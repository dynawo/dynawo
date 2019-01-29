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
 * @file xml/import/NetworkHandler.cpp
 * @brief Provides NetworkHandler definition
 */

#include <IIDM/xml/import/NetworkHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include <IIDM/components/Substation.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator.hpp>
#include <boost/phoenix/bind.hpp>

#include <IIDM/builders/NetworkBuilder.h>

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;

namespace IIDM {
namespace xml {

namespace {

template <typename Handler>//Handler is either LineHandler or TieLineHandler
void add_connectable(boost::optional<IIDM::Network> & network, Handler const& handler) {
  network->add( handler.build(), handler.at(IIDM::side_1), handler.at(IIDM::side_2) );
}

} // end of anonymous namespace



NetworkHandler::NetworkHandler(elementName_type const& root_element):
  substation_handler(elementName_type(iidm_ns, "substation")),
  line_handler(elementName_type(iidm_ns, "line")),
  tieline_handler(elementName_type(iidm_ns, "tieLine")),
  hvdcline_handler(elementName_type(iidm_ns, "hvdcLine"))
{
  //we can create the actual IIDM::Network as soon as startElement(<root_element>);
  onStartElement( root_element, lambda::bind(&NetworkHandler::create, lambda::ref(*this), lambda_args::arg2 ) );

  onElement(root_element+iidm_ns("substation"), substation_handler);
  substation_handler.onEnd( lambda::bind(&NetworkHandler::add_substation, lambda::ref(*this)) );
  
  set_connectable_handler(root_element+iidm_ns("line"), line_handler);
  set_connectable_handler(root_element+iidm_ns("tieLine"), tieline_handler);
  
  onElement(root_element+iidm_ns("hvdcLine"), hvdcline_handler);
  hvdcline_handler.onEnd( lambda::bind(&NetworkHandler::add_hvdcline, lambda::ref(*this)) );
 }

void NetworkHandler::create(attributes_type const& attributes) {
  m_network = IIDM::builders::NetworkBuilder()
    .sourceFormat( attributes["sourceFormat"] )
    .caseDate( attributes["caseDate"] )
    .forecastDistance( attributes["forecastDistance"] )
  .build( attributes["id"].as_string() );
}

void NetworkHandler::add_substation() {
  m_network->add( substation_handler.get() );
}


void NetworkHandler::add_hvdcline() {
  m_network->add( hvdcline_handler.build() );
}

template <typename Handler>//Line_Handler is either LineHandler or TieLineHandler
void NetworkHandler::set_connectable_handler(path_type const& path, Handler& handler) {
  this->onElement(path, handler);
  handler.onEnd( lambda::bind(&add_connectable<Handler>, lambda::ref(m_network), lambda::ref(handler)) );
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
