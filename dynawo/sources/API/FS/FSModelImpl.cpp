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
 * @file  FSModelImpl.cpp
 *
 * @brief final state model : implementation file
 *
 */
#include "FSModelImpl.h"
#include "FSIterators.h"

using std::string;
using boost::shared_ptr;

namespace finalState {

FinalStateModel::Impl::Impl(const string& id) :
id_(id) {
}

FinalStateModel::Impl::~Impl() {
}

void
FinalStateModel::Impl::setId(const string& id) {
  id_ = id;
}

string
FinalStateModel::Impl::getId() const {
  return id_;
}

void
FinalStateModel::Impl::addSubModel(const shared_ptr<FinalStateModel>& model) {
  subModels_.push_back(model);
}

void
FinalStateModel::Impl::addVariable(const shared_ptr<Variable>& variable) {
  variables_.push_back(variable);
}

finalStateModel_const_iterator
FinalStateModel::Impl::cbeginFinalStateModel() const {
  return finalStateModel_const_iterator(this, true);
}

finalStateModel_const_iterator
FinalStateModel::Impl::cendFinalStateModel() const {
  return finalStateModel_const_iterator(this, false);
}

finalStateVariable_const_iterator
FinalStateModel::Impl::cbeginVariable() const {
  return finalStateVariable_const_iterator(this, true);
}

finalStateVariable_const_iterator
FinalStateModel::Impl::cendVariable() const {
  return finalStateVariable_const_iterator(this, false);
}

finalStateModel_iterator
FinalStateModel::Impl::beginFinalStateModel() {
  return finalStateModel_iterator(this, true);
}

finalStateModel_iterator
FinalStateModel::Impl::endFinalStateModel() {
  return finalStateModel_iterator(this, false);
}

finalStateVariable_iterator
FinalStateModel::Impl::beginVariable() {
  return finalStateVariable_iterator(this, true);
}

finalStateVariable_iterator
FinalStateModel::Impl::endVariable() {
  return finalStateVariable_iterator(this, false);
}

}  // namespace finalState
