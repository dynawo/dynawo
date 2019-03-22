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
 * @file GeneratorEntsoeCategoryHandler.cpp
 * @brief Provides GeneratorEntsoeCategoryHandler definition
 */

#include <IIDM/extensions/generatorEntsoeCategory/xml/GeneratorEntsoeCategoryHandler.h>
#include <IIDM/extensions/GeneratorEntsoeCategory.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace generator_entsoe_category {
namespace xml {

std::string GeneratorEntsoeCategoryHandler::xsd_path() {
  return IIDM_EXT_GENERATORENTSOECATEGORY_XML_XSD_PATH + std::string("generatorEntsoeCategory.xsd");
}

GeneratorEntsoeCategoryHandler::elementName_type const GeneratorEntsoeCategoryHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/generator_entsoe_category/1_0"), "entsoeCategory"
);

GeneratorEntsoeCategory* GeneratorEntsoeCategoryHandler::do_make() {
  return GeneratorEntsoeCategoryBuilder()
    .code(boost::lexical_cast<int>(data()))
  .build().clone().release();
}

} // end of namespace IIDM::extensions::generator_entsoe_category::xml::
} // end of namespace IIDM::extensions::generator_entsoe_category::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
