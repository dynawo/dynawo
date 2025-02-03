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
 * @file PARParametersSet.cpp
 * @brief Dynawo parameters set : implementation file
 *
 */
#include <sstream>
#include <set>
#include "DYNMacrosMessage.h"

#include "PARParametersSet.h"
#include "PARParameter.h"
#include "PARParameterFactory.h"
#include "PARMacroParSet.h"

using std::map;
using std::set;
using std::string;
using std::vector;
using std::stringstream;
using std::unordered_map;

using std::dynamic_pointer_cast;
using std::shared_ptr;

namespace parameters {

ParametersSet::ParametersSet(const string& id) :
id_(id) {
}

const std::string&
ParametersSet::getId() const {
  return id_;
}

const std::string&
ParametersSet::getFilePath() const {
  return filepath_;
}

void
ParametersSet::setFilePath(const std::string& filepath) {
  filepath_ = filepath;
}

// in case of using omc, parameter A[1] will be renamed A_1
// A[1][1] will ne renamed A_1_1
// in par file, A[1] will be declared with row = 1, column =1, so we create two names:
// A_1_1 and A_1 (using column index)

vector<string> ParametersSet::tableParameterNames(const string& name, const string& row, const string& column) const {
  vector<string> names;
  stringstream nameFull;

  nameFull.str("");
  nameFull << name << "_" << row << "_" << column << "_";
  names.push_back(nameFull.str());

  // all further names will be created as aliases
  if (row == "1") {
    nameFull.str("");
    nameFull << name << "_" << column << "_";
    names.push_back(nameFull.str());
  }

  return names;
}

std::shared_ptr<ParametersSet> ParametersSet::createAlias(const string& aliasName, const string& origName) {
  if ((!hasParameter(origName)) || (hasParameter(aliasName))) {
    throw DYNError(DYN::Error::API, ParameterAliasFailed, aliasName, origName, id_);
  }
  parameters_[aliasName] = parameters_[origName];

  return shared_from_this();
}

// only create one parameter object, then create aliases pointing towards the first object

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, bool value, const string& row, const string& column) {
  return addParameter<bool>(name, value, row, column);
}

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, int value, const string& row, const string& column) {
  return addParameter<int>(name, value, row, column);
}

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, double value, const string& row, const string& column) {
  return addParameter<double>(name, value, row, column);
}

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, const string& value, const string& row, const string& column) {
  return addParameter<string>(name, value, row, column);
}

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, const bool value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, const int value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, const double value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

