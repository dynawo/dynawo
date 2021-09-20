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
 * @file components/Battery.h
 * @brief Load interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_BATTERY_H
#define LIBIIDM_COMPONENTS_GUARD_BATTERY_H

#include <boost/optional.hpp>

#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Injection.h>
#include <IIDM/components/ContainedIn.h>

#include <IIDM/components/ReactiveInformations.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class BatteryBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief Load in the network
 */
class Battery: public Identifiable, public Injection<Battery>, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }

  ///gets a reference to the parent VoltageLevel
  VoltageLevel & voltageLevel() { return parent(); }

public:
    /** get active power min value */
  double pmin() const { return m_pmin; }

  /** get active power max value */
  double pmax() const { return m_pmax; }

  /** get the constant active power */
  double p0() const { return m_p0; }

  /** get the constant reactive power */
  double q0() const { return m_q0; }

  /** tells if the reactive capability curve is set */
  bool has_reactiveCapabilityCurve() const { return static_cast<bool>(m_reactiveCapabilityCurve); }
  /** gets the reactive capability curve
   * @throws boost::bad_optional_access if not set
   */
  const ReactiveCapabilityCurve & reactiveCapabilityCurve() const { return m_reactiveCapabilityCurve.value(); }
  /** gets the optional reactive capability curve */
  boost::optional<ReactiveCapabilityCurve> const& optional_reactiveCapabilityCurve() const { return m_reactiveCapabilityCurve; }
  /** sets the reactive capability curve */
  Battery & reactiveCapabilityCurve(ReactiveCapabilityCurve const& curve) { m_reactiveCapabilityCurve = curve; return *this; }
  /** sets the reactive capability curve (or unsets if used with boost::none or an empty optional) */
  Battery & reactiveCapabilityCurve(boost::optional<ReactiveCapabilityCurve> const& curve) { m_reactiveCapabilityCurve = curve; return *this; }


  /** tells if the reactive limits is set */
  bool has_minMaxReactiveLimits() const { return static_cast<bool>(m_minMaxReactiveLimits); }
  /** gets the reactive limits
   * @throws boost::bad_optional_access if not set
   */
  const MinMaxReactiveLimits & minMaxReactiveLimits() const { return m_minMaxReactiveLimits.value(); }
  /** gets the optional reactive limits */
  boost::optional<MinMaxReactiveLimits> const& optional_minMaxReactiveLimits() const { return m_minMaxReactiveLimits; }
  /** sets the reactive limits */
  Battery & minMaxReactiveLimits(MinMaxReactiveLimits const& limits) { m_minMaxReactiveLimits = limits; return *this; }
  /** sets the reactive limits (or unsets if used with boost::none or an empty optional) */
  Battery & minMaxReactiveLimits(boost::optional<MinMaxReactiveLimits> const& limits) { m_minMaxReactiveLimits = limits; return *this; }

private:
  double m_p0;
  double m_q0;
  double m_pmin;
  double m_pmax;

  boost::optional<MinMaxReactiveLimits> m_minMaxReactiveLimits;
  boost::optional<ReactiveCapabilityCurve> m_reactiveCapabilityCurve;

private:
  Battery(Identifier const&, properties_type const&);
  friend class IIDM::builders::BatteryBuilder;
};

} // end of namespace IIDM::

#endif
