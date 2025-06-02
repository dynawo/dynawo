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
 * @file DYDModel.cpp
 * @brief Model description : implementation file
 *
 */

#include "DYDModel.h"

#include "DYDIdentifiable.h"
#include "DYDIdentifiableFactory.h"
#include "DYDMacroStaticRef.h"
#include "DYDStaticRef.h"
#include "DYDStaticRefFactory.h"
#include "DYNMacrosMessage.h"

using std::map;
using std::string;

namespace dynamicdata {

Model::Model(const string& id, const ModelType type) : id_(IdentifiableFactory::newIdentifiable(id)), type_(type) {}

Model::~Model() {}

const string&
Model::getId() const {
  return id_->get();
}

Model::ModelType
Model::getType() const {
  return type_;
}

Model&
Model::addStaticRef(const string& var, const string& staticVar) {
  // The staticRef key in the map is var_staticVar
  string key = var + '_' + staticVar;
  std::pair<std::map<std::string, std::unique_ptr<StaticRef> >::iterator, bool> ret;
  ret = staticRefs_.emplace(key, StaticRefFactory::newStaticRef(var, staticVar));
  if (!ret.second)
    throw DYNError(DYN::Error::API, StaticRefNotUnique, getId(), var, staticVar);

  return *this;
}

void
Model::addMacroStaticRef(const std::shared_ptr<MacroStaticRef>& macroStaticRef) {
  const string& id = macroStaticRef->getId();
  std::pair<std::map<std::string, std::shared_ptr<MacroStaticRef> >::iterator, bool> ret;
  ret = macroStaticRefs_.emplace(id, macroStaticRef);
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroStaticRefNotUnique, getId(), id);
}

const std::unique_ptr<StaticRef>&
Model::findStaticRef(const string& key) {
  map<string, std::unique_ptr<StaticRef> >::const_iterator iter = staticRefs_.find(key);
  if (iter == staticRefs_.end())
    throw DYNError(DYN::Error::API, StaticRefUndefined, key);

  return iter->second;
}

const std::shared_ptr<MacroStaticRef>&
Model::findMacroStaticRef(const string& id) {
  map<string, std::shared_ptr<MacroStaticRef> >::const_iterator iter = macroStaticRefs_.find(id);
  if (iter == macroStaticRefs_.end())
    throw DYNError(DYN::Error::API, MacroStaticRefUndefined, id);

  return iter->second;
}

}  // namespace dynamicdata
