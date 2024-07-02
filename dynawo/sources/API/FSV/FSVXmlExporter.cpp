//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVXmlExporter.cpp
 *
 * @brief Dynawo final state values collection XML exporter : implementation file
 *
 */

#include "FSVXmlExporter.h"

#include "DYNCommon.h"
#include "DYNMacrosMessage.h"
#include "FSVFinalStateValue.h"
#include "FSVFinalStateValuesCollection.h"

#include <fstream>
#include <sstream>
#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

using std::fstream;
using std::ostream;
using std::string;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace finalStateValues {

void
XmlExporter::exportToFile(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(finalStateValues, file);
  file.close();
}

void
XmlExporter::exportToStream(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues, ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("finalStateValuesOutput", attrs);

  for (const auto& finalStateValue : finalStateValues->getFinalStateValues()) {
    attrs.clear();
    attrs.add("model", finalStateValue->getModelName());
    attrs.add("variable", finalStateValue->getVariable());
    attrs.add("value", DYN::double2String(finalStateValue->getValue()));
    formatter->startElement("finalStateValue", attrs);
    formatter->endElement();  // finalStateValue
  }
  formatter->endElement();  // finalStateValuesOutput
  formatter->endDocument();
}

}  // namespace finalStateValues
