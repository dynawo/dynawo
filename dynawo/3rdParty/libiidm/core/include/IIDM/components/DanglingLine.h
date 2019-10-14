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
 * @file components/DanglingLine.h
 * @brief DanglingLine interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_DANGLINGLINE_H
#define LIBIIDM_COMPONENTS_GUARD_DANGLINGLINE_H

#include <string>

#include <boost/optional.hpp>


#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/Injection.h>
#include <IIDM/components/ContainedIn.h>

#include <IIDM/components/CurrentLimit.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class DanglingLineBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief DanglingLine in the network
 */
class DanglingLine: public Identifiable, public Injection<DanglingLine>, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }
  ///gets a reference to the parent VoltageLevel
  VoltageLevel & voltageLevel() { return parent(); }

public:
  /** get the constant active power */
  double p0() const { return m_p0; }

  /** get the constant reactive power */
  double q0() const { return m_q0; }


  double r() const { return m_r; }

  double x() const { return m_x; }

  double g() const { return m_g; }

  double b() const { return m_b; }


  /** tells if the UCTE xNodeCode is set */
  bool has_ucte_xNodeCode() const { return static_cast<bool>(m_ucte_xNodeCode); }
  /** gets the UCTE xNodeCode
   * @throws boost::bad_optional_access if not set
   */
  std::string const& ucte_xNodeCode() const { return m_ucte_xNodeCode.value(); }
  /** gets the optional UCTE xNodeCode */
  boost::optional<std::string> const& optional_ucte_xNodeCode() const { return m_ucte_xNodeCode; }
  /** sets the UCTE xNodeCode */
  DanglingLine& ucte_xNodeCode(std::string const& ucte_xNodeCode) { m_ucte_xNodeCode = ucte_xNodeCode; return *this; }
  /** sets the UCTE xNodeCode (or unsets if used with boost::none or an empty optional) */
  DanglingLine& ucte_xNodeCode(boost::optional<std::string> const& ucte_xNodeCode) { m_ucte_xNodeCode = ucte_xNodeCode; return *this; }


  /** tells if the current limits are set */
  bool has_currentLimits() const { return static_cast<bool>(m_currentLimits); }
  /** gets the current limits
   * @throws boost::bad_optional_access if not set
   */
  CurrentLimits const& currentLimits() const { return m_currentLimits.value(); }
  /** gets the optional  */
  boost::optional<CurrentLimits> const& optional_currentLimits() const { return m_currentLimits; }
  /** sets the current limits */
  DanglingLine& currentLimits(CurrentLimits const& currentLimits) { m_currentLimits = currentLimits; return *this; }
  /** sets the current limits (or unsets if used with boost::none or an empty optional) */
  DanglingLine& currentLimits(boost::optional<CurrentLimits> const& currentLimits) { m_currentLimits = currentLimits; return *this; }

private:
  double m_p0;
  double m_q0;
  double m_r;
  double m_x;
  double m_g;
  double m_b;
  boost::optional<std::string> m_ucte_xNodeCode;
  boost::optional<CurrentLimits> m_currentLimits;

private:
  DanglingLine(Identifier const&, properties_type const&);
  friend class IIDM::builders::DanglingLineBuilder;
};


} // end of namespace IIDM::

#endif
