//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file PARMacroParSetFactory.cpp
 * @brief PARMacroParSetFactory : implementation file
 *
 */

#include "PARMacroParSetFactory.h"

#include "PARMacroParSet.h"

using std::string;

using boost::shared_ptr;

namespace parameters {

shared_ptr<MacroParSet>
MacroParSetFactory::newMacroParSet(const string& id) {
  return shared_ptr<MacroParSet>(new MacroParSet(id));
}

}  // namespace parameters
