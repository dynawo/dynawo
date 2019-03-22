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
 * @file xml/import/VscConverterStationHandler.cpp
 * @brief VscConverterStationHandler definition
 */

#include <IIDM/xml/import/VscConverterStationHandler.h>

#include <IIDM/xml/import/ReactiveInformationsHandler.h>
#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"


namespace IIDM {
namespace xml {

VscConverterStationHandler::VscConverterStationHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::VscConverterStationBuilder, false, IIDM::side_1>(root_element)
{
  curve_handler.onEnd( make_setter(builder(), &builder_type::reactiveCapabilityCurve, curve_handler.curve) );
  onElement( root_element+iidm_ns("reactiveCapabilityCurve"), curve_handler );

  limits_handler.onEnd( make_setter(builder(), &builder_type::minMaxReactiveLimits, limits_handler.limits) );
  onElement( root_element+iidm_ns("minMaxReactiveLimits"), limits_handler );
}


void VscConverterStationHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::VscConverterStationBuilder, false, IIDM::side_1>::configure(attributes);

  builder()
    .lossFactor( attributes["lossFactor"] )
    .regulating( attributes["voltageRegulatorOn"] )
    .voltageSetpoint( attributes["voltageSetpoint"] )
    .reactivePowerSetpoint( attributes["reactivePowerSetpoint"] )
    .p( attributes["p"] )
    .q( attributes["q"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
