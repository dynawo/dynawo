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
 * @file PARParameterImpl.h
 * @brief Dynawo parameters : header file
 *
 */

#ifndef API_PAR_PARPARAMETERIMPL_H_
#define API_PAR_PARPARAMETERIMPL_H_

#include <boost/any.hpp>

#include "PARParameter.h"

namespace parameters {

/**
 * @class Parameter::Impl
 * @brief Parameter implemented class
 *
 * Implementation of Parameter interface class.
 */
class Parameter::Impl : public Parameter {
 public:
  /**
   * @brief Constructor of "bool" typed parameter
   *
   * @param name  Name of the parameter
   * @param boolValue Value of the parameter
   */
  Impl(const std::string& name, const bool boolValue);

  /**
   * @brief Constructor of "int" typed parameter
   *
   * @param name  Name of the parameter
   * @param intValue Value of the parameter
   */
  Impl(const std::string& name, const int intValue);

  /**
   * @brief Constructor of "double" typed parameter
   *
   * @param name  Name of the parameter
   * @param doubleValue Value of the parameter
   */
  Impl(const std::string& name, const double doubleValue);

  /**
   * @brief Constructor of "string" typed parameter
   *
   * @param name  Name of the parameter
   * @param stringValue Value of the parameter
   */
  Impl(const std::string& name, const std::string& stringValue);

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc Parameter::getType()
   */
  ParameterType getType() const;

  /**
   * @copydoc Parameter::getName()
   */
  std::string getName() const;

  /**
   * @copydoc Parameter::getBool()
   */
  bool getBool() const;

  /**
   * @copydoc Parameter::getInt()
   */
  int getInt() const;

  /**
   * @copydoc Parameter::getDouble()
   */
  double getDouble() const;

  /**
   * @copydoc Parameter::getString()
   */
  std::string getString() const;

  /**
   * @copydoc Parameter::getUsed()
   */
  bool getUsed() const;

  /**
   * @copydoc Parameter::setUsed(bool Bool)
   */
  void setUsed(bool used);

 private:
#ifdef LANG_CXX11
  Impl() = delete;  // Private default constructor
#else
  Impl();  // Private default constructor
#endif

  ParameterType type_; /**< Parameter's type **/
  std::string name_; /**< Parameter's name **/
  boost::any value_; /**< Parameter's value **/
  bool used_; /**< True if the parameter is used in the model **/
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERIMPL_H_
