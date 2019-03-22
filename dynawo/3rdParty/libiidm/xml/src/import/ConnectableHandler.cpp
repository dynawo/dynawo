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
 * @file xml/import/ConnectableHandler.cpp
 * @brief ConnectableHandler definition file
 */

#include <IIDM/xml/import/ConnectableHandler.h>


#include <boost/optional.hpp>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/Connection.h>

#include <xml/sax/parser/Attributes.h>


namespace IIDM {
namespace xml {

using ::xml::sax::parser::Attributes;

//note: there is no possible disconnected node: meaning no voltageLevelId if neither node nor connectableBus.
namespace {

boost::optional<IIDM::Connection>
make_connection(Attributes::SearchedAttribute const& voltageLevelId, IIDM::Port const& port, IIDM::side_id side) {
  return voltageLevelId.exists() ? IIDM::at(voltageLevelId, port, side) : IIDM::at(port, side);
}

} // end of anonymous namespace

boost::optional<IIDM::Connection>
connection(Attributes const& s, IIDM::side_id side, bool withVoltageLevel) {

  std::string const suffix = (side==side_end) ? "" : boost::lexical_cast<std::string>(side - IIDM::side_begin + 1);

  IIDM::side_id const actual_side = (side!=IIDM::side_end) ? side : IIDM::side_1;

  //a voltage level id is required
  Attributes::SearchedAttribute voltageLevelId = s["voltageLevelId"+suffix];
  if (withVoltageLevel && !voltageLevelId.exists()) return boost::none;

  Attributes::SearchedAttribute node = s["node"+suffix];
  if (node.exists()) {
    return make_connection(voltageLevelId, static_cast<IIDM::node_type>(node), actual_side);
  }

  Attributes::SearchedAttribute connectableBus = s["connectableBus"+suffix];
  Attributes::SearchedAttribute bus = s["bus"+suffix];

  if (connectableBus.exists() || bus.exists()) {
    return make_connection(
      voltageLevelId,
      Port(
        static_cast<IIDM::id_type const&>(bus.exists() ? bus : connectableBus),
        bus.exists() ? IIDM::connected : IIDM::disconnected
      ),
      actual_side
    );
  }

  return boost::none;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
