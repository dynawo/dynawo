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
 * @file EXTVARXmlImporter.cpp
 * @brief External variables collection XML importer : implementation file
 */

#include <fstream>

#include <xml/sax/parser/ParserFactory.h>
#include <xml/sax/parser/ParserException.h>

#include "DYNMacrosMessage.h"

#include "EXTVARVariablesCollectionFactory.h"
#include "EXTVARXmlHandler.h"
#include "EXTVARXmlImporter.h"
#include "DYNExecUtils.h"

using std::string;
using std::vector;

namespace parser = xml::sax::parser;

namespace externalVariables {

std::shared_ptr<VariablesCollection>
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

std::shared_ptr<VariablesCollection> XmlImporter::importFromStream(std::istream& stream) const {
  XmlHandler extVarHandler;
  xml::sax::parser::ParserFactory parser_factory;
  xml::sax::parser::ParserPtr parser = parser_factory.createParser();
  try {
    bool xsdValidation = false;
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
      string extvarXsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + string("extVar.xsd");
      parser->addXmlSchema(extvarXsdPath);
      xsdValidation = true;
    }
    parser->parse(stream, extVarHandler, xsdValidation);
  } catch (const xml::sax::parser::ParserException& exp) {
    throw DYNError(DYN::Error::API, XmlParsingError, exp.what());
  }

  return extVarHandler.getVariablesCollection();
}

}  // namespace externalVariables
