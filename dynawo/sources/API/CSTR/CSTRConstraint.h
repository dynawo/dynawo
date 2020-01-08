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

#include <string>

#include "CSTRConstraintCommon.h"

namespace constraints {

/**
 * class Constraint
 */
class Constraint {
 public:
  virtual ~Constraint() { }

  /**
   * @brief Setter for constraint's time
   * @param time constraint's time
   */
  virtual void setTime(const double& time) = 0;

  /**
   * @brief Setter for modelName for which constraint occurs
   * @param modelName Model's name for which constraint occurs
   */
  virtual void setModelName(const std::string& modelName) = 0;

  /**
   * @brief Setter for model type for which constraint occurs
   * @param modelType Model's type for which constraint occurs
   */
  virtual void setModelType(const std::string& modelType) = 0;

  /**
   * @brief Setter for side for which constraint occurs
   * @param side side for which constraint occurs
   */
  virtual void setSide(const std::string& side) = 0;

  /**
   * @brief Setter for constraint's type (begin or end)
   * @param type constraint's type
   */
  virtual void setType(const Type_t& type) = 0;

  /**
   * @brief Setter for constraint's description
   * @param description message to describe constraint
   */
  virtual void setDescription(const std::string& description) = 0;

  /**
   * @brief Getter for constraint's time
   * @return constraint's time
   */
  virtual double getTime() const = 0;

  /**
   * @brief Getter for modelName for which constraint occurs
   * @return Model's name for which constraint occurs
   */
  virtual std::string getModelName() const = 0;

  /**
   * @brief Getter for model type for which constraint occurs
   * @return Model's type for which constraint occurs
   */
  virtual std::string getModelType() const = 0;

  /**
   * @brief test if a model type was defined for this constraint
   * @return true if a model type was defined for this constraint
   */
  virtual bool hasModelType() const = 0;

  /**
   * @brief Getter for side for which constraint occurs
   * @return side for which constraint occurs
   */
  virtual std::string getSide() const = 0;

  /**
   * @brief test if a side was defined for this constraint
   * @return true if a side was defined for this constraint
   */
  virtual bool hasSide() const = 0;

  /**
   * @brief Getter for constraint's type (begin or end)
   * @return constraint's type
   */
  virtual Type_t getType() const = 0;

  /**
   * @brief Getter for constraint's description
   * @return message to describe constraint
   */
  virtual std::string getDescription() const = 0;

  class Impl;
};
}  // namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINT_H_
