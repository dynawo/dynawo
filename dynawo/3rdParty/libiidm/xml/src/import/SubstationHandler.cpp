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
 * @file xml/import/SubstationHandler.cpp
 * @brief Provides SubstationHandler definition
 */

#include <IIDM/xml/import/SubstationHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include <IIDM/components/Substation.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;

namespace IIDM {
namespace xml {

void SubstationHandler::add_voltageLevel(VoltageLevelHandler const& vl_handler) {
  get().add(vl_handler.get());
}

SubstationHandler::SubstationHandler(elementName_type const& root_element):
  parent_type(root_element),
  voltagelevel_handler(elementName_type(iidm_ns, "voltageLevel")),
  transformer2windings_handler(elementName_type(iidm_ns, "twoWindingsTransformer")),
  transformer3windings_handler(elementName_type(iidm_ns, "threeWindingsTransformer"))
{
  onElement(root_element+iidm_ns("voltageLevel"), voltagelevel_handler);
  voltagelevel_handler.onStart( create_builded(*this) );
  voltagelevel_handler.onEnd(
    lambda::bind( &SubstationHandler::add_voltageLevel, lambda::ref(*this), lambda::cref(voltagelevel_handler) )
  );

  set_connectable_handler(root_element+iidm_ns("twoWindingsTransformer"), transformer2windings_handler);
  set_connectable_handler(root_element+iidm_ns("threeWindingsTransformer"), transformer3windings_handler);
}

void SubstationHandler::configure(attributes_type const& attributes) {
  parent_type::configure(attributes);

  builder()
    .country( attributes["country"] )
    .tso( attributes["tso"] )
    .geographicalTags( attributes["geographicalTags"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
