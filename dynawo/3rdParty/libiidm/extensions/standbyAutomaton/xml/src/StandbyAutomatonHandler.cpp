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
 * @file StandbyAutomatonHandler.cpp
 * @brief Provides StandbyAutomatonHandler definition
 */

#include <IIDM/extensions/standbyAutomaton/xml/StandbyAutomatonHandler.h>
#include <IIDM/extensions/StandbyAutomaton.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace standbyautomaton {
namespace xml {

std::string StandbyAutomatonHandler::xsd_path() {
  const std::string xsdPath = getEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("standbyAutomaton.xsd");
}

StandbyAutomatonHandler::elementName_type const& StandbyAutomatonHandler::root() {
  static elementName_type const root(
    parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/standby_automaton/1_0"), "standbyAutomaton"
  );
  return root;
}

StandbyAutomaton* StandbyAutomatonHandler::do_make() {
  return StandbyAutomatonBuilder()
    .standBy( attribute("standby") )
    .b0( attribute("b0") )
    .lowVoltageSetPoint( attribute("lowVoltageSetPoint") )
    .highVoltageSetPoint( attribute("highVoltageSetPoint") )
    .lowVoltageThreshold( attribute("lowVoltageThreshold") )
    .highVoltageThreshold( attribute("highVoltageThreshold") )
  .build().clone().release();
}

} // end of namespace IIDM::extensions::standbyautomaton::xml::
} // end of namespace IIDM::extensions::standbyautomaton::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
