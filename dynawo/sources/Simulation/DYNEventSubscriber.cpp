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
  zmqpp::poller poller_;
  poller_.add(socket_);
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
  for (std::shared_ptr<Action>& action : actions_) {
    action->model->updateParameters(action->parametersSet);
    Trace::info() << "EventSubscriber: SubModel " << action->modelName << " parameters updated" << Trace::endline;
    std::cout << "EventSubscriber: SubModel " << action->modelName << " parameters updated" << std::endl;
  }
  actions_.clear();
}

bool
EventSubscriber::registerAction(const std::string& modelName, std::shared_ptr<parameters::ParametersSet>& parametersSet) {
  std::shared_ptr<ModelMulti> model = std::dynamic_pointer_cast<ModelMulti>(model_);
  boost::shared_ptr<SubModel> subModel = model->findSubModelByName(modelName);
  if (!subModel) {
    Trace::error() << "EventSubscriber: Impossible to register action. Unknown SubModel: " << modelName << Trace::endline;
    return false;
  }

  std::shared_ptr<Action> newAction = std::make_shared<Action>();
  newAction->modelName = modelName;
  newAction->model = subModel;
  newAction->parametersSet = parametersSet;
  {
    std::lock_guard<std::mutex> actionLock(actions_mutex_);
    actions_.push_back(newAction);
  }
  Trace::info() << "EventSubscriber: New action registered on model: " << modelName << Trace::endline;
  return true;
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
EventSubscriber::receiveMessages(bool stop) {
  while (running_ && !SignalHandler::gotExitSignal()) {
    zmqpp::message message;

    // Polling
    if (poller_.poll(pollTimeoutMs_)) {
      std::cout << "EventSubscriber: message received" << std::endl;

      std::string input;
      message >> input;

      if (input.empty() && triggerEnabled_) {
          // trigger next step
          zmqpp::message reply;
          if (stop) {
            reply << "simulation ended";
            std::cout << "Reply: simulation ended" << std::endl;
          } else {
            reply << "trigger reply";
            std::cout << "Reply: trigger reply" << std::endl;
          }
          socket_.send(reply);
          return;

      } else if (actionsEnabled_) {
        std::shared_ptr<ParametersSet> parametersSet = parseParametersSet(input);

        // Register the action
        zmqpp::message reply;
        if (registerAction(parametersSet->getId(), parametersSet)) {
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


void
EventSubscriber::messageReceiverAsync() {
  while (running_ && !SignalHandler::gotExitSignal()) {
    zmqpp::message message;

    // Polling
    if (poller_.poll(pollTimeoutMs_)) {
      std::cout << "EventSubscriber: message received" << std::endl;

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
      } else if (actionsEnabled_) {
        std::shared_ptr<ParametersSet> parametersSet = parseParametersSet(input);

        // Register the action
        zmqpp::message reply;
        if (registerAction(parametersSet->getId(), parametersSet)) {
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
  stepTriggeredCnt_++;
  simulationStepTriggerCondition_.notify_all();
}

std::shared_ptr<ParametersSet>
EventSubscriber::parseParametersSet(std::string& input) {
  std::cout << "EventSubscriber: register: " << input << std::endl;
  std::istringstream stream(input);
  std::string token;
  std::string modelName;

  // Read the id (first part before the first comma)
  std::getline(stream, modelName, ',');

  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet(modelName);

  // Read the rest of the parameter-value pairs
  while (std::getline(stream, token, ',')) {
    // parse the triple
    std::string parameter = token;
    std::string type, value;

    if (std::getline(stream, token, ',')) {
        type = token;
    } else {
      Trace::error() << "EventSubscriber: Could not parse action, incomplete data" << Trace::endline;
      return std::shared_ptr<ParametersSet>();
    }

    if (std::getline(stream, token, ',')) {
        value = token;
    } else {
      Trace::error() << "EventSubscriber: Could not parse action, incomplete data" << Trace::endline;
      return std::shared_ptr<ParametersSet>();
    }

    // Cast the value
    if (type == "int") {
      try {
        parametersSet->createParameter(parameter, std::stoi(value));
        std::cout << "EventSubscriber: int param: " << parameter << " = " << value << std::endl;
      } catch (const std::exception&) {
        Trace::error() << "EventSubscriber: Could not parse action, Invalid integer value: " << value << Trace::endline;
        return std::shared_ptr<ParametersSet>();
      }
    } else if (type == "double") {
      try {
        parametersSet->createParameter(parameter, std::stod(value));
        std::cout << "EventSubscriber: double param: " << parameter << " = " << value << std::endl;
      } catch (const std::exception&) {
        Trace::error() << "EventSubscriber: Could not parse action, Invalid double value: " << value << Trace::endline;
        return std::shared_ptr<ParametersSet>();
      }
    } else if (type == "bool") {
      try {
        bool bval = std::stoi(value);
        parametersSet->createParameter(parameter, bval);
        std::cout << "EventSubscriber: bool param: " << parameter << " = " << value << std::endl;
      } catch (const std::exception&) {
        Trace::error() << "EventSubscriber: Could not parse action, Invalid double value: " << value << Trace::endline;
        return std::shared_ptr<ParametersSet>();
      }
    } else if (type == "string") {
      parametersSet->createParameter(parameter, value);
      std::cout << "EventSubscriber: string param: " << parameter << " = " << value << std::endl;
    } else {
      std::cout << "EventSubscriber: Could not parse action, unknown type: " << type << std::endl;
      // Trace::error() << "EventSubscriber: Could not parse action, unknown type: " << type << Trace::endline;
      return std::shared_ptr<ParametersSet>();
    }
  }
  return parametersSet;
}

void
EventSubscriber::wait() {
  std::cout << "EventSubscriber: wait for signal " << std::endl;
  if (asyncMode_) {
    std::unique_lock<std::mutex> simulationLock(simulationMutex_);
    simulationStepTriggerCondition_.wait(simulationLock, [this] {return stepTriggeredCnt_;});
    stepTriggeredCnt_--;
  } else {
    receiveMessages();
  }
  std::cout << "EventSubscriber: trigger signal received " << std::endl;
}
}  // end of namespace DYN
