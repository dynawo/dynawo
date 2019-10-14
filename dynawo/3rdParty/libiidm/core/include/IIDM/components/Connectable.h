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
 * @file components/Connectable.h
 * @brief Connectable interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_CONNECTABLE_H
#define LIBIIDM_COMPONENTS_GUARD_CONNECTABLE_H

#include <map>
#include <vector>

#include <boost/optional.hpp>


#include <IIDM/cpp11.h>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/ConnectionPoint.h>
#include <IIDM/components/Connection.h>

namespace IIDM {

/**
 @brief base class for for a connectable component.
 @tparam CRTP_COMPONENT the actual type of this Connectable inheriter
 @tparam Sides the number of side of this connectable component
 the general implementation is not defined, only specialization for some side_id are provided
 */
template <typename CRTP_COMPONENT, side_id Sides>
class Connectable;


namespace details {
//private detail class
/**
 * @brief Base class for object having a fixed but arbitrary number of connection point.
 *
 * Shared code base to Connectable<side_2> and Connectable<side_3>
 * Each available connection are not necessary defined.
 *
 * a port may be:
 *   undefined
 *   a node
 *   a connected bus
 *   a connectable bus
 */
class ConnectableBase {
public:
  ///map of connections by side.
  typedef std::map<side_id, Connection> connections_type;
  ///constant iterator of a connections_type.
  typedef connections_type::const_iterator const_iterator;

public:
  /**
  @brief creates or replace the connection of a given side.
  @returns true if there was no connection already defined.
  */
  bool createConnection(Connection const& c);

  /**
  @brief creates or replace the connection of a given side.
  @returns createConnection(voltageLevel, port, side, status)
  */
  bool createConnection(id_type const& voltageLevel, id_type const& bus, side_id side, connection_status_t status) {
    return createConnection( Connection(voltageLevel, Port(bus, status), side) );
  }

  /**
  @brief creates or replace the connection of a given side.
  @returns createConnection(voltageLevel, port, side, status)
  */
  bool createConnection(id_type const& voltageLevel, node_type const& node, side_id side) {
    return createConnection( Connection(voltageLevel, Port(node), side) );
  }

  /**
  @brief creates or replace the connection of a given side.
  @returns createConnection(voltageLevel, port, side, status)
  */
  bool createConnection(id_type const& voltageLevel, Port const& port, side_id side) {
    return createConnection( Connection(voltageLevel, port, side) );
  }

  /**
  @brief creates or replace the connection of a given side.
  @returns createConnection(cp.voltageLevel(), cp.port(), side, status)
  */
  bool createConnection(ConnectionPoint const& cp, side_id side) {
    return createConnection( Connection(cp, side) );
  }

protected:
  /**
   * @brief constructs a ConnectableBase with a specific side count
   * @param max the maximum side allowed in this ConnectableBase
   */
  explicit ConnectableBase(side_id max): max_sides(max) {}

  /**
   * @brief destucts this ConnectableBase.
   */
  ~ConnectableBase() {};


  /**
   * @brief gets the connection at a given side.
   * @returns a constant reference to the connection at the requested side
   * @throws std::runtime_error if no connection is available at this side
   */
  Connection const& at(side_id) const;

  /**
   * @brief gets the connection at a given side.
   * @returns a reference to the connection at the requested side
   * @throws std::runtime_error if no connection is available at this side
   */
  Connection & at(side_id side);

public:
  ///gets the number of available sides
  side_id side_count() const { return max_sides; }

  /**
   * @brief tells if a given side is accepted by this ConnectableBase
   * @returns true if the given side is acceptable, false otherwise
   */
  bool allows_side(side_id s) const { return side_count() <= s; }

  /**
   * @brief tells if this Connectable has a connection at a given side.
   * @returns true if the given side is defined, false otherwise
   */
  bool has_connection(side_id s) const { return m_connections.find(s)!=m_connections.end(); }


  /**
   * @brief gets an iterator to the first defined connection.
   * @returns connections().begin();
   */
  const_iterator begin() const { return m_connections.begin(); }

  /**
   * @brief gets an iterator to the past-the-end connection.
   * @returns connections().end();
   */
  const_iterator end() const { return m_connections.end(); }

  // individual access

