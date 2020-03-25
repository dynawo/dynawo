//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  CRTCriteriaCollectionImpl.cpp
 *
 * @brief Criteria collection : implementation file
 *
 */
#include "CRTCriteriaCollectionImpl.h"

using std::string;
using std::vector;
using boost::shared_ptr;

namespace criteria {

void
CriteriaCollection::Impl::add(CriteriaCollectionType_t type, const boost::shared_ptr<Criteria> & criteria) {
  switch (type) {
  case CriteriaCollection::BUS:
    busCriteria_.push_back(criteria);
    break;
  case CriteriaCollection::LOAD:
    loadCriteria_.push_back(criteria);
    break;
  case CriteriaCollection::GENERATOR:
    generatorCriteria_.push_back(criteria);
    break;
  }
}

void
CriteriaCollection::Impl::merge(const boost::shared_ptr<CriteriaCollection> & other) {
  boost::shared_ptr<CriteriaCollection::Impl> otherImpl = boost::dynamic_pointer_cast<CriteriaCollection::Impl>(other);
  if (!otherImpl) return;
  busCriteria_.insert(busCriteria_.end(), otherImpl->busCriteria_.begin(), otherImpl->busCriteria_.end());
  loadCriteria_.insert(loadCriteria_.end(), otherImpl->loadCriteria_.begin(), otherImpl->loadCriteria_.end());
  generatorCriteria_.insert(generatorCriteria_.end(), otherImpl->generatorCriteria_.begin(), otherImpl->generatorCriteria_.end());
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::Impl::begin(CriteriaCollectionType_t type) const {
  return CriteriaCollection::CriteriaCollectionConstIterator(this, true, type);
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::Impl::end(CriteriaCollectionType_t type) const {
  return CriteriaCollection::CriteriaCollectionConstIterator(this, false, type);
}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::BaseConstCriteriaCollectionIteratorImpl(
    const CriteriaCollection::Impl* iterated, bool begin, CriteriaCollectionType_t type) {
  switch (type) {
  case CriteriaCollection::BUS:
    current_ = (begin ? iterated->busCriteria_.begin() : iterated->busCriteria_.end());
    break;
  case CriteriaCollection::LOAD:
    current_ = (begin ? iterated->loadCriteria_.begin() : iterated->loadCriteria_.end());
    break;
  case CriteriaCollection::GENERATOR:
    current_ = (begin ? iterated->generatorCriteria_.begin() : iterated->generatorCriteria_.end());
    break;
  }
}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::BaseConstCriteriaCollectionIteratorImpl(
    const BaseConstCriteriaCollectionIteratorImpl& iterator) :
current_(iterator.current()) {}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl&
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator=(const BaseConstCriteriaCollectionIteratorImpl& other) {
  current_ = other.current_;
  return *this;
}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::~BaseConstCriteriaCollectionIteratorImpl() {
}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl&
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator++() {
  ++current_;
  return *this;
}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator++(int) {
  CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl previous = *this;
  current_++;
  return previous;
}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl&
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator--() {
  --current_;
  return *this;
}

CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator--(int) {
  CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator==(const CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator!=(const CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Criteria>&
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<Criteria>*
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::operator->() const {
  return &(*current_);
}


std::vector<boost::shared_ptr<Criteria> >::const_iterator
CriteriaCollection::BaseConstCriteriaCollectionIteratorImpl::current() const {
  return current_;
}

}  // namespace criteria
