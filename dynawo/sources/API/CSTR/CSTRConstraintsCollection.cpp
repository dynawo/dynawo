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
 * @file  CSTRConstraintsCollection.cpp
 *
 * @brief Dynawo constraints : implementation file
 *
 */
#include "CSTRConstraintsCollection.h"

#include "CSTRConstraint.h"
#include "CSTRConstraintFactory.h"

#include <iostream>
#include <sstream>

using std::map;
using std::string;
using std::stringstream;
using std::vector;

namespace constraints {

ConstraintsCollection::ConstraintsCollection(const string& id) : id_(id) {}

void
ConstraintsCollection::addConstraint(
  const string& modelName,
  const string& description,
  const double& time,
  Type_t type,
  const string& modelType,
  const boost::optional<constraints::ConstraintData>& data) {
  stringstream id;
  id << time << "_" << modelName << "_" << type << "_" << description;  // allow to sort constraint by time, then modelName and type

  std::shared_ptr<Constraint> constraint = ConstraintFactory::newConstraint();
  constraint->setModelName(modelName);
  constraint->setDescription(description);
  constraint->setTime(time);
  constraint->setType(type);
  constraint->setData(data);
  constraint->setModelType(modelType);
  constraintsByModel_[modelName].push_back(constraint);
  constraintsById_[id.str()] = constraint;
}

void
ConstraintsCollection::filter() {
  for (auto& modelIt : constraintsByModel_) {
    const string& modelName = modelIt.first;
    std::vector<std::shared_ptr<Constraint> > constraints = modelIt.second;
    std::map<std::string, int> beginConstraints;
    std::map<std::string, int>::iterator beginConstraintsIt;
    std::vector<size_t> toRemove;
    // Collect begin/end pairs to remove
    for (unsigned int i = 0; i < constraints.size(); ++i) {
      const string& description = constraints[i]->getDescription();
      Type_t type = constraints[i]->getType();
      if (type == CONSTRAINT_BEGIN) {
        beginConstraints.insert({description, i});
      } else if (type == CONSTRAINT_END) {
        beginConstraintsIt = beginConstraints.find(description);
        if (beginConstraintsIt != beginConstraints.end()) {
          toRemove.push_back(beginConstraintsIt->second);
          toRemove.push_back(i);
          beginConstraints.erase(beginConstraintsIt);
        }
      }
    }
    // Remove elements
    stringstream idSs;
    for (auto it = toRemove.rbegin(); it != toRemove.rend(); ++it) {
      idSs.str(std::string());
      idSs.clear();
      idSs << constraints[*it]->getTime() << "_" << modelName << "_" << constraints[*it]->getType() << "_" << constraints[*it]->getDescription();
      constraintsById_.erase(idSs.str());
      modelIt.second.erase(modelIt.second.begin() + *it);
    }
  }
}

ConstraintsCollection::const_iterator
ConstraintsCollection::cbegin() const {
  return ConstraintsCollection::const_iterator(this, true);
}

ConstraintsCollection::const_iterator
ConstraintsCollection::cend() const {
  return ConstraintsCollection::const_iterator(this, false);
}

ConstraintsCollection::const_iterator::const_iterator(const ConstraintsCollection* iterated, bool begin) :
    current_((begin ? iterated->constraintsById_.begin() : iterated->constraintsById_.end())) {}

ConstraintsCollection::const_iterator&
ConstraintsCollection::const_iterator::operator++() {
  ++current_;
  return *this;
}

ConstraintsCollection::const_iterator
ConstraintsCollection::const_iterator::operator++(int) {
  ConstraintsCollection::const_iterator previous = *this;
  current_++;
  return previous;
}

ConstraintsCollection::const_iterator&
ConstraintsCollection::const_iterator::operator--() {
  --current_;
  return *this;
}

ConstraintsCollection::const_iterator
ConstraintsCollection::const_iterator::operator--(int) {
  ConstraintsCollection::const_iterator previous = *this;
  current_--;
  return previous;
}

bool
ConstraintsCollection::const_iterator::operator==(const ConstraintsCollection::const_iterator& other) const {
  return current_ == other.current_;
}

bool
ConstraintsCollection::const_iterator::operator!=(const ConstraintsCollection::const_iterator& other) const {
  return current_ != other.current_;
}

const std::shared_ptr<Constraint>& ConstraintsCollection::const_iterator::operator*() const {
  return current_->second;
}

const std::shared_ptr<Constraint>* ConstraintsCollection::const_iterator::operator->() const {
  return &(current_->second);
}

}  // namespace constraints
