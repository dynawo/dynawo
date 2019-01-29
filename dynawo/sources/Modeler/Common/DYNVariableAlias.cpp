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
 * @file  DYNVariableAlias.cpp
 *
 * @brief Dynawo variable alias : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "DYNVariableAlias.h"
#include "DYNVariableNative.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

VariableAlias::VariableAlias(const string& name, const string& refName, bool negated) :
Variable(name, true),
referenceName_(refName),
negated_(negated) {
}

VariableAlias::VariableAlias(const string& name, const shared_ptr<VariableNative> refVar, bool negated) :
Variable(name, true),
referenceName_(refVar->getName()),
negated_(negated),
referenceVariable_(refVar) {
}

VariableAlias::~VariableAlias() {
}

void
VariableAlias::setReferenceVariable(const shared_ptr<VariableNative> refVar) {
  // an alias has to point towards a native variable
  if (refVar->isAlias()) {
    throw DYNError(Error::MODELER, VariableAliasRefNotNative, getName(), refVar->getName());
  }

  // the reference variable has to match the pre-defined reference variable name
  if (refVar->getName() != referenceName_) {
    throw DYNError(Error::MODELER, VariableAliasRefIncoherent, getName(), referenceName_, refVar->getName());
  }
  referenceVariable_ = refVar;
}

typeVar_t
VariableAlias::getType() const {
  return getReferenceVariable()->getType();
}

bool
VariableAlias::getNegated() const {
  return (!(negated_ == getReferenceVariable()->getNegated()));
}

bool
VariableAlias::isState() const {
  return getReferenceVariable()->isState();
}

int
VariableAlias::getIndex() const {
  return getReferenceVariable()->getIndex();
}

bool
VariableAlias::referenceVariableSet() const {
  if (referenceVariable_)
    return true;
  else
    return false;
}

shared_ptr<VariableNative>
VariableAlias::getReferenceVariable() const {
  if (!referenceVariableSet()) {
    throw DYNError(Error::MODELER, VariableAliasRefNotSet, getName(), getReferenceVariableName());
  }

  return referenceVariable_.value();
}
}  // namespace DYN
