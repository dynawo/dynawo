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

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"
#include "DYNXmlStreamWriter.h"
#include "TLXmlExporter.h"
#include "TLTimeline.h"

namespace timeline {

void
XmlExporter::exportToFile(const boost::shared_ptr<Timeline>& timeline, const std::string& filePath) const {
  std::fstream file;
  file.open(filePath.c_str(), std::fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(timeline, file);
  file.close();
}

void
XmlExporter::exportToStream(const boost::shared_ptr<Timeline>& timeline, std::ostream& stream) const {
  DYN::XmlStreamWriter writer(stream, true);

  writer.writeStartDocument("ISO-8859-1", "1.0");
  writer.writeStartElement("timeline");
  writer.writeAttribute("xmlns", "http://www.rte-france.com/dynawo");

  for (Timeline::event_const_iterator itEvent = timeline->cbeginEvent();
          itEvent != timeline->cendEvent();
          ++itEvent) {
    if ((*itEvent)->hasPriority() && maxPriority_ != boost::none && (*itEvent)->getPriority() > maxPriority_)
      continue;
    writer.writeStartElement("event");
    if (exportWithTime_) {
      writer.writeAttribute("time", DYN::double2String((*itEvent)->getTime()));
    }
    writer.writeAttribute("modelName", (*itEvent)->getModelName());
    writer.writeAttribute("message", (*itEvent)->getMessage());
    if ((*itEvent)->hasPriority()) {
      writer.writeAttribute("priority", (*itEvent)->getPriority());
    }
    writer.writeEndElement();
  }

  writer.writeEndElement();  // timeline
  writer.writeEndDocument();
}

}  // namespace timeline
