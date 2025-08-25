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
 * @file  DYNAction.h
 *
 * @brief EventSubscriber header
 *
 */
#ifndef RT_SYSTEM_DYNACTION_H_
#define RT_SYSTEM_DYNACTION_H_

#include <vector>
#include <string>

#include "DYNSubModel.h"

#ifdef _MSC_VER
  typedef int pid_t;
#endif

namespace DYN {

/**
 * @brief Action class
 *
 * class for event interraction
 *
 */
class Action {
 public:
  Action(boost::shared_ptr<SubModel>& subModel, std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>>& parameterValueSet);

  void apply();

  void updateParameterValueSet(std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>>& newParameterValueSet);

 private:
  boost::shared_ptr<SubModel> subModel_;                                                  ///< Pointer to the model
  std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>> parameterValueSet_;   ///< Set of parameters
};

}  // end of namespace DYN

#endif  // RT_SYSTEM_DYNACTION_H_
