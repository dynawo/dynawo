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
 * @file GeneratorEntsoeCategoryFormatter.cpp
 * @brief Provides GeneratorEntsoeCategoryFormatter definition
 */
 
#include <IIDM/extensions/generatorEntsoeCategory/xml/GeneratorEntsoeCategoryFormatter.h>
#include <IIDM/extensions/generatorEntsoeCategory/GeneratorEntsoeCategory.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace generator_entsoe_category {
namespace xml {

void exportGeneratorEntsoeCategory(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  GeneratorEntsoeCategory const* ext = identifiable.findExtension<GeneratorEntsoeCategory>();
  if (ext) {
    root.simple_element(xml_prefix, "entsoeCategory", ext->code());
  }
}

} // end of namespace IIDM::extensions::generator_entsoe_category::xml::
} // end of namespace IIDM::extensions::generator_entsoe_category::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
