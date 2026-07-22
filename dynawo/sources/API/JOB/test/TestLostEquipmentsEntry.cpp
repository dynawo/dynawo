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
 * @file API/JOB/test/TestLostEquipmentsEntry.cpp
 * @brief Unit tests for API_JOB/LostEquipmentsEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBLostEquipmentsEntry.h"

namespace job {

TEST(APIJOBTest, testLostEquipmentsEntry) {
  boost::shared_ptr<LostEquipmentsEntry> lostEquipments = boost::shared_ptr<LostEquipmentsEntry>(new LostEquipmentsEntry());
  // check default attributes
  ASSERT_EQ(lostEquipments->getDumpLostEquipments(), false);

  lostEquipments->setDumpLostEquipments(true);

  ASSERT_EQ(lostEquipments->getDumpLostEquipments(), true);
}

}  // namespace job
