//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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
  for (const auto& finalStateEntry : other.finalStateEntries_)
    finalStateEntries_.push_back(DYN::clone(finalStateEntry));
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
OutputsEntry::setInitValuesEntry(const std::shared_ptr<InitValuesEntry>& initValuesEntry) {
  initValuesEntry_ = initValuesEntry;
}

std::shared_ptr<InitValuesEntry>
OutputsEntry::getInitValuesEntry() const {
  return initValuesEntry_;
}

void
OutputsEntry::setFinalValuesEntry(const std::shared_ptr<FinalValuesEntry>& finalValuesEntry) {
  finalValuesEntry_ = finalValuesEntry;
}

std::shared_ptr<FinalValuesEntry>
OutputsEntry::getFinalValuesEntry() const {
  return finalValuesEntry_;
}

void
OutputsEntry::setConstraintsEntry(const std::shared_ptr<ConstraintsEntry>& constraintsEntry) {
  constraintsEntry_ = constraintsEntry;
}

std::shared_ptr<ConstraintsEntry>
OutputsEntry::getConstraintsEntry() const {
  return constraintsEntry_;
}

void
OutputsEntry::setTimelineEntry(const std::shared_ptr<TimelineEntry>& timelineEntry) {
  timelineEntry_ = timelineEntry;
}

std::shared_ptr<TimelineEntry>
OutputsEntry::getTimelineEntry() const {
  return timelineEntry_;
}

void
OutputsEntry::setTimetableEntry(const std::shared_ptr<TimetableEntry>& timetableEntry) {
  timetableEntry_ = timetableEntry;
}

std::shared_ptr<TimetableEntry>
OutputsEntry::getTimetableEntry() const {
  return timetableEntry_;
}

void
OutputsEntry::addFinalStateEntry(const std::shared_ptr<FinalStateEntry>& finalStateEntry) {
  finalStateEntries_.push_back(finalStateEntry);
}

void
OutputsEntry::setCurvesEntry(const std::shared_ptr<CurvesEntry>& curvesEntry) {
  curvesEntry_ = curvesEntry;
}

std::shared_ptr<CurvesEntry>
OutputsEntry::getCurvesEntry() const {
  return curvesEntry_;
}

void
OutputsEntry::setFinalStateValuesEntry(const std::shared_ptr<FinalStateValuesEntry>& finalStateValuesEntry) {
  finalStateValuesEntry_ = finalStateValuesEntry;
}

std::shared_ptr<FinalStateValuesEntry>
OutputsEntry::getFinalStateValuesEntry() const {
  return finalStateValuesEntry_;
}

void
OutputsEntry::setLostEquipmentsEntry(const std::shared_ptr<LostEquipmentsEntry>& lostEquipmentsEntry) {
  lostEquipmentsEntry_ = lostEquipmentsEntry;
}

std::shared_ptr<LostEquipmentsEntry>
OutputsEntry::getLostEquipmentsEntry() const {
  return lostEquipmentsEntry_;
}

void
OutputsEntry::setLogsEntry(const std::shared_ptr<LogsEntry>& logsEntry) {
  logsEntry_ = logsEntry;
}

std::shared_ptr<LogsEntry>
OutputsEntry::getLogsEntry() const {
  return logsEntry_;
}

}  // namespace job
