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

#include "DYNDelay.h"
#include "DYNDelayManager.h"
#include "gtest_dynawo.h"

TEST(CommonTest, testDelayClassVar) {
  double value = 1.1;
  double delay_value = 2.;
  DYN::Delay delay(&value, &delay_value, 3.);

  delay.saveTimepoint(1);
  value = 2.2;
  delay.saveTimepoint(2);
  value = 3.3;
  delay.saveTimepoint(3);
  value = 4.4;
  delay.saveTimepoint(4);
  value = 5.5;
  delay.saveTimepoint(5);

  std::pair<double, double> val = delay.getDelay(5);
  ASSERT_EQ(val.first, 3);
  ASSERT_EQ(val.second, 3.3);

  delay_value = 0;
  val = delay.getDelay(6);
  ASSERT_EQ(val.first, 6);
  ASSERT_EQ(val.second, 5.5);

  delay_value = 1.5;
  val = delay.getDelay(5);
  ASSERT_EQ(val.first, 3.5);
  ASSERT_EQ(val.second, 3.85);

  delay_value = 0.5;
  val = delay.getDelay(4);
  ASSERT_EQ(val.first, 3.5);
  ASSERT_EQ(val.second, 3.85);

  try {
    delay_value = 4.;
    val = delay.getDelay(5);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  try {
    delay_value = -1;
    val = delay.getDelay(5);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }
}

TEST(CommonTest, testDelayClassFix) {
  double value = 1.1;
  DYN::Delay delay(&value, 1.5);

  delay.saveTimepoint(1);
  value = 2.2;
  delay.saveTimepoint(2);
  value = 3.3;
  delay.saveTimepoint(3);
  value = 4.4;
  delay.saveTimepoint(4);
  value = 5.5;
  delay.saveTimepoint(5);

  std::pair<double, double> val = delay.getDelay(5);
  ASSERT_EQ(val.first, 3.5);
  ASSERT_EQ(val.second, 3.85);
}

TEST(CommonTest, testDelayManagerClass) {
  DYN::DelayManager manager;

  double value = 1.1;
  double delay_value = 2.;
  size_t id = manager.addDelay(&value, &delay_value, 3.);

  double value2 = 1.1;
  size_t id2 = manager.addDelay(&value2, 1.5);

  manager.saveTimepoint(id, 1);
  manager.saveTimepoint(id2, 1);

  value = 2.2;
  manager.saveTimepoint(id, 2);

  value2 = 2.2;
  manager.saveTimepoint(id2, 2);

  value = 3.3;
  manager.saveTimepoint(id, 3);

  value2 = 3.3;
  manager.saveTimepoint(id2, 3);

  value = 4.4;
  manager.saveTimepoint(id, 4);

  value2 = 4.4;
  manager.saveTimepoint(id2, 4);

  value = 5.5;
  manager.saveTimepoint(id, 5);

  value2 = 5.5;
  manager.saveTimepoint(id2, 5);

  // global ids
  ASSERT_TRUE(manager.isIdAcceptable(id));
  ASSERT_TRUE(manager.isIdAcceptable(id2));
  ASSERT_FALSE(manager.isIdAcceptable(2));

  try {
    std::pair<double, double> val = manager.getDelay(2, 5);

    // exception should be raised
    ASSERT_TRUE(false);
  } catch (const std::exception& e) {
  }

  // for id
  std::pair<double, double> val = manager.getDelay(id, 5);
  ASSERT_EQ(val.first, 3);
  ASSERT_EQ(val.second, 3.3);

  delay_value = 0;
  val = manager.getDelay(id, 6);
  ASSERT_EQ(val.first, 6);
  ASSERT_EQ(val.second, 5.5);

  delay_value = 1.5;
  val = manager.getDelay(id, 5);
  ASSERT_EQ(val.first, 3.5);
  ASSERT_EQ(val.second, 3.85);

  delay_value = 0.5;
  val = manager.getDelay(id, 4);
  ASSERT_EQ(val.first, 3.5);
  ASSERT_EQ(val.second, 3.85);

  try {
    delay_value = 4.;
    val = manager.getDelay(id, 5);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  try {
    delay_value = -1;
    val = manager.getDelay(id, 5);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  // for id 2
  val = manager.getDelay(id2, 5);
  ASSERT_EQ(val.first, 3.5);
  ASSERT_EQ(val.second, 3.85);
}
