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
 * @file DYDMacroConnectionFactory.cpp
 * @brief MacroConnection factory : implementation file
 *
 */

#include "DYDMacroConnectionFactory.h"

#include "DYDMacroConnection.h"

using boost::shared_ptr;
using std::string;

namespace dynamicdata {

shared_ptr<MacroConnection>
MacroConnectionFactory::newMacroConnection(const string& var1, const string& var2) {
  return shared_ptr<MacroConnection>(new MacroConnection(var1, var2));
}

}  // namespace dynamicdata
