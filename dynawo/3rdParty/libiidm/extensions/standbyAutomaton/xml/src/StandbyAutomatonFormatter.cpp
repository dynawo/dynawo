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
 * @file StandbyAutomatonFormatter.cpp
 * @brief Provides StandbyAutomatonFormatter definition
 */
 
#include <IIDM/extensions/standbyAutomaton/xml/StandbyAutomatonFormatter.h>

#include <IIDM/extensions/StandbyAutomaton.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace standbyautomaton {
namespace xml {

void exportStandbyAutomaton(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  StandbyAutomaton const* ext = identifiable.findExtension<StandbyAutomaton>();
  if (ext) {
    root.empty_element(xml_prefix, "standbyAutomaton",
      ::xml::sax::formatter::AttributeList
        ("b0", ext->b0())
        ("standby", ext->standBy())
        ("lowVoltageSetPoint", ext->lowVoltageSetPoint())
        ("highVoltageSetPoint", ext->highVoltageSetPoint())
        ("lowVoltageThreshold", ext->lowVoltageThreshold())
        ("highVoltageThreshold", ext->highVoltageThreshold())
    );
  }
}

} // end of namespace IIDM::extensions::standbyautomaton::xml::
} // end of namespace IIDM::extensions::standbyautomaton::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
