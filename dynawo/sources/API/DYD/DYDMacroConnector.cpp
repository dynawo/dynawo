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
 * @file DYDMacroConnector.cpp
 * @brief MacroConnector : implementation file
 *
 */

#include "DYDMacroConnector.h"

#include "DYDMacroConnection.h"
#include "DYDMacroConnectionFactory.h"
#include "DYNMacrosMessage.h"

using std::map;
using std::string;

namespace dynamicdata {

MacroConnector::MacroConnector(const string& id) : id_(id) {}

const string&
MacroConnector::getId() const {
  return id_;
}

const map<string, std::unique_ptr<MacroConnection> >&
MacroConnector::getInitConnectors() const {
  return initConnectorsMap_;
}

const map<string, std::unique_ptr<MacroConnection> >&
MacroConnector::getConnectors() const {
  return connectorsMap_;
}

MacroConnector&
MacroConnector::addConnect(const string& var1, const string& var2) {
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  string connectionId;
  if (var1 < var2)
    connectionId = var1 + '_' + var2;
  else
    connectionId = var2 + '_' + var1;

  // to avoid necessity to create MacroConnection::Impl default constructor
  std::pair<std::map<std::string, std::unique_ptr<MacroConnection> >::iterator, bool> ret;
  ret = connectorsMap_.emplace(connectionId, MacroConnectionFactory::newMacroConnection(var1, var2));
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectionIDNotUnique, connectionId);
  return *this;
}

MacroConnector&
MacroConnector::addInitConnect(const string& var1, const string& var2) {
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  string connectionId;
  if (var1 < var2)
    connectionId = var1 + '_' + var2;
  else
    connectionId = var2 + '_' + var1;

  // to avoid necessity to create MacroConnection::Impl default constructor
  std::pair<std::map<std::string, std::unique_ptr<MacroConnection> >::iterator, bool> ret;
  ret = initConnectorsMap_.emplace(connectionId, MacroConnectionFactory::newMacroConnection(var1, var2));
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectionIDNotUnique, id_, var1, var2);
  return *this;
}

}  // namespace dynamicdata
