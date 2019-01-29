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
 * @file  FSVariableImpl.cpp
 *
 * @brief final state variable : implementation file
 *
 */
#include "FSVariableImpl.h"

using std::string;

namespace finalState {

Variable::Impl::Impl(const string& id) :
id_(id),
value_(0),
available_(false) {
}

Variable::Impl::~Impl() {
}

void
Variable::Impl::setId(const string& id) {
  id_ = id;
}

void
Variable::Impl::setValue(const double& value) {
  value_ = value;
  available_ = true;
}

string
Variable::Impl::getId() const {
  return id_;
}

double
Variable::Impl::getValue() const {
  return value_;
}

bool
Variable::Impl::getAvailable() const {
  return available_;
}

}  // namespace finalState

