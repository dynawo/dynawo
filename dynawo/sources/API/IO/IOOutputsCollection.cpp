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
 * @file  IOOutputsCollection.cpp
 *
 * @brief Outputs collection : implementation file
 *
 */
#include "IOOutputsCollection.h"
#include "IOOutput.h"

using std::string;

namespace io {


void
OutputsCollection::add(const std::shared_ptr<Output>& output) {
  outputs_.push_back(output);
}

// void
// OutputsCollection::updateOutputs(const double& time) {
//   for (OutputsCollection::iterator iter = begin();
//           iter != end();
//           ++iter) {
//     (*iter)->update(time);
//   }
// }

OutputsCollection::const_iterator
OutputsCollection::cbegin() const {
  return OutputsCollection::const_iterator(this, true);
}

OutputsCollection::const_iterator
OutputsCollection::cend() const {
  return OutputsCollection::const_iterator(this, false);
}


OutputsCollection::const_iterator::const_iterator(const OutputsCollection* iterated, bool begin) :
current_((begin ? iterated->outputs_.begin() : iterated->outputs_.end())) { }

OutputsCollection::const_iterator&
OutputsCollection::const_iterator::operator++() {
  ++current_;
  return *this;
}

OutputsCollection::const_iterator
OutputsCollection::const_iterator::operator++(int) {
  OutputsCollection::const_iterator previous = *this;
  current_++;
  return previous;
}

OutputsCollection::const_iterator&
OutputsCollection::const_iterator::operator--() {
  --current_;
  return *this;
}

OutputsCollection::const_iterator
OutputsCollection::const_iterator::operator--(int) {
  OutputsCollection::const_iterator previous = *this;
  current_--;
  return previous;
}

bool
OutputsCollection::const_iterator::operator==(const OutputsCollection::const_iterator& other) const {
  return current_ == other.current_;
}

bool
OutputsCollection::const_iterator::operator!=(const OutputsCollection::const_iterator& other) const {
  return current_ != other.current_;
}

const std::shared_ptr<Output>&
OutputsCollection::const_iterator::operator*() const {
  return *current_;
}

const std::shared_ptr<Output>*
OutputsCollection::const_iterator::operator->() const {
  return &(*current_);
}

OutputsCollection::iterator
OutputsCollection::begin() {
  return OutputsCollection::iterator(this, true);
}

OutputsCollection::iterator
OutputsCollection::end() {
  return OutputsCollection::iterator(this, false);
}

OutputsCollection::iterator::iterator(OutputsCollection* iterated, bool begin) :
current_((begin ? iterated->outputs_.begin() : iterated->outputs_.end())) { }

OutputsCollection::iterator&
OutputsCollection::iterator::operator++() {
  ++current_;
  return *this;
}

OutputsCollection::iterator
OutputsCollection::iterator::operator++(int) {
  OutputsCollection::iterator previous = *this;
  current_++;
  return previous;
}

OutputsCollection::iterator&
OutputsCollection::iterator::operator--() {
  --current_;
  return *this;
}

OutputsCollection::iterator
OutputsCollection::iterator::operator--(int) {
  OutputsCollection::iterator previous = *this;
  current_--;
  return previous;
}

bool
OutputsCollection::iterator::operator==(const OutputsCollection::iterator& other) const {
  return current_ == other.current_;
}

bool
OutputsCollection::iterator::operator!=(const OutputsCollection::iterator& other) const {
  return current_ != other.current_;
}

std::shared_ptr<Output>&
OutputsCollection::iterator::operator*() const {
  return *current_;
}

std::shared_ptr<Output>*
OutputsCollection::iterator::operator->() const {
  return &(*current_);
}

}  // namespace io
