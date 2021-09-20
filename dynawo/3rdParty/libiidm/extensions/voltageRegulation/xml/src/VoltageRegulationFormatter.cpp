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
 * @file VoltageRegulationFormatter.cpp
 * @brief Provides VoltageRegulationFormatter definition
 */

#include <IIDM/extensions/voltageRegulation/xml/VoltageRegulationFormatter.h>
#include <IIDM/extensions/voltageRegulation/VoltageRegulation.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace voltageregulation {
namespace xml {

using ::xml::sax::formatter::Element;
using ::xml::sax::formatter::AttributeList;

void exportVoltageRegulation(IIDM::Identifiable const& identifiable, Element& root, std::string const& xml_prefix) {
  VoltageRegulation const* ext = identifiable.findExtension<VoltageRegulation>();
  if (ext) {
    Element voltageRegulation = root.element( xml_prefix, "voltageRegulation",
                            AttributeList("voltageRegulatorOn", ext->voltageRegulatorOn())
                                          ("targetV", ext->optional_targetV())
    );
    if (ext->has_regulatingTerminal())      to_xml(voltageRegulation, xml_prefix, "terminalRef", ext->regulatingTerminal());
  }
}

void to_xml(::xml::sax::formatter::Element& root, std::string const& xml_prefix, std::string const& name, IIDM::TerminalReference const& ref) {
  if (ref.side==IIDM::side_end) {
    root.element( xml_prefix, name, AttributeList("id", ref.id) );
  } else {
    const char* side;
    switch(ref.side) {
      case IIDM::side_1: side = "ONE"; break;
      case IIDM::side_2: side = "TWO"; break;
      case IIDM::side_3: side = "THREE"; break;
      default: side="OTHER";
    }
    root.element( xml_prefix, name, AttributeList("id", ref.id)("side", side) );
  }
}

} // end of namespace IIDM::extensions::voltageregulation::xml::
} // end of namespace IIDM::extensions::voltageregulation::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
