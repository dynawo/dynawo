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
 * @file  FSIterators.cpp
 *
 * @brief final state iterators: implementation file
 *
 * Iterators can be on models or variables container. They can be const or not
 */
#include "FSIterators.h"
#include "FSIteratorsImpl.h"

using boost::shared_ptr;

namespace finalState {

model_const_iterator::model_const_iterator(const FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new ModelConstIteratorImpl(iterated, begin);
}

model_const_iterator::model_const_iterator(const Model::Impl* iterated, bool begin) {
  impl_ = new ModelConstIteratorImpl(iterated, begin);
}

model_const_iterator::model_const_iterator(const model_const_iterator& original) {
  impl_ = new ModelConstIteratorImpl(*(original.impl_));
}

model_const_iterator::model_const_iterator(const model_iterator& original) {
  impl_ = new ModelConstIteratorImpl(*(original.impl()));
}

model_const_iterator::~model_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

model_const_iterator&
model_const_iterator::operator=(const model_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new ModelConstIteratorImpl(*(other.impl_));
  return *this;
}

model_const_iterator&
model_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

model_const_iterator
model_const_iterator::operator++(int) {
  model_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

model_const_iterator&
model_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

model_const_iterator
model_const_iterator::operator--(int) {
  model_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
model_const_iterator::operator==(const model_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
model_const_iterator::operator!=(const model_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Model>&
model_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Model>*
model_const_iterator::operator->() const {
  return impl_->operator->();
}

variable_const_iterator::variable_const_iterator(const FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new VariableConstIteratorImpl(iterated, begin);
}

variable_const_iterator::variable_const_iterator(const Model::Impl* iterated, bool begin) {
  impl_ = new VariableConstIteratorImpl(iterated, begin);
}

variable_const_iterator::variable_const_iterator(const variable_const_iterator& original) {
  impl_ = new VariableConstIteratorImpl(*(original.impl_));
}

variable_const_iterator::variable_const_iterator(const variable_iterator& original) {
  impl_ = new VariableConstIteratorImpl(*(original.impl()));
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
  impl_ = new VariableConstIteratorImpl(*(other.impl_));
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

model_iterator::model_iterator(FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new ModelIteratorImpl(iterated, begin);
}

model_iterator::model_iterator(Model::Impl* iterated, bool begin) {
  impl_ = new ModelIteratorImpl(iterated, begin);
}

model_iterator::model_iterator(const model_iterator& original) {
  impl_ = new ModelIteratorImpl(*(original.impl_));
}

model_iterator::~model_iterator() {
  delete impl_;
  impl_ = NULL;
}

model_iterator&
model_iterator::operator=(const model_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new ModelIteratorImpl(*(other.impl_));
  return *this;
}

model_iterator&
model_iterator::operator++() {
  ++(*impl_);
  return *this;
}

model_iterator
model_iterator::operator++(int) {
  model_iterator previous = *this;
  (*impl_)++;
  return previous;
}

model_iterator&
model_iterator::operator--() {
  --(*impl_);
  return *this;
}

model_iterator
model_iterator::operator--(int) {
  model_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
model_iterator::operator==(const model_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
model_iterator::operator!=(const model_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<Model>&
model_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<Model>*
model_iterator::operator->() const {
  return impl_->operator->();
}

ModelIteratorImpl*
model_iterator::impl() const {
  return impl_;
}

variable_iterator::variable_iterator(FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new VariableIteratorImpl(iterated, begin);
}

variable_iterator::variable_iterator(Model::Impl* iterated, bool begin) {
  impl_ = new VariableIteratorImpl(iterated, begin);
}

variable_iterator::variable_iterator(const variable_iterator& original) {
  impl_ = new VariableIteratorImpl(*(original.impl_));
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
  impl_ = new VariableIteratorImpl(*(other.impl_));
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

VariableIteratorImpl*
variable_iterator::impl() const {
  return impl_;
}

}  // namespace finalState
