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
 * @file StateOfChargeHandler.cpp
 * @brief Provides StateOfChargeHandler definition
 */

#include <IIDM/extensions/stateOfCharge/xml/StateOfChargeHandler.h>
#include <IIDM/extensions/StateOfCharge.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace stateofcharge {
namespace xml {

const std::string & StateOfChargeHandler::xsd_path() {
  const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("stateOfCharge.xsd");
}

StateOfChargeHandler::elementName_type const StateOfChargeHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/state_of_charge/1_0"), "stateOfCharge"
);

StateOfCharge* StateOfChargeHandler::do_make() {
  return StateOfChargeBuilder()
    .min( attribute("min") )
    .max( attribute("max") )
    .current( attribute("current") )
    .storageCapacity( attribute("storageCapacity") )
  .build().clone().release();
}

} // end of namespace IIDM::extensions::stateofcharge::xml::
} // end of namespace IIDM::extensions::stateofcharge::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
