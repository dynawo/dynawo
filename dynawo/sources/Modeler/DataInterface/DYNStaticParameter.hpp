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
 * @file  DYNStaticParameter.hpp
 *
 * @brief Implementation of template methods
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSTATICPARAMETER_HPP_
#define MODELER_DATAINTERFACE_DYNSTATICPARAMETER_HPP_

#include "DYNMacrosMessage.h"

namespace DYN {

/**
 * @brief Set the value of a static parameter
 * @param value double value to use
 * @return instance of staticParameter modified
 * Specific case for dynawo
 * if the StaticParameter is a boolean value, in modelica the value will be processed as a double
 * -1 -> false
 * 1 -> true
 */
template<>
inline StaticParameter& StaticParameter::setValue(const double& value) {
  if (type_ == BOOL) {
    value_ = (value > 0);
  } else if (type_ == DOUBLE) {
    value_ = value;
  } else {
    throw DYNError(Error::MODELER, StaticParameterWrongType, name_, typeAsString(type_), "double");
  }
  return *this;
}

/**
 * @brief Set the value of a static parameter
 * @param value integer value to use
 * @return instance of staticParameter modified
 */
template<>
inline StaticParameter& StaticParameter::setValue(const int& value) {
  if (type_ != INT)
    throw DYNError(Error::MODELER, StaticParameterWrongType, name_, typeAsString(type_), "double");

  value_ = value;
  return *this;
}

/**
 * @brief Set the value of a static parameter
 * @param value boolean value to use
 * @return instance of staticParameter modified
 */
template<>
inline StaticParameter& StaticParameter::setValue(const bool& value) {
  if (type_ != BOOL)
    throw DYNError(Error::MODELER, StaticParameterWrongType, name_, typeAsString(type_), "double");

  value_ = value;
  return *this;
}

template<typename T>
T StaticParameter::getValue() const {
  T value;
  try {
    value = boost::any_cast<T>(*value_);
  }
  catch (boost::bad_any_cast&)  {
    throw DYNError(Error::MODELER, StaticParameterBadCast, name_, typeAsString(type_));
  }
  return value;
}

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNSTATICPARAMETER_HPP_
