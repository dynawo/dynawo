//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  TLJsonExporter.cpp
 * @brief Dynawo timeline JSON exporter : implementation file
 *
 */
#include <fstream>
#include <sstream>

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"
#include "TLJsonExporter.h"
#include "TLTimeline.h"

using std::fstream;
using std::ostream;
using std::string;
using boost::property_tree::ptree;

namespace timeline {

void
JsonExporter::exportToFile(const boost::shared_ptr<Timeline>& timeline, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(timeline, file);
  file.close();
}

void
JsonExporter::exportToStream(const boost::shared_ptr<Timeline>& timeline, ostream& stream) const {
  ptree root;
  ptree array;
  for (const auto& event : timeline->getEvents()) {
    if (event->hasPriority() && maxPriority_ != boost::none && event->getPriority() > maxPriority_)
      continue;
    ptree item;
    if (exportWithTime_)
      item.put("time", DYN::double2String(event->getTime()));
    item.put("modelName", event->getModelName());
    item.put("message", event->getMessage());
    if (event->hasPriority()) {
      item.put("priority", event->getPriority());
    }
    array.push_back(std::make_pair("", item));
  }
  root.push_back(std::make_pair("timeline", array));
  write_json(stream, root, false);
}
}  // namespace timeline
