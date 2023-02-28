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

#include "DYNXmlReader.h"
#include "DYDDynamicModelsCollection.h"
#include "DYDUnitDynamicModel.h"

namespace dynamicdata {

class XmlParser {
 public:
  XmlParser(boost::shared_ptr<DynamicModelsCollection> dynamicModelsCollection, const std::string& filename);
  void parseXML();
  void activateXSDValidation(const std::string& xsdSchemaFile);

 private:
  void parseDynamicModelsArchitecture();
  void parseModelicaModel();
  void parseModelTemplate();
  void parseBlackBoxModel();
  void parseModelTemplateExpansion();
  void parseMacroConnector();
  void parseMacroStaticReference();
  boost::shared_ptr<Connector> parseConnect() const;
  boost::shared_ptr<MacroConnection> parseMacroConnection() const;
  boost::shared_ptr<MacroConnect> parseMacroConnect() const;
  boost::shared_ptr<StaticRef> parseStaticRef() const;
  boost::shared_ptr<MacroStaticRef> parseMacroStaticRef() const;
  boost::shared_ptr<UnitDynamicModel> parseUnitDynamicModel() const;
  void parseBlackBoxModelOrModelTemplateExpansion(boost::shared_ptr<Model> model) const;

  boost::shared_ptr<DynamicModelsCollection> dynamicModelsCollection_;
  const DYN::XmlReader reader_;
  const std::string filename_;
};


}  // namespace dynamicdata

#endif  // API_DYD_DYDXMLPARSER_H_
