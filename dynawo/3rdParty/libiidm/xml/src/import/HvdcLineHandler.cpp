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
 * @file xml/import/HvdcLineHandler.cpp
 * @brief provides HvdcLineHandler definitions
 */

#include <IIDM/xml/import/HvdcLineHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"

#include <IIDM/builders/HvdcLineBuilder.h>

namespace xml {
namespace sax {
namespace parser {

template<>
Attributes::SearchedAttribute::operator IIDM::HvdcLine::mode_enum () const {
  if (!value) throw std::runtime_error("no value for attribute "+name);

  return (*value == "SIDE_1_RECTIFIER_SIDE_2_INVERTER")?
    IIDM::HvdcLine::mode_RectifierInverter:
    IIDM::HvdcLine::mode_InverterRectifier;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
namespace xml {

HvdcLineHandler::HvdcLineHandler(elementName_type const& root_element):
  IdentifiableHandler<IIDM::builders::HvdcLineBuilder>(root_element)
{}

void HvdcLineHandler::configure(attributes_type const& attributes) {
  IdentifiableHandler<IIDM::builders::HvdcLineBuilder>::configure(attributes);
  builder()
    .r( attributes["r"] )
    .nominalV( attributes["nominalV"] )
    .activePowerSetpoint( attributes["activePowerSetpoint"] )
    .maxP( attributes["maxP"] )
    .convertersMode( attributes["convertersMode"] )
    .converterStation1( attributes["converterStation1"] )
    .converterStation2( attributes["converterStation2"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
