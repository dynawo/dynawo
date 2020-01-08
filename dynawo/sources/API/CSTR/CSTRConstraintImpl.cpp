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

Constraint::Impl::Impl() :
time_(0.),
type_(CONSTRAINT_UNDEFINED) {
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
Constraint::Impl::setModelType(const string& modelType) {
  modelType_ = modelType;
}

void
Constraint::Impl::setSide(const string& side) {
  side_ = side;
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

string
Constraint::Impl::getModelType() const {
  return modelType_;
}

bool
Constraint::Impl::hasModelType() const {
  return !modelType_.empty();
}

string
Constraint::Impl::getSide() const {
  return side_;
}

bool
Constraint::Impl::hasSide() const {
  return !side_.empty();
}

Type_t
Constraint::Impl::getType() const {
  return type_;
}

}  // namespace constraints
