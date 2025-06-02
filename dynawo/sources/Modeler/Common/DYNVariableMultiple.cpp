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
 * @file  DYNVariableMultiple.cpp
 *
 * @brief Dynawo multiple variable : implementation file
 *
 */
#include "DYNMacrosMessage.h"

#include "DYNVariableMultiple.h"

using std::string;

namespace DYN {

VariableMultiple::VariableMultiple(const string& name, const string& cardinalityName, const typeVar_t type, const bool isState, const bool negated) :
VariableNative(name, type, isState, negated),
cardinalityName_(cardinalityName) {
}

void
VariableMultiple::setCardinality(const unsigned int cardinality) {
  cardinality_ = cardinality;
}

bool
VariableMultiple::cardinalitySet() const {
  if (cardinality_)
    return true;
  else
    return false;
}

unsigned int
VariableMultiple::getCardinality() const {
  if (!cardinalitySet()) {
    throw DYNError(Error::MODELER, VariableCardinalityNotSet, getName(), getCardinalityName());
  }

  return cardinality_.value();
}

int
VariableMultiple::getIndex() const {
  throw DYNError(Error::MODELER, VariableMultipleHasNoIndex, getName());
}

}  // namespace DYN
