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
#include "TLJsonExporter.h"
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
  timeline->addEvent(10, "model1", "event1 at 10s", priorityNone, "");
  timeline->addEvent(10, "model1", "event2 at 10s", priority2, "");
  timeline->addEvent(10, "model1", "event2 at 10s", priority2, "");
  timeline->addEvent(10, "model2", "event1 at 10s", priorityNone, "");
  timeline->addEvent(20, "model2", "event2 at 20s", priority1, "");
  timeline->addEvent(30, "model2", "event3 at 30s", priorityNone, "");

  // export the timeline in xml format
  XmlExporter exporterXML;
  exporterXML.setExportWithTime(true);
  ASSERT_NO_THROW(exporterXML.exportToFile(timeline, "testXmlTimelineExport.xml"));
  ASSERT_TRUE(compareFiles("testXmlTimelineExport.xml", "res/testXmlTimelineExport.xml"));
  {
    std::stringstream ss;
    exporterXML.exportToStream(timeline, ss, 10);
    ASSERT_EQ(ss.str(), "<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>\n"
                        "<timeline xmlns=\"http://www.rte-france.com/dynawo\">\n"
                        "  <event time=\"20.000000\" modelName=\"model2\" message=\"event2 at 20s\" priority=\"10\"/>\n"
                        "  <event time=\"30.000000\" modelName=\"model2\" message=\"event3 at 30s\"/>\n"
                        "</timeline>\n");
  }
  exporterXML.setMaxPriority(priority2);
  ASSERT_NO_THROW(exporterXML.exportToFile(timeline, "testXmlTimelineExportMaxPriority.xml"));
  ASSERT_TRUE(compareFiles("testXmlTimelineExportMaxPriority.xml", "res/testXmlTimelineExportMaxPriority.xml"));
  exporterXML.setMaxPriority(priorityNone);
  exporterXML.setExportWithTime(false);
  ASSERT_NO_THROW(exporterXML.exportToFile(timeline, "testXmlTimelineExportWithoutTime.xml"));
  ASSERT_TRUE(compareFiles("testXmlTimelineExportWithoutTime.xml", "res/testXmlTimelineExportWithoutTime.xml"));

  // export the timeline in csv format
  CsvExporter exporterCSV;
  exporterCSV.setExportWithTime(true);
  ASSERT_NO_THROW(exporterCSV.exportToFile(timeline, "testCsvTimelineExport.csv"));
  ASSERT_TRUE(compareFiles("testCsvTimelineExport.csv", "res/testCsvTimelineExport.csv"));
  {
    std::stringstream ss;
    exporterCSV.exportToStream(timeline, ss, 10);
    ASSERT_EQ(ss.str(), "20.000000;model2;event2 at 20s;10\n30.000000;model2;event3 at 30s\n");
  }
  exporterCSV.setMaxPriority(priority2);
  ASSERT_NO_THROW(exporterCSV.exportToFile(timeline, "testCsvTimelineExportMaxPriority.csv"));
  ASSERT_TRUE(compareFiles("testCsvTimelineExportMaxPriority.csv", "res/testCsvTimelineExportMaxPriority.csv"));
  exporterCSV.setMaxPriority(priorityNone);
  exporterCSV.setExportWithTime(false);
  ASSERT_NO_THROW(exporterCSV.exportToFile(timeline, "testCsvTimelineExportWithoutTime.csv"));
  ASSERT_TRUE(compareFiles("testCsvTimelineExportWithoutTime.csv", "res/testCsvTimelineExportWithoutTime.csv"));

  // export the timeline in txt format
  TxtExporter exporterTXT;
  exporterTXT.setExportWithTime(true);
  ASSERT_NO_THROW(exporterTXT.exportToFile(timeline, "testTxtTimelineExport.txt"));
  ASSERT_TRUE(compareFiles("testTxtTimelineExport.txt", "res/testTxtTimelineExport.txt"));
  {
    std::stringstream ss;
    exporterTXT.exportToStream(timeline, ss, 10);
    ASSERT_EQ(ss.str(), "20.000000 | model2 | event2 at 20s | 10\n30.000000 | model2 | event3 at 30s\n");
  }
  exporterTXT.setMaxPriority(priority2);
  ASSERT_NO_THROW(exporterTXT.exportToFile(timeline, "testTxtTimelineExportMaxPriority.txt"));
  ASSERT_TRUE(compareFiles("testTxtTimelineExportMaxPriority.txt", "res/testTxtTimelineExportMaxPriority.txt"));
  exporterTXT.setMaxPriority(priorityNone);
  exporterTXT.setExportWithTime(false);
  ASSERT_NO_THROW(exporterTXT.exportToFile(timeline, "testTxtTimelineExportWithoutTime.txt"));
  ASSERT_TRUE(compareFiles("testTxtTimelineExportWithoutTime.txt", "res/testTxtTimelineExportWithoutTime.txt"));

  // export the timeline in json format
  JsonExporter exporterJSON;
  exporterJSON.setExportWithTime(true);
  ASSERT_NO_THROW(exporterJSON.exportToFile(timeline, "testJsonTimelineExport.json"));
  ASSERT_TRUE(compareFiles("testJsonTimelineExport.json", "res/testJsonTimelineExport.json"));
  {
    std::stringstream ss;
    exporterJSON.exportToStream(timeline, ss, 10);
    ASSERT_EQ(ss.str(), "{\"timeline\":["
    "{\"time\":\"20.000000\",\"modelName\":\"model2\",\"message\":\"event2 at 20s\",\"priority\":\"10\"},"
    "{\"time\":\"30.000000\",\"modelName\":\"model2\",\"message\":\"event3 at 30s\"}]}\n");
  }
  exporterJSON.setMaxPriority(priority2);
  ASSERT_NO_THROW(exporterJSON.exportToFile(timeline, "testJsonTimelineExportMaxPriority.json"));
  ASSERT_TRUE(compareFiles("testJsonTimelineExportMaxPriority.json", "res/testJsonTimelineExportMaxPriority.json"));
  exporterJSON.setMaxPriority(priorityNone);
  exporterJSON.setExportWithTime(false);
  ASSERT_NO_THROW(exporterJSON.exportToFile(timeline, "testJsonTimelineExportWithoutTime.json"));
  ASSERT_TRUE(compareFiles("testJsonTimelineExportWithoutTime.json", "res/testJsonTimelineExportWithoutTime.json"));
}

}  // namespace timeline
