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
 * @file components/Substation.cpp
 * @brief Substation implementation file
 */

#include <IIDM/components/Substation.h>

#include <IIDM/components/NetworkOf.h>
#include <IIDM/Network.h>

namespace IIDM {
Substation::Substation(Identifier const& id, properties_type const& properties): Identifiable(id, properties) {}


void Substation::register_into(Network & net) {
  net.register_identifiable(*this);

  net.register_all_identifiable(twoWindingsTransformers());
  net.register_all_identifiable(threeWindingsTransformers());

  for (Contains<VoltageLevel>::iterator it = voltageLevels().begin(); it!=voltageLevels().end(); ++it) {
    it->register_into(net);
  }
}


VoltageLevel& Substation::add(VoltageLevel const& voltageLevel) {
  VoltageLevel& added = Contains<VoltageLevel>::add(voltageLevel);

  Network* net = network_of(*this);
  if (net) {
    added.register_into(*net);
  }

  return added;
}

Substation& Substation::add(Transformer2Windings const& transformer, boost::optional<Connection> const& c1, boost::optional<Connection> const& c2) {
  check(c1, side_2);
  check(c2, side_2);

  Transformer2Windings & added = Contains<Transformer2Windings>::add(transformer);

  Network* net = network_of(*this);
  if (net) net->register_identifiable(added);

  if (c1) added.createConnection(*c1);
  if (c2) added.createConnection(*c2);

  return *this;
}



Substation& Substation::add(Transformer3Windings const& transformer,
  boost::optional<Connection> const& c1,
  boost::optional<Connection> const& c2,
  boost::optional<Connection> const& c3
) {
  check(c1, side_3);
  check(c2, side_3);
  check(c3, side_3);

  Transformer3Windings & added = Contains<Transformer3Windings>::add(transformer);

  Network* net = network_of(*this);
  if (net) net->register_identifiable(added);

  if (c1) added.createConnection(*c1);
  if (c2) added.createConnection(*c2);
  if (c3) added.createConnection(*c3);

  return *this;
}



//throws if a connection is not valid or does not match the given side count
void Substation::check(boost::optional<Connection> const& connection, side_id max_sides) const {
  if (!connection) return;

  if (!connection->has_voltageLevel()) {
    throw std::runtime_error("missing voltage level");
  }

  //look for connection.voltageLevel()
  voltageLevel_const_iterator v = find_voltageLevel(connection->voltageLevel());
  if (v == voltageLevels_end()) {
    throw std::runtime_error("no such voltage level: " + connection->voltageLevel());
  }
  v->check(*connection, max_sides);
}

} // end of namespace IIDM::
