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

Model::Impl::Impl(const string& id) :
id_(id) {
}

Model::Impl::~Impl() {
}

void
Model::Impl::setId(const string& id) {
  id_ = id;
}

string
Model::Impl::getId() const {
  return id_;
}

void
Model::Impl::addSubModel(const shared_ptr<Model>& model) {
  subModels_.push_back(model);
}

void
Model::Impl::addVariable(const shared_ptr<Variable>& variable) {
  variables_.push_back(variable);
}

model_const_iterator
Model::Impl::cbeginModel() const {
  return model_const_iterator(this, true);
}

model_const_iterator
Model::Impl::cendModel() const {
  return model_const_iterator(this, false);
}

variable_const_iterator
Model::Impl::cbeginVariable() const {
  return variable_const_iterator(this, true);
}

variable_const_iterator
Model::Impl::cendVariable() const {
  return variable_const_iterator(this, false);
}

model_iterator
Model::Impl::beginModel() {
  return model_iterator(this, true);
}

model_iterator
Model::Impl::endModel() {
  return model_iterator(this, false);
}

variable_iterator
Model::Impl::beginVariable() {
  return variable_iterator(this, true);
}

variable_iterator
Model::Impl::endVariable() {
  return variable_iterator(this, false);
}

}  // namespace finalState
