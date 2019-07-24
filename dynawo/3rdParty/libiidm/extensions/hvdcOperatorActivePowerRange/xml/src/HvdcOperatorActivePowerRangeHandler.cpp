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
 * @file HvdcOperatorActivePowerRangeHandler.cpp
 * @brief Provides HvdcOperatorActivePowerRangeHandler definition
 */

#include <IIDM/extensions/hvdcOperatorActivePowerRange/xml/HvdcOperatorActivePowerRangeHandler.h>
#include <IIDM/extensions/HvdcOperatorActivePowerRange.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace hvdcoperatoractivepowerrange {
namespace xml {

std::string HvdcOperatorActivePowerRangeHandler::xsd_path() {
  const std::string xsdPath = getEnvVar("IIDM_EXT_HVDCOPERATORACTIVEPOWERRANGE_XML_XSD_PATH");
  return xsdPath + std::string("hvdcOperatorActivePowerRange.xsd");
}

HvdcOperatorActivePowerRangeHandler::elementName_type const HvdcOperatorActivePowerRangeHandler::root(
        parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/hvdc_operator_active_power_range/1_0"), "hvdcOperatorActivePowerRange"
);

HvdcOperatorActivePowerRange* HvdcOperatorActivePowerRangeHandler::do_make() {
    return HvdcOperatorActivePowerRangeBuilder()
            .oprFromCS1toCS2(attribute("fromCS1toCS2"))
            .oprFromCS2toCS1(attribute("fromCS2toCS1"))
            .build().clone().release();
}

} // end of namespace IIDM::extensions::hvdcoperatoractivepowerrange::xml::
} // end of namespace IIDM::extensions::hvdcoperatoractivepowerrange::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
