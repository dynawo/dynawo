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
 * @file  CSTRConstraintImpl.h
 *
 * @brief Dynawo constraint : header file
 *
 */
#ifndef API_CSTR_CSTRCONSTRAINTIMPL_H_
#define API_CSTR_CSTRCONSTRAINTIMPL_H_

#include "CSTRConstraint.h"

namespace constraints {

/**
 * @class Constraint::Impl
 * @brief Constraint implemented class
 *
 * Implementation of Constraint interface class
 */
class Constraint::Impl : public Constraint {
 public:
  /**
   * @brief Constructor
   */
  Impl();

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc Constraint::setTime(const double& time)
   */
  void setTime(const double& time);

  /**
   * @copydoc Constraint::setModelName(const std::string& modelName)
   */
  void setModelName(const std::string& modelName);

  /**
   * @copydoc Constraint::setModelType(const std::string& modelType)
   */
  void setModelType(const std::string& modelType);

  /**
   * @copydoc Constraint::setType(const Type_t& type)
   */
  void setType(const Type_t& type);

  /**
   * @copydoc Constraint::setDescription(const std::string& description)
   */
  void setDescription(const std::string& description);

  /**
   * @copydoc Constraint::getTime() const
   */
  double getTime() const;

  /**
   * @copydoc Constraint::getModelName() const
   */
  std::string getModelName() const;

  /**
   * @copydoc Constraint::getModelType() const
   */
  std::string getModelType() const;

  /**
   * @copydoc Constraint::hasModelType() const
   */
  bool hasModelType() const;

  /**
   * @copydoc Constraint::getType() const
   */
  Type_t getType() const;

  /**
   * @copydoc Constraint::getDescription() const
   */
  std::string getDescription() const;

 private:
  double time_;  ///< Constraint's time
  Type_t type_;  ///< Constraint's type : begin or end
  std::string modelName_;  ///< Model's name for which constraint occurs
  std::string description_;  ///< Description of the constraint
  std::string modelType_;  ///< Model's type for which constraint occurs
};
}  // end of namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTIMPL_H_
