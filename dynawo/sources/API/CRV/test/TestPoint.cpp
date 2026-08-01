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
 * @file API/CRV/test/TestPoint.cpp
 * @brief Unit tests for API_CRV
 *
 */

#include "gtest_dynawo.h"

#include "CRVPointFactory.h"
#include "CRVPoint.h"

namespace curves {

//-----------------------------------------------------
// TEST build Point
//-----------------------------------------------------

TEST(APICRVTest, Point) {
  const std::unique_ptr<Point> point = PointFactory::newPoint(5.2, 3.5);

  ASSERT_EQ(point->getTime(), 5.2);
  ASSERT_EQ(point->getValue(), 3.5);

  point->setTime(10.7);
  point->setValue(1.6);
  ASSERT_EQ(point->getTime(), 10.7);
  ASSERT_EQ(point->getValue(), 1.6);
}

}  // namespace curves
