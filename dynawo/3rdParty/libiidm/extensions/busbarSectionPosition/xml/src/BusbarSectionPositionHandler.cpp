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
 * @file BusbarSectionPositionHandler.cpp
 * @brief Provides BusbarSectionPositionHandler definition
 */

#include <IIDM/extensions/busbarSectionPosition/xml/BusbarSectionPositionHandler.h>
#include <IIDM/extensions/BusbarSectionPosition.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace busbarsection_position {
namespace xml {

const std::string& BusbarSectionPositionHandler::xsd_path() {
  static const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH") + std::string("busbarSectionPosition.xsd");
  return xsdPath;
}

BusbarSectionPositionHandler::elementName_type const& BusbarSectionPositionHandler::root() {
  static elementName_type const root(
    parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/busbarsectionposition/1_0"), "busbarSectionPosition"
  );
  return root;
}

BusbarSectionPosition* BusbarSectionPositionHandler::do_make() {
  return BusbarSectionPositionBuilder()
    .busbarIndex( attribute("busbarIndex"))
    .sectionIndex( attribute("sectionIndex"))
  .build().clone().release();
}

} // end of namespace IIDM::extensions::busbarsection_position::xml::
} // end of namespace IIDM::extensions::busbarsection_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
