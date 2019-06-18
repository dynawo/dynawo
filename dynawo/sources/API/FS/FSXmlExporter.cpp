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
 * @file  FSXmlExporter.cpp
 *
 * @brief Dynawo final state XML exporter : implementation file
 *
 */
#include <fstream>
#include <sstream>
#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNCommon.h"
#include "DYNMacrosMessage.h"

#include "FSXmlExporter.h"
#include "FSFinalStateCollection.h"
#include "FSModel.h"
#include "FSVariable.h"
#include "FSIterators.h"

using std::fstream;
using std::ostream;
using std::string;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace finalState {

void
exportModel(FormatterPtr& formatter, model_iterator& itModel) {
  AttributeList attrs;

  for (model_iterator itModel1 = (*itModel)->beginModel();
          itModel1 != (*itModel)->endModel();
          ++itModel1) {
    attrs.clear();
    attrs.add("id", (*itModel1)->getId());
    formatter->startElement("model", attrs);
    exportModel(formatter, itModel1);
    formatter->endElement();   // model
  }

  for (variable_iterator itVariable = (*itModel)->beginVariable();
          itVariable != (*itModel)->endVariable();
          ++itVariable) {
    attrs.clear();
    attrs.add("id", (*itVariable)->getId());
    if ((*itVariable)->getAvailable())
      attrs.add("value", DYN::double2String((*itVariable)->getValue()));
    else
      attrs.add("value", "UNVAILABLE");
    formatter->startElement("variable", attrs);
    formatter->endElement();   // variable
  }
}

void
XmlExporter::exportToFile(const boost::shared_ptr<FinalStateCollection>& finalState, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);

  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(finalState, file);
  file.close();
}


void
XmlExporter::exportToStream(const boost::shared_ptr<FinalStateCollection>& finalState, ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("finalState", attrs);

  for (model_iterator itModel = finalState->beginModel();
          itModel != finalState->endModel();
          ++itModel) {
    attrs.clear();
    attrs.add("id", (*itModel)->getId());
    formatter->startElement("model", attrs);
    exportModel(formatter, itModel);
    formatter->endElement();   // model
  }

  for (variable_iterator itVariable = finalState->beginVariable();
          itVariable != finalState->endVariable();
          ++itVariable) {
    attrs.clear();
    attrs.add("id", (*itVariable)->getId());
    if ((*itVariable)->getAvailable())
      attrs.add("value", DYN::double2String((*itVariable)->getValue()));
    else
      attrs.add("value", "UNVAILABLE");
    formatter->startElement("variable", attrs);
    formatter->endElement();   // variable
  }

  formatter->endElement();   // finalState
  formatter->endDocument();
}

}  // namespace finalState
