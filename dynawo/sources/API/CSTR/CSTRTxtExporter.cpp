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
 * @file  CSTRTxtExporter.cpp
 *
 * @brief Dynawo constraints txt exporter : implementation file
 *
 */
#include <fstream>
#include <sstream>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"

#include "CSTRTxtExporter.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"

using std::fstream;
using std::ostream;
using std::string;

namespace constraints {

void
TxtExporter::exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(constraints, file);
  file.close();
}

void
TxtExporter::exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints, ostream& stream, double afterTime) const {
  const std::string TXTEXPORTER_SEPARATOR = " | ";  ///< separator in txt file
  for (const auto& constraintPair : constraints->getConstraintsById()) {
    const auto& constraint = constraintPair.second;
    if (!DYN::doubleGreater(constraint->getTime(), afterTime))
      continue;
    stream << constraint->getModelName()
            << TXTEXPORTER_SEPARATOR
            << DYN::double2String(constraint->getTime())
            << TXTEXPORTER_SEPARATOR
            << constraint->getDescription();
    if (constraint->hasModelType())
      stream << TXTEXPORTER_SEPARATOR
             << constraint->getModelType();

    const boost::optional<ConstraintData>& data = constraint->getData();
    if (data) {
      switch (data->kind) {
        case ConstraintData::OverloadOpen:
          stream << TXTEXPORTER_SEPARATOR
                 << "OverloadOpen";
          break;
        case ConstraintData::OverloadUp:
          stream << TXTEXPORTER_SEPARATOR
                 << "OverloadUp";
          break;
        case ConstraintData::PATL:
          stream << TXTEXPORTER_SEPARATOR
                 << "PATL";
          break;
        case ConstraintData::UInfUmin:
          stream << TXTEXPORTER_SEPARATOR
                 << "UInfUmin";
          break;
        case ConstraintData::USupUmax:
          stream << TXTEXPORTER_SEPARATOR
                 << "USupUmax";
          break;
	case ConstraintData::FictLim:
          stream << TXTEXPORTER_SEPARATOR
                 << "Fictitious";
          break;
        case ConstraintData::Undefined:
          break;
      }
      stream << TXTEXPORTER_SEPARATOR
             << data->limit;
      stream << TXTEXPORTER_SEPARATOR
             << data->value;
      boost::optional<int> side = data->side;
      if (side) {
        stream << TXTEXPORTER_SEPARATOR
               << side.value();
      }
      boost::optional<double> acceptableDuration = data->acceptableDuration;
      if (acceptableDuration) {
        stream << TXTEXPORTER_SEPARATOR
               << acceptableDuration.value();
      }
    }
    stream << "\n";
  }
}

}  // namespace constraints
