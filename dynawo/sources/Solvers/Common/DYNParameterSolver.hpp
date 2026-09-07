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
 * @file  DYNParameterSolver.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef SOLVERS_COMMON_DYNPARAMETERSOLVER_HPP_
#define SOLVERS_COMMON_DYNPARAMETERSOLVER_HPP_

#include "DYNMacrosMessage.h"

namespace DYN {

/**
 * @copydoc ParameterSolver::setValue()
 * template specialization for boolean type
 */
template<>
inline void ParameterSolver::setValue(const bool& value) {
  if (getValueType() != VAR_TYPE_BOOL)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "BOOL");

  value_ = value;
}

/**
 * @copydoc ParameterSolver::setValue()
 * template specialization for integer type
 */
template<>
inline void ParameterSolver::setValue(const int& value) {
  if (getValueType() != VAR_TYPE_INT)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "INT");

  value_ = value;
}

/**
 * @copydoc ParameterSolver::setValue()
 * template specialization for double type
 */
template<>
inline void ParameterSolver::setValue(const double& value) {
  if (getValueType() != VAR_TYPE_DOUBLE)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "DOUBLE");

  value_ = value;
}

/**
 * @copydoc ParameterSolver::setValue()
 * template specialization for string type
 */
template<>
inline void ParameterSolver::setValue(const std::string& value) {
  if (getValueType() != VAR_TYPE_STRING)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "STRING");

  value_ = value;
}

}  // namespace DYN

#endif  // SOLVERS_COMMON_DYNPARAMETERSOLVER_HPP_
