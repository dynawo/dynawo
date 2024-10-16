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
// #include "PARParametersSetCollection.h"
// #include "DYNDataInterface.h"

namespace websocket {
class WebsocketServer;
}

namespace timeline {
class Timeline;
}

namespace curves {
class CurvesCollection;
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
  SimulationRT(boost::shared_ptr<job::JobEntry>& jobEntry, boost::shared_ptr<SimulationContext>& context,
              boost::shared_ptr<DataInterface> data = boost::shared_ptr<DataInterface>());

  /**
   * @brief launch the simulation
   */
  void simulate();

  /**
   * @brief timeSync setter
   * @param timeSync boolean indicating if simulation must be sync with user clock
   */
  void setTimeSync(bool timeSync) {
    timeSync_ = timeSync;
  }

  /**
   * @brief timeSyncAcceleration setter
   * @param timeSyncAcceleration acceleration ratio between simulation time and user clock
   */
  void setTimeSyncAcceleration(double timeSyncAcceleration) {
    timeSyncAcceleration_ = timeSyncAcceleration;
  }

  /**
   * @brief update streams : at the end of each iteration, new points are added to curve
   */
  void curvesToStream();

 protected:
  boost::shared_ptr<websocket::WebsocketServer> wsServer_;  ///< instance of websocket server

  bool timeSync_;  ///< true if simulation time should be synchronized with real clock >
  double timeSyncAcceleration_;  ///< acceleration factor clockTime/simulationTime >
  std::vector<std::string> curvesNames_;  ///< curves names >
};
}  // end of namespace DYN

#endif  // SIMULATION_DYNSIMULATIONRT_H_
