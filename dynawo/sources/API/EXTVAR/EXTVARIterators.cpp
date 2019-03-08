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
 * @file  DYDIterators.cpp
 *
 * @brief Dynamic data iterators: implementation file
 *
 * Iterators can be on models, connectors or network connectors
 * container. They can be const or not
 */
#include "EXTVARIterators.h"
#include "EXTVARIteratorsImpl.h"

using boost::shared_ptr;

namespace externalVariables {

variable_const_iterator::variable_const_iterator(const VariablesCollection::Impl* iterated, bool begin) {
  impl_ = new VariablesConstIteratorImpl(iterated, begin);
}

variable_const_iterator::variable_const_iterator(const variable_const_iterator& original) {
  impl_ = new VariablesConstIteratorImpl(*(original.impl_));
}

variable_const_iterator::variable_const_iterator(const variable_iterator& original) {
  impl_ = new VariablesConstIteratorImpl(*(original.impl()));
}

variable_const_iterator::~variable_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

variable_const_iterator&
variable_const_iterator::operator=(const variable_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new VariablesConstIteratorImpl(*(other.impl_));
  return *this;
}

variable_const_iterator&
variable_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

variable_const_iterator
variable_const_iterator::operator++(int) {
  variable_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

variable_const_iterator&
variable_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

variable_const_iterator
variable_const_iterator::operator--(int) {
  variable_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
variable_const_iterator::operator==(const variable_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
variable_const_iterator::operator!=(const variable_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Variable>&
variable_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Variable>*
variable_const_iterator::operator->() const {
  return impl_->operator->();
}

variable_iterator::variable_iterator(VariablesCollection::Impl* iterated, bool begin) {
  impl_ = new VariablesIteratorImpl(iterated, begin);
}

variable_iterator::variable_iterator(const variable_iterator& original) {
  impl_ = new VariablesIteratorImpl(*(original.impl_));
}

variable_iterator::~variable_iterator() {
  delete impl_;
  impl_ = NULL;
}

variable_iterator&
variable_iterator::operator=(const variable_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new VariablesIteratorImpl(*(other.impl_));
  return *this;
}

variable_iterator&
variable_iterator::operator++() {
  ++(*impl_);
  return *this;
}

variable_iterator
variable_iterator::operator++(int) {
  variable_iterator previous = *this;
  (*impl_)++;
  return previous;
}

variable_iterator&
variable_iterator::operator--() {
  --(*impl_);
  return *this;
}

variable_iterator
variable_iterator::operator--(int) {
  variable_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
variable_iterator::operator==(const variable_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
variable_iterator::operator!=(const variable_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<Variable>&
variable_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<Variable>*
variable_iterator::operator->() const {
  return impl_->operator->();
}

VariablesIteratorImpl*
variable_iterator::impl() const {
  return impl_;
}

}  // namespace externalVariables
