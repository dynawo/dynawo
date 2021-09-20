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
 * @file src/components/VoltageLevel.cpp
 * @brief VoltageLevel implementation file
 */
#include <IIDM/components/VoltageLevel.h>

#include <stdexcept>
#include <iostream>
#include <sstream>

#include <algorithm>

#include <IIDM/cpp11.h>
#include <IIDM/components/ConnectionPoint.h>
#include <IIDM/components/NetworkOf.h>
#include <IIDM/Network.h>

namespace IIDM {

VoltageLevel::VoltageLevel(Identifier const& id, properties_type const& properties): Identifiable(id, properties) {}


std::ostream& operator<< (std::ostream& stream, VoltageLevel::e_mode mode) {
  switch (mode) {
    case VoltageLevel::bus_breaker : return stream << "bus breaker";
    case VoltageLevel::node_breaker: return stream << "node breaker";
    default:
      //that's not even possible
      return stream;
  }
}

bool VoltageLevel::has(Port const& port) const {
  return (port.is_bus()) ? has(port.bus_id()) : has(port.node());
}

bool VoltageLevel::has(id_type const& bus_id) const {
  return Contains<Bus>::exists(bus_id);
}

bool VoltageLevel::has(node_type const& node) const {
  return node < node_count() && node >=0;
}

bool VoltageLevel::has(ConnectionPoint const& port) const {
  if (port.voltageLevel()!=id()) return false;

  switch (mode()) {
    case node_breaker:
      if (port.is_bus ()) {
        throw std::runtime_error("no bus in the node breaker voltage level "+id());
      }
      return has(port.node());

    case bus_breaker:
      if (port.is_node()) {
        throw std::runtime_error("no node in the bus breaker voltage level "+id());
      }
      return has(port.bus_id());

    default:
      //that's not even possible
      throw std::logic_error("strange mode for voltage level "+id());
  }

}

boost::optional<ActualConnectionPoint> VoltageLevel::validate(ConnectionPoint const& port) const {
  if (!has(port)) throw boost::none;
  return boost::make_optional(ActualConnectionPoint(port));
}



void VoltageLevel::check(Connection const& connection, side_id sides) const {
  if (connection.has_voltageLevel() && connection.voltageLevel()!=id()) {
    std::ostringstream s;
    s<<"Voltage level id mismatch: "<<connection.voltageLevel() << " != " << id();
    throw std::runtime_error(s.str());
  }
  switch (mode()) {
    case bus_breaker:
      if (!connection.port().is_bus()) {
        std::ostringstream s;
        s<<"Bus breaker voltage level "<<id()<<" does not accepts nodes";
        throw std::runtime_error(s.str());
      }
      if (!has(connection.port())) {
        std::ostringstream s;
        s<<"unavailable bus "<<connection.port();
        throw std::runtime_error(s.str());
      }
      break;

    case node_breaker:
      if (!connection.port().is_node()) {
        std::ostringstream s;
        s<<"Node breaker voltage level "<<id()<<" does not accepts buses";
        throw std::runtime_error(s.str());
      }
      if (!has(connection.port())) {
        std::ostringstream s;
        s<<"unavailable port "<<connection.port();
        throw std::runtime_error(s.str());
      }
      break;
  }
  if (connection.side() > sides) {
    throw std::runtime_error("invalide side");
  }
}


void VoltageLevel::register_into(Network & net) {
  net.register_identifiable(*this);

  net.register_all_identifiable(buses());
  net.register_all_identifiable(busBarSections());
  net.register_all_identifiable(switches());

  net.register_all_identifiable(batteries());
  net.register_all_identifiable(loads());
  net.register_all_identifiable(shuntCompensators());
  net.register_all_identifiable(danglingLines());
  net.register_all_identifiable(generators());
  net.register_all_identifiable(staticVarCompensators());
}

VoltageLevel& VoltageLevel::add(Bus const& bus) {
  if (mode()!=bus_breaker) throw std::runtime_error("Bus may only be added to a bus breaker voltage level "+id());

  Bus& added = Contains<Bus>::add(bus);

  Network* net = network_of(*this);
  if (net) net->register_identifiable(added);

  return *this;
}


VoltageLevel& VoltageLevel::add(BusBarSection const& busBarSection) {
  if (mode()!=node_breaker) {
    throw std::runtime_error("BusBarSection may only be added to a node breaker voltage level "+id());
  }
  const node_type node = busBarSection.node();
  if (!has(node)) {
    std::ostringstream oss;
    oss << "unknown node " << node;
    throw std::runtime_error(oss.str());
  }

  BusBarSection& added = Contains<BusBarSection>::add(busBarSection);

  Network* net = network_of(*this);
  if (net) net->register_identifiable(added);

  return *this;
}




VoltageLevel& VoltageLevel::add(Switch const& s, id_type const& bus1, id_type const& bus2) {
  if (mode()!=bus_breaker) throw std::runtime_error("Bus switch may only be added to a bus breaker voltage level "+id());

  if (!has(bus1)) {
    std::ostringstream oss;
    oss << "unknown bus id " << bus1;
    throw std::runtime_error(oss.str());
  }
  if (!has(bus2)) {
    std::ostringstream oss;
    oss << "unknown bus id " << bus2;
    throw std::runtime_error(oss.str());
  }

  return add(s, Port(bus1, connected), Port(bus2, connected));
}

VoltageLevel& VoltageLevel::add(Switch const& s, node_type node1, node_type node2) {
  if (mode()!=node_breaker) throw std::runtime_error("Node switch may only be added to a node breaker voltage level "+id());

  if (!has(node1)) {
    std::ostringstream oss;
    oss << "unknown node " << node1;
    throw std::runtime_error(oss.str());
  }
  if (!has(node2)) {
    std::ostringstream oss;
    oss << "unknown node " << node2;
    throw std::runtime_error(oss.str());
  }

  return add(s, Port(node1), Port(node2));
}


VoltageLevel& VoltageLevel::add(Switch const& s, Port const& port1, Port const& port2) {
  Switch& added = Contains<Switch>::add(s).connectTo(port1, port2);

  Network* net = network_of(*this);
  if (net) net->register_identifiable(added);

  return *this;
}



template <typename T>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< IIDM::tt::is_convertible< T&, Connectable<T, side_1>& >::value, VoltageLevel& >::type
#else
  VoltageLevel&
#endif
VoltageLevel::connect(T const& connectable, boost::optional<Connection> const& c) {
  check(c, side_1);

  T& added = Contains<T>::add(connectable);

  if (c) added.connectTo(id(), c->port());

  Network* net = network_of(*this);
  if (net) net->register_identifiable(added);

  return *this;
}

VoltageLevel& VoltageLevel::add(Battery const& battery, boost::optional<Connection> const& connection) {
  return connect(battery, connection);
}


VoltageLevel& VoltageLevel::add(Load const& load, boost::optional<Connection> const& connection) {
  return connect(load, connection);
}

VoltageLevel& VoltageLevel::add(ShuntCompensator const& ShuntCompensator, boost::optional<Connection> const& connection) {
  return connect(ShuntCompensator, connection);
}

VoltageLevel& VoltageLevel::add(DanglingLine const& danglingLine, boost::optional<Connection> const& connection) {
  return connect(danglingLine, connection);
}

VoltageLevel& VoltageLevel::add(Generator const& generator, boost::optional<Connection> const& connection) {
  return connect(generator, connection);
}

VoltageLevel& VoltageLevel::add(StaticVarCompensator const& svc, boost::optional<Connection> const& connection) {
  return connect(svc, connection);
}

VoltageLevel& VoltageLevel::add(VscConverterStation const& vcs, boost::optional<Connection> const& connection) {
  return connect(vcs, connection);
}

VoltageLevel& VoltageLevel::add(LccConverterStation const& lcs, boost::optional<Connection> const& connection) {
  return connect(lcs, connection);
}

} // end of namespace IIDM::
