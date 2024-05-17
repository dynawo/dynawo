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
 * @file JOBOutputsEntry.cpp
 * @brief Ouputs entry description : implementation file
 *
 */

#include "JOBOutputsEntry.h"

#include "DYNClone.hpp"

namespace job {

OutputsEntry::OutputsEntry(const OutputsEntry& other) {
  copy(other);
}

OutputsEntry&
OutputsEntry::operator=(const OutputsEntry& other) {
  copy(other);
  return *this;
}

void
OutputsEntry::copy(const OutputsEntry& other) {
  outputsDirectory_ = other.outputsDirectory_;

  initValuesEntry_ = DYN::clone(other.initValuesEntry_);
  finalValuesEntry_ = DYN::clone(other.finalValuesEntry_);
  constraintsEntry_ = DYN::clone(other.constraintsEntry_);
  timelineEntry_ = DYN::clone(other.timelineEntry_);
  timetableEntry_ = DYN::clone(other.timetableEntry_);
  curvesEntry_ = DYN::clone(other.curvesEntry_);
  lostEquipmentsEntry_ = DYN::clone(other.lostEquipmentsEntry_);
  logsEntry_ = DYN::clone(other.logsEntry_);
  finalStateValuesEntry_ = DYN::clone(other.finalStateValuesEntry_);

  finalStateEntries_.reserve(other.finalStateEntries_.size());
  for (std::vector<boost::shared_ptr<FinalStateEntry> >::const_iterator it = other.finalStateEntries_.begin(); it != other.finalStateEntries_.end(); ++it) {
    finalStateEntries_.push_back(DYN::clone(*it));
  }
}

void
OutputsEntry::setOutputsDirectory(const std::string& outputsDirectory) {
  outputsDirectory_ = outputsDirectory;
}

const std::string&
OutputsEntry::getOutputsDirectory() const {
  return outputsDirectory_;
}

void
OutputsEntry::setInitValuesEntry(const boost::shared_ptr<InitValuesEntry>& initValuesEntry) {
  initValuesEntry_ = initValuesEntry;
}

boost::shared_ptr<InitValuesEntry>
OutputsEntry::getInitValuesEntry() const {
  return initValuesEntry_;
}

void
OutputsEntry::setFinalValuesEntry(const boost::shared_ptr<FinalValuesEntry>& finalValuesEntry) {
  finalValuesEntry_ = finalValuesEntry;
}

boost::shared_ptr<FinalValuesEntry>
OutputsEntry::getFinalValuesEntry() const {
  return finalValuesEntry_;
}

void
OutputsEntry::setConstraintsEntry(const boost::shared_ptr<ConstraintsEntry>& constraintsEntry) {
  constraintsEntry_ = constraintsEntry;
}

boost::shared_ptr<ConstraintsEntry>
OutputsEntry::getConstraintsEntry() const {
  return constraintsEntry_;
}

void
OutputsEntry::setTimelineEntry(const boost::shared_ptr<TimelineEntry>& timelineEntry) {
  timelineEntry_ = timelineEntry;
}

boost::shared_ptr<TimelineEntry>
OutputsEntry::getTimelineEntry() const {
  return timelineEntry_;
}

void
OutputsEntry::setTimetableEntry(const boost::shared_ptr<TimetableEntry>& timetableEntry) {
  timetableEntry_ = timetableEntry;
}

boost::shared_ptr<TimetableEntry>
OutputsEntry::getTimetableEntry() const {
  return timetableEntry_;
}

void
OutputsEntry::addFinalStateEntry(const boost::shared_ptr<FinalStateEntry>& finalStateEntry) {
  finalStateEntries_.push_back(finalStateEntry);
}

void
OutputsEntry::setCurvesEntry(const boost::shared_ptr<CurvesEntry>& curvesEntry) {
  curvesEntry_ = curvesEntry;
}

boost::shared_ptr<CurvesEntry>
OutputsEntry::getCurvesEntry() const {
  return curvesEntry_;
}

void
OutputsEntry::setFinalStateValuesEntry(const boost::shared_ptr<FinalStateValuesEntry>& finalStateValuesEntry) {
  finalStateValuesEntry_ = finalStateValuesEntry;
}

boost::shared_ptr<FinalStateValuesEntry>
OutputsEntry::getFinalStateValuesEntry() const {
  return finalStateValuesEntry_;
}

void
OutputsEntry::setLostEquipmentsEntry(const boost::shared_ptr<LostEquipmentsEntry>& lostEquipmentsEntry) {
  lostEquipmentsEntry_ = lostEquipmentsEntry;
}

boost::shared_ptr<LostEquipmentsEntry>
OutputsEntry::getLostEquipmentsEntry() const {
  return lostEquipmentsEntry_;
}

void
OutputsEntry::setLogsEntry(const boost::shared_ptr<LogsEntry>& logsEntry) {
  logsEntry_ = logsEntry;
}

boost::shared_ptr<LogsEntry>
OutputsEntry::getLogsEntry() const {
  return logsEntry_;
}

}  // namespace job
