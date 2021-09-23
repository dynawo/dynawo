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
 * @file VoltageRegulationHandler.cpp
 * @brief Provides VoltageRegulationHandler definition
 */

#include <IIDM/xml/import/iidm_namespace.h>
#include <IIDM/extensions/voltageRegulation/xml/VoltageRegulationHandler.h>
#include <IIDM/extensions/VoltageRegulation.h>

#include "internals/config.h"
#include "internals/import/TerminalReferenceHandler.h"

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>


namespace parser = ::xml::sax::parser;
namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;

namespace IIDM {
namespace extensions {
namespace voltageregulation {
namespace xml {

const std::string & VoltageRegulationHandler::xsd_path() {
  static std::string XSD_PATH = IIDM_EXT_VOLTAGEREGULATION_XML_XSD_PATH + std::string("voltageRegulation.xsd");
  return XSD_PATH;
}

VoltageRegulationHandler::VoltageRegulationHandler() {
  builder = VoltageRegulationBuilder();
  onStartElement(
      root,
      lambda::bind(&VoltageRegulationHandler::configure, lambda::ref(*this), lambda_args::arg2)
  );
  onStartElement(
      root + elementName_type(root.ns, "terminalRef"),
      lambda::bind(&VoltageRegulationHandler::set_regulatingTerminal, lambda::ref(*this), lambda_args::arg2 )
  );

}

void VoltageRegulationHandler::set_regulatingTerminal(attributes_type const& attributes) {
  builder.regulatingTerminal( IIDM::xml::make_terminalReference(attributes) );
}


VoltageRegulationHandler::elementName_type const VoltageRegulationHandler::root(
  parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/voltageregulation/1_0"), "voltageRegulation"
);

void VoltageRegulationHandler::configure(attributes_type const& attributes) {
  boost::optional<double> targetV = attributes["targetV"].as< boost::optional<double> >();
  bool voltageRegulatorOn = attributes["voltageRegulatorOn"];
  if (voltageRegulatorOn) {
    if (!targetV || *targetV <= 0) {
        throw std::runtime_error("voltage setpoint should be > 0 when voltage regulator is on");
    }
  }

  builder.voltageRegulatorOn(voltageRegulatorOn)
    .targetV(targetV);
}

VoltageRegulation* VoltageRegulationHandler::do_make() {
  return builder.build().clone().release();
}

} // end of namespace IIDM::extensions::voltageregulation::xml::
} // end of namespace IIDM::extensions::voltageregulation::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
