//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file API/LEQ/test/TestLostEquipment.cpp
 * @brief Unit tests for API_LEQ
 *
 */

#include "gtest_dynawo.h"

#include "LEQLostEquipmentFactory.h"
#include "LEQLostEquipment.h"

namespace lostEquipments {

//-----------------------------------------------------
// TEST for LostEquipment
//-----------------------------------------------------

TEST(APILEQTest, LostEquipment) {
  boost::shared_ptr<LostEquipment> lostEquipment = LostEquipmentFactory::newLostEquipment();

  lostEquipment->setId("ID1");
  lostEquipment->setType("type1");

  ASSERT_EQ(lostEquipment->getId(), "ID1");
  ASSERT_EQ(lostEquipment->getType(), "type1");

  lostEquipment = LostEquipmentFactory::newLostEquipment("ID2", "type2");

  ASSERT_EQ(lostEquipment->getId(), "ID2");
  ASSERT_EQ(lostEquipment->getType(), "type2");
}

}  // namespace lostEquipments
