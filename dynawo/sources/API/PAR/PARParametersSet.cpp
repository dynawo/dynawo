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
 * @file PARParametersSet.cpp
 * @brief Dynawo parameters set : implementation for iterator
 *
 */

#include "PARParametersSet.h"
#include "PARParametersSetImpl.h"

using boost::shared_ptr;

namespace parameters {

ParametersSet::parameter_const_iterator::parameter_const_iterator(const ParametersSet::Impl* iterated, bool begin) {
  impl_ = new BaseIteratorImpl(iterated, begin);
}

ParametersSet::parameter_const_iterator::parameter_const_iterator(const ParametersSet::parameter_const_iterator& original) {
  impl_ = new BaseIteratorImpl(*(original.impl_));
}

ParametersSet::parameter_const_iterator::~parameter_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

ParametersSet::parameter_const_iterator&
ParametersSet::parameter_const_iterator::operator=(const ParametersSet::parameter_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new BaseIteratorImpl(*(other.impl_));
  return *this;
}

ParametersSet::parameter_const_iterator&
ParametersSet::parameter_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

ParametersSet::parameter_const_iterator
ParametersSet::parameter_const_iterator::operator++(int) {
  ParametersSet::parameter_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

ParametersSet::parameter_const_iterator&
ParametersSet::parameter_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

ParametersSet::parameter_const_iterator
ParametersSet::parameter_const_iterator::operator--(int) {
  ParametersSet::parameter_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
ParametersSet::parameter_const_iterator::operator==(const ParametersSet::parameter_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
ParametersSet::parameter_const_iterator::operator!=(const ParametersSet::parameter_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Parameter>&
ParametersSet::parameter_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Parameter>*
ParametersSet::parameter_const_iterator::operator->() const {
  return impl_->operator->();
}

ParametersSet::reference_const_iterator::reference_const_iterator(const ParametersSet::Impl* iterated, bool begin) {
  impl_ = new BaseIteratorRefImpl(iterated, begin);
}

ParametersSet::reference_const_iterator::reference_const_iterator(const ParametersSet::reference_const_iterator& original) {
  impl_ = new BaseIteratorRefImpl(*(original.impl_));
}

ParametersSet::reference_const_iterator::~reference_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

ParametersSet::reference_const_iterator&
ParametersSet::reference_const_iterator::operator=(const ParametersSet::reference_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new BaseIteratorRefImpl(*(other.impl_));
  return *this;
}

ParametersSet::reference_const_iterator&
ParametersSet::reference_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

ParametersSet::reference_const_iterator
ParametersSet::reference_const_iterator::operator++(int) {
  ParametersSet::reference_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

ParametersSet::reference_const_iterator&
ParametersSet::reference_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

ParametersSet::reference_const_iterator
ParametersSet::reference_const_iterator::operator--(int) {
  ParametersSet::reference_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
ParametersSet::reference_const_iterator::operator==(const ParametersSet::reference_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
ParametersSet::reference_const_iterator::operator!=(const ParametersSet::reference_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Reference>&
ParametersSet::reference_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Reference>*
ParametersSet::reference_const_iterator::operator->() const {
  return impl_->operator->();
}
}  // namespace parameters
