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
#include "DYDIterators.h"
#include "DYDMacroStaticRef.h"
#include "DYDStaticRef.h"
#include "DYDStaticRefFactory.h"
#include "DYNMacrosMessage.h"

using std::map;
using std::string;
using std::vector;

using boost::shared_ptr;

namespace dynamicdata {

Model::Model(const string& id, ModelType type) : id_(IdentifiableFactory::newIdentifiable(id)), type_(type) {}

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
Model::addStaticRef(boost::shared_ptr<StaticRef> staticRef) {
  const std::string var = staticRef->getModelVar();
  const std::string staticVar = staticRef->getStaticVar();
  return addStaticRef(var, staticVar);
}

Model&
Model::addStaticRef(const string& var, const string& staticVar) {
  // The staticRef key in the map is var_staticVar
  string key = var + '_' + staticVar;
  std::pair<std::map<std::string, boost::shared_ptr<StaticRef> >::iterator, bool> ret;
  ret = staticRefs_.emplace(key, shared_ptr<StaticRef>(StaticRefFactory::newStaticRef(var, staticVar)));
  if (!ret.second)
    throw DYNError(DYN::Error::API, StaticRefNotUnique, getId(), var, staticVar);

  return *this;
}

void
Model::addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef) {
  const string& id = macroStaticRef->getId();
  std::pair<std::map<std::string, boost::shared_ptr<MacroStaticRef> >::iterator, bool> ret;
  ret = macroStaticRefs_.emplace(id, macroStaticRef);
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroStaticRefNotUnique, getId(), id);
}

staticRef_const_iterator
Model::cbeginStaticRef() const {
  return staticRef_const_iterator(this, true);
}

staticRef_const_iterator
Model::cendStaticRef() const {
  return staticRef_const_iterator(this, false);
}

macroStaticRef_const_iterator
Model::cbeginMacroStaticRef() const {
  return macroStaticRef_const_iterator(this, true);
}

macroStaticRef_const_iterator
Model::cendMacroStaticRef() const {
  return macroStaticRef_const_iterator(this, false);
}

staticRef_iterator
Model::beginStaticRef() {
  return staticRef_iterator(this, true);
}

staticRef_iterator
Model::endStaticRef() {
  return staticRef_iterator(this, false);
}

macroStaticRef_iterator
Model::beginMacroStaticRef() {
  return macroStaticRef_iterator(this, true);
}

macroStaticRef_iterator
Model::endMacroStaticRef() {
  return macroStaticRef_iterator(this, false);
}

const shared_ptr<StaticRef>&
Model::findStaticRef(const string& key) {
  map<string, shared_ptr<StaticRef> >::const_iterator iter = staticRefs_.find(key);
  if (iter == staticRefs_.end())
    throw DYNError(DYN::Error::API, StaticRefUndefined, key);

  return iter->second;
}

const shared_ptr<MacroStaticRef>&
Model::findMacroStaticRef(const string& id) {
  map<string, shared_ptr<MacroStaticRef> >::const_iterator iter = macroStaticRefs_.find(id);
  if (iter == macroStaticRefs_.end())
    throw DYNError(DYN::Error::API, MacroStaticRefUndefined, id);

  return iter->second;
}

}  // namespace dynamicdata
