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
 * @file  CRVXmlExporter.cpp
 *
 * @brief Dynawo curves collection XML exporter : implementation file
 *
 */
#include <fstream>
#include <sstream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNMacrosMessage.h"

#include "DYNCommon.h"

#include "CRVCurvesCollection.h"
#include "CRVCurve.h"
#include "CRVPoint.h"
#include "CRVXmlExporter.h"

using std::fstream;
using std::ostream;
using std::string;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

namespace curves {

void
XmlExporter::exportToFile(const std::shared_ptr<CurvesCollection>& curves, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(curves, file);
  file.close();
}

void
XmlExporter::exportToStream(const std::shared_ptr<CurvesCollection>& curves, ostream& stream) const {
  FormatterPtr formatter = Formatter::createFormatter(stream, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("curvesOutput", attrs);

  for (const auto& curve : curves->getCurves()) {
    const bool exportAsCurve = curve->getExportType() == Curve::EXPORT_AS_CURVE || curve->getExportType() == Curve::EXPORT_AS_BOTH;
    if (curve->getAvailable() && exportAsCurve) {
      attrs.clear();
      attrs.add("model", curve->getModelName());
      attrs.add("variable", curve->getVariable());
      if (DYN::doubleNotEquals(curve->getFactor(), 1.))
        attrs.add("factor", curve->getFactor());
      formatter->startElement("curve", attrs);
      for (const auto& point : curve->getPoints()) {
        attrs.clear();
        attrs.add("time", DYN::double2String(point->getTime()));
        attrs.add("value", DYN::double2String(point->getValue()));
        formatter->startElement("point", attrs);
        formatter->endElement();   // point
      }
      formatter->endElement();   // curve
    }
  }
  formatter->endElement();   // curvesOutput
  formatter->endDocument();
}

}  // namespace curves
