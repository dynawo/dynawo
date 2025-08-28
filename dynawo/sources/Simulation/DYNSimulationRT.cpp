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
#include "TLTimeline.h"
#include "TLJsonExporter.h"

#include "CRVCurvesCollectionFactory.h"
#include "CRVCurveFactory.h"
#include "CRVPoint.h"

#include "FSVFinalStateValuesCollectionFactory.h"
#include "FSVFinalStateValuesCollection.h"

#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRJsonExporter.h"

#include "LEQLostEquipmentsCollectionFactory.h"

#include "JOBJobEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBInteractiveSettingsEntry.h"
#include "JOBClockEntry.h"
#include "JOBChannelEntry.h"
#include "JOBStreamEntry.h"

#include "PARParametersSetFactory.h"

#include "DYNModel.h"
#include "DYNSimulationRT.h"
#include "DYNTrace.h"
#include "DYNSolver.h"
#include "DYNTimer.h"
#include "DYNModelMulti.h"
#include "DYNSubModel.h"
#include "DYNZmqPublisher.h"
#include "DYNZmqInput.h"
#include "DYNZmqOutput.h"
#include "DYNRTInputCommon.h"

using std::ofstream;
using std::fstream;
using std::string;
using std::vector;
using std::stringstream;
using std::ostringstream;
using std::map;
using std::setw;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;
namespace fs = boost::filesystem;

using timeline::TimelineFactory;
using timeline::Timeline;
// using timeline::JsonExporter;

using curves::CurvesCollection;
using curves::CurvesCollectionFactory;

using finalStateValues::FinalStateValuesCollection;
using finalStateValues::FinalStateValuesCollectionFactory;

using constraints::ConstraintsCollectionFactory;
// using constraints::JsonExporter;

using lostEquipments::LostEquipmentsCollectionFactory;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

using std::chrono::system_clock;
using std::chrono::microseconds;
using std::chrono::duration_cast;

static const char TIME_FILENAME[] = "time.bin";  ///< name of the file to dump time at the end of the simulation

