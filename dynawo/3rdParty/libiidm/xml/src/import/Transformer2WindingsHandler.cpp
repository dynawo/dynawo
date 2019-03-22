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
 * @file xml/import/Transformer2WindingsHandler.cpp
 * @brief Provides Transformer2WindingsHandler definition
 */

#include <IIDM/xml/import/Transformer2WindingsHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"

namespace IIDM {
namespace xml {

Transformer2WindingsHandler::Transformer2WindingsHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::Transformer2WindingsBuilder, true, IIDM::side_2>(root_element),
  currentLimits1_handler(elementName_type(iidm_ns, "currentLimits1")),
  currentLimits2_handler(elementName_type(iidm_ns, "currentLimits2")),
  rtc_handler(elementName_type(iidm_ns, "ratioTapChanger")),
  ptc_handler(elementName_type(iidm_ns, "phaseTapChanger"))
{
  currentLimits1_handler.onEnd( make_setter(builder(), &builder_type::currentLimits1, currentLimits1_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits1"), currentLimits1_handler );

  currentLimits2_handler.onEnd( make_setter(builder(), &builder_type::currentLimits2, currentLimits2_handler.limits) );
  onElement( root_element+iidm_ns("currentLimits2"), currentLimits2_handler );


  rtc_handler.onEnd( make_setter(builder(), &builder_type::ratioTapChanger, rtc_handler.tapchanger) );
  onElement( root_element+iidm_ns("ratioTapChanger"), rtc_handler );

  ptc_handler.onEnd( make_setter(builder(), &builder_type::phaseTapChanger, ptc_handler.tapchanger) );
  onElement( root_element+iidm_ns("phaseTapChanger"), ptc_handler );
}


void Transformer2WindingsHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::Transformer2WindingsBuilder, true, IIDM::side_2>::configure(attributes);
  builder()
    .r( attributes["r"] )
    .x( attributes["x"] )
    .g( attributes["g"] )
    .b( attributes["b"] )
    .ratedU1( attributes["ratedU1"] )
    .ratedU2( attributes["ratedU2"] )
    .p1( attributes["p1"] )
    .q1( attributes["q1"] )
    .p2( attributes["p2"] )
    .q2( attributes["q2"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
