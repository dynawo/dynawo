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

#include "DYNCommon.h"
#include "DYNDelay.h"
#include "DYNDelayManager.h"
#include "gtest_dynawo.h"

TEST(CommonTest, testDelayClass) {
  double time = 1;
  double value = 1.1;
  DYN::Delay delay(&time, &value, 3.);

  delay.saveTimepoint();

  time = 2;
  value = 2.2;
  delay.saveTimepoint();
  time = 3;
  value = 3.3;
  delay.saveTimepoint();
  time = 4;
  value = 4.4;
  delay.saveTimepoint();
  time = 5;
  value = 5.5;
  delay.saveTimepoint();

  ASSERT_EQ(delay.size(), 5);
  ASSERT_EQ(*(delay.initialValue()), 1.1);

  time = 5;
  double val = delay.getDelay(2);
  ASSERT_EQ(val, 3.3);

  time = 6;
  val = delay.getDelay(0);
  ASSERT_TRUE(DYN::doubleEquals(val, 6.6));

  time = 5;
  val = delay.getDelay(1.5);
  ASSERT_EQ(val, 3.85);

  time = 4;
  val = delay.getDelay(0.5);
  ASSERT_EQ(val, 3.85);

  try {
    time = 5;
    val = delay.getDelay(4);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  try {
    time = 5;
    val = delay.getDelay(-1);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  std::vector<std::pair<double, double> > vec;
  delay.points(vec);
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

TEST(CommonTest, testDelayClassParameters) {
  std::vector<std::pair<double, double> > values;
  values.push_back(std::make_pair(1., 1.1));
  values.push_back(std::make_pair(2., 2.2));
  values.push_back(std::make_pair(3., 3.3));
  values.push_back(std::make_pair(4., 4.4));
  values.push_back(std::make_pair(5., 5.5));

  DYN::Delay delay(values);

  std::vector<std::pair<double, double> > vec;
  delay.points(vec);
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

TEST(CommonTest, testDelayManagerClass) {
  DYN::DelayManager manager;

  double time = 1;
  double value = 1.1;

  size_t id = 10;
  manager.addDelay(id, &time, &value, 3.);

  size_t id2 = 20;
  double time2 = 1;
  double value2 = 1.1;
  manager.addDelay(id2, &time2, &value2, 1.5);

  manager.saveTimepoint();

  time = 2;
  value = 2.2;
  time2 = 2;
  value2 = 2.2;
  manager.saveTimepoint();

  time = 3;
  value = 3.3;
  time2 = 3;
  value2 = 3.3;
  manager.saveTimepoint();

  time = 4;
  value = 4.4;
  time2 = 4;
  value2 = 4.4;
  manager.saveTimepoint();

  time = 5;
  value = 5.5;
  time2 = 5;
  value2 = 5.5;
  manager.saveTimepoint();

  ASSERT_EQ(*(manager.getInitialValue(id)), 1.1);
  ASSERT_EQ((*manager.getInitialValue(id2)), 1.1);

  // global ids
  ASSERT_TRUE(manager.isIdAcceptable(id));
  ASSERT_TRUE(manager.isIdAcceptable(id2));
  ASSERT_FALSE(manager.isIdAcceptable(2));

  try {
    double val = manager.getDelay(2, 2);

    // exception should be raised
    ASSERT_TRUE(false);
  } catch (const std::exception& e) {
  }

  // for id
  double val = manager.getDelay(id, 2);
  ASSERT_EQ(val, 3.3);

  time = 6;
  val = manager.getDelay(id, 0);
  ASSERT_TRUE(DYN::doubleEquals(val, 6.6));

  time = 5;
  val = manager.getDelay(id, 1.5);
  ASSERT_EQ(val, 3.85);

  time = 4;
  val = manager.getDelay(id, 0.5);
  ASSERT_EQ(val, 3.85);

  try {
    time = 5;
    val = manager.getDelay(id, 4);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  try {
    val = manager.getDelay(id, -1);

    // exception should be caught
    ASSERT_TRUE(false);
  } catch (const DYN::Error& e) {
    ASSERT_EQ(e.type(), DYN::Error::SIMULATION);
    ASSERT_EQ(e.key(), DYN::KeyError_t::IncorrectDelay);
  }

  // for id 2
  time2 = 5;
  val = manager.getDelay(id2, 1.5);
  ASSERT_EQ(val, 3.85);
}

static bool
compare(const std::vector<std::string>& lhs, const std::vector<std::string>& rhs) {
  for (std::vector<std::string>::const_iterator it = lhs.begin(); it != lhs.end(); ++it) {
    if (std::find(rhs.begin(), rhs.end(), *it) == rhs.end()) {
      return false;
    }
  }

  return true;
}

TEST(CommonTest, testDelayManagerClassParameters) {
  std::string formatted1 = "10:1,1.1;2,2.2;3,3.3;4,4.4;5,5.5;";
  std::string formatted2 = "20:1,1.1;2,2.2;3,3.3;4,4.4;5,5.5;";
  std::vector<std::string> format;
  format.push_back(formatted1);
  format.push_back(formatted2);

  DYN::DelayManager manager;

  bool ok = manager.loadDelays(format);
  ASSERT_TRUE(ok);

  std::vector<std::string> formatted = manager.dumpDelays();
  ASSERT_TRUE(compare(formatted, format));
}
