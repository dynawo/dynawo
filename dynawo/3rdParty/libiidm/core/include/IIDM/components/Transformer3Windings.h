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
 * @file components/Transformer3Windings.h
 * @brief Transformer3Windings interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_TRANSFORMER3_H
#define LIBIIDM_COMPONENTS_GUARD_TRANSFORMER3_H

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
class Transformer3WindingsBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief 3 windings transformer in the network
 */
class IIDM_EXPORT Transformer3Windings: public Identifiable, public Connectable<Transformer3Windings, side_3>, public ContainedIn<Substation> {
public:
  //aliases of parent()
  ///tells if a parent substation is specified
  bool has_substation() const { return has_parent(); }

  ///gets a constant reference to the parent substation
  Substation const& substation() const { return parent(); }
  ///gets a reference to the parent substation
  Substation & substation() { return parent(); }

  id_type const& voltageLevelId1() const;

  id_type const& voltageLevelId2() const;

  id_type const& voltageLevelId3() const;

  VoltageLevel const& voltageLevel1() const;

  VoltageLevel const& voltageLevel2() const;

  VoltageLevel const& voltageLevel3() const;

public:
  double r1() const { return m_r1; }
  double x1() const { return m_x1; }

  double r2() const { return m_r2; }
  double x2() const { return m_x2; }

  double r3() const { return m_r3; }
  double x3() const { return m_x3; }

  double g1() const { return m_g1; }
  double b1() const { return m_b1; }

  double ratedU1() const { return m_ratedU1; }
  double ratedU2() const { return m_ratedU2; }
  double ratedU3() const { return m_ratedU3; }


