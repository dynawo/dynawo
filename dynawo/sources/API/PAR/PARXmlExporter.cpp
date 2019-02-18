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

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace parameters {

void
XmlExporter::exportToFile(const boost::shared_ptr<ParametersSetCollection>& collection, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(collection, file);
  file.close();
}

void
XmlExporter::exportToStream(const boost::shared_ptr<ParametersSetCollection>& collection, std::ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("parametersSet", attrs);
  for (ParametersSetCollection::parametersSet_const_iterator itParamSet = collection->cbeginParametersSet();
          itParamSet != collection->cendParametersSet();
          ++itParamSet) {
    attrs.clear();
    attrs.add("id", (*itParamSet)->getId());
    vector <string> paramsExported;  ///< list of already exported parameters, to avoid exporting aliases
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
          throw("SIZE_OF_ENUM should not be set as a Parameter type");
      }
      formatter->startElement("par", attrs);
      formatter->endElement();   // par
    }
     // write references
    for (ParametersSet::reference_const_iterator itRef = (*itParamSet)->cbeginReference();
            itRef != (*itParamSet)->cendReference();
            ++itRef) {
      attrs.clear();
      attrs.add("type", (*itRef)->getType());
      attrs.add("name", (*itRef)->getName());
      attrs.add("origData", (*itRef)->getOrigDataStr());
      attrs.add("origName", (*itRef)->getOrigName());
      formatter->startElement("reference", attrs);
      formatter->endElement();   // ref
    }
    formatter->endElement();   // set
  }
  formatter->endElement();   // parametersSet
  formatter->endDocument();
}

}  // namespace parameters

