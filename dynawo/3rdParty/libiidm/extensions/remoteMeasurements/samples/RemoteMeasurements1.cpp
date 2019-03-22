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
 * @file RemoteMeasurements1.cpp
 * @brief sample program creating a network with the RemoteMeasurements extension
 */

#include <IIDM/xml/export.h>

#include <IIDM/Network.h>
#include <IIDM/builders.h>

#include <iostream>
#include <fstream>
#include <string>

#include <IIDM/extensions/RemoteMeasurements.h>
#include <IIDM/extensions/remoteMeasurements/xml.h>

using std::cout;
using std::cerr;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;

using namespace IIDM::extensions::remotemeasurements;
using namespace IIDM::extensions::remotemeasurements::xml;


int main(int argc, char** argv) {
  //creating the network
  SubstationBuilder substation_builder = SubstationBuilder().country("FR").tso("RTE");
  RemoteMeasurementsBuilder remotemeasurements_builder = RemoteMeasurementsBuilder();

  Network network = NetworkBuilder().sourceFormat("handcrafted").caseDate("2000-01-01T00:00:00").forecastDistance(0).build("network");

  IIDM::xml::xml_formatter formatter;
  formatter.register_extension( &exportRemoteMeasurements, RemoteMeasurementsHandler::uri(), "ext_tm" );

  if (argc == 1) {
    formatter.to_xml(network, cout);
  } else {
    for (int i = 1; i < argc; ++i) {
      std::ofstream output(argv[i]);
      formatter.to_xml(network, output);
    }
  }

  return 0;
}
