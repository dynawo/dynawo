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
 * @file components/Substation.h
 * @brief Substation
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_SUBSTATION_H
#define LIBIIDM_COMPONENTS_GUARD_SUBSTATION_H

#include <string>

#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/ContainedIn.h>
#include <IIDM/components/Container.h>

#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/Transformer2Windings.h>
#include <IIDM/components/Transformer3Windings.h>

namespace IIDM {

class Network;

namespace builders {
class SubstationBuilder;
} // end of namespace IIDM::builders::


//note: Contains<*> are inherited privately to hide non controlling add overloads.
class IIDM_EXPORT Substation:
  public Identifiable,
  public ContainedIn<Network>,
  public Contains<VoltageLevel>,
  public Contains<Transformer2Windings>,
  public Contains<Transformer3Windings>
{
  /* ********* data interface ********* */
public:
  //aliases of parent()
  ///tells if a parent network is specified
  bool has_network() const { return has_parent(); }

  ///gets a constant reference to the parent network
  Network const& network() const { return parent(); }
  ///gets a reference to the parent network
  Network      & network()       { return parent(); }

public:
  /** gets the country */
  std::string const& country() const { return m_country; }
  /** sets the country */
  Substation& country(std::string value) { m_country=value; return *this; }


  /** tells if the TSO is set */
  bool has_tso() const { return static_cast<bool>(m_tso); }
  /** gets the TSO
   * @throws boost::bad_optional_access if not set
   */
  std::string const& tso() const { return m_tso.value(); }
  /** gets the optional TSO */
  boost::optional<std::string> const& optional_tso() const { return m_tso; }
  /** sets the TSO */
  Substation& tso(std::string const& tso) { m_tso = tso; return *this; }
  /** sets the TSO (or unsets if used with boost::none or an empty optional) */
  Substation& tso(boost::optional<std::string> const& tso) { m_tso = tso; return *this; }


  /** tells if the geographical tags are set */
  bool has_geographicalTags() const { return static_cast<bool>(m_geographicalTags); }
  /** gets the geographical tags
   * @throws boost::bad_optional_access if not set
   */
  std::string const& geographicalTags() const { return m_geographicalTags.value(); }
  /** gets the optional  */
  boost::optional<std::string> const& optional_geographicalTags() const { return m_geographicalTags; }
  /** sets the geographical tags */
  Substation& geographicalTags(std::string const& tags) { m_geographicalTags = tags; return *this; }
  /** sets the geographical tags (or unsets if used with boost::none or an empty optional) */
  Substation& geographicalTags(boost::optional<std::string> const& tags) { m_geographicalTags = tags; return *this; }

private:
  std::string m_country;
  boost::optional<std::string> m_tso;
  boost::optional<std::string> m_geographicalTags;

/* ****** connection interface ****** */
public:
  bool has(ConnectionPoint const&) const;
  boost::optional<ActualConnectionPoint> validate(ConnectionPoint const&) const;

  void register_into(Network &);

//VoltageLevel
public:
  typedef Contains<VoltageLevel> voltageLevels_type;
  typedef voltageLevels_type::iterator voltageLevel_iterator;
  typedef voltageLevels_type::const_iterator voltageLevel_const_iterator;

  voltageLevels_type const& voltageLevels() const { return *this; }
  voltageLevels_type & voltageLevels() { return *this; }

  voltageLevel_const_iterator voltageLevels_begin() const { return voltageLevels().begin(); }
  voltageLevel_const_iterator voltageLevels_end() const { return voltageLevels().end(); }

  voltageLevel_iterator voltageLevels_begin() { return voltageLevels().begin(); }
  voltageLevel_iterator voltageLevels_end() { return voltageLevels().end(); }

  VoltageLevel const& get_voltageLevel(id_type const& id) const { return voltageLevels().get(id); }
  VoltageLevel & get_voltageLevel(id_type const& id) { return voltageLevels().get(id); }

  voltageLevel_const_iterator find_voltageLevel(id_type const& id) const { return voltageLevels().find(id); }
  voltageLevel_iterator find_voltageLevel(id_type const& id) { return voltageLevels().find(id); }

//Transformer2Windings
public:
  typedef Contains<Transformer2Windings> twoWindingsTransformers_type;
  typedef twoWindingsTransformers_type::iterator twoWindingsTransformer_iterator;
  typedef twoWindingsTransformers_type::const_iterator twoWindingsTransformer_const_iterator;

  twoWindingsTransformers_type const& twoWindingsTransformers() const { return *this; }
  twoWindingsTransformers_type & twoWindingsTransformers() { return *this; }

  twoWindingsTransformer_const_iterator twoWindingsTransformers_begin() const { return twoWindingsTransformers().begin(); }
  twoWindingsTransformer_const_iterator twoWindingsTransformers_end() const { return twoWindingsTransformers().end(); }

  twoWindingsTransformer_iterator twoWindingsTransformers_begin() { return twoWindingsTransformers().begin(); }
  twoWindingsTransformer_iterator twoWindingsTransformers_end() { return twoWindingsTransformers().end(); }

  Transformer2Windings const& get_twoWindingsTransformer(id_type const& id) const { return twoWindingsTransformers().get(id); }
  Transformer2Windings & get_twoWindingsTransformer(id_type const& id) { return twoWindingsTransformers().get(id); }

  twoWindingsTransformer_const_iterator find_twoWindingsTransformer(id_type const& id) const { return twoWindingsTransformers().find(id); }
  twoWindingsTransformer_iterator find_twoWindingsTransformer(id_type const& id) { return twoWindingsTransformers().find(id); }

//Transformer3Windings
public:
  typedef Contains<Transformer3Windings> threeWindingsTransformers_type;
  typedef threeWindingsTransformers_type::iterator threeWindingsTransformer_iterator;
  typedef threeWindingsTransformers_type::const_iterator threeWindingsTransformer_const_iterator;

  threeWindingsTransformers_type const& threeWindingsTransformers() const { return *this; }
  threeWindingsTransformers_type & threeWindingsTransformers() { return *this; }

  threeWindingsTransformer_const_iterator threeWindingsTransformers_begin() const { return threeWindingsTransformers().begin(); }
  threeWindingsTransformer_const_iterator threeWindingsTransformers_end() const { return threeWindingsTransformers().end(); }

  threeWindingsTransformer_iterator threeWindingsTransformers_begin() { return threeWindingsTransformers().begin(); }
  threeWindingsTransformer_iterator threeWindingsTransformers_end() { return threeWindingsTransformers().end(); }

  Transformer3Windings const& get_threeWindingsTransformer(id_type const& id) const { return threeWindingsTransformers().get(id); }
  Transformer3Windings & get_threeWindingsTransformer(id_type const& id) { return threeWindingsTransformers().get(id); }

  threeWindingsTransformer_const_iterator find_threeWindingsTransformer(id_type const& id) const { return threeWindingsTransformers().find(id); }
  threeWindingsTransformer_iterator find_threeWindingsTransformer(id_type const& id) { return threeWindingsTransformers().find(id); }

public:
  VoltageLevel& add(VoltageLevel const& voltageLevel);

  Substation& add(
    Transformer2Windings const& transformer,
    boost::optional<Connection> const& connection1,
    boost::optional<Connection> const& connection2
  );

  Substation& add(
    Transformer3Windings const& transformer,
    boost::optional<Connection> const& connection1,
    boost::optional<Connection> const& connection2,
    boost::optional<Connection> const& connection3
  );

private:
  //utilities for add(...)

  //throws if a connection is not valid or does not match the given side count
  void check(boost::optional<Connection> const& connection, side_id max_sides) const;

private:
  //builder requirements
  Substation(Identifier const&, properties_type const&);
  friend class IIDM::builders::SubstationBuilder;
};

} // end of namespace IIDM::

#endif
