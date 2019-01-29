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
 * @file components/Generator.h
 * @brief Generator interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_GENERATOR_H
#define LIBIIDM_COMPONENTS_GUARD_GENERATOR_H

#include <vector>

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Injection.h>
#include <IIDM/components/ContainedIn.h>

#include <IIDM/components/ReactiveInformations.h>
#include <IIDM/components/TerminalReference.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class GeneratorBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief Generator in the network
 */
class IIDM_EXPORT Generator: public Identifiable, public Injection<Generator>, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }
  ///gets a reference to the parent VoltageLevel
  VoltageLevel      & voltageLevel()       { return parent(); }

public:
  enum energy_source_enum {source_hydro, source_nuclear, source_wind, source_thermal, source_solar, source_other};

public:
  energy_source_enum energySource() const { return m_energySource; }

  /** get active power min value */
  double pmin() const { return m_pmin; }

  /** get active power max value */
  double pmax() const { return m_pmax; }

  bool voltageRegulatorOn() const { return m_regulating; }

  /** get target active power */
  double targetP() const { return m_targetP; }



  /** tells if the reactive capability curve is set */
  bool has_reactiveCapabilityCurve() const { return static_cast<bool>(m_reactiveCapabilityCurve); }
  /** gets the reactive capability curve
   * @throws boost::bad_optional_access if not set
   */
  ReactiveCapabilityCurve reactiveCapabilityCurve() const { return m_reactiveCapabilityCurve.value(); }
  /** gets the optional reactive capability curve */
  boost::optional<ReactiveCapabilityCurve> const& optional_reactiveCapabilityCurve() const { return m_reactiveCapabilityCurve; }
  /** sets the reactive capability curve */
  Generator& reactiveCapabilityCurve(ReactiveCapabilityCurve const& curve) { m_reactiveCapabilityCurve = curve; return *this; }
  /** sets the reactive capability curve (or unsets if used with boost::none or an empty optional) */
  Generator& reactiveCapabilityCurve(boost::optional<ReactiveCapabilityCurve> const& curve) { m_reactiveCapabilityCurve = curve; return *this; }



  /** tells if the reactive limits is set */
  bool has_minMaxReactiveLimits() const { return static_cast<bool>(m_minMaxReactiveLimits); }
  /** gets the reactive limits
   * @throws boost::bad_optional_access if not set
   */
  MinMaxReactiveLimits minMaxReactiveLimits() const { return m_minMaxReactiveLimits.value(); }
  /** gets the optional reactive limits */
  boost::optional<MinMaxReactiveLimits> const& optional_minMaxReactiveLimits() const { return m_minMaxReactiveLimits; }
  /** sets the reactive limits */
  Generator& minMaxReactiveLimits(MinMaxReactiveLimits const& limits) { m_minMaxReactiveLimits = limits; return *this; }
  /** sets the reactive limits (or unsets if used with boost::none or an empty optional) */
  Generator& minMaxReactiveLimits(boost::optional<MinMaxReactiveLimits> const& limits) { m_minMaxReactiveLimits = limits; return *this; }



  /** tells if the regulating terminal is set */
  bool has_regulatingTerminal() const { return static_cast<bool>(m_regulatingTerminal); }
  /** gets the regulating terminal
   * @throws boost::bad_optional_access if not set
   */
  TerminalReference regulatingTerminal() const { return m_regulatingTerminal.value(); }
  /** gets the optional regulating terminal */
  boost::optional<TerminalReference> const& optional_regulatingTerminal() const { return m_regulatingTerminal; }
  /** sets the regulating terminal */
  Generator& regulatingTerminal(TerminalReference const& terminal) { m_regulatingTerminal = terminal; return *this; }
  /** sets the regulating terminal (or unsets if used with boost::none or an empty optional) */
  Generator& regulatingTerminal(boost::optional<TerminalReference> const& terminal) { m_regulatingTerminal = terminal; return *this; }


  /** tells if the target reactive power is set */
  bool has_targetQ() const { return static_cast<bool>(m_targetQ); }
  /** gets the target reactive power
   * @throws boost::bad_optional_access if not set
   */
  double targetQ() const { return m_targetQ.value(); }
  /** gets the optional target reactive power */
  boost::optional<double> const& optional_targetQ() const { return m_targetQ; }
  /** sets the target reactive power */
  Generator& targetQ(double targetQ) { m_targetQ = targetQ; return *this; }
  /** sets the target reactive power (or unsets if used with boost::none or an empty optional) */
  Generator& targetQ(boost::optional<double> const& targetQ) { m_targetQ = targetQ; return *this; }


  /** tells if the target tension is set */
  bool has_targetV() const { return static_cast<bool>(m_targetV); }
  /** gets the target tension
   * @throws boost::bad_optional_access if not set
   */
  double targetV() const { return m_targetV.value(); }
  /** gets the optional target tension */
  boost::optional<double> const& optional_targetV() const { return m_targetV; }
  /** sets the target tension */
  Generator& targetV(double targetV) { m_targetV = targetV; return *this; }
  /** sets the target tension (or unsets if used with boost::none or an empty optional) */
  Generator& targetV(boost::optional<double> const& targetV) { m_targetV = targetV; return *this; }


  /** tells if ratedS is set */
  bool has_ratedS() const { return static_cast<bool>(m_ratedS); }
  /** gets ratedS
   * @throws boost::bad_optional_access if not set
   */
  double ratedS() const { return m_ratedS.value(); }
  /** gets the optional ratedS */
  boost::optional<double> const& optional_ratedS() const { return m_ratedS; }
  /** sets ratedS */
  Generator& ratedS(double ratedS) { m_ratedS = ratedS; return *this; }
  /** sets ratedS (or unsets if used with boost::none or an empty optional) */
  Generator& ratedS(boost::optional<double> const& ratedS) { m_ratedS = ratedS; return *this; }

private:
  energy_source_enum m_energySource;

  bool m_regulating;
  double m_pmin;
  double m_pmax;
  double m_targetP;

  boost::optional<double> m_targetQ;
  boost::optional<double> m_targetV;
  boost::optional<double> m_ratedS;

  boost::optional<MinMaxReactiveLimits> m_minMaxReactiveLimits;
  boost::optional<ReactiveCapabilityCurve> m_reactiveCapabilityCurve;
  boost::optional<TerminalReference> m_regulatingTerminal;

private:
  Generator(Identifier const&, properties_type const&);
  friend class IIDM::builders::GeneratorBuilder;

};

} // end of namespace IIDM::

#endif
