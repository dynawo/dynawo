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
 * @file components/StaticVarCompensator.h
 * @brief StaticVarCompensator interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_STATICVARCOMPENSATOR_H
#define LIBIIDM_COMPONENTS_GUARD_STATICVARCOMPENSATOR_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Injection.h>

#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class StaticVarCompensatorBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief StaticVarCompensator in the network
 */
class IIDM_EXPORT StaticVarCompensator: public Identifiable, public Injection<StaticVarCompensator>, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }
  ///gets a reference to the parent VoltageLevel
  VoltageLevel      & voltageLevel()       { return parent(); }

public:
  enum e_regulation_mode {regulation_voltage, regulation_reactive_power, regulation_off};
public:
  /** gets the regulation mode of the static var compensator */
  e_regulation_mode regulationMode() const { return m_regulationMode; }

  /** sets the regulation mode of the static var compensator */
  StaticVarCompensator& regulationMode(e_regulation_mode mode) { m_regulationMode = mode; return *this; }

  double bmin() const { return m_bmin; }

  double bmax() const { return m_bmax; }

  /** tells if the voltage set point is set */
  bool has_voltageSetPoint() const { return static_cast<bool>(m_voltageSetPoint); }
  /** gets the voltage set point
   * @throws boost::bad_optional_access if not set
   */
  double voltageSetPoint() const { return m_voltageSetPoint.value(); }
  /** gets the optional voltage set point */
  boost::optional<double> const& optional_voltageSetPoint() const { return m_voltageSetPoint; }
  /** sets the voltage set point */
  StaticVarCompensator& voltageSetPoint(double p) { m_voltageSetPoint = p; return *this; }
  /** sets the voltage set point (or unsets if used with boost::none or an empty optional) */
  StaticVarCompensator& voltageSetPoint(boost::optional<double> const& p) { m_voltageSetPoint = p; return *this; }



  /** tells if the reactive power set point is set */
  bool has_reactivePowerSetPoint() const { return static_cast<bool>(m_reactivePowerSetPoint); }
  /** gets the reactive power set point
   * @throws boost::bad_optional_access if not set
   */
  double reactivePowerSetPoint() const { return m_reactivePowerSetPoint.value(); }
  /** gets the optional reactive power set point */
  boost::optional<double> const& optional_reactivePowerSetPoint() const { return m_reactivePowerSetPoint; }
  /** sets the reactive power set point */
  StaticVarCompensator& reactivePowerSetPoint(double p) { m_reactivePowerSetPoint = p; return *this; }
  /** sets the reactive power set point (or unsets if used with boost::none or an empty optional) */
  StaticVarCompensator& reactivePowerSetPoint(boost::optional<double> const& p) { m_reactivePowerSetPoint = p; return *this; }

private:
  e_regulation_mode m_regulationMode;
  double m_bmin;
  double m_bmax;
  boost::optional<double> m_voltageSetPoint;
  boost::optional<double> m_reactivePowerSetPoint;

private:
  StaticVarCompensator(Identifier const&, properties_type const&);
  friend class IIDM::builders::StaticVarCompensatorBuilder;
};

} // end of namespace IIDM::

#endif
