//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  CSTRJsonExporter.cpp
 *
 * @brief Dynawo constraint JSON exporter : implementation file
 *
 */
#include <fstream>

#include <sstream>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"

#include "CSTRJsonExporter.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"

using std::fstream;
using std::ostream;
using std::string;
using std::ostringstream;

namespace constraints {

void
JsonExporter::exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints,
                          const string& filePath,
                          bool exportEventType) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(constraints, file, -1.0, exportEventType);
  file.close();
}

void
JsonExporter::exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints,
                            ostream& stream,
                            double minTime,
                            bool exportEventType) const {
  ostringstream oss;
  oss << "[";

  bool firstConstraint = true;
  for (const auto& constraintPair : constraints->getConstraintsById()) {
    const auto& constraint = constraintPair.second;
    if (constraint->getTime() < minTime)
      continue;

    if (!firstConstraint) {
      oss << ",";
    }
    firstConstraint = false;

    oss << "{";
    oss << "\"modelName\":\"" << constraint->getModelName() << "\",";
    oss << "\"description\":\"" << constraint->getDescription() << "\",";
    oss << "\"time\":" << constraint->getTime();

    if (constraint->hasModelType()) {
      oss << ",\"type\":\"" << constraint->getModelType() << "\"";
    }

    if (exportEventType) {
      Type_t eventType = constraint->getType();
      if (eventType == CONSTRAINT_BEGIN)
        oss << ",\"eventType\":\"BEGIN\"";
      else if (eventType == CONSTRAINT_END)
        oss << ",\"eventType\":\"END\"";
    }

    const boost::optional<ConstraintData>& data = constraint->getData();
    if (data) {
      switch (data->kind) {
        case ConstraintData::OverloadOpen:
          oss << ",\"kind\":\"OverloadOpen\"";
          break;
        case ConstraintData::OverloadUp:
          oss << ",\"kind\":\"OverloadUp\"";
          break;
        case ConstraintData::PATL:
          oss << ",\"kind\":\"PATL\"";
          break;
        case ConstraintData::UInfUmin:
          oss << ",\"kind\":\"UInfUmin\"";
          break;
        case ConstraintData::USupUmax:
          oss << ",\"kind\":\"USupUmax\"";
          break;
        case ConstraintData::FictLim:
          oss << ",\"kind\":\"Fictitious\"";
          break;
        case ConstraintData::Undefined:
          break;
      }
      oss << ",\"limit\":" << data->limit;
      oss << ",\"value\":" << data->value;

      if (data->valueMin)
        oss << ",\"valueMin\":" << data->valueMin.value();

      if (data->valueMax)
        oss << ",\"valueMax\":" << data->valueMax.value();

      if (data->side)
        oss << ",\"side\":" << data->side.value();

      if (data->acceptableDuration)
        oss << ",\"acceptableDuration\":" << data->acceptableDuration.value();

      if (!data->limitName.empty())
        oss << ",\"limitName\":\"" << data->limitName << "\"";
    }

    oss << "}";
  }
  oss << "]";

  stream << oss.str() << "\n";
}

}  // namespace constraints
