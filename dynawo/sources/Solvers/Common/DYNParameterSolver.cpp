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
 * @file  DYNParameterSolver.cpp
 *
 * @brief Dynawo solver parameter : implementation file
 *
 */
#include "DYNParameterSolver.h"

#include "DYNMacrosMessage.h"

using std::string;

namespace DYN {

ParameterSolver::ParameterSolver(const string& name, const typeVarC_t valueType, const bool mandatory) :
  ParameterCommon(name, valueType, mandatory) {
}

double
ParameterSolver::getDoubleValue() const {
  if (getValueType() == VAR_TYPE_DOUBLE)
    return getValue<double>();
  else if (getValueType() == VAR_TYPE_INT)
    return static_cast<double> (getValue<int>());
  else if (getValueType() == VAR_TYPE_BOOL)
    return fromNativeBool(getValue<bool>());
  else
    throw DYNError(Error::GENERAL, ParameterUnableToConvertToDouble, getName(), typeVarC2Str(getValueType()));
}

boost::any
ParameterSolver::getAnyValue() const {
  return value_.value();
}

Error::TypeError_t
ParameterSolver::getTypeError() const {
  return Error::GENERAL;
}

}  // namespace DYN
