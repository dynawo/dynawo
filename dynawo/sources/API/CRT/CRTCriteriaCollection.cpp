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

#include "CRTCriteriaCollection.h"

using std::shared_ptr;

namespace criteria {

void
CriteriaCollection::add(CriteriaCollectionType_t type, const std::shared_ptr<Criteria>& criteria) {
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
CriteriaCollection::merge(const std::shared_ptr<CriteriaCollection>& other) {
  std::shared_ptr<CriteriaCollection> otherImpl = std::dynamic_pointer_cast<CriteriaCollection>(other);
  if (!otherImpl) return;
  busCriteria_.insert(busCriteria_.end(), otherImpl->busCriteria_.begin(), otherImpl->busCriteria_.end());
  loadCriteria_.insert(loadCriteria_.end(), otherImpl->loadCriteria_.begin(), otherImpl->loadCriteria_.end());
  generatorCriteria_.insert(generatorCriteria_.end(), otherImpl->generatorCriteria_.begin(), otherImpl->generatorCriteria_.end());
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::begin(CriteriaCollectionType_t type) const {
  return CriteriaCollection::CriteriaCollectionConstIterator(this, true, type);
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::end(CriteriaCollectionType_t type) const {
  return CriteriaCollection::CriteriaCollectionConstIterator(this, false, type);
}

CriteriaCollection::CriteriaCollectionConstIterator::CriteriaCollectionConstIterator(
    const CriteriaCollection* iterated, bool begin, CriteriaCollectionType_t type) {
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

CriteriaCollection::CriteriaCollectionConstIterator&
CriteriaCollection::CriteriaCollectionConstIterator::operator++() {
  ++current_;
  return *this;
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::CriteriaCollectionConstIterator::operator++(int) {
  CriteriaCollection::CriteriaCollectionConstIterator previous = *this;
  current_++;
  return previous;
}

CriteriaCollection::CriteriaCollectionConstIterator&
CriteriaCollection::CriteriaCollectionConstIterator::operator--() {
  --current_;
  return *this;
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::CriteriaCollectionConstIterator::operator--(int) {
  CriteriaCollection::CriteriaCollectionConstIterator previous = *this;
  current_--;
  return previous;
}

bool
CriteriaCollection::CriteriaCollectionConstIterator::operator==(const CriteriaCollection::CriteriaCollectionConstIterator& other) const {
  return current_ == other.current_;
}

bool
CriteriaCollection::CriteriaCollectionConstIterator::operator!=(const CriteriaCollection::CriteriaCollectionConstIterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Criteria>&
CriteriaCollection::CriteriaCollectionConstIterator::operator*() const {
  return *current_;
}

const shared_ptr<Criteria>*
CriteriaCollection::CriteriaCollectionConstIterator::operator->() const {
  return &(*current_);
}

}  // namespace criteria
