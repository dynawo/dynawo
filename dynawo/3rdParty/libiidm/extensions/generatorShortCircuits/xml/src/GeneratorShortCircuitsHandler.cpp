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
 * @file GeneratorShortCircuitsHandler.cpp
 * @brief Provides GeneratorShortCircuitsHandler definition
 */

#include <IIDM/extensions/generatorShortCircuits/xml/GeneratorShortCircuitsHandler.h>
#include <IIDM/extensions/GeneratorShortCircuits.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace generatorshortcircuits {
namespace xml {

std::string GeneratorShortCircuitsHandler::xsd_path() {
  const std::string xsdPath = getEnvVar("IIDM_EXT_GENERATORSHORTCIRCUITS_XML_XSD_PATH");
  return xsdPath + std::string("generatorShortCircuits.xsd");
}

GeneratorShortCircuitsHandler::elementName_type const GeneratorShortCircuitsHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/generator_short_circuits/1_0"), "generatorShortCircuits"
);

GeneratorShortCircuits* GeneratorShortCircuitsHandler::do_make() {
  return GeneratorShortCircuitsBuilder()
    .transientReactance( attribute("transientReactance") )
    .stepUpTransformerReactance( attribute("stepUpTransformerReactance") )
  .build().clone().release();
}

} // end of namespace IIDM::extensions::generatorshortcircuits::xml::
} // end of namespace IIDM::extensions::generatorshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
