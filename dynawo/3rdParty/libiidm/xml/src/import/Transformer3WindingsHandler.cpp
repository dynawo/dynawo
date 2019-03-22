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
 * @file xml/import/Transformer3WindingsHandler.cpp
 * @brief Provides Transformer3WindingsHandler definition
 */

#include <IIDM/xml/import/Transformer3WindingsHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"

namespace IIDM {
namespace xml {

Transformer3WindingsHandler::Transformer3WindingsHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::Transformer3WindingsBuilder, true, IIDM::side_3>(root_element),
  currentLimits1_handler(elementName_type(iidm_ns, "currentLimits1")),
  currentLimits2_handler(elementName_type(iidm_ns, "currentLimits2")),
  currentLimits3_handler(elementName_type(iidm_ns, "currentLimits3")),
  rtc2_handler(elementName_type(iidm_ns, "ratioTapChanger2")),
  rtc3_handler(elementName_type(iidm_ns, "ratioTapChanger3"))
{
  currentLimits1_handler.onEnd( make_setter(builder(), &builder_type::currentLimits1, currentLimits1_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits1"), currentLimits1_handler );

  currentLimits2_handler.onEnd( make_setter(builder(), &builder_type::currentLimits2, currentLimits2_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits2"), currentLimits2_handler );

  currentLimits3_handler.onEnd( make_setter(builder(), &builder_type::currentLimits3, currentLimits3_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits3"), currentLimits3_handler );


  rtc2_handler.onEnd( make_setter(builder(), &builder_type::ratioTapChanger2, rtc2_handler.tapchanger) );
  onElement( root_element+iidm_ns("ratioTapChanger2"), rtc2_handler );

  rtc3_handler.onEnd( make_setter(builder(), &builder_type::ratioTapChanger3, rtc3_handler.tapchanger) );
  onElement( root_element+iidm_ns("ratioTapChanger3"), rtc3_handler );
}


void Transformer3WindingsHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::Transformer3WindingsBuilder, true, IIDM::side_3>::configure(attributes);
  builder()
    .r1( attributes["r1"] )
    .x1( attributes["x1"] )
    .r2( attributes["r2"] )
    .x2( attributes["x2"] )
    .r3( attributes["r3"] )
    .x3( attributes["x3"] )
    .g1( attributes["g1"] )
    .b1( attributes["b1"] )
    .ratedU1( attributes["ratedU1"] )
    .ratedU2( attributes["ratedU2"] )
    .ratedU3( attributes["ratedU3"] )
    .p1( attributes["p1"] )
    .q1( attributes["q1"] )
    .p2( attributes["p2"] )
    .q2( attributes["q2"] )
    .p3( attributes["p3"] )
    .q3( attributes["q3"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
