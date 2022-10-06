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
 * @file JOBCurvesEntry.cpp
 * @brief curves entry description : implementation file
 *
 */

#include "JOBCurvesEntry.h"

namespace job {

const std::string&
CurvesEntry::getInputFile() const {
  return inputFile_;
}

const std::string&
CurvesEntry::getOutputFile() const {
  return outputFile_;
}

const std::string&
CurvesEntry::getExportMode() const {
  return exportMode_;
}

boost::optional<int>
CurvesEntry::getIterationStep() const {
  return iterationStep_;
}

boost::optional<double>
CurvesEntry::getTimeStep() const {
  return timeStep_;
}

void
CurvesEntry::setInputFile(const std::string& inputFile) {
  inputFile_ = inputFile;
}

void
CurvesEntry::setOutputFile(const std::string& outputFile) {
  outputFile_ = outputFile;
}

void
CurvesEntry::setExportMode(const std::string& exportMode) {
  exportMode_ = exportMode;
}

void
CurvesEntry::setIterationStep(boost::optional<int> iterationStep) {
  iterationStep_ = iterationStep;
}

void
CurvesEntry::setTimeStep(boost::optional<double> timeStep) {
  timeStep_ = timeStep;
}

}  // namespace job
