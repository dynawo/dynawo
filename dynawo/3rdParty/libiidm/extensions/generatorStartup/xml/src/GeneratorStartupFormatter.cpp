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
 * @file GeneratorStartupFormatter.cpp
 * @brief Provides GeneratorStartupFormatter definition
 */

#include <IIDM/extensions/generatorStartup/xml/GeneratorStartupFormatter.h>
#include <IIDM/extensions/generatorStartup/GeneratorStartup.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace generator_startup {
namespace xml {

void exportGeneratorStartup(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  GeneratorStartup const* ext = identifiable.findExtension<GeneratorStartup>();
  if (ext) {
    root.empty_element(xml_prefix, "startup",
      ::xml::sax::formatter::AttributeList("predefinedActivePowerSetpoint", ext->predefinedActivePowerSetpoint())
                                          ("marginalCost", ext->marginalCost())
                                          ("plannedOutageRate", ext->plannedOutageRate())
                                          ("forcedOutageRate", ext->forcedOutageRate())
    );
  }
}

} // end of namespace IIDM::extensions::generator_startup::xml::
} // end of namespace IIDM::extensions::generator_startup::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
