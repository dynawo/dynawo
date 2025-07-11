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
 * @file PARXmlExporter.cpp
 * @brief Dynawo parameters collection XML exporter : implementation file
 *
 */

#include <fstream>
#include <vector>
#include <map>
#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"

#include "PARParameter.h"
#include "PARParametersSet.h"
#include "PARParametersSetCollection.h"
#include "PARXmlExporter.h"
#include "PARReference.h"

using std::fstream;
using std::string;
using std::vector;
using std::map;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace parameters {

void
XmlExporter::exportToFile(const std::shared_ptr<ParametersSetCollection>& collection, const string& filePath, const std::string& encoding) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(collection, file, encoding);
  file.close();
}

void
XmlExporter::exportToStream(const std::shared_ptr<ParametersSetCollection>& collection, std::ostream& stream, const std::string& encoding) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");
  if (!encoding.empty()) {
    formatter->setEncoding(encoding);
  }

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("parametersSet", attrs);

  for (const auto& macroParameterSetPair : collection->getMacroParametersSets()) {
    const auto& macroParameterSet = macroParameterSetPair.second;
    attrs.clear();
    attrs.add("id", macroParameterSet->getId());
    formatter->startElement("macroParameterSet", attrs);
    for (const auto& referencePair : macroParameterSet->getReferences()) {
      const auto& reference = referencePair.second;
      attrs.clear();
      attrs.add("type", reference->getType());
      attrs.add("name", reference->getName());
      attrs.add("origData", reference->getOrigDataStr());
      attrs.add("origName", reference->getOrigName());
      formatter->startElement("reference", attrs);
      formatter->endElement();
    }
    for (const auto& parameterPair : macroParameterSet->getParameters()) {
      const auto& parameter = parameterPair.second;
      attrs.clear();
      attrs.add("name", parameter->getName());
      switch (parameter->getType()) {
        case Parameter::BOOL:
          attrs.add("type", "BOOL");
          attrs.add("value", parameter->getBool() ? "true" : "false");
          break;
        case Parameter::INT:
          attrs.add("type", "INT");
          attrs.add("value", parameter->getInt());
          break;
        case Parameter::DOUBLE:
          attrs.add("type", "DOUBLE");
          attrs.add("value", parameter->getDouble());
          break;
        case Parameter::STRING:
          attrs.add("type", "STRING");
          attrs.add("value", parameter->getString());
          break;
        case Parameter::SIZE_OF_ENUM:
          throw DYNError(DYN::Error::API, PARXmlSizeOfEnumParamType);
      }
      formatter->startElement("par", attrs);
      formatter->endElement();
    }
    formatter->endElement();
  }
  for (const auto& paramSetPair : collection->getParametersSets()) {
    const auto& paramSet = paramSetPair.second;
    attrs.clear();
    attrs.add("id", paramSet->getId());
    vector <string> paramsExported;  ///< list of already exported parameters, to avoid exporting aliases
    formatter->startElement("set", attrs);
     // write parameters
    for (const auto& parameterPair : paramSet->getParameters()) {
      const auto& parameter = parameterPair.second;
      const string& paramName = parameter->getName();
      const bool alreadyExported = std::find(paramsExported.begin(), paramsExported.end(), paramName) != paramsExported.end();

      if (alreadyExported) {
        continue;
      } else {
        paramsExported.push_back(paramName);
      }

      attrs.clear();
      attrs.add("name", paramName);
      switch (parameter->getType()) {
        case Parameter::BOOL:
          attrs.add("type", "BOOL");
          attrs.add("value", parameter->getBool() ? "true" : "false");
          break;
        case Parameter::INT:
          attrs.add("type", "INT");
          attrs.add("value", parameter->getInt());
          break;
        case Parameter::DOUBLE:
          attrs.add("type", "DOUBLE");
          attrs.add("value", parameter->getDouble());
          break;
        case Parameter::STRING:
          attrs.add("type", "STRING");
          attrs.add("value", parameter->getString());
          break;
        case Parameter::SIZE_OF_ENUM:
          throw DYNError(DYN::Error::API, PARXmlSizeOfEnumParamType);
      }
      formatter->startElement("par", attrs);
      formatter->endElement();   // par
    }
     // write references
    map<string, std::shared_ptr<Reference> > sortedRefs;
    for (const auto& referencePair : paramSet->getReferences()) {
      const auto& reference = referencePair.second;
      sortedRefs.insert(std::make_pair(reference->getName(), reference));
    }
    for (const auto& sortedRef : sortedRefs) {
      const std::shared_ptr<Reference>& ref = sortedRef.second;
      attrs.clear();
      attrs.add("type", ref->getType());
      attrs.add("name", ref->getName());
      attrs.add("origData", ref->getOrigDataStr());
      attrs.add("origName", ref->getOrigName());
      if (!ref->getComponentId().empty()) {
        attrs.add("componentId", ref->getComponentId());
      }
      formatter->startElement("reference", attrs);
      formatter->endElement();   // ref
    }
    for (const auto& macroParSetPair : paramSet->getMacroParSets()) {
      const auto& macroParSet = macroParSetPair.second;
      attrs.clear();
      attrs.add("id", macroParSet->getId());
      formatter->startElement("macroParSet", attrs);
      formatter->endElement();
    }
    formatter->endElement();   // set
  }
  formatter->endElement();   // parametersSet
  formatter->endDocument();
}

}  // namespace parameters
