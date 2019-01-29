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
 * @file src/components/Transformer3Windings.cpp
 * @brief Transformer3Windings implementation file
 */

#include <IIDM/components/Transformer3Windings.h>
#include <IIDM/Network.h>

namespace IIDM {

Transformer3Windings::Transformer3Windings(Identifier const& id, properties_type const& properties): Identifiable(id, properties) {}

id_type const& Transformer3Windings::voltageLevelId1() const {
  return voltageLevel1().id();
}

id_type const& Transformer3Windings::voltageLevelId2() const {
  return voltageLevel2().id();
}

id_type const& Transformer3Windings::voltageLevelId3() const {
  return voltageLevel3().id();
}


VoltageLevel const& Transformer3Windings::voltageLevel1() const {
  boost::optional<Connection> c = connection(side_1);
  if (!c) throw std::runtime_error("no connection at side 1");
  return substation().get_voltageLevel(c->voltageLevel());
}

VoltageLevel const& Transformer3Windings::voltageLevel2() const {
  boost::optional<Connection> c = connection(side_2);
  if (!c) throw std::runtime_error("no connection at side 2");
  return substation().get_voltageLevel(c->voltageLevel());
}

VoltageLevel const& Transformer3Windings::voltageLevel3() const {
  boost::optional<Connection> c = connection(side_3);
  if (!c) throw std::runtime_error("no connection at side 3");
  return substation().get_voltageLevel(c->voltageLevel());
}

} // end of namespace IIDM::
