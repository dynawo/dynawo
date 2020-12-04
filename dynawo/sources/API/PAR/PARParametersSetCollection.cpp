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
 * @file PARParametersSetCollection.cpp
 * @brief Dynawo parameters set collection : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "PARParametersSet.h"
#include "PARParametersSetCollection.h"

using std::map;
using std::string;

using boost::dynamic_pointer_cast;
using boost::shared_ptr;

using DYN::Error;

namespace parameters {

void
ParametersSetCollection::addParametersSet(shared_ptr<ParametersSet> paramSet, bool force) {
  assert(paramSet && "impossible to add null parameter set pointer to collection");

  string id = paramSet->getId();
  if (hasParametersSet(id)) {
    if (force) {
      // @todo : force / Create custom id, change parameters set one and adds it to the map
    } else {
      throw DYNError(Error::API, ParametersSetAlreadyExists, id);
    }
  }
  parametersSets_[id] = paramSet;
}

shared_ptr<ParametersSet>
ParametersSetCollection::getParametersSet(const string& id) {
  map< string, shared_ptr<ParametersSet> >::iterator itParamSet = parametersSets_.find(id);
  if (itParamSet == parametersSets_.end())
    throw DYNError(DYN::Error::API, ParametersSetNotFound, id);
  return itParamSet->second;
}

bool
ParametersSetCollection::hasParametersSet(const string& id) {
  return (parametersSets_.find(id) != parametersSets_.end());
}

void
ParametersSetCollection::propagateOriginData(const std::string& filepath) {
  for (map<string, shared_ptr<ParametersSet> >::const_iterator itParams = parametersSets_.begin();
          itParams != parametersSets_.end();
          ++itParams) {
    itParams->second->setFilePath(filepath);
  }
}

ParametersSetCollection::parametersSet_const_iterator
ParametersSetCollection::cbeginParametersSet() const {
  return ParametersSetCollection::parametersSet_const_iterator(this, true);
}

ParametersSetCollection::parametersSet_const_iterator
ParametersSetCollection::cendParametersSet() const {
  return ParametersSetCollection::parametersSet_const_iterator(this, false);
}

ParametersSetCollection::parametersSet_const_iterator::parametersSet_const_iterator(const ParametersSetCollection* iterated, bool begin) :
current_((begin ? iterated->parametersSets_.begin() : iterated->parametersSets_.end())) { }

ParametersSetCollection::parametersSet_const_iterator&
ParametersSetCollection::parametersSet_const_iterator::operator++() {
  ++current_;
  return *this;
}

ParametersSetCollection::parametersSet_const_iterator
ParametersSetCollection::parametersSet_const_iterator::operator++(int) {
  ParametersSetCollection::parametersSet_const_iterator previous = *this;
  current_++;
  return previous;
}

ParametersSetCollection::parametersSet_const_iterator&
ParametersSetCollection::parametersSet_const_iterator::operator--() {
  --current_;
  return *this;
}

ParametersSetCollection::parametersSet_const_iterator
ParametersSetCollection::parametersSet_const_iterator::operator--(int) {
  ParametersSetCollection::parametersSet_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
ParametersSetCollection::parametersSet_const_iterator::operator==(const ParametersSetCollection::parametersSet_const_iterator& other) const {
  return current_ == other.current_;
}

bool
ParametersSetCollection::parametersSet_const_iterator::operator!=(const ParametersSetCollection::parametersSet_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<ParametersSet>&
ParametersSetCollection::parametersSet_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<ParametersSet>*
ParametersSetCollection::parametersSet_const_iterator::operator->() const {
  return &(current_->second);
}

}  // namespace parameters
