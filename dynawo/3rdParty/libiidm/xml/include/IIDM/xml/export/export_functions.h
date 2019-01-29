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
 * @file xml/export/export_functions.h
 * @brief export methods used by xml_exporter
 */

#ifndef LIBIIDM_XML_EXPORT_GUARD_EXPORT_FUNCTIONS_H
#define LIBIIDM_XML_EXPORT_GUARD_EXPORT_FUNCTIONS_H

#include <string>

#include <IIDM/forward.h>
#include <IIDM/xml/export.h>

namespace xml {
namespace sax {
namespace formatter {
class Element;
class Document;
} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
namespace xml {

//returns the generated element.
::xml::sax::formatter::Element to_xml(::xml::sax::formatter::Document& document, IIDM::Network const& network);

void to_xml(::xml::sax::formatter::Element& root, IIDM::Line const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::TieLine const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::HvdcLine const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::Substation const&);

void to_xml(::xml::sax::formatter::Element& root, IIDM::VoltageLevel const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::Bus const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::BusBarSection const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::Switch const&);

void to_xml(::xml::sax::formatter::Element& root, IIDM::Load const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::ShuntCompensator const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::DanglingLine const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::StaticVarCompensator const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::Generator const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::VscConverterStation const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::LccConverterStation const&);

void to_xml(::xml::sax::formatter::Element& root, IIDM::Transformer2Windings const&);
void to_xml(::xml::sax::formatter::Element& root, IIDM::Transformer3Windings const&);


void to_xml(::xml::sax::formatter::Element& root, std::string const& name, IIDM::CurrentLimits const&, std::string const& xml_prefix="");

void to_xml(::xml::sax::formatter::Element& root, std::string const& name, IIDM::TerminalReference const&);

void to_xml(::xml::sax::formatter::Element& root, std::string const& name, IIDM::MinMaxReactiveLimits const&);
void to_xml(::xml::sax::formatter::Element& root, std::string const& name, IIDM::ReactiveCapabilityCurve const&);

void to_xml(::xml::sax::formatter::Element& root, std::string const& name, IIDM::RatioTapChanger const&);
void to_xml(::xml::sax::formatter::Element& root, std::string const& name, IIDM::PhaseTapChanger const&);

} // end of namespace IIDM::xml::
} // end of namespace IIDM::


#endif
