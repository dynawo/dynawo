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
 * @file  FSFinalStateCollectionImpl.cpp
 *
 * @brief Final state collection : implementation file
 *
 */
#include "FSFinalStateCollectionImpl.h"
#include "FSIterators.h"
#include "FSModel.h"

using std::string;
using boost::shared_ptr;

namespace finalState {

FinalStateCollection::Impl::Impl(const string& id) :
id_(id) {
}

FinalStateCollection::Impl::~Impl() {
}

void
FinalStateCollection::Impl::addModel(const shared_ptr<Model>& model) {
  models_.push_back(model);
}

void
FinalStateCollection::Impl::addVariable(const shared_ptr<Variable>& variable) {
  variables_.push_back(variable);
}

model_const_iterator
FinalStateCollection::Impl::cbeginModel() const {
  return model_const_iterator(this, true);
}

model_const_iterator
FinalStateCollection::Impl::cendModel() const {
  return model_const_iterator(this, false);
}

variable_const_iterator
FinalStateCollection::Impl::cbeginVariable() const {
  return variable_const_iterator(this, true);
}

variable_const_iterator
FinalStateCollection::Impl::cendVariable() const {
  return variable_const_iterator(this, false);
}

model_iterator
FinalStateCollection::Impl::beginModel() {
  return model_iterator(this, true);
}

model_iterator
FinalStateCollection::Impl::endModel() {
  return model_iterator(this, false);
}

variable_iterator
FinalStateCollection::Impl::beginVariable() {
  return variable_iterator(this, true);
}

variable_iterator
FinalStateCollection::Impl::endVariable() {
  return variable_iterator(this, false);
}
}  // namespace finalState



