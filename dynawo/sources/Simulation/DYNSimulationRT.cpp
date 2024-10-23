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


// #include <boost/archive/binary_iarchive.hpp>
// #include <boost/archive/binary_oarchive.hpp>
// #include <boost/serialization/vector.hpp>
// #include <boost/filesystem.hpp>
// #include <boost/algorithm/string/classification.hpp>
// #include <boost/algorithm/string/split.hpp>

// #include <libzip/ZipFile.h>
// #include <libzip/ZipFileFactory.h>
// #include <libzip/ZipEntry.h>
// #include <libzip/ZipInputStream.h>
// #include <libzip/ZipOutputStream.h>

#include "TLTimelineFactory.h"
// #include "TLTimeline.h"
// #include "TLTxtExporter.h"
// #include "TLXmlExporter.h"
// #include "TLCsvExporter.h"

#include "CRVCurvesCollectionFactory.h"
// #include "CRVCurvesCollection.h"
// #include "CRVXmlImporter.h"
// #include "CRVCurveFactory.h"
// #include "CRVCurve.h"
#include "CRVPoint.h"
// #include "CRVXmlExporter.h"
// #include "CRVCsvExporter.h"

#include "FSVFinalStateValuesCollectionFactory.h"
#include "FSVFinalStateValuesCollection.h"
// #include "FSVFinalStateValue.h"
// #include "FSVFinalStateValueFactory.h"
// #include "FSVXmlExporter.h"
// #include "FSVXmlImporter.h"
// #include "FSVCsvExporter.h"
// #include "FSVTxtExporter.h"

// #include "CSTRConstraintsCollection.h"
#include "CSTRConstraintsCollectionFactory.h"
// #include "CSTRTxtExporter.h"
// #include "CSTRXmlExporter.h"

#include "LEQLostEquipmentsCollectionFactory.h"
// #include "LEQXmlExporter.h"

// #include "PARParametersSet.h"
// #include "PARXmlImporter.h"

// #include "CRTXmlImporter.h"
// #include "CRTCriteriaCollection.h"

#include "JOBJobEntry.h"
// #include "JOBSolverEntry.h"
// #include "JOBModelerEntry.h"
// #include "JOBModelsDirEntry.h"
// #include "JOBOutputsEntry.h"
// #include "JOBNetworkEntry.h"
// #include "JOBInitialStateEntry.h"
// #include "JOBInitValuesEntry.h"
// #include "JOBConstraintsEntry.h"
// #include "JOBTimelineEntry.h"
// #include "JOBTimetableEntry.h"
// #include "JOBFinalStateEntry.h"
#include "JOBCurvesEntry.h"
// #include "JOBSimulationEntry.h"
// #include "JOBLogsEntry.h"
// #include "JOBAppenderEntry.h"
// #include "JOBDynModelsEntry.h"

// #include "DYNCompiler.h"
// #include "DYNDynamicData.h"
#include "DYNModel.h"
#include "DYNSimulationRT.h"
// #include "DYNSimulationContext.h"
#include "DYNTrace.h"
// #include "DYNMacrosMessage.h"
#include "DYNSolver.h"
// #include "DYNSolverFactory.h"
#include "DYNTimer.h"
// #include "DYNModelMulti.h"
// #include "DYNModeler.h"
// #include "DYNFileSystemUtils.h"
// #include "DYNTerminate.h"
// #include "DYNDataInterface.h"
// #include "DYNDataInterfaceFactory.h"
// #include "DYNExecUtils.h"
// #include "DYNSignalHandler.h"
// #include "DYNIoDico.h"
// #include "DYNBitMask.h"

using std::ofstream;
using std::fstream;
using std::string;
using std::vector;
using std::stringstream;
using std::map;
using std::setw;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;

namespace fs = boost::filesystem;

using timeline::TimelineFactory;

using curves::CurvesCollection;
using curves::CurvesCollectionFactory;

using finalStateValues::FinalStateValuesCollection;
using finalStateValues::FinalStateValuesCollectionFactory;

using constraints::ConstraintsCollectionFactory;

using lostEquipments::LostEquipmentsCollectionFactory;

using parameters::ParametersSet;
using parameters::ParametersSetCollection;

static const char TIME_FILENAME[] = "time.bin";  ///< name of the file to dump time at the end of the simulation

namespace DYN {

SimulationRT::SimulationRT(shared_ptr<job::JobEntry>& jobEntry, shared_ptr<SimulationContext>& context, shared_ptr<DataInterface> data) :
Simulation(jobEntry, context, data),
timeSync_(false),
timeSyncAcceleration_(10.) {
  setTimeSync(jobEntry_->getSimulationEntry()->getTimeSync());
  setTimeSyncAcceleration(jobEntry_->getSimulationEntry()->getTimeSyncAcceleration());
  wsServer_ = boost::make_shared<wsc::WebsocketServer>();
  std::cout << "will run server" << std::endl;
  wsServer_->run(9001);
  std::cout << "run server ok" << std::endl;
}

void
SimulationRT::simulate() {
  Timer timer("SimulationRT::simulate()");
  printSolverHeader();

  // Printing out the initial solution
  solver_->printSolve();
  if (exportCurvesMode_ != EXPORT_CURVES_NONE) {
    // This is a workaround to update the calculated variables with initial values of y and yp as they are not accessible at this level
    model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);
  }
  const bool updateCalculatedVariable = false;
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

