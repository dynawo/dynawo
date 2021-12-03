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
 * @file ActiveSeasonHandler.cpp
 * @brief Provides ActiveSeasonHandler definition
 */

#include <IIDM/extensions/activeSeason/xml/ActiveSeasonHandler.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace activeseason {
namespace xml {

const std::string& ActiveSeasonHandler::xsd_path() {
  static const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH") + std::string("activeSeason.xsd");
  return xsdPath;
}

ActiveSeasonHandler::elementName_type const& ActiveSeasonHandler::root() {
  static elementName_type const root(
    parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/active-season/1_0"), "activeSeason"
  );
  return root;
}

ActiveSeason* ActiveSeasonHandler::do_make() {
  return new ActiveSeason(data());
}

} // end of namespace IIDM::extensions::activeseason::xml::
} // end of namespace IIDM::extensions::activeseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
