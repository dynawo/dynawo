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
 * @file  DYNParameter.cpp
 *
 * @brief Dynawo parameter : implementation file
 *
 */
#include "DYNParameter.h"
#include "DYNMacrosMessage.h"

using std::string;

namespace DYN {

ParameterCommon::ParameterCommon(const string& name, const typeVarC_t valueType, const bool mandatory) :
name_(name),
valueType_(valueType),
mandatory_(mandatory) {
}

ParameterCommon::~ParameterCommon() {}

void
ParameterCommon::setIndex(const unsigned int index) {
  if (indexSet())
    throw DYNError(Error::MODELER, ParameterIndexAlreadySet, getName());

  index_ = index;
}

unsigned int
ParameterCommon::getIndex() const {
  if (!indexSet())
    throw DYNError(Error::MODELER, ParameterHasNoIndex, name_);

  return index_.value();
}

string origin2Str(const parameterOrigin_t origin) {
  switch (origin) {
    case MO:
      return "modelica file";
    case PAR:
      return "parameters";
    case IIDM:
      return "IIDM";
    case LOCAL_INIT:
      return "initialization";
    case LOADED_DUMP:
      return "loaded dump";
    case FINAL:
      return "final value";
    case NB_ORIGINS:
      throw DYNError(Error::MODELER, Origin2StrUnableToConvert, origin);
  }
  return "";
}

}  // namespace DYN
