//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file MANDATORYPARAMXmlImporter.cpp
 * @brief Mandatory parameters XML importer : implementation file
 */

#include <fstream>

#include <xml/sax/parser/ParserFactory.h>
#include <xml/sax/parser/ParserException.h>

#include "DYNMacrosMessage.h"
#include "DYNExecUtils.h"

#include "MANDATORYPARAMXmlHandler.h"
#include "MANDATORYPARAMXmlImporter.h"

namespace parser = xml::sax::parser;

namespace mandatoryParameters {

std::shared_ptr<Collection>
XmlImporter::importFromFile(const std::string& filePath) const {
  std::ifstream stream(filePath.c_str());
  if (!stream)
    throw DYNError(DYN::Error::API, FileSystemItemDoesNotExist, filePath);

  try {
    return importFromStream(stream);
  } catch (const DYN::Error& exp) {
    throw DYNError(DYN::Error::API, XmlFileParsingError, filePath, exp.what());
  }
}

std::shared_ptr<Collection>
XmlImporter::importFromStream(std::istream& stream) const {
  XmlHandler handler;
  parser::ParserFactory parserFactory;
  parser::ParserPtr xmlParser = parserFactory.createParser();
  try {
    bool xsdValidation = false;
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
      std::string xsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + std::string("mandatoryParam.xsd");
      xmlParser->addXmlSchema(xsdPath);
      xsdValidation = true;
    }
    xmlParser->parse(stream, handler, xsdValidation);
  } catch (const parser::ParserException& exp) {
    throw DYNError(DYN::Error::API, XmlParsingError, exp.what());
  }

  return handler.getCollection();
}

}  // namespace mandatoryParameters
