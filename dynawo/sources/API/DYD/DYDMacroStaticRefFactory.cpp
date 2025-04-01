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
 * @file MacroStaticRefFactory.cpp
 * @brief MacroStaticRef factory : implementation file
 *
 */

#include "DYDMacroStaticRefFactory.h"
#include "DYDMacroStaticRef.h"

using std::string;

using boost::shared_ptr;

namespace dynamicdata {

shared_ptr<MacroStaticRef>
MacroStaticRefFactory::newMacroStaticRef(const string& id) {
  return shared_ptr<MacroStaticRef>(new MacroStaticRef(id));
}

}  // namespace dynamicdata
