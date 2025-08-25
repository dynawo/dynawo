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
#ifndef RT_SYSTEM_DYNACTIONBUFFER_H_
#define RT_SYSTEM_DYNACTIONBUFFER_H_

#include <mutex>
#include <unordered_map>
#include <string>

#include "DYNModel.h"
#include "DYNAction.h"
#include "DYNRTInputCommon.h"


#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief ActionBuffer class
 *
 * class for event interraction
 *
 */
class ActionBuffer {
 public:
  explicit ActionBuffer() = default;

  void setModel(std::shared_ptr<Model>& modelMulti);

  void applyActions();

  // bool registerAction(std::string& input);
  bool registerAction(ActionMessage& actionMessage);

 private:
  std::unordered_map<std::string, Action> actions_;
  std::mutex actions_mutex_;
  std::shared_ptr<Model> model_;
};

}  // end of namespace DYN

#endif  // RT_SYSTEM_DYNACTIONBUFFER_H_
