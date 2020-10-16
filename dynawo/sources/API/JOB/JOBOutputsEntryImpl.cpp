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
 * @file JOBOuputsEntryImpl.cpp
 * @brief Ouputs entry description : implementation file
 *
 */

#include "JOBOutputsEntryImpl.h"

namespace job {

OutputsEntry::Impl::Impl() :
outputsDirectory_("") {
}

OutputsEntry::Impl::~Impl() {
}

void
OutputsEntry::Impl::setOutputsDirectory(const std::string& outputsDirectory) {
  outputsDirectory_ = outputsDirectory;
}

std::string
OutputsEntry::Impl::getOutputsDirectory() const {
  return outputsDirectory_;
}

void
OutputsEntry::Impl::setInitValuesEntry(const boost::shared_ptr<InitValuesEntry>& initValuesEntry) {
  initValuesEntry_ = initValuesEntry;
}

boost::shared_ptr<InitValuesEntry>
OutputsEntry::Impl::getInitValuesEntry() const {
  return initValuesEntry_;
}

void
OutputsEntry::Impl::setConstraintsEntry(const boost::shared_ptr<ConstraintsEntry>& constraintsEntry) {
  constraintsEntry_ = constraintsEntry;
}

boost::shared_ptr<ConstraintsEntry>
OutputsEntry::Impl::getConstraintsEntry() const {
  return constraintsEntry_;
}

void
OutputsEntry::Impl::setTimelineEntry(const boost::shared_ptr<TimelineEntry>& timelineEntry) {
  timelineEntry_ = timelineEntry;
}

boost::shared_ptr<TimelineEntry>
OutputsEntry::Impl::getTimelineEntry() const {
  return timelineEntry_;
}

void
OutputsEntry::Impl::setTimestepsEntry(const boost::shared_ptr<TimestepsEntry>& timestepsEntry) {
  timestepsEntry_ = timestepsEntry;
}

boost::shared_ptr<TimestepsEntry>
OutputsEntry::Impl::getTimestepsEntry() const {
  return timestepsEntry_;
}

void
OutputsEntry::Impl::setFinalStateEntry(const boost::shared_ptr<FinalStateEntry>& finalStateEntry) {
  finalStateEntry_ = finalStateEntry;
}

boost::shared_ptr<FinalStateEntry>
OutputsEntry::Impl::getFinalStateEntry() const {
  return finalStateEntry_;
}

void
OutputsEntry::Impl::setCurvesEntry(const boost::shared_ptr<CurvesEntry>& curvesEntry) {
  curvesEntry_ = curvesEntry;
}

boost::shared_ptr<CurvesEntry>
OutputsEntry::Impl::getCurvesEntry() const {
  return curvesEntry_;
}

void
OutputsEntry::Impl::setLogsEntry(const boost::shared_ptr<LogsEntry>& logsEntry) {
  logsEntry_ = logsEntry;
}

boost::shared_ptr<LogsEntry>
OutputsEntry::Impl::getLogsEntry() const {
  return logsEntry_;
}

}  // namespace job
