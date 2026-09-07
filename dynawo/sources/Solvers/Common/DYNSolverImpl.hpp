//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
//

/**
 * @file  DYNSolverImpl.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef SOLVERS_COMMON_DYNSOLVERIMPL_HPP_
#define SOLVERS_COMMON_DYNSOLVERIMPL_HPP_

#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNSolverImpl.h"

namespace DYN {

template<typename T>
void
inline Solver::Impl::setParameterValue(ParameterSolver& parameter, const T& value) {
  if (hasParameter(parameter.getName())) {
    parameter.setValue(value);
  }
}

}  // namespace DYN

#endif  // SOLVERS_COMMON_DYNSOLVERIMPL_HPP_
