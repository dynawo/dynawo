//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file  CRVCsvExporter.cpp
 *
 * @brief Dynawo curves collection CSV exporter : implementation file
 *
 */
#include <fstream>
#include <vector>
#include <sstream>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"

#include "CRVCurvesCollection.h"
#include "CRVCurve.h"
#include "CRVPoint.h"
#include "CRVCsvExporter.h"

using std::fstream;
using std::string;
using std::ostream;

namespace curves {

void
CsvExporter::exportToFile(const std::shared_ptr<CurvesCollection>& curves, const string& filePath) const {
  // open export file
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(curves, file);
  file.close();
}

void
CsvExporter::exportToStream(const std::shared_ptr<CurvesCollection>& curves, ostream& stream) const {
  static const char CSV_SEPARATOR = ';';

  // filter curves to actually be exported
  std::vector<std::shared_ptr<Curve> > curvesToExport;
  for (std::shared_ptr<Curve> curve : curves->getCurves())
    if (curve->getAvailable() && curve->getExportType() != curves::Curve::EXPORT_AS_FINAL_STATE_VALUE)
      curvesToExport.push_back(curve);

  if (curvesToExport.empty())
    return;

  // export header
  stream << "time" << CSV_SEPARATOR;
  for (std::shared_ptr<Curve> curve : curvesToExport) {
    stream << curve->getUniqueName() << CSV_SEPARATOR;
  }
  stream << '\n';

  // for each time point, print value for all the curves if at least one value (including time) has changed
  std::string prevLine;
  for (unsigned int step = 0; step < curvesToExport.front()->getPoints().size(); ++step) {
    std::string newLine = DYN::double2String(curvesToExport.front()->getPoints()[step]->getTime());
    newLine += CSV_SEPARATOR;

    for (std::shared_ptr<Curve> curve : curvesToExport) {
        newLine += DYN::double2String(curve->getPoints()[step]->getValue());
        newLine += CSV_SEPARATOR;
    }
    newLine += '\n';

    if (newLine != prevLine) {
      stream << newLine;
      prevLine = newLine;
    }
  }
}

}  // namespace curves
