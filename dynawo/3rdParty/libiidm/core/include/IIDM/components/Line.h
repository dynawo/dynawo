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
 * @file components/Line.h
 * @brief Line interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_LINE_H
#define LIBIIDM_COMPONENTS_GUARD_LINE_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Connectable.h>
#include <IIDM/components/ContainedIn.h>
#include <IIDM/components/CurrentLimit.h>

namespace IIDM {

class Network;
class VoltageLevel;

namespace builders {
class LineBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief Line in the network
 */
class IIDM_EXPORT Line: public Identifiable, public Connectable<Line, side_2>, public ContainedIn<Network> {
public:
  //aliases of parent()
  ///tells if a parent network is specified
  bool has_network() const { return has_parent(); }

  ///gets a constant reference to the parent network
  Network const& network() const { return parent(); }
  ///gets a reference to the parent network
  Network      & network()       { return parent(); }

  VoltageLevel const& voltageLevel1() const;

  VoltageLevel const& voltageLevel2() const;

public:
  double r() const { return m_r; }

  double x() const { return m_x; }

  double g1() const { return m_g1; }

  double b1() const { return m_b1; }

  double g2() const { return m_g2; }

  double b2() const { return m_b2; }


  /** tells if the active power at side 1 is set */
  bool has_p1() const { return static_cast<bool>(m_p1); }
  /** gets the active power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double p1() const { return m_p1.value(); }
  /** gets the optional active power at side 1 */
  boost::optional<double> const& optional_p1() const { return m_p1; }
  /** sets the active power at side 1 */
  Line& p1(double p1) { m_p1 = p1; return *this; }
  /** sets the active power at side 1 (or unsets if used with boost::none or an empty optional) */
  Line& p1(boost::optional<double> const& p1) { m_p1 = p1; return *this; }


  /** tells if the reactive power at side 1 is set */
  bool has_q1() const { return static_cast<bool>(m_q1); }
  /** gets the reactive power at side 1
   * @throws boost::bad_optional_access if not set
   */
  double q1() const { return m_q1.value(); }
  /** gets the optional reactive power at side 1 */
  boost::optional<double> const& optional_q1() const { return m_q1; }
  /** sets the reactive power at side 1 */
  Line& q1(double q1) { m_q1 = q1; return *this; }
  /** sets the reactive power at side 1 (or unsets if used with boost::none or an empty optional) */
  Line& q1(boost::optional<double> const& q1) { m_q1 = q1; return *this; }


  /** tells if the active power at side 2 is set */
  bool has_p2() const { return static_cast<bool>(m_p2); }
  /** gets the active power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double p2() const { return m_p2.value(); }
  /** gets the optional active power at side 2 */
  boost::optional<double> const& optional_p2() const { return m_p2; }
  /** sets the active power at side 2 */
  Line& p2(double p2) { m_p2 = p2; return *this; }
  /** sets the active power at side 2 (or unsets if used with boost::none or an empty optional) */
  Line& p2(boost::optional<double> const& p2) { m_p2 = p2; return *this; }


  /** tells if the reactive power at side 2 is set */
  bool has_q2() const { return static_cast<bool>(m_q2); }
  /** gets the reactive power at side 2
   * @throws boost::bad_optional_access if not set
   */
  double q2() const { return m_q2.value(); }
  /** gets the optional reactive power at side 2 */
  boost::optional<double> const& optional_q2() const { return m_q2; }
  /** sets the reactive power at side 2 */
  Line& q2(double q2) { m_q2 = q2; return *this; }
  /** sets the reactive power at side 2 (or unsets if used with boost::none or an empty optional) */
  Line& q2(boost::optional<double> const& q2) { m_q2 = q2; return *this; }


  /** tells if  at side 1 is set */
  bool has_currentLimits1() const { return static_cast<bool>(m_currentLimits1); }
  /** gets  at side 1
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits1() const { return m_currentLimits1.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits1() const { return m_currentLimits1; }
  /** sets  */
  Line& currentLimits1(CurrentLimits const& l) { m_currentLimits1 = l; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Line& currentLimits1(boost::optional<CurrentLimits> const& l) { m_currentLimits1 = l; return *this; }


  /** tells if  at side 2 is set */
  bool has_currentLimits2() const { return static_cast<bool>(m_currentLimits2); }
  /** gets  at side 2
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits2() const { return m_currentLimits2.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits2() const { return m_currentLimits2; }
  /** sets  */
  Line& currentLimits2(CurrentLimits const& l) { m_currentLimits2 = l; return *this; }
  /** sets  (or unsets if used with boost::none or an empty optional) */
  Line& currentLimits2(boost::optional<CurrentLimits> const& l) { m_currentLimits2 = l; return *this; }

private:
  double m_r;
  double m_x;
  double m_g1;
  double m_b1;
  double m_g2;
  double m_b2;

  boost::optional<double> m_p1;
  boost::optional<double> m_q1;
  boost::optional<double> m_p2;
  boost::optional<double> m_q2;

  boost::optional<CurrentLimits> m_currentLimits1;
  boost::optional<CurrentLimits> m_currentLimits2;

private:
  Line(Identifier const&, properties_type const&);
  friend class IIDM::builders::LineBuilder;
};

} // end of namespace IIDM

#endif
