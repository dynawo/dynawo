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
 * @file  TLTxtExporter.cpp
 * @brief Dynawo timeline txt exporter : implementation file
 */
#include <fstream>
#include <iostream>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"
#include "TLTxtExporter.h"
#include "TLTimeline.h"

using std::fstream;
using std::ostream;

namespace timeline {

void
TxtExporter::exportToFile(const boost::shared_ptr<Timeline>& timeline, const std::string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(timeline, file);
  file.close();
}

void
TxtExporter::exportToStream(const boost::shared_ptr<Timeline>& timeline, ostream& stream) const {
  const std::string TXTEXPORTER_SEPARATOR = " | ";  ///< definition of the separator to use in txt files
  for (const auto& event : timeline->getEvents()) {
    if (event->hasPriority() && maxPriority_ != boost::none && event->getPriority() > maxPriority_)
      continue;
    if (exportWithTime_)
      stream << DYN::double2String(event->getTime())
              << TXTEXPORTER_SEPARATOR;
    stream << event->getModelName()
            << TXTEXPORTER_SEPARATOR
            << event->getMessage();
    if (event->hasPriority()) {
      stream << TXTEXPORTER_SEPARATOR
              << event->getPriority();
    }
    stream << "\n";
  }
}

}  // namespace timeline
