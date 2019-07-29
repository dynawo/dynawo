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
 * @file HvdcAngleDroopActivePowerControlHandler.cpp
 * @brief Provides HvdcAngleDroopActivePowerControlHandler definition
 */

#include <IIDM/extensions/hvdcAngleDroopActivePowerControl/xml/HvdcAngleDroopActivePowerControlHandler.h>
#include <IIDM/extensions/HvdcAngleDroopActivePowerControl.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace hvdcangledroopactivepowercontrol {
namespace xml {

std::string HvdcAngleDroopActivePowerControlHandler::xsd_path() {
  const std::string xsdPath = getEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("hvdcAngleDroopActivePowerControl.xsd");
}

HvdcAngleDroopActivePowerControlHandler::elementName_type const HvdcAngleDroopActivePowerControlHandler::root(
        parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/hvdc_angle_droop_active_power_control/1_0"), "hvdcAngleDroopActivePowerControl"
);

HvdcAngleDroopActivePowerControl* HvdcAngleDroopActivePowerControlHandler::do_make() {
    return HvdcAngleDroopActivePowerControlBuilder()
            .p0(attribute("p0"))
            .droop(attribute("droop"))
            .enabled(attribute("enabled"))
            .build().clone().release();
}

} // end of namespace IIDM::extensions::hvdcangledroopactivepowercontrol::xml::
} // end of namespace IIDM::extensions::hvdcangledroopactivepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
