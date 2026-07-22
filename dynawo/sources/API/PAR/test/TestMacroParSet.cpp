//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file API/PAR/test/TestMacroParSet.cpp
 * @brief Unit tests for API_PAR
 *
 */

#include "gtest_dynawo.h"
#include "PARMacroParSet.h"
#include <boost/shared_ptr.hpp>

namespace parameters {
  TEST(APIPARTest, MacroParSet) {
    boost::shared_ptr<MacroParSet> macroParSet = boost::shared_ptr<MacroParSet>(new MacroParSet("macroParSet"));
    ASSERT_EQ(macroParSet->getId(), "macroParSet");
  }
}
