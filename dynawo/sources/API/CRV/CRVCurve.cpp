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
 * @file  CRVCurve.cpp
 *
 * @brief Dynawo Curve : implementation file
 *
 */
#include "CRVCurve.h"

#include "CRVPoint.h"
#include "CRVPointFactory.h"

#include <iostream>
#include <limits>

using std::string;

namespace curves {

Curve::Curve::Curve() :
      modelName_(""),
      variable_(""),
      foundName_(""),
      available_(false),
      negated_(false),
      buffer_(NULL),
      isParameterCurve_(false),
      curveType_(UNDEFINED),
      indexInGlobalTable_(std::numeric_limits<size_t>::max()),
      exportType_(EXPORT_AS_CURVE) {}

void
Curve::update(const double& time) {
  if (available_) {
    if (!isParameterCurve_) {  // this is a variable curve
      double value = buffer_[0];
      if (negated_)
        value = -1 * value;

      std::unique_ptr<Point> point = PointFactory::newPoint(time, value);
      if (exportType_ == EXPORT_AS_CURVE || exportType_ == EXPORT_AS_BOTH || points_.empty()) {
        points_.push_back(std::move(point));
      } else {
        points_.back() = std::move(point);
      }
    } else {  // this is a parameter curve
              // we set the value of parameter curve to zero during the simulation
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
Curve::updateParameterCurveValue(std::string /*parameterName*/, double parameterValue) {
  for (std::vector<std::unique_ptr<Point> >::iterator it = points_.begin(); it != points_.end(); ++it) {
    (*it)->setValue(parameterValue);
  }
}

std::unique_ptr<Point>
Curve::getLastPoint() const {
  if (points_.size() >= 0)
    return PointFactory::newPoint(points_.back()->getTime(), points_.back()->getValue());
  else
    return std::unique_ptr<Point>(nullptr);
}

void
Curve::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Curve::setVariable(const string& variable) {
  variable_ = variable;
}

void
Curve::setFoundVariableName(const string& name) {
  foundName_ = name;
}

void
Curve::setAvailable(bool isAvailable) {
  available_ = isAvailable;
}

void
Curve::setNegated(bool negated) {
  negated_ = negated;
}

void
Curve::setBuffer(const double* buffer) {
  buffer_ = buffer;
}

void
Curve::setExportType(ExportType_t value) {
  exportType_ = value;
}

void
Curve::setGlobalIndex(size_t index) {
  indexInGlobalTable_ = index;
}

size_t
Curve::getGlobalIndex() {
  return indexInGlobalTable_;
}

const string&
Curve::getModelName() const {
  return modelName_;
}

const string&
Curve::getVariable() const {
  return variable_;
}

const string&
Curve::getFoundVariableName() const {
  return foundName_;
}

bool
Curve::getAvailable() const {
  return available_;
}

bool
Curve::getNegated() const {
  return negated_;
}

const double*
Curve::getBuffer() const {
  return buffer_;
}

Curve::const_iterator
Curve::cbegin() const {
  return Curve::const_iterator(this, true);
}

Curve::const_iterator
Curve::cend() const {
  return Curve::const_iterator(this, false);
}

Curve::const_iterator
Curve::at(int i) const {
  return Curve::const_iterator(this, true, i);
}

Curve::const_iterator::const_iterator(const Curve* iterated, bool begin, int i) {
  if (begin)
    current_ = iterated->points_.begin() + i;
  else
    current_ = iterated->points_.end() - i;
}

Curve::const_iterator::const_iterator(const Curve* iterated, bool begin) : current_((begin ? iterated->points_.begin() : iterated->points_.end())) {}

Curve::const_iterator&
Curve::const_iterator::operator++() {
  ++current_;
  return *this;
}

Curve::const_iterator
Curve::const_iterator::operator++(int) {
  Curve::const_iterator previous = *this;
  current_++;
  return previous;
}

Curve::const_iterator&
Curve::const_iterator::operator--() {
  --current_;
  return *this;
}

Curve::const_iterator
Curve::const_iterator::operator--(int) {
  Curve::const_iterator previous = *this;
  current_--;
  return previous;
}

bool
Curve::const_iterator::operator==(const Curve::const_iterator& other) const {
  return current_ == other.current_;
}

bool
Curve::const_iterator::operator!=(const Curve::const_iterator& other) const {
  return current_ != other.current_;
}

const std::unique_ptr<Point>& Curve::const_iterator::operator*() const {
  return *current_;
}

const std::unique_ptr<Point>* Curve::const_iterator::operator->() const {
  return &(*current_);
}

}  // namespace curves
