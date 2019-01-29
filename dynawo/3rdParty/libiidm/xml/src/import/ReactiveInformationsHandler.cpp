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
 * @file xml/import/ReactiveInformationsHandler.cpp
 * @brief ReactiveCapabilityCurveHandler, and MinMaxReactiveLimitsHandler definition
 */

#include <IIDM/xml/import/ReactiveInformationsHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"

#include <xml/sax/parser/Attributes.h>


namespace IIDM {
namespace xml {

void ReactiveCapabilityCurveHandler::do_startElement(elementName_type const& name, attributes_type const& attributes) {
  if (name == iidm_ns("reactiveCapabilityCurve") ) {
    curve = IIDM::ReactiveCapabilityCurve();
  } else if ( name == iidm_ns("point") ) {
    curve->add( attributes["p"], attributes["minQ"], attributes["maxQ"] );
  }
}


void MinMaxReactiveLimitsHandler::do_startElement(elementName_type const&, attributes_type const& attributes) {
  limits = IIDM::MinMaxReactiveLimits(attributes["minQ"], attributes["maxQ"]);
}


} // end of namespace IIDM::xml::
} // end of namespace IIDM::
