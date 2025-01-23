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

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

namespace DYN {

EventSubscriber::EventSubscriber(std::shared_ptr<Model>& model):
model_(model),
socket_(context_, zmqpp::socket_type::reply)
{socket_.bind("tcp://*:5555");}

void
EventSubscriber::start() {
  receiverThread_ = std::thread(&EventSubscriber::messageReceiver, this);
  std::cout << "ZMQ thread started" << std::endl;
  running_ = true;
}

void
EventSubscriber::stop() {
  running_ = false;
  receiverThread_.join();
  std::cout << "ZMQ thread stopped" << std::endl;
}

void
EventSubscriber::applyActions() {
  std::lock_guard<std::mutex> lock(actions_mutex_);
  for (std::shared_ptr<Action>& action : actions_) {
    action->model->updateParameters(action->parametersSet);
    Trace::info() << "Action: SubModel " << action->modelName << " parameters updated" << Trace::endline;
    std::cout << "Action: SubModel " << action->modelName << " parameters updated" << std::endl;
  }
  actions_.clear();
}

bool
EventSubscriber::registerAction(const std::string& modelName, std::shared_ptr<parameters::ParametersSet>& parametersSet) {
  std::lock_guard<std::mutex> lock(actions_mutex_);
  std::shared_ptr<ModelMulti> model = std::dynamic_pointer_cast<ModelMulti>(model_);
  boost::shared_ptr<SubModel> subModel = model->findSubModelByName(modelName);
  if (!subModel) {
    Trace::error() << "Action: Impossible to register action. Unknown SubModel: " << modelName << Trace::endline;
    return false;
  }

  std::shared_ptr<Action> newAction = std::make_shared<Action>();
  newAction->modelName = modelName;
  newAction->model = subModel;
  newAction->parametersSet = parametersSet;
  actions_.push_back(newAction);
  Trace::info() << "Action: New action registered on model: " << modelName << Trace::endline;
  return true;
}


void
EventSubscriber::messageReceiver() {
  while (running_) {
    // std::cout << "... zmq receiver loop" << std::endl;

    zmqpp::message message;

    // Non-blocking receive
    if (socket_.receive(message, true)) {
      std::cout << "Action: message received" << std::endl;

      std::string input;
      message >> input;
      std::shared_ptr<ParametersSet> parametersSet = parseParametersSet(input);

      // Register the action
      zmqpp::message reply;
      if (registerAction(parametersSet->getId(), parametersSet)) {
        reply << "OK";
      } else {
        reply << "KO";
      }
      socket_.send(reply);
    }

    // Sleep briefly to reduce CPU usage
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }
}

std::shared_ptr<ParametersSet>
EventSubscriber::parseParametersSet(std::string& input) {
  std::cout << "Action: register: " << input << std::endl;
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
      Trace::error() << "Action: Could not parse action, incomplete data" << Trace::endline;
      return std::shared_ptr<ParametersSet>();
    }

    if (std::getline(stream, token, ',')) {
        value = token;
    } else {
      Trace::error() << "Action: Could not parse action, incomplete data" << Trace::endline;
      return std::shared_ptr<ParametersSet>();
    }

    // Cast the value
    if (type == "int") {
      try {
        parametersSet->createParameter(parameter, std::stoi(value));
        std::cout << "Action: int param: " << parameter << " = " << value << std::endl;
      } catch (const std::exception&) {
        Trace::error() << "Action: Could not parse action, Invalid integer value: " << value << Trace::endline;
        return std::shared_ptr<ParametersSet>();
      }
    } else if (type == "double") {
      try {
        parametersSet->createParameter(parameter, std::stod(value));
        std::cout << "Action: double param: " << parameter << " = " << value << std::endl;
      } catch (const std::exception&) {
        Trace::error() << "Action: Could not parse action, Invalid double value: " << value << Trace::endline;
        return std::shared_ptr<ParametersSet>();
      }
    } else if (type == "bool") {
      try {
        bool bval = std::stoi(value);
        parametersSet->createParameter(parameter, bval);
        std::cout << "Action: bool param: " << parameter << " = " << value << std::endl;
      } catch (const std::exception&) {
        Trace::error() << "Action: Could not parse action, Invalid double value: " << value << Trace::endline;
        return std::shared_ptr<ParametersSet>();
      }
    } else if (type == "string") {
      parametersSet->createParameter(parameter, value);
      std::cout << "Action: string param: " << parameter << " = " << value << std::endl;
    } else {
      std::cout << "Action: Could not parse action, unknown type: " << type << std::endl;
      // Trace::error() << "Action: Could not parse action, unknown type: " << type << Trace::endline;
      return std::shared_ptr<ParametersSet>();
    }
  }
  return parametersSet;
}
}  // end of namespace DYN
