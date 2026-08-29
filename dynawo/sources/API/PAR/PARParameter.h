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
 * @file PARParameter.h
 * @brief Dynawo parameters : interface file
 *
 */

#ifndef API_PAR_PARPARAMETER_H_
#define API_PAR_PARPARAMETER_H_

#include <boost/any.hpp>
#include <string>

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
    BOOL,         ///< Indicates bool parameter
    INT,          ///< Indicates int parameter
    DOUBLE,       ///< Indicates double parameter
    STRING,       ///< Indicates string parameter
    SIZE_OF_ENUM  ///< value to use ONLY to assess the enumeration size
  };

  /**
   * @brief Constructor of "bool" typed parameter
   *
   * @param name  Name of the parameter
   * @param boolValue Value of the parameter
   */
  Parameter(const std::string& name, const bool boolValue);

  /**
   * @brief Constructor of "int" typed parameter
   *
   * @param name  Name of the parameter
   * @param intValue Value of the parameter
   */
  Parameter(const std::string& name, const int intValue);

  /**
   * @brief Constructor of "double" typed parameter
   *
   * @param name  Name of the parameter
   * @param doubleValue Value of the parameter
   */
  Parameter(const std::string& name, const double doubleValue);

  /**
   * @brief Constructor of "string" typed parameter
   *
   * @param name  Name of the parameter
   * @param stringValue Value of the parameter
   */
  Parameter(const std::string& name, const std::string& stringValue);

  /**
   * @brief Getter for parameter type
   *
   * @returns Parameter's type
   */
  ParameterType getType() const;

  /**
   * @brief Getter for parameter name
   *
   * @returns Parameter's name
   */
  std::string getName() const;

  /**
   * @brief Getter for "bool" typed parameter
   *
   * @returns Boolean value of a @p Parameter::BOOL typed parameter
   * @throws API exception if the parameter is not a bool
   */
  bool getBool() const;

  /**
   * @brief Getter for "int" typed parameter
   *
   * @returns Integer value of a @p Parameter::INT typed parameter
   * @throws API exception if the parameter is not an int
   */
  int getInt() const;

  /**
   * @brief Getter for "double" typed parameter
   *
   * @returns Double value of a @p Parameter::DOUBLE typed parameter
   * @throws API exception if the parameter is not a double
   */
  double getDouble() const;

  /**
   * @brief Getter for "string" typed parameter
   *
   * @returns String value of a @p Parameter::STRING typed paramater
   * @throws API exception if the parameter is not a string
   */
  std::string getString() const;

  /**
   * @brief Getter for "used" boolean
   *
   * @returns Boolean "used" indicating whether the parameter is used or not
   */
  bool getUsed() const;

  /**
   * @brief Set "used" boolean
   *
   * @param used boolean used to set "used" value
   */
  void setUsed(bool used);

 private:
  ParameterType type_; /**< Parameter's type **/
  std::string name_;   /**< Parameter's name **/
  boost::any value_;   /**< Parameter's value **/
  bool used_;          /**< True if the parameter is used in the model **/
};
static const char* ParameterTypeNames[Parameter::SIZE_OF_ENUM] = {"boolean", "integer", "double", "string"};  ///< string conversion of enum values
// statically check that the size of ParameterTypeNames fits the number of ParameterTypes
/**
 * @brief Test if the size of ParameterTypeNames is relevant with the enumeration size
 */
static_assert(sizeof(ParameterTypeNames) / sizeof(char*) == Parameter::SIZE_OF_ENUM, "Parameters string size does not match ParameterType enumeration");
}  // namespace parameters

#endif  // API_PAR_PARPARAMETER_H_