namespace DYN {

SimulationRT::SimulationRT(const std::shared_ptr<job::JobEntry>& jobEntry, const std::shared_ptr<SimulationContext>& context, shared_ptr<DataInterface> data) :
Simulation(jobEntry, context, data) {
  configureRT();
}

void
SimulationRT::configureRT() {
  if (!jobEntry_->getInteractiveSettingsEntry())
    throw DYNError(DYN::Error::API, MissingInteractiveSettings);

  std::shared_ptr<job::ChannelsEntry> channelsEntry = jobEntry_->getInteractiveSettingsEntry()->getChannelsEntry();
  std::shared_ptr<job::ClockEntry> clockEntry = jobEntry_->getInteractiveSettingsEntry()->getClockEntry();

  // initialize interactive simulation managing objects
  clock_ = std::make_shared<Clock>();
  actionBuffer_ = std::make_shared<ActionBuffer>();
  outputDispatcher_ = std::make_shared<OutputDispatcher>();
  inputDispatcherAsync_ = std::make_shared<InputDispatcherAsync>(actionBuffer_, clock_);

  std::cout << "objects initialized" << std::endl;
  // Clock settings
  if (clockEntry->getType() == "INTERNAL") {
    clock_->setUseTrigger(false);
    if (clockEntry->getSpeedup())
      clock_->setSpeedup(clockEntry->getSpeedup().get());
  } else {
    clock_->setUseTrigger(true);
    std::shared_ptr<job::ChannelEntry> triggerChannelEntry = channelsEntry->getChannelEntryById(clockEntry->getTriggerChannel());
    if (!triggerChannelEntry)
      throw DYNError(Error::API, UnknownChannelId, clockEntry->getTriggerChannel());
  }

  // Output dispatcher settings
  std::map<std::string, std::shared_ptr<OutputInterface> > channelInterfaceMap;
  for (auto &streamEntry : jobEntry_->getInteractiveSettingsEntry()->getStreamsEntry()->getStreamEntries()) {
    std::map<std::string, std::shared_ptr<OutputInterface> >::iterator channelInterfaceMapIt = channelInterfaceMap.find(streamEntry->getChannel());
    std::shared_ptr<OutputInterface> outputInterface;
    if (channelInterfaceMapIt == channelInterfaceMap.end()) {
      // Create new OutputInterface
      std::shared_ptr<job::ChannelEntry> channelEntry = channelsEntry->getChannelEntryById(streamEntry->getChannel());
      if (channelEntry->getType() == "ZMQ") {
        std::cout << "creating ZMQ channel " << channelEntry->getId() << std::endl;
        // outputInterface = std::make_shared<ZmqOutput>(channelEntry->getEndpoint());
        outputInterface = std::make_shared<ZmqOutput>();
        channelInterfaceMap.emplace(channelEntry->getId(), outputInterface);
        std::cout << "ZMQ channel created" << channelEntry->getId() << std::endl;
      } else {
        Trace::warn() << "Unsupported output Channel type: " << channelEntry->getType() << Trace::endline;
        continue;
      }
    } else {
      outputInterface = channelInterfaceMapIt->second;
    }
    std::cout << "outputInterface created" << std::endl;

    if (streamEntry->getData() == "CURVES") {
      outputDispatcher_->addCurvesPublisher(outputInterface, streamEntry->getFormat());
    } else if (streamEntry->getData() == "TIMELINE") {
      outputDispatcher_->addTimelinePublisher(outputInterface, streamEntry->getFormat());
    } else if (streamEntry->getData() == "CONSTRAINTS") {
      outputDispatcher_->addConstraintsPublisher(outputInterface, streamEntry->getFormat());
    } else {
      Trace::warn() << "Stream data unknown or not managed: " << streamEntry->getData() << Trace::endline;;
    }
  }
  std::cout << "output dispatcher set up" << std::endl;

  // intialize input channels
  for (auto &channelEntry : channelsEntry->getChannelEntries()) {
    if (channelEntry->getKind() == "OUTPUT") {
      if (channelInterfaceMap.find(channelEntry->getId()) == channelInterfaceMap.end())
        Trace::warn() << "Output channel '" << channelEntry->getId() << "' not used by a stream, not instanciated" << Trace::endline;
    } else {  // INPUT
      // Input dispatcher settings
      bool isTriggerChannel = (clock_->getUseTrigger() &&
      clockEntry->getTriggerChannel() == channelEntry->getId());
      if (channelEntry->getType() == "ZMQ") {
        MessageFilter filter = MessageFilter::Actions | MessageFilter::TimeManagement;
        if (isTriggerChannel)
          filter = filter | MessageFilter::Trigger;
        std::shared_ptr<InputInterface> zmqServer = std::make_shared<ZmqInput>("zmq", filter);
        inputDispatcherAsync_->addReceiver(zmqServer);
      } else {
        Trace::warn() << "Unknown channel type: " << channelEntry->getType() << Trace::endline;
      }
    }
  }
  std::cout << "channel initialized" << std::endl;

  // if (jobEntry_->getSimulationEntry()->getPublishToWebsocket()) {
  //   wsServer_ = std::make_shared<wsc::WebsocketServer>();
  //   wsServer_->run(9001);
  //   std::cout << "Websocket server started" << std::endl;
  // }

  // Workaround to avoid saving value for each curve:
  //  - Set all curves as EXPORT_AS_FINAL_STATE_VALUE --> will keep only one Point corresponding to last value
  //  - Disable export of curves and final state values
  std::cout << "Real time mode: disabling all curves recording (jobs-with-curves won't work!)" << std::endl;
  for (auto &curve : curvesCollection_->getCurves()) {
    curve->setExportType(curves::Curve::EXPORT_AS_FINAL_STATE_VALUE);
  }
  exportCurvesMode_ = EXPORT_CURVES_NONE;
  exportFinalStateValuesMode_ = EXPORT_FINAL_STATE_VALUES_NONE;
  // Add simulation time to curves
  bool sendSimulationMetrics_ = true;   // TODO(thibaut) add jobs property
  if (sendSimulationMetrics_)
    initComputationTimeCurve();
  // valuesBuffer_.reserve((curvesCollection_->getCurves().size() + 1) * sizeof(double));

  std::cout << "configureRT au bout" << std::endl;
}

void
SimulationRT::updateCurves(bool updateCalculateVariable) const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SimulationRT::updateCurves()");
#endif
  // if (exportCurvesMode_ == EXPORT_CURVES_NONE && exportFinalStateValuesMode_ == EXPORT_FINAL_STATE_VALUES_NONE)
  //   return;

