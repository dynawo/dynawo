//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVXmlImporter.cpp
 *
 * @brief Dynawo final state values collection XML importer : implementation file
 *
 */
#include "FSVXmlImporter.h"

#include "DYNExecUtils.h"
#include "DYNMacrosMessage.h"
#include "FSVXmlHandler.h"

#include <fstream>
#include <xml/sax/parser/ParserException.h>
#include <xml/sax/parser/ParserFactory.h>


using std::string;
namespace parser = xml::sax::parser;
namespace finalStateValues {

std::shared_ptr<FinalStateValuesCollection>
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

std::shared_ptr<FinalStateValuesCollection>
XmlImporter::importFromStream(std::istream& stream) const {
  XmlHandler finalStateValuesHandler;

  xml::sax::parser::ParserFactory parser_factory;
  xml::sax::parser::ParserPtr parser = parser_factory.createParser();

  try {
    bool xsdValidation = false;
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
      const std::string fsvXsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + std::string("finalStateValuesInput.xsd");
      parser->addXmlSchema(fsvXsdPath);
      xsdValidation = true;
    }
    parser->parse(stream, finalStateValuesHandler, xsdValidation);
  } catch (const xml::sax::parser::ParserException& exp) {
    throw DYNError(DYN::Error::API, XmlParsingError, exp.what());
  }

  return finalStateValuesHandler.getFinalStateValuesCollection();
}

}  // namespace finalStateValues
