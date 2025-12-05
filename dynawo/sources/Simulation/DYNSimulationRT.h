//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNSimulationRT.h
 *
 * @brief SimulationRT header
 *
 */
#ifndef SIMULATION_DYNSIMULATIONRT_H_
#define SIMULATION_DYNSIMULATIONRT_H_

#include <vector>
#include <queue>
#include <unordered_map>
#include <boost/shared_ptr.hpp>
#include <boost/optional.hpp>
#include <boost/filesystem.hpp>
#include <cstdint>


#include "DYNSimulation.h"
#include "DYNClock.h"
#include "DYNActionBuffer.h"
#include "DYNInputDispatcherAsync.h"
#include "DYNOutputDispatcher.h"

namespace timeline {
class Timeline;
class Exporter;
}


namespace constraints {
class ConstraintsCollection;
class Exporter;
}

namespace job {
class JobEntry;
}

namespace criteria {
class CriteriaCollection;
}

namespace DYN {
class Message;
class MessageTimeline;
class Model;
class Solver;
class DynamicData;
class DataInterface;
class SimulationContext;
class Clock;

/**
 * @brief SimulationRT class
 *
 * SimulationRT class is the entry point for Dynawo interactive (or real-time) simulations.
 * It redifines part of Simulation class to introduce input/output at each step with an external system.
 */
class SimulationRT: public Simulation {
 public:
  /**
   * @brief default constructor
   *
   * @param jobEntry data read in jobs file
   * @param context context of the simulation (configuration, directories, locale, etc...)
   * @param data data interface to use for the simulation (NULL if we build it inside simulation)
   */
  SimulationRT(const std::shared_ptr<job::JobEntry>& jobEntry,
              const std::shared_ptr<SimulationContext>& context,
              boost::shared_ptr<DataInterface> data = boost::shared_ptr<DataInterface>());

  /**
   * @brief default destructor
   */
  virtual ~SimulationRT() {}

  /**
   * @brief configure RT System
   */
  void configureRT();

  /**
   * @brief configure RT Clock
   */
  void configureClock();

  /**
   * @brief configure RT Outputs
   */
  void configureOutputsRT();

  /**
   * @brief configure RT Inputs
   */
  void configureInputsRT();

  /**
   * @brief configure Curves for RT Simulation
   */
  void configureCurvesRT();

  /**
   * @copydoc Simulation::updateCurves()
   */
  void updateCurves(bool updateCalculatedVariable = true) const override;

  /**
   * @copydoc Simulation::createModeler()
   */
  std::unique_ptr<Modeler> createModeler() const override;

  /**
   * @copydoc Simulation::simulate()
   */
  void simulate() override;

 private:
   /**
   * @brief initiate time step value
   */
  void updateStepStart();

  /**
   * @brief update current step time
   */
  void updateStepComputationTime();

  /**
   * @brief add curve for step duration
   */
  void initComputationTimeCurve();

 protected:
  std::chrono::steady_clock::time_point stepStart_;             ///< Clock time before step (after sleep)
  double stepComputationTime_;                                  ///< Step computation time in ms
  double couplingTimeStep_;                                     ///< Simulation period to call for wait / output values in seconds

  std::shared_ptr<Clock> clock_;                                ///< Class managing RT pace
  std::shared_ptr<ActionBuffer> actionBuffer_;                  ///< Action buffer
  std::shared_ptr<InputDispatcherAsync> inputDispatcherAsync_;  ///< Input dispatcher
  std::shared_ptr<OutputDispatcher> outputDispatcher_;          ///< Output dispatcher
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNSIMULATIONRT_H_
