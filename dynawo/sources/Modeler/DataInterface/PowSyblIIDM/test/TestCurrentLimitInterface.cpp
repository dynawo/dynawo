//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "DYNCurrentLimitInterfaceIIDM.h"

#include "gtest_dynawo.h"


namespace DYN {

TEST(DataInterfaceTest, CurrentLimit) {
  DYN::CurrentLimitInterfaceIIDM C(1.0, 99, false);
  ASSERT_DOUBLE_EQ(C.getLimit(), 1);
  ASSERT_EQ(C.getAcceptableDuration(), 99);
  ASSERT_FALSE(C.isFictitious());

  DYN::CurrentLimitInterfaceIIDM D(std::numeric_limits<double>::max(), 9876UL, false);
  ASSERT_TRUE(std::isnan(D.getLimit()));
  ASSERT_EQ(D.getAcceptableDuration(), 9876);
  ASSERT_FALSE(C.isFictitious());

  DYN::CurrentLimitInterfaceIIDM E(-1000, std::numeric_limits<unsigned long>::max(), false);
  ASSERT_DOUBLE_EQ(E.getLimit(), -1000);
  ASSERT_EQ(E.getAcceptableDuration(), std::numeric_limits<int>::max());
  ASSERT_FALSE(C.isFictitious());

  DYN::CurrentLimitInterfaceIIDM F(1.0, std::numeric_limits<unsigned long>::max(), true);
  ASSERT_DOUBLE_EQ(F.getLimit(), 1);
  ASSERT_EQ(F.getAcceptableDuration(), std::numeric_limits<int>::max());
  ASSERT_TRUE(F.isFictitious());
}  // TEST(DataInterfaceTest, CurrentLimit)
}  // namespace DYN
