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
 * @file  TLXmlExporter.cpp
 * @brief Dynawo timeline xml exporter : implementation file
 *
 */
#include <fstream>
#include <sstream>
#include <iomanip>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"
#include "TLXmlExporter.h"
#include "TLTimeline.h"

using std::fstream;
using std::ostream;
using std::string;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace timeline {

void
XmlExporter::exportToFile(const boost::shared_ptr<Timeline>& timeline, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(timeline, file);
  file.close();
}

void
XmlExporter::exportToStream(const boost::shared_ptr<Timeline>& timeline, ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("timeline", attrs);
  for (Timeline::event_const_iterator itEvent = timeline->cbeginEvent();
          itEvent != timeline->cendEvent();
          ++itEvent) {
    if ((*itEvent)->hasPriority() && maxPriority_ != boost::none && (*itEvent)->getPriority() > maxPriority_)
      continue;
    attrs.clear();
    if (exportWithTime_) {
      std::ostringstream ss;
      double time = (*itEvent)->getTime();
      ss << std::fixed << std::setprecision(DYN::getPrecisionAsNbDecimal()) << time;
      attrs.add("time", ss.str());
    }
    attrs.add("modelName", (*itEvent)->getModelName());
    attrs.add("message", (*itEvent)->getMessage());
    if ((*itEvent)->hasPriority()) {
      attrs.add("priority", (*itEvent)->getPriority());
    }
    formatter->startElement("event", attrs);
    formatter->endElement();  // event
  }
  formatter->endElement();  // timeline
  formatter->endDocument();
}



}  // namespace timeline
