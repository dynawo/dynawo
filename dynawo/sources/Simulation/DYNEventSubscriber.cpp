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
 * @file  DYNEventSubscriber.cpp
 *
 * @brief Event interractor
 *
 */

#include "DYNTrace.h"

#include "DYNEventSubscriber.h"
#include "PARParametersSetFactory.h"
#include "DYNModelMulti.h"
#include "DYNSignalHandler.h"

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

namespace DYN {

EventSubscriber::EventSubscriber(bool triggerEnabled, bool actionEnabled, bool asyncMode):
socket_(context_, zmqpp::socket_type::reply),
running_(false),
triggerEnabled_(triggerEnabled),
actionsEnabled_(actionEnabled),
asyncMode_(asyncMode),
pollTimeoutMs_(10),
stepTriggeredCnt_(0) {
  socket_.bind("tcp://*:5555");
}

void
EventSubscriber::setModel(std::shared_ptr<Model>& model) {
  model_ = model;
}

void
EventSubscriber::start() {
  if (!model_) {
    std::cout << "EventSubscriber: model not set. Can't start" << std::endl;
    return;
  }
  running_ = true;
  if (asyncMode_) {
    receiverThread_ = std::thread(&EventSubscriber::messageReceiverAsync, this);
    std::cout << "EventSubscriber: thread started" << std::endl;
  }
}

void
EventSubscriber::stop() {
  receiveMessages(true);
  simulationStepTriggerCondition_.notify_all();
  receiverThread_.join();
  std::cout << "EventSubscriber: thread stopped" << std::endl;
  running_ = false;
}

void
EventSubscriber::applyActions() {
  std::lock_guard<std::mutex> actionLock(actions_mutex_);
  for (auto& actionPair : actions_) {
    boost::shared_ptr<SubModel> subModel = actionPair.second.subModel;
    for (auto& parameterTuple : actionPair.second.parameterValueSet) {
      switch (std::get<2>(parameterTuple)) {
        case VAR_TYPE_DOUBLE: {
          subModel->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<double>(std::get<1>(parameterTuple)), false);
          break;
        }
        case VAR_TYPE_INT: {
          subModel->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<int>(std::get<1>(parameterTuple)), false);
          break;
        }
        case VAR_TYPE_BOOL: {
          subModel->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<bool>(std::get<1>(parameterTuple)), false);
          break;
        }
        case VAR_TYPE_STRING: {
          subModel->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<std::string>(std::get<1>(parameterTuple)), false);
          break;
        }
        default:
        {
          throw DYNError(Error::MODELER, ParameterBadType, std::get<0>(parameterTuple));
        }
      }
    }
    subModel->setSubModelParameters();
    Trace::info() << "EventSubscriber: SubModel " << actionPair.second.subModel->name() << " parameters updated" << Trace::endline;
    std::cout << "EventSubscriber: SubModel " << actionPair.second.subModel->name() << " parameters updated" << std::endl;
  }
  actions_.clear();
}


/*
void
EventSubscriber::sendReply(const std::string& msg) {
  if (!asyncMode_ && pendingReply_) {
    zmqpp::message reply;
    reply << msg;
    socket_.send(reply);
  }
}
*/

void
EventSubscriber::receiveMessages(bool stop = false) {
  zmqpp::poller poller;
  poller.add(socket_);

  while (running_ && !SignalHandler::gotExitSignal()) {
    // Polling
    if (poller.poll(pollTimeoutMs_)) {
      std::cout << "EventSubscriber: message received" << std::endl;

      if (poller.has_input(socket_)) {
        zmqpp::message message;
        socket_.receive(message);
        std::string input;
        message >> input;
        zmqpp::message reply;
        if (input.empty() && triggerEnabled_) {
            // trigger next step
            if (stop) {
              reply << "simulation ended";
              std::cout << "Reply: simulation ended" << std::endl;
            } else {
              reply << "trigger reply";
              std::cout << "Reply: trigger reply" << std::endl;
            }
            socket_.send(reply);
            return;

        } else if (!input.compare(STOP_KEY)) {
          running_ = false;
          reply << "stop signal";
          socket_.send(reply);
          std::cout << "Stop signal received. Ending simulation." << std::endl;
          kill(getpid(), SIGINT);

        } else if (actionsEnabled_) {
          // Register the action
          if (registerAction(input)) {
            reply << "Action registered";
          } else {
            reply << "Action registration failed";
          }
          socket_.send(reply);
        } else {
          zmqpp::message reply;
          reply << "Unknown request";
          socket_.send(reply);
        }
      }
    }
  }
}


