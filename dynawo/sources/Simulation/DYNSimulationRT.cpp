//
// Copyright (c) 2024, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNSimulationRT.cpp
 *
 * @brief RT Simulation implementation
 *
 */

#include <iomanip>
#include <vector>
#include <map>
#include <cstdlib>
#include <sstream>
#include <fstream>
#include <thread>
#ifdef _MSC_VER
#include <process.h>
#endif


#include "TLTimelineFactory.h"

#include "CRVCurvesCollectionFactory.h"
#include "CRVCurveFactory.h"
#include "CRVPoint.h"

#include "FSVFinalStateValuesCollectionFactory.h"
#include "FSVFinalStateValuesCollection.h"

#include "CSTRConstraintsCollectionFactory.h"

#include "LEQLostEquipmentsCollectionFactory.h"

#include "JOBJobEntry.h"
#include "JOBCurvesEntry.h"

#include "PARParametersSetFactory.h"

#include "DYNModel.h"
#include "DYNSimulationRT.h"
#include "DYNTrace.h"
#include "DYNSolver.h"
#include "DYNTimer.h"
#include "DYNModelMulti.h"
#include "DYNSubModel.h"
#include "DYNZmqPublisher.h"

using std::ofstream;
using std::fstream;
using std::string;
using std::vector;
using std::stringstream;
using std::map;
using std::setw;
using std::shared_ptr;
using std::dynamic_pointer_cast;
namespace fs = boost::filesystem;

using timeline::TimelineFactory;

using curves::CurvesCollection;
using curves::CurvesCollectionFactory;

using finalStateValues::FinalStateValuesCollection;
using finalStateValues::FinalStateValuesCollectionFactory;

using constraints::ConstraintsCollectionFactory;

using lostEquipments::LostEquipmentsCollectionFactory;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

using std::chrono::system_clock;
using std::chrono::microseconds;
using std::chrono::duration_cast;

static const char TIME_FILENAME[] = "time.bin";  ///< name of the file to dump time at the end of the simulation

namespace DYN {

SimulationRT::SimulationRT(const std::shared_ptr<job::JobEntry>& jobEntry, const std::shared_ptr<SimulationContext>& context, boost::shared_ptr<DataInterface> data = boost::shared_ptr<DataInterface>()) :
Simulation(jobEntry, context, data) {
  if (jobEntry_->getSimulationEntry()->getPublishToZmq()) {
    stepPublisher_ = std::make_shared<ZmqPublisher>();
    std::cout << "ZMQ publisher server started" << std::endl;
  }
  if (jobEntry_->getSimulationEntry()->getTimeSync()) {
    timeManager_ = std::make_shared<TimeManager>(
      jobEntry_->getSimulationEntry()->getTimeSyncAcceleration());
  }
  bool subscribeActions = jobEntry_->getSimulationEntry()->getEventSubscriberActions();
  bool subscribeTrigger = jobEntry_->getSimulationEntry()->getEventSubscriberTrigger();
  std::cout << "subcribe trigger:  " << subscribeTrigger << " , actions: " << subscribeActions << std::endl;
  if (subscribeActions || subscribeTrigger) {
    triggerSimulationTimeStepInS_ = jobEntry_->getSimulationEntry()->getTriggerSimulationTimeStepInS();
    eventSubscriber_ = std::make_shared<EventSubscriber>(subscribeTrigger, subscribeActions);
  }
  if (jobEntry_->getSimulationEntry()->getPublishToWebsocket()) {
    wsServer_ = std::make_shared<wsc::WebsocketServer>();
    wsServer_->run(9001);
    std::cout << "Websocket server started" << std::endl;
  }
}

void
SimulationRT::simulate() {
  Timer timer("SimulationRT::simulate()");
  if (eventSubscriber_) {
    eventSubscriber_->setModel(model_);
    eventSubscriber_->start();
  }

  printSolverHeader();

  // Printing out the initial solution
  solver_->printSolve();
  if (exportCurvesMode_ != EXPORT_CURVES_NONE) {
    // This is a workaround to update the calculated variables with initial values of y and yp as they are not accessible at this level
    model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);
  }
  const bool updateCalculatedVariable = false;
  initComputationTimeCurve();
  updateCurves(updateCalculatedVariable);  // initial curves

