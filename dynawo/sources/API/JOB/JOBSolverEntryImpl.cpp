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
 * @file JOBSolverEntryImpl.cpp
 * @brief Solver entry description : implementation file
 *
 */

#include "JOBSolverEntryImpl.h"

namespace job {

SolverEntry::Impl::Impl() :
lib_(""),
parametersFile_(""),
parametersId_("") {
}

SolverEntry::Impl::~Impl() {
}

void
SolverEntry::Impl::setLib(const std::string & lib) {
  lib_ = lib;
}

std::string
SolverEntry::Impl::getLib() const {
  return lib_;
}

void
SolverEntry::Impl::setParametersFile(const std::string & parametersFile) {
  parametersFile_ = parametersFile;
}

std::string
SolverEntry::Impl::getParametersFile() const {
  return parametersFile_;
}

void
SolverEntry::Impl::setParametersId(const std::string& parametersId) {
  parametersId_ = parametersId;
}

std::string
SolverEntry::Impl::getParametersId() const {
  return parametersId_;
}

}  // namespace job
