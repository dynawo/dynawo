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

#include "gtest_dynawo.h"
#include "DYNBitMask.h"

namespace DYN {

TEST(BitMaskTest, testBitMask) {
  BitMask bitmask;
  ASSERT_EQ(bitmask.getFlags(0x01), false);
  ASSERT_EQ(bitmask.getFlags(0x02), false);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), false);
  ASSERT_EQ(bitmask.noFlagSet(), true);
  bitmask.setFlags(0x01);
  ASSERT_EQ(bitmask.getFlags(0x01), true);
  ASSERT_EQ(bitmask.getFlags(0x02), false);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), false);
  ASSERT_EQ(bitmask.noFlagSet(), false);
  bitmask.setFlags(0x02);
  ASSERT_EQ(bitmask.getFlags(0x01), true);
  ASSERT_EQ(bitmask.getFlags(0x02), true);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), false);
  ASSERT_EQ(bitmask.noFlagSet(), false);
  bitmask.unsetFlags(0x02);
  ASSERT_EQ(bitmask.getFlags(0x01), true);
  ASSERT_EQ(bitmask.getFlags(0x02), false);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), false);
  ASSERT_EQ(bitmask.noFlagSet(), false);
  bitmask.unsetFlags(0xFE);
  ASSERT_EQ(bitmask.getFlags(0x01), true);
  ASSERT_EQ(bitmask.getFlags(0x02), false);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), false);
  ASSERT_EQ(bitmask.noFlagSet(), false);
  bitmask.setFlags(0xFE);
  ASSERT_EQ(bitmask.getFlags(0x01), true);
  ASSERT_EQ(bitmask.getFlags(0x02), true);
  ASSERT_EQ(bitmask.getFlags(0x04), true);
  ASSERT_EQ(bitmask.getFlags(0x08), true);
  ASSERT_EQ(bitmask.getFlags(0x10), true);
  ASSERT_EQ(bitmask.getFlags(0x20), true);
  ASSERT_EQ(bitmask.getFlags(0x40), true);
  ASSERT_EQ(bitmask.getFlags(0x80), true);
  ASSERT_EQ(bitmask.noFlagSet(), false);
  bitmask.unsetFlags(0xFF);
  ASSERT_EQ(bitmask.getFlags(0x01), false);
  ASSERT_EQ(bitmask.getFlags(0x02), false);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), false);
  ASSERT_EQ(bitmask.noFlagSet(), true);
  bitmask.setFlags(0x02 | 0x80);
  ASSERT_EQ(bitmask.getFlags(0x01), false);
  ASSERT_EQ(bitmask.getFlags(0x02), true);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), true);
  ASSERT_EQ(bitmask.noFlagSet(), false);
  bitmask.reset();
  ASSERT_EQ(bitmask.getFlags(0x01), false);
  ASSERT_EQ(bitmask.getFlags(0x02), false);
  ASSERT_EQ(bitmask.getFlags(0x04), false);
  ASSERT_EQ(bitmask.getFlags(0x08), false);
  ASSERT_EQ(bitmask.getFlags(0x10), false);
  ASSERT_EQ(bitmask.getFlags(0x20), false);
  ASSERT_EQ(bitmask.getFlags(0x40), false);
  ASSERT_EQ(bitmask.getFlags(0x80), false);
  ASSERT_EQ(bitmask.noFlagSet(), true);
}

}  // namespace DYN
