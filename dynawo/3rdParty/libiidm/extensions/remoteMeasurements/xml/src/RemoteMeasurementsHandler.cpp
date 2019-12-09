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
 * @file RemoteMeasurementsHandler.cpp
 * @brief Provides RemoteMeasurementsHandler definition
 */

#include <IIDM/extensions/remoteMeasurements/xml/RemoteMeasurementsHandler.h>
#include <IIDM/extensions/RemoteMeasurements.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"
#include <iostream>

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace extensions {
namespace remotemeasurements {
namespace xml {

void RemoteMeasurementHandler::do_startElement(elementName_type const& element, attributes_type const& attributes)
{
  float value             = attributes["value"];
  float standardDeviation = attributes["standardDeviation"];
  bool valid              = attributes["valid"];
  bool masked             = attributes["masked"];
  bool critical           = attributes["critical"];
  remoteMeasurement = RemoteMeasurements::RemoteMeasurement(value , standardDeviation, valid, masked, critical);
}

void TapPositionHandler::do_startElement(elementName_type const& element, attributes_type const& attributes)
{
  tapPosition = boost::none;
  if(!attributes.has("position")) return;
  int position  = attributes["position"];

  tapPosition = RemoteMeasurements::TapPosition(position);
}


std::string RemoteMeasurementsHandler::xsd_path() {
  const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("remoteMeasurements.xsd");
}

RemoteMeasurementsHandler::elementName_type const& RemoteMeasurementsHandler::root() {
  static elementName_type const root(
    parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/remotemeasurements/1_0"), "remoteMeasurements"
  );
  return root;
}


RemoteMeasurementsHandler::RemoteMeasurementsHandler() :
  m_pHandler(), m_qHandler(), m_p1Handler(), m_q1Handler(), m_p2Handler(), m_q2Handler(),
  m_vHandler(), m_tapPositionHandler()
{
  onElement(root() + elementName_type(root().ns, "p"),            m_pHandler);
  onElement(root() + elementName_type(root().ns, "q"),            m_qHandler);
  onElement(root() + elementName_type(root().ns, "p1"),           m_p1Handler);
  onElement(root() + elementName_type(root().ns, "q1"),           m_q1Handler);
  onElement(root() + elementName_type(root().ns, "p2"),           m_p2Handler);
  onElement(root() + elementName_type(root().ns, "q2"),           m_q2Handler);
  onElement(root() + elementName_type(root().ns, "v"),            m_vHandler);
  onElement(root() + elementName_type(root().ns, "tapPosition"),  m_tapPositionHandler);
}


RemoteMeasurements* RemoteMeasurementsHandler::do_make()
{
  return RemoteMeasurementsBuilder()
    .p( m_pHandler.remoteMeasurement)
    .q( m_qHandler.remoteMeasurement)
    .p1(m_p1Handler.remoteMeasurement)
    .q1(m_q1Handler.remoteMeasurement)
    .p2(m_p2Handler.remoteMeasurement)
    .q2(m_q2Handler.remoteMeasurement)
    .v( m_vHandler.remoteMeasurement)
    .tapPosition(m_tapPositionHandler.tapPosition)
    .build().clone().release();
}



} // end of namespace IIDM::extensions::remotemeasurements::xml::
} // end of namespace IIDM::extensions::remotemeasurements::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
