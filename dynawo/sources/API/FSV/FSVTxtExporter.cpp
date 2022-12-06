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
 * @file  FSVTxtExporter.cpp
 *
 * @brief Dynawo final state values collection TXT exporter : implementation file
 *
 */

#include <fstream>

#include "DYNCommon.h"
#include "DYNMacrosMessage.h"
#include "FSVTxtExporter.h"

namespace finalStateValues {

void
TxtExporter::exportToFile(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues,
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
TxtExporter::exportToStream(const boost::shared_ptr<FinalStateValuesCollection>& finalStateValues,
                            std::ostream& stream) const {
  const std::string TXTEXPORTER_SEPARATOR = " | ";  ///< definition of the separator to use in txt files

  // print title line
  stream << "model" << TXTEXPORTER_SEPARATOR;
  stream << "variable" << TXTEXPORTER_SEPARATOR;
  stream << "value" << "\n";

  for (FinalStateValuesCollection::const_iterator itFsv = finalStateValues->cbegin();
        itFsv != finalStateValues->cend();
        ++itFsv) {
    stream << (*itFsv)->getModelName() << TXTEXPORTER_SEPARATOR;
    stream << (*itFsv)->getVariable() << TXTEXPORTER_SEPARATOR;
    stream << DYN::double2String((*itFsv)->getValue()) << "\n";
  }
}

}  // namespace finalStateValues
