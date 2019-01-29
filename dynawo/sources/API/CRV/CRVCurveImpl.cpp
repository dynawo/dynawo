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
 * @file  CRVCurveImpl.cpp
 *
 * @brief Dynawo Curve : implementation file
 *
 */
#include <iostream>

#include "CRVCurveImpl.h"
#include "CRVPoint.h"
#include "CRVPointFactory.h"

using std::string;
using boost::shared_ptr;

namespace curves {

Curve::Impl::Impl() :
modelName_(""),
variable_(""),
foundName_(""),
available_(false),
negated_(false),
buffer_(NULL),
isParameterCurve_(false),
isCalculatedVariableCurve_(false) {
}

Curve::Impl::~Impl() {
}

void
Curve::Impl::update(const double& time) {
  if (available_) {
    if (!isParameterCurve_) {   // this is a variable curve
      double value = buffer_[0];
      if (negated_)
        value = -1 * value;

      boost::shared_ptr<Point> point = PointFactory::newPoint(time, value);
      points_.push_back(point);
    } else {   // this is a parameter curve
       // we set the value of parameter curve to zero during the simulation
       // and update the value at the end of simulation.
      double value(0);
      boost::shared_ptr<Point> point = PointFactory::newPoint(time, value);
      points_.push_back(point);
    }
  }
}

void
Curve::Impl::updateParameterCurveValue(std::string /*parameterName*/, double parameterValue) {
  for (std::vector<boost::shared_ptr<Point> >::iterator it = points_.begin(); it != points_.end(); ++it) {
    (*it)->setValue(parameterValue);
  }
}

void
Curve::Impl::setModelName(const string& modelName) {
  modelName_ = modelName;
}

void
Curve::Impl::setVariable(const string& variable) {
  variable_ = variable;
}

void
Curve::Impl::setFoundVariableName(const string& name) {
  foundName_ = name;
}

void
Curve::Impl::setAvailable(bool isAvailable) {
  available_ = isAvailable;
}

void
Curve::Impl::setNegated(bool negated) {
  negated_ = negated;
}

void
Curve::Impl::setBuffer(double* buffer) {
  buffer_ = buffer;
}

string
Curve::Impl::getModelName() const {
  return modelName_;
}

string
Curve::Impl::getVariable() const {
  return variable_;
}

string
Curve::Impl::getFoundVariableName() const {
  return foundName_;
}

bool
Curve::Impl::getAvailable() const {
  return available_;
}

bool
Curve::Impl::getNegated() const {
  return negated_;
}

double*
Curve::Impl::getBuffer() const {
  return buffer_;
}

Curve::const_iterator
Curve::Impl::cbegin() const {
  return Curve::const_iterator(this, true);
}

Curve::const_iterator
Curve::Impl::cend() const {
  return Curve::const_iterator(this, false);
}

Curve::const_iterator
Curve::Impl::at(int i) const {
  return Curve::const_iterator(this, true, i);
}

Curve::BaseConstIteratorImpl::BaseConstIteratorImpl(const Curve::Impl* iterated, bool begin, int i) {
  if (begin)
    current_ = iterated->points_.begin() + i;
  else
    current_ = iterated->points_.end() - i;
}

Curve::BaseConstIteratorImpl::BaseConstIteratorImpl(const Curve::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->points_.begin() : iterated->points_.end());
}

Curve::BaseConstIteratorImpl::~BaseConstIteratorImpl() {
}

Curve::BaseConstIteratorImpl&
Curve::BaseConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

Curve::BaseConstIteratorImpl
Curve::BaseConstIteratorImpl::operator++(int) {
  Curve::BaseConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

Curve::BaseConstIteratorImpl&
Curve::BaseConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

Curve::BaseConstIteratorImpl
Curve::BaseConstIteratorImpl::operator--(int) {
  Curve::BaseConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
Curve::BaseConstIteratorImpl::operator==(const Curve::BaseConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
Curve::BaseConstIteratorImpl::operator!=(const Curve::BaseConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Point>&
Curve::BaseConstIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<Point>*
Curve::BaseConstIteratorImpl::operator->() const {
  return &(*current_);
}


}  // namespace curves

