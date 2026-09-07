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
 * @file  DYNParameter.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef COMMON_DYNPARAMETER_HPP_
#define COMMON_DYNPARAMETER_HPP_

#include "DYNMacrosMessage.h"

namespace DYN {

/**
 * @copydoc ParameterCommon::getValue()
 * template specialization for boolean type
 */
template<>
inline bool ParameterCommon::getValue() const {
  if (getValueType() != VAR_TYPE_BOOL)
    throw DYNError(getTypeError(), ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "BOOL");

  if (!hasValue())
    throw DYNError(getTypeError(), ParameterHasNoValue, getName());

  bool value;
  try {
    value = boost::any_cast<bool>(getAnyValue());
  }
  catch (boost::bad_any_cast&)  {
    throw DYNError(getTypeError(), ParameterBadCast, getName(), typeVarC2Str(getValueType()));
  }
  return value;
}

/**
 * @copydoc ParameterCommon::getValue()
 * template specialization for double type
 */
template<>
inline double ParameterCommon::getValue() const {
  if (getValueType() != VAR_TYPE_DOUBLE)
    throw DYNError(getTypeError(), ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "DOUBLE");

  if (!hasValue())
    throw DYNError(getTypeError(), ParameterHasNoValue, getName());

  double value;
  try {
    value = boost::any_cast<double>(getAnyValue());
  }
  catch (boost::bad_any_cast&)  {
    throw DYNError(getTypeError(), ParameterBadCast, getName(), typeVarC2Str(getValueType()));
  }
  return value;
}

/**
 * @copydoc ParameterCommon::getValue()
 * template specialization for integer type
 */
template<>
inline int ParameterCommon::getValue() const {
  if (getValueType() != VAR_TYPE_INT)
    throw DYNError(getTypeError(), ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "INT");

  if (!hasValue())
    throw DYNError(getTypeError(), ParameterHasNoValue, getName());

  int value;
  try {
    value = boost::any_cast<int>(getAnyValue());
  }
  catch (boost::bad_any_cast&)  {
    throw DYNError(getTypeError(), ParameterBadCast, getName(), typeVarC2Str(getValueType()));
  }
  return value;
}

/**
 * @copydoc ParameterCommon::getValue()
 * template specialization for string type
 */
template<>
inline std::string ParameterCommon::getValue() const {
  if (getValueType() != VAR_TYPE_STRING)
    throw DYNError(getTypeError(), ParameterInvalidTypeRequested, getName(), typeVarC2Str(getValueType()), "STRING");

  if (!hasValue())
    throw DYNError(getTypeError(), ParameterHasNoValue, getName());

  std::string value;
  try {
    value = boost::any_cast<std::string>(getAnyValue());
  }
  catch (boost::bad_any_cast&)  {
    throw DYNError(getTypeError(), ParameterBadCast, getName(), typeVarC2Str(getValueType()));
  }
  return value;
}


}  // namespace DYN

#endif  // COMMON_DYNPARAMETER_HPP_
