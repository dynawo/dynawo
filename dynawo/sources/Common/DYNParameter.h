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
 * @file  DYNParameter.h
 *
 * @brief Dynawo Parameter: header file
 *
 */
#ifndef COMMON_DYNPARAMETER_H_
#define COMMON_DYNPARAMETER_H_

#include <string>
#include <vector>
#include <map>

#include <boost/optional.hpp>
#include <boost/any.hpp>

#include "DYNCommon.h"
#include "DYNError.h"

namespace DYN {

/**
 * class ParameterCommon
 */
class ParameterCommon {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the parameter
   * @param valueType type of the parameter (bool, int, string, double)
   * @param mandatory whether the parameter is mandatory or optional
   */
  ParameterCommon(const std::string& name, const typeVarC_t& valueType, bool mandatory);

  /**
   * @brief Default copy Constructor
   */
  ParameterCommon(const ParameterCommon&) = default;

  /**
   * @brief Default copy assigment operator
   *
   * @return a new parameter
   */
  ParameterCommon& operator=(const ParameterCommon&) = delete;
  /**
   * @brief Destructor
   */
  virtual ~ParameterCommon();

  /**
   * @brief Getter for parameter's name
   * @return parameter's name
   */
  inline const std::string& getName() const {
    return name_;
  }

  /**
   * @brief Getter for parameter's type
   * @return true if the parameter is mandatory else otherwise
   */
  inline bool isMandatory() const {
    return mandatory_;
  }

  /**
   * @brief parameter's value type getter
   * @return parameter's value type
   */
  inline typeVarC_t getValueType() const {
    return valueType_;
  }

  /**
   * @brief check whether the parameter index has already been set
   * @return whether the parameter index has already been set
   */
  inline bool indexSet() const {
    return index_ != boost::none;
  }

  /**
   * @brief index setter
   * @param index the index to set
   */
  void setIndex(const unsigned int& index);

  /**
   * @brief index getter
   * @return index
   */
  unsigned int getIndex() const;

  /**
   * @brief parameter's value getter
   * @return parameter's value
   */
  template<typename T> T getValue() const;

  /**
   * @brief value intermediary getter
   * @return parameter's value
   */
  virtual boost::any getAnyValue() const = 0;

  /**
   * @brief indicates whether a parameter has a value
   * @return true if the parameter has a value, false otherwise
   */
  virtual bool hasValue() const = 0;

  /**
   * @brief TypeError getter
   * @return TypeError getter
   */
  virtual Error::TypeError_t getTypeError() const = 0;

 private:
  ParameterCommon() = delete;  ///< default constructor

  std::string name_;  ///< name of the parameter
  typeVarC_t valueType_;  ///< type of the parameter value (BOOL, INT, DOUBLE, STRING: as defined in enum)
  boost::optional<unsigned int> index_;  ///< parameter index in the raw parameters' vector
  bool mandatory_;  ///< true if this parameter is mandatory
};

/**
 * @brief Parameter origins enum (ordered by increasing priority)
 */
typedef enum {
  MO,  ///< Parameter from MODELICA model
  LOADED_DUMP,  ///< Value loaded from previous dump
  PAR,  ///< Parameter from PAR file
  IIDM,  ///< Parameter from IIDM file
  LOCAL_INIT,  ///< Parameter from local initialization
  FINAL,  ///< Value used for dynamic simulation
  NB_ORIGINS  ///< Number of origins (for data dimensions)
} parameterOrigin_t;

/**
 * @brief convert a parameter origin to string
 * @param origin : the parameter origin as an enum
 * @return the converted origin as a string
 */
std::string origin2Str(const parameterOrigin_t& origin);
}  // namespace DYN

#include "DYNParameter.hpp"

#endif  // COMMON_DYNPARAMETER_H_
