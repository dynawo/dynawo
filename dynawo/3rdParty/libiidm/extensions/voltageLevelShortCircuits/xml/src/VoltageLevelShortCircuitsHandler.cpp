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
 * @file VoltageLevelShortCircuitsHandler.cpp
 * @brief Provides VoltageLevelShortCircuitsHandler definition
 */
 
#include <IIDM/extensions/voltageLevelShortCircuits/xml/VoltageLevelShortCircuitsHandler.h>
#include <IIDM/extensions/VoltageLevelShortCircuits.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace voltagelevelshortcircuits {
namespace xml {
  
std::string VoltageLevelShortCircuitsHandler::xsd_path() {
  return IIDM_EXT_VOLTAGELEVELSHORTCIRCUITS_XML_XSD_PATH + std::string("voltageLevelShortCircuits.xsd");
}

VoltageLevelShortCircuitsHandler::elementName_type const VoltageLevelShortCircuitsHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/voltagelevel_short_circuits/1_0"), "voltageLevelShortCircuits"
);

VoltageLevelShortCircuits* VoltageLevelShortCircuitsHandler::do_make() {
  return VoltageLevelShortCircuitsBuilder()
    .minShortCircuitsCurrent( attribute("minShortCircuitsCurrent") )
    .maxShortCircuitsCurrent( attribute("maxShortCircuitsCurrent") )
  .build().clone().release();
}

} // end of namespace IIDM::extensions::voltagelevelshortcircuits::xml::
} // end of namespace IIDM::extensions::voltagelevelshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