std::shared_ptr<ParametersSet>
ParametersSet::createParameter(const string& name, const string& value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

std::shared_ptr<ParametersSet>
ParametersSet::addParameter(const shared_ptr<Parameter>& param) {
  const string name = param->getName();
  if (hasParameter(name)) {
    throw DYNError(DYN::Error::API, ParameterAlreadyInSet, name, id_);
  }
  parameters_[name] = param;
  return shared_from_this();
}

std::shared_ptr<ParametersSet>
ParametersSet::addMacroParSet(const shared_ptr<MacroParSet>& macroParSet) {
  const string id = macroParSet->getId();
  if (hasMacroParSet(id))
    throw DYNError(DYN::Error::API, MacroParSetAlreadyExists, id, id_);
  macroParSets_[id] = macroParSet;
  return shared_from_this();
}

const shared_ptr<Parameter>
ParametersSet::getParameter(const string& name) const {
  map<string, shared_ptr<Parameter> >::const_iterator itParam = parameters_.find(name);
  if (itParam == parameters_.end())
    throw DYNError(DYN::Error::API, ParameterNotFoundInSet, name, id_);

  itParam->second->setUsed(true);

  return itParam->second;
}

const shared_ptr<Reference>
ParametersSet::getReference(const string& name) const {
  unordered_map<string, shared_ptr<Reference> >::const_iterator itRef = references_.find(name);
  if (itRef == references_.end())
    throw DYNError(DYN::Error::API, ReferenceNotFoundInSet, name, id_);
  return itRef->second;
}

bool
ParametersSet::hasParameter(const string& name) const {
  return (parameters_.find(name) != parameters_.end());
}

bool
ParametersSet::hasMacroParSet(const string& id) const {
  return (macroParSets_.find(id) != macroParSets_.end());
}

bool
ParametersSet::hasMacroParSet() const {
  return (!macroParSets_.empty());
}

bool
ParametersSet::hasReference(const string& name) const {
  return (references_.find(name) != references_.end());
}

void
ParametersSet::extend(std::shared_ptr<ParametersSet> parametersSet) {
  const map<string, shared_ptr<Parameter> >& mapParameters = dynamic_pointer_cast<ParametersSet>(parametersSet)->getParameters();
  parameters_.insert(mapParameters.begin(), mapParameters.end());
}

vector<string>
ParametersSet::getParametersNames() const {
  vector<string> returnVector;
  for (map<string, shared_ptr<Parameter> >::const_iterator itParams = parameters_.begin();
          itParams != parameters_.end();
          ++itParams) {
    returnVector.push_back(itParams->first);
  }
  return returnVector;
}

vector<string>
ParametersSet::getParamsUnused() const {
  vector<string> returnVector;
  for (map<string, shared_ptr<Parameter> >::const_iterator itParams = parameters_.begin();
          itParams != parameters_.end();
          ++itParams) {
    if (!itParams->second->getUsed()) {
      returnVector.push_back(itParams->first);
    }
  }
  return returnVector;
}

vector<string>
ParametersSet::getReferencesNames() const {
  vector<string> returnVector;
  set<string> orderedNames;
  for (unordered_map<string, shared_ptr<Reference> >::const_iterator itRefs = references_.begin();
          itRefs != references_.end();
          ++itRefs) {
    orderedNames.insert(itRefs->first);
  }
  for (set<string>::const_iterator itRefs = orderedNames.begin();
          itRefs != orderedNames.end();
          ++itRefs) {
    returnVector.push_back(*itRefs);
  }
  return returnVector;
}

std::shared_ptr<ParametersSet>
ParametersSet::addReference(const std::shared_ptr<Reference>& ref) {
  const string& refName = ref->getName();
  if (hasReference(refName)) {
    throw DYNError(DYN::Error::API, ReferenceAlreadySet, refName);
  }
  references_[refName] = ref;
  return shared_from_this();
}

map<string, shared_ptr<Parameter> >&
ParametersSet::getParameters() {
  return parameters_;
}

unordered_map<std::string, std::shared_ptr<Reference> >&
ParametersSet::getReferences() {
  return references_;
}

ParametersSet::parameter_const_iterator
ParametersSet::cbeginParameter() const {
  return ParametersSet::parameter_const_iterator(this, true);
}

ParametersSet::parameter_const_iterator
ParametersSet::cendParameter() const {
  return ParametersSet::parameter_const_iterator(this, false);
}

ParametersSet::reference_const_iterator
ParametersSet::cbeginReference() const {
  return ParametersSet::reference_const_iterator(this, true);
}

ParametersSet::reference_const_iterator
ParametersSet::cendReference() const {
  return ParametersSet::reference_const_iterator(this, false);
}

ParametersSet::parameter_const_iterator::parameter_const_iterator(const ParametersSet* iterated, bool begin) :
current_((begin ? iterated->parameters_.begin() : iterated->parameters_.end())) { }

ParametersSet::parameter_const_iterator&
ParametersSet::parameter_const_iterator::operator++() {
  ++current_;
  return *this;
}

ParametersSet::parameter_const_iterator
ParametersSet::parameter_const_iterator::operator++(int) {
  ParametersSet::parameter_const_iterator previous = *this;
  current_++;
  return previous;
}

ParametersSet::parameter_const_iterator&
ParametersSet::parameter_const_iterator::operator--() {
  --current_;
  return *this;
}

ParametersSet::parameter_const_iterator
ParametersSet::parameter_const_iterator::operator--(int) {
  ParametersSet::parameter_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
ParametersSet::parameter_const_iterator::operator==(const ParametersSet::parameter_const_iterator& other) const {
  return current_ == other.current_;
}

bool
ParametersSet::parameter_const_iterator::operator!=(const ParametersSet::parameter_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Parameter>&
ParametersSet::parameter_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<Parameter>*
ParametersSet::parameter_const_iterator::operator->() const {
  return &(current_->second);
}

// for Reference

ParametersSet::reference_const_iterator::reference_const_iterator(const ParametersSet* iterated, bool begin) :
current_((begin ? iterated->references_.begin() : iterated->references_.end())) { }

ParametersSet::reference_const_iterator&
ParametersSet::reference_const_iterator::operator++() {
  ++current_;
  return *this;
}

ParametersSet::reference_const_iterator
ParametersSet::reference_const_iterator::operator++(int) {
  ParametersSet::reference_const_iterator previous = *this;
  current_++;
  return previous;
}

bool
ParametersSet::reference_const_iterator::operator==(const ParametersSet::reference_const_iterator& other) const {
  return current_ == other.current_;
}

bool
ParametersSet::reference_const_iterator::operator!=(const ParametersSet::reference_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Reference>&
ParametersSet::reference_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<Reference>*
ParametersSet::reference_const_iterator::operator->() const {
  return &(current_->second);
}

// for macroParSet

ParametersSet::macroparset_const_iterator::macroparset_const_iterator(const ParametersSet* iterated, bool begin) :
current_((begin ? iterated->macroParSets_.begin() : iterated->macroParSets_.end())) { }

ParametersSet::macroparset_const_iterator&
ParametersSet::macroparset_const_iterator::operator++() {
  ++current_;
  return *this;
}

ParametersSet::macroparset_const_iterator
ParametersSet::macroparset_const_iterator::operator++(int) {
  ParametersSet::macroparset_const_iterator previous = *this;
  current_++;
  return previous;
}

bool
ParametersSet::macroparset_const_iterator::operator==(const ParametersSet::macroparset_const_iterator& other) const {
  return current_ == other.current_;
}

bool
ParametersSet::macroparset_const_iterator::operator!=(const ParametersSet::macroparset_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroParSet>&
ParametersSet::macroparset_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<MacroParSet>*
ParametersSet::macroparset_const_iterator::operator->() const {
  return &(current_->second);
}

ParametersSet::macroparset_const_iterator
ParametersSet::cbeginMacroParSet() const {
  return ParametersSet::macroparset_const_iterator(this, true);
}

ParametersSet::macroparset_const_iterator
ParametersSet::cendMacroParSet() const {
  return ParametersSet::macroparset_const_iterator(this, false);
}

}  // namespace parameters
