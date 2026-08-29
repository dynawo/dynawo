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
 * @file JOBSolverEntry.cpp
 * @brief Solver entry description : implementation file
 *
 */

#include "JOBSolverEntry.h"

namespace job {

void
SolverEntry::setLib(const std::string& lib) {
  lib_ = lib;
}

const std::string&
SolverEntry::getLib() const {
  return lib_;
}

void
SolverEntry::setParametersFile(const std::string& parametersFile) {
  parametersFile_ = parametersFile;
}

const std::string&
SolverEntry::getParametersFile() const {
  return parametersFile_;
}

void
SolverEntry::setParametersId(const std::string& parametersId) {
  parametersId_ = parametersId;
}

const std::string&
SolverEntry::getParametersId() const {
  return parametersId_;
}

}  // namespace job
