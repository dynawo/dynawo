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
 * @file API/TL/test/TestExporter.cpp
 * @brief Unit tests for API_TL
 *
 */

#include "gtest_dynawo.h"

#include <boost/optional.hpp>

#include "TLTimeline.h"
#include "TLTimelineFactory.h"
#include "TLXmlExporter.h"
#include "TLCsvExporter.h"
#include "TLTxtExporter.h"
#include "TestUtil.h"

using boost::shared_ptr;

namespace timeline {

//-----------------------------------------------------
// TEST export in xml/csv/txt files and test message order in exported timeline file
//-----------------------------------------------------

TEST(APITLTest, TimelineExporters) {
  shared_ptr<Timeline> timeline = TimelineFactory::newInstance("timeline");
  boost::optional<int> priority1 = 10;
  boost::optional<int> priority2 = 5;
  boost::optional<int> priorityNone = boost::none;
  // add events to timeline (random order)
  timeline->addEvent(10, "model1", "event1 at 10s", priorityNone);
  timeline->addEvent(20, "model2", "event2 at 20s", priority1);
  timeline->addEvent(10, "model1", "event2 at 10s", priority2);
  timeline->addEvent(30, "model2", "event3 at 30s", priorityNone);
  timeline->addEvent(10, "model2", "event1 at 10s", priorityNone);

  // export the timeline in xml format
  XmlExporter exporterXML;
  ASSERT_NO_THROW(exporterXML.exportToFile(timeline, "testXmlTimelineExport.xml"));
  ASSERT_EQ(compareFiles("testXmlTimelineExport.xml", "res/testXmlTimelineExport.xml"), true);

  // export the timeline in csv format
  CsvExporter exporterCSV;
  ASSERT_NO_THROW(exporterCSV.exportToFile(timeline, "testCsvTimelineExport.csv"));
  ASSERT_EQ(compareFiles("testCsvTimelineExport.csv", "res/testCsvTimelineExport.csv"), true);

  // export the timeline in txt format
  TxtExporter exporterTXT;
  ASSERT_NO_THROW(exporterTXT.exportToFile(timeline, "testTxtTimelineExport.txt"));
  ASSERT_EQ(compareFiles("testTxtTimelineExport.txt", "res/testTxtTimelineExport.txt"), true);
}

}  // namespace timeline
