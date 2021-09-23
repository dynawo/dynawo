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
 * @file components/VoltageLevel.h
 * @brief VoltageLevel
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_VOLTAGELEVEL_H
#define LIBIIDM_COMPONENTS_GUARD_VOLTAGELEVEL_H

#include <string>
#include <iosfwd>
#include <boost/optional.hpp>


#include <IIDM/cpp11_type_traits.h>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/ConnectionPoint.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Connectable.h>
#include <IIDM/components/Container.h>
#include <IIDM/components/ContainedIn.h>

#include <IIDM/components/Bus.h>
#include <IIDM/components/BusBarSection.h>
#include <IIDM/components/Switch.h>

#include <IIDM/components/Battery.h>
#include <IIDM/components/Load.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/Generator.h>
#include <IIDM/components/StaticVarCompensator.h>
#include <IIDM/components/VscConverterStation.h>
#include <IIDM/components/LccConverterStation.h>

namespace IIDM {

class Network;
class Substation;

namespace builders {
class VoltageLevelBuilder;
} // end of namespace IIDM::builders::

//note: Contains<*> are inherited privately to hide non controlling add overloads.
/**
 * @brief VoltageLevel in the network.
 * A voltage level is either bus or node oriented.
 * in node mode, nodes are in the [0, node_count) range
 */
class VoltageLevel:
  public Identifiable,
  public ContainedIn<Substation>,
  public Contains<Bus>,
  public Contains<BusBarSection>,
  public Contains<Switch>,
  public Contains<Battery>,
  public Contains<Load>,
  public Contains<ShuntCompensator>,
  public Contains<DanglingLine>,
  public Contains<Generator>,
  public Contains<StaticVarCompensator>,
  public Contains<VscConverterStation>,
  public Contains<LccConverterStation>
{
/* ********* data interface ********* */
public:
  //aliases of parent()
  ///tells if a parent substation is specified
  bool has_substation() const { return has_parent(); }

  ///gets a constant reference to the parent substation
  Substation const& substation() const { return parent(); }
  ///gets a reference to the parent substation
  Substation & substation() { return parent(); }

public:
  enum e_mode {bus_breaker, node_breaker};

  e_mode mode() const { return m_mode; }

  node_type node_count() const { return m_node_count; }

  double nominalV() const { return m_nominalV; }


  /** tells if the low voltage limit is set */
  bool has_lowVoltageLimit() const { return static_cast<bool>(m_lowVoltageLimit); }

  /** gets the low voltage limit
   * @throws boost::bad_optional_access if not set
   */
  double lowVoltageLimit() const { return m_lowVoltageLimit.value(); }

  /** gets the optional  */
  boost::optional<double> const& optional_lowVoltageLimit() const { return m_lowVoltageLimit; }

  /** sets the low voltage limit */
  VoltageLevel& lowVoltageLimit(double l) { m_lowVoltageLimit = l; return *this; }

  /** sets the low voltage limit (or unsets if used with boost::none or an empty optional) */
  VoltageLevel& lowVoltageLimit(boost::optional<double> const& l) { m_lowVoltageLimit = l; return *this; }


  /** tells if the high voltage limit is set */
  bool has_highVoltageLimit() const { return static_cast<bool>(m_highVoltageLimit); }

  /** gets the high voltage limit
   * @throws boost::bad_optional_access if not set
   */
  double highVoltageLimit() const { return m_highVoltageLimit.value(); }

  /** gets the optional  */
  boost::optional<double> const& optional_highVoltageLimit() const { return m_highVoltageLimit; }

  /** sets the high voltage limit */
  VoltageLevel& highVoltageLimit(double l) { m_highVoltageLimit = l; return *this; }

  /** sets the high voltage limit (or unsets if used with boost::none or an empty optional) */
  VoltageLevel& highVoltageLimit(boost::optional<double> const& l) { m_highVoltageLimit = l; return *this; }

private:
  e_mode m_mode;

  node_type m_node_count;
  double m_nominalV;

  boost::optional<double> m_lowVoltageLimit;
  boost::optional<double> m_highVoltageLimit;


/* ****** connection interface ****** */
public:
  bool has(Port const& node) const;

  bool has(id_type const& bus_id) const;

  bool has(node_type const& node) const;

  bool has(ConnectionPoint const&) const;

  boost::optional<ActualConnectionPoint> validate(ConnectionPoint const&) const;

  //throws if a connection is not valid or does not match the given side count
  void check(Connection const& connection, side_id max_sides) const;

  void register_into(Network &);


//Buses
public:
  typedef Contains<Bus> buses_type;
  typedef buses_type::iterator bus_iterator;
  typedef buses_type::const_iterator bus_const_iterator;

  buses_type const& buses() const { return *this; }
  buses_type & buses() { return *this; }

  bus_const_iterator buses_begin() const { return buses().begin(); }
  bus_const_iterator buses_end() const { return buses().end(); }

  bus_iterator buses_begin() { return buses().begin(); }
  bus_iterator buses_end() { return buses().end(); }

  Bus const& get_bus(id_type const& id) const { return buses().get(id); }
  Bus & get_bus(id_type const& id) { return buses().get(id); }

  bus_const_iterator find_bus(id_type const& id) const { return buses().find(id); }
  bus_iterator find_bus(id_type const& id) { return buses().find(id); }

//BusBarSections
public:
  typedef Contains<BusBarSection> busBarSections_type;
  typedef busBarSections_type::iterator busBarSection_iterator;
  typedef busBarSections_type::const_iterator busBarSection_const_iterator;

  busBarSections_type const& busBarSections() const { return *this; }
  busBarSections_type & busBarSections() { return *this; }

  busBarSection_const_iterator busBarSections_begin() const { return busBarSections().begin(); }
  busBarSection_const_iterator busBarSections_end() const { return busBarSections().end(); }

  busBarSection_iterator busBarSections_begin() { return busBarSections().begin(); }
  busBarSection_iterator busBarSections_end() {return busBarSections().end(); }

  BusBarSection const& get_busBarSection(id_type const& id) const { return busBarSections().get(id); }
  BusBarSection & get_busBarSection(id_type const& id) { return busBarSections().get(id); }

  busBarSection_const_iterator find_busBarSection(id_type const& id) const { return busBarSections().find(id); }
  busBarSection_iterator find_busBarSection(id_type const& id) { return busBarSections().find(id); }

//Switches
public:
  typedef Contains<Switch> switches_type;
  typedef switches_type::iterator switch_iterator;
  typedef switches_type::const_iterator switch_const_iterator;

  switches_type const& switches() const { return *this; }
  switches_type & switches() { return *this; }

  switch_const_iterator switches_begin() const { return switches().begin(); }
  switch_const_iterator switches_end() const { return switches().end(); }

  switch_iterator switches_begin() { return switches().begin(); }
  switch_iterator switches_end() { return switches().end(); }

  Switch const& get_switch(id_type const& id) const { return switches().get(id); }
  Switch & get_switch(id_type const& id) { return switches().get(id); }

  switch_const_iterator find_switch(id_type const& id) const { return switches().find(id); }
  switch_iterator find_switch(id_type const& id) { return switches().find(id); }

//Loads
public:
  typedef Contains<Load> loads_type;
  typedef loads_type::iterator load_iterator;
  typedef loads_type::const_iterator load_const_iterator;

  loads_type const& loads() const { return *this; }
  loads_type & loads() { return *this; }

  load_const_iterator loads_begin() const { return loads().begin(); }
  load_const_iterator loads_end() const { return loads().end(); }

  load_iterator loads_begin() { return loads().begin(); }
  load_iterator loads_end() { return loads().end(); }

  Load const& get_load(id_type const& id) const { return loads().get(id); }
  Load & get_load(id_type const& id) { return loads().get(id); }

  load_const_iterator find_load(id_type const& id) const { return loads().find(id); }
  load_iterator find_load(id_type const& id) { return loads().find(id); }

//Batteries
public:
  typedef Contains<Battery> batteries_type;
  typedef batteries_type::iterator battery_iterator;
  typedef batteries_type::const_iterator battery_const_iterator;

  batteries_type const& batteries() const { return *this; }
  batteries_type & batteries() { return *this; }

  battery_const_iterator batteries_begin() const { return batteries().begin(); }
  battery_const_iterator batteries_end() const { return batteries().end(); }

  battery_iterator batteries_begin() { return batteries().begin(); }
  battery_iterator batteries_end() { return batteries().end(); }

  Battery const& get_battery(id_type const& id) const { return batteries().get(id); }
  Battery & get_battery(id_type const& id) { return batteries().get(id); }

  battery_const_iterator find_battery(id_type const& id) const { return batteries().find(id); }
  battery_iterator find_battery(id_type const& id) { return batteries().find(id); }

//ShuntCompensators
public:
  typedef Contains<ShuntCompensator> shuntCompensators_type;
  typedef shuntCompensators_type::iterator shuntCompensator_iterator;
  typedef shuntCompensators_type::const_iterator shuntCompensator_const_iterator;

  shuntCompensators_type const& shuntCompensators() const { return *this; }
  shuntCompensators_type & shuntCompensators() { return *this; }

  shuntCompensator_const_iterator shuntCompensators_begin() const { return shuntCompensators().begin(); }
  shuntCompensator_const_iterator shuntCompensators_end() const { return shuntCompensators().end(); }

  shuntCompensator_iterator shuntCompensators_begin() { return shuntCompensators().begin(); }
  shuntCompensator_iterator shuntCompensators_end() { return shuntCompensators().end(); }

  ShuntCompensator const& get_shuntCompensator(id_type const& id) const { return shuntCompensators().get(id); }
  ShuntCompensator & get_shuntCompensator(id_type const& id) { return shuntCompensators().get(id); }

  shuntCompensator_const_iterator find_shuntCompensator(id_type const& id) const { return shuntCompensators().find(id); }
  shuntCompensator_iterator find_shuntCompensator(id_type const& id) { return shuntCompensators().find(id); }

//DanglingLines
public:
  typedef Contains<DanglingLine> danglingLines_type;
  typedef danglingLines_type::iterator danglingLine_iterator;
  typedef danglingLines_type::const_iterator danglingLine_const_iterator;

  danglingLines_type const& danglingLines() const { return *this; }
  danglingLines_type & danglingLines() { return *this; }

  danglingLine_const_iterator danglingLines_begin() const { return danglingLines().begin(); }
  danglingLine_const_iterator danglingLines_end() const { return danglingLines().end(); }

  danglingLine_iterator danglingLines_begin() { return danglingLines().begin(); }
  danglingLine_iterator danglingLines_end() { return danglingLines().end(); }

  DanglingLine const& get_danglingLine(id_type const& id) const { return danglingLines().get(id); }
  DanglingLine & get_danglingLine(id_type const& id) { return danglingLines().get(id); }

  danglingLine_const_iterator find_danglingLine(id_type const& id) const { return danglingLines().find(id); }
  danglingLine_iterator find_danglingLine(id_type const& id) { return danglingLines().find(id); }

//Generators
public:
  typedef Contains<Generator> generators_type;
  typedef generators_type::iterator generator_iterator;
  typedef generators_type::const_iterator generator_const_iterator;

  generators_type const& generators() const { return *this; }
  generators_type & generators() { return *this; }

  generator_const_iterator generators_begin() const { return generators().begin(); }
  generator_const_iterator generators_end() const { return generators().end(); }

  generator_iterator generators_begin() { return generators().begin(); }
  generator_iterator generators_end() { return generators().end(); }

  Generator const& get_generator(id_type const& id) const { return generators().get(id); }
  Generator & get_generator(id_type const& id) { return generators().get(id); }

  generator_const_iterator find_generator(id_type const& id) const { return generators().find(id); }
  generator_iterator find_generator(id_type const& id) { return generators().find(id); }

//StaticVarCompensators
public:
  typedef Contains<StaticVarCompensator> staticVarCompensators_type;
  typedef staticVarCompensators_type::iterator staticVarCompensator_iterator;
  typedef staticVarCompensators_type::const_iterator staticVarCompensator_const_iterator;

  staticVarCompensators_type const& staticVarCompensators() const { return *this; }
  staticVarCompensators_type & staticVarCompensators() { return *this; }

  staticVarCompensator_const_iterator staticVarCompensators_begin() const { return staticVarCompensators().begin(); }
  staticVarCompensator_const_iterator staticVarCompensators_end() const { return staticVarCompensators().end(); }

  staticVarCompensator_iterator staticVarCompensators_begin() { return staticVarCompensators().begin(); }
  staticVarCompensator_iterator staticVarCompensators_end() { return staticVarCompensators().end(); }

  StaticVarCompensator const& get_staticVarCompensator(id_type const& id) const { return staticVarCompensators().get(id); }
  StaticVarCompensator & get_staticVarCompensator(id_type const& id) { return staticVarCompensators().get(id); }

  staticVarCompensator_const_iterator find_staticVarCompensator(id_type const& id) const { return staticVarCompensators().find(id); }
  staticVarCompensator_iterator find_staticVarCompensator(id_type const& id) { return staticVarCompensators().find(id); }

//VscConverterStations
public:
  typedef Contains<VscConverterStation> vscConverterStations_type;
  typedef vscConverterStations_type::iterator vscConverterStation_iterator;
  typedef vscConverterStations_type::const_iterator vscConverterStation_const_iterator;

  vscConverterStations_type const& vscConverterStations() const { return *this; }
  vscConverterStations_type & vscConverterStations() { return *this; }

  vscConverterStation_const_iterator vscConverterStations_begin() const { return vscConverterStations().begin(); }
  vscConverterStation_const_iterator vscConverterStations_end() const { return vscConverterStations().end(); }

  vscConverterStation_iterator vscConverterStations_begin() { return vscConverterStations().begin(); }
  vscConverterStation_iterator vscConverterStations_end() { return vscConverterStations().end(); }

  VscConverterStation const& get_vscConverterStation(id_type const& id) const { return vscConverterStations().get(id); }
  VscConverterStation & get_vscConverterStation(id_type const& id) { return vscConverterStations().get(id); }

  vscConverterStation_const_iterator find_vscConverterStation(id_type const& id) const { return vscConverterStations().find(id); }
  vscConverterStation_iterator find_vscConverterStation(id_type const& id) { return vscConverterStations().find(id); }

//LccConverterStation
public:
  typedef Contains<LccConverterStation> lccConverterStations_type;
  typedef lccConverterStations_type::iterator lccConverterStation_iterator;
  typedef lccConverterStations_type::const_iterator lccConverterStation_const_iterator;

  lccConverterStations_type const& lccConverterStations() const { return *this; }
  lccConverterStations_type & lccConverterStations() { return *this; }

  lccConverterStation_const_iterator lccConverterStations_begin() const { return lccConverterStations().begin(); }
  lccConverterStation_const_iterator lccConverterStations_end() const { return lccConverterStations().end(); }

  lccConverterStation_iterator lccConverterStations_begin() { return lccConverterStations().begin(); }
  lccConverterStation_iterator lccConverterStations_end() { return lccConverterStations().end(); }

  LccConverterStation const& get_lccConverterStation(id_type const& id) const { return lccConverterStations().get(id); }
  LccConverterStation & get_lccConverterStation(id_type const& id) { return lccConverterStations().get(id); }

  lccConverterStation_const_iterator find_lccConverterStation(id_type const& id) const { return lccConverterStations().find(id); }
  lccConverterStation_iterator find_lccConverterStation(id_type const& id) { return lccConverterStations().find(id); }

public:
  VoltageLevel& add(Bus const&);
  VoltageLevel& add(BusBarSection const&);

public:
  VoltageLevel& add(Switch const&, node_type node1, node_type node2);
  VoltageLevel& add(Switch const&, id_type const& bus1, id_type const& bus2);

  //note: compile time check makes add(switch, "", "") ambiguous without that third overload
  VoltageLevel& add(Switch const& s, const char* bus1, const char* bus2) {
    return add(s, id_type(bus1), id_type(bus2));
  }

private:
  VoltageLevel& add(Switch const&, Port const& port1, Port const& port2);

public:
  VoltageLevel& add(Battery const&, boost::optional<Connection> const& = boost::none);
  VoltageLevel& add(Load const&, boost::optional<Connection> const& = boost::none);
  VoltageLevel& add(ShuntCompensator const&, boost::optional<Connection> const& = boost::none);
  VoltageLevel& add(DanglingLine const&, boost::optional<Connection> const& = boost::none);
  VoltageLevel& add(Generator const&, boost::optional<Connection> const& = boost::none);
  VoltageLevel& add(StaticVarCompensator const&, boost::optional<Connection> const& = boost::none);
  VoltageLevel& add(VscConverterStation const&, boost::optional<Connection> const& = boost::none);
  VoltageLevel& add(LccConverterStation const&, boost::optional<Connection> const& = boost::none);

private:
  //utilities for add(...)

  //throws if a connection is not valid or does not match the given side count
  void check(boost::optional<Connection> const& connection, side_id max_sides) const {
    if (connection) check(*connection, max_sides);
  }

  //used to share some code in the add(...) functions related to Injections.
  template <typename T>
  #ifndef DOXYGEN_RUNNING
    typename IIDM_ENABLE_IF< IIDM::tt::is_convertible< T&, Connectable<T, side_1>& >::value, VoltageLevel& >::type
  #else
    VoltageLevel&
  #endif
  connect(T const& , boost::optional<Connection> const&);


private:
  //builder requirements
  VoltageLevel(Identifier const&, properties_type const&);
  friend class IIDM::builders::VoltageLevelBuilder;
};

std::ostream& operator<< (std::ostream&, VoltageLevel::e_mode);

} // end of namespace IIDM::

#endif
