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
 * @file src/components/Switch.cpp
 * @brief Switch implementation file
 */

#include <IIDM/components/Switch.h>
#include <IIDM/components/VoltageLevel.h>

namespace IIDM {

Switch::Switch(Identifier const& id, e_type type, bool retained, bool opened, bool fictitious):
  Identifiable(id),
  m_type(type),
  m_retained(retained),
  m_opened(opened),
  m_fictitious(fictitious)
{}


Switch& Switch::connectTo(Port const& port1, Port const& port2) {
  if (port1.is_bus()!=port2.is_bus()) {
    throw std::runtime_error("A switch can not connect a bus and a node");
  }

  m_ports = std::make_pair(ConnectionPoint(parent().id(), port1), ConnectionPoint(parent().id(), port2));
  return *this;
}


Switch::e_mode Switch::mode() const {
  if (!connected()) return mode_disconnected;
  return m_ports->first.is_bus() ? mode_bus : mode_node;
}

} // end of namespace IIDM::