  /**
   * @brief gets the potential connection at a given side.
   * @returns the connection if defined, boost::none otherwise.
   */
  boost::optional<Connection> connection(side_id) const;

  /**
   * @brief gets connection status at a given side.
   * @returns at(side).status()
   * @throws std::port_error if no connection is available at this side
   */
  connection_status_t getConnectionState(side_id side) const { return at(side).status(); }

  /**
   * @brief tells if the connection at a given side is connected.
   * @returns at(side).status()==connected
   * @throws std::port_error if no connection is available at this side
   */
  bool isConnected(side_id side) const { return getConnectionState(side) == connected; }

  /**
   * @brief tells if the connection at a given side is disconnected.
   * @returns at(side).status()==disconnected
   * @throws std::port_error if no connection is available at this side
   */
  bool isDisconnected(side_id side) const { return getConnectionState(side) == disconnected; }

  /**
   * @brief sets connection status at a given side.
   * @throws std::port_error if no connection is available at this side
   */
  void setConnectionState(side_id side, connection_status_t status) {at(side).status(status);}

  /**
   * @brief connects the connection at a given side.
   * @throws std::port_error if no connection is available at this side
   */
  void connect(side_id side) {setConnectionState(side, connected);}

  /**
   * @brief disconnects the connection at a given side.
   * @throws std::port_error if no connection is available at this side
   */
  void disconnect(side_id side) {setConnectionState(side, disconnected);}

  //state access:

  /** @brief gets defined connections */
  connections_type const& connections() const { return m_connections; }

  /** @brief gets defined connection points */
  std::map<side_id, ConnectionPoint> connectionPoints() const;



  // bus breaker view related


  /** @brief gets connection statuses for each sides */
  std::map<side_id, connection_status_t> connectionStates() const;


  /** @brief gets the sides in a given connection status */
  std::vector<side_id> sidesByStatus(connection_status_t) const;


  /**
   * @brief gets the sides with a defined connection in the connected state.
   * @returns sidesByStatus(connected)
   */
  std::vector<side_id> connectedSides() const { return sidesByStatus(connected); }

  /**
   * @brief gets the sides with a defined connection in the disconnected state.
   * @returns sidesByStatus(disconnected)
   */
  std::vector<side_id> disconnectedSides() const { return sidesByStatus(disconnected); }


private:
  //a functor structure to be used with connections
  struct connectionPoint_of;

  //a functor structure to be used with connectionStates
  struct status_of;

  connections_type m_connections;

  side_id max_sides;
};

} // end of namespace IIDM::details::


/**
 @brief base class for for a one-sided component.
 @tparam CRTP_COMPONENT the actual type of this Connectable inheriter
 */
template <typename CRTP_COMPONENT>
class Connectable<CRTP_COMPONENT, side_1> {
public:
  typedef CRTP_COMPONENT component_type;

protected:
  /**
   * @brief constructs a one-sided Connectable
   */
  explicit Connectable(): m_connection() {}

  /**
   * @brief destucts this one-sided Connectable.
   */
  ~Connectable() {};


public:
  ///establish the connection
  component_type& connectTo(id_type const& voltageLevel, Port const& port) {
    m_connection = Connection(voltageLevel, port, side_1);
    return *static_cast<component_type*>(this);
  }

public:
  ///gets the number of available sides
  IIDM_CONSTEXPR side_id side_count() const { return side_1; }

  /**
   * @brief tells if the connection is defined.
   * @returns true if the connection is defined, false otherwise
   */
  bool has_connection() const { return static_cast<bool>(m_connection); }

  /**
   * @brief gets the potential connection.
   * @returns the connection if defined, boost::none otherwise.
   */
  boost::optional<Connection> const& connection() const {return m_connection;}

public:
  /**
   * @brief tells if this Connectable has a connection to a node.
   * @returns true if this Connectable has a connection which is defined by a node, and false otherwise
   */
  bool is_node() const { return m_connection && m_connection->is_node(); }

  /**
   * @brief tells if this Connectable has a connection to a bus.
   * @returns true if this Connectable has a connection which is defined by a bus, and false otherwise
   */
  bool is_bus () const { return m_connection && m_connection->is_bus(); }

  /**
   * @brief gets the node of this Connectable.
   * @returns the node number of the connection of this Connectable.
   * @throws a std::runtime_error if is_node() returns false
   */
  node_type node() const { return m_connection->node(); }

