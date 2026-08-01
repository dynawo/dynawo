//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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

vector<string> ParametersSet::tableParameterNames(const string& name, const string& row, const string& column) {
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

const shared_ptr<Parameter>&
ParametersSet::getParameter(const string& name) const {
  const auto itParam = parameters_.find(name);
  if (itParam == parameters_.end())
    throw DYNError(DYN::Error::API, ParameterNotFoundInSet, name, id_);

  itParam->second->setUsed(true);

  return itParam->second;
}

const shared_ptr<Reference>&
ParametersSet::getReference(const string& name) const {
  const auto itRef = references_.find(name);
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
ParametersSet::extend(const std::shared_ptr<ParametersSet>& parametersSet) {
  const map<string, shared_ptr<Parameter> >& mapParameters = dynamic_pointer_cast<ParametersSet>(parametersSet)->getParameters();
  parameters_.insert(mapParameters.begin(), mapParameters.end());
}

vector<string>
ParametersSet::getParametersNames() const {
  vector<string> returnVector;
  returnVector.reserve(parameters_.size());
  for (const auto& parameter : parameters_)
    returnVector.push_back(parameter.first);

  return returnVector;
}

vector<string>
ParametersSet::getParamsUnused() const {
  vector<string> returnVector;
  for (const auto& parameterPair : parameters_) {
    if (!parameterPair.second->getUsed()) {
      returnVector.push_back(parameterPair.first);
    }
  }
  return returnVector;
}

vector<string>
ParametersSet::getReferencesNames() const {
  set<string> orderedNames;
  for (const auto& referencePair : references_)
    orderedNames.insert(referencePair.first);

  vector<string> returnVector(orderedNames.begin(), orderedNames.end());

  return returnVector;
}

shared_ptr<ParametersSet>
ParametersSet::addReference(const std::shared_ptr<Reference>& ref) {
  const string& refName = ref->getName();
  if (hasReference(refName)) {
    throw DYNError(DYN::Error::API, ReferenceAlreadySet, refName);
  }
  references_[refName] = ref;
  return shared_from_this();
}

const map<string, shared_ptr<Parameter> >&
ParametersSet::getParameters() {
  return parameters_;
}

const unordered_map<std::string, std::shared_ptr<Reference> >&
ParametersSet::getReferences() {
  return references_;
}

const std::map<std::string, std::shared_ptr<MacroParSet> >&
ParametersSet::getMacroParSets() {
  return macroParSets_;
}

}  // namespace parameters
