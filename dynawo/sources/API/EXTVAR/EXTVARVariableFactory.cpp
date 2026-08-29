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
 * @file EXTVARVariableFactory.cpp
 * @brief External variable file factory : implementation file
 *
 */

#include "EXTVARVariableFactory.h"
#include "EXTVARVariable.h"

using std::string;

namespace externalVariables {

std::unique_ptr<Variable>
VariableFactory::newVariable(const string& id, Variable::Type type) {
  return std::unique_ptr<Variable>(new Variable(id, type));
}

}  // namespace externalVariables
