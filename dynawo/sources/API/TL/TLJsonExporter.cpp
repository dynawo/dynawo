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

#include <nlohmann/json.hpp>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"
#include "TLJsonExporter.h"
#include "TLTimeline.h"

using std::fstream;
using std::ostream;
using std::string;
using json = nlohmann::json;

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
  json j = json::array();

  for (const auto& event : timeline->getEvents()) {
    if (event->hasPriority() && maxPriority_ != boost::none && event->getPriority() > maxPriority_)
      continue;

    json eventJson;

    if (exportWithTime_)
      eventJson["time"] = event->getTime();

    eventJson["modelName"] = event->getModelName();
    eventJson["message"] = event->getMessage();

    if (event->hasPriority())
      eventJson["priority"] = event->getPriority();

    j.push_back(eventJson);
  }

  stream << j.dump() << "\n";
}
}  // namespace timeline
