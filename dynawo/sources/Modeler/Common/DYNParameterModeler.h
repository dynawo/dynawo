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
 * @file  DYNParameterModeler.h
 *
 * @brief Dynawo Modeler Parameter: header file
 *
 */
#ifndef MODELER_COMMON_DYNPARAMETERMODELER_H_
#define MODELER_COMMON_DYNPARAMETERMODELER_H_

#include <string>
#include <vector>
#include <map>

#include <boost/optional.hpp>
#include <boost/any.hpp>

#include "DYNEnumUtils.h"
#include "DYNParameter.h"

namespace DYN {

/**
 * class ParameterModeler
 */
class ParameterModeler : public ParameterCommon {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the parameter
   * @param valueType type of the parameter (bool, int, string, double)
   * @param scope scope of the parameter (internal, external, undefined)
   * @param cardinality cardinality of the parameter
   * @param cardinalityInformator of the parameter
   */
  ParameterModeler(const std::string& name, const typeVarC_t& valueType, const parameterScope_t& scope, const std::string& cardinality = "1",
            const std::string& cardinalityInformator = "");

  /**
   * @brief Default copy Constructor
   */
  ParameterModeler(const ParameterModeler&) = default;
  /**
   * @brief Default assignement operator
   * @returns *this
   */
  ParameterModeler& operator=(const ParameterModeler&) = delete;

  /**
   * @brief checks whether a parameter value may be set
   * @param origin tested origin for the parameter
   * @throws when it is forbidden to write data for the current parameter and origin
   * @throws when the parameter is not unitary
   */
  void writeChecks(parameterOrigin_t origin) const;

  /**
   * @brief checks whether a parameter value may be set for a given origin
   * @param origin tested origin for the parameter
   * @return whether write rights are granted
   */
  inline bool originWriteAllowed(const parameterOrigin_t origin) const {
    return ((writeRights_.find(origin) != writeRights_.end()) && (writeRights_.find(origin)->second));
  }

  /**
   * @brief parameter's value setter
   * @param value parameter's value
   * @param origin parameter's origin
   */
  template<typename T> void setValue(const T& value, parameterOrigin_t origin);

  /**
   * @brief Setter for parameter's cardinality
   * @param cardinality parameter's cardinality
   */
  inline void setCardinality(const std::string& cardinality) {
    cardinality_ = cardinality;
  }

  /**
   * @brief Setter for cardinality informator
   * @param cardinalityInformator parameter's cardinality informator
   */
  void setCardinalityInformator(const std::string& cardinalityInformator);

  /**
   * @brief Getter for parameter's origin
   * @return parameter's origin
   */
  parameterOrigin_t getOrigin() const;

  /**
   * @brief Update the priority origin of the parameter
   * @param origin origin used to update the priority origin
   */
  void updateOrigin(parameterOrigin_t origin);

  /**
   * @brief check whether the parameter's origin is set
   * @return whether the parameter's origin is set
   */
  inline bool originSet() const {
    return origin_ != boost::none;
  }

  /**
   * @brief Set the priority origin of the parameter
   * @param origin origin used to update the priority origin
   */
  inline void setOrigin(const parameterOrigin_t origin) {
    origin_ = origin;
  }

  /**
   * @brief indicates whether a parameter has a value
   * @return true if the parameter has a value, false otherwise
   */
  inline bool hasValue() const override {
    return originSet();
  }

  /**
   * @brief indicates whether a parameter has a value associated with a given origin
   * @param origin tested origin for the parameter
   * @return true if the parameter has a value associated with the given origin, false otherwise
   */
  bool hasOrigin(parameterOrigin_t origin) const;

  /**
   * @brief indicates whether a parameter has a value associated with a given origin or a less important origin
   * @param origin tested origin for the parameter
   * @return true if the parameter has a value associated with the given origin or a less important origin, false otherwise
   */
  inline bool hasAtLeastOrigin(const parameterOrigin_t origin) const {
    return (getOrigin() >= origin);
  }

  /**
   * @brief parameter's value intermediary getter
   * @return parameter's value
   */
  boost::any getAnyValue() const override;

  /**
   * @brief parameter's value getter (converting the value to double)
   * @return parameter's value (converted to double)
   */
  double getDoubleValue() const;

  /**
   * @brief Getter for parameter's scope (internal, external, shared)
   * @return parameter's scope
   */
  inline parameterScope_t getScope() const {
    return scope_;
  }

  /**
   * @brief Getter for parameter's cardinality
   * @return parameter's cardinality
   */
  inline std::string getCardinality() const {
    return cardinality_;
  }

  /**
   * @brief Indicates whether the parameter is unitary (cardinality = 1)
   * @return whether the parameter is unitary (cardinality = 1)
   */
  inline bool isUnitary() const {
    return (getCardinality() == "1");
  }

  /**
   * @brief cardinality informator getter
   * @return cardinality informator
   */
  std::string getCardinalityInformator() const;

  /**
   * @brief set whether the parameter is the result of a non-unitary parameter instanciation
   * @param nonUnitaryParameterInstance whether the parameter is the result of a non-unitary parameter instanciation
   */
  inline void setIsNonUnitaryParameterInstance(const bool nonUnitaryParameterInstance) {
    nonUnitaryParameterInstance_ = nonUnitaryParameterInstance;
  }

  /**
   * @brief get whether the parameter is the result of a non-unitary parameter instanciation
   * @return whether the parameter is the result of a non-unitary parameter instanciation
   */
  inline bool getIsNonUnitaryParameterInstance() const {
    return nonUnitaryParameterInstance_;
  }

  /**
   * @brief get whether the parameter is fully internal (i.e. may not be updated from outside the model)
   * @return whether the parameter is fully internal
   */
  inline bool isFullyInternal() const {
    return scope_ == INTERNAL_PARAMETER;
  }

  /**
   * @brief get whether the parameter is fully external (i.e. may only be set from outside the model)
   * @return whether the parameter is fully external
   */
  inline bool isFullyExternal() const {
    return scope_ == EXTERNAL_PARAMETER;
  }

  /**
   * @brief TypeError getter
   * @return TypeError getter
   */
  Error::TypeError_t getTypeError() const override;

 private:
  ParameterModeler() = delete;  ///< default constructor

  std::map<parameterOrigin_t, bool> writeRights_;  ///< whether it is allowed to write a given parameter value from a given origin
  std::map <parameterOrigin_t, boost::any> values_;  ///< values of the parameter and its origin
  boost::optional<parameterOrigin_t> origin_;  ///< priority origin of the parameter's value
  parameterScope_t scope_;  ///< scope of the parameter (internal, external or shared)
  std::string cardinality_;  ///< cardinality of the parameter, "1" by default
  std::string cardinalityInformator_;  ///< name of the parameter that gives the value to cardinality
  bool nonUnitaryParameterInstance_;  ///< whether the parameter is an instance of a non-unitary parameter
};
}  // namespace DYN

#include "DYNParameterModeler.hpp"

#endif  // MODELER_COMMON_DYNPARAMETERMODELER_H_
