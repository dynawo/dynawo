//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQXmlExporter.cpp
 *
 * @brief Dynawo lost equipments xml exporter : implementation file
 *
 */
#include <fstream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"

#include "LEQXmlExporter.h"
#include "LEQLostEquipmentsCollection.h"
#include "LEQLostEquipment.h"

using std::fstream;
using std::ostream;
using std::string;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;


namespace lostEquipments {

void
XmlExporter::exportToFile(const std::shared_ptr<LostEquipmentsCollection>& lostEquipments, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(lostEquipments, file);
  file.close();
}

void
XmlExporter::exportToStream(const std::shared_ptr<LostEquipmentsCollection>& lostEquipments, ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;

  formatter->startElement("lostEquipments", attrs);
  for (LostEquipmentsCollection::LostEquipmentsCollectionConstIterator itLostEquipment = lostEquipments->cbegin();
          itLostEquipment != lostEquipments->cend();
          ++itLostEquipment) {
    attrs.clear();
    attrs.add("id", (*itLostEquipment)->getId());
    attrs.add("type", (*itLostEquipment)->getType());
    formatter->startElement("lostEquipment", attrs);
    formatter->endElement();   // lostEquipment
  }
  formatter->endElement();   // lostEquipments
  formatter->endDocument();
}

}  // namespace lostEquipments
