//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

/**
 * @file GeneratorOperatorActivePowerRangeHandler.cpp
 * @brief Provides GeneratorOperatorActivePowerRangeHandler definition
 */

#include <IIDM/extensions/generatorOperatorActivePowerRange/xml/GeneratorOperatorActivePowerRangeHandler.h>
#include <IIDM/extensions/GeneratorOperatorActivePowerRange.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace generator_operator_activepower_range {
namespace xml {

std::string GeneratorOperatorActivePowerRangeHandler::xsd_path() {
  const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("generatorOperatorActivePowerRange.xsd");
}

GeneratorOperatorActivePowerRangeHandler::elementName_type const GeneratorOperatorActivePowerRangeHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/generatoroperatoractivepowerrange/1_0"), "generatorOperatorActivePowerRange"
);

GeneratorOperatorActivePowerRange* GeneratorOperatorActivePowerRangeHandler::do_make()
{
  // build element from xml
    return GeneratorOperatorActivePowerRangeBuilder()
          .activePowerLimitation(attribute("activePowerLimitation"))
          .build().clone().release();
}

} // end of namespace IIDM::extensions::generator_operator_activepower_range::xml::
} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
