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
 * @file API/JOB/test/TestInitValuesEntry.cpp
 * @brief Unit tests for API_JOB/JOBInitValuesEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBInitValuesEntry.h"

namespace job {

TEST(APIJOBTest, testInitValuesEntry) {
  boost::shared_ptr<InitValuesEntry> initValues = boost::shared_ptr<InitValuesEntry>(new InitValuesEntry());
  // check default attributes
  ASSERT_EQ(initValues->getDumpLocalInitValues(), false);
  ASSERT_EQ(initValues->getDumpGlobalInitValues(), false);

  initValues->setDumpLocalInitValues(true);
  initValues->setDumpGlobalInitValues(true);

  ASSERT_EQ(initValues->getDumpLocalInitValues(), true);
  ASSERT_EQ(initValues->getDumpGlobalInitValues(), true);
}

}  // namespace job
