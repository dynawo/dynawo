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
 * @file  EXTVARIterators.cpp
 *
 * @brief extern variable data iterators : implementation file
 *
 */
#include "EXTVARIterators.h"

#include "EXTVARVariablesCollection.h"

using std::shared_ptr;
using std::map;
using std::string;

namespace externalVariables {

variable_const_iterator::variable_const_iterator(const VariablesCollection* iterated, bool begin) :
    current_((begin ? iterated->variables_.begin() : iterated->variables_.end())) {}

variable_const_iterator&
variable_const_iterator::operator++() {
  ++current_;
  return *this;
}

variable_const_iterator
variable_const_iterator::operator++(int) {
  variable_const_iterator previous = *this;
  current_++;
  return previous;
}

variable_const_iterator&
variable_const_iterator::operator--() {
  --current_;
  return *this;
}

variable_const_iterator
variable_const_iterator::operator--(int) {
  variable_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
variable_const_iterator::operator==(const variable_const_iterator& other) const {
  return current_ == other.current_;
}

bool
variable_const_iterator::operator!=(const variable_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Variable>& variable_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<Variable>* variable_const_iterator::operator->() const {
  return &(current_->second);
}

variable_iterator::variable_iterator(VariablesCollection* iterated, bool begin) :
    current_((begin ? iterated->variables_.begin() : iterated->variables_.end())) {}

variable_iterator&
variable_iterator::operator++() {
  ++current_;
  return *this;
}

variable_iterator
variable_iterator::operator++(int) {
  variable_iterator previous = *this;
  current_++;
  return previous;
}

variable_iterator&
variable_iterator::operator--() {
  --current_;
  return *this;
}

variable_iterator
variable_iterator::operator--(int) {
  variable_iterator previous = *this;
  current_--;
  return previous;
}

bool
variable_iterator::operator==(const variable_iterator& other) const {
  return current_ == other.current_;
}

bool
variable_iterator::operator!=(const variable_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<Variable>& variable_iterator::operator*() const {
  return current_->second;
}

shared_ptr<Variable>* variable_iterator::operator->() const {
  return &(current_->second);
}

}  // namespace externalVariables
