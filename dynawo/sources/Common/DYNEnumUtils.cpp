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
 * @file  DYNModelCommon.cpp
 *
 * @brief utility functions for models
 *
 */

#include "DYNMacrosMessage.h"

#include "DYNEnumUtils.h"

using std::string;

namespace DYN {

string
modeChangeType2Str(const modeChangeType_t& modeChangeType) {
  switch (modeChangeType) {
    case NO_MODE:
      return "No mode change";
    case DIFFERENTIAL_MODE:
      return "Differential mode change";
    case ALGEBRAIC_MODE:
      return "Algebraic mode change";
    case ALGEBRAIC_J_UPDATE_MODE:
      return "Algebraic mode (with J recalculation) change";
    case ALGEBRAIC_J_J_UPDATE_MODE:
      return "Algebraic mode (with J J recalculation) change";
    default:
      assert(0 && "Mode change type should be one of the enum values");
  }
  return "";
}

string
propertyVar2Str(const propertyContinuousVar_t& property) {
  switch (property) {
    case DIFFERENTIAL:
      return "DIFFERENTIAL";
    case ALGEBRAIC:
      return "ALGEBRAIC";
    case EXTERNAL:
      return "EXTERNAL";
    case OPTIONAL_EXTERNAL:
      return "OPTIONAL_EXTERNAL";
    case UNDEFINED_PROPERTY:
      return "UNDEFINED";
    default:
      assert(0 && "Property should be one of the enum values");
  }
  return "";
}

string
typeVar2Str(const typeVar_t& type) {
  switch (type) {
    case DISCRETE:
      return "DISCRETE";
    case CONTINUOUS:
      return "CONTINUOUS";
    case FLOW:
      return "FLOW";
    case INTEGER:
      return "INTEGER";
    case BOOLEAN:
      return "BOOLEAN";
    case UNDEFINED_TYPE:
      return "UNDEFINED";
    default:
      assert(0 && "TypeVar should be one of the enum values");
  }
  return "";
}

typeVarC_t toCTypeVar(const typeVar_t& type) {
  switch (type) {
    case DISCRETE:
    case CONTINUOUS:
    case FLOW:
      return VAR_TYPE_DOUBLE;
    case INTEGER:
      return VAR_TYPE_INT;
    case BOOLEAN:
      return VAR_TYPE_BOOL;
    case UNDEFINED_TYPE:
      assert(0 && "TypeVar undefined");
    default:
      assert(0 && "TypeVar should be one of the enum values");
  }
  return VAR_TYPE_DOUBLE;
}

string paramScope2Str(const parameterScope_t& scope) {
  switch (scope) {
    case EXTERNAL_PARAMETER:
      return "external parameter";
    case SHARED_PARAMETER:
      return "shared parameter";
    case INTERNAL_PARAMETER:
      return "internal parameter";
    default:
      assert(0 && "Parameter scope should be one of the enum values");
  }
  return "";
}

}  // namespace DYN
