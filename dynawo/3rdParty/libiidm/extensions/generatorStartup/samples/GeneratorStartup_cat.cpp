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
 * @file GeneratorStartup_cat.cpp
 * @brief sample program replicating an iidm xml file using only GeneratorStartup extension
 */

#include <IIDM/extensions/generatorStartup/xml.h>

#include <iostream>
#include <fstream>

#include <IIDM/xml/import.h>
#include <IIDM/xml/export.h>

#include <IIDM/Network.h>


using std::cout;
using std::cerr;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;

using namespace IIDM::extensions::generator_startup::xml;

int main(int argc, char** argv) {
  if (argc < 2) {
    cerr << "usage: " << argv[0] << " <input xml>" << endl;
    return -1;
  }

  IIDM::xml::xml_parser parser;
  parser.register_extension<GeneratorStartupHandler>();

  Network extracted = parser.from_xml(argv[1], true);

  IIDM::xml::xml_formatter formatter;
  formatter.register_extension( &exportGeneratorStartup, GeneratorStartupHandler::uri(), "gs" );

  formatter.to_xml(extracted, cout);

  return 0;
}
