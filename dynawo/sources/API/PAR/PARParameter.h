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
 * @file PARParameter.h
 * @brief Dynawo parameters : interface file
 *
 */

#ifndef API_PAR_PARPARAMETER_H_
#define API_PAR_PARPARAMETER_H_

#include <string>

#ifndef LANG_CXX11
#include <boost/static_assert.hpp>
#endif

namespace parameters {

/**
 * @class Parameter
 * @brief Parameter interface class
 *
 * Interface class for parameter objects. These are containers for parameters
 * that can be of three c++ native types : bool, int, double and string
 */
class Parameter {
 public:
  /**
   * @brief Available parameter types enum
   *
   */
  enum ParameterType {
    BOOL,  ///< Indicates bool parameter
    INT,  ///< Indicates int parameter
    DOUBLE,  ///< Indicates double parameter
    STRING,  ///< Indicates string parameter
    SIZE_OF_ENUM  ///< value to use ONLY to assess the enumeration size
  };
  /**
   * @brief Destructor
   */
  virtual ~Parameter() {}


  /**
   * @brief Getter for parameter type
   *
   * @returns Parameter's type
   */
  virtual ParameterType getType() const = 0;

  /**
   * @brief Getter for parameter name
   *
   * @returns Parameter's name
   */
  virtual std::string getName() const = 0;

  /**
   * @brief Getter for "bool" typed parameter
   *
   * @returns Boolean value of a @p Parameter::BOOL typed parameter
   * @throws API exception if the parameter is not a bool
   */
  virtual bool getBool() const = 0;

  /**
   * @brief Getter for "int" typed parameter
   *
   * @returns Integer value of a @p Parameter::INT typed parameter
   * @throws API exception if the parameter is not an int
   */
  virtual int getInt() const = 0;

  /**
   * @brief Getter for "double" typed parameter
   *
   * @returns Double value of a @p Parameter::DOUBLE typed parameter
   * @throws API exception if the parameter is not a double
   */
  virtual double getDouble() const = 0;

  /**
   * @brief Getter for "string" typed parameter
   *
   * @returns String value of a @p Parameter::STRING typed paramater
   * @throws API exception if the parameter is not a string
   */
  virtual std::string getString() const = 0;

  /**
   * @brief Getter for "used" boolean
   *
   * @returns Boolean "used" indicating whether the parameter is used or not
   */
  virtual bool getUsed() const = 0;

  /**
   * @brief Set "used" boolean
   *
   * @param used: boolean used to set "used" value
   */
  virtual void setUsed(bool used) = 0;

  class Impl;
};
static const char* ParameterTypeNames[Parameter::SIZE_OF_ENUM] = {"boolean", "integer", "double", "string"};  ///< string conversion of enum values
// statically check that the size of ParameterTypeNames fits the number of ParameterTypes
#ifdef LANG_CXX11
/**
 * @brief Test if the size of ParameterTypeNames is relevant with the enumeration size
 */
static_assert(sizeof (ParameterTypeNames) / sizeof (char*) == Parameter::SIZE_OF_ENUM, "Parameters string size does not match ParameterType enumeration");
#else
/**
 * @brief Test if the size of ParameterTypeNames is relevant with the enumeration size
 */
BOOST_STATIC_ASSERT_MSG(sizeof (ParameterTypeNames) / sizeof (char*) == Parameter::SIZE_OF_ENUM,
                        "Parameters string size does not match ParameterType enumeration");
#endif
}  // namespace parameters

#endif  // API_PAR_PARPARAMETER_H_
