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
 * @file JOBCurvesEntryImpl.cpp
 * @brief curves entry description : implementation file
 *
 */

#include "JOBCurvesEntryImpl.h"

#include <boost/make_shared.hpp>

namespace job {

CurvesEntry::Impl::Impl() :
inputFile_(""),
outputFile_(""),
exportMode_("") {
}

CurvesEntry::Impl::~Impl() {
}

boost::shared_ptr<CurvesEntry>
CurvesEntry::Impl::clone() const  {
  return boost::make_shared<CurvesEntry::Impl>(*this);
}

std::string
CurvesEntry::Impl::getInputFile() const {
  return inputFile_;
}

std::string
CurvesEntry::Impl::getOutputFile() const {
  return outputFile_;
}

std::string
CurvesEntry::Impl::getExportMode() const {
  return exportMode_;
}

void
CurvesEntry::Impl::setInputFile(const std::string & inputFile) {
  inputFile_ = inputFile;
}

void
CurvesEntry::Impl::setOutputFile(const std::string & outputFile) {
  outputFile_ = outputFile;
}

void
CurvesEntry::Impl::setExportMode(const std::string & exportMode) {
  exportMode_ = exportMode;
}

}  // namespace job
