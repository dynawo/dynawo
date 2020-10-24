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
 * @file PARParametersSetImpl.h
 * @brief Dynawo parameters set : implementation file
 *
 */
#include <sstream>
#include <set>
#include "DYNMacrosMessage.h"

#include "PARParametersSetImpl.h"
#include "PARParameter.h"
#include "PARParameterFactory.h"

using std::map;
using std::set;
using std::string;
using std::vector;
using std::stringstream;

using boost::dynamic_pointer_cast;
using boost::shared_ptr;
using boost::unordered_map;

namespace parameters {

ParametersSet::Impl::Impl(const string& id) :
id_(id) {
}

ParametersSet::Impl::~Impl() {
}

const std::string&
ParametersSet::Impl::getId() const {
  return id_;
}

const std::string&
ParametersSet::Impl::getFilePath() const {
  return filepath_;
}

void
ParametersSet::Impl::setFilePath(const std::string& filepath) {
  filepath_ = filepath;
}

// in case of using omc, parameter A[1] will be renamed A_1
// A[1][1] will ne renamed A_1_1
// in par file, A[1] will be declared with row = 1, column =1, so we create two names:
// A_1_1 and A_1 (using column index)

vector<string> ParametersSet::Impl::tableParameterNames(const string& name, const string& row, const string& column) const {
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

shared_ptr<ParametersSet> ParametersSet::Impl::createAlias(const string& aliasName, const string& origName) {
  if ((!hasParameter(origName)) || (hasParameter(aliasName))) {
    throw DYNError(DYN::Error::API, ParameterAliasFailed, aliasName, origName, id_);
  }
  parameters_[aliasName] = parameters_[origName];

  return shared_from_this();
}

// only create one parameter object, then create aliases pointing towards the first object

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, bool value, const string& row, const string& column) {
  return addParameter<bool>(name, value, row, column);
}

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, int value, const string& row, const string& column) {
  return addParameter<int>(name, value, row, column);
}

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, double value, const string& row, const string& column) {
  return addParameter<double>(name, value, row, column);
}

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, const string& value, const string& row, const string& column) {
  return addParameter<string>(name, value, row, column);
}

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, const bool value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, const int value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, const double value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

shared_ptr<ParametersSet>
ParametersSet::Impl::createParameter(const string& name, const string& value) {
  return addParameter(ParameterFactory::newParameter(name, value));
}

shared_ptr<ParametersSet>
ParametersSet::Impl::addParameter(const shared_ptr<Parameter>& param) {
  const string name = param->getName();
  if (hasParameter(name)) {
    throw DYNError(DYN::Error::API, ParameterAlreadyInSet, name, id_);
  }
  parameters_[name] = param;
  return shared_from_this();
}

const shared_ptr<Parameter>
ParametersSet::Impl::getParameter(const string& name) const {
  map<string, shared_ptr<Parameter> >::const_iterator itParam = parameters_.find(name);
  if (itParam == parameters_.end())
    throw DYNError(DYN::Error::API, ParameterNotFoundInSet, name, id_);

  itParam->second->setUsed(true);

  return itParam->second;
}

const shared_ptr<Reference>
ParametersSet::Impl::getReference(const string& name) const {
  unordered_map<string, shared_ptr<Reference> >::const_iterator itRef = references_.find(name);
  if (itRef == references_.end())
    throw DYNError(DYN::Error::API, ReferenceNotFoundInSet, name, id_);
  return itRef->second;
}

bool
ParametersSet::Impl::hasParameter(const string& name) const {
  return (parameters_.find(name) != parameters_.end());
}

bool
ParametersSet::Impl::hasReference(const string& name) const {
  return (references_.find(name) != references_.end());
}

void
ParametersSet::Impl::extend(shared_ptr<ParametersSet> parametersSet) {
  const map<string, shared_ptr<Parameter> >& mapParameters = dynamic_pointer_cast<ParametersSet::Impl>(parametersSet)->getParameters();
  parameters_.insert(mapParameters.begin(), mapParameters.end());
}

