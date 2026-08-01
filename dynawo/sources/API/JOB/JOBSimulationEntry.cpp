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
 * @file JOBSimulationEntryImpl.cpp
 * @brief Simulation entry description : implementation file
 *
 */

#include "JOBSimulationEntry.h"

#include <limits>

namespace job {

SimulationEntry::SimulationEntry() : startTime_(0), stopTime_(0), criteriaStep_(10), precision_(1e-6), timeout_(std::numeric_limits<double>::max()) {}

void
SimulationEntry::setStartTime(double startTime) {
  startTime_ = startTime;
}

double
SimulationEntry::getStartTime() const {
  return startTime_;
}

void
SimulationEntry::setStopTime(double stopTime) {
  stopTime_ = stopTime;
}

double
SimulationEntry::getStopTime() const {
  return stopTime_;
}

void
SimulationEntry::addCriteriaFile(const std::string& criteriaFile) {
  criteriaFiles_.push_back(criteriaFile);
}

void
SimulationEntry::setCriteriaFile(const std::string& criteriaFile) {
  criteriaFiles_.clear();
  criteriaFiles_.push_back(criteriaFile);
}

const std::vector<std::string>&
SimulationEntry::getCriteriaFiles() const {
  return criteriaFiles_;
}

void
SimulationEntry::setCriteriaStep(int criteriaStep) {
  criteriaStep_ = criteriaStep;
}

int
SimulationEntry::getCriteriaStep() const {
  return criteriaStep_;
}

void
SimulationEntry::setPrecision(double precision) {
  precision_ = precision;
}

double
SimulationEntry::getPrecision() const {
  return precision_;
}

}  // namespace job
