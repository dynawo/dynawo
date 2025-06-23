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
#ifndef MODELER_COMMON_DYNACTIONBUFFER_H_
#define MODELER_COMMON_DYNACTIONBUFFER_H_

#include <mutex>
#include <unordered_map>
#include <string>

#include "DYNModel.h"
#include "DYNAction.h"


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
   * @brief apply the list of action in the queue (empty the queue)
   */
  void applyActions();

  /**
   * @brief register an action item, merging with or replacing a previous item
   * @param subModel subModel of the action
   * @param parameterValueSet set of parameter values
   */
  void addAction(const boost::shared_ptr<SubModel>& subModel, Action::ActionParameters& parameterValueSet);

 private:
  std::unordered_map<std::string, Action> actions_;  ///< map of action ordered by model
  std::mutex actionsMutex_;                          ///< mutex for applying/registering a new action
};

}  // end of namespace DYN

#endif  // MODELER_COMMON_DYNACTIONBUFFER_H_
