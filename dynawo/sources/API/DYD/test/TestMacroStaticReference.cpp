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
 * @file API/DYD/test/TestMacroStaticReference.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDMacroStaticReferenceFactory.h"
#include "DYDMacroStaticReference.h"
#include "DYDStaticRef.h"

namespace dynamicdata {

//-----------------------------------------------------
// TEST build MacroStaticReference
//-----------------------------------------------------

TEST(APIDYDTest, MacroStaticReference) {
  std::shared_ptr<MacroStaticReference> macroStaticReference = MacroStaticReferenceFactory::newMacroStaticReference("macroStaticReference");
  ASSERT_NO_THROW(macroStaticReference->addStaticRef("var1", "staticVar1"));
  ASSERT_NO_THROW(macroStaticReference->addStaticRef("var2", "staticVar2"));
  ASSERT_THROW_DYNAWO(macroStaticReference->addStaticRef("var2", "staticVar2"), DYN::Error::API, DYN::KeyError_t::StaticRefNotUniqueInMacro);

  ASSERT_EQ(macroStaticReference->getId(), "macroStaticReference");

  const auto nbStaticRefs = macroStaticReference->getStaticReferences().size();
  ASSERT_EQ(nbStaticRefs, 2);

  ASSERT_NO_THROW(macroStaticReference->findStaticRef("var1_staticVar1"));
  ASSERT_NO_THROW(macroStaticReference->findStaticRef("var2_staticVar2"));
  ASSERT_THROW_DYNAWO(macroStaticReference->findStaticRef("var3_staticVar3"), DYN::Error::API, DYN::KeyError_t::StaticRefUndefined);
}

}  // namespace dynamicdata
