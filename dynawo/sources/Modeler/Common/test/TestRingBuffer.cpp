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
 * @file Common/Test.cpp
 * @brief Unit tests for Common lib
 *
 */

#include "DYNCommon.h"
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

  value = buffer.get(6, 0);  // corresponding timepoint not in buffer
  ASSERT_TRUE(DYN::doubleEquals(value, 6.6));

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

  try {
    value = buffer.get(5, -1);
    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  std::vector<std::pair<double, double> > vec;
  buffer.points(vec);
  ASSERT_EQ(vec[0].first, 1.);
  ASSERT_EQ(vec[0].second, 1.1);
  ASSERT_EQ(vec[1].first, 2.);
  ASSERT_EQ(vec[1].second, 2.2);
  ASSERT_EQ(vec[2].first, 3.);
  ASSERT_EQ(vec[2].second, 3.3);
  ASSERT_EQ(vec[3].first, 4.);
  ASSERT_EQ(vec[3].second, 4.4);
  ASSERT_EQ(vec[4].first, 5.);
  ASSERT_EQ(vec[4].second, 5.5);
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
