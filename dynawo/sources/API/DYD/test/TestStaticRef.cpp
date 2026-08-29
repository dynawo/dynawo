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
 * @file API/DYD/test/TestStaticRef.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDStaticRefFactory.h"
#include "DYDStaticRef.h"
#include "DYDBlackBoxModelFactory.h"
#include "DYDBlackBoxModel.h"

namespace dynamicdata {

//-----------------------------------------------------
// TEST build StaticRef
//-----------------------------------------------------

TEST(APIDYDTest, StaticRef1) {
  boost::shared_ptr<StaticRef> staticRef1 = boost::shared_ptr<StaticRef>(StaticRefFactory::newStaticRef("modelVar", "staticVar"));
  ASSERT_EQ(staticRef1->getModelVar(), "modelVar");
  ASSERT_EQ(staticRef1->getStaticVar(), "staticVar");
}

TEST(APIDYDTest, StaticRef2) {
  boost::shared_ptr<StaticRef> staticRef2 = boost::shared_ptr<StaticRef>(StaticRefFactory::newStaticRef());
  staticRef2->setModelVar("modelVar");
  staticRef2->setStaticVar("staticVar");

  ASSERT_EQ(staticRef2->getModelVar(), "modelVar");
  ASSERT_EQ(staticRef2->getStaticVar(), "staticVar");
}

TEST(APIDYDTest, StaticRefWithModel) {
  boost::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel");
  model->addStaticRef("var1", "staticVar1");
  model->addStaticRef("var2", "staticVar2");

  int nbStaticRefs = 0;
  for (const auto& staticRefPair : model->getStaticRefs()) {
    const auto& staticRef = staticRefPair.second;
    if (nbStaticRefs == 0) {
      ASSERT_EQ(staticRef->getModelVar(), "var1");
      ASSERT_EQ(staticRef->getStaticVar(), "staticVar1");
    } else {
      ASSERT_EQ(staticRef->getModelVar(), "var2");
      ASSERT_EQ(staticRef->getStaticVar(), "staticVar2");
    }
    ++nbStaticRefs;
  }
  ASSERT_EQ(nbStaticRefs, 2);

  ASSERT_NO_THROW(model->findStaticRef("var1_staticVar1"));
  ASSERT_NO_THROW(model->findStaticRef("var2_staticVar2"));
  ASSERT_THROW_DYNAWO(model->findStaticRef("var3_staticVar3"), DYN::Error::API, DYN::KeyError_t::StaticRefUndefined);
}

TEST(APIDYDTest, StaticRefNotUnique) {
  boost::shared_ptr<BlackBoxModel> model = BlackBoxModelFactory::newModel("blackBoxModel1");
  model->addStaticRef("var1", "staticVar1");
  ASSERT_THROW_DYNAWO(model->addStaticRef("var1", "staticVar1"), DYN::Error::API, DYN::KeyError_t::StaticRefNotUnique);
}

}  // namespace dynamicdata
