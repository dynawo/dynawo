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
 * @file CurrentLimitsPerSeason1.cpp
 * @brief sample program creating a network with the CurrentLimitsPerSeason extension
 */

#include <IIDM/extensions/CurrentLimitsPerSeason.h>
#include <IIDM/extensions/currentLimitsPerSeason/xml.h>

#include <IIDM/xml/export.h>

#include <IIDM/Network.h>
#include <IIDM/builders.h>

#include <iostream>
#include <fstream>
#include <string>

using std::cout;
using std::cerr;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;

using namespace IIDM::extensions::currentlimitsperseason;
using namespace IIDM::extensions::currentlimitsperseason::xml;

int main(int argc, char** argv) {
  //creating the network
  SubstationBuilder substation_builder = SubstationBuilder().country("FR").tso(std::string("RTE"));
  VoltageLevelBuilder bus_voltagelevel_builder = VoltageLevelBuilder().mode(VoltageLevel::bus_breaker).nominalV(50);
  BusBuilder bus_builder = BusBuilder().v(0).angle(10);
  LoadBuilder load_builder = LoadBuilder().p0(0).q0(0).p(0).q(0).p(2);

  Network network = NetworkBuilder().sourceFormat("handcrafted").caseDate("2000-01-01T00:00:00").forecastDistance(0).build("network");

  network.add( substation_builder.build("station") )
    .add( bus_voltagelevel_builder.build("VL") )
      .add( bus_builder.build("loads") )

      .add( load_builder.type(Load::type_undefined ).build("load1"), at("loads", connected) )
      .add( load_builder.type(Load::type_auxiliary ).build("load2"), at("loads", connected) )
      .add( load_builder.type(Load::type_fictitious).build("load3"), at("loads", connected) )
  ;

  Load& load = network
    .substations().get("station")
    .voltageLevels().get("VL")
    .loads().get("load1");

  load.setExtension(
    CurrentLimitsPerSeason()
      .set(
        CurrentLimitsPerSeason::season("summer", true)
          .set(IIDM::side_1, IIDM::CurrentLimits(boost::none).add("S_CL1", 100.0, 400).add("S_CL2", 200.0, 100))
      )
      .set(
        CurrentLimitsPerSeason::season("winter", IIDM::CurrentLimits(7).add("W_CL1", 100.0, 400).add("W_CL2", 200.0, 100))
      )
      .set(
        CurrentLimitsPerSeason::season("base")
          .set(IIDM::side_1, IIDM::CurrentLimits(1).add("CL1_1", 100.0, 400).add("CL1_2", 200.0, 100))
          .set(IIDM::side_2, IIDM::CurrentLimits(2).add("CL2_1", 100.0, 400).add("CL2_2", 200.0, 100))
          .set(IIDM::side_3, IIDM::CurrentLimits(3).add("CL3_1", 100.0, 400).add("CL3_2", 200.0, 100))
      )
  );

  //exporting the network into cout or each of the given files

  IIDM::xml::xml_formatter formatter;
  formatter.register_extension( &exportCurrentLimitsPerSeason, CurrentLimitsPerSeasonHandler::uri(), "ext_as" );

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
