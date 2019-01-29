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
 * @file xml/import/LoadHandler.cpp
 * @brief Provides LoadHandler definition
 */

#include <IIDM/xml/import/LoadHandler.h>

namespace xml {
namespace sax {
namespace parser {

template<>
Attributes::SearchedAttribute::operator IIDM::Load::e_type () const {
  if (!value) return IIDM::Load::type_undefined;

  if (*value=="AUXILIARY" ) return IIDM::Load::type_auxiliary;
  if (*value=="FICTITIOUS") return IIDM::Load::type_fictitious;
  return IIDM::Load::type_undefined;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
namespace xml {

LoadHandler::LoadHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::LoadBuilder, false, IIDM::side_1>(root_element)
{}

void LoadHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::LoadBuilder, false, IIDM::side_1>::configure(attributes);

  builder()
    .p0( attributes["p0"] )
    .q0( attributes["q0"] )
    .type( attributes["loadType"] )
    .p( attributes["p"] )
    .q( attributes["q"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
