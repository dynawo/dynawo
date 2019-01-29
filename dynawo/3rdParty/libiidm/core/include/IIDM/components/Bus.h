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
 * @file components/Bus.h
 * @brief Bus inside a VoltageLevel
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_BUS_H
#define LIBIIDM_COMPONENTS_GUARD_BUS_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class BusBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief Bus in a voltage level
 */
class IIDM_EXPORT Bus: public Identifiable, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }
  
  ///gets a reference to the parent VoltageLevel
  VoltageLevel & voltageLevel() { return parent(); }

public:
  /** tells if the tension is set */
  bool has_v() const { return static_cast<bool>(m_v); }
  /** gets the tension
   * @throws boost::bad_optional_access if not set
   */
  double v() const { return m_v.value(); }
  /** gets the optional tension */
  boost::optional<double> const& optional_v() const { return m_v; }
  /** sets the tension */
  Bus& v(double v) { m_v = v; return *this; }
  /** sets the tension (or unsets if used with boost::none or an empty optional) */
  Bus& v(boost::optional<double> const& v) { m_v = v; return *this; }

  /** tells if the angle is set */
  bool has_angle() const { return static_cast<bool>(m_angle); }
  /** gets the angle
   * @throws boost::bad_optional_access if not set
   */
  double angle() const { return m_angle.value(); }
  /** gets the optional angle */
  boost::optional<double> const& optional_angle() const { return m_angle; }
  /** sets the angle */
  Bus& angle(double angle) { m_angle = angle; return *this; }
  /** sets the angle (or unsets if used with boost::none or an empty optional) */
  Bus& angle(boost::optional<double> const& angle) { m_angle = angle; return *this; }

private:
  boost::optional<double> m_v;
  boost::optional<double> m_angle;

private:
  Bus(Identifier const&, properties_type const&);
  friend class IIDM::builders::BusBuilder;
};

} // end of namespace IIDM::

#endif

