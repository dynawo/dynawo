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
 * @file components/Connectable.cpp
 * @brief Connectable implementation file
 */
#include <IIDM/components/Connectable.h>

#include <algorithm>
#include <iterator>

#include <sstream>
#include <stdexcept>


using std::string;
using std::map;
using boost::shared_ptr;

namespace IIDM {
namespace details {
bool ConnectableBase::createConnection(Connection const& c){
  std::pair<connections_type::iterator, bool> insertion = m_connections.insert(
    connections_type::value_type(c.side(), c)
  );

  if (!insertion.second) {
    insertion.first->second = c;
  }

  return insertion.second;
}


struct ConnectableBase::connectionPoint_of {
  std::map<side_id, ConnectionPoint>::value_type
  operator() (ConnectableBase::connections_type::value_type const& value) const {
    return std::map<side_id, ConnectionPoint>::value_type(value.first, value.second.connectionPoint());
  }
};

struct ConnectableBase::status_of {
  std::map<side_id, connection_status_t>::value_type
  operator()(ConnectableBase::connections_type::value_type const& value) const {
    return std::map<side_id, connection_status_t>::value_type(value.first, value.second.status());
  }
};


Connection const&
ConnectableBase::at(side_id side) const {
  connections_type::const_iterator it = m_connections.find(side);
  if (it!= m_connections.end()) return it->second;

  std::ostringstream msg;
  msg << "unavailable side value: " << (side+1);
  throw std::runtime_error(msg.str());
}

Connection &
ConnectableBase::at(side_id side) {
  connections_type::iterator it = m_connections.find(side);
  if (it!= m_connections.end()) return it->second;

  std::ostringstream msg;
  msg << "unavailable side value: " << (side+1);
  throw std::runtime_error(msg.str());
}


/** get defined connection points */
std::map<side_id, ConnectionPoint>
ConnectableBase::connectionPoints() const {
  std::map<side_id, ConnectionPoint> values;

  std::transform(
    m_connections.begin(), m_connections.end(),
    std::inserter(values, values.begin()),
    connectionPoint_of()
  );
  return values;
}

/** get connection states */
std::map<side_id, connection_status_t>
ConnectableBase::connectionStates() const {
  std::map<side_id, connection_status_t> values;

  std::transform(
    m_connections.begin(), m_connections.end(),
    std::inserter(values, values.begin()),
    status_of()
  );
  return values;

}

std::vector<side_id> ConnectableBase::sidesByStatus(connection_status_t status) const {
  std::vector<side_id> res;
  for (connections_type::const_iterator it=m_connections.begin(), end=m_connections.end(); it!=end; ++it) {
    if (it->second.status() == status) res.push_back(it->first);
  }
  return res;
}

// individual access

boost::optional<Connection>
ConnectableBase::connection(side_id side) const {
  connections_type::const_iterator it = m_connections.find(side);
  return (it!= m_connections.end()) ? boost::make_optional(it->second) : boost::none;
}

} // end of namespace IIDM::details::
} // end of namespace IIDM::
