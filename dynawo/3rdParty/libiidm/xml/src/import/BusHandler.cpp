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
 * @file xml/import/BusHandler.cpp
 * @brief Provides BusHandler definition
 */

#include <IIDM/xml/import/BusHandler.h>

namespace IIDM {
namespace xml {

BusHandler::BusHandler(elementName_type const& root_element):
  IdentifiableHandler<IIDM::builders::BusBuilder>(root_element)
{}

void BusHandler::configure(attributes_type const& attributes) {
  IdentifiableHandler<IIDM::builders::BusBuilder>::configure(attributes);

  builder()
    .v( attributes["v"] )
    .angle( attributes["angle"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
