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
 * @file xml/import/StaticVarCompensatorHandler.cpp
 * @brief Provides StaticVarCompensatorHandler definition
 */

#include <IIDM/xml/import/StaticVarCompensatorHandler.h>

namespace xml {
namespace sax {
namespace parser {

template<>
Attributes::SearchedAttribute::operator IIDM::StaticVarCompensator::e_regulation_mode () const {
  if (!value) throw std::runtime_error("no value for attribute "+name);

  if (*value=="VOLTAGE") return IIDM::StaticVarCompensator::regulation_voltage;
  if (*value=="REACTIVE_POWER") return IIDM::StaticVarCompensator::regulation_reactive_power;
  return IIDM::StaticVarCompensator::regulation_off;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

namespace IIDM {
namespace xml {

StaticVarCompensatorHandler::StaticVarCompensatorHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::StaticVarCompensatorBuilder, false, IIDM::side_1>(root_element)
{}

void StaticVarCompensatorHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::StaticVarCompensatorBuilder, false, IIDM::side_1>::configure(attributes);
  builder()
    .regulationMode( attributes["regulationMode"] )
    .bmin( attributes["bMin"] )
    .bmax( attributes["bMax"] )
    .voltageSetPoint( attributes["voltageSetPoint"] )
    .reactivePowerSetPoint( attributes["reactivePowerSetPoint"] )
    .p( attributes["p"] )
    .q( attributes["q"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
