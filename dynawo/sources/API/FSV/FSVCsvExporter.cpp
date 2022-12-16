//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file  FSVCsvExporter.cpp
 *
 * @brief Dynawo final state values collection CSV exporter : implementation file
 *
 */

#include <fstream>

#include "DYNCommon.h"
#include "DYNMacrosMessage.h"
#include "FSVCsvExporter.h"

namespace finalStateValues {

void
CsvExporter::exportToFile(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues,
                          const std::string& filePath) const {
  std::fstream file;
  file.open(filePath.c_str(), std::fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(finalStateValues, file);
  file.close();
}

void
CsvExporter::exportToStream(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues,
                            std::ostream& stream) const {
  const std::string CSVEXPORTER_SEPARATOR = ";";  ///< separator in csv file

  // print title line
  stream << "model" << CSVEXPORTER_SEPARATOR;
  stream << "variable" << CSVEXPORTER_SEPARATOR;
  stream << "value" << CSVEXPORTER_SEPARATOR;
  stream << "\n";

  for (FinalStateValuesCollection::const_iterator itFsv = finalStateValues->cbegin();
        itFsv != finalStateValues->cend();
        ++itFsv) {
    stream << (*itFsv)->getModelName() << CSVEXPORTER_SEPARATOR;
    stream << (*itFsv)->getVariable() << CSVEXPORTER_SEPARATOR;
    stream << DYN::double2String((*itFsv)->getValue()) << CSVEXPORTER_SEPARATOR;
    stream << "\n";
  }
}

}  // namespace finalStateValues