vector<string>
ParametersSet::Impl::getParametersNames() const {
  vector<string> returnVector;
  for (map<string, shared_ptr<Parameter> >::const_iterator itParams = parameters_.begin();
          itParams != parameters_.end();
          ++itParams) {
    returnVector.push_back(itParams->first);
  }
  return returnVector;
}

vector<string>
ParametersSet::Impl::getParamsUnused() const {
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
ParametersSet::Impl::getReferencesNames() const {
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

shared_ptr<ParametersSet>
ParametersSet::Impl::addReference(boost::shared_ptr<Reference> ref) {
  const string& refName = ref->getName();
  if (hasReference(refName)) {
    throw DYNError(DYN::Error::API, ReferenceAlreadySet, refName);
  }
  references_[refName] = ref;
  return shared_from_this();
}

map<string, shared_ptr<Parameter> >&
ParametersSet::Impl::getParameters() {
  return parameters_;
}

ParametersSet::parameter_const_iterator
ParametersSet::Impl::cbeginParameter() const {
  return ParametersSet::parameter_const_iterator(this, true);
}

ParametersSet::parameter_const_iterator
ParametersSet::Impl::cendParameter() const {
  return ParametersSet::parameter_const_iterator(this, false);
}

ParametersSet::reference_const_iterator
ParametersSet::Impl::cbeginReference() const {
  return ParametersSet::reference_const_iterator(this, true);
}

ParametersSet::reference_const_iterator
ParametersSet::Impl::cendReference() const {
  return ParametersSet::reference_const_iterator(this, false);
}

ParametersSet::BaseIteratorImpl::BaseIteratorImpl(const ParametersSet::Impl* iterated, bool begin) :
current_((begin ? iterated->parameters_.begin() : iterated->parameters_.end())) { }

ParametersSet::BaseIteratorImpl::~BaseIteratorImpl() {
}

ParametersSet::BaseIteratorImpl&
ParametersSet::BaseIteratorImpl::operator++() {
  ++current_;
  return *this;
}

ParametersSet::BaseIteratorImpl
ParametersSet::BaseIteratorImpl::operator++(int) {
  ParametersSet::BaseIteratorImpl previous = *this;
  current_++;
  return previous;
}

ParametersSet::BaseIteratorImpl&
ParametersSet::BaseIteratorImpl::operator--() {
  --current_;
  return *this;
}

ParametersSet::BaseIteratorImpl
ParametersSet::BaseIteratorImpl::operator--(int) {
  ParametersSet::BaseIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
ParametersSet::BaseIteratorImpl::operator==(const ParametersSet::BaseIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
ParametersSet::BaseIteratorImpl::operator!=(const ParametersSet::BaseIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Parameter>&
ParametersSet::BaseIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<Parameter>*
ParametersSet::BaseIteratorImpl::operator->() const {
  return &(current_->second);
}

// for Reference

ParametersSet::BaseIteratorRefImpl::BaseIteratorRefImpl(const ParametersSet::Impl* iterated, bool begin) :
current_((begin ? iterated->references_.begin() : iterated->references_.end())) { }

ParametersSet::BaseIteratorRefImpl::~BaseIteratorRefImpl() {
}

ParametersSet::BaseIteratorRefImpl&
ParametersSet::BaseIteratorRefImpl::operator++() {
  ++current_;
  return *this;
}

ParametersSet::BaseIteratorRefImpl
ParametersSet::BaseIteratorRefImpl::operator++(int) {
  ParametersSet::BaseIteratorRefImpl previous = *this;
  current_++;
  return previous;
}

bool
ParametersSet::BaseIteratorRefImpl::operator==(const ParametersSet::BaseIteratorRefImpl& other) const {
  return current_ == other.current_;
}

bool
ParametersSet::BaseIteratorRefImpl::operator!=(const ParametersSet::BaseIteratorRefImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Reference>&
ParametersSet::BaseIteratorRefImpl::operator*() const {
  return current_->second;
}

const shared_ptr<Reference>*
ParametersSet::BaseIteratorRefImpl::operator->() const {
  return &(current_->second);
}

}  // namespace parameters
