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

  for (ParametersSetCollection::macroparameterset_const_iterator itMacroParameterSet = collection->cbeginMacroParameterSet();
  itMacroParameterSet != collection->cendMacroParameterSet();
  ++itMacroParameterSet) {
    attrs.clear();
    attrs.add("id", (*itMacroParameterSet)->getId());
    formatter->startElement("macroParameterSet", attrs);
    for (MacroParameterSet::reference_const_iterator itReference = (*itMacroParameterSet)->cbeginReference();
    itReference != (*itMacroParameterSet)->cendReference();
    ++itReference) {
      attrs.clear();
      attrs.add("type", (*itReference)->getType());
      attrs.add("name", (*itReference)->getName());
      attrs.add("origData", (*itReference)->getOrigDataStr());
      attrs.add("origName", (*itReference)->getOrigName());
      formatter->startElement("reference", attrs);
      formatter->endElement();
    }
    for (MacroParameterSet::parameter_const_iterator itParameter = (*itMacroParameterSet)->cbeginParameter();
    itParameter != (*itMacroParameterSet)->cendParameter();
    ++itParameter) {
      attrs.clear();
      attrs.add("name", (*itParameter)->getName());
      switch ((*itParameter)->getType()) {
        case Parameter::BOOL:
          attrs.add("type", "BOOL");
          attrs.add("value", ((*itParameter)->getBool() ? "true" : "false"));
          break;
        case Parameter::INT:
          attrs.add("type", "INT");
          attrs.add("value", (*itParameter)->getInt());
          break;
        case Parameter::DOUBLE:
          attrs.add("type", "DOUBLE");
          attrs.add("value", (*itParameter)->getDouble());
          break;
        case Parameter::STRING:
          attrs.add("type", "STRING");
          attrs.add("value", (*itParameter)->getString());
          break;
        case Parameter::SIZE_OF_ENUM:
          throw DYNError(DYN::Error::API, PARXmlSizeOfEnumParamType);
      }
      formatter->startElement("par", attrs);
      formatter->endElement();
    }
    formatter->endElement();
  }
  for (ParametersSetCollection::parametersSet_const_iterator itParamSet = collection->cbeginParametersSet();
          itParamSet != collection->cendParametersSet();
          ++itParamSet) {
    attrs.clear();
    attrs.add("id", (*itParamSet)->getId());
    vector<string> paramsExported;  ///< list of already exported parameters, to avoid exporting aliases
    formatter->startElement("set", attrs);
     // write parameters
    for (ParametersSet::parameter_const_iterator itParam = (*itParamSet)->cbeginParameter();
            itParam != (*itParamSet)->cendParameter();
            ++itParam) {
      const string paramName = (*itParam)->getName();
      const bool alreadyExported = std::find(paramsExported.begin(), paramsExported.end(), paramName) != paramsExported.end();

      if (alreadyExported) {
        continue;
      } else {
        paramsExported.push_back(paramName);
      }

      attrs.clear();
      attrs.add("name", paramName);
      switch ((*itParam)->getType()) {
        case Parameter::BOOL:
          attrs.add("type", "BOOL");
          attrs.add("value", ((*itParam)->getBool() ? "true" : "false"));
          break;
        case Parameter::INT:
          attrs.add("type", "INT");
          attrs.add("value", (*itParam)->getInt());
          break;
        case Parameter::DOUBLE:
          attrs.add("type", "DOUBLE");
          attrs.add("value", (*itParam)->getDouble());
          break;
        case Parameter::STRING:
          attrs.add("type", "STRING");
          attrs.add("value", (*itParam)->getString());
          break;
        case Parameter::SIZE_OF_ENUM:
          throw DYNError(DYN::Error::API, PARXmlSizeOfEnumParamType);
      }
      formatter->startElement("par", attrs);
      formatter->endElement();   // par
    }
     // write references
    map<string, boost::shared_ptr<Reference> > sortedRef;
    for (ParametersSet::reference_const_iterator itRef = (*itParamSet)->cbeginReference();
            itRef != (*itParamSet)->cendReference();
            ++itRef) {
      sortedRef.insert(std::make_pair((*itRef)->getName(), *itRef));
    }
    for (map<string, boost::shared_ptr<Reference> >::const_iterator itRef = sortedRef.begin();
            itRef != sortedRef.end(); ++itRef) {
      const boost::shared_ptr<Reference>& ref = itRef->second;
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
    for (ParametersSet::macroparset_const_iterator itMacroParSet = (*itParamSet)->cbeginMacroParSet();
    itMacroParSet != (*itParamSet)->cendMacroParSet();
    ++itMacroParSet) {
      attrs.clear();
      attrs.add("id", (*itMacroParSet)->getId());
      formatter->startElement("macroParSet", attrs);
      formatter->endElement();
    }
    formatter->endElement();   // set
  }
  formatter->endElement();   // parametersSet
  formatter->endDocument();
}

}  // namespace parameters
