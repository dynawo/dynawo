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
 * @file VoltageLevelShortCircuitsFormatter.cpp
 * @brief Provides VoltageLevelShortCircuitsFormatter definition
 */

#include <IIDM/extensions/voltageLevelShortCircuits/xml/VoltageLevelShortCircuitsFormatter.h>
#include <IIDM/extensions/voltageLevelShortCircuits/VoltageLevelShortCircuits.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace voltagelevelshortcircuits {
namespace xml {

void exportVoltageLevelShortCircuits(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  VoltageLevelShortCircuits const* ext = identifiable.findExtension<VoltageLevelShortCircuits>();
  if (ext) {
    root.empty_element(xml_prefix, "voltageLevelShortCircuits",
      ::xml::sax::formatter::AttributeList
        ("minShortCircuitsCurrent", ext->minShortCircuitsCurrent())
        ("maxShortCircuitsCurrent", ext->maxShortCircuitsCurrent())
    );
  }
}

} // end of namespace IIDM::extensions::voltagelevelshortcircuits::xml::
} // end of namespace IIDM::extensions::voltagelevelshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
