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
 * @file ActivePowerControlHandler.cpp
 * @brief Provides ActivePowerControlHandler definition
 */

#include <IIDM/extensions/activePowerControl/xml/ActivePowerControlHandler.h>
#include <IIDM/extensions/ActivePowerControl.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace activepowercontrol {
namespace xml {

std::string ActivePowerControlHandler::xsd_path() {
  return IIDM_EXT_ACTIVEPOWERCONTROL_XML_XSD_PATH + std::string("activePowerControl.xsd");
}

ActivePowerControlHandler::elementName_type const ActivePowerControlHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/active_power_control/1_0"), "activePowerControl"
);

ActivePowerControl* ActivePowerControlHandler::do_make() {
  return ActivePowerControlBuilder()
    .participate( attribute("participate") )
    .droop( attribute("droop") )
    .build().clone().release();
}

} // end of namespace IIDM::extensions::activepowercontrol::xml::
} // end of namespace IIDM::extensions::activepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
