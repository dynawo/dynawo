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
 * @file JOBTimelineEntry.cpp
 * @brief Timeline entry description : implementation file
 *
 */

#include "JOBTimelineEntry.h"
#include "DYNExecUtils.h"

namespace job {

TimelineEntry::TimelineEntry() :
    outputFile_(""),
    exportMode_(""),
    exportWithTime_(true),
    maxPriority_(boost::none) {
  filter_ = hasEnvVar("DYNAWO_FILTER_TIMELINE");
}

void
TimelineEntry::setOutputFile(const std::string& outputFile) {
  outputFile_ = outputFile;
}

void
TimelineEntry::setExportMode(const std::string& exportMode) {
  exportMode_ = exportMode;
}

void
TimelineEntry::setExportWithTime(const bool exportWithTime) {
  exportWithTime_ = exportWithTime;
}

void
TimelineEntry::setMaxPriority(const boost::optional<int> maxPriority) {
  maxPriority_ = maxPriority;
}

const std::string&
TimelineEntry::getOutputFile() const {
  return outputFile_;
}

const std::string&
TimelineEntry::getExportMode() const {
  return exportMode_;
}

bool
TimelineEntry::getExportWithTime() const {
  return exportWithTime_;
}

boost::optional<int>
TimelineEntry::getMaxPriority() const {
  return maxPriority_;
}

void
TimelineEntry::setFilter(bool filter) {
  filter_ = filter;
}

bool
TimelineEntry::isFilter() const {
  return filter_;
}

}  // namespace job
