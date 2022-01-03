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
 * @file  CSTRConstraint.h
 *
 * @brief Dynawo constraint : interface file
 *
 */
#ifndef API_CSTR_CSTRCONSTRAINT_H_
#define API_CSTR_CSTRCONSTRAINT_H_

#include "CSTRConstraintCommon.h"

#include <boost/optional.hpp>
#include <string>

namespace constraints {

/**
 * @brief Constraint data definition
 */
struct ConstraintData {
  /**
   * @brief possible values for kind
   */
  typedef enum { PATL = 0, OverloadUp, OverloadOpen, UInfUmin, USupUmax } kind_t;

  kind_t kind;                                 ///< Kind of constraint
  double limit;                                ///< Limit of the constraint
  double value;                                ///< value of the constraint
  boost::optional<int> side;                   ///< Side the constraint applies
  boost::optional<double> acceptableDuration;  ///< the acceptable duration of the constraint

  /**
   * @brief Construct a new Constraint Data object
   *
   * @param kind Kind of constraint
   * @param limit Limit of the constraint
   * @param value value of the constraint
   * @param side Side the constraint applies
   * @param acceptableDuration the acceptable duration of the constraint
   */
  ConstraintData(kind_t kind, double limit, double value, boost::optional<int> side = boost::none, boost::optional<double> acceptableDuration = boost::none) :
      kind(kind),
      limit(limit),
      value(value),
      side(side),
      acceptableDuration(acceptableDuration) {}
};

/**
 * @brief Constraint
 */
class Constraint {
 public:
  /**
   * @brief Constructor
   */
  Constraint();

  /**
   * @brief Setter for constraint's time
   * @param time constraint's time
   */
  void setTime(const double& time);

  /**
   * @brief Setter for modelName for which constraint occurs
   * @param modelName Model's name for which constraint occurs
   */
  void setModelName(const std::string& modelName);

  /**
   * @brief Setter for model type for which constraint occurs
   * @param modelType Model's type for which constraint occurs
   */
  void setModelType(const std::string& modelType);

  /**
   * @brief Setter for constraint's type (begin or end)
   * @param type constraint's type
   */
  void setType(const Type_t& type);

  /**
   * @brief Setter for constraint's description
   * @param description message to describe constraint
   */
  void setDescription(const std::string& description);

  /**
   * @brief Setter for constraint's data
   * @param data constraint's data
   */
  void setData(const boost::optional<ConstraintData>& data);

  /**
   * @brief Getter for constraint's time
   * @return constraint's time
   */
  double getTime() const;

  /**
   * @brief Getter for modelName for which constraint occurs
   * @return Model's name for which constraint occurs
   */
  const std::string& getModelName() const;

  /**
   * @brief Getter for model type for which constraint occurs
   * @return Model's type for which constraint occurs
   */
  const std::string& getModelType() const;

  /**
   * @brief test if a model type was defined for this constraint
   * @return true if a model type was defined for this constraint
   */
  bool hasModelType() const;

  /**
   * @brief Getter for constraint's type (begin or end)
   * @return constraint's type
   */
  Type_t getType() const;

  /**
   * @brief Getter for constraint's description
   * @return message to describe constraint
   */
  const std::string& getDescription() const;

  /**
   * @brief Getter for constraint's data
   * @return constraint's data
   */
  boost::optional<ConstraintData> getData() const;

 private:
  double time_;              ///< Constraint's time
  Type_t type_;              ///< Constraint's type : begin or end
  std::string modelName_;    ///< Model's name for which constraint occurs
  std::string description_;  ///< Description of the constraint
  std::string modelType_;    ///< Model's type for which constraint occurs

  boost::optional<ConstraintData> data_;  ///< Constraint's detailed data
};
}  // namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINT_H_
