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

#pragma GCC diagnostic ignored "-Wunused-parameter"
#pragma GCC diagnostic ignored "-Wunused-variable"

#include "DYDXmlImporter.h"
#include "DYNExecUtils.h"
#include "DYDXmlParser.h"

using boost::shared_ptr;

using parameters::ParametersSetCollection;

namespace dynamicdata {

shared_ptr<DynamicModelsCollection>
XmlImporter::importFromDydFiles(const std::vector<std::string>& fileNames) const {
  boost::shared_ptr<DynamicModelsCollection> dynamicModelsCollection =
                                              boost::shared_ptr<DynamicModelsCollection>(new DynamicModelsCollection());
  for (const std::string& fileName : fileNames) {
    XmlParser xmlParser(dynamicModelsCollection, fileName);
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true") {
      std::string dydXsdPath = getMandatoryEnvVar("DYNAWO_XSD_DIR") + std::string("dyd.xsd");
      xmlParser.activateXSDValidation(dydXsdPath);
    }
    xmlParser.parseXML();
  }

  return dynamicModelsCollection;
}

void XmlImporter::importFromStream(std::istream& stream, XmlHandler& dydHandler, xml::sax::parser::ParserPtr& parser, bool xsdValidation) const {
  // inutile ?
}

}  // namespace dynamicdata
