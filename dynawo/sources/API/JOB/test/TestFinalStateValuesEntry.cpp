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
 * @file API/JOB/test/TestFinalStateValuesEntry.cpp
 * @brief Unit tests for API_JOB/JOBFinalStateValuesEntry class
 *
 */

#include "JOBFinalStateValuesEntry.h"
#include "gtest_dynawo.h"

namespace job {

TEST(APIJOBTest, testFinalStateValuesEntry) {
  boost::shared_ptr<FinalStateValuesEntry> finalStateValuesEntry = boost::shared_ptr<FinalStateValuesEntry>(new FinalStateValuesEntry());
  // check default attributes
  ASSERT_EQ(finalStateValuesEntry->getInputFile(), "");
  ASSERT_EQ(finalStateValuesEntry->getExportMode(), "CSV");

  finalStateValuesEntry->setInputFile("input.fsv");
  finalStateValuesEntry->setExportMode("XML");

  ASSERT_EQ(finalStateValuesEntry->getInputFile(), "input.fsv");
  ASSERT_EQ(finalStateValuesEntry->getExportMode(), "XML");
}

}  // namespace job
