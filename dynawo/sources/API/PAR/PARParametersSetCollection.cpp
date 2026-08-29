//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file PARParametersSetCollection.cpp
 * @brief Dynawo parameters set collection : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "PARParametersSet.h"
#include "PARParametersSetCollection.h"
#include "PARMacroParameterSet.h"

using std::map;
using std::string;

using DYN::Error;

namespace parameters {

void
ParametersSetCollection::addParametersSet(const std::shared_ptr<ParametersSet>& paramSet, const bool force) {
  assert(paramSet && "impossible to add null parameter set pointer to collection");

  string id = paramSet->getId();
  if (hasParametersSet(id)) {
    if (force) {
      // @todo : force / Create custom id, change parameters set one and adds it to the map
    } else {
      throw DYNError(Error::API, ParametersSetAlreadyExists, id);
    }
  }
  parametersSets_[id] = paramSet;
}

void
ParametersSetCollection::addMacroParameterSet(const std::shared_ptr<MacroParameterSet>& macroParamSet) {
  assert(macroParamSet && "impossible to add null macro parameter set pointer to collection");
  string id = macroParamSet->getId();
  if (hasMacroParametersSet(id)) {
    throw DYNError(Error::API, MacroParameterSetAlreadyExists, id);
  }
  macroParametersSets_[id] = macroParamSet;
}

std::shared_ptr<ParametersSet>
ParametersSetCollection::getParametersSet(const string& id) {
  const auto itParamSet = parametersSets_.find(id);
  if (itParamSet == parametersSets_.end())
    throw DYNError(DYN::Error::API, ParametersSetNotFound, id);
  return itParamSet->second;
}

void
ParametersSetCollection::getParametersFromMacroParameter() {
  for (const auto& parametersSetPair : parametersSets_) {
    // if a macroParSet is defined in the set, we add the references and parameters associated
    const auto& parameterSet = parametersSetPair.second;
    if (parameterSet->hasMacroParSet()) {
      for (const auto& macroParSetPair : parameterSet->getMacroParSets()) {
        const auto& macroParSet = macroParSetPair.second;
        const auto& macroParSetId = macroParSet->getId();
        if (hasMacroParametersSet(macroParSetId)) {
          for (const auto& referencePair : macroParametersSets_[macroParSetId]->getReferences())
            parameterSet->addReference(referencePair.second);
          for (const auto& parameterPair : macroParametersSets_[macroParSetId]->getParameters())
            parameterSet->addParameter(parameterPair.second);
        }
      }
    }
  }
}

bool
ParametersSetCollection::hasParametersSet(const string& id) const {
  return parametersSets_.find(id) != parametersSets_.end();
}

bool
ParametersSetCollection::hasMacroParametersSet(const string& id) const {
  return macroParametersSets_.find(id) != macroParametersSets_.end();
}

void
ParametersSetCollection::propagateOriginData(const std::string& filepath) const {
  for (const auto& parametersSet : parametersSets_)
    parametersSet.second->setFilePath(filepath);
}

}  // namespace parameters
