//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYDXmlImporter.cpp
 * @brief Dynamic models collection XML importer : implementation file
 *
 */

#include <fstream>

#include <xml/sax/parser/ParserException.h>

#include "DYNMacrosMessage.h"

#include "DYDDynamicModelsCollectionFactory.h"
#include "DYDXmlHandler.h"
#include "DYDXmlImporter.h"
#include "DYNExecUtils.h"

using std::string;
using std::vector;
using boost::shared_ptr;

namespace parser = xml::sax::parser;

using parameters::ParametersSetCollection;

namespace dynamicdata {

shared_ptr<DynamicModelsCollection>
XmlImporter::importFromDydFiles(const vector<string>& fileNames) const {
  XmlHandler dydHandler;
  xml::sax::parser::ParserFactory parser_factory;
  xml::sax::parser::ParserPtr parser = parser_factory.createParser();
  bool xsdValidation = false;
  if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
    string dydXsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + string("dyd.xsd");
    parser->addXmlSchema(dydXsdPath);
    xsdValidation = true;
  }

  for (const auto& fileName : fileNames) {
    std::ifstream stream(fileName.c_str());
    if (!stream)
      throw DYNError(DYN::Error::API, FileSystemItemDoesNotExist, fileName.c_str());

    try {
      importFromStream(stream, dydHandler, parser, xsdValidation);
    } catch (const DYN::Error& exp) {
      throw DYNError(DYN::Error::API, XmlFileParsingError, fileName.c_str(), exp.what());
    }
  }

  return dydHandler.getDynamicModelsCollection();
}

void XmlImporter::importFromStream(std::istream& stream, XmlHandler& dydHandler, xml::sax::parser::ParserPtr& parser, bool xsdValidation) const {
  try {
    parser->parse(stream, dydHandler, xsdValidation);
  } catch (const xml::sax::parser::ParserException& exp) {
    throw DYNError(DYN::Error::API, XmlParsingError, exp.what());
  }
}

}  // namespace dynamicdata