  bool criteriaChecked = true;
  try {
    // update state variable only if the IIDM final state is exported, or criteria is checked, or lost equipments are exported
    if (data_ && (finalState_.iidmFile_ || activateCriteria_ || isLostEquipmentsExported())) {
      data_->getStateVariableReference();   // Each state variable in DataInterface has a mapped reference variable in dynamic model,
                                         // either in a modelica model or in a C++ model.
      // save initial connection state at t0 for each equipment
      if (isLostEquipmentsExported()) {
        data_->updateFromModel(false);  // force state variables' init
        connectedComponents_ = data_->findConnectedComponents();
      }
    }

    std::shared_ptr<job::CurvesEntry> curvesEntry = jobEntry_->getOutputsEntry()->getCurvesEntry();
    boost::optional<int> iterationStep;
    boost::optional<double> timeStep;
    if (curvesEntry != nullptr) {
      iterationStep = curvesEntry->getIterationStep();
      timeStep = curvesEntry->getTimeStep();
    }
    int currentIterNb = 0;
    double nextTimeStep = 0;

    if (timeManager_)
      timeManager_->start(tCurrent_);


    double nextTToTrigger = tCurrent_ + triggerSimulationTimeStepInS_;  // Only used if (eventSubscriber_ && eventSubscriber_->triggerEnabled())

    while (!end() && !SignalHandler::gotExitSignal() && criteriaChecked) {
      // option1: ZMQ --> wait for an empty message before simulating next time step
      if (eventSubscriber_ && eventSubscriber_->triggerEnabled() && tCurrent_ >= nextTToTrigger) {
        nextTToTrigger += triggerSimulationTimeStepInS_;
        eventSubscriber_->wait();
      }

      // option2: TimeManager --> sleep in the loop
      if (timeManager_) {
        timeManager_->wait(tCurrent_);
      }

      updateStepStart();

      // Apply actions from event subscriber
      if (eventSubscriber_ && eventSubscriber_->actionsEnabled())
        eventSubscriber_->applyActions();

      double elapsed = timer.elapsed();
      double timeout = jobEntry_->getSimulationEntry()->getTimeout();
      if (elapsed > timeout) {
        Trace::warn() << DYNLog(SimulationTimeoutReached, jobEntry_->getName(), timeout) << Trace::endline;
        endSimulationWithError(false);
        return;
      }

      bool isCheckCriteriaIter = data_ && activateCriteria_ && currentIterNb % criteriaStep_ == 0;

      solver_->solve(tStop_, tCurrent_);
      solver_->printSolve();
      if (currentIterNb == 0)
        printHighestDerivativesValues();

      BitMask solverState = solver_->getState();
      bool modifZ = false;
      if (solverState.getFlags(ModeChange)) {
        // if (timeManager_)
        //   Trace::info() << "TimeManagement (ModeChange): tCurrent_ = " << tCurrent_
        //   << " s; Partial step computation time: " << timeManager_->getStepDuration() << "ms" << Trace::endline;
        // updateCurves(true);
        model_->notifyTimeStep();
        Trace::info() << DYNLog(NewStartPoint) << Trace::endline;
        solver_->reinit();
        model_->getCurrentZ(zCurrent_);
        solver_->printSolve();
        printHighestDerivativesValues();
       } else if (solverState.getFlags(NotSilentZChange)
          || solverState.getFlags(SilentZNotUsedInDiscreteEqChange)
          || solverState.getFlags(SilentZNotUsedInContinuousEqChange)) {
        // updateCurves(true);
        // if (timeManager_)
        //   Trace::info() << "TimeManagement (SilentZish): tCurrent_ = " << tCurrent_
        //   << " s; Partial step computation time: " << timeManager_->getStepDuration() << "ms" << Trace::endline;
        model_->getCurrentZ(zCurrent_);
        modifZ = true;
      }

      if (isCheckCriteriaIter)
        model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);

      // if (iterationStep) {
      //   if (currentIterNb % *iterationStep == 0) {
      //     updateCurves(!isCheckCriteriaIter && !modifZ);
      //   }
      // } else if (timeStep) {
      //   if (tCurrent_ >= nextTimeStep) {
      //     nextTimeStep = tCurrent_ + *timeStep;
      //     updateCurves(!isCheckCriteriaIter && !modifZ);
      //   }
      // } else {
      //   updateCurves(!isCheckCriteriaIter && !modifZ);
      // }

      model_->checkDataCoherence(tCurrent_);
      model_->printMessages();
      if (timetableOutputFile_ != "" && currentIterNb % timetableSteps_ == 0)
        printCurrentTime(timetableOutputFile_);

      if (isCheckCriteriaIter) {
        criteriaChecked = checkCriteria(tCurrent_, false);
      }
      ++currentIterNb;

      model_->notifyTimeStep();

      if (hasIntermediateStateToDump() && !isCheckCriteriaIter) {
        // In case it was not already done beause of check criteria and intermediate state dump will be done at least one for current
        // iteration
        model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);
      }
      while (hasIntermediateStateToDump()) {
        const ExportStateDefinition& dumpDefinition = intermediateStates_.front();
        data_->exportStateVariables();
        if (dumpDefinition.dumpFile_) {
          dumpState(*dumpDefinition.dumpFile_);
        }
        if (dumpDefinition.iidmFile_) {
          dumpIIDMFile(*dumpDefinition.iidmFile_);
        }
        intermediateStates_.pop();
      }

