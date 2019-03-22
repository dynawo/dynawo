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
 * @file GeneratorStartupHandler.cpp
 * @brief Provides GeneratorStartupHandler definition
 */

#include <IIDM/extensions/generatorStartup/xml/GeneratorStartupHandler.h>
#include <IIDM/extensions/GeneratorStartup.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace generator_startup {
namespace xml {

std::string GeneratorStartupHandler::xsd_path() {
  return IIDM_EXT_GENERATORSTARTUP_XML_XSD_PATH + std::string("generatorStartup.xsd");
}

GeneratorStartupHandler::elementName_type const GeneratorStartupHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/generator_startup/1_0"), "startup"
);

GeneratorStartup* GeneratorStartupHandler::do_make() {
  return GeneratorStartupBuilder()
    .predefinedActivePowerSetpoint( attribute("predefinedActivePowerSetpoint"))
    .marginalCost( attribute("marginalCost"))
    .plannedOutageRate( attribute("plannedOutageRate"))
    .forcedOutageRate( attribute("forcedOutageRate"))
  .build().clone().release();
}

} // end of namespace IIDM::extensions::generator_startup::xml::
} // end of namespace IIDM::extensions::generator_startup::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
