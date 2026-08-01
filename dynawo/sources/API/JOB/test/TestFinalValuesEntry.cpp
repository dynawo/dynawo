//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
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
 * @file API/JOB/test/TestFinalValuesEntry.cpp
 * @brief Unit tests for API_JOB/FinalValuesEntry class
 *
 */

#include "gtest_dynawo.h"
#include "JOBFinalValuesEntry.h"

namespace job {

TEST(APIJOBTest, testFinalValuesEntry) {
    boost::shared_ptr<FinalValuesEntry> finalValues = boost::shared_ptr<FinalValuesEntry>(new FinalValuesEntry());
    // check default attribute
    ASSERT_FALSE(finalValues->getDumpFinalValues());

    finalValues->setDumpFinalValues(true);
    ASSERT_TRUE(finalValues->getDumpFinalValues());
}

}  // namespace job
