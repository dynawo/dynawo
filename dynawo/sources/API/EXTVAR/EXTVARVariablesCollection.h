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

#include <boost/shared_ptr.hpp>

#include "EXTVARExport.h"

namespace externalVariables {

class Variable;
class variable_const_iterator;
class variable_iterator;

/**
 * @class VariablesCollection
 * @brief External variables collection interface class
 *
 * VariablesCollection objects describe Modelica models variables
 * for which (C++) connections will be conducted later on,
 * leading to fictitious equations for preassembled models compilation
 */
class __DYNAWO_EXTVAR_EXPORT VariablesCollection {
 public:
  /**
   * @brief Destructor
   */
  virtual ~VariablesCollection() {}
  /**
   * @brief Add an external variable in the collection
   *
   * @param variable Variable to add
   * @throws Error::API exception if variable id already exists
   */
  virtual void addVariable(const boost::shared_ptr<Variable>& variable) = 0;

  /**
   * @brief Implementation class
   */
  class Impl;  // Implementation class

  /**
   * @brief model iterator: beginning of variable
   * @return beginning of variable
   */
  virtual variable_const_iterator cbeginVariable() const = 0;

  /**
   * @brief model iterator: end of variable
   * @return end of variable
   */
  virtual variable_const_iterator cendVariable() const = 0;

  /**
   * @brief model iterator: beginning of variable
   * @return beginning of variable
   */
  virtual variable_iterator beginVariable() = 0;

  /**
   * @brief model iterator: end of variable
   * @return end of variable
   */
  virtual variable_iterator endVariable() = 0;
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLESCOLLECTION_H_
