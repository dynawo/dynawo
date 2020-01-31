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
 * @file  CSTRConstraintsCollectionImpl.cpp
 *
 * @brief Dynawo constraints : implementation file
 *
 */
#include <iostream>
#include <sstream>
#include "CSTRConstraintsCollectionImpl.h"
#include "CSTRConstraint.h"
#include "CSTRConstraintFactory.h"

using std::string;
using std::stringstream;
using std::map;
using std::vector;
using boost::shared_ptr;

namespace constraints {

ConstraintsCollection::Impl::Impl(const string& id) :
id_(id) {
}

ConstraintsCollection::Impl::~Impl() {
}

void
ConstraintsCollection::Impl::addConstraint(const string& modelName, const string& description,
                                           const double& time, Type_t type,
                                           const string& modelType) {
  stringstream id;
  id << time << "_" << modelName << "_" << description;  // allow to sort constraint by time, then modelName

  // find if a constraint of same description already exists
  // if this is the case, if type are different (and the first is begin), erase constraints of this description
  bool addConstraint = true;
  map<string, vector<shared_ptr<Constraint> > >::iterator iter = constraintsByModel_.find(modelName);
  if (iter == constraintsByModel_.end()) {
    constraintsByModel_[modelName] = vector<shared_ptr<Constraint> >();
  } else {
    vector<shared_ptr<Constraint> > constraints = iter->second;
    for (unsigned int i = 0; i < constraints.size(); ++i) {
      string oldDescription = constraints[i]->getDescription();
      Type_t oldType = constraints[i]->getType();
      double oldTime = constraints[i]->getTime();
      stringstream oldId;
      oldId << oldTime << "_" << modelName << "_" << oldDescription;
      if (oldDescription == description && oldType == CONSTRAINT_BEGIN && type == CONSTRAINT_END) {
        addConstraint = false;
        // remove in map
        iter->second.erase(iter->second.begin() + i);
        constraintsById_.erase(oldId.str());
        break;
      }
    }
  }

  if (addConstraint) {
    shared_ptr<Constraint> constraint = ConstraintFactory::newConstraint();
    constraint->setModelName(modelName);
    constraint->setDescription(description);
    constraint->setTime(time);
    constraint->setType(type);
    constraint->setModelType(modelType);
    constraintsByModel_[modelName].push_back(constraint);
    constraintsById_[id.str()] = constraint;
  }
}

ConstraintsCollection::const_iterator
ConstraintsCollection::Impl::cbegin() const {
  return ConstraintsCollection::const_iterator(this, true);
}

ConstraintsCollection::const_iterator
ConstraintsCollection::Impl::cend() const {
  return ConstraintsCollection::const_iterator(this, false);
}

ConstraintsCollection::BaseIteratorImpl::BaseIteratorImpl(const ConstraintsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->constraintsById_.begin() : iterated->constraintsById_.end())) { }

ConstraintsCollection::BaseIteratorImpl::~BaseIteratorImpl() {
}

ConstraintsCollection::BaseIteratorImpl&
ConstraintsCollection::BaseIteratorImpl::operator++() {
  ++current_;
  return *this;
}

ConstraintsCollection::BaseIteratorImpl
ConstraintsCollection::BaseIteratorImpl::operator++(int) {
  ConstraintsCollection::BaseIteratorImpl previous = *this;
  current_++;
  return previous;
}

ConstraintsCollection::BaseIteratorImpl&
ConstraintsCollection::BaseIteratorImpl::operator--() {
  --current_;
  return *this;
}

ConstraintsCollection::BaseIteratorImpl
ConstraintsCollection::BaseIteratorImpl::operator--(int) {
  ConstraintsCollection::BaseIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
ConstraintsCollection::BaseIteratorImpl::operator==(const ConstraintsCollection::BaseIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
ConstraintsCollection::BaseIteratorImpl::operator!=(const ConstraintsCollection::BaseIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Constraint>&
ConstraintsCollection::BaseIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<Constraint>*
ConstraintsCollection::BaseIteratorImpl::operator->() const {
  return &(current_->second);
}



}  // namespace constraints
