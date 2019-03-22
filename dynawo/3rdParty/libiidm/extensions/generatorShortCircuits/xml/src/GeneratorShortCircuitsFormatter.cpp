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
 * @file GeneratorShortCircuitsFormatter.cpp
 * @brief Provides GeneratorShortCircuitsFormatter definition
 */

#include <IIDM/components/Identifiable.h>
#include <IIDM/extensions/generatorShortCircuits/GeneratorShortCircuits.h>
#include <string>

#include <xml/sax/formatter/Document.h>
#include "../include/IIDM/extensions/generatorShortCircuits/xml/GeneratorShortCircuitsFormatter.h"

namespace IIDM {
namespace extensions {
namespace generatorshortcircuits {
namespace xml {

void exportGeneratorShortCircuits(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  GeneratorShortCircuits const* ext = identifiable.findExtension<GeneratorShortCircuits>();
  if (ext) {
    root.empty_element(xml_prefix, "generatorShortCircuits",
      ::xml::sax::formatter::AttributeList
        ("transientReactance", ext->transientReactance())
        ("stepUpTransformerReactance", ext->stepUpTransformerReactance())
    );
  }
}

} // end of namespace IIDM::extensions::generatorshortcircuits::xml::
} // end of namespace IIDM::extensions::generatorshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
