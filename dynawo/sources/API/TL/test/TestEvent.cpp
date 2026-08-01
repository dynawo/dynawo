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
 * @file API/TL/test/TestEvent.cpp
 * @brief Unit tests for API_TL
 *
 */

#include "gtest_dynawo.h"
#include <boost/optional.hpp>
#include <boost/none.hpp>
#include "TLEvent.h"
#include "TLEventFactory.h"

using boost::shared_ptr;

namespace timeline {

//-----------------------------------------------------
// TEST check Event set and get functions
//-----------------------------------------------------

TEST(APITLTest, Event) {
  shared_ptr<Event> event = EventFactory::newEvent();

  ASSERT_EQ(event->getTime(), 0);
  ASSERT_EQ(event->getModelName(), "");
  ASSERT_EQ(event->getMessage(), "");

  event->setTime(1.2);
  event->setModelName("modelName");
  event->setMessage("message");
  boost::optional<int> priority = 12;
  event->setPriority(priority);

  ASSERT_EQ(event->getTime(), 1.2);
  ASSERT_EQ(event->getModelName(), "modelName");
  ASSERT_EQ(event->getMessage(), "message");
  ASSERT_EQ(event->getPriority(), 12);
}

}  // namespace timeline
