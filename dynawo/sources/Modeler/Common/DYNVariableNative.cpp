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
 * @file  DYNVariableNative.cpp
 *
 * @brief Dynawo native variable : implementation file
 *
 */
#include "DYNMacrosMessage.h"

#include "DYNVariableNative.h"

using std::string;

namespace DYN {

VariableNative::VariableNative(const string& name, const typeVar_t type, const bool isState, const bool negated) :
Variable(name, false),
type_(type),
isState_(isState),
negated_(negated) {
}

void
VariableNative::setIndex(const int index) {
  if (indexSet()) {
    throw DYNError(Error::MODELER, VariableNativeIndexAlreadySet, getName());
  }
  index_ = index;
}

bool
VariableNative::isState() const {
  return isState_;
}

bool
VariableNative::indexSet() const {
  if (index_)
    return true;
  else
    return false;
}

int
VariableNative::getIndex() const {
  if (!indexSet()) {
    throw DYNError(Error::MODELER, VariableNativeIndexNotSet, getName());
  }
  return index_.value();
}

}  // namespace DYN
