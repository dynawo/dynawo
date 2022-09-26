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
 * @file API/TL/test/TestTimeline.cpp
 * @brief Unit tests for API_TL
 *
 */

#include "DYNCommon.h"
#include "gtest_dynawo.h"

#include "TLTimeline.h"
#include "TLTimelineFactory.h"
#include "TLEvent.h"

using boost::shared_ptr;
using DYN::doubleEquals;

namespace timeline {

//-----------------------------------------------------
// TEST check timeline factory
//-----------------------------------------------------

TEST(APITLTest, TimelineFactory) {
  boost::shared_ptr<Timeline> timeline1 = TimelineFactory::newInstance("timeline");

  boost::shared_ptr<Timeline> timeline2;
  boost::shared_ptr<Timeline> timeline3;

  Timeline& refTimeline1(*timeline1);

  ASSERT_NO_THROW(timeline2 = TimelineFactory::copyInstance(timeline1));
  ASSERT_NO_THROW(timeline3 = TimelineFactory::copyInstance(refTimeline1));
}

//-----------------------------------------------------
// TEST add several events to a timeline
//-----------------------------------------------------

TEST(APITLTest, TimelineAddEvent) {
  boost::shared_ptr<Timeline> timeline = TimelineFactory::newInstance("timeline");

  boost::optional<int> priority2 = 2;
  boost::optional<int> priority4 = 4;
  boost::optional<int> priorityNone = boost::none;

  // add events to timeline
  timeline->addEvent(10, "model1", "event1 at 10s", priorityNone, "");
  timeline->addEvent(10, "model1", "event2 at 10s", priority2, "");  // same time, same model, different message
  timeline->addEvent(10, "model2", "event3 at 10s", priority4, "");  // same time, different model
  timeline->addEvent(20, "model2", "event2 at 20s", priorityNone, "");  // different time

  // test const iterator
  int nbEvents = 0;
  for (Timeline::event_const_iterator itEvent = timeline->cbeginEvent();
          itEvent != timeline->cendEvent();
          ++itEvent)
    ++nbEvents;
  ASSERT_EQ(nbEvents, timeline->getSizeEvents());

  Timeline::event_const_iterator itVariablec(timeline->cbeginEvent());
  ASSERT_EQ((++itVariablec)->get()->getMessage(), "event2 at 10s");
  ASSERT_EQ((--itVariablec)->get()->getMessage(), "event1 at 10s");
  ASSERT_EQ((itVariablec++)->get()->getMessage(), "event1 at 10s");
  ASSERT_EQ((itVariablec--)->get()->getMessage(), "event2 at 10s");
}

//-----------------------------------------------------
// TEST remove several events from a timeline
//-----------------------------------------------------

TEST(APITLTest, TimelineEraseEvents) {
  boost::shared_ptr<Timeline> timeline = TimelineFactory::newInstance("timeline");

  boost::optional<int> priority2 = 2;
  boost::optional<int> priority4 = 4;
  boost::optional<int> priorityNone = boost::none;

  // add events to timeline
  timeline->addEvent(10, "model1", "event1 at 10s", priorityNone, "");
  timeline->addEvent(10, "model1", "event2 at 10s", priority2, "");  // same time, same model, different message
  timeline->addEvent(10, "model2", "event3 at 10s", priority4, "");  // same time, different model
  timeline->addEvent(10, "model2", "event3 at 10s", priority4, "");  // same event
  timeline->addEvent(20, "model2", "event2 at 20s", priorityNone, "");  // different time

  // remove events 2 and 3 from the timeline
  ASSERT_EQ(4, timeline->getSizeEvents());
  Timeline::event_const_iterator startingEvent = timeline->cbeginEvent();
  ASSERT_EQ(startingEvent->get()->getMessage(), "event1 at 10s");
  ASSERT_EQ((++startingEvent)->get()->getMessage(), "event2 at 10s");
  ASSERT_EQ((++startingEvent)->get()->getMessage(), "event3 at 10s");
  ASSERT_EQ((++startingEvent)->get()->getMessage(), "event2 at 20s");
  timeline->eraseEvents(2);
  ASSERT_EQ(2, timeline->getSizeEvents());
  startingEvent = timeline->cbeginEvent();
  ASSERT_EQ(startingEvent->get()->getMessage(), "event1 at 10s");
  ASSERT_EQ((++startingEvent)->get()->getMessage(), "event2 at 10s");
}

TEST(APITLTest, TimelineFilter) {
  boost::optional<int> priorityNone = boost::none;
  boost::shared_ptr<Timeline> timeline = TimelineFactory::newInstance("timeline");

  timeline->addEvent(0, "GEN____8_SM", "PMIN : activation", priorityNone, "ActivatePMIN");

  timeline->addEvent(0.0306911, "GEN____3_SM", "PMIN : activation", priorityNone, "ActivatePMIN");
  timeline->addEvent(0.0306911, "GEN____3_SM", "PMIN : deactivation", priorityNone, "DeactivatePMIN");

  timeline->addEvent(0.348405, "GEN____8_SM", "PMIN : deactivation", priorityNone, "DeactivatePMIN");
  timeline->addEvent(0.348405, "GEN____8_SM", "PMIN : deactivation", priorityNone, "DeactivatePMIN");
  timeline->addEvent(0.348405, "GEN____3_SM", "PMIN : deactivation", priorityNone, "DeactivatePMIN");

  timeline->addEvent(0.828675, "GEN____3_SM", "PV Generator : back to voltage regulation", priorityNone, "GeneratorPVBackRegulation");
  timeline->addEvent(0.828675, "GEN____3_SM", "PV Generator : max reactive power limit reached", priorityNone, "GeneratorPVMaxQ");
  timeline->addEvent(0.828675, "GEN____3_SM", "PV Generator : back to voltage regulation", priorityNone, "GeneratorPVBackRegulation");

  timeline->addEvent(0.900000, "GEN____3_SM", "PV Generator : back to voltage regulation", priorityNone, "GeneratorPVBackRegulation");
  timeline->addEvent(0.900000, "GEN____3_SM", "PV Generator : min reactive power limit reached", priorityNone, "GeneratorPVMinQ");
  timeline->addEvent(0.900000, "GEN____3_SM", "PV Generator : back to voltage regulation", priorityNone, "GeneratorPVBackRegulation");

  timeline->addEvent(0.910000, "GEN____3_SM", "PV Generator : back to voltage regulation", priorityNone, "GeneratorPVBackRegulation");
  timeline->addEvent(0.910000, "GEN____3_SM", "PV Generator : min reactive power limit reached", priorityNone, "GeneratorPVMinQ");
  timeline->addEvent(0.910000, "GEN____3_SM", "PV Generator : max reactive power limit reached", priorityNone, "GeneratorPVMaxQ");

  std::unordered_map<std::string, std::unordered_set<std::string>> oppositeEventDico;
  oppositeEventDico["ActivatePMIN"].insert("DeactivatePMIN");
  oppositeEventDico["DeactivatePMIN"].insert("ActivatePMIN");
  oppositeEventDico["GeneratorPVBackRegulation"].insert("GeneratorPVMaxQ");
  oppositeEventDico["GeneratorPVMaxQ"].insert("GeneratorPVBackRegulation");
  oppositeEventDico["GeneratorPVBackRegulation"].insert("GeneratorPVMinQ");
  oppositeEventDico["GeneratorPVMinQ"].insert("GeneratorPVBackRegulation");
  timeline->filter(oppositeEventDico);

  unsigned index = 0;
  for (Timeline::event_const_iterator itEvent = timeline->cbeginEvent();
          itEvent != timeline->cendEvent();
          ++itEvent) {
    if (index == 0) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____8_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PMIN : activation");
    } else if (index == 1) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0.0306911);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____3_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PMIN : deactivation");
    } else if (index == 2) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0.348405);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____8_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PMIN : deactivation");
    } else if (index == 3) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0.348405);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____3_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PMIN : deactivation");
    } else if (index == 4) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0.828675);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____3_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PV Generator : back to voltage regulation");
    } else if (index == 5) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0.9);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____3_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PV Generator : back to voltage regulation");
    } else if (index == 6) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0.91);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____3_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PV Generator : min reactive power limit reached");
    } else if (index == 7) {
      ASSERT_DOUBLE_EQUALS_DYNAWO((*itEvent)->getTime(), 0.91);
      ASSERT_EQ((*itEvent)->getModelName(), "GEN____3_SM");
      ASSERT_EQ((*itEvent)->getMessage(), "PV Generator : max reactive power limit reached");
    }
    ++index;
  }
  ASSERT_EQ(index, 8);
}
}  // namespace timeline
