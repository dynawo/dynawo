//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of
// simulation tools for power systems.
//

#ifndef COMMON_DYNNUMERICALUTILS_H_
#define COMMON_DYNNUMERICALUTILS_H_

#include "DYNMacrosMessage.h"

#include <cmath>


namespace DYN {

/**
 * specific definition of power function to raise an error when the return value cannot be calculated
 * @param a base number
 * @param b exponent number
 * @return a^b
 */
template<typename T>
T pow_dynawo(T a, T b) {
  T value = pow(a, b);
  if (std::isnan(value) || std::isinf(value)) {
    throw(DYN::Error(DYN::Error::NUMERICAL_ERROR, DYN::KeyError_t::NumericalErrorFunction, std::string(__FILE__), __LINE__, \
          (DYN::Message("ERROR", DYN::KeyError_t::names(DYN::KeyError_t::NumericalErrorFunction)), "pow")));
  }
  return value;
}

} /* namespace DYN */

#endif  // COMMON_DYNNUMERICALUTILS_H_
