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
  const std::string CSVEXPORTER_SEPARATOR = ";";  ///< separator in csv file

  // check if there are curves to be printed
  bool hasAvailableCurves(false);
  for (const auto& curve : curves->getCurves()) {
    if (curve->getAvailable()) {
      hasAvailableCurves = true;
      break;
    }
  }

  if (!hasAvailableCurves) {
    return;
  }

  // if there are curves to be printed:

  // print title line
  stream << "time" << CSVEXPORTER_SEPARATOR;
  for (const auto& curve : curves->getCurves()) {
    if (curve->getAvailable() && curve->getExportType() != curves::Curve::EXPORT_AS_FINAL_STATE_VALUE) {
      stream << curve->getModelName() << "_"
              << curve->getVariable() << CSVEXPORTER_SEPARATOR;
    }
  }
  stream << "\n";

  // get time line
  std::vector<double> time;
  for (const auto& curve : curves->getCurves()) {
    if (curve->getAvailable()) {
      for (const auto& point : curve->getPoints()) {
        time.push_back(point->getTime());
      }
      break;
    }
  }
  // for each time point, print value for all the curves.
  for (unsigned int i = 0; i < time.size(); ++i) {
    stream <<  DYN::double2String(time[i]) << CSVEXPORTER_SEPARATOR;
    for (const auto& curve : curves->getCurves()) {
      const auto& points = curve->getPoints();
      if (curve->getAvailable() && curve->getExportType() != curves::Curve::EXPORT_AS_FINAL_STATE_VALUE) {
        stream << DYN::double2String(points[i]->getValue()) << CSVEXPORTER_SEPARATOR;
      }
    }
    stream << "\n";
  }
}

}  // namespace curves
