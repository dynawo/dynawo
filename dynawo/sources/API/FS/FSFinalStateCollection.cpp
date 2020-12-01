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
 * @file  FSFinalStateCollection.cpp
 *
 * @brief Final state collection : implementation file
 *
 */
#include "FSFinalStateCollection.h"
#include "FSIterators.h"
#include "FSModel.h"

using std::string;
using boost::shared_ptr;

namespace finalState {

FinalStateCollection::FinalStateCollection(const string& id) :
id_(id) {
}

void
FinalStateCollection::addFinalStateModel(const shared_ptr<FinalStateModel>& model) {
  models_.push_back(model);
}

void
FinalStateCollection::addVariable(const shared_ptr<Variable>& variable) {
  variables_.push_back(variable);
}

finalStateModel_const_iterator
FinalStateCollection::cbeginFinalStateModel() const {
  return finalStateModel_const_iterator(this, true);
}

finalStateModel_const_iterator
FinalStateCollection::cendFinalStateModel() const {
  return finalStateModel_const_iterator(this, false);
}

finalStateVariable_const_iterator
FinalStateCollection::cbeginVariable() const {
  return finalStateVariable_const_iterator(this, true);
}

finalStateVariable_const_iterator
FinalStateCollection::cendVariable() const {
  return finalStateVariable_const_iterator(this, false);
}

finalStateModel_iterator
FinalStateCollection::beginFinalStateModel() {
  return finalStateModel_iterator(this, true);
}

finalStateModel_iterator
FinalStateCollection::endFinalStateModel() {
  return finalStateModel_iterator(this, false);
}

finalStateVariable_iterator
FinalStateCollection::beginVariable() {
  return finalStateVariable_iterator(this, true);
}

finalStateVariable_iterator
FinalStateCollection::endVariable() {
  return finalStateVariable_iterator(this, false);
}
}  // namespace finalState
