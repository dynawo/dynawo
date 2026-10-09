//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  MATLinearizedSystem.cpp
 *
 * @brief Linearized system to export : implementation file
 *
 */

#include "MATLinearizedSystem.h"

#include <utility>

namespace matrix {

LinearizedSystem::LinearizedSystem(const double time) :
time_(time) {
}

void
LinearizedSystem::setJacobian(Matrix jacobian) {
  jacobian_ = std::move(jacobian);
}

void
LinearizedSystem::setJacobianPrim(Matrix jacobianPrim) {
  jacobianPrim_ = std::move(jacobianPrim);
}

void
LinearizedSystem::addVariable(const std::string& name, const std::string& modelName, const std::string& type) {
  variables_.push_back({name, modelName, type});
}

void
LinearizedSystem::addEquation(const std::string& type) {
  equations_.push_back({type});
}

}  // namespace matrix
