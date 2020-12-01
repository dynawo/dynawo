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
 * @brief Final state iterators : implementation file
 *
 */
#include "FSIterators.h"

#include "FSFinalStateCollection.h"
#include "FSModel.h"

using boost::shared_ptr;
using std::vector;

namespace finalState {

finalStateModel_const_iterator::finalStateModel_const_iterator(const FinalStateCollection* iterated, bool begin) :
    current_((begin ? iterated->models_.begin() : iterated->models_.end())) {}

finalStateModel_const_iterator::finalStateModel_const_iterator(const FinalStateModel* iterated, bool begin) :
    current_((begin ? iterated->subModels_.begin() : iterated->subModels_.end())) {}

finalStateModel_const_iterator&
finalStateModel_const_iterator::operator++() {
  ++current_;
  return *this;
}

finalStateModel_const_iterator
finalStateModel_const_iterator::operator++(int) {
  finalStateModel_const_iterator previous = *this;
  current_++;
  return previous;
}

finalStateModel_const_iterator&
finalStateModel_const_iterator::operator--() {
  --current_;
  return *this;
}

finalStateModel_const_iterator
finalStateModel_const_iterator::operator--(int) {
  finalStateModel_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
finalStateModel_const_iterator::operator==(const finalStateModel_const_iterator& other) const {
  return current_ == other.current_;
}

bool
finalStateModel_const_iterator::operator!=(const finalStateModel_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<FinalStateModel>& finalStateModel_const_iterator::operator*() const {
  return *current_;
}

const shared_ptr<FinalStateModel>* finalStateModel_const_iterator::operator->() const {
  return &(*current_);
}

finalStateVariable_const_iterator::finalStateVariable_const_iterator(const FinalStateCollection* iterated, bool begin) :
    current_((begin ? iterated->variables_.begin() : iterated->variables_.end())) {}

finalStateVariable_const_iterator::finalStateVariable_const_iterator(const FinalStateModel* iterated, bool begin) :
    current_((begin ? iterated->variables_.begin() : iterated->variables_.end())) {}

finalStateVariable_const_iterator&
finalStateVariable_const_iterator::operator++() {
  ++current_;
  return *this;
}

finalStateVariable_const_iterator
finalStateVariable_const_iterator::operator++(int) {
  finalStateVariable_const_iterator previous = *this;
  current_++;
  return previous;
}

finalStateVariable_const_iterator&
finalStateVariable_const_iterator::operator--() {
  --current_;
  return *this;
}

finalStateVariable_const_iterator
finalStateVariable_const_iterator::operator--(int) {
  finalStateVariable_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
finalStateVariable_const_iterator::operator==(const finalStateVariable_const_iterator& other) const {
  return current_ == other.current_;
}

bool
finalStateVariable_const_iterator::operator!=(const finalStateVariable_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Variable>& finalStateVariable_const_iterator::operator*() const {
  return *current_;
}

const shared_ptr<Variable>* finalStateVariable_const_iterator::operator->() const {
  return &(*current_);
}

finalStateModel_iterator::finalStateModel_iterator(FinalStateCollection* iterated, bool begin) :
    current_((begin ? iterated->models_.begin() : iterated->models_.end())) {}

finalStateModel_iterator::finalStateModel_iterator(FinalStateModel* iterated, bool begin) :
    current_((begin ? iterated->subModels_.begin() : iterated->subModels_.end())) {}

finalStateModel_iterator&
finalStateModel_iterator::operator++() {
  ++current_;
  return *this;
}

finalStateModel_iterator
finalStateModel_iterator::operator++(int) {
  finalStateModel_iterator previous = *this;
  current_++;
  return previous;
}

finalStateModel_iterator&
finalStateModel_iterator::operator--() {
  --current_;
  return *this;
}

finalStateModel_iterator
finalStateModel_iterator::operator--(int) {
  finalStateModel_iterator previous = *this;
  current_--;
  return previous;
}

bool
finalStateModel_iterator::operator==(const finalStateModel_iterator& other) const {
  return current_ == other.current_;
}

bool
finalStateModel_iterator::operator!=(const finalStateModel_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<FinalStateModel>& finalStateModel_iterator::operator*() const {
  return *current_;
}

shared_ptr<FinalStateModel>* finalStateModel_iterator::operator->() const {
  return &(*current_);
}

finalStateVariable_iterator::finalStateVariable_iterator(FinalStateCollection* iterated, bool begin) :
    current_((begin ? iterated->variables_.begin() : iterated->variables_.end())) {}

finalStateVariable_iterator::finalStateVariable_iterator(FinalStateModel* iterated, bool begin) :
    current_((begin ? iterated->variables_.begin() : iterated->variables_.end())) {}

finalStateVariable_iterator&
finalStateVariable_iterator::operator++() {
  ++current_;
  return *this;
}

finalStateVariable_iterator
finalStateVariable_iterator::operator++(int) {
  finalStateVariable_iterator previous = *this;
  current_++;
  return previous;
}

finalStateVariable_iterator&
finalStateVariable_iterator::operator--() {
  --current_;
  return *this;
}

finalStateVariable_iterator
finalStateVariable_iterator::operator--(int) {
  finalStateVariable_iterator previous = *this;
  current_--;
  return previous;
}

bool
finalStateVariable_iterator::operator==(const finalStateVariable_iterator& other) const {
  return current_ == other.current_;
}

bool
finalStateVariable_iterator::operator!=(const finalStateVariable_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<Variable>& finalStateVariable_iterator::operator*() const {
  return *current_;
}

shared_ptr<Variable>* finalStateVariable_iterator::operator->() const {
  return &(*current_);
}

}  // namespace finalState
