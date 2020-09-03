//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file Common/Test.cpp
 * @brief Unit tests for Common lib
 *
 */

#include "DYNRingBuffer.h"
#include "gtest_dynawo.h"

TEST(CommonTest, testRingBufferClass) {
  DYN::RingBuffer buffer(3.);

  buffer.add(1, 1.1);  // will be kept only because delay and time are integers
  buffer.add(2, 2.2);
  buffer.add(3, 3.3);
  buffer.add(4, 4.4);
  buffer.add(5, 5.5);

  ASSERT_EQ(buffer.size(), 5);

  double value = buffer.get(5, 2);
  ASSERT_EQ(value, 3.3);

  value = buffer.get(5, -1);  // corresponding timepoint not in buffer
  ASSERT_EQ(value, 5.5);

  value = buffer.get(5, 1.5);
  ASSERT_EQ(value, 3.85);

  value = buffer.get(4, 0.5);
  ASSERT_EQ(value, 3.85);

  try {
    value = buffer.get(5, 4);
    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }
}

TEST(CommonTest, testRingBufferClassFloat) {
  DYN::RingBuffer buffer(1.5);

  buffer.add(1, 1.1);  // removed
  buffer.add(2, 2.2);  // removed
  buffer.add(3, 3.3);
  buffer.add(4, 4.4);
  buffer.add(5, 5.5);

  ASSERT_EQ(buffer.size(), 3);

  double value = buffer.get(5, 1.5);
  ASSERT_EQ(value, 3.85);
}
