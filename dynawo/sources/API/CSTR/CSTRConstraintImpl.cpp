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
 * @file  CSTRConstraintImpl.cpp
 *
 * @brief Dynawo constraint : implementation file
 *
 */
#include "CSTRConstraintImpl.h"

using std::string;

namespace constraints {

Constraint::Impl::Impl() {
}

Constraint::Impl::~Impl() {
}

void
Constraint::Impl::setTime(const double& time) {
  time_ = time;
}

void
Constraint::Impl::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Constraint::Impl::setType(const Type_t& type) {
  type_ = type;
}

void
Constraint::Impl::setDescription(const string& description) {
  description_ = description;
}

double
Constraint::Impl::getTime() const {
  return time_;
}

string
Constraint::Impl::getModelName() const {
  return modelName_;
}

string
Constraint::Impl::getDescription() const {
  return description_;
}

Type_t
Constraint::Impl::getType() const {
  return type_;
}

}  // namespace constraints


