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
 * @file PARParametersSetCollection.cpp
 * @brief Dynawo parameters set collection : implementation for iterator
 *
 */

#include "PARParametersSetCollection.h"
#include "PARParametersSetCollectionImpl.h"

namespace parameters {

ParametersSetCollection::parametersSet_const_iterator::parametersSet_const_iterator(const ParametersSetCollection::Impl* iterated, bool begin) {
  impl_ = new BaseIteratorImpl(iterated, begin);
}

ParametersSetCollection::parametersSet_const_iterator::parametersSet_const_iterator(const ParametersSetCollection::parametersSet_const_iterator& original) {
  impl_ = new BaseIteratorImpl(*(original.impl_));
}

ParametersSetCollection::parametersSet_const_iterator::~parametersSet_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

ParametersSetCollection::parametersSet_const_iterator&
ParametersSetCollection::parametersSet_const_iterator::operator=(const ParametersSetCollection::parametersSet_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new BaseIteratorImpl(*(other.impl_));
  return *this;
}

ParametersSetCollection::parametersSet_const_iterator&
ParametersSetCollection::parametersSet_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

ParametersSetCollection::parametersSet_const_iterator
ParametersSetCollection::parametersSet_const_iterator::operator++(int) {
  ParametersSetCollection::parametersSet_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

ParametersSetCollection::parametersSet_const_iterator&
ParametersSetCollection::parametersSet_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

ParametersSetCollection::parametersSet_const_iterator
ParametersSetCollection::parametersSet_const_iterator::operator--(int) {
  ParametersSetCollection::parametersSet_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
ParametersSetCollection::parametersSet_const_iterator::operator==(const ParametersSetCollection::parametersSet_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
ParametersSetCollection::parametersSet_const_iterator::operator!=(const ParametersSetCollection::parametersSet_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const boost::shared_ptr<ParametersSet>&
ParametersSetCollection::parametersSet_const_iterator::operator*() const {
  return *(*impl_);
}

const boost::shared_ptr<ParametersSet>*
ParametersSetCollection::parametersSet_const_iterator::operator->() const {
  return impl_->operator->();
}

}  // namespace parameters
