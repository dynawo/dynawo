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
 * @file EXTVARXmlExporter.cpp
 * @brief Dynawo external variables models collection XML exporter : implementation file
 *
 */
#include <fstream>

#include <xml/sax/parser/Attributes.h>
#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"

#include "EXTVARVariablesCollection.h"
#include "EXTVARXmlExporter.h"
#include "EXTVARVariable.h"

using std::fstream;
using std::ostream;
using std::string;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace externalVariables {

void
XmlExporter::exportToFile(const VariablesCollection& collection, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(collection, file);
  file.close();
}

void
XmlExporter::exportToStream(const VariablesCollection& collection, ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("external_variables", attrs);

  for (const auto& variablePair : collection.getVariables()) {
    writeVariable(variablePair.second, *formatter);
  }

  formatter->endElement();  // external_variables
  formatter->endDocument();
}

void
XmlExporter::writeVariable(const std::shared_ptr<Variable>& variable, Formatter& formatter) const {
  AttributeList attrs;
  attrs.add("id", variable->getId());
  std::string type;
  switch (variable->getType()) {
    case Variable::Type::CONTINUOUS:
      type = "continuous";
      break;
    case Variable::Type::DISCRETE:
      type = "discrete";
      break;
    case Variable::Type::BOOLEAN:
      type = "boolean";
      break;
    case Variable::Type::CONTINUOUS_ARRAY:
      type = "continuousArray";
      break;
    case Variable::Type::DISCRETE_ARRAY:
      type = "discreteArray";
      break;
  }

  attrs.add("type", type);
  if (variable->hasDefaultValue())
    attrs.add("defaultValue", variable->getDefaultValue());

  if (variable->hasSize())
    attrs.add("size", variable->getSize());

  if (variable->hasOptional())
    attrs.add("optional", variable->getOptional());

  formatter.startElement("variable", attrs);
  formatter.endElement();  // variable
}

}  // namespace externalVariables
