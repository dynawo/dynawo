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
 * @file IIDM/extensions/voltageRegulation/xml/VoltageRegulationFormatter.h
 * @brief Provides VoltageRegulationFormatter interface, used for input
 */

#ifndef LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_XML_GUARD_VOLTAGEREGULATION_FORMATTER_H
#define LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_XML_GUARD_VOLTAGEREGULATION_FORMATTER_H

#include <string>
#include <IIDM/forward.h>

namespace xml {
namespace sax {
namespace formatter {
class Element;
} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
class Identifiable;

namespace extensions {
namespace voltageregulation {
namespace xml {

void exportVoltageRegulation(IIDM::Identifiable const&, ::xml::sax::formatter::Element& root, std::string const& xml_prefix);

void to_xml(::xml::sax::formatter::Element& root, std::string const& xml_prefix, std::string const& name, IIDM::TerminalReference const& ref);

} // end of namespace IIDM::extensions::voltageregulation::xml::
} // end of namespace IIDM::extensions::voltageregulation::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
