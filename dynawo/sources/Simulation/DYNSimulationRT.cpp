//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
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
#include "DYNRTInputCommon.h"

#ifdef USE_ZMQPP
#include "DYNZmqInputChannel.h"
#include "DYNZmqOutputChannel.h"
#endif

#include "make_unique.hpp"

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

using curves::CurvesCollection;
using curves::CurvesCollectionFactory;

using finalStateValues::FinalStateValuesCollection;
using finalStateValues::FinalStateValuesCollectionFactory;

using constraints::ConstraintsCollectionFactory;

using lostEquipments::LostEquipmentsCollectionFactory;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

using std::chrono::steady_clock;
using std::chrono::microseconds;
using std::chrono::duration_cast;

namespace DYN {

SimulationRT::SimulationRT(const std::shared_ptr<job::JobEntry>& jobEntry, const std::shared_ptr<SimulationContext>& context, shared_ptr<DataInterface> data) :
Simulation(jobEntry, context, data) {
  configureRT();
}

void
SimulationRT::configureRT() {
  if (!jobEntry_->getInteractiveSettingsEntry())
    throw DYNError(Error::API, MissingInteractiveSettings);

  std::shared_ptr<job::ChannelsEntry> channelsEntry = jobEntry_->getInteractiveSettingsEntry()->getChannelsEntry();
  std::shared_ptr<job::ClockEntry> clockEntry = jobEntry_->getInteractiveSettingsEntry()->getClockEntry();

  // initialize interactive simulation managing objects
  clock_ = std::make_shared<Clock>();
  actionBuffer_ = std::make_shared<ActionBuffer>();
  outputDispatcher_ = std::make_shared<OutputDispatcher>();
  inputDispatcherAsync_ = std::make_shared<InputDispatcherAsync>(clock_);

  couplingTimeStep_ = jobEntry_->getInteractiveSettingsEntry()->getCouplingTimeStep() < 0 ? 0 : jobEntry_->getInteractiveSettingsEntry()->getCouplingTimeStep();

  configureClock();
  configureOutputsRT();
  configureInputsRT();
  configureCurvesRT();
}

void
SimulationRT::configureClock() {
  std::shared_ptr<job::ChannelsEntry> channelsEntry = jobEntry_->getInteractiveSettingsEntry()->getChannelsEntry();
  std::shared_ptr<job::ClockEntry> clockEntry = jobEntry_->getInteractiveSettingsEntry()->getClockEntry();

  if (!clock_)
    return;
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
}

void
SimulationRT::configureOutputsRT() {
  std::shared_ptr<job::ChannelsEntry> channelsEntry = jobEntry_->getInteractiveSettingsEntry()->getChannelsEntry();

  std::map<std::string, std::shared_ptr<OutputChannel> > channelInterfaceMap;
  for (auto &streamEntry : jobEntry_->getInteractiveSettingsEntry()->getStreamsEntry()->getStreamEntries()) {
    std::map<std::string, std::shared_ptr<OutputChannel> >::iterator channelInterfaceMapIt = channelInterfaceMap.find(streamEntry->getChannel());
    std::shared_ptr<OutputChannel> outputChannel;
    if (channelInterfaceMapIt == channelInterfaceMap.end()) {
      // Create a new output channel
      std::shared_ptr<job::ChannelEntry> channelEntry = channelsEntry->getChannelEntryById(streamEntry->getChannel());
      if (channelEntry->getType() == "ZMQ") {
#ifdef USE_ZMQPP
        if (channelEntry->getEndpoint() == "")
          outputChannel = std::make_shared<ZmqOutputChannel>();
        else
          outputChannel = std::make_shared<ZmqOutputChannel>(channelEntry->getEndpoint());
        channelInterfaceMap.emplace(channelEntry->getId(), outputChannel);
        Trace::debug() << DYNLog(ZmqChannelCreated, channelEntry->getId()) << Trace::endline;
#else
        throw DYNError(Error::GENERAL, UnavailableLib, "ZMQPP");
#endif
      } else {
        Trace::warn() << DYNLog(UnsopportedOutputChannel, channelEntry->getType()) << Trace::endline;
        continue;
      }
    } else {
      outputChannel = channelInterfaceMapIt->second;
    }

    // Connect the output stream to the output channel
    if (streamEntry->getData() == "CURVES") {
      outputDispatcher_->addCurvesPublisher(outputChannel, streamEntry->getFormat());
    } else if (streamEntry->getData() == "TIMELINE") {
      outputDispatcher_->addTimelinePublisher(outputChannel, streamEntry->getFormat());
    } else if (streamEntry->getData() == "CONSTRAINTS") {
      outputDispatcher_->addConstraintsPublisher(outputChannel, streamEntry->getFormat());
    } else {
      Trace::warn() << DYNLog(StreamDataNotManaged, streamEntry->getData()) << Trace::endline;
    }
  }
  for (auto &channelEntry : channelsEntry->getChannelEntries())
    if (channelEntry->getKind() == "OUTPUT" && channelInterfaceMap.find(channelEntry->getId()) == channelInterfaceMap.end())
      Trace::warn() << DYNLog(OutputStreamMissing, channelEntry->getId()) << Trace::endline;
}

void
SimulationRT::configureInputsRT() {
  std::shared_ptr<job::ChannelsEntry> channelsEntry = jobEntry_->getInteractiveSettingsEntry()->getChannelsEntry();
  std::shared_ptr<job::ClockEntry> clockEntry = jobEntry_->getInteractiveSettingsEntry()->getClockEntry();

  for (auto &channelEntry : channelsEntry->getChannelEntries()) {
    if (channelEntry->getKind() == "INPUT") {
      // Create input channel
      if (channelEntry->getType() == "ZMQ") {
#ifdef USE_ZMQPP
        MessageFilter filter = MessageFilter::Actions | MessageFilter::TimeManagement;
        if (clockEntry->getType() == "EXTERNAL" && clockEntry->getTriggerChannel() == channelEntry->getId())  // is trigger channel
          filter = filter | MessageFilter::Trigger;
        std::shared_ptr<InputChannel> zmqServer;
        if (channelEntry->getEndpoint() == "")
          zmqServer = std::make_shared<ZmqInputChannel>("zmq", filter);
        else
          zmqServer = std::make_shared<ZmqInputChannel>("zmq", filter, channelEntry->getEndpoint());
        inputDispatcherAsync_->addInputChannel(zmqServer);
#else
        throw DYNError(Error::GENERAL, UnavailableLib, "ZMQPP");
#endif
      } else {
        Trace::warn() << DYNLog(UnknownChannelType, channelEntry->getType()) << Trace::endline;
      }
    }
  }
}

void
SimulationRT::configureCurvesRT() {
  // Workaround to avoid saving value for each curve:
  //  - Set all curves as EXPORT_AS_FINAL_STATE_VALUE --> will keep only one Point corresponding to last value
  //  - Disable export of curves and final state values
  Trace::info() << DYNLog(RTModeCurvesDisabled) << Trace::endline;
  for (auto &curve : curvesCollection_->getCurves()) {
    curve->setExportType(curves::Curve::EXPORT_AS_FINAL_STATE_VALUE);
  }
  exportCurvesMode_ = EXPORT_CURVES_NONE;
  exportFinalStateValuesMode_ = EXPORT_FINAL_STATE_VALUES_NONE;
  // Add simulation time to curves
  bool sendSimulationMetrics_ = true;
  if (sendSimulationMetrics_)
    initComputationTimeCurve();
}

void
SimulationRT::updateCurves(bool updateCalculatedVariable) const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SimulationRT::updateCurves()");
#endif
  if (updateCalculatedVariable)
    model_->updateCalculatedVarForCurves();

