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
 * @file DYDMacroConnectionImpl.h
 * @brief MacroConnection description : header file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTIONIMPL_H_
#define API_DYD_DYDMACROCONNECTIONIMPL_H_

#include "DYDMacroConnection.h"

namespace dynamicdata {

/**
 * @class MacroConnection::Impl
 * @brief MacroConnection implemented class
 *
 * Implementation of MacroConnection interface.
 */
class MacroConnection::Impl : public MacroConnection {
 public:
  /**
   * @brief MacroConnection::Impl constructor
   *
   * MacroConnection::Impl constructor.
   *
   * @param var1   First model connected port name
   * @param var2  Second model connected port name
   *
   * @returns New MacroConnection::Impl instance with given attributes
   */
  Impl(const std::string & var1, const std::string & var2);

  /**
   * @brief Connector destructor
   */
  virtual ~Impl();

  /**
   * @copydoc MacroConnection::getFirstVariableId()
   */
  std::string getFirstVariableId() const;

  /**
   * @copydoc MacroConnection::getSecondVariableId()
   */
  std::string getSecondVariableId() const;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string firstVariableId_;  ///< Variable name for the first variable
  std::string secondVariableId_;  ///< Variable name for the second variable
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTIONIMPL_H_
