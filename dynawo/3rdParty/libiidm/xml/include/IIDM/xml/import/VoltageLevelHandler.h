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
 * @file xml/import/VoltageLevelHandler.h
 * @brief Provides VoltageLevelHandler interface
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_VOLTAGELEVELHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_VOLTAGELEVELHANDLER_H

#include <IIDM/xml/import/ContainerHandler.h>

#include <IIDM/xml/import/BusHandler.h>
#include <IIDM/xml/import/BusBarSectionHandler.h>
#include <IIDM/xml/import/SwitchHandler.h>

#include <IIDM/xml/import/BatteryHandler.h>
#include <IIDM/xml/import/LoadHandler.h>
#include <IIDM/xml/import/GeneratorHandler.h>
#include <IIDM/xml/import/DanglingLineHandler.h>
#include <IIDM/xml/import/ShuntCompensatorHandler.h>
#include <IIDM/xml/import/StaticVarCompensatorHandler.h>
#include <IIDM/xml/import/VscConverterStationHandler.h>
#include <IIDM/xml/import/LccConverterStationHandler.h>

#include <IIDM/builders/VoltageLevelBuilder.h>
#include <IIDM/components/VoltageLevel.h>

namespace IIDM {
namespace xml {

class VoltageLevelHandler: public ContainerHandler<IIDM::builders::VoltageLevelBuilder> {
private:
  typedef ContainerHandler<IIDM::builders::VoltageLevelBuilder> parent_type;

public:
  VoltageLevelHandler(elementName_type const& root_element);

private:
  BusHandler bus_handler;
  BusBarSectionHandler busbarsection_handler;
  SwitchHandler bus_switch_handler, node_switch_handler;

  BatteryHandler battery_handler;
  DanglingLineHandler danglingline_handler;
  GeneratorHandler generator_handler;
  LoadHandler load_handler;
  ShuntCompensatorHandler shuntcompensator_handler;
  StaticVarCompensatorHandler staticvarcompensator_handler;
  VscConverterStationHandler vscConverterStation_handler;
  LccConverterStationHandler lccConverterStation_handler;

  template <typename H>
  void set_topology_part_handler(path_type const& path, H& handler, void (VoltageLevelHandler::*add_function)() );

private:
  void add_bus();
  void add_busbarsection();

  void add_bus_switch();

  void add_node_switch();

  void configure_nodeBreakerTopology(attributes_type const& attributes);

protected:
  void configure(attributes_type const& attributes) IIDM_OVERRIDE;

};


} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
