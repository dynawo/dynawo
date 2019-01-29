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
 * @file LoadDetailHandler.cpp
 * @brief Provides LoadDetailHandler definition
 */
 
#include <IIDM/extensions/loadDetail/xml/LoadDetailHandler.h>
#include <IIDM/extensions/LoadDetail.h>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace load_detail {
namespace xml {

std::string LoadDetailHandler::xsd_path() {
  return IIDM_EXT_LOADDETAIL_XML_XSD_PATH + std::string("loadDetail.xsd");
}

LoadDetailHandler::elementName_type const LoadDetailHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/load_detail/1_0"), "detail"
);

LoadDetail* LoadDetailHandler::do_make() {
  boost::optional<float> subLoad1ActivePower = attribute("subLoad1ActivePower");
  boost::optional<float> fixedActivePower = attribute("fixedActivePower");
  if (!subLoad1ActivePower && !fixedActivePower) {
    throw std::runtime_error("subLoad1ActivePower|fixedActivePower not found");
  }
  boost::optional<float> subLoad1ReactivePower = attribute("subLoad1ReactivePower");
  boost::optional<float> fixedReactivePower = attribute("fixedReactivePower");
  if (!subLoad1ReactivePower && !fixedReactivePower) {
    throw std::runtime_error("subLoad1ReactivePower|fixedReactivePower not found");
  }
  boost::optional<float> subLoad2ActivePower = attribute("subLoad2ActivePower");
  boost::optional<float> variableActivePower = attribute("variableActivePower");
  if (!subLoad2ActivePower && !variableActivePower) {
    throw std::runtime_error("subLoad2ActivePower|variableActivePower not found");
  }
  boost::optional<float> subLoad2ReactivePower = attribute("subLoad2ReactivePower");
  boost::optional<float> variableReactivePower = attribute("variableReactivePower");
  if (!subLoad2ReactivePower && !variableReactivePower) {
    throw std::runtime_error("subLoad2ReactivePower|variableReactivePower not found");
  }

  return LoadDetailBuilder()
    .fixedActivePower(fixedActivePower ? *fixedActivePower : *subLoad1ActivePower)
    .fixedReactivePower(fixedReactivePower ? *fixedReactivePower : *subLoad1ReactivePower)
    .variableActivePower(variableActivePower ? *variableActivePower : *subLoad2ActivePower)
    .variableReactivePower(variableReactivePower ? *variableReactivePower : *subLoad2ReactivePower)
  .build().clone().release();
}

} // end of namespace IIDM::extensions::load_detail::xml::
} // end of namespace IIDM::extensions::load_detail::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
