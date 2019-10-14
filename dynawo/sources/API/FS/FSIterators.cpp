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

finalStateModel_const_iterator::finalStateModel_const_iterator(const FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new ModelConstIteratorImpl(iterated, begin);
}

finalStateModel_const_iterator::finalStateModel_const_iterator(const Model::Impl* iterated, bool begin) {
  impl_ = new ModelConstIteratorImpl(iterated, begin);
}

finalStateModel_const_iterator::finalStateModel_const_iterator(const THIS& original) {
  impl_ = new ModelConstIteratorImpl(*(original.impl_));
}

finalStateModel_const_iterator::finalStateModel_const_iterator(const finalStateModel_iterator& original) {
  impl_ = new ModelConstIteratorImpl(*(original.impl()));
}

finalStateModel_const_iterator::~finalStateModel_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

finalStateModel_const_iterator&
finalStateModel_const_iterator::operator=(const THIS& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new ModelConstIteratorImpl(*(other.impl_));
  return *this;
}

finalStateModel_const_iterator&
finalStateModel_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

finalStateModel_const_iterator
finalStateModel_const_iterator::operator++(int) {
  THIS previous = *this;
  (*impl_)++;
  return previous;
}

finalStateModel_const_iterator&
finalStateModel_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

finalStateModel_const_iterator
finalStateModel_const_iterator::operator--(int) {
  THIS previous = *this;
  (*impl_)--;
  return previous;
}

bool
finalStateModel_const_iterator::operator==(const THIS& other) const {
  return *impl_ == *(other.impl_);
}

bool
finalStateModel_const_iterator::operator!=(const THIS& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Model>&
finalStateModel_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Model>*
finalStateModel_const_iterator::operator->() const {
  return impl_->operator->();
}

finalStateVariable_const_iterator::finalStateVariable_const_iterator(const FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new VariableConstIteratorImpl(iterated, begin);
}

finalStateVariable_const_iterator::finalStateVariable_const_iterator(const Model::Impl* iterated, bool begin) {
  impl_ = new VariableConstIteratorImpl(iterated, begin);
}

finalStateVariable_const_iterator::finalStateVariable_const_iterator(const finalStateVariable_const_iterator& original) {
  impl_ = new VariableConstIteratorImpl(*(original.impl_));
}

finalStateVariable_const_iterator::finalStateVariable_const_iterator(const finalStateVariable_iterator& original) {
  impl_ = new VariableConstIteratorImpl(*(original.impl()));
}

finalStateVariable_const_iterator::~finalStateVariable_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

finalStateVariable_const_iterator&
finalStateVariable_const_iterator::operator=(const THIS& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new VariableConstIteratorImpl(*(other.impl_));
  return *this;
}

finalStateVariable_const_iterator&
finalStateVariable_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

finalStateVariable_const_iterator
finalStateVariable_const_iterator::operator++(int) {
  THIS previous = *this;
  (*impl_)++;
  return previous;
}

finalStateVariable_const_iterator&
finalStateVariable_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

finalStateVariable_const_iterator
finalStateVariable_const_iterator::operator--(int) {
  THIS previous = *this;
  (*impl_)--;
  return previous;
}

bool
finalStateVariable_const_iterator::operator==(const THIS& other) const {
  return *impl_ == *(other.impl_);
}

bool
finalStateVariable_const_iterator::operator!=(const THIS& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Variable>&
finalStateVariable_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Variable>*
finalStateVariable_const_iterator::operator->() const {
  return impl_->operator->();
}

finalStateModel_iterator::finalStateModel_iterator(FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new ModelIteratorImpl(iterated, begin);
}

finalStateModel_iterator::finalStateModel_iterator(Model::Impl* iterated, bool begin) {
  impl_ = new ModelIteratorImpl(iterated, begin);
}

finalStateModel_iterator::finalStateModel_iterator(const THIS& original) {
  impl_ = new ModelIteratorImpl(*(original.impl_));
}

finalStateModel_iterator::~finalStateModel_iterator() {
  delete impl_;
  impl_ = NULL;
}

finalStateModel_iterator&
finalStateModel_iterator::operator=(const THIS& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new ModelIteratorImpl(*(other.impl_));
  return *this;
}

finalStateModel_iterator&
finalStateModel_iterator::operator++() {
  ++(*impl_);
  return *this;
}

finalStateModel_iterator
finalStateModel_iterator::operator++(int) {
  THIS previous = *this;
  (*impl_)++;
  return previous;
}

finalStateModel_iterator&
finalStateModel_iterator::operator--() {
  --(*impl_);
  return *this;
}

finalStateModel_iterator
finalStateModel_iterator::operator--(int) {
  THIS previous = *this;
  (*impl_)--;
  return previous;
}

bool
finalStateModel_iterator::operator==(const THIS& other) const {
  return *impl_ == *(other.impl_);
}

bool
finalStateModel_iterator::operator!=(const THIS& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<Model>&
finalStateModel_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<Model>*
finalStateModel_iterator::operator->() const {
  return impl_->operator->();
}

ModelIteratorImpl*
finalStateModel_iterator::impl() const {
  return impl_;
}

finalStateVariable_iterator::finalStateVariable_iterator(FinalStateCollection::Impl* iterated, bool begin) {
  impl_ = new VariableIteratorImpl(iterated, begin);
}

finalStateVariable_iterator::finalStateVariable_iterator(Model::Impl* iterated, bool begin) {
  impl_ = new VariableIteratorImpl(iterated, begin);
}

finalStateVariable_iterator::finalStateVariable_iterator(const THIS& original) {
  impl_ = new VariableIteratorImpl(*(original.impl_));
}

finalStateVariable_iterator::~finalStateVariable_iterator() {
  delete impl_;
  impl_ = NULL;
}

finalStateVariable_iterator&
finalStateVariable_iterator::operator=(const THIS& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new VariableIteratorImpl(*(other.impl_));
  return *this;
}

finalStateVariable_iterator&
finalStateVariable_iterator::operator++() {
  ++(*impl_);
  return *this;
}

finalStateVariable_iterator
finalStateVariable_iterator::operator++(int) {
  THIS previous = *this;
  (*impl_)++;
  return previous;
}

finalStateVariable_iterator&
finalStateVariable_iterator::operator--() {
  --(*impl_);
  return *this;
}

finalStateVariable_iterator
finalStateVariable_iterator::operator--(int) {
  THIS previous = *this;
  (*impl_)--;
  return previous;
}

bool
finalStateVariable_iterator::operator==(const THIS& other) const {
  return *impl_ == *(other.impl_);
}

bool
finalStateVariable_iterator::operator!=(const THIS& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<Variable>&
finalStateVariable_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<Variable>*
finalStateVariable_iterator::operator->() const {
  return impl_->operator->();
}

VariableIteratorImpl*
finalStateVariable_iterator::impl() const {
  return impl_;
}

}  // namespace finalState
