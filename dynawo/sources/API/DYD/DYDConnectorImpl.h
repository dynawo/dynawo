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
 * @file DYDConnectorImpl.h
 * @brief Connector description : header file
 *
 */

#ifndef API_DYD_DYDCONNECTORIMPL_H_
#define API_DYD_DYDCONNECTORIMPL_H_

#include "DYDConnector.h"

namespace dynamicdata {

/**
 * @class Connector::Impl
 * @brief Connector implemented class
 *
 * Implementation of Connector interface.
 */
class Connector::Impl : public Connector {
 public:
  /**
   * @brief Connector::Impl constructor
   *
   * Connector::Impl constructor.
   *
   * @param model1  Shared pointer to the first model
   * @param var1   First model connected port name
   * @param model2 Shared pointer to the second model
   * @param var2  Second model connected port name
   *
   * @returns New Connector::Impl instance with given attributes
   */
  Impl(const std::string & model1, const std::string & var1, const std::string & model2, const std::string & var2);

  /**
   * @brief Connector destructor
   */
  virtual ~Impl();

  /**
   * @copydoc Connector::getFirstVariableId()
   */
  std::string getFirstVariableId() const;

  /**
   * @copydoc Connector::getSecondVariableId()
   */
  std::string getSecondVariableId() const;

  /**
   * @copydoc Connector::getFirstModelId()
   */
  std::string getFirstModelId() const;

  /**
   * @copydoc Connector::getSecondModelId()
   */
  std::string getSecondModelId() const;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string firstModelId_; /**< Model name for the first Model */
  std::string firstVariableId_; /**< Variable name for the first Model */
  std::string secondModelId_; /**< Model name for the second Model */
  std::string secondVariableId_; /**< Variable name for the second Model */
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDCONNECTORIMPL_H_
