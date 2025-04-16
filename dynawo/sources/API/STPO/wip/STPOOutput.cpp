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
 * @file  STPOOutput.cpp
 *
 * @brief Dynawo Output : implementation file
 *
 */
#include "STPOOutput.h"

#include <iostream>
#include <limits>

using std::string;

namespace stepOutputs {

std::unique_ptr<Output>
OutputFactory::newOutput() {
  return DYN::make_unique<Output>();
}

Output::Output::Output() :
      modelName_(""),
      variable_(""),
      available_(false),
      negated_(false),
      buffer_(NULL),
      outputType_(UNDEFINED),
      indexInGlobalTable_(std::numeric_limits<size_t>::max()) {}

double
Output::getValue() {
  // should check for availability first
  double value = buffer_[0];
  if (negated_)
    return  -1 * value;
  else
    return value;
}

void
Output::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Output::setVariable(const string& variable) {
  variable_ = variable;
}

// void
// Output::setFoundVariableName(const string& name) {
//   foundName_ = name;
// }

void
Output::setAvailable(bool isAvailable) {
  available_ = isAvailable;
}

void
Output::setNegated(bool negated) {
  negated_ = negated;
}

void
Output::setBuffer(const double* buffer) {
  buffer_ = buffer;
}

void
Output::setGlobalIndex(size_t index) {
  indexInGlobalTable_ = index;
}

size_t
Output::getGlobalIndex() {
  return indexInGlobalTable_;
}

const string&
Output::getModelName() const {
  return modelName_;
}

const string&
Output::getVariable() const {
  return variable_;
}

const string&
Output::getFoundVariableName() const {
  return foundName_;
}

bool
Output::getAvailable() const {
  return available_;
}

bool
Output::getNegated() const {
  return negated_;
}

const double*
Output::getBuffer() const {
  return buffer_;
}

}  // namespace stepOutputs
