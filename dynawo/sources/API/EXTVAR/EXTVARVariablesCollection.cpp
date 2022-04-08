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
 * @file EXTVARVariablesCollection.cpp
 * @brief External variables collection description : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "EXTVARVariablesCollection.h"
#include "EXTVARIterators.h"
#include "EXTVARVariable.h"

using std::map;
using std::string;

using boost::shared_ptr;

namespace externalVariables {

void VariablesCollection::addVariable(const shared_ptr<Variable>& variable) {
  const string& id = variable->getId();
  // Used instead of variables_[name] = VariableFactory::newvariable(id, type)
  // to avoid necessity to create VariableFactory::Impl default constructor
  std::pair < map< string, shared_ptr<Variable> >::iterator, bool> ret;
  ret = variables_.emplace(id, variable);
  if (!ret.second)
    throw DYNError(DYN::Error::API, ExternalVariableIDNotUnique, id);
}

variable_const_iterator
VariablesCollection::cbeginVariable() const {
  return variable_const_iterator(this, true);
}

variable_const_iterator
VariablesCollection::cendVariable() const {
  return variable_const_iterator(this, false);
}

variable_iterator
VariablesCollection::beginVariable() {
  return variable_iterator(this, true);
}

variable_iterator
VariablesCollection::endVariable() {
  return variable_iterator(this, false);
}

}  // namespace externalVariables