      // if (timeManager_) {
      //   timeManager_->updateStepDurationValue();
      //   Trace::info() << "TimeManagement: tCurrent_ = " << tCurrent_
      //   << " s; Step computation time: " << timeManager_->getStepDuration() << "ms" << Trace::endline;
      // }

      // Set up step times
      updateStepComputationTime();
      updateCurves(true);

      // Publish values
      if ((wsServer_ || stepPublisher_) && (!eventSubscriber_->triggerEnabled() || tCurrent_ >= nextTToTrigger)) {
        string formatedString;
        curvesToJson(formatedString);
        if (wsServer_) {
          wsServer_->sendMessage(formatedString);
          Trace::info() << "data published to websocket" << Trace::endline;
        }
        if (stepPublisher_) {
          stepPublisher_->sendMessage(formatedString);
          Trace::info() << "data published to ZMQ" << Trace::endline;
        }
      }
    }

    // If we haven't evaluated the calculated variables for the last iteration before, we must do it here if it might be used in the post process
    if (finalState_.iidmFile_ || exportCurvesMode_ != EXPORT_CURVES_NONE || activateCriteria_)
      model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);

    if (SignalHandler::gotExitSignal() && !end()) {
      if (timeline_) {
        addEvent(DYNTimeline(SignalReceived));
      }
      throw DYNError(Error::GENERAL, SignalReceived);
    } else if (!criteriaChecked) {
      if (timeline_) {
        addEvent(DYNTimeline(CriteriaNotChecked));
      }
      throw DYNError(Error::SIMULATION, CriteriaNotChecked);
    } else if (end() && data_ && activateCriteria_) {
      criteriaChecked = checkCriteria(tCurrent_, true);
      if (!criteriaChecked) {
        if (timeline_) {
          addEvent(DYNTimeline(CriteriaNotChecked));
        }
        throw DYNError(Error::SIMULATION, CriteriaNotChecked);
      }
    }
    if (timetableOutputFile_ != "")
        remove(timetableOutputFile_);
  } catch (const Terminate& t) {
    Trace::warn() << t.what() << Trace::endline;
    model_->printMessages();
    endSimulationWithError(criteriaChecked);
  } catch (const Error& e) {
    Trace::error() << e.what() << Trace::endline;
    bool staticModelWellInitialized = true;
    if (e.key() == DYN::KeyError_t::StateVariableNoReference)
      staticModelWellInitialized = false;
    if (e.type() == DYN::Error::SOLVER_ALGO ||
        e.type() == DYN::Error::SUNDIALS_ERROR ||
        e.type() == DYN::Error::NUMERICAL_ERROR) {
      endSimulationWithError(criteriaChecked && staticModelWellInitialized, true);
    } else {
      endSimulationWithError(criteriaChecked && staticModelWellInitialized);
    }
    throw;
  } catch (...) {
    endSimulationWithError(criteriaChecked);
    throw;
  }
}

