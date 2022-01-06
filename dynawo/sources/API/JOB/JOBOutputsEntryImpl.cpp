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

#include "JOBLogsEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBConstraintsEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBFinalStateEntry.h"

#include <boost/make_shared.hpp>

namespace job {

void OutputsEntry::Impl::copy(const OutputsEntry::Impl& other) {
  outputsDirectory_ = other.outputsDirectory_;

  initValuesEntry_ = other.initValuesEntry_ ? other.initValuesEntry_->clone() : boost::shared_ptr<InitValuesEntry>();
  constraintsEntry_ = other.constraintsEntry_ ? other.constraintsEntry_->clone() : boost::shared_ptr<ConstraintsEntry>();
  timelineEntry_ = other.timelineEntry_ ? other.timelineEntry_->clone() : boost::shared_ptr<TimelineEntry>();
  curvesEntry_ = other.curvesEntry_ ? other.curvesEntry_->clone() : boost::shared_ptr<CurvesEntry>();
  logsEntry_ = other.logsEntry_ ? other.logsEntry_->clone() : boost::shared_ptr<LogsEntry>();

  finalStateEntries_.reserve(other.finalStateEntries_.size());
  for (std::vector<boost::shared_ptr<FinalStateEntry> >::const_iterator it = other.finalStateEntries_.begin(); it != other.finalStateEntries_.end(); ++it) {
    finalStateEntries_.push_back((*it)->clone());
  }
}

boost::shared_ptr<OutputsEntry>
OutputsEntry::Impl::clone() const {
  boost::shared_ptr<OutputsEntry::Impl> newPtr = boost::make_shared<OutputsEntry::Impl>();
  newPtr->copy(*this);
  return newPtr;
}

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
OutputsEntry::Impl::addFinalStateEntry(const boost::shared_ptr<FinalStateEntry>& finalStateEntry) {
  finalStateEntries_.push_back(finalStateEntry);
}

const std::vector<boost::shared_ptr<FinalStateEntry> >&
OutputsEntry::Impl::getFinalStateEntries() const {
    return finalStateEntries_;
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
