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
 * @file components/VscConverterStation.h
 * @brief VscConverterStation interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_VSCCONVERTERSTATION_H
#define LIBIIDM_COMPONENTS_GUARD_VSCCONVERTERSTATION_H

#include <vector>

#include <boost/optional.hpp>


#include <IIDM/cpp11.h>

#include <IIDM/components/HvdcConverterStation.h>

#include <IIDM/components/ReactiveInformations.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class VscConverterStationBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief VscConverterStation in the network
 */
class VscConverterStation: public HvdcConverterStation<VscConverterStation> {
public:
  bool voltageRegulatorOn() const { return m_regulating; }



  /** @brief tells if voltageSetpoint is set */
  bool has_voltageSetpoint() const { return static_cast<bool>(m_voltageSetpoint); }

  /**
   * @brief gets voltageSetpoint
   * @throws boost::bad_optional_access if not set
   */
  double voltageSetpoint() const { return m_voltageSetpoint.value(); }

  /** gets the optional ratedS */
  boost::optional<double> const& optional_voltageSetpoint() const { return m_voltageSetpoint; }

  /** sets voltageSetpoint */
  VscConverterStation& voltageSetpoint(double voltageSetpoint) { m_voltageSetpoint = voltageSetpoint; return *this; }

  /** sets voltageSetpoint (or unsets if used with boost::none or an empty optional) */
  VscConverterStation& voltageSetpoint(boost::optional<double> const& value) { m_voltageSetpoint = value; return *this; }



  /** @brief tells if reactivePowerSetpoint is set */
  bool has_reactivePowerSetpoint() const { return static_cast<bool>(m_reactivePowerSetpoint); }

  /**
   * @brief gets reactivePowerSetpoint
   * @throws boost::bad_optional_access if not set
   */
  double reactivePowerSetpoint() const { return m_reactivePowerSetpoint.value(); }

  /** @brief gets the optional ratedS */
  boost::optional<double> const& optional_reactivePowerSetpoint() const { return m_reactivePowerSetpoint; }

  /** @brief sets reactivePowerSetpoint */
  VscConverterStation& reactivePowerSetpoint(double reactivePowerSetpoint) { m_reactivePowerSetpoint = reactivePowerSetpoint; return *this; }

  /** @brief sets reactivePowerSetpoint (or unsets if used with boost::none or an empty optional) */
  VscConverterStation& reactivePowerSetpoint(boost::optional<double> const& value) { m_reactivePowerSetpoint = value; return *this; }



  /** @brief tells if the reactive capability curve is set */
  bool has_reactiveCapabilityCurve() const { return static_cast<bool>(m_reactiveCapabilityCurve); }

  /**
   * @brief gets the reactive capability curve
   * @throws boost::bad_optional_access if not set
   */
  ReactiveCapabilityCurve reactiveCapabilityCurve() const { return m_reactiveCapabilityCurve.value(); }

  /** @brief gets the optional reactive capability curve */
  boost::optional<ReactiveCapabilityCurve> const& optional_reactiveCapabilityCurve() const { return m_reactiveCapabilityCurve; }

  /** @brief sets the reactive capability curve */
  VscConverterStation& reactiveCapabilityCurve(ReactiveCapabilityCurve const& curve) { m_reactiveCapabilityCurve = curve; return *this; }

  /** @brief sets the reactive capability curve (or unsets if used with boost::none or an empty optional) */
  VscConverterStation& reactiveCapabilityCurve(boost::optional<ReactiveCapabilityCurve> const& curve) { m_reactiveCapabilityCurve = curve; return *this; }



  /** @brief tells if the reactive limits is set */
  bool has_minMaxReactiveLimits() const { return static_cast<bool>(m_minMaxReactiveLimits); }

  /**
   * @brief gets the reactive limits
   * @throws boost::bad_optional_access if not set
   */
  MinMaxReactiveLimits minMaxReactiveLimits() const { return m_minMaxReactiveLimits.value(); }

  /** @brief gets the optional reactive limits */
  boost::optional<MinMaxReactiveLimits> const& optional_minMaxReactiveLimits() const { return m_minMaxReactiveLimits; }

  /** @brief sets the reactive limits */
  VscConverterStation& minMaxReactiveLimits(MinMaxReactiveLimits const& limits) { m_minMaxReactiveLimits = limits; return *this; }

  /** @brief sets the reactive limits (or unsets if used with boost::none or an empty optional) */
  VscConverterStation& minMaxReactiveLimits(boost::optional<MinMaxReactiveLimits> const& limits) { m_minMaxReactiveLimits = limits; return *this; }


private:
  bool m_regulating;

  boost::optional<double> m_voltageSetpoint;
  boost::optional<double> m_reactivePowerSetpoint;


  boost::optional<MinMaxReactiveLimits> m_minMaxReactiveLimits;
  boost::optional<ReactiveCapabilityCurve> m_reactiveCapabilityCurve;

private:
  VscConverterStation(Identifier const&, properties_type const&);
  friend class IIDM::builders::VscConverterStationBuilder;

};

} // end of namespace IIDM::

#endif
