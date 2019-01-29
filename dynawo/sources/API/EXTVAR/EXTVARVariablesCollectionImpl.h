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
 * @brief External variables collection description : header file
 *
 */

#ifndef API_EXTVAR_EXTVARVARIABLESCOLLECTIONIMPL_H_
#define API_EXTVAR_EXTVARVARIABLESCOLLECTIONIMPL_H_

#include <map>

#include "EXTVARVariablesCollection.h"

namespace externalVariables {
class Variable;

/**
 * @class VariablesCollection::Impl
 * @brief Dynamic models collection implemented class
 *
 * VariablesCollection objects describe a set of external variables for
 * Dynawo
 * a Variable may be discrete or continuous external variables
 */
class VariablesCollection::Impl : public VariablesCollection {
 public:
  /**
   * @brief Constructor
   *
   * @returns New VariablesCollection::Impl instance
   */
  Impl() { }

  /**
   * @brief VariablesCollection destructor
   */
  virtual ~Impl() { }

  /**
   * @copydoc VariablesCollection::addVariable(const boost::shared_ptr<Variable>& variable)
   */
  void addVariable(const boost::shared_ptr<Variable>& variable);

  /**
   * @copydoc VariablesCollection::cbeginVariable()
   */
  variable_const_iterator cbeginVariable() const;

  /**
   * @copydoc VariablesCollection::cendVariable()
   */
  variable_const_iterator cendVariable() const;

  /**
   * @copydoc VariablesCollection::beginVariable()
   */
  variable_iterator beginVariable();

  /**
   * @copydoc VariablesCollection::endVariable()
   */
  variable_iterator endVariable();

  friend class VariablesIteratorImpl;
  friend class VariablesConstIteratorImpl;
 private:
  std::map<std::string, boost::shared_ptr<Variable> > variables_;  ///< Map of the variables
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARVARIABLESCOLLECTIONIMPL_H_
