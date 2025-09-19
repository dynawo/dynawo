//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNActionBuffer.h
 *
 * @brief ActionBuffer header
 *
 */
#ifndef RT_ENGINE_DYNACTIONBUFFER_H_
#define RT_ENGINE_DYNACTIONBUFFER_H_

#include <mutex>
#include <unordered_map>
#include <string>

#include "DYNModel.h"
#include "DYNAction.h"
#include "DYNRTInputCommon.h"


namespace DYN {

/**
 * @brief ActionBuffer class
 *
 * class for event interraction
 *
 */
class ActionBuffer {
 public:
  /**
   * @brief set model instance
   * @param model model instance
   */
  void setModel(std::shared_ptr<Model>& model);

  /**
   * @brief apply the list of action in the queue (empty the queue)
   */
  void applyActions();

  /**
   * @brief register an action item, merging with or replacing a previous item
   * @param actionMessage action to register
   */
  bool registerAction(ActionMessage& actionMessage);

 private:
  std::unordered_map<std::string, Action> actions_;  ///< map of action ordered by model
  std::mutex actionsMutex_;                          ///< mutex for applying/registering a new action
  std::shared_ptr<Model> model_;                     ///< simulation Model instance
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNACTIONBUFFER_H_
