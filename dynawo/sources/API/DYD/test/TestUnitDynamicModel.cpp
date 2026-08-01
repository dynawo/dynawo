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
 * @file API/DYD/test/TestUnitDynamicModel.cpp
 * @brief Unit tests for API_DYD
 *
 */

#include "gtest_dynawo.h"

#include "DYDUnitDynamicModelFactory.h"
#include "DYDUnitDynamicModel.h"

namespace dynamicdata {
//-----------------------------------------------------
// TEST build UnitDynamicModel
//-----------------------------------------------------
TEST(APIDYDTest, UnitDynamicModel) {
  boost::shared_ptr<UnitDynamicModel> udm;
  udm = UnitDynamicModelFactory::newModel("udm", "model");
  udm->setDynamicFileName("moFile");
  udm->setInitModelName("initName");
  udm->setInitFileName("initFile");
  udm->setParFile("parFile");
  udm->setParId("parId");

  ASSERT_EQ(udm->getId(), "udm");
  ASSERT_EQ(udm->getParFile(), "parFile");
  ASSERT_EQ(udm->getParId(), "parId");
  ASSERT_EQ(udm->getDynamicModelName(), "model");
  ASSERT_EQ(udm->getDynamicFileName(), "moFile");
  ASSERT_EQ(udm->getInitModelName(), "initName");
  ASSERT_EQ(udm->getInitFileName(), "initFile");
}

}  // namespace dynamicdata
