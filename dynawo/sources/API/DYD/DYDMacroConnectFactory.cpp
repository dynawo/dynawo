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
 * @file DYDMacroConnectFactory.cpp
 * @brief MacroConnect factory : implementation file
 *
 */

#include "DYDMacroConnectFactory.h"
#include "DYDMacroConnect.h"

using std::string;


namespace dynamicdata {

std::unique_ptr<MacroConnect>
MacroConnectFactory::newMacroConnect(const std::string& id, const std::string& model1, const std::string& model2) {
  return std::unique_ptr<MacroConnect>(new MacroConnect(id, model1, model2));
}

}  // namespace dynamicdata
