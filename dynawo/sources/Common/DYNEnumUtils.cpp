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
propertyVar2Str(const propertyContinuousVar_t& property) {
  string string2Return;
  switch (property) {
    case DIFFERENTIAL:
      string2Return = "DIFFERENTIAL";
      break;
    case ALGEBRIC:
      string2Return = "ALGEBRIC";
      break;
    case EXTERNAL:
      string2Return = "EXTERNAL";
      break;
    case OPTIONAL_EXTERNAL:
      string2Return = "OPTIONAL_EXTERNAL";
      break;
    case UNDEFINED_PROPERTY:
      string2Return = "UNDEFINED";
      break;
  }
  return string2Return;
}

string
typeVar2Str(const typeVar_t& type) {
  string string2Return;
  switch (type) {
    case DISCRETE:
      string2Return = "DISCRETE";
      break;
    case CONTINUOUS:
      string2Return = "CONTINUOUS";
      break;
    case FLOW:
      string2Return = "FLOW";
      break;
    case INTEGER:
      string2Return = "INTEGER";
      break;
    case BOOLEAN:
      string2Return = "BOOLEAN";
      break;
  }
  return string2Return;
}

typeVarC_t toCTypeVar(const typeVar_t& type) {
  typeVarC_t typeVar;
  switch (type) {
    case DISCRETE:
    case CONTINUOUS:
    case FLOW:
      typeVar = DOUBLE;
      break;
    case INTEGER:
      typeVar = INT;
      break;
    case BOOLEAN:
      typeVar = BOOL;
      break;
  }
  return typeVar;
}

string paramScope2Str(const parameterScope_t& scope) {
  string paramScopeStr;
  switch (scope) {
    case EXTERNAL_PARAMETER:
      paramScopeStr = "external parameter";
      break;
    case SHARED_PARAMETER:
      paramScopeStr = "shared parameter";
      break;
    case INTERNAL_PARAMETER:
      paramScopeStr = "internal parameter";
      break;
  }
  return paramScopeStr;
}

}  // namespace DYN
