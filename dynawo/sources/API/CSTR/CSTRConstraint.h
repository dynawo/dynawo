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

#include <string>

namespace constraints {

/**
 * class Constraint
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

 private:
  double time_;              ///< Constraint's time
  Type_t type_;              ///< Constraint's type : begin or end
  std::string modelName_;    ///< Model's name for which constraint occurs
  std::string description_;  ///< Description of the constraint
  std::string modelType_;    ///< Model's type for which constraint occurs
};
}  // namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINT_H_
