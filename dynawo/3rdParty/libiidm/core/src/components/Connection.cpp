//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file components/Connection.cpp
 * @brief 
 */
#include <IIDM/components/Connection.h>

#include <stdexcept>

namespace IIDM {
/* ****** class Connection ****** */
Connection::Connection(Port const& port, side_id side):
  m_side(side), m_port(port), voltageLevel_id()
{}

Connection::Connection(id_type const& voltageLevel, Port const& port, side_id side):
  m_side(side), m_port(port), voltageLevel_id(voltageLevel)
{}

Connection::Connection(ConnectionPoint const& cp, side_id side):
  m_side(side), m_port(cp.port()), voltageLevel_id(cp.voltageLevel())
{}


ConnectionPoint Connection::connectionPoint() const {
  return ConnectionPoint(voltageLevel(), port());
}


void Connection::status(connection_status_t status) {
  if (!m_port.is_bus()) {
    throw port_error("can't define connection status of a node");
  }
  m_port = Port(m_port.bus(), status);
}

} // end of namespace IIDM::
