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
 * @file components/Connection.h
 * @brief Connection interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_CONNECTION_H
#define LIBIIDM_COMPONENTS_GUARD_CONNECTION_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/BasicTypes.h>

#include <IIDM/components/ConnectionPoint.h>

namespace IIDM {

/**
 * @brief describe a connection between a voltage level and a component.
 *
 * Includes a potential voltage level id
 * This class is copiable because it is immuable
 */
class IIDM_EXPORT Connection {
public:
  ///constructs a connection
  Connection(Port const&, side_id);

  ///constructs a connection
  Connection(id_type const& voltageLevel, Port const&, side_id);

  ///constructs a connection
  Connection(ConnectionPoint const&, side_id);

public:
  ///port of the voltage level
  Port const& port() const { return m_port; }

  ///sets if the component is actually connected or not.
  ///throws port_error if this connection is not related to a bus.
  void status(connection_status_t status);
  
  ///side of the component
  side_id side() const { return m_side; }
  
  ///gets the voltage level id of this connection
  bool has_voltageLevel() const { return static_cast<bool>(voltageLevel_id); }

  ///gets the voltage level id of this connection
  id_type const& voltageLevel() const { return *voltageLevel_id; }
  
  boost::optional<id_type> const& voltageLevel_optional() const { return voltageLevel_id; }

  ///gets a ConnectionPoint view of this connection
  ConnectionPoint connectionPoint() const;

public:
  /**
   * @brief tells if this connection  is defined by a node.
   * @returns true if this connection is defined by a node, and false otherwise
   */
  bool is_node() const { return m_port.is_node(); }

  /**
   * @brief tells if this connection is defined by a bus id.
   * @returns true if this connection is defined by a bus id, and false otherwise
   */
  bool is_bus () const { return m_port.is_bus(); }

  /**
   * @brief gets the node of this connection.
   * @returns the node number of this connection.
   * @throws a std::port_error if the Port is not a node, i.e. if is_node() returns false
   */
  node_type node() const { return m_port.node(); }

  /**
   * @brief gets the bus id of this Connection.
   * @returns the bus id of this connection.
   * @throws a std::port_error if the Port is not a bus, i.e. if is_bus() returns false
   */
  id_type bus_id() const { return m_port.bus_id(); }

  /**
   * @brief gets the bus id of this Connection.
   * @returns the bus id of this connection.
   * @throws a std::port_error if the Port is not a bus, i.e. if is_bus() returns false
   */
  id_type bus() const { return m_port.bus(); }
  
  /**
   * @brief tells if this connection is electrically connected.
   * @returns true if this connection is defined by a bus id, and is connected, or is a node, false otherwise
   */
  connection_status_t status() const { return m_port.status(); }
  
  /**
   * @brief tells if this connection is on an electrically connected bus.
   * @returns true if this connection is defined by a bus id, and is connected, false otherwise
   * @throws a std::port_error if this connection is not on a bus, i.e. if is_bus() returns false
   */
  connection_status_t bus_status() const { return m_port.bus_status(); }
  
  /**
   * @brief tells if this connection is on an electrically connected bus.
   * @returns true if this connection is defined by a bus id, and is connected, false otherwise
   * @throws a std::port_error if this connection is not on a bus, i.e. if is_bus() returns false
   */
  bool is_bus_connected() const { return m_port.is_bus_connected(); }

private:
  //order of members influences object size
  side_id m_side;
  Port m_port;
  boost::optional<id_type> voltageLevel_id;
};

///creates a connection
inline IIDM_EXPORT Connection at(Port const& port, side_id s = side_1) {
  return Connection(port, s);
}

///creates a connection
inline IIDM_EXPORT Connection at(id_type const& bus, connection_status_t status, side_id s = side_1) {
  return Connection(Port(bus, status), s);
}

///creates a connection
inline IIDM_EXPORT Connection at(node_type const& node, side_id s = side_1) {
  return Connection(Port(node), s);
}


///creates a full connection
inline IIDM_EXPORT Connection at(id_type const& voltageLevel, Port const& port, side_id s = side_1) {
  return Connection(voltageLevel, port, s);
}

///creates a full connection
inline IIDM_EXPORT Connection at(id_type const& voltageLevel, id_type const& bus, connection_status_t status, side_id s = side_1) {
  return Connection(voltageLevel, Port(bus, status), s);
}

///creates a full connection
inline IIDM_EXPORT Connection at(id_type const& voltageLevel, node_type const& node, side_id s = side_1) {
  return Connection(voltageLevel, Port(node), s);
}


///creates a full connection from a connection point (voltagelevel and port), a status and an optional side
inline IIDM_EXPORT Connection at(ConnectionPoint const& cp, side_id s = side_1) {
  return Connection(cp, s);
}


} // end of namespace IIDM

#endif

