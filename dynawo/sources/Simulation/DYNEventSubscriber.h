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
 * @file  DYNEventSubscriber.h
 *
 * @brief EventSubscriber header
 *
 */
#ifndef SIMULATION_DYNEVENTSUBSCRIBER_H_
#define SIMULATION_DYNEVENTSUBSCRIBER_H_

#include <mutex>
#include <vector>
#include <string>
#include <condition_variable>
#include <zmqpp/zmqpp.hpp>
#include <signal.h>

#include "DYNModel.h"
#include "DYNSubModel.h"
#include "PARParametersSet.h"


#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief EventSubscriber class
 *
 * class for event interraction
 *
 */
class EventSubscriber {
 public:
  struct Action {
    boost::shared_ptr<SubModel> subModel;                                  ///< Pointer to the model
    std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>> parameterValueSet;   ///< Set of parameters
  };

 public:
  explicit EventSubscriber(bool triggerEnabled, bool actionsEnabled, bool asyncMode = false);

  void setModel(std::shared_ptr<Model>& modelMulti);

  void start();

  void stop();

  void applyActions();

  bool registerAction(std::string& input);

  // void sendReply(const std::string& msg);

  void receiveMessages(bool stop);

  void messageReceiverAsync();

  bool triggerEnabled() {return triggerEnabled_;}

  bool actionsEnabled() {return actionsEnabled_;}

  void wait();

 private:
  const std::string STOP_KEY = "stop";
  std::unordered_map<std::string, Action> actions_;
  std::mutex actions_mutex_;
  zmqpp::context context_;
  zmqpp::socket socket_;
  std::thread receiverThread_;
  std::shared_ptr<Model> model_;
  bool running_;
  bool triggerEnabled_;
  bool actionsEnabled_;
  bool asyncMode_;
  long pollTimeoutMs_;

  // Async variables
  int stepTriggeredCnt_;
  std::mutex simulationMutex_;
  std::condition_variable simulationStepTriggerCondition_;
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNEVENTSUBSCRIBER_H_
