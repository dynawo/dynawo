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
 * @file xml/import/LinesHandler.cpp
 * @brief provides LineHandler and TieLineHandler definitions
 */

#include <IIDM/xml/import/LinesHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"

#include <IIDM/builders/LineBuilder.h>
#include <IIDM/builders/TieLineBuilder.h>

namespace IIDM {
namespace xml {

LineHandler::LineHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::LineBuilder, true, IIDM::side_2>(root_element),
  currentLimits1_handler(elementName_type(iidm_ns, "currentLimits1")),
  currentLimits2_handler(elementName_type(iidm_ns, "currentLimits2"))
{
  currentLimits1_handler.onEnd( make_setter(builder(), &builder_type::currentLimits1, currentLimits1_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits1"), currentLimits1_handler );
  
  currentLimits2_handler.onEnd( make_setter(builder(), &builder_type::currentLimits2, currentLimits2_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits2"), currentLimits2_handler );
}

void LineHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::LineBuilder, true, IIDM::side_2>::configure(attributes);
  builder()
    .r( attributes["r"] )
    .x( attributes["x"] )
    .g1( attributes["g1"] )
    .b1( attributes["b1"] )
    .g2( attributes["g2"] )
    .b2( attributes["b2"] )
    .p1( attributes["p1"] )
    .q1( attributes["q1"] )
    .p2( attributes["p2"] )
    .q2( attributes["q2"] )
  ;
}




TieLineHandler::TieLineHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::TieLineBuilder, true, IIDM::side_2>(root_element),
  currentLimits1_handler(elementName_type(iidm_ns, "currentLimits1")),
  currentLimits2_handler(elementName_type(iidm_ns, "currentLimits2"))
{
  currentLimits1_handler.onEnd( make_setter(builder(), &builder_type::currentLimits1, currentLimits1_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits1"), currentLimits1_handler );
  
  currentLimits2_handler.onEnd( make_setter(builder(), &builder_type::currentLimits2, currentLimits2_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits2"), currentLimits2_handler );
}

void TieLineHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::TieLineBuilder, true, IIDM::side_2>::configure(attributes);
  builder()
    .ucteXnodeCode( attributes["ucteXnodeCode"] )
    
    .id_1( attributes["id_1"] )
    .name_1( attributes["name_1"] )
    .id_1( attributes["id_1"] )
    . r_1( attributes[ "r_1"] )
    . x_1( attributes[ "x_1"] )
    .g1_1( attributes["g1_1"] )
    .b1_1( attributes["b1_1"] )
    .g2_1( attributes["g2_1"] )
    .b2_1( attributes["b2_1"] )
    .xnodeP_1( attributes["xnodeP_1"] )
    .xnodeQ_1( attributes["xnodeQ_1"] )

    .id_2( attributes["id_2"] )
    .id_2( attributes["id_2"] )
    . r_2( attributes[ "r_2"] )
    . x_2( attributes[ "x_2"] )
    .g1_2( attributes["g1_2"] )
    .b1_2( attributes["b1_2"] )
    .g2_2( attributes["g2_2"] )
    .b2_2( attributes["b2_2"] )
    .name_2( attributes["name_2"] )
    .xnodeP_2( attributes["xnodeP_2"] )
    .xnodeQ_2( attributes["xnodeQ_2"] )

    .p1( attributes["p1"] )
    .q1( attributes["q1"] )
    .p2( attributes["p2"] )
    .q2( attributes["q2"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
