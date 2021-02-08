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
 * @file  FSXmlImporter.cpp
 *
 * @brief Dynawo Final State collection XML importer : implementation file
 *
 */
#include <fstream>

#include <xml/sax/parser/ParserFactory.h>
#include <xml/sax/parser/ParserException.h>

#include "DYNMacrosMessage.h"

#include "FSXmlImporter.h"
#include "FSXmlHandler.h"
#include "DYNExecUtils.h"

using std::string;
using boost::shared_ptr;
namespace parser = xml::sax::parser;

namespace finalState {

shared_ptr<FinalStateCollection>
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

boost::shared_ptr<FinalStateCollection> XmlImporter::importFromStream(std::istream& stream) const {
  XmlHandler finalStateHandler;
  xml::sax::parser::ParserFactory parser_factory(multiThreadingMode_);
  xml::sax::parser::ParserPtr parser = parser_factory.createParser();
  try {
    bool xsdValidation = false;
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
      string fsXsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + string("finalStateInput.xsd");
      parser->addXmlSchema(fsXsdPath);
      xsdValidation = true;
    }
    parser->parse(stream, finalStateHandler, xsdValidation);
  } catch (const xml::sax::parser::ParserException& exp) {
    throw DYNError(DYN::Error::API, XmlParsingError, exp.what());
  }

  return finalStateHandler.getFinalStateCollection();
}


}  // namespace finalState
