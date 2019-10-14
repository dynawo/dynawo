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
 * @file components/Switch.h
 * @brief Switch inside a VoltageLevel
 */


#ifndef LIBIIDM_COMPONENTS_GUARD_SWITCH_H
#define LIBIIDM_COMPONENTS_GUARD_SWITCH_H

#include <string>
#include <boost/optional.hpp>
#include <utility>


#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/ContainedIn.h>
#include <IIDM/components/Connectable.h>

#include <IIDM/components/ConnectionPoint.h>

namespace IIDM {

class VoltageLevel;

namespace builders {
class SwitchBuilder;
} // end of namespace IIDM::builders::

/**
 * @class Switch
 * @brief a switch must and can only contain two bus or two node.
 */
class Switch: public Identifiable, public ContainedIn<VoltageLevel> {
public:
  //aliases of parent()
  ///tells if a parent is specified
  bool has_voltageLevel() const { return has_parent(); }

  ///gets a constant reference to the parent VoltageLevel
  VoltageLevel const& voltageLevel() const { return parent(); }
  ///gets a reference to the parent VoltageLevel
  VoltageLevel & voltageLevel() { return parent(); }

public:
  enum e_type {breaker, disconnector, load_break_switch};

  enum e_mode {mode_disconnected, mode_bus, mode_node};

public:
  ///throws if called on a switch having no parent.
  Switch& connectTo(Port const&, Port const&);

  bool connected() const { return static_cast<bool>(m_ports); }

  ConnectionPoint const& port1() const { return m_ports->first ; }
  ConnectionPoint const& port2() const { return m_ports->second; }

  boost::optional<ConnectionPoint> optional_port1() const { return m_ports ? boost::make_optional(m_ports->first ) : boost::none ; }
  boost::optional<ConnectionPoint> optional_port2() const { return m_ports ? boost::make_optional(m_ports->second) : boost::none ; }

  e_mode mode() const;

  e_type type() const { return m_type; }

  bool retained() const { return m_retained; }

  bool opened() const { return m_opened; }

  Switch& open(bool opened) { m_opened = opened; return *this; }

  Switch& open() { m_opened = true; return *this; }
  Switch& close() { m_opened = false; return *this; }

  bool fictitious() const { return m_fictitious; }

  // setter for states variables

private:
  Switch(Identifier const&, e_type, bool retained, bool opened, bool fictitious);
  friend class IIDM::builders::SwitchBuilder;

  e_type m_type;
  bool m_retained;
  bool m_opened;
  bool m_fictitious;

  boost::optional< std::pair<ConnectionPoint, ConnectionPoint> > m_ports;
};


} // end of namespace IIDM::

#endif
