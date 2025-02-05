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
    std::string modelName;                                      ///< Name of the model
    boost::shared_ptr<SubModel> model;                          ///< Pointer to the model
    std::shared_ptr<parameters::ParametersSet> parametersSet;   ///< Set of parameters
  };

 public:
  explicit EventSubscriber(bool extSync);

  void setModel(std::shared_ptr<Model>& modelMulti);

  void start();

  void stop();

  void applyActions();

  bool registerAction(const std::string& modelName, std::shared_ptr<parameters::ParametersSet>& parametersSet);

  void messageReceiver();

  bool isExtSync() {return extSync_;}

  void wait();

  std::shared_ptr<parameters::ParametersSet> parseParametersSet(std::string& input);

 private:
  std::vector<std::shared_ptr<Action> > actions_;
  std::mutex actions_mutex_;
  zmqpp::context context_;
  zmqpp::socket socket_;
  std::thread receiverThread_;
  bool running_;
  std::shared_ptr<Model> model_;
  bool extSync_;
  bool ready_;
  std::mutex simulationMutex_;
  std::condition_variable simulationStepTriggerCondition_;
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNEVENTSUBSCRIBER_H_
