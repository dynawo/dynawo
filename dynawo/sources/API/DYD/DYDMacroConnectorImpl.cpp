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
 * @file DYDMacroConnectorImpl.cpp
 * @brief MacroConnector : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "DYDMacroConnectorImpl.h"
#include "DYDMacroConnectionFactory.h"
#include "DYDMacroConnection.h"

using std::string;
using std::map;
using boost::shared_ptr;

namespace dynamicdata {

MacroConnector::Impl::Impl(const string& id) :
id_(id) {
}

MacroConnector::Impl::~Impl() {
}

string
MacroConnector::Impl::getId() const {
  return id_;
}

const map<string, shared_ptr<MacroConnection> >&
MacroConnector::Impl::getInitConnectors() const {
  return initConnectorsMap_;
}

const map<string, shared_ptr<MacroConnection> >&
MacroConnector::Impl::getConnectors() const {
  return connectorsMap_;
}

MacroConnector&
MacroConnector::Impl::addConnect(const string& var1, const string& var2) {
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  string connectionId;
  if (var1 < var2)
    connectionId = var1 + '_' + var2;
  else
    connectionId = var2 + '_' + var1;

  // to avoid necessity to create MacroConnection::Impl default constructor
  std::pair<std::map<std::string, boost::shared_ptr<MacroConnection> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = connectorsMap_.emplace(connectionId, shared_ptr<MacroConnection>(MacroConnectionFactory::newMacroConnection(var1, var2)));
#else
  ret = connectorsMap_.insert(std::make_pair(connectionId, shared_ptr<MacroConnection>(MacroConnectionFactory::newMacroConnection(var1, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectionIDNotUnique, connectionId);
  return *this;
}

MacroConnector&
MacroConnector::Impl::addInitConnect(const string& var1, const string& var2) {
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  string connectionId;
  if (var1 < var2)
    connectionId = var1 + '_' + var2;
  else
    connectionId = var2 + '_' + var1;

  // to avoid necessity to create MacroConnection::Impl default constructor
  std::pair<std::map<std::string, boost::shared_ptr<MacroConnection> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = initConnectorsMap_.emplace(connectionId, shared_ptr<MacroConnection>(MacroConnectionFactory::newMacroConnection(var1, var2)));
#else
  ret = initConnectorsMap_.insert(std::make_pair(connectionId, shared_ptr<MacroConnection>(MacroConnectionFactory::newMacroConnection(var1, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectionIDNotUnique, id_, var1, var2);
  return *this;
}

}  // namespace dynamicdata
