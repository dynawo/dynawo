//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  CSTRJsonExporter.cpp
 *
 * @brief Dynawo constraint JSON exporter : implementation file
 *
 */
#include <fstream>

#include <nlohmann/json.hpp>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"

#include "CSTRJsonExporter.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"

using std::fstream;
using std::ostream;
using std::string;
using json = nlohmann::json;

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
  json j = json::array();

  for (const auto& constraintPair : constraints->getConstraintsById()) {
    const auto& constraint = constraintPair.second;
    if (constraint->getTime() < minTime)
      continue;

    json constraintJson;
    constraintJson["modelName"] = constraint->getModelName();
    constraintJson["description"] = constraint->getDescription();
    constraintJson["time"] = constraint->getTime();

    if (constraint->hasModelType())
      constraintJson["type"] = constraint->getModelType();

    if (exportEventType) {
      Type_t eventType = constraint->getType();
      if (eventType == CONSTRAINT_BEGIN)
        constraintJson["eventType"] = "BEGIN";
      else if (eventType == CONSTRAINT_END)
        constraintJson["eventType"] = "END";
    }

    const boost::optional<ConstraintData>& data = constraint->getData();
    if (data) {
      switch (data->kind) {
        case ConstraintData::OverloadOpen:
          constraintJson["kind"] = "OverloadOpen";
          break;
        case ConstraintData::OverloadUp:
          constraintJson["kind"] = "OverloadUp";
          break;
        case ConstraintData::PATL:
          constraintJson["kind"] = "PATL";
          break;
        case ConstraintData::UInfUmin:
          constraintJson["kind"] = "UInfUmin";
          break;
        case ConstraintData::USupUmax:
          constraintJson["kind"] = "USupUmax";
          break;
        case ConstraintData::FictLim:
          constraintJson["kind"] = "Fictitious";
          break;
        case ConstraintData::Undefined:
          break;
      }
      constraintJson["limit"] = data->limit;
      constraintJson["value"] = data->value;

      if (data->valueMin)
        constraintJson["valueMin"] = data->valueMin.value();

      if (data->valueMax)
        constraintJson["valueMax"] = data->valueMax.value();

      if (data->side)
        constraintJson["side"] = data->side.value();

      if (data->acceptableDuration)
        constraintJson["acceptableDuration"] = data->acceptableDuration.value();

      if (!data->limitName.empty())
        constraintJson["limitName"] = data->limitName;
    }

    j.push_back(constraintJson);
  }

  stream << j.dump() << "\n";
}

}  // namespace constraints
