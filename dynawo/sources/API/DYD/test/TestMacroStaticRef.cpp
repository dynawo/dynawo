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
 * @file API/DYD/test/TestMacroStaticRef.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDMacroStaticRefFactory.h"
#include "DYDMacroStaticRef.h"

namespace dynamicdata {

//-----------------------------------------------------
// TEST build MacroStaticRef
//-----------------------------------------------------

TEST(APIDYDTest, MacroStaticRef) {
  boost::shared_ptr<MacroStaticRef> macroStaticRef = MacroStaticRefFactory::newMacroStaticRef("macroStaticRef");

  ASSERT_EQ(macroStaticRef->getId(), "macroStaticRef");
}

}  // namespace dynamicdata