  curvesCollection_->updateCurves(tCurrent_);
}

std::unique_ptr<Modeler>
SimulationRT::createModeler() const {
  std::unique_ptr<Modeler> modeler = DYN::make_unique<Modeler>();
  modeler->setActionBuffer(actionBuffer_);
  return modeler;
}

void
SimulationRT::simulate() {
  Timer timer("SimulationRT::simulate()");
  if (inputDispatcherAsync_)
    inputDispatcherAsync_->setModel(model_);

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
    outputDispatcher_->publishCurvesNames(curvesCollection_);

  bool criteriaChecked = true;
  try {
    // update state variable only if the IIDM final state is exported, or criteria is checked, or lost equipments are exported
    if (data_ && (finalState_.iidmFile_ || isLostEquipmentsExported())) {
      data_->getStateVariableReference();   // Each state variable in DataInterface has a mapped reference variable in dynamic model,
                                         // either in a modelica model or in a C++ model.
      // save initial connection state at t0 for each equipment
      if (isLostEquipmentsExported()) {
        data_->updateFromModel(false);  // force state variables' init
        connectedComponents_ = data_->findConnectedComponents();
      }
    }

    int currentIterNb = 0;

    inputDispatcherAsync_->start();

    clock_->start(tCurrent_);

    double nextOutputT = tCurrent_;  // Publish first time step
    bool isPublicationTime = false;
    bool isWaitTime = false;
    while (!end() && !clock_->getStopMessageReceived() && !SignalHandler::gotExitSignal() && criteriaChecked) {
      // If simulated time corresponds to a completed period, publish the results at the end of the step, then wait before applying the actions
      if (tCurrent_ >= nextOutputT) {
        isPublicationTime = true;
        nextOutputT += couplingTimeStep_;
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

      solver_->solve(tStop_, tCurrent_);
      solver_->printSolve();
      if (currentIterNb == 0)
        printHighestDerivativesValues();

      BitMask solverState = solver_->getState();
      if (solverState.getFlags(ModeChange)) {
        model_->notifyTimeStep();  // check if needed
        Trace::info() << DYNLog(NewStartPoint) << Trace::endline;
        solver_->reinit();
        model_->getCurrentZ(zCurrent_);
        solver_->printSolve();
        printHighestDerivativesValues();
       } else if (solverState.getFlags(NotSilentZChange)
          || solverState.getFlags(SilentZNotUsedInDiscreteEqChange)
          || solverState.getFlags(SilentZNotUsedInContinuousEqChange)) {
        model_->getCurrentZ(zCurrent_);
      }

      model_->checkDataCoherence(tCurrent_);  // check if needed
      ++currentIterNb;

      model_->notifyTimeStep();  // check if needed

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
      if (SignalHandler::gotExitSignal() && !end()) {
        if (timeline_) {
          addEvent(DYNTimeline(SignalReceived));
        }
        throw DYNError(Error::GENERAL, SignalReceived);
      }
    }
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
  stepStart_ = steady_clock::now();
}

void
SimulationRT::updateStepComputationTime() {
  stepComputationTime_ = (1./1000)*(duration_cast<microseconds>(steady_clock::now() - stepStart_)).count();
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
}  // end of namespace DYN
