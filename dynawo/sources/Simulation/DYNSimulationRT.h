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

#ifdef _MSC_VER
  typedef int pid_t;
#endif

#include "DYNSimulation.h"
// #include "DYNModelManager.h"
// #include "PARParametersSetCollection.h"
#include "WSCServer.h"
#include "DYNTimeManager.h"
#include "DYNEventSubscriber.h"
#include "DYNZmqPublisher.h"

namespace websocket {
class WebsocketServer;
}

namespace timeline {
class Timeline;
}


namespace constraints {
class ConstraintsCollection;
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
class TimeManager;





/**
 * @brief SimulationRT class
 *
 * SimulationRT class is the entry point for Dynawo real-time simulations. It is
 * responsible for setting solver parameters and for controlling
 * simulation time exchanges between the model and the solver
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
   * @brief launch the simulation
   */
  void simulate();

  /**
   * @brief push last curves to websocket
   */
  void publishStepOutputs();

  /**
   * @brief format last curves point in JSON
   */
  void curvesToJson(std::string& outputString);

  /**
   * @brief add curve for step duration
   */
  void initStepDurationCurve();

  /**
   * @brief end the simulation : export data, curves,...
   */
  void terminate();

 protected:
  std::shared_ptr<wsc::WebsocketServer> wsServer_;  ///< instance of websocket server >

  std::shared_ptr<TimeManager> timeManager_;  ///< Time manager >

  std::shared_ptr<EventSubscriber> eventSubscriber_;   ///< Event manager >
  double triggerSimulationTimeStepInS_;  ///< Event manager >

  std::shared_ptr<ZmqPublisher> stepPublisher_;   ///< result publisher
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNSIMULATIONRT_H_
