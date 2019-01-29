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
 * @file xml/import/DanglingLineHandler.cpp
 * @brief provides DanglingLineHandler definition
 */

#include <IIDM/xml/import/SwitchHandler.h>

namespace xml {
namespace sax {
namespace parser {

template<>
Attributes::SearchedAttribute::operator IIDM::Switch::e_type () const {
  if (!value) throw std::runtime_error("no value for attribute "+name);

  if (*value=="BREAKER") return IIDM::Switch::breaker;
  if (*value=="DISCONNECTOR") return IIDM::Switch::disconnector;
  return IIDM::Switch::load_break_switch;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

namespace IIDM {
namespace xml {

SwitchHandler::SwitchHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::SwitchBuilder, false, IIDM::side_2>(root_element)
{}

void SwitchHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::SwitchBuilder, false, IIDM::side_2>::configure(attributes);
  builder()
    .type( attributes["kind"] )
    .retained( attributes["retained"] )
    .opened( attributes["open"] )
    .fictitious( attributes["fictitious"] | false )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
