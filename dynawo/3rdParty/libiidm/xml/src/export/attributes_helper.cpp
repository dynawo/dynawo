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
 * @file xml/export/attributes_helper.cpp
 * @brief xml export support functions related to xml attributes
 */

 #include <IIDM/xml/export/attributes_helper.h>


#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace xml {

using ::xml::sax::formatter::Element;
using ::xml::sax::formatter::AttributeList;

using namespace detail;

//to use with attributes_adder or an extension
attributes_adder const& operator << (attributes_adder const& attrs, IIDM::Connection const& c) {
  if (c.is_node()) {
    attrs.add("node", c.port().node());
  }
  else {
    if (c.status() == IIDM::connected) attrs.add("bus", c.port().bus_id());
    attrs.add("connectableBus", c.port().bus_id());
  }
  return attrs;
}


//to use with attributes_adder or an extension
attributes_adder const& operator << (attributes_adder const& attrs, WithVoltageLevel<IIDM::Connection> const& c) {
  return attrs.add("voltageLevelId", c->voltageLevel()) << *c;
}

//adds Identifiable attributes
AttributeList& operator << (AttributeList& attrs, IIDM::Identifiable const& identifiable) {
  return add(attrs)
    ("id", identifiable.id())
    ("name", identifiable.named() ? boost::make_optional(identifiable.name()) : boost::none)
  ;
}


} // end of namespace IIDM::xml::
} // end of namespace IIDM::
