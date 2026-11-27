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
 * @file  DYNParameterModeler.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef MODELER_COMMON_DYNPARAMETERMODELER_HPP_
#define MODELER_COMMON_DYNPARAMETERMODELER_HPP_

#include "DYNMacrosMessage.h"

namespace DYN {

/**
 * @copydoc ParameterModeler::setValue()
 * template specialization for boolean type
 */
template<>
inline void ParameterModeler::setValue(const bool& value, const parameterOrigin_t origin) {
  if (getValueType() != VAR_TYPE_BOOL)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "BOOL");

  writeChecks(origin);

  values_[origin] = value;
  updateOrigin(origin);
}

/**
 * @copydoc ParameterModeler::setValue()
 * template specialization for integer type
 */
template<>
inline void ParameterModeler::setValue(const int& value, const parameterOrigin_t origin) {
  if (getValueType() != VAR_TYPE_INT)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "INT");

  writeChecks(origin);

  values_[origin]= value;
  updateOrigin(origin);
}

/**
 * @copydoc ParameterModeler::setValue()
 * template specialization for double type
 */
template<>
inline void ParameterModeler::setValue(const double& value, const parameterOrigin_t origin) {
  if (getValueType() != VAR_TYPE_DOUBLE)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "DOUBLE");

  writeChecks(origin);

  values_[origin] = value;
  updateOrigin(origin);
}

/**
 * @copydoc ParameterModeler::setValue()
 * template specialization for string type
 */
template<>
inline void ParameterModeler::setValue(const std::string& value, const parameterOrigin_t origin) {
  if (getValueType() != VAR_TYPE_STRING)
    throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "STRING");

  writeChecks(origin);

  values_[origin] = value;
  updateOrigin(origin);
}

}  // namespace DYN

#endif  // MODELER_COMMON_DYNPARAMETERMODELER_HPP_
