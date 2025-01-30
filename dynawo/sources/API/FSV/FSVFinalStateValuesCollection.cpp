//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVFinalStateValuesCollection.cpp
 *
 * @brief Final state values collection : implementation file
 *
 */
#include "FSVFinalStateValuesCollection.h"

#include "FSVFinalStateValue.h"

using std::string;
using std::vector;

namespace finalStateValues {

FinalStateValuesCollection::FinalStateValuesCollection(const string& id) : id_(id) {}

void
FinalStateValuesCollection::add(const std::shared_ptr<FinalStateValue>& finalStateValue) {
  finalStateValues_.push_back(finalStateValue);
}

FinalStateValuesCollection::const_iterator
FinalStateValuesCollection::cbegin() const {
  return FinalStateValuesCollection::const_iterator(this, true);
}

FinalStateValuesCollection::const_iterator
FinalStateValuesCollection::cend() const {
  return FinalStateValuesCollection::const_iterator(this, false);
}

FinalStateValuesCollection::const_iterator::const_iterator(const FinalStateValuesCollection* iterated, bool begin) :
    current_((begin ? iterated->finalStateValues_.begin() : iterated->finalStateValues_.end())) {}

FinalStateValuesCollection::const_iterator&
FinalStateValuesCollection::const_iterator::operator++() {
  ++current_;
  return *this;
}

FinalStateValuesCollection::const_iterator
FinalStateValuesCollection::const_iterator::operator++(int) {
  FinalStateValuesCollection::const_iterator previous = *this;
  current_++;
  return previous;
}

FinalStateValuesCollection::const_iterator&
FinalStateValuesCollection::const_iterator::operator--() {
  --current_;
  return *this;
}

FinalStateValuesCollection::const_iterator
FinalStateValuesCollection::const_iterator::operator--(int) {
  FinalStateValuesCollection::const_iterator previous = *this;
  current_--;
  return previous;
}

bool
FinalStateValuesCollection::const_iterator::operator==(const FinalStateValuesCollection::const_iterator& other) const {
  return current_ == other.current_;
}

bool
FinalStateValuesCollection::const_iterator::operator!=(const FinalStateValuesCollection::const_iterator& other) const {
  return current_ != other.current_;
}

const std::shared_ptr<FinalStateValue>& FinalStateValuesCollection::const_iterator::operator*() const {
  return *current_;
}

const std::shared_ptr<FinalStateValue>* FinalStateValuesCollection::const_iterator::operator->() const {
  return &(*current_);
}

FinalStateValuesCollection::iterator
FinalStateValuesCollection::begin() {
  return FinalStateValuesCollection::iterator(this, true);
}

FinalStateValuesCollection::iterator
FinalStateValuesCollection::end() {
  return FinalStateValuesCollection::iterator(this, false);
}

FinalStateValuesCollection::iterator::iterator(FinalStateValuesCollection* iterated, bool begin) :
    current_((begin ? iterated->finalStateValues_.begin() : iterated->finalStateValues_.end())) {}

FinalStateValuesCollection::iterator&
FinalStateValuesCollection::iterator::operator++() {
  ++current_;
  return *this;
}

FinalStateValuesCollection::iterator
FinalStateValuesCollection::iterator::operator++(int) {
  FinalStateValuesCollection::iterator previous = *this;
  current_++;
  return previous;
}

FinalStateValuesCollection::iterator&
FinalStateValuesCollection::iterator::operator--() {
  --current_;
  return *this;
}

FinalStateValuesCollection::iterator
FinalStateValuesCollection::iterator::operator--(int) {
  FinalStateValuesCollection::iterator previous = *this;
  current_--;
  return previous;
}

bool
FinalStateValuesCollection::iterator::operator==(const FinalStateValuesCollection::iterator& other) const {
  return current_ == other.current_;
}

bool
FinalStateValuesCollection::iterator::operator!=(const FinalStateValuesCollection::iterator& other) const {
  return current_ != other.current_;
}

std::shared_ptr<FinalStateValue>& FinalStateValuesCollection::iterator::operator*() const {
  return *current_;
}

std::shared_ptr<FinalStateValue>* FinalStateValuesCollection::iterator::operator->() const {
  return &(*current_);
}

}  // namespace finalStateValues
