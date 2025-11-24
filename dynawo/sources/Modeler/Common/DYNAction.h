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
#ifndef MODELER_COMMON_DYNACTION_H_
#define MODELER_COMMON_DYNACTION_H_

#include <vector>
#include <string>

#include "DYNSubModel.h"

namespace DYN {

/**
 * @brief Action class
 *
 * class for event interraction
 *
 */
class Action {
 public:
  /**
   * @typedef ActionParameters
   * @brief Alias for a vector of tuples <parameter name, value, type>
   */
  typedef std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t> > ActionParameters;

 /**
   * @brief constructor
   * @param subModel SubModel where some value should be modified
   * @param parameterValueSet set of parameters to modify
   */
  Action(const boost::shared_ptr<SubModel>& subModel, ActionParameters& parameterValueSet);

  /**
   * @brief apply the action
   */
  void apply();

  /**
   * @brief update the action parameters list, inserting a new list
   * @param newParameterValueSet new parameter set to insert in the Action parameter value set
   */
  void updateParameterValueSet(ActionParameters& newParameterValueSet);

 private:
  boost::shared_ptr<SubModel> subModel_;   ///< Pointer to the SubModel
  ActionParameters parameterValueSet_;     ///< Set of parameters to modify
};

}  // end of namespace DYN

#endif  // MODELER_COMMON_DYNACTION_H_
