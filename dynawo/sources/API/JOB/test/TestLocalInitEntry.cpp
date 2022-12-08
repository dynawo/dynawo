//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file API/JOB/test/TestLocalInitEntry.cpp
 * @brief Unit tests for API_JOB/JOBLocalInitEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBLocalInitEntry.h"

namespace job {

TEST(APIJOBTest, testLocalInitEntry) {
  boost::shared_ptr<LocalInitEntry> localInit = boost::shared_ptr<LocalInitEntry>(new LocalInitEntry());
  // check default attributes
  ASSERT_EQ(localInit->getParFile(), "");
  ASSERT_EQ(localInit->getParId(), "");

  localInit->setParFile("file.par");
  localInit->setParId("42");

  ASSERT_EQ(localInit->getParFile(), "file.par");
  ASSERT_EQ(localInit->getParId(), "42");
}

}  // namespace job
