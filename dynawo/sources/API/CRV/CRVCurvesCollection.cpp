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
 * @file  CRVCurvesCollection.cpp
 *
 * @brief Curves collection : implementation file
 *
 */
#include "CRVCurvesCollection.h"
#include "CRVCurve.h"

using std::string;
using std::vector;
using boost::shared_ptr;

namespace curves {

CurvesCollection::CurvesCollection(const string& id) :
id_(id) {
}

void
CurvesCollection::add(const shared_ptr<Curve>& curve) {
  curves_.push_back(curve);
}

void
CurvesCollection::updateCurves(const double& time) {
  for (CurvesCollection::iterator iter = begin();
          iter != end();
          ++iter) {
    (*iter)->update(time);
  }
}

CurvesCollection::const_iterator
CurvesCollection::cbegin() const {
  return CurvesCollection::const_iterator(this, true);
}

CurvesCollection::const_iterator
CurvesCollection::cend() const {
  return CurvesCollection::const_iterator(this, false);
}

CurvesCollection::const_iterator::const_iterator(const CurvesCollection* iterated, bool begin) :
current_((begin ? iterated->curves_.begin() : iterated->curves_.end())) { }

CurvesCollection::const_iterator&
CurvesCollection::const_iterator::operator++() {
  ++current_;
  return *this;
}

CurvesCollection::const_iterator
CurvesCollection::const_iterator::operator++(int) {
  CurvesCollection::const_iterator previous = *this;
  current_++;
  return previous;
}

CurvesCollection::const_iterator&
CurvesCollection::const_iterator::operator--() {
  --current_;
  return *this;
}

CurvesCollection::const_iterator
CurvesCollection::const_iterator::operator--(int) {
  CurvesCollection::const_iterator previous = *this;
  current_--;
  return previous;
}

bool
CurvesCollection::const_iterator::operator==(const CurvesCollection::const_iterator& other) const {
  return current_ == other.current_;
}

bool
CurvesCollection::const_iterator::operator!=(const CurvesCollection::const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Curve>&
CurvesCollection::const_iterator::operator*() const {
  return *current_;
}

const shared_ptr<Curve>*
CurvesCollection::const_iterator::operator->() const {
  return &(*current_);
}

CurvesCollection::iterator
CurvesCollection::begin() {
  return CurvesCollection::iterator(this, true);
}

CurvesCollection::iterator
CurvesCollection::end() {
  return CurvesCollection::iterator(this, false);
}

CurvesCollection::iterator::iterator(CurvesCollection* iterated, bool begin) :
current_((begin ? iterated->curves_.begin() : iterated->curves_.end())) { }

CurvesCollection::iterator&
CurvesCollection::iterator::operator++() {
  ++current_;
  return *this;
}

CurvesCollection::iterator
CurvesCollection::iterator::operator++(int) {
  CurvesCollection::iterator previous = *this;
  current_++;
  return previous;
}

CurvesCollection::iterator&
CurvesCollection::iterator::operator--() {
  --current_;
  return *this;
}

CurvesCollection::iterator
CurvesCollection::iterator::operator--(int) {
  CurvesCollection::iterator previous = *this;
  current_--;
  return previous;
}

bool
CurvesCollection::iterator::operator==(const CurvesCollection::iterator& other) const {
  return current_ == other.current_;
}

bool
CurvesCollection::iterator::operator!=(const CurvesCollection::iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<Curve>&
CurvesCollection::iterator::operator*() const {
  return *current_;
}

shared_ptr<Curve>*
CurvesCollection::iterator::operator->() const {
  return &(*current_);
}

}  // namespace curves
