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
 * @file xml/import/VoltageLevelHandler.cpp
 * @brief Provides VoltageLevelHandler definition
 */

#include <IIDM/xml/import/VoltageLevelHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

namespace xml {
namespace sax {
namespace parser {

template<>
Attributes::SearchedAttribute::operator IIDM::VoltageLevel::e_mode () const {
  if (!value) throw std::runtime_error("no value for attribute "+name);

  return (*value=="NODE_BREAKER") ? IIDM::VoltageLevel::node_breaker : IIDM::VoltageLevel::bus_breaker;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;

namespace IIDM {
namespace xml {

VoltageLevelHandler::VoltageLevelHandler(elementName_type const& root_element):
  parent_type(root_element),

  bus_handler(elementName_type(iidm_ns, "bus")),
  busbarsection_handler(elementName_type(iidm_ns, "busbarSection")),
  bus_switch_handler(elementName_type(iidm_ns, "switch")),
  node_switch_handler(elementName_type(iidm_ns, "switch")),

  danglingline_handler(elementName_type(iidm_ns, "danglingLine")),
  generator_handler(elementName_type(iidm_ns, "generator")),
  load_handler(elementName_type(iidm_ns, "load")),
  shuntcompensator_handler(elementName_type(iidm_ns, "shunt")),
  staticvarcompensator_handler(elementName_type(iidm_ns, "staticVarCompensator")),
  vscConverterStation_handler(elementName_type(iidm_ns, "vscConverterStation")),
  lccConverterStation_handler(elementName_type(iidm_ns, "lccConverterStation"))
{
  onStartElement( root_element+iidm_ns("nodeBreakerTopology"),
    lambda::bind(&VoltageLevelHandler::configure_nodeBreakerTopology, lambda::ref(*this), lambda_args::arg2 )
  );

  set_topology_part_handler(root_element+iidm_ns("busBreakerTopology/bus"), bus_handler, &VoltageLevelHandler::add_bus);
  set_topology_part_handler(root_element+iidm_ns("busBreakerTopology/switch"), bus_switch_handler, &VoltageLevelHandler::add_bus_switch);

  set_topology_part_handler(root_element+iidm_ns("nodeBreakerTopology/busbarSection"), busbarsection_handler, &VoltageLevelHandler::add_busbarsection);
  set_topology_part_handler(root_element+iidm_ns("nodeBreakerTopology/switch"), node_switch_handler, &VoltageLevelHandler::add_node_switch);

  set_connectable_handler(root_element+iidm_ns("danglingLine"), danglingline_handler);
  set_connectable_handler(root_element+iidm_ns("generator"), generator_handler);
  set_connectable_handler(root_element+iidm_ns("load"), load_handler);
  set_connectable_handler(root_element+iidm_ns("shunt"), shuntcompensator_handler);
  set_connectable_handler(root_element+iidm_ns("staticVarCompensator"), staticvarcompensator_handler);
  set_connectable_handler(root_element+iidm_ns("vscConverterStation"), vscConverterStation_handler);
  set_connectable_handler(root_element+iidm_ns("lccConverterStation"), lccConverterStation_handler);
}

template <typename H>
void VoltageLevelHandler::set_topology_part_handler(path_type const& path, H& handler, void (VoltageLevelHandler::*add_function)() ) {
  onElement(path, handler);
  handler.onStart( create_builded(*this) );
  handler.onEnd( lambda::bind(add_function, lambda::ref(*this)) );
}



void VoltageLevelHandler::add_bus() {
  add(bus_handler);
}

void VoltageLevelHandler::add_busbarsection() {
  add(busbarsection_handler);
}


void VoltageLevelHandler::add_bus_switch() {
  get().add(
    bus_switch_handler.build(),
    bus_switch_handler.at(IIDM::side_1)->bus_id(),
    bus_switch_handler.at(IIDM::side_2)->bus_id()
  );
}

void VoltageLevelHandler::add_node_switch() {
  get().add(
    node_switch_handler.build(),
    node_switch_handler.at(IIDM::side_1)->node(),
    node_switch_handler.at(IIDM::side_2)->node()
  );
}

void VoltageLevelHandler::configure(attributes_type const& attributes) {
  parent_type::configure(attributes);

  builder()
    .mode( attributes["topologyKind"] )
    .nominalV( attributes["nominalV"] )
    .node_count( static_cast<IIDM::node_type>(0) )//this 0 means it's a bus breaker voltage level. see IIDM::VoltageLevel
    .lowVoltageLimit( attributes["lowVoltageLimit"] )
    .highVoltageLimit( attributes["highVoltageLimit"] )
  ;
}

void VoltageLevelHandler::configure_nodeBreakerTopology(attributes_type const& attributes) {
  builder().node_count( attributes["nodeCount"] );
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
