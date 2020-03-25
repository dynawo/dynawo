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
#include "CRTCriteriaCollectionImpl.h"

using boost::shared_ptr;

namespace criteria {

CriteriaCollection::CriteriaCollectionConstIterator::CriteriaCollectionConstIterator(
    const CriteriaCollection::Impl* iterated, bool begin, CriteriaCollectionType_t type) :
impl_(new BaseConstCriteriaCollectionIteratorImpl(iterated, begin, type)) { }

CriteriaCollection::CriteriaCollectionConstIterator::CriteriaCollectionConstIterator(const CriteriaCollection::CriteriaCollectionConstIterator& original) :
impl_(new BaseConstCriteriaCollectionIteratorImpl(*(original.impl_))) { }

CriteriaCollection::CriteriaCollectionConstIterator::~CriteriaCollectionConstIterator() {
  delete impl_;
  impl_ = NULL;
}

CriteriaCollection::CriteriaCollectionConstIterator&
CriteriaCollection::CriteriaCollectionConstIterator::operator=(const CriteriaCollection::CriteriaCollectionConstIterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new BaseConstCriteriaCollectionIteratorImpl(*(other.impl_));
  return *this;
}

CriteriaCollection::CriteriaCollectionConstIterator&
CriteriaCollection::CriteriaCollectionConstIterator::operator++() {
  ++(*impl_);
  return *this;
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::CriteriaCollectionConstIterator::operator++(int) {
  CriteriaCollection::CriteriaCollectionConstIterator previous = *this;
  (*impl_)++;
  return previous;
}

CriteriaCollection::CriteriaCollectionConstIterator&
CriteriaCollection::CriteriaCollectionConstIterator::operator--() {
  --(*impl_);
  return *this;
}

CriteriaCollection::CriteriaCollectionConstIterator
CriteriaCollection::CriteriaCollectionConstIterator::operator--(int) {
  CriteriaCollection::CriteriaCollectionConstIterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
CriteriaCollection::CriteriaCollectionConstIterator::operator==(const CriteriaCollection::CriteriaCollectionConstIterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
CriteriaCollection::CriteriaCollectionConstIterator::operator!=(const CriteriaCollection::CriteriaCollectionConstIterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Criteria>&
CriteriaCollection::CriteriaCollectionConstIterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Criteria>*
CriteriaCollection::CriteriaCollectionConstIterator::operator->() const {
  return impl_->operator->();
}

}  // namespace criteria
