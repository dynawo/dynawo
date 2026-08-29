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
 * @file  CSTRConstraint.cpp
 *
 * @brief Dynawo constraint : implementation file
 *
 */
#include "CSTRConstraint.h"

using std::string;

namespace constraints {

Constraint::Constraint() :
time_(0.),
type_(CONSTRAINT_UNDEFINED) {
}

void
Constraint::setTime(const double& time) {
  time_ = time;
}

void
Constraint::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Constraint::setModelType(const string& modelType) {
  modelType_ = modelType;
}

void
Constraint::setType(const Type_t& type) {
  type_ = type;
}

void
Constraint::setDescription(const string& description) {
  description_ = description;
}

void
Constraint::setData(const boost::optional<ConstraintData>& data) {
  data_ = data;
}

double
Constraint::getTime() const {
  return time_;
}

const string&
Constraint::getModelName() const {
  return modelName_;
}

const string&
Constraint::getDescription() const {
  return description_;
}

const string&
Constraint::getModelType() const {
  return modelType_;
}

bool
Constraint::hasModelType() const {
  return !modelType_.empty();
}

Type_t
Constraint::getType() const {
  return type_;
}

boost::optional<ConstraintData>
Constraint::getData() const {
  return data_;
}

}  // namespace constraints
