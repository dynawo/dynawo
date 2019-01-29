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
 * @file DYDMacroConnectorImpl.h
 * @brief MacroConnector model description : header file
 *
 */

#ifndef API_DYD_DYDMACROCONNECTORIMPL_H_
#define API_DYD_DYDMACROCONNECTORIMPL_H_

#include "DYDMacroConnector.h"

namespace dynamicdata {

/**
 * @class MacroConnector::Impl
 * @brief MacroConnector implemented class
 */
class MacroConnector::Impl : public MacroConnector {
 public:
  /**
   * @brief MacroConnector constructor
   *
   * @param id MacroConnector ID
   *
   * @returns New MacroConnector::Impl instance with given attributes
   */
  explicit Impl(const std::string& id);

  /**
   * @brief MacroConnector destructor
   */
  ~Impl();

  /**
   * @copydoc MacroConnector::getId()
   */
  std::string getId() const;

  /**
   * @copydoc MacroConnector::getConnectors()
   */
  const std::map<std::string, boost::shared_ptr<MacroConnection> >& getConnectors() const;

  /**
   * @copydoc MacroConnector::getInitConnectors()
   */
  const std::map<std::string, boost::shared_ptr<MacroConnection> >& getInitConnectors() const;

  /**
   * @copydoc MacroConnector::addInitConnect()
   */
  MacroConnector& addInitConnect(const std::string& var1, const std::string& var2);

  /**
   * @copydoc MacroConnector::addConnect()
   */
  MacroConnector& addConnect(const std::string& var1, const std::string& var2);

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string id_;  ///< id of the macro connector
  std::map<std::string, boost::shared_ptr<MacroConnection> > initConnectorsMap_;  ///< MacroConnector initialization connectors
  std::map<std::string, boost::shared_ptr<MacroConnection> > connectorsMap_;  ///<  MacroConnector connectors
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECTORIMPL_H_

