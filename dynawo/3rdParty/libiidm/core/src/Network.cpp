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
 * @file Network.cpp
 * @brief Network implementation file
 */

#include <IIDM/Network.h>

#include <IIDM/Export.h>
#include <IIDM/cpp11_type_traits.h>

#include <IIDM/BasicTypes.h>

#include <IIDM/components/NetworkOf.h>

namespace IIDM {
Network::Network(Network const& other):
  Contains<Substation>(other),
  Contains<Line>(other),
  Contains<TieLine>(other),
  Contains<HvdcLine>(other),
  Contains<ExternalComponent>(other),
  m_id(other.m_id),
  m_format(other.m_format),
  m_caseDate(other.m_caseDate),
  m_forecastDistance(other.m_forecastDistance)
{
  register_all_identifiable(lines());
  register_all_identifiable(tielines());
  for (substations_type::iterator it = substations().begin(); it!=substations().end(); ++it) {
    it->register_into(*this);
  }
}


VoltageLevel const& Network::voltageLevel(id_type const& id) const {
  voltageLevels_type::const_iterator it = m_voltageLevels.find(id);
  if (it == m_voltageLevels.end()) {
    throw std::runtime_error("There is no voltage level with the id "+id);
  }
  return *it->second;
}

void Network::register_identifiable(Identifiable & identifiable) {
  m_identifiables[identifiable.id()] = &identifiable;
}

void Network::register_identifiable(VoltageLevel & vl) {
  register_identifiable(static_cast<Identifiable&>(vl));
  std::pair<voltageLevels_type::iterator, bool> result = m_voltageLevels.insert(voltageLevels_type::value_type(vl.id(), &vl));
  if (!result.second) result.first->second=&vl;
}


Identifiable const* Network::searchById(id_type const& id) const {
  identifiables_type::const_iterator it = m_identifiables.find(id);
  return (it!=m_identifiables.end()) ? it->second : IIDM_NULLPTR;
}

Identifiable* Network::searchById(id_type const& id) {
  identifiables_type::iterator it = m_identifiables.find(id);
  return (it!=m_identifiables.end()) ? it->second : IIDM_NULLPTR;
}

Identifiable const& Network::getById(id_type const& id) const {
  identifiables_type::const_iterator it = m_identifiables.find(id);
  if (it==m_identifiables.end()) {
    throw std::runtime_error("There is no component with the id "+id);
  }
  return *it->second;
}

Identifiable & Network::getById(id_type const& id) {
  identifiables_type::iterator it = m_identifiables.find(id);
  if (it==m_identifiables.end()) {
    throw std::runtime_error("There is no component with the id "+id);
  }
  return *it->second;
}


//throws if a connection is not valid or does not match the given side count
void Network::check(Connection const& connection, side_id max_sides) const {
  voltageLevel(connection.voltageLevel()).check(connection, max_sides);
}


Substation& Network::add(Substation const& s) {
  Substation& added = Contains<Substation>::add(s);
  
  added.register_into(*this);

  return added;
}

Line& Network::add(
  Line const& line,
  boost::optional<Connection> const& c1,
  boost::optional<Connection> const& c2
) {
  if (c1) check(*c1, side_2);
  if (c2) check(*c2, side_2);

  Line& added = Contains<Line>::add(line);

  register_identifiable(added);
  
  if (c1) added.createConnection(*c1);
  if (c2) added.createConnection(*c2);

  return added;
}

TieLine& Network::add(
  TieLine const& tieline,
  boost::optional<Connection> const& c1,
  boost::optional<Connection> const& c2
) {
  if (c1) check(*c1, side_2);
  if (c2) check(*c2, side_2);

  TieLine& added = Contains<TieLine>::add(tieline);

  register_identifiable(added);
  
  if (c1) added.createConnection(*c1);
  if (c2) added.createConnection(*c2);

  return added;
}

HvdcLine& Network::add(HvdcLine const& hvdcline) {
  HvdcLine& added = Contains<HvdcLine>::add(hvdcline);

  register_identifiable(added);
  
  return added;
}

ExternalComponent& Network::add(ExternalComponent const& e) {
  ExternalComponent& added = Contains<ExternalComponent>::add(e);

  register_identifiable(added);

  return added;
}

} // end of namespace IIDM::
