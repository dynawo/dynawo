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
 * @file components/ConnectionPoint.cpp
 * @brief
 */
#include <IIDM/components/ConnectionPoint.h>

#include <iostream>
#include <sstream>
#include <stdexcept>

namespace IIDM {

/* ****** class Port ****** */

int Port::compare(Port const& other) const {
  return (this->port==other.port) ? 0 : (this->port < other.port ? -1 : 1);
}

bool operator<(Port const& a, Port const& b) {
  if (a.is_node() != b.is_node()) return a.is_bus();

  return a.port < b.port;
}

node_type Port::node() const {
  if (!is_node()) {
    std::ostringstream str;
    str << "bus " << boost::get<bus_port>(port).bus << " used as node";
    throw port_error(str.str());
  }

  return boost::get<node_type>(port);
}

id_type Port::bus_id() const {
  if (!is_bus()) {
    std::ostringstream str;
    str << "node " << boost::get<node_type>(port) << " used as bus";
    throw port_error(str.str());
  }

  return boost::get<bus_port>(port).bus;
}

connection_status_t Port::bus_status() const {
  if (!is_bus()) {
    std::ostringstream str;
    str << "node " << boost::get<node_type>(port) << " used as bus";
    throw port_error(str.str());
  }

  return boost::get<bus_port>(port).status;
}

connection_status_t Port::status() const {
  return is_node() ? connected : boost::get<bus_port>(port).status;
}

/* ****** class Port::bus_port ****** */
int Port::bus_port::compare(bus_port const& other) const {
  const int cmp = bus.compare(other.bus);
  if (cmp!=0) return cmp;
  if (status != other.status) return status == connected ? -1 : 1;
  return 0;
}

bool Port::bus_port::operator<(bus_port const& other) const {
  return compare(other) < 0;
}

std::ostream& operator<<(std::ostream& stream, Port::bus_port const& p) {
  return p.status==connected ? stream << p.bus : stream << '(' << p.bus << ')';
}

/* ****** class ConnectionPoint ****** */

std::ostream& operator<<(std::ostream& stream, ConnectionPoint const& cp) {
  return stream << cp.voltageLevel_id << ':' << cp.m_port;
}

} // end of namespace IIDM::
