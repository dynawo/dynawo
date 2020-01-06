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
 * @file  CRVCurvesCollectionImpl.cpp
 *
 * @brief Curves collection : implementation file
 *
 */
#include "CRVCurvesCollectionImpl.h"
#include "CRVCurveImpl.h"

using std::string;
using std::vector;
using boost::shared_ptr;

namespace curves {

CurvesCollection::Impl::Impl(const string& id) :
id_(id) {
}

CurvesCollection::Impl::~Impl() {
}

void
CurvesCollection::Impl::add(const shared_ptr<Curve>& curve) {
  curves_.push_back(curve);
}

void
CurvesCollection::Impl::updateCurves(const double& time) {
  for (CurvesCollection::iterator iter = begin();
          iter != end();
          ++iter) {
    (*iter)->update(time);
  }
}

CurvesCollection::const_iterator
CurvesCollection::Impl::cbegin() const {
  return CurvesCollection::const_iterator(this, true);
}

CurvesCollection::const_iterator
CurvesCollection::Impl::cend() const {
  return CurvesCollection::const_iterator(this, false);
}

CurvesCollection::BaseConstIteratorImpl::BaseConstIteratorImpl(const CurvesCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->curves_.begin() : iterated->curves_.end())) { }

CurvesCollection::BaseConstIteratorImpl::~BaseConstIteratorImpl() {
}

CurvesCollection::BaseConstIteratorImpl::BaseConstIteratorImpl(const BaseIteratorImpl& iterator) :
current_(iterator.current()) { }

CurvesCollection::BaseConstIteratorImpl&
CurvesCollection::BaseConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

CurvesCollection::BaseConstIteratorImpl
CurvesCollection::BaseConstIteratorImpl::operator++(int) {
  CurvesCollection::BaseConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

CurvesCollection::BaseConstIteratorImpl&
CurvesCollection::BaseConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

CurvesCollection::BaseConstIteratorImpl
CurvesCollection::BaseConstIteratorImpl::operator--(int) {
  CurvesCollection::BaseConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
CurvesCollection::BaseConstIteratorImpl::operator==(const CurvesCollection::BaseConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
CurvesCollection::BaseConstIteratorImpl::operator!=(const CurvesCollection::BaseConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Curve>&
CurvesCollection::BaseConstIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<Curve>*
CurvesCollection::BaseConstIteratorImpl::operator->() const {
  return &(*current_);
}

CurvesCollection::iterator
CurvesCollection::Impl::begin() {
  return CurvesCollection::iterator(this, true);
}

CurvesCollection::iterator
CurvesCollection::Impl::end() {
  return CurvesCollection::iterator(this, false);
}

CurvesCollection::BaseIteratorImpl::BaseIteratorImpl(CurvesCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->curves_.begin() : iterated->curves_.end())) { }

CurvesCollection::BaseIteratorImpl::~BaseIteratorImpl() {
}

CurvesCollection::BaseIteratorImpl&
CurvesCollection::BaseIteratorImpl::operator++() {
  ++current_;
  return *this;
}

CurvesCollection::BaseIteratorImpl
CurvesCollection::BaseIteratorImpl::operator++(int) {
  CurvesCollection::BaseIteratorImpl previous = *this;
  current_++;
  return previous;
}

CurvesCollection::BaseIteratorImpl&
CurvesCollection::BaseIteratorImpl::operator--() {
  --current_;
  return *this;
}

CurvesCollection::BaseIteratorImpl
CurvesCollection::BaseIteratorImpl::operator--(int) {
  CurvesCollection::BaseIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
CurvesCollection::BaseIteratorImpl::operator==(const CurvesCollection::BaseIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
CurvesCollection::BaseIteratorImpl::operator!=(const CurvesCollection::BaseIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<Curve>&
CurvesCollection::BaseIteratorImpl::operator*() const {
  return *current_;
}

shared_ptr<Curve>*
CurvesCollection::BaseIteratorImpl::operator->() const {
  return &(*current_);
}

vector<shared_ptr<Curve> >::iterator
CurvesCollection::BaseIteratorImpl::current() const {
  return current_;
}

}  // namespace curves
