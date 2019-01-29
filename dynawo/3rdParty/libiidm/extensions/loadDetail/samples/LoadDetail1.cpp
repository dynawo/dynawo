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
 * @file LoadDetail1.cpp
 * @brief sample program creating a network with the LoadDetail extension
 */

#include <IIDM/extensions/LoadDetail.h>
#include <IIDM/extensions/loadDetail/xml.h>

#include <IIDM/xml/export.h>

#include <IIDM/Network.h>
#include <IIDM/builders.h>

#include <iostream>
#include <fstream>
#include <string>

using std::cout;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;

using namespace IIDM::extensions::load_detail;
using namespace IIDM::extensions::load_detail::xml;

int main(int argc, char** argv) {
  //creating the network
  SubstationBuilder substation_builder = SubstationBuilder().country("FR").tso("RTE");
  VoltageLevelBuilder bus_voltagelevel_builder = VoltageLevelBuilder().mode(VoltageLevel::bus_breaker).nominalV(50);
  BusBuilder bus_builder = BusBuilder().v(0).angle(10);
  LoadBuilder load_builder = LoadBuilder().p0(10).q0(5).p(0).q(0).p(2);

  Network network = NetworkBuilder().sourceFormat("handcrafted").caseDate("2000-01-01T00:00:00").forecastDistance(0).build("network");

  network.add( substation_builder.build("station") )
    .add( bus_voltagelevel_builder.build("VL") )
      .add( bus_builder.build("loads") )
      .add( load_builder.type(Load::type_undefined ).build("load1"), at("loads", connected) )
  ;
  
  Load& load = network
    .substations().get("station")
    .voltageLevels().get("VL")
    .loads().get("load1");
    
  load.setExtension(LoadDetailBuilder().fixedActivePower(3.0)
                                       .fixedReactivePower(1.5)
                                       .variableActivePower(4.2)
                                       .variableReactivePower(2.1)
                                       .build());

  //exporting the network into cout or each of the given files
  
  IIDM::xml::xml_formatter formatter;
  formatter.register_extension( &exportLoadDetail, LoadDetailHandler::uri(), "ld" );

  if (argc == 1) {
    formatter.to_xml(network, cout);
  } else {
    for (int i = 1; i < argc; ++i) {
      std::ofstream output(argv[i]);
      formatter.to_xml(network, output);
    }
    cout << "done." << endl;
  }

  return 0;
}
