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

#include <IIDM/xml/import/DanglingLineHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"

namespace IIDM {
namespace xml {

DanglingLineHandler::DanglingLineHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::DanglingLineBuilder, false, IIDM::side_1>(root_element),
  currentLimits(elementName_type(iidm_ns, "currentLimits"))
{
  onElement( root_element+iidm_ns("currentLimits"), currentLimits );
  currentLimits.onEnd( make_setter(builder(), &builder_type::currentLimits, currentLimits.limits) );
}

void DanglingLineHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::DanglingLineBuilder, false, IIDM::side_1>::configure(attributes);

  builder()
    .p0( attributes["p0"] )
    .q0( attributes["q0"] )
    .r( attributes["r"] )
    .x( attributes["x"] )
    .g( attributes["g"] )
    .b( attributes["b"] )
    .p( attributes["p"] )
    .q( attributes["q"] )
    .ucte_xNodeCode( attributes["ucteXnodeCode"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
