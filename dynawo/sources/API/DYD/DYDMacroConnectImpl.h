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
 * @file DYDMacroConnectImpl.h
 * @brief MacroConnect description : header file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTIMPL_H_
#define API_DYD_DYDMACROCONNECTIMPL_H_

#include "DYDMacroConnect.h"

namespace dynamicdata {

/**
 * @class MacroConnect::Impl
 * @brief MacroConnect implemented class
 */
class MacroConnect::Impl : public MacroConnect {
 public:
  /**
   * @brief MacroConnect::Impl constructor
   *
   * MacroConnect::Impl constructor.
   *
   * @param connector id of the connector
   * @param model1  id of the first model
   * @param model2  id of the second model
   *
   * @returns New MacroConnect::Impl instance with given attributes
   */
  Impl(const std::string & connector, const std::string & model1, const std::string & model2);

  /**
   * @brief MacroConnect destructor
   */
  virtual ~Impl();

  /**
   * @copydoc MacroConnect::getConnector()
   */
  std::string getConnector() const;

  /**
   * @copydoc MacroConnect::getFirstModelId()
   */
  std::string getFirstModelId() const;

  /**
   * @copydoc MacroConnect::getSecondModelId()
   */
  std::string getSecondModelId() const;

  /**
   * @copydoc MacroConnect::setIndex1()
   */
  void setIndex1(const std::string& index1);

  /**
   * @copydoc MacroConnect::setIndex2()
   */
  void setIndex2(const std::string& index2);

  /**
   * @copydoc MacroConnect::setName1()
   */
  void setName1(const std::string& name1);

  /**
   * @copydoc MacroConnect::setName2()
   */
  void setName2(const std::string& name2);

  /**
   * @copydoc MacroConnect::getIndex1() const
   */
  std::string getIndex1() const;

  /**
   * @copydoc MacroConnect::getIndex2() const
   */
  std::string getIndex2() const;

  /**
   * @copydoc MacroConnect::getName1() const
   */
  std::string getName1() const;

  /**
   * @copydoc MacroConnect::getName2() const
   */
  std::string getName2() const;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string connectorId_;  ///< id of the connector
  std::string firstModelId_;  ///< Model name for the first Model
  std::string secondModelId_;  ///< Model name for the second Model
  std::string index1_;  ///< index of the first model to replace \@INDEX\@
  std::string index2_;  ///< index of the second model to replace \@INDEX\@
  std::string name1_;  ///< name of the first model to replace \@NAME\@
  std::string name2_;  ///< name of the second model to replace \@NAME\@
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTIMPL_H_