  /**
   * @brief gets the bus id of this Connectable.
   * @returns the bus id of the connection of this Connectable.
   * @throws a std::runtime_error if is_bus() returns false
   */
  id_type bus() const { return m_connection->bus(); }

  /**
   * @brief gets the bus id of this Connectable.
   * @returns the bus id of the connection of this Connectable.
   * @throws a std::runtime_error if is_bus() returns false
   */
  id_type bus_id() const { return m_connection->bus_id(); }

private:
  boost::optional<Connection> & connection() {return m_connection;}

public:
  /** @brief gets defined connection points */
  boost::optional<ConnectionPoint> connectionPoint() const {
    return (m_connection) ? boost::make_optional(m_connection->connectionPoint()) : boost::none;
  }

  /**
   * @brief gets the connection status.
   * @returns connection().status()
   * @throws std::runtime_error if no connection is available
   */
  connection_status_t connectionStatus() const { return connection()->status(); }

  /**
   * @brief tells if the connection is actually connected.
   * @returns connection().status()==connected
   * @throws std::runtime_error if no connection is available
   */
  bool isConnected() const { return connectionStatus() == connected; }

  /**
   * @brief tells if the connection is actually disconnected.
   * @returns connection().status()==disconnected
   * @throws std::runtime_error if no connection is available
   */
  bool isDisconnected() const { return connectionStatus() == disconnected; }


  /**
   * @brief sets connection status at a given side.
   * @throws std::port_error if the connection is node based
   * @throws std::runtime_error if no connection is available at this side
   */
  component_type& setConnectionState(connection_status_t status) {
    m_connection->status(status);
    return *static_cast<component_type*>(this);
  }

  /**
   * @brief connects the connection at a given side.
   * @throws std::port_error if the connection is node based
   * @throws std::runtime_error if no connection is available at this side
   */
  component_type& connect() { return setConnectionState(connected); }

  /**
   * @brief disconnects the connection at a given side.
   * @throws std::port_error if the connection is node based
   * @throws std::runtime_error if no connection is available at this side
   */
  component_type& disconnect() { return setConnectionState(disconnected); }

private:
  boost::optional<Connection> m_connection;
};

/**
 @brief base class for for a two sided component.
 @tparam CRTP_COMPONENT the actual type of this Connectable inheriter
 */
template <typename CRTP_COMPONENT>
class Connectable<CRTP_COMPONENT, side_2> : public details::ConnectableBase {
public:
  typedef CRTP_COMPONENT component_type;

  ///number of sides of this connectable
  static IIDM_CONSTEXPR side_id const sides = side_2;

protected:
  Connectable(): details::ConnectableBase(side_2) {}
  ~Connectable() {};

public:
  ///establish the connection to side one
  component_type& connectSide1To(ConnectionPoint const& port) {
    createConnection(port, side_1);
    return *static_cast<component_type*>(this);
  }

  ///establish the connection to side two
  component_type& connectSide2To(ConnectionPoint const& port) {
    createConnection(port, side_2);
    return *static_cast<component_type*>(this);
  }
};

/**
 @brief base class for for a three sided component.
 @tparam CRTP_COMPONENT the actual type of this Connectable inheriter
 */
template <typename CRTP_COMPONENT>
class Connectable<CRTP_COMPONENT, side_3> : public details::ConnectableBase {
public:
  typedef CRTP_COMPONENT component_type;

  ///number of sides of this connectable
  static IIDM_CONSTEXPR side_id const sides = side_3;

protected:
  Connectable(): details::ConnectableBase(side_3) {}
  ~Connectable() {};

public:
  ///establish the connection to side one
  component_type& connectSide1To(ConnectionPoint const& port) {
    createConnection(port, side_1);
    return *static_cast<component_type*>(this);
  }

  ///establish the connection to side two
  component_type& connectSide2To(ConnectionPoint const& port) {
    createConnection(port, side_2);
    return *static_cast<component_type*>(this);
  }

  ///establish the connection to side three
  component_type& connectSide3To(ConnectionPoint const& port) {
    createConnection(port, side_3);
    return *static_cast<component_type*>(this);
  }
};

} // end of namespace IIDM

#endif
