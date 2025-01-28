//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file EXTVARVariablesCollection.h
 * @brief External variables collection description : interface file
 *
 */

#ifndef API_EXTVAR_EXTVARVARIABLESCOLLECTION_H_
#define API_EXTVAR_EXTVARVARIABLESCOLLECTION_H_

#include "EXTVARIterators.h"
#include "EXTVARVariable.h"


namespace externalVariables {

/**
 * @class VariablesCollection
 * @brief External variables collection interface class
 *
 * VariablesCollection objects describe Modelica models variables
 * for which (C++) connections will be conducted later on,
 * leading to fictitious equations for preassembled models compilation
 */
class VariablesCollection {
 public:
  /**
   * @brief Add an external variable in the collection
   *
   * @param variable Variable to add
   * @throws Error::API exception if variable id already exists
   */
  void addVariable(const std::shared_ptr<Variable>& variable);

  /**
   * @brief model iterator: beginning of variable
   * @return beginning of variable
   */
  variable_const_iterator cbeginVariable() const;

  /**
   * @brief model iterator: end of variable
   * @return end of variable
   */
  variable_const_iterator cendVariable() const;

  /**
   * @brief model iterator: beginning of variable
   * @return beginning of variable
   */
  variable_iterator beginVariable();

  /**
   * @brief model iterator: end of variable
   * @return end of variable
   */
  variable_iterator endVariable();

  friend class variable_iterator;
  friend class variable_const_iterator;

 private:
  std::map<std::string, std::shared_ptr<Variable> > variables_;  ///< Map of the variables
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLESCOLLECTION_H_
