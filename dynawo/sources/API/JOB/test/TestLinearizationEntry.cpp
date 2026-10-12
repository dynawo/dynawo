//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file API/JOB/test/TestLinearizationEntry.cpp
 * @brief Unit tests for API_JOB/JOBLinearizationEntry class
 *
 */

#include "JOBLinearizationEntry.h"
#include "gtest_dynawo.h"

namespace job {

TEST(APIJOBTest, testLinearizationEntry) {
  std::shared_ptr<LinearizationEntry> linearizationEntry = std::make_shared<LinearizationEntry>();
  // check default attributes
  ASSERT_EQ(linearizationEntry->getTime(), 0.);
  ASSERT_EQ(linearizationEntry->getExportMode(), "TXT");

  linearizationEntry->setTime(10.5);
  linearizationEntry->setExportMode("OTHER");

  ASSERT_EQ(linearizationEntry->getTime(), 10.5);
  ASSERT_EQ(linearizationEntry->getExportMode(), "OTHER");
}

}  // namespace job
