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

VariableAlias::VariableAlias(const string& name, const string& refName, const typeVar_t type, const bool negated) :
Variable(name, true),
referenceName_(refName),
negated_(negated),
type_(type) {
}

VariableAlias::VariableAlias(const string& name, const shared_ptr<VariableNative>& refVar, const typeVar_t type, const bool negated) :
Variable(name, true),
referenceName_(refVar->getName()),
negated_(negated),
type_(type),
referenceVariable_(refVar) {
  if (referenceVariable_ && type_ == UNDEFINED_TYPE) {
    type_ = refVar->getType();
  }
  if (referenceVariable_)
    checkTypeCompatibility();
}

VariableAlias::~VariableAlias() {}

void
VariableAlias::setReferenceVariable(const shared_ptr<VariableNative>& refVar) {
  // an alias has to point towards a native variable
  if (refVar->isAlias()) {
    throw DYNError(Error::MODELER, VariableAliasRefNotNative, getName(), refVar->getName());
  }

  // the reference variable has to match the pre-defined reference variable name
  if (refVar->getName() != referenceName_) {
    throw DYNError(Error::MODELER, VariableAliasRefIncoherent, getName(), referenceName_, refVar->getName());
  }
  referenceVariable_ = refVar;
  if (type_ == UNDEFINED_TYPE) {
    type_ = refVar->getType();
  }
  checkTypeCompatibility();
}

typeVar_t
VariableAlias::getType() const {
  return getReferenceVariable()->getType();
}

typeVar_t
VariableAlias::getLocalType() const {
  return type_;
}

bool
VariableAlias::getNegated() const {
  return !(negated_ == getReferenceVariable()->getNegated());
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

void
VariableAlias::checkTypeCompatibility() const {
  const typeVar_t refType = getReferenceVariable()->getType();
  if (referenceVariableSet() && type_ != refType) {
    if ((type_ == FLOW && refType != CONTINUOUS) || (type_ == CONTINUOUS && refType != FLOW))
      throw DYNError(Error::MODELER, VariableAliasIncoherentType, getName(), typeVar2Str(type_), getReferenceVariableName(), typeVar2Str(refType));
    if ((type_ == DISCRETE && refType != INTEGER && refType != BOOLEAN)
        || (type_ == INTEGER && refType != DISCRETE && refType != BOOLEAN)
        || (type_ == BOOLEAN && refType != DISCRETE && refType != INTEGER))
      throw DYNError(Error::MODELER, VariableAliasIncoherentType, getName(), typeVar2Str(type_), getReferenceVariableName(), typeVar2Str(refType));
  }
}

}  // namespace DYN
