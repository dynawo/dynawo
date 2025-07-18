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
 * @file  CSTRXmlExporter.cpp
 *
 * @brief Dynawo constraint xml exporter : implementation file
 *
 */
#include <fstream>
#include <sstream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"

#include "CSTRXmlExporter.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"

using std::fstream;
using std::ostream;
using std::string;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace constraints {

void
XmlExporter::exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(constraints, file);
  file.close();
}

void
XmlExporter::exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints, ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;

  formatter->startElement("constraints", attrs);
  for (const auto& constraintPair : constraints->getConstraintsById()) {
    const auto& constraint = constraintPair.second;
    attrs.clear();
    attrs.add("modelName", constraint->getModelName());
    attrs.add("description", constraint->getDescription());
    attrs.add("time", DYN::double2String(constraint->getTime()));
    if (constraint->hasModelType())
      attrs.add("type", constraint->getModelType());

    const boost::optional<ConstraintData>& data = constraint->getData();
    if (data) {
      switch (data->kind) {
        case ConstraintData::OverloadOpen:
          attrs.add("kind", "OverloadOpen");
          break;
        case ConstraintData::OverloadUp:
          attrs.add("kind", "OverloadUp");
          break;
        case ConstraintData::PATL:
          attrs.add("kind", "PATL");
          break;
        case ConstraintData::UInfUmin:
          attrs.add("kind", "UInfUmin");
          break;
        case ConstraintData::USupUmax:
          attrs.add("kind", "USupUmax");
          break;
        case ConstraintData::FictLim:
          attrs.add("kind", "Fictitious");
          break;
        case ConstraintData::Undefined:
          break;
      }
      attrs.add("limit", data->limit);
      attrs.add("value", data->value);
      boost::optional<int> side = data->side;
      if (side) {
        attrs.add("side", side.value());
      }
      boost::optional<double> acceptableDuration = data->acceptableDuration;
      if (acceptableDuration) {
        attrs.add("acceptableDuration", acceptableDuration.value());
      }
    }

    formatter->startElement("constraint", attrs);
    formatter->endElement();   // constraint
  }
  formatter->endElement();   // constraints
  formatter->endDocument();
}

}  // namespace constraints
