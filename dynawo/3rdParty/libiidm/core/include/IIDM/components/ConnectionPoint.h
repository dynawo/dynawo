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
 * @file components/ConnectionPoint.h
 * @brief Connectable interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_CONNECTIONPOINT_H
#define LIBIIDM_COMPONENTS_GUARD_CONNECTIONPOINT_H

#include <string>
#include <iosfwd>
#include <stdexcept>

#include <boost/variant.hpp>

#include <IIDM/Export.h>
#include <IIDM/BasicTypes.h>

namespace IIDM {

struct port_error: public std::runtime_error {
  port_error(std::string const& msg): std::runtime_error(msg) {}
};

/**
 * @brief position in a voltage level (bus id or node).

 * This class is copiable because it is immuable
 */
class IIDM_EXPORT Port {
private:
  // structure to represent a bus connection, which can be electrically connected or not.
  struct bus_port {
    id_type bus;
    connection_status_t status;
    
    bus_port(id_type const& bus, connection_status_t status): bus(bus), status(status) {}
    
    bool operator<(bus_port const& other) const;
    
    int compare(bus_port const& other) const;
    
    bool operator==(bus_port const& other) const { return bus == other.bus && status == other.status; }
  };

  friend std::ostream& operator<<(std::ostream& stream, bus_port const& p);

  boost::variant< node_type, bus_port > port;
  //an enum would be requiered if two modes use the same type for their id

public:
  /// Named constructor for a Port from a node number
  static Port from_node(node_type node) { return Port(node); }

  /// Named constructor for a Port from a bus id
  static Port from_bus(id_type const& bus, connection_status_t status) { return Port(bus, status); }
  
  ///constructs a Port from a node number
  Port(node_type node): port(node) {}

  ///constructs a Port from a bus id
  Port(id_type const& bus, connection_status_t status): port( bus_port(bus, status) ) {}

  ///constructs a Port from a bus id (as plain old C-string)
  // needed because char* is implicitely convertible to node_type, which C++ prefers to id_type const& conversion.
  Port(const char* bus, connection_status_t status): port( bus_port(id_type(bus), status) ) {}

  /**
   * @brief tells if this Port is defined by a node.
   * @returns true if this Port is defined by a node, and false otherwise
   */
  bool is_node() const { return port.which()==0; }

  /**
   * @brief tells if this Port is defined by a bus id.
   * @returns true if this Port is defined by a bus id, and false otherwise
   */
  bool is_bus() const { return port.which()==1; }

  /**
   * @brief gets the node defining this Port.
   * @returns the node number defining this Port.
   * @throws a std::port_error if this Port is not a node, i.e. if is_node() returns false
   */
  node_type node() const;

  /**
   * @brief gets the bus id defining this Port.
   * @returns the bus id defining this Port.
   * @throws a std::port_error if this Port is not a bus, i.e. if is_bus() returns false
   */
  id_type bus() const { return bus_id(); }
  
  /**
   * @brief gets the bus id defining this Port.
   * @returns the bus id defining this Port.
   * @throws a std::port_error if this Port is not a bus, i.e. if is_bus() returns false
   */
  id_type bus_id() const;

  /**
   * @brief tells if this bus is electrically connected.
   * @returns true if this Port is defined by a bus id, and is electrically connected, false otherwise
   * @throws a std::port_error if this Port is not a bus, i.e. if is_bus() returns false
   */
  bool is_bus_connected() const { return bus_status() == connected; }

  /**
   * @brief tells if this bus is electrically connected.
   * @returns true if this Port is defined by a bus id, and is electrically connected, false otherwise
   * @throws a std::port_error if this Port is not a bus, i.e. if is_bus() returns false
   */
  connection_status_t bus_status() const;

  /**
   * @brief tells if this Port is a node or an electrically connected bus.
   * @returns false if this Port is defined by a bus id, and is not electrically connected, true otherwise
   */
  connection_status_t status() const;

  /**
   * @brief tells if two Ports are the same.
   * @return true if the two given ports designate the same node or the same bus, false otherwise
   */
  friend
  inline bool operator==(Port const& a, Port const& b) { return (a.port==b.port); }

  /**
   * @brief tells if two Ports are not the same.
   * @return true if the two given ports designate different nodes or differents bus, or a bus and a node.
   */
  friend
  inline bool operator!=(Port const& a, Port const& b) { return (a.port!=b.port); }


  /**
   * @brief defines a strict order between Ports.
   * Nodes are compared by number, buses by id (in lexical order), and nodes comes before buses
   * @return true if a Port is ordered before another
   */
  friend bool operator<(Port const& a, Port const& b);

