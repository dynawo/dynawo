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

/**
 * @file Common/DYNAddEvent.cpp
 * @brief Unit tests for the DYNAddEvent() macro
 *
 */

#include "DYNMacrosMessage.h"
#include "TLTimelineFactory.h"

#include "gtest_dynawo.h"

#include <boost/shared_ptr.hpp>

#include <string>

class Tiny {
 public:
  inline Tiny() : time_(3.14) {}

  inline bool
  hasTimeline() const {
    return timeline_.use_count() != 0;
  }

  inline const boost::shared_ptr<timeline::Timeline>&
  getTimeline() const {
    return timeline_;
  }

  void
  setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline) {
    timeline_ = timeline;
  }

  inline double
  getCurrentTime() const {
    return time_;
  }

 private:
  boost::shared_ptr<timeline::Timeline> timeline_;
  double time_;
};

TEST(CommonTest, DYNAddEvent) {
  Tiny T;
  ASSERT_FALSE(T.hasTimeline());
  ASSERT_DOUBLE_EQ(T.getCurrentTime(), 3.14);

  Tiny* p(&T);
  boost::shared_ptr<timeline::Timeline> timeline = timeline::TimelineFactory::newInstance("timeline");
  T.setTimeline(timeline);
  ASSERT_TRUE(p->hasTimeline());

  DYNAddEvent(p, "model", DYN::KeyTimeline_t::OverloadOpen);
  {
    timeline::Timeline::event_const_iterator it(timeline->cbeginEvent());
    std::string s(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::OverloadOpen));
    ASSERT_EQ(it->get()->getMessage(), s);
  }

  DYNAddEvent(p, "model", DYN::KeyTimeline_t::OverloadOpen, "test");
  {
    timeline::Timeline::event_const_iterator it(timeline->cbeginEvent());
    std::string s(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::OverloadOpen));
    s += " test";
    ASSERT_EQ((++it)->get()->getMessage(), s);
  }

  DYNAddEvent(p, "model", DYN::KeyTimeline_t::OverloadOpen, "test", "and", "another", "test", "and", "a", "few", "words", 666);
  {
    timeline::Timeline::event_const_iterator it(timeline->cbeginEvent());
    std::string s(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::OverloadOpen));
    s += " test and another test and a few words 666";
    ASSERT_EQ((++++it)->get()->getMessage(), s);
  }

  DYNAddEvent(p, "model2", DYN::KeyTimeline_t::OverloadDown, "test", 3.14, 5, "end");
  {
    timeline::Timeline::event_const_iterator it(timeline->cendEvent());
    std::string s(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::OverloadDown));
    s += " test 3.14 5 end";
    ASSERT_EQ((--it)->get()->getMessage(), s);
  }

  ASSERT_EQ(timeline->getSizeEvents(), 4);
}
