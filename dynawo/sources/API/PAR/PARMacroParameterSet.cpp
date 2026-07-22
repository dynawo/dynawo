//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file PARMacroParameterSet.cpp
 * @brief PARMacroParameterSet description : implementation file
 *
 */

#include "PARMacroParameterSet.h"
#include "PARReference.h"
#include "DYNMacrosMessage.h"

using std::shared_ptr;
using std::string;

namespace parameters {

MacroParameterSet::MacroParameterSet(const string& id) : id_(id) { }

const std::string&
MacroParameterSet::getId() const {
  return id_;
}

void
MacroParameterSet::addReference(const std::shared_ptr<Reference>& reference) {
  std::string name = reference->getName();
  const std::pair<std::map<std::string, std::shared_ptr<Reference> >::iterator, bool> ret = references_.emplace(name, reference);
  if (!ret.second)
    throw DYNError(DYN::Error::API, ReferenceAlreadySetInMacroParameterSet, reference->getName(), getId());
}

void
MacroParameterSet::addParameter(const std::shared_ptr<Parameter>& parameter) {
  std::string name = parameter->getName();
  const std::pair<std::map<std::string, std::shared_ptr<Parameter> >::iterator, bool> ret = parameters_.emplace(name, parameter);
  if (!ret.second)
    throw DYNError(DYN::Error::API, ParameterAlreadySetInMacroParameterSet, parameter->getName(), getId());
}

}  // namespace parameters
