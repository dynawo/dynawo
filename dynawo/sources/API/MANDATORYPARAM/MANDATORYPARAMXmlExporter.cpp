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
 * @file MANDATORYPARAMXmlExporter.cpp
 * @brief Mandatory parameters XML exporter : implementation file
 */

#include <fstream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"

#include "MANDATORYPARAMXmlExporter.h"

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::FormatterPtr;
using xml::sax::formatter::Formatter;

namespace mandatoryParameters {

void
XmlExporter::exportToFile(const Collection& collection, const std::string& filePath) const {
  std::fstream file;
  file.open(filePath.c_str(), std::fstream::out);
  if (!file.is_open())
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());

  FormatterPtr formatter = Formatter::createFormatter(file);
  formatter->startDocument();

  AttributeList attrs;
  formatter->startElement("mandatoryParameters", attrs);

  for (const auto& param : collection.getParameters()) {
    AttributeList paramAttrs;
    paramAttrs.add("name", param.getName());
    paramAttrs.add("type", param.getType());
    formatter->startElement("mandatoryParameter", paramAttrs);
    formatter->endElement();
  }

  formatter->endElement();  // mandatoryParameters
  formatter->endDocument();

  file.close();
}

}  // namespace mandatoryParameters