  /** tells if the active power at side 1 is set */
  bool has_p1() const { return static_cast<bool>(m_p1); }
  /** gets the active power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double p1() const { return m_p1.value(); }
  /** gets the optional active power at side 1 */
  boost::optional<double> const& optional_p1() const { return m_p1; }
  /** sets the active power at side 1 */
  Transformer3Windings& p1(double p1) { m_p1 = p1; return *this; }
  /** sets the active power at side 1 (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& p1(boost::optional<double> const& p1) { m_p1 = p1; return *this; }


  /** tells if the reactive power at side 1 is set */
  bool has_q1() const { return static_cast<bool>(m_q1); }
  /** gets the reactive power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double q1() const { return m_q1.value(); }
  /** gets the optional reactive power at side 1 */
  boost::optional<double> const& optional_q1() const { return m_q1; }
  /** sets the reactive power at side 1 */
  Transformer3Windings& q1(double q1) { m_q1 = q1; return *this; }
  /** sets the reactive power at side 1 (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& q1(boost::optional<double> const& q1) { m_q1 = q1; return *this; }


  /** tells if the active power at side 2 is set */
  bool has_p2() const { return static_cast<bool>(m_p2); }
  /** gets the active power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double p2() const { return m_p2.value(); }
  /** gets the optional active power at side 2 */
  boost::optional<double> const& optional_p2() const { return m_p2; }
  /** sets the active power at side 2 */
  Transformer3Windings& p2(double p2) { m_p2 = p2; return *this; }
  /** sets the active power at side 2 (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& p2(boost::optional<double> const& p2) { m_p2 = p2; return *this; }


  /** tells if the reactive power at side 2 is set */
  bool has_q2() const { return static_cast<bool>(m_q2); }
  /** gets the reactive power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double q2() const { return m_q2.value(); }
  /** gets the optional reactive power at side 2 */
  boost::optional<double> const& optional_q2() const { return m_q2; }
  /** sets the reactive power at side 2 */
  Transformer3Windings& q2(double q2) { m_q2 = q2; return *this; }
  /** sets the reactive power at side 2 (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& q2(boost::optional<double> const& q2) { m_q2 = q2; return *this; }



  /** tells if the active power at side 3 is set */
  bool has_p3() const { return static_cast<bool>(m_p3); }
  /** gets the active power at side 3
   * @throws boost::bad_optional_access if not set
   */
  double p3() const { return m_p3.value(); }
  /** gets the optional active power at side 3 */
  boost::optional<double> const& optional_p3() const { return m_p3; }
  /** sets the active power at side 3 */
  Transformer3Windings& p3(double p3) { m_p3 = p3; return *this; }
  /** sets the active power at side 3 (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& p3(boost::optional<double> const& p3) { m_p3 = p3; return *this; }


  /** tells if the reactive power at side 3 is set */
  bool has_q3() const { return static_cast<bool>(m_q3); }
  /** gets the reactive power at side 3
   * @throws boost::bad_optional_access if not set
   */
  double q3() const { return m_q3.value(); }
  /** gets the optional reactive power at side 3 */
  boost::optional<double> const& optional_q3() const { return m_q3; }
  /** sets the reactive power at side 3 */
  Transformer3Windings& q3(double q3) { m_q3 = q3; return *this; }
  /** sets the reactive power at side 3 (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& q3(boost::optional<double> const& q3) { m_q3 = q3; return *this; }




  /** tells if  is set */
  bool has_ratioTapChanger2() const { return static_cast<bool>(m_ratioTapChanger2); }
  /** gets
   * @throws boost::bad_optional_access if not set
   */
  RatioTapChanger const& ratioTapChanger2() const { return m_ratioTapChanger2.value(); }
  /** gets the optional  */
  boost::optional<RatioTapChanger> const& optional_ratioTapChanger2() const { return m_ratioTapChanger2; }
  /** sets  */
  Transformer3Windings& ratioTapChanger2(RatioTapChanger const& rtc) { m_ratioTapChanger2 = rtc; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& ratioTapChanger2(boost::optional<RatioTapChanger> const& rtc) { m_ratioTapChanger2 = rtc; return *this; }


  /** tells if  is set */
  bool has_ratioTapChanger3() const { return static_cast<bool>(m_ratioTapChanger3); }
  /** gets
   * @throws boost::bad_optional_access if not set
   */
  RatioTapChanger const& ratioTapChanger3() const { return m_ratioTapChanger3.value(); }
  /** gets the optional  */
  boost::optional<RatioTapChanger> const& optional_ratioTapChanger3() const { return m_ratioTapChanger3; }
  /** sets  */
  Transformer3Windings& ratioTapChanger3(RatioTapChanger const& rtc) { m_ratioTapChanger3 = rtc; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& ratioTapChanger3(boost::optional<RatioTapChanger> const& rtc) { m_ratioTapChanger3 = rtc; return *this; }


  /** tells if  at side 1 is set */
  bool has_currentLimits1() const { return static_cast<bool>(m_currentLimits1); }
  /** gets  at side 1
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits1() const { return m_currentLimits1.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits1() const { return m_currentLimits1; }
  /** sets  */
  Transformer3Windings& currentLimits1(CurrentLimits const& l) { m_currentLimits1 = l; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& currentLimits1(boost::optional<CurrentLimits> const& l) { m_currentLimits1 = l; return *this; }


  /** tells if  at side 2 is set */
  bool has_currentLimits2() const { return static_cast<bool>(m_currentLimits2); }
  /** gets  at side 2
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits2() const { return m_currentLimits2.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits2() const { return m_currentLimits2; }
  /** sets  */
  Transformer3Windings& currentLimits2(CurrentLimits const& l) { m_currentLimits2 = l; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& currentLimits2(boost::optional<CurrentLimits> const& l) { m_currentLimits2 = l; return *this; }


  /** tells if  at side 3 is set */
  bool has_currentLimits3() const { return static_cast<bool>(m_currentLimits3); }
  /** gets  at side 3
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits3() const { return m_currentLimits3.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits3() const { return m_currentLimits3; }
  /** sets  */
  Transformer3Windings& currentLimits3(CurrentLimits const& l) { m_currentLimits3 = l; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Transformer3Windings& currentLimits3(boost::optional<CurrentLimits> const& l) { m_currentLimits3 = l; return *this; }


private:
  double m_r1;
  double m_x1;
  double m_r2;
  double m_x2;
  double m_r3;
  double m_x3;
  double m_g1;
  double m_b1;

  double m_ratedU1;
  double m_ratedU2;
  double m_ratedU3;

  boost::optional<double> m_p1;
  boost::optional<double> m_q1;
  boost::optional<double> m_p2;
  boost::optional<double> m_q2;
  boost::optional<double> m_p3;
  boost::optional<double> m_q3;

  boost::optional<RatioTapChanger> m_ratioTapChanger2;
  boost::optional<RatioTapChanger> m_ratioTapChanger3;
  boost::optional<CurrentLimits> m_currentLimits1;
  boost::optional<CurrentLimits> m_currentLimits2;
  boost::optional<CurrentLimits> m_currentLimits3;

private:
  Transformer3Windings(Identifier const&, properties_type const&);
  friend class IIDM::builders::Transformer3WindingsBuilder;

};


} // end of namespace IIDM::

#endif
