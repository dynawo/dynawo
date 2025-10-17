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
#include <sstream>

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/json_parser.hpp>

#include "DYNMacrosMessage.h"
#include "DYNCommon.h"

#include "CSTRJsonExporter.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"

using std::fstream;
using std::ostream;
using std::string;

using boost::property_tree::ptree;

namespace constraints {

void
JsonExporter::exportToFile(const std::shared_ptr<ConstraintsCollection>& constraints, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }

  exportToStream(constraints, file);
  file.close();
}

void
JsonExporter::exportToStream(const std::shared_ptr<ConstraintsCollection>& constraints, ostream& stream) const {
  ptree root;
  ptree array;
  for (const auto& constraintPair : constraints->getConstraintsById()) {
    const auto& constraint = constraintPair.second;
    ptree item;
    item.put("modelName", constraint->getModelName());
    item.put("description", constraint->getDescription());
    item.put("time", DYN::double2String(constraint->getTime()));
    if (constraint->hasModelType())
      item.put("type", constraint->getModelType());
    const boost::optional<ConstraintData>& data = constraint->getData();
    if (data) {
      switch (data->kind) {
        case ConstraintData::OverloadOpen:
          item.put("kind", "OverloadOpen");
          break;
        case ConstraintData::OverloadUp:
          item.put("kind", "OverloadUp");
          break;
        case ConstraintData::PATL:
          item.put("kind", "PATL");
          break;
        case ConstraintData::UInfUmin:
          item.put("kind", "UInfUmin");
          break;
        case ConstraintData::USupUmax:
          item.put("kind", "USupUmax");
          break;
        case ConstraintData::FictLim:
          item.put("kind", "Fictitious");
          break;
        case ConstraintData::Undefined:
          break;
      }
      item.put("limit", data->limit);
      item.put("value", data->value);

      boost::optional<double> valueMin = data->valueMin;
      if (valueMin)
        item.put("valueMin", valueMin.value());

      boost::optional<double> valueMax = data->valueMax;
      if (valueMax)
        item.put("valueMax", valueMax.value());

      boost::optional<int> side = data->side;
      if (side) {
        item.put("side", side.value());
      }
      boost::optional<double> acceptableDuration = data->acceptableDuration;
      if (acceptableDuration) {
        item.put("acceptableDuration", acceptableDuration.value());
      }
    }
    array.push_back(std::make_pair("", item));
  }
  root.push_back(std::make_pair("constraints", array));

  write_json(stream, root, false);
}

}  // namespace constraints
