//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "DYNCurrentLimitInterfaceIIDM.h"

#include "gtest_dynawo.h"


namespace DYN {

TEST(DataInterfaceTest, CurrentLimit) {
  DYN::CurrentLimitInterfaceIIDM C(1.0, 99);
  ASSERT_DOUBLE_EQ(C.getLimit(), 1);
  ASSERT_EQ(C.getAcceptableDuration(), 99);

  DYN::CurrentLimitInterfaceIIDM D(std::numeric_limits<double>::max(), 9876UL);
  ASSERT_TRUE(std::isnan(D.getLimit()));
  ASSERT_EQ(D.getAcceptableDuration(), 9876);

  DYN::CurrentLimitInterfaceIIDM E(-1000, std::numeric_limits<unsigned long>::max());
  ASSERT_DOUBLE_EQ(E.getLimit(), -1000);
  ASSERT_EQ(E.getAcceptableDuration(), std::numeric_limits<int>::max());
}  // TEST(DataInterfaceTest, CurrentLimit)
}  // namespace DYN