void
SimulationRT::updateStepStart() {
  stepStart_ = system_clock::now();
}

void
SimulationRT::updateStepComputationTime() {
  stepComputationTime_ = (1./1000)*(duration_cast<microseconds>(system_clock::now() - stepStart_)).count();
}


void
SimulationRT::curvesToJson(string& jsonCurves) {
  stringstream stream;
  double time = -1;
  stream << "{\n\t\"curves\": {\n";
  stream << "\t\t" << "\"values\": {\n";
  for (CurvesCollection::iterator itCurve = curvesCollection_->begin();
        itCurve != curvesCollection_->end();
        ++itCurve) {
    if ((*itCurve)->getAvailable()) {
      std::shared_ptr<curves::Point> point = (*itCurve)->getLastPoint();
      if (point) {
        if (time < 0) {
          time = point->getTime();
          stream << "\n";
        } else {
          stream << ",\n";
        }
        string curveName =  (*itCurve)->getModelName() + "_" + (*itCurve)->getVariable();
        double value = point->getValue();
        stream << "\t\t\t" << "\"" << curveName << "\": " << point->getValue();
      }
    }
  }
  stream << "\n\t\t" << "},\n";
  // if (timeManager_)
  //   stream << "\t\t" << "\"stepdurationms\": " << timeManager_->getStepDuration() << ",\n";
  stream << "\t\t" << "\"time\": " << time << "\n";
  stream << "\t}\n}";

  jsonCurves = stream.str();
}


void
SimulationRT::initComputationTimeCurve() {
  shared_ptr<curves::Curve> curve = curves::CurveFactory::newCurve();
  curve->setModelName("Simulation");
  curve->setVariable("stepDurationMs");
  curve->setAvailable(true);
  curve->setBuffer(&stepComputationTime_);
  curvesCollection_->add(curve);
}

void
SimulationRT::terminate() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::terminate()");
#endif
  if (wsServer_)
    wsServer_->stop();

  if (eventSubscriber_)
    eventSubscriber_->stop();
  updateParametersValues();   // update parameter curves' value

  if (curvesOutputFile_ != "") {
    ofstream fileCurves;
    openFileStream(fileCurves, curvesOutputFile_);
    printCurves(fileCurves);
    fileCurves.close();
  }

  if (finalStateValuesOutputFile_ != "") {
    ofstream fileFinalStateValues;
    openFileStream(fileFinalStateValues, finalStateValuesOutputFile_);
    printFinalStateValues(fileFinalStateValues);
    fileFinalStateValues.close();
  }

  if (timelineOutputFile_ != "") {
    ofstream fileTimeline;
    openFileStream(fileTimeline, timelineOutputFile_);
    printTimeline(fileTimeline);
    fileTimeline.close();
  }

  if (constraintsOutputFile_ != "") {
    ofstream fileConstraints;
    openFileStream(fileConstraints, constraintsOutputFile_);
    printConstraints(fileConstraints);
    fileConstraints.close();
  }

  if (dumpFinalValues_) {
    string finalValuesDir = createAbsolutePath("finalValues", outputsDirectory_);
    if (!exists(finalValuesDir))
      create_directory(finalValuesDir);
    model_->printModelValues(finalValuesDir, "dumpFinalValues");
  }

  if (data_ && (finalState_.iidmFile_ || isLostEquipmentsExported())) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
    Timer timer2("DataInterfaceIIDM::exportStateVariables");
#endif
    data_->exportStateVariables();
  }

  if (data_ && isLostEquipmentsExported() && lostEquipmentsOutputFile_ != "") {
    ofstream fileLostEquipments;
    openFileStream(fileLostEquipments, lostEquipmentsOutputFile_);
    printLostEquipments(fileLostEquipments);
    fileLostEquipments.close();
  }

  if (finalState_.dumpFile_)
    dumpState();

  if (finalState_.iidmFile_)
    dumpIIDMFile();

  printEnd();
  if (wasLoggingEnabled_ && !Trace::isLoggingEnabled()) {
    // re-enable logging for upper project
    Trace::enableLogging();
  }
}

}  // end of namespace DYN
