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
 * @file  CSTRConstraintsCollection.cpp
 *
 * @brief Dynawo constraints : implementation for iterator
 *
 */
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraintsCollectionImpl.h"

using boost::shared_ptr;

namespace constraints {

ConstraintsCollection::const_iterator::const_iterator(const ConstraintsCollection::Impl* iterated, bool begin) {
  impl_ = new BaseIteratorImpl(iterated, begin);
}

ConstraintsCollection::const_iterator::const_iterator(const ConstraintsCollection::const_iterator& original) {
  impl_ = new BaseIteratorImpl(*(original.impl_));
}

ConstraintsCollection::const_iterator::~const_iterator() {
  delete impl_;
  impl_ = NULL;
}

ConstraintsCollection::const_iterator&
ConstraintsCollection::const_iterator::operator=(const ConstraintsCollection::const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new BaseIteratorImpl(*(other.impl_));
  return *this;
}

ConstraintsCollection::const_iterator&
ConstraintsCollection::const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

ConstraintsCollection::const_iterator
ConstraintsCollection::const_iterator::operator++(int) {
  ConstraintsCollection::const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

ConstraintsCollection::const_iterator&
ConstraintsCollection::const_iterator::operator--() {
  --(*impl_);
  return *this;
}

ConstraintsCollection::const_iterator
ConstraintsCollection::const_iterator::operator--(int) {
  ConstraintsCollection::const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
ConstraintsCollection::const_iterator::operator==(const ConstraintsCollection::const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
ConstraintsCollection::const_iterator::operator!=(const ConstraintsCollection::const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Constraint>&
ConstraintsCollection::const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Constraint>*
ConstraintsCollection::const_iterator::operator->() const {
  return impl_->operator->();
}

}  // namespace constraints
