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
 * @file  FSVariableImpl.h
 *
 * @brief final state variable : header file
 *
 */
#ifndef API_FS_FSVARIABLEIMPL_H_
#define API_FS_FSVARIABLEIMPL_H_

#include "FSVariable.h"

namespace finalState {

/**
 * @class Variable::Impl
 * @brief final state variable implemented class
 *
 * Variable is a container for a final state requested variable
 */
class Variable::Impl : public Variable {
 public:
  /**
   * @brief Constructor
   *
   * @param id variable's id
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc Variable::setId(const std::string& id)
   */
  void setId(const std::string& id);

  /**
   * @copydoc Variable::setValue(const double& value)
   */
  void setValue(const double& value);

  /**
   * @copydoc Variable::getId()
   */
  std::string getId() const;

  /**
   * @copydoc Variable::getValue()
   */
  double getValue() const;

  /**
   * @copydoc Variable::getAvailable()
   */
  bool getAvailable() const;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string id_;  ///< variable's id
  double value_;  ///< variable's value
  bool available_;  ///< @b true is the value is available, @b false else
};

}  // namespace finalState

#endif  // API_FS_FSVARIABLEIMPL_H_
