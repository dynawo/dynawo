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

#include "STPOPoint.h"
#include "STPOPointFactory.h"

#include <iostream>
#include <limits>

using std::string;

namespace stepOutputs {

Output::Output::Output() :
      modelName_(""),
      variable_(""),
      foundName_(""),
      available_(false),
      negated_(false),
      buffer_(NULL),
      isParameterOutput_(false),
      outputType_(UNDEFINED),
      indexInGlobalTable_(std::numeric_limits<size_t>::max()),
      exportType_(EXPORT_AS_CURVE) {}

void
Output::update(const double& time) {
  if (available_) {
    if (!isParameterOutput_) {  // this is a variable output
      double value = buffer_[0];
      if (negated_)
        value = -1 * value;

      std::unique_ptr<Point> point = PointFactory::newPoint(time, value);
      if (exportType_ == EXPORT_AS_CURVE || exportType_ == EXPORT_AS_BOTH || points_.empty()) {
        points_.push_back(std::move(point));
      } else {
        points_.back() = std::move(point);
      }
    } else {  // this is a parameter output
              // we set the value of parameter output to zero during the simulation
              // and update the value at the end of simulation.
      double value(0);
      std::unique_ptr<Point> point = PointFactory::newPoint(time, value);
      if (exportType_ == EXPORT_AS_CURVE || exportType_ == EXPORT_AS_BOTH || points_.empty()) {
        points_.push_back(std::move(point));
      } else {
        points_.back() = std::move(point);
      }
    }
  }
}

void
Output::updateParameterOutputValue(std::string /*parameterName*/, double parameterValue) {
  for (std::vector<std::unique_ptr<Point> >::iterator it = points_.begin(); it != points_.end(); ++it) {
    (*it)->setValue(parameterValue);
  }
}

std::unique_ptr<Point>
Output::getLastPoint() const {
  if (points_.size() > 0)
    return PointFactory::newPoint(points_.back()->getTime(), points_.back()->getValue());
  else
    return std::unique_ptr<Point>(nullptr);
}

void
Output::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Output::setVariable(const string& variable) {
  variable_ = variable;
}

void
Output::setAlias(const string& alias) {
  alias_ = alias;
}

void
Output::setFoundVariableName(const string& name) {
  foundName_ = name;
}

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
Output::setExportType(ExportType_t value) {
  exportType_ = value;
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
Output::getAlias() const {
  return alias_;
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

Output::const_iterator
Output::cbegin() const {
  return Output::const_iterator(this, true);
}

Output::const_iterator
Output::cend() const {
  return Output::const_iterator(this, false);
}

Output::const_iterator
Output::at(int i) const {
  return Output::const_iterator(this, true, i);
}

Output::const_iterator::const_iterator(const Output* iterated, bool begin, int i) {
  if (begin)
    current_ = iterated->points_.begin() + i;
  else
    current_ = iterated->points_.end() - i;
}

Output::const_iterator::const_iterator(const Output* iterated, bool begin) : current_((begin ? iterated->points_.begin() : iterated->points_.end())) {}

Output::const_iterator&
Output::const_iterator::operator++() {
  ++current_;
  return *this;
}

Output::const_iterator
Output::const_iterator::operator++(int) {
  Output::const_iterator previous = *this;
  current_++;
  return previous;
}

Output::const_iterator&
Output::const_iterator::operator--() {
  --current_;
  return *this;
}

Output::const_iterator
Output::const_iterator::operator--(int) {
  Output::const_iterator previous = *this;
  current_--;
  return previous;
}

bool
Output::const_iterator::operator==(const Output::const_iterator& other) const {
  return current_ == other.current_;
}

bool
Output::const_iterator::operator!=(const Output::const_iterator& other) const {
  return current_ != other.current_;
}

const std::unique_ptr<Point>& Output::const_iterator::operator*() const {
  return *current_;
}

const std::unique_ptr<Point>* Output::const_iterator::operator->() const {
  return &(*current_);
}

}  // namespace stepOutputs
