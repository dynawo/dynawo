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
 * @file  DYNCommun.h
 *
 * @brief define common function that could be used
 *
 */
#ifndef COMMON_DYNCOMMUN_H_
#define COMMON_DYNCOMMUN_H_

#include <vector>

namespace DYN {
  /**
   * @brief determine whether two vectors of double are equalss
   *
   * @param y1 : first vector to compare
   * @param y2 : second vector to compare
   *
   * @return @b true if vectors are equals, @b false otherwise
   */
  bool vectorAreEquals(const std::vector<double> &y1, const std::vector<double> & y2);

  /**
   * @brief transforms a double number to a string
   *
   * @param value : double to transform
   * @param nbDecimal : number of decimal to use in string format
   *
   * @return the value with string format
   */
  std::string double2String(const double& value, const int& nbDecimal = 5);

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
    STRING,  ///< the variable is a string variable
    BOOL,  ///< The variable is a boolean variable
    INT,  ///< The variable is an integer variable
    DOUBLE,  ///< The variable is a (possibly discrete) real variable
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
   * @brief convert Real (aka Dynawo boolean) to native boolean
   *
   *
   * @param dynawoBool the Dynawo boolean value
   * @return the boolean value as a native boolean
   */
  static inline bool toNativeBool(const double& dynawoBool) {
    return dynawoBool == 1.0;
  }
}  // namespace DYN

#endif  // COMMON_DYNCOMMUN_H_
