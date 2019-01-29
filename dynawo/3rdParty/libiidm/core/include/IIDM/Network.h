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
 * @file Network.h
 * @brief Network interface file
 */

#ifndef LIBIIDM_GUARD_NETWORK_H
#define LIBIIDM_GUARD_NETWORK_H

#include <IIDM/Export.h>
#include <IIDM/cpp11_type_traits.h>

#include <IIDM/BasicTypes.h>

#include <IIDM/components/Container.h>
#include <IIDM/components/Connection.h>

#include <IIDM/components/Substation.h>
#include <IIDM/components/Line.h>
#include <IIDM/components/TieLine.h>
#include <IIDM/components/HvdcLine.h>
#include <IIDM/components/ExternalComponent.h>

#include <IIDM/utils/maps.h>
#include <boost/unordered_map.hpp>

namespace IIDM {
class ConnectionPoint;
class VoltageLevel;

namespace builders {
class NetworkBuilder;
} // end of namespace IIDM::builders::


/**
 * @class Network
 * @brief Network description
 */
class IIDM_EXPORT Network:
  public Contains<Substation>,
  public Contains<Line>,
  public Contains<TieLine>,
  public Contains<HvdcLine>,
  public Contains<ExternalComponent>
{
/* ********* data interface ********* */
private:
  id_type m_id;
  std::string m_format;
  std::string m_caseDate;
  int m_forecastDistance;

  typedef std::map<id_type, Identifiable*> identifiables_type;
  identifiables_type m_identifiables;
  
public:
  id_type const& id()  const { return m_id; }
  std::string const& sourceFormat() const { return m_format; }
  std::string const& caseDate() const { return m_caseDate; }
  int forecastDistance() const { return m_forecastDistance; }

/* ****** navigation interface ****** */
public:
  typedef 
    boost::indirect_iterator< map_value_iterator_adapter<identifiables_type::const_iterator> >
  identifiable_const_iterator;
  typedef 
    boost::indirect_iterator< map_value_iterator_adapter<identifiables_type::iterator> >
  identifiable_iterator;
  
  Identifiable const* searchById(id_type const& id) const;
  Identifiable * searchById(id_type const& id);
  
  Identifiable const& getById(id_type const& id) const;
  Identifiable & getById(id_type const& id);

  identifiable_const_iterator identifiable_begin() const { return identifiable_const_iterator(m_identifiables.begin()); }
  identifiable_const_iterator identifiable_end() const { return identifiable_const_iterator(m_identifiables.end()); }

  identifiable_iterator identifiable_begin() { return identifiable_iterator(m_identifiables.begin()); }
  identifiable_iterator identifiable_end() { return identifiable_iterator(m_identifiables.end()); }

private:
  friend class VoltageLevel;
  friend class Substation;

  void register_identifiable(Identifiable & identifiable);
  void register_identifiable(VoltageLevel &);
  
  template <typename Component>
  void register_all_identifiable(Contains<Component> & all) {
    for (typename Contains<Component>::iterator it = all.begin(); it != all.end(); ++it) {
      register_identifiable(*it);
    }
  }

private:
  //short-cut access to VoltageLevels
  typedef boost::unordered_map<id_type, VoltageLevel *> voltageLevels_type;
  voltageLevels_type m_voltageLevels;

public:
  VoltageLevel const& voltageLevel(id_type const& id) const;

/* ****** connection interface ****** */
private:
  //throws if a connection is not valid or does not match the given side count
  void check(Connection const& connection, side_id max_sides) const;

//Substations
public:
  typedef Contains<Substation> substations_type;
  typedef substations_type::iterator substation_iterator;
  typedef substations_type::const_iterator substation_const_iterator;
  
  substations_type const& substations() const { return *this; }
  substations_type & substations() { return *this; }

  substation_const_iterator substations_begin() const { return substations().begin(); }
  substation_const_iterator substations_end() const { return substations().end(); }

  substation_iterator substations_begin() { return substations().begin(); }
  substation_iterator substations_end() { return substations().end(); }

  Substation const& get_substation(id_type const& id) const { return substations().get(id); }
  Substation & get_substation(id_type const& id) { return substations().get(id); }
  
  substation_const_iterator find_substation(id_type const& id) const { return substations().find(id); }
  substation_iterator find_substation(id_type const& id) { return substations().find(id); }

  Substation& add(Substation const&);
  
//Lines
public:
  typedef Contains<Line> lines_type;
  typedef lines_type::iterator line_iterator;
  typedef lines_type::const_iterator line_const_iterator;
  
  lines_type const& lines() const { return *this; }
  lines_type & lines() { return *this; }

  line_const_iterator lines_begin() const { return lines().begin(); }
  line_const_iterator lines_end() const { return lines().end(); }

  line_iterator lines_begin() { return lines().begin(); }
  line_iterator lines_end() { return lines().end(); }

  Line const& get_line(id_type const& id) const { return lines().get(id); }
  Line & get_line(id_type const& id) { return lines().get(id); }
  
  line_const_iterator find_line(id_type const& id) const { return lines().find(id); }
  line_iterator find_line(id_type const& id) { return lines().find(id); }

  Line& add(
    Line const& line,
    boost::optional<Connection> const& connection1,
    boost::optional<Connection> const& connection2
  );

//Tie-Lines
public:
  typedef Contains<TieLine> tielines_type;
  typedef tielines_type::iterator tieline_iterator;
  typedef tielines_type::const_iterator tieline_const_iterator;
  
  tielines_type const& tielines() const { return *this; }
  tielines_type & tielines() { return *this; }

  tieline_const_iterator tielines_begin() const { return tielines().begin(); }
  tieline_const_iterator tielines_end() const { return tielines().end(); }

  tieline_iterator tielines_begin() { return tielines().begin(); }
  tieline_iterator tielines_end() { return tielines().end(); }

  TieLine const& get_tieline(id_type const& id) const { return tielines().get(id); }
  TieLine & get_tieline(id_type const& id) { return tielines().get(id); }
  
  tieline_const_iterator find_tieline(id_type const& id) const { return tielines().find(id); }
  tieline_iterator find_tieline(id_type const& id) { return tielines().find(id); }

  TieLine& add(
    TieLine const& tieline,
    boost::optional<Connection> const& connection1,
    boost::optional<Connection> const& connection2
  );

//HvdcLines
public:
  typedef Contains<HvdcLine> hvdclines_type;
  typedef hvdclines_type::iterator hvdcline_iterator;
  typedef hvdclines_type::const_iterator hvdcline_const_iterator;
  
  hvdclines_type const& hvdclines() const { return *this; }
  hvdclines_type & hvdclines() { return *this; }

  hvdcline_const_iterator hvdclines_begin() const { return hvdclines().begin(); }
  hvdcline_const_iterator hvdclines_end() const { return hvdclines().end(); }

  hvdcline_iterator hvdclines_begin() { return hvdclines().begin(); }
  hvdcline_iterator hvdclines_end() { return hvdclines().end(); }

  HvdcLine const& get_hvdcline(id_type const& id) const { return hvdclines().get(id); }
  HvdcLine & get_hvdcline(id_type const& id) { return hvdclines().get(id); }
  
  hvdcline_const_iterator find_hvdcline(id_type const& id) const { return hvdclines().find(id); }
  hvdcline_iterator find_hvdcline(id_type const& id) { return hvdclines().find(id); }

  HvdcLine& add(HvdcLine const& line);

//ExternalComponents
public:
  typedef Contains<ExternalComponent> externals_type;
  typedef externals_type::iterator external_iterator;
  typedef externals_type::const_iterator external_const_iterator;
  
  externals_type const& externals() const { return *this; }
  externals_type & externals() { return *this; }
  
  external_const_iterator externals_begin() const { return externals().begin(); }
  external_const_iterator externals_end() const { return externals().end(); }

  external_iterator externals_begin() { return externals().begin(); }
  external_iterator externals_end() { return externals().end(); }

  ExternalComponent const& get_externalComponent(id_type const& id) const { return externals().get(id); }
  ExternalComponent & get_externalComponent(id_type const& id) { return externals().get(id); }
  
  external_const_iterator find_externalComponent(id_type const& id) const { return externals().find(id); }
  external_iterator find_externalComponent(id_type const& id) { return externals().find(id); }

  ExternalComponent& add(ExternalComponent const&);
  ExternalComponent& add_externalComponent(id_type const& id) { return add(ExternalComponent(id)); }

public:
  Network(Network const&);

private:
  Network(id_type const& id, std::string const& format, std::string const& caseDate, int forecastDistance):
    m_id(id), m_format(format), m_caseDate(caseDate), m_forecastDistance(forecastDistance)
  {}

  friend class IIDM::builders::NetworkBuilder;
};

} // end of namespace IIDM::

#endif

