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

#include "CSTRConstraintSource.h"
#include "CSTRConstraintFactory.h"

#include <iostream>
#include <sstream>
#include <set>
#include <unordered_map>

using std::map;
using std::string;
using std::stringstream;
using std::vector;

namespace constraints {

ConstraintsCollection::ConstraintsCollection(const string& id) : id_(id) {}

void
ConstraintsCollection::addConstraint(const string& modelName, const string& description, const double& time, Type_t type,
                                     const string& modelType, const boost::optional<constraints::ConstraintData>& data) {
  string id = idFromDetails(modelName, description, time, type);
  if (constraintsById_.find(id) == constraintsById_.end()) {
    std::shared_ptr<Constraint> constraint = ConstraintFactory::newConstraint();
    constraint->setModelName(modelName);
    constraint->setDescription(description);
    constraint->setTime(time);
    constraint->setType(type);
    constraint->setData(data);
    constraint->setModelType(modelType);

    constraintsByModel_[modelName].push_back(constraint);
    constraintsById_[id] = constraint;
  }
}

void
ConstraintsCollection::filter(DYN::ConstraintValueType_t filterType) {
  if (filterType == DYN::NO_CONSTRAINTS_FILTER)
    return;

  for (auto & modelIt : constraintsByModel_) {
    std::vector<std::shared_ptr<Constraint> > & constraints = modelIt.second;
    std::unordered_map<std::string, std::vector<std::shared_ptr<Constraint> > > constraintsByDescr;

    for (std::shared_ptr<Constraint> & constraint : constraints) {
      const string & descr = constraint->getDescription();
      Type_t type = constraint->getType();

      if ((constraintsByDescr.find(descr) == constraintsByDescr.end())) {  // new constraint
        if ((type == CONSTRAINT_BEGIN)) {
          constraintsByDescr[descr].push_back(constraint);
          if ((filterType == DYN::CONSTRAINTS_DYNAFLOW) && constraint->getData() && (constraint->getData()->source != nullptr)) {
            ConstraintData data = constraint->getData().get();
            data.source->getFinalValues(data.kind, data.varIndex, data.value, data.valueMin, data.valueMax);
            constraint->setData(data);
          }
        }
      } else if ((type == CONSTRAINT_END) && (filterType == DYN::CONSTRAINTS_KEEP_FIRST)) {  // in non-DFL mode, forget closed constraints
          constraintsByDescr.erase(constraintsByDescr.find(descr));
      }
    }

    constraints.clear();
    for (auto & descrIt : constraintsByDescr)
      for (std::shared_ptr<Constraint> & constraint : descrIt.second)
        constraints.push_back(constraint);
  }

  // regenerate filtered constraintsById_
  constraintsById_.clear();
  for (auto & modelIt : constraintsByModel_)
    for (std::shared_ptr<Constraint> & constraint : modelIt.second)
      constraintsById_[idFromDetails(modelIt.first, constraint->getDescription(), constraint->getTime(), constraint->getType())] = constraint;
}

void
ConstraintsCollection::clear() {
  constraintsByModel_.clear();
  constraintsById_.clear();
}

string
ConstraintsCollection::idFromDetails(const string & modelName, const string & description, const double & time, Type_t type) const {
  stringstream stream;
  stream << modelName << "_" << time << "_" << type << "_" << description;  // allow to sort constraint by modelName, then time and type
  return stream.str();
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