  /**
   * @brief compares two Ports.
   * @param other the Port to compare this one to.
   * @returns a number lesser that 0 if this Port is ordered before other, 0 if they are the same, and a number greater to 0 otherwise
   */
  int compare(Port const& other) const;

  /**
   * @brief output a port into a stream
   * @param stream the target stream
   * @param p the Port to output
   * @returns the stream after output
   */
  friend std::ostream& operator<<(std::ostream& stream, Port const& p) { return stream << p.port; }
};

/**
 * @brief connection point in the network, made of a voltage level id, and a port.
 *
 * This class is copiable because it is immuable
 */
class IIDM_EXPORT ConnectionPoint {
private:
  id_type voltageLevel_id;

  Port m_port;
  //an enum would be requiered if two modes use the same type for their id


public:
  /**
   * @name constructors
   * @{
   */

  ConnectionPoint(id_type const& voltageLevel_id, Port const& port):
    voltageLevel_id(voltageLevel_id), m_port(port)
  {}

  ConnectionPoint(id_type const& voltageLevel_id, node_type node):
    voltageLevel_id(voltageLevel_id), m_port(node)
  {}

  ConnectionPoint(id_type const& voltageLevel_id, id_type const& bus, connection_status_t status):
    voltageLevel_id(voltageLevel_id), m_port(bus, status)
  {}
  /** @} */

  /** @{ */
  id_type const& voltageLevel() const { return voltageLevel_id; }

  Port const& port() const { return m_port; }
  /** @} */

  /**@{*/
  /**
   * @brief tells if this ConnectionPoint is defined by a node.
   * @returns true if this ConnectionPoint is defined by a node, and false otherwise
   */
  bool is_node() const { return m_port.is_node(); }

  /**
   * @brief tells if this ConnectionPoint is defined by a bus id.
   * @returns true if this ConnectionPoint is defined by a bus id, and false otherwise
   */
  bool is_bus() const { return m_port.is_bus(); }

  /**
   * @brief gets the node defining this ConnectionPoint.
   * @returns the node number defining this ConnectionPoint.
   * @throws a std::port_error if this ConnectionPoint is not a node, i.e. if is_node() returns false
   */
  node_type node() const { return m_port.node(); }

  /**
   * @brief gets the bus id defining this ConnectionPoint.
   * @returns the bus id defining this ConnectionPoint.
   * @throws a std::port_error if this ConnectionPoint is not a bus, i.e. if is_bus() returns false
   */
  id_type bus() const { return m_port.bus(); }
  
  /**
   * @brief gets the bus id defining this ConnectionPoint.
   * @returns the bus id defining this ConnectionPoint.
   * @throws a std::port_error if this ConnectionPoint is not a bus, i.e. if is_bus() returns false
   */
  id_type bus_id() const { return m_port.bus_id(); }

  /**
   * @brief tells if this bus is electrically connected.
   * @returns true if this ConnectionPoint is defined by a bus id, and is electrically connected, false otherwise
   * @throws a std::port_error if this ConnectionPoint is not a bus, i.e. if is_bus() returns false
   */
  bool is_bus_connected() const { return m_port.is_bus_connected(); }
  
  /**
   * @brief tells if this bus is electrically connected.
   * @returns true if this ConnectionPoint is defined by a bus id, and is electrically connected, false otherwise
   * @throws a std::port_error if this ConnectionPoint is not a bus, i.e. if is_bus() returns false
   */
  connection_status_t bus_status() const { return m_port.bus_status(); }
  
  /**@}*/

  /**
   * @brief output a ConnectionPoint into a stream
   * @returns the given stream after output was done
   */
  friend std::ostream& operator<<(std::ostream&, ConnectionPoint const&);
};


//only ConnectionProvider is able to create ActualConnectionPoint
//this means ActualConnectionPoint may be guarantied by ConnectionProvider to match an existing point
class IIDM_EXPORT ActualConnectionPoint: public ConnectionPoint {
public:
  ActualConnectionPoint(ActualConnectionPoint const& other): ConnectionPoint(other) {}

  ActualConnectionPoint& operator=(ActualConnectionPoint const& other) {
    ConnectionPoint::operator=(other); return *this;
  }

  friend class VoltageLevel;

private:
  explicit ActualConnectionPoint(ConnectionPoint const& cp): ConnectionPoint(cp) {}

  ActualConnectionPoint(id_type const& voltageLevel_id, node_type node):
    ConnectionPoint(voltageLevel_id, node)
  {}

  ActualConnectionPoint(id_type const& voltageLevel_id, id_type const& bus, connection_status_t status):
    ConnectionPoint(voltageLevel_id, bus, status)
  {}

  ActualConnectionPoint& operator=(ConnectionPoint const& other) {
    ConnectionPoint::operator=(other); return *this;
  }
};

} // end of namespace IIDM

#endif

