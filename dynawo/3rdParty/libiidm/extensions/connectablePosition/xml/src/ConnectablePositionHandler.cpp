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
 * @file ConnectablePositionHandler.cpp
 * @brief Provides ConnectablePositionHandler definition
 */

#include <IIDM/extensions/connectablePosition/xml/ConnectablePositionHandler.h>
#include <IIDM/extensions/ConnectablePosition.h>

#include <IIDM/xml/ExecUtils.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "internals/config.h"

namespace parser = ::xml::sax::parser;
namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;

namespace IIDM {
namespace extensions {
namespace connectable_position {
namespace xml {

void FeederHandler::do_startElement(elementName_type const& /*name*/, attributes_type const& attributes) {
    std::string feederName = attributes["name"].as_string();
    int order = attributes["order"];
    std::string directionStr = attributes["direction"].as_string();
    ConnectablePosition::Feeder::Direction direction;
    if (directionStr == "TOP") {
        direction = ConnectablePosition::Feeder::TOP;
    } else if (directionStr == "BOTTOM") {
        direction = ConnectablePosition::Feeder::BOTTOM;
    } else if (directionStr == "UNDEFINED") {
        direction = ConnectablePosition::Feeder::UNDEFINED;
    } else {
        throw std::runtime_error("bad direction value " + directionStr);
    }
    feeder = ConnectablePosition::Feeder(feederName, order, direction);
}

std::string ConnectablePositionHandler::xsd_path() {
  const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("connectablePosition.xsd");
}

ConnectablePositionHandler::elementName_type const& ConnectablePositionHandler::root() {
  static elementName_type const root(
    parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/connectable_position/1_0"), "position"
  );
  return root;
}

ConnectablePositionHandler::ConnectablePositionHandler()
        : m_feederHandler(),
          m_feeder1Handler(),
          m_feeder2Handler(),
          m_feeder3Handler() {
    onElement(root() + elementName_type(root().ns, "feeder"), m_feederHandler);
    onElement(root() + elementName_type(root().ns, "feeder1"), m_feeder1Handler);
    onElement(root() + elementName_type(root().ns, "feeder2"), m_feeder2Handler);
    onElement(root() + elementName_type(root().ns, "feeder3"), m_feeder3Handler);
}

ConnectablePosition* ConnectablePositionHandler::do_make() {
  return ConnectablePositionBuilder()
    .feeder(m_feederHandler.feeder)
    .feeder1(m_feeder1Handler.feeder)
    .feeder2(m_feeder2Handler.feeder)
    .feeder3(m_feeder3Handler.feeder)
  .build().clone().release();
}

} // end of namespace IIDM::extensions::connectable_position::xml::
} // end of namespace IIDM::extensions::connectable_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
