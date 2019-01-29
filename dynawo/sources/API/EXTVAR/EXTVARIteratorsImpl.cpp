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
 * @file  DYDIteratorsImpl.cpp
 *
 * @brief Dynamic data iterators : implementation file
 *
 */
#include "EXTVARIteratorsImpl.h"

using boost::shared_ptr;
using std::map;
using std::string;

namespace externalVariables {

VariablesConstIteratorImpl::VariablesConstIteratorImpl(const VariablesCollection::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->variables_.begin() : iterated->variables_.end());
}

VariablesConstIteratorImpl::VariablesConstIteratorImpl(const VariablesIteratorImpl& iterator) {
  current_ = iterator.current();
}

VariablesConstIteratorImpl::~VariablesConstIteratorImpl() {
}

VariablesConstIteratorImpl&
VariablesConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

VariablesConstIteratorImpl
VariablesConstIteratorImpl::operator++(int) {
  VariablesConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

VariablesConstIteratorImpl&
VariablesConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

VariablesConstIteratorImpl
VariablesConstIteratorImpl::operator--(int) {
  VariablesConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
VariablesConstIteratorImpl::operator==(const VariablesConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
VariablesConstIteratorImpl::operator!=(const VariablesConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Variable>&
VariablesConstIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<Variable>*
VariablesConstIteratorImpl::operator->() const {
  return &(current_->second);
}

VariablesIteratorImpl::VariablesIteratorImpl(VariablesCollection::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->variables_.begin() : iterated->variables_.end());
}

VariablesIteratorImpl::~VariablesIteratorImpl() {
}

VariablesIteratorImpl&
VariablesIteratorImpl::operator++() {
  ++current_;
  return *this;
}

VariablesIteratorImpl
VariablesIteratorImpl::operator++(int) {
  VariablesIteratorImpl previous = *this;
  current_++;
  return previous;
}

VariablesIteratorImpl&
VariablesIteratorImpl::operator--() {
  --current_;
  return *this;
}

VariablesIteratorImpl
VariablesIteratorImpl::operator--(int) {
  VariablesIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
VariablesIteratorImpl::operator==(const VariablesIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
VariablesIteratorImpl::operator!=(const VariablesIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<Variable>&
VariablesIteratorImpl::operator*() const {
  return current_->second;
}

shared_ptr<Variable>*
VariablesIteratorImpl::operator->() const {
  return &(current_->second);
}

map<string, shared_ptr<Variable> >::iterator
VariablesIteratorImpl::current() const {
  return current_;
}

}  // namespace externalVariables
