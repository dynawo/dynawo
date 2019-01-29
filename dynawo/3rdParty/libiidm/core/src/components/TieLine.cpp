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
 * @file src/components/TieLine.cpp
 * @brief TieLine implementation file
 */

#include <IIDM/components/TieLine.h>
#include <IIDM/Network.h>

namespace IIDM {

TieLine::TieLine(Identifier const& id, properties_type const& properties): Identifiable(id, properties) {}

VoltageLevel const& TieLine::voltageLevel1() const {
  boost::optional<Connection> c = connection(side_1);
  if (!c) throw std::runtime_error("no connection at side 1");
  return network().voltageLevel( c->voltageLevel() );
}

VoltageLevel const& TieLine::voltageLevel2() const {
  boost::optional<Connection> c = connection(side_1);
  if (!c) throw std::runtime_error("no connection at side 1");
  return network().voltageLevel( c->voltageLevel() );
}

} // end of namespace IIDM::
