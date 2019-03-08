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
 * @brief Curves collection : implementation for iterator
 *
 */
#include "CRVCurvesCollection.h"
#include "CRVCurvesCollectionImpl.h"

using boost::shared_ptr;

namespace curves {

CurvesCollection::const_iterator::const_iterator(const CurvesCollection::Impl* iterated, bool begin) {
  impl_ = new BaseConstIteratorImpl(iterated, begin);
}

CurvesCollection::const_iterator::const_iterator(const CurvesCollection::const_iterator& original) {
  impl_ = new BaseConstIteratorImpl(*(original.impl_));
}

CurvesCollection::const_iterator::const_iterator(const CurvesCollection::iterator& original) {
  impl_ = new BaseConstIteratorImpl(*(original.impl()));
}

CurvesCollection::const_iterator::~const_iterator() {
  delete impl_;
  impl_ = NULL;
}

CurvesCollection::const_iterator&
CurvesCollection::const_iterator::operator=(const CurvesCollection::const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new BaseConstIteratorImpl(*(other.impl_));
  return *this;
}

CurvesCollection::const_iterator&
CurvesCollection::const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

CurvesCollection::const_iterator
CurvesCollection::const_iterator::operator++(int) {
  CurvesCollection::const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

CurvesCollection::const_iterator&
CurvesCollection::const_iterator::operator--() {
  --(*impl_);
  return *this;
}

CurvesCollection::const_iterator
CurvesCollection::const_iterator::operator--(int) {
  CurvesCollection::const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
CurvesCollection::const_iterator::operator==(const CurvesCollection::const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
CurvesCollection::const_iterator::operator!=(const CurvesCollection::const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Curve>&
CurvesCollection::const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Curve>*
CurvesCollection::const_iterator::operator->() const {
  return impl_->operator->();
}

CurvesCollection::iterator::iterator(CurvesCollection::Impl* iterated, bool begin) {
  impl_ = new BaseIteratorImpl(iterated, begin);
}

CurvesCollection::iterator::iterator(const CurvesCollection::iterator& original) {
  impl_ = new BaseIteratorImpl(*(original.impl_));
}

CurvesCollection::iterator::~iterator() {
  delete impl_;
  impl_ = NULL;
}

CurvesCollection::iterator&
CurvesCollection::iterator::operator=(const CurvesCollection::iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new BaseIteratorImpl(*(other.impl_));
  return *this;
}

CurvesCollection::iterator&
CurvesCollection::iterator::operator++() {
  ++(*impl_);
  return *this;
}

CurvesCollection::iterator
CurvesCollection::iterator::operator++(int) {
  CurvesCollection::iterator previous = *this;
  (*impl_)++;
  return previous;
}

CurvesCollection::iterator&
CurvesCollection::iterator::operator--() {
  --(*impl_);
  return *this;
}

CurvesCollection::iterator
CurvesCollection::iterator::operator--(int) {
  CurvesCollection::iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
CurvesCollection::iterator::operator==(const CurvesCollection::iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
CurvesCollection::iterator::operator!=(const CurvesCollection::iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<Curve>&
CurvesCollection::iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<Curve>*
CurvesCollection::iterator::operator->() const {
  return impl_->operator->();
}

CurvesCollection::BaseIteratorImpl*
CurvesCollection::iterator::impl() const {
  return impl_;
}

}  // namespace curves


