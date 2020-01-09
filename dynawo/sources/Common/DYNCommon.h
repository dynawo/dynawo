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
 * @file  DYNCommon.h
 *
 * @brief define common function that could be used
 *
 */
#ifndef COMMON_DYNCOMMON_H_
#define COMMON_DYNCOMMON_H_

#include <string>
#include <vector>
#include <cmath>
#include <limits>
#include <algorithm>

namespace DYN {
  /**
   * @brief determine the shared library extension based on the platform
   *
   * @return ".so", ".dylib" or ".dll"
   */
  const char* sharedLibraryExtension();

  /**
   * @brief transforms a double number to a string
   *
   * @param value : double to transform
   *
   * @return the value with string format
   */
  std::string double2String(const double& value);

  /**
   * @brief determines the sign of a double number
   *
   * @param value : the double of which we want to know the sign
   *
   * @return @b -1 if the value is <0, @b 1 otherwise
   */
  int sign(const double& value);

  /**
   * @brief C type definition for variable
   */
  typedef enum {
    VAR_TYPE_STRING,  ///< the variable is a string variable
    VAR_TYPE_BOOL,  ///< The variable is a boolean variable
    VAR_TYPE_INT,  ///< The variable is an integer variable
    VAR_TYPE_DOUBLE,  ///< The variable is a (possibly discrete) real variable
  } typeVarC_t;

  /**
   * @brief return the C type of a variable as a string
   * @param type : type of a variable as an enum type
   * @return type of a variable as a string
   */
  std::string typeVarC2Str(const typeVarC_t& type);

  /**
   * @brief return the C type of a variable
   * @param typeStr : type of a variable as a string
   * @return type of a variable as an enum
   */
  typeVarC_t str2TypeVarC(const std::string& typeStr);


  /**
   * @brief return the current precision in the form 1e-n
   * @return the current precision in the form 1e-n
   */
  double getCurrentPrecision();
  /**
   * @brief set the current precision with the form 1e-n
   * @param precision precision with the form 1e-n
   */
  void setCurrentPrecision(double precision);
  /**
   * @brief return the current precision in the form of the number of decimals
   * @return the current precision in the form of the number of decimals
   */
  unsigned getPrecisionAsNbDecimal();

  /**
   * @brief convert native bool to Real (aka Dynawo boolean)
   *
   *
   * @param value the boolean value
   * @return the Dynawo boolean value
   */
  static inline double fromNativeBool(const bool value) {
    return (value ? 1.0 : -1.0);
  }

  /**
   * @brief return true if a == b
   *
   *
   * @param a first double
   * @param b second double
   * @return return true if a == b
   */
  static inline bool doubleEquals(const double& a, const double& b) {
    if (std::isinf(a) || std::isinf(b)) return false;
    if (std::isnan(a) || std::isnan(b)) return false;
    double diff = std::fabs(a-b);
    if (diff <= getCurrentPrecision()/5) return true;
    return diff <= std::max(std::fabs(a), std::fabs(b))*getCurrentPrecision()/5;  // Error factor used to add more leeway
  }

  /**
   * @brief return true if a != b
   *
   *
   * @param a first double
   * @param b second double
   * @return return true if a != b
   */
  static inline bool doubleNotEquals(const double& a, const double& b) {
    return !doubleEquals(a, b);
  }

  /**
   * @brief return true if a == 0.
   *
   *
   * @param a double to test
   * @return return true if a == 0.
   */
  static inline bool doubleIsZero(const double& a) {
    return std::fabs(a) <= getCurrentPrecision()/5;
  }

  /**
   * @brief convert Real (aka Dynawo boolean) to native boolean
   *
   *
   * @param dynawoBool the Dynawo boolean value
   * @return the boolean value as a native boolean
   */
  static inline bool toNativeBool(const double& dynawoBool) {
    return dynawoBool >  0.0;
  }
}  // namespace DYN

#endif  // COMMON_DYNCOMMON_H_
