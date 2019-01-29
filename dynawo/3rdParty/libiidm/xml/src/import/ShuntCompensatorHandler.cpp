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
 * @file xml/import/ShuntCompensatorHandler.cpp
 * @brief Provides ShuntCompensatorHandler definition
 */

#include <IIDM/xml/import/ShuntCompensatorHandler.h>

namespace IIDM {
namespace xml {

ShuntCompensatorHandler::ShuntCompensatorHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::ShuntCompensatorBuilder, false, IIDM::side_1>(root_element)
{}

void ShuntCompensatorHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::ShuntCompensatorBuilder, false, IIDM::side_1>::configure(attributes);
  builder()
    .section_current( attributes["currentSectionCount"] )
    .section_max( attributes["maximumSectionCount"] )
    .b_per_section( attributes["bPerSection"] )
    .q( attributes["q"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
