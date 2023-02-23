//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
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
 * @file DYDXmlParser.h
 * @brief XML parser : header file
 *
 */

#ifndef API_DYD_DYDXMLPARSER_H_
#define API_DYD_DYDXMLPARSER_H_

#include <boost/shared_ptr.hpp>
#include <libxml/xmlreader.h>

#include "DYDDynamicModelsCollection.h"

namespace dynamicdata {

class XmlParser {
 public:
  XmlParser(boost::shared_ptr<DynamicModelsCollection> dynamicModelsCollection, const std::string& filename);
  ~XmlParser();
  void parseXML();
  void activateXSDValidation(const std::string& xsdSchemaFile);

 private:
  void parseDynamicModelsArchitecture();
  void parseParentNode(const std::string& parentNodeName);
  void parseChildNode(const std::string& childNodeName);
  void addStaticRefsToModel(boost::shared_ptr<Model> model);
  void addConnectsAndInitConnectsToMacroConnector(boost::shared_ptr<MacroConnector> macroConnector);

  boost::shared_ptr<DynamicModelsCollection> dynamicModelsCollection_;
  const xmlTextReaderPtr reader_;
  const std::string filename_;
};


}  // namespace dynamicdata

#endif  // API_DYD_DYDXMLPARSER_H_
