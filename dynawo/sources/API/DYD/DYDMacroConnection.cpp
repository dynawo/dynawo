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
 * @file DYDMacroConnection.cpp
 * @brief MacroConnection description : implementation file
 *
 */

#include "DYDMacroConnection.h"

using std::string;

namespace dynamicdata {

MacroConnection::MacroConnection(const string& var1, const string& var2) : firstVariableId_(var1), secondVariableId_(var2) {}

const string&
MacroConnection::getFirstVariableId() const {
  return firstVariableId_;
}

const string&
MacroConnection::getSecondVariableId() const {
  return secondVariableId_;
}

}  // namespace dynamicdata