    boost::shared_ptr<job::CurvesEntry> curvesEntry = jobEntry_->getOutputsEntry()->getCurvesEntry();
    boost::optional<int> iterationStep;
    boost::optional<double> timeStep;
    if (curvesEntry != nullptr) {
      iterationStep = curvesEntry->getIterationStep();
      timeStep = curvesEntry->getTimeStep();
    }
    int currentIterNb = 0;
    double nextTimeStep = 0;
    const auto startTimeSync = std::chrono::system_clock::now();
    std::chrono::time_point<std::chrono::system_clock> afterSleepTime;
    while (!end() && !SignalHandler::gotExitSignal() && criteriaChecked) {
      // RT sleep
      // std::chrono::time_point<std::chrono::system_clock> tCurrentSync = startTimeSync + std::chrono::seconds(tCurrent_/timeSyncAcceleration_);
      if (timeSync_) {
        std::this_thread::sleep_until(startTimeSync + std::chrono::milliseconds(static_cast<int>(1000*tCurrent_/timeSyncAcceleration_)));
        afterSleepTime = std::chrono::system_clock::now();
        Trace::warn() << "TITI tCurrent_ = " << tCurrent_  << " s; "
        << "RT now: " << (std::chrono::duration_cast<std::chrono::milliseconds>(afterSleepTime - startTimeSync)).count()/1000.  << " s; "
        << Trace::endline;
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
      bool modifZ = false;
      if (solverState.getFlags(ModeChange)) {
        updateCurves(true);
        model_->notifyTimeStep();
        Trace::info() << DYNLog(NewStartPoint) << Trace::endline;
        solver_->reinit();
        model_->getCurrentZ(zCurrent_);
        solver_->printSolve();
        printHighestDerivativesValues();
      } else if (solverState.getFlags(NotSilentZChange)
          || solverState.getFlags(SilentZNotUsedInDiscreteEqChange)
          || solverState.getFlags(SilentZNotUsedInContinuousEqChange)) {
        updateCurves(true);
        model_->getCurrentZ(zCurrent_);
        modifZ = true;
      }

      if (isCheckCriteriaIter)
        model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);

      if (iterationStep) {
        if (currentIterNb % *iterationStep == 0) {
          updateCurves(!isCheckCriteriaIter && !modifZ);
        }
      } else if (timeStep) {
        if (tCurrent_ >= nextTimeStep) {
          nextTimeStep = tCurrent_ + *timeStep;
          updateCurves(!isCheckCriteriaIter && !modifZ);
        }
      } else {
        updateCurves(!isCheckCriteriaIter && !modifZ);
      }

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
      if (timeSync_) {
        const auto afterStepTime = std::chrono::system_clock::now();
        Trace::warn() << "TITI tCurrent_ = " << tCurrent_  << " s; "
        << "step computation time: " << (std::chrono::duration_cast<std::chrono::milliseconds>(afterStepTime - afterSleepTime)).count() << " ms"
        << Trace::endline;
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
SimulationRT::curvesToStream() {
  stringstream stream;
  double time = -1;
  stream << "{\n\t\"curves\": {\n";
  stream << "\t\t" << "\"values\": {\n";
  for (CurvesCollection::iterator itCurve = curvesCollection_->begin();
        itCurve != curvesCollection_->end();
        ++itCurve) {
    if ((*itCurve)->getAvailable()) {
      boost::shared_ptr<curves::Point> point = (*itCurve)->getLastPoint();
      if (point) {
        if (time < 0) {
          time = point->getTime();
          stream << "\n";
        }
        else
          stream << ",\n";
        string curveName =  (*itCurve)->getModelName() + "_" + (*itCurve)->getVariable();
        double value = point->getValue();
        stream << "\t\t\t" << "\"" << curveName << "\": " << point->getValue();
      }
    }
  }
  stream << "\t\t" << "},\n";
  stream << "\t\t" << "\"time\": " << time << "\n";
  stream << "\t}\n}";

  const string formatedString = stream.str();
  if (wsServer_) {
    wsServer_->sendMessage(formatedString);
    Trace::info() << "sent message: \n" << formatedString << Trace::endline;
    // std::cout << "sent message: \n" << formatedString << std::endl;
  }
  // Trace::warn() << formatedString << Trace::endline;
}

void
SimulationRT::updateCurves(bool updateCalculateVariable) {
  if (exportCurvesMode_ == EXPORT_CURVES_NONE && exportFinalStateValuesMode_ == EXPORT_FINAL_STATE_VALUES_NONE)
    return;
  Simulation::updateCurves(updateCalculateVariable);
  curvesToStream();
}


void
SimulationRT::terminate() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::terminate()");
#endif
  if (wsServer_)
    wsServer_->stop();

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

// void
// SimulationRT::runWebsocketServer() {
//   wsServer_->run(9001);
// }

}  // end of namespace DYN