  if (updateCalculateVariable)
    model_->updateCalculatedVarForCurves();

  curvesCollection_->updateCurves(tCurrent_);
}


void
SimulationRT::simulate() {
  std::cout << "---- simulate ----" << std::endl;

  Timer timer("SimulationRT::simulate()");
  if (actionBuffer_)
    actionBuffer_->setModel(model_);

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

  if (outputDispatcher_)
    outputDispatcher_->initPublishCurves(curvesCollection_);
  // if (stepPublisher_ && !jobEntry_->getSimulationEntry()->getPublishToZmqCurvesFormat().compare("BYTES")) {
  //   string formatedCurvesNames = curvesNamesToCsv();
  //   stepPublisher_->sendMessage(formatedCurvesNames, "curves_names");
  // }

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
    // double nextTimeStep = 0;

    inputDispatcherAsync_->start();

    clock_->start(tCurrent_);

    // double nextTToTrigger = tCurrent_ + triggerSimulationTimeStepInS_;  // Only used if (eventSubscriber_ && eventSubscriber_->triggerEnabled())
    double nextOutputT = tCurrent_;  // Publish first time step
    // double lastPublicationTime = -1;
    bool isPublicationTime = false;
    bool isWaitTime = false;
    while (!end() && !clock_->getStopMessageReceived() && !SignalHandler::gotExitSignal() && criteriaChecked) {
      // If simulated time corresponds to a completed period, publish the results at the end of the step, then wait before applying the actions
      if (tCurrent_ >= nextOutputT) {
        isPublicationTime = true;
        nextOutputT += communicationPeriod_;
      }

      if (isWaitTime) {
        clock_->wait(tCurrent_);
        updateStepStart();
        actionBuffer_->applyActions();
        isWaitTime = false;
      }

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
      // bool modifZ = false;
      if (solverState.getFlags(ModeChange)) {
        // if (clock_)
        //   Trace::info() << "TimeManagement (ModeChange): tCurrent_ = " << tCurrent_
        //   << " s; Partial step computation time: " << clock_->getStepDuration() << "ms" << Trace::endline;
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
        // if (clock_)
        //   Trace::info() << "TimeManagement (SilentZish): tCurrent_ = " << tCurrent_
        //   << " s; Partial step computation time: " << clock_->getStepDuration() << "ms" << Trace::endline;
        model_->getCurrentZ(zCurrent_);
        // modifZ = true;
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

      // Set up step times
      updateStepComputationTime();
      updateCurves(true);

      // Publish values
      if (isPublicationTime) {
        outputDispatcher_->publishCurves(curvesCollection_);
        outputDispatcher_->publishTimeline(timeline_);
        outputDispatcher_->publishConstraints(constraintsCollection_);
        timeline_->clear();
        constraintsCollection_->clear();
        isPublicationTime = false;
        isWaitTime = true;
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
SimulationRT::initComputationTimeCurve() {
  std::shared_ptr<curves::Curve> curve = curves::CurveFactory::newCurve();
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
  std::cout << "SimulationRT::terminate" << std::endl;
  // if (wsServer_)
  //   wsServer_->stop();

  // if (inputDispatcherAsync_)
  //   inputDispatcherAsync_->stop();

  // if (eventSubscriber_)
  //   eventSubscriber_->stop();
  // updateParametersValues();   // update parameter curves' value

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
      createDirectory(finalValuesDir);
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
