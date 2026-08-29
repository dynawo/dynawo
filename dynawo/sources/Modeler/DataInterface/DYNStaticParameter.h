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
 * @file  DYNStaticParameter.h
 *
 * @brief Static parameter description : header file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNSTATICPARAMETER_H_
#define MODELER_DATAINTERFACE_DYNSTATICPARAMETER_H_

#include <string>
#include <boost/any.hpp>
#include <boost/optional.hpp>

namespace DYN {

/**
 * @class StaticParameter
 * @brief Static parameter description class
 */
class StaticParameter {
 public:
  /**
   * @brief Definition of the type of the static parameter
   */
  enum StaticParameterType {
    BOOL,  ///<  the static parameter is a boolean one
    INT,  ///< the static parameter is an integer one
    DOUBLE  ///< the static parameter is a double one
  };

 public:
  /**
   * @brief default constructor
   */
  StaticParameter();

  /**
   * @brief constructor
   *
   * @param name name of the static parameter
   * @param type type of the static parameter
   */
  StaticParameter(const std::string& name, const StaticParameterType& type);

  /**
   * @brief set the value of a static parameter
   *
   * @param value new value of the static parameter
   * @return instance of the staticParameter modified
   */
  template<typename T> StaticParameter& setValue(const T& value);

  /**
   * @brief getter of the static parameter's name
   * @return name of the static parameter
   */
  std::string getName() const;

  /**
   * @brief get the value of the parameter variable
   * @return the value of the static parameter
   */
  template<typename T> T getValue() const;

  /**
   * @brief get the type of a static parameter
   * @return the type of a static parameter
   */
  StaticParameterType getType() const;

  /**
   * @brief check is the static parameter has a value
   * @return @b true is the static parameter's value is already affected
   */
  bool valueAffected() const;

  /**
   * @brief return the type of the static parameter as a string
   * @param type type of the static parameter
   * @return type of the static parameter as a string
   */
  static std::string typeAsString(const StaticParameterType& type);

 private:
  StaticParameterType type_;  ///< type of the static parameter
  boost::optional<boost::any> value_;  ///< value of the static parameter
  std::string name_;  ///< name of the static parameter
};  ///< class for static parameter
}  // namespace DYN

#include "DYNStaticParameter.hpp"

#endif  // MODELER_DATAINTERFACE_DYNSTATICPARAMETER_H_