void
EventSubscriber::messageReceiverAsync() {
  zmqpp::poller poller;
  poller.add(socket_);

  while (running_ && !SignalHandler::gotExitSignal()) {
    zmqpp::message message;

    // Polling
    if (poller.poll(pollTimeoutMs_)) {
      std::cout << "EventSubscriber: message received" << std::endl;

      if (poller.has_input(socket_)) {
        zmqpp::message message;
        socket_.receive(message);
        std::string input;
        message >> input;

        zmqpp::message reply;
        if (input.empty() && triggerEnabled_) {
            // trigger next step
            reply << "Step triggered";
            std::lock_guard<std::mutex> simulationLock(simulationMutex_);
            stepTriggeredCnt_++;
            simulationStepTriggerCondition_.notify_one();
            socket_.send(reply);
        } else if (!input.compare(STOP_KEY)) {
          running_ = false;
          reply << "stop signal";
          socket_.send(reply);
          std::cout << "Stop signal received. Ending simulation." << std::endl;
          kill(getppid(), SIGINT);
        } else if (actionsEnabled_) {
          // Register the action
          zmqpp::message reply;
          if (registerAction(input)) {
            reply << "Action registered";
          } else {
            reply << "Action registration failed";
          }
          socket_.send(reply);
        } else {
          reply << "Unknown request";
          socket_.send(reply);
        }
      }
    }
  }
  stepTriggeredCnt_++;
  simulationStepTriggerCondition_.notify_all();
}

bool
EventSubscriber::registerAction(std::string& input) {
  std::cout << "EventSubscriber: register: " << input << std::endl;
  std::istringstream stream(input);
  std::string token;
  std::string subModelName;

  // Read the id (first part before the first comma)
  std::getline(stream, subModelName, ',');

  std::shared_ptr<ModelMulti> model = std::dynamic_pointer_cast<ModelMulti>(model_);
  boost::shared_ptr<SubModel> subModel = model->findSubModelByName(subModelName);
  if (!subModel) {
    Trace::error() << "EventSubscriber: Impossible to register action. Unknown SubModel: " << subModelName << Trace::endline;
    return false;
  }

  std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>> parameterValueSet;
  // Read the rest of the parameter-value pairs
  while (std::getline(stream, token, ',')) {
    // parse the triple
    std::string name = token;
    std::string type, value;

    if (std::getline(stream, token, ',')) {
        type = token;
    } else {
      Trace::error() << "EventSubscriber: Could not parse action, incomplete data" << Trace::endline;
      return false;
    }

    if (std::getline(stream, token, ',')) {
        value = token;
    } else {
      Trace::error() << "EventSubscriber: Could not parse action, incomplete data" << Trace::endline;
      return false;
    }

    if (subModel->hasParameterDynamic(name)) {
      const ParameterModeler& parameter = subModel->findParameterDynamic(name);
      boost::any castedValue;
      switch (parameter.getValueType()) {
        case VAR_TYPE_DOUBLE: {
          castedValue = std::stod(value);
          break;
        }
        case VAR_TYPE_INT: {
          castedValue = std::stoi(value);
          break;
        }
        case VAR_TYPE_BOOL: {
          bool bval = std::stoi(value);
          castedValue = bval;
          break;
        }
        case VAR_TYPE_STRING: {
          castedValue = value;
          break;
        }
        default:
        {
          throw DYNError(Error::MODELER, ParameterBadType, parameter.getName());
        }
      }

      parameterValueSet.push_back(std::make_tuple(name, castedValue, parameter.getValueType()));
      std::cout << "new parameter modification for: " << name << std::endl;
    } else {
      std::cout << "EventSubscriber: Parameter: " << name << " does not exist" << std::endl;
      return false;
    }
  }

  Action newAction = {subModel, parameterValueSet};
  {
    std::lock_guard<std::mutex> actionLock(actions_mutex_);
    if (actions_.find(subModelName) != actions_.end()) {
      if (!subModelName.compare("NETWORK")) {
        actions_[subModelName].parameterValueSet.insert(actions_[subModelName].parameterValueSet.end(),
                                                        parameterValueSet.begin(),
                                                        parameterValueSet.end());
        std::cout << "EventSubscriber: Action list extended for NETWORK SubModel" << std::endl;
        Trace::info() << "EventSubscriber: Action list extended for NETWORK SubModel" << Trace::endline;
      } else {
        actions_[subModelName] = newAction;
        std::cout << "EventSubscriber: Actions overriden for SubModel: " << subModelName << std::endl;
        Trace::warn() << "EventSubscriber: Actions overriden for SubModel: " << subModelName << Trace::endline;
      }
    } else {
      Trace::info() << "EventSubscriber: New action registered on model: " << subModelName << Trace::endline;
      std::cout << "EventSubscriber: New action registered on model: " << subModelName << std::endl;
      actions_[subModelName] = newAction;
    }
  }
  return true;
}

void
EventSubscriber::wait() {
  if (asyncMode_) {
    std::unique_lock<std::mutex> simulationLock(simulationMutex_);
    simulationStepTriggerCondition_.wait(simulationLock, [this] {return stepTriggeredCnt_;});
    stepTriggeredCnt_--;
  } else {
    receiveMessages();
  }
}
}  // end of namespace DYN
