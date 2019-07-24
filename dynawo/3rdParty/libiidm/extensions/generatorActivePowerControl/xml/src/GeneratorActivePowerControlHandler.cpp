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
 * @file GeneratorActivePowerControlHandler.cpp
 * @brief Provides GeneratorActivePowerControlHandler definition
 */

#include <IIDM/extensions/generatorActivePowerControl/xml/GeneratorActivePowerControlHandler.h>
#include <IIDM/extensions/GeneratorActivePowerControl.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace generatoractivepowercontrol {
namespace xml {

std::string GeneratorActivePowerControlHandler::xsd_path() {
  const std::string xsdPath = getEnvVar("IIDM_EXT_GENERATORACTIVEPOWERCONTROL_XML_XSD_PATH");
  return xsdPath + std::string("generatorActivePowerControl.xsd");
}

GeneratorActivePowerControlHandler::elementName_type const GeneratorActivePowerControlHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/generator_active_power_control/1_0"), "generatorActivePowerControl"
);

GeneratorActivePowerControl* GeneratorActivePowerControlHandler::do_make() {
  return GeneratorActivePowerControlBuilder()
    .participate( attribute("participate") )
    .droop( attribute("droop") )
  .build().clone().release();
}

} // end of namespace IIDM::extensions::generatoractivepowercontrol::xml::
} // end of namespace IIDM::extensions::generatoractivepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
