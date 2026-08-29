//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNVariableAliasFactory.cpp
 *
 * @brief Dynawo variable alias : factory file
 *
 */

#include "DYNMacrosMessage.h"

#include "DYNVariableAliasFactory.h"
#include "DYNVariableAlias.h"
#include "DYNVariableNative.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

shared_ptr<VariableAlias>
VariableAliasFactory::create(const string& name, const string& refName, const typeVar_t type, const bool negated) {
  return shared_ptr<VariableAlias>(new VariableAlias(name, refName, type, negated));
}

shared_ptr<VariableAlias>
VariableAliasFactory::create(const string& name, const shared_ptr<VariableNative> refVar, const typeVar_t type, const bool negated) {
  if (refVar->isAlias()) {
    throw DYNError(Error::MODELER, VariableAliasRefNotNative, name, refVar->getName());
  }
  return shared_ptr<VariableAlias>(new VariableAlias(name, refVar, type, negated));
}

}  // namespace DYN
