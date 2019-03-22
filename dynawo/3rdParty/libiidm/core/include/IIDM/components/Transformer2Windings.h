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
 * @file components/Transformer2Windings.h
 * @brief Transformer2Windings interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_TRANSFORMER2_H
#define LIBIIDM_COMPONENTS_GUARD_TRANSFORMER2_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Connectable.h>
#include <IIDM/components/ContainedIn.h>

#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/TapChanger.h>

namespace IIDM {

class Substation;
class VoltageLevel;

namespace builders {
class Transformer2WindingsBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief 2 windings transformer in the network
 */
class IIDM_EXPORT Transformer2Windings: public Identifiable, public Connectable<Transformer2Windings, side_2>, public ContainedIn<Substation> {
public:
  //aliases of parent()
  ///tells if a parent substation is specified
  bool has_substation() const { return has_parent(); }

  ///gets a constant reference to the parent substation
  Substation const& substation() const { return parent(); }
  ///gets a reference to the parent substation
  Substation      & substation()       { return parent(); }

  id_type const& voltageLevelId1() const;

  id_type const& voltageLevelId2() const;

  VoltageLevel const& voltageLevel1() const;

  VoltageLevel const& voltageLevel2() const;

public:
  double r() const { return m_r; }
  double x() const { return m_x; }
  double g() const { return m_g; }
  double b() const { return m_b; }

  double ratedU1() const { return m_ratedU1; }
  double ratedU2() const { return m_ratedU2; }

  /** tells if the active power at side 1 is set */
  bool has_p1() const { return static_cast<bool>(m_p1); }
  /** gets the active power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double p1() const { return m_p1.value(); }
  /** gets the optional active power at side 1 */
  boost::optional<double> const& optional_p1() const { return m_p1; }
  /** sets the active power at side 1 */
  Transformer2Windings& p1(double p1) { m_p1 = p1; return *this; }
  /** sets the active power at side 1 (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& p1(boost::optional<double> const& p1) { m_p1 = p1; return *this; }


  /** tells if the reactive power at side 1 is set */
  bool has_q1() const { return static_cast<bool>(m_q1); }
  /** gets the reactive power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double q1() const { return m_q1.value(); }
  /** gets the optional reactive power at side 1 */
  boost::optional<double> const& optional_q1() const { return m_q1; }
  /** sets the reactive power at side 1 */
  Transformer2Windings& q1(double q1) { m_q1 = q1; return *this; }
  /** sets the reactive power at side 1 (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& q1(boost::optional<double> const& q1) { m_q1 = q1; return *this; }


  /** tells if the active power at side 2 is set */
  bool has_p2() const { return static_cast<bool>(m_p2); }
  /** gets the active power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double p2() const { return m_p2.value(); }
  /** gets the optional active power at side 2 */
  boost::optional<double> const& optional_p2() const { return m_p2; }
  /** sets the active power at side 2 */
  Transformer2Windings& p2(double p2) { m_p2 = p2; return *this; }
  /** sets the active power at side 2 (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& p2(boost::optional<double> const& p2) { m_p2 = p2; return *this; }


  /** tells if the reactive power at side 2 is set */
  bool has_q2() const { return static_cast<bool>(m_q2); }
  /** gets the reactive power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double q2() const { return m_q2.value(); }
  /** gets the optional reactive power at side 2 */
  boost::optional<double> const& optional_q2() const { return m_q2; }
  /** sets the reactive power at side 2 */
  Transformer2Windings& q2(double q2) { m_q2 = q2; return *this; }
  /** sets the reactive power at side 2 (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& q2(boost::optional<double> const& q2) { m_q2 = q2; return *this; }



  /** tells if  is set */
  bool has_ratioTapChanger() const { return static_cast<bool>(m_ratioTapChanger); }
  /** gets
   * @throws boost::bad_optional_access if not set
   */
  RatioTapChanger const& ratioTapChanger() const { return m_ratioTapChanger.value(); }

  RatioTapChanger & ratioTapChanger() { return m_ratioTapChanger.value(); }

  /** gets the optional  */
  boost::optional<RatioTapChanger> const& optional_ratioTapChanger() const { return m_ratioTapChanger; }
  /** sets  */
  Transformer2Windings& ratioTapChanger(RatioTapChanger const& rtc) { m_ratioTapChanger = rtc; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& ratioTapChanger(boost::optional<RatioTapChanger> const& rtc) { m_ratioTapChanger = rtc; return *this; }


  /** tells if the phase tap changer is set */
  bool has_phaseTapChanger() const { return static_cast<bool>(m_phaseTapChanger); }
  /** gets the phase tap changer
   * @throws boost::bad_optional_access if not set
   */
  PhaseTapChanger const& phaseTapChanger() const { return m_phaseTapChanger.value(); }

  PhaseTapChanger & phaseTapChanger() { return m_phaseTapChanger.value(); }

  /** gets the optional  */
  boost::optional<PhaseTapChanger> const& optional_phaseTapChanger() const { return m_phaseTapChanger; }
  /** sets the phase tap changer */
  Transformer2Windings& phaseTapChanger(PhaseTapChanger const& ptc) { m_phaseTapChanger = ptc; return *this; }
  /** sets the phase tap changer (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& phaseTapChanger(boost::optional<PhaseTapChanger> const& ptc) { m_phaseTapChanger = ptc; return *this; }


  /** tells if  at side 1 is set */
  bool has_currentLimits1() const { return static_cast<bool>(m_currentLimits1); }
  /** gets  at side 1
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits1() const { return m_currentLimits1.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits1() const { return m_currentLimits1; }
  /** sets  */
  Transformer2Windings& currentLimits1(CurrentLimits const& l) { m_currentLimits1 = l; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& currentLimits1(boost::optional<CurrentLimits> const& l) { m_currentLimits1 = l; return *this; }


  /** tells if  at side 2 is set */
  bool has_currentLimits2() const { return static_cast<bool>(m_currentLimits2); }
  /** gets  at side 2
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits2() const { return m_currentLimits2.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits2() const { return m_currentLimits2; }
  /** sets  */
  Transformer2Windings& currentLimits2(CurrentLimits const& l) { m_currentLimits2 = l; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer2Windings& currentLimits2(boost::optional<CurrentLimits> const& l) { m_currentLimits2 = l; return *this; }

private:
  double m_r;
  double m_x;
  double m_g;
  double m_b;

  double m_ratedU1;
  double m_ratedU2;

  boost::optional<double> m_p1;
  boost::optional<double> m_q1;
  boost::optional<double> m_p2;
  boost::optional<double> m_q2;

  boost::optional<RatioTapChanger> m_ratioTapChanger;
  boost::optional<PhaseTapChanger> m_phaseTapChanger;
  boost::optional<CurrentLimits> m_currentLimits1;
  boost::optional<CurrentLimits> m_currentLimits2;

private:
  Transformer2Windings(Identifier const&, properties_type const&);
  friend class IIDM::builders::Transformer2WindingsBuilder;

};

} // end of namespace IIDM::

#endif
