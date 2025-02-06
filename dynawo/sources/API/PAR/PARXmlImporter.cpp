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
 * @file PARXmlImporter.cpp
 * @brief Dynawo parameters collection XML importer : implementation file
 *
 */
#include <fstream>

#include <xml/sax/parser/ParserFactory.h>
#include <xml/sax/parser/ParserException.h>

#include "DYNMacrosMessage.h"

#include "PARXmlHandler.h"
#include "PARXmlImporter.h"
#include "DYNExecUtils.h"

using std::string;

namespace parser = xml::sax::parser;

namespace parameters {

std::shared_ptr<ParametersSetCollection>
XmlImporter::importFromFile(const string& fileName) const {
  std::ifstream stream(fileName.c_str());
  if (!stream)
    throw DYNError(DYN::Error::API, FileSystemItemDoesNotExist, fileName);

  try {
    return importFromStream(stream);
  } catch (const DYN::Error& exp) {
    throw DYNError(DYN::Error::API, XmlFileParsingError, fileName, exp.what());
  }
}

std::shared_ptr<ParametersSetCollection> XmlImporter::importFromStream(std::istream& stream) const {
  XmlHandler parHandler;
  xml::sax::parser::ParserFactory parser_factory;
  xml::sax::parser::ParserPtr parser = parser_factory.createParser();

  try {
    bool xsdValidation = false;
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
      string parXsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + string("parameters.xsd");
      parser->addXmlSchema(parXsdPath);
      xsdValidation = true;
    }
    parser->parse(stream, parHandler, xsdValidation);
  } catch (const xml::sax::parser::ParserException& exp) {
    throw DYNError(DYN::Error::API, XmlParsingError, exp.what());
  }

  return parHandler.getParametersSetCollection();
}

}  // namespace parameters
