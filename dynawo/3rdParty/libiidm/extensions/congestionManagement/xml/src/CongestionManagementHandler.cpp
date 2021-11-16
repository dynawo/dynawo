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
 * @file CongestionManagementHandler.cpp
 * @brief Provides CongestionManagementHandler definition
 */

#include <IIDM/extensions/congestionManagement/xml/CongestionManagementHandler.h>
#include <IIDM/extensions/CongestionManagement.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace congestion_management {
namespace xml {

std::string CongestionManagementHandler::xsd_path() {
  const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("congestionManagement.xsd");
}

CongestionManagementHandler::elementName_type const CongestionManagementHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/congestion_management/1_0"), "congestionManagement"
);

CongestionManagement* CongestionManagementHandler::do_make() {
  return CongestionManagementBuilder()
    .enabled(attribute("enabled"))
  .build().clone().release();
}

} // end of namespace IIDM::extensions::congestion_management::xml::
} // end of namespace IIDM::extensions::congestion_management::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
