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
 * @file DYDModelImpl.cpp
 * @brief Model description : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "DYDModelImpl.h"
#include "DYDStaticRefFactory.h"
#include "DYDStaticRef.h"
#include "DYDMacroStaticRef.h"
#include "DYDIdentifiableFactory.h"
#include "DYDIdentifiable.h"
#include "DYDIterators.h"

using std::string;
using std::map;
using std::vector;

using boost::shared_ptr;

namespace dynamicdata {

Model::Impl::Impl(const string& id, ModelType type) :
id_(IdentifiableFactory::newIdentifiable(id)),
type_(type) {
}

Model::Impl::~Impl() {
}

string
Model::Impl::getId() const {
  return id_->get();
}

Model::ModelType
Model::Impl::getType() const {
  return type_;
}

Model&
Model::Impl::addStaticRef(const string& var, const string& staticVar) {
  // The staticRef key in the map is var_staticVar
  string key = var + '_' + staticVar;
  std::pair<std::map<std::string, boost::shared_ptr<StaticRef> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = staticRefs_.emplace(key, shared_ptr<StaticRef>(StaticRefFactory::newStaticRef(var, staticVar)));
#else
  ret = staticRefs_.insert(std::make_pair(key, shared_ptr<StaticRef>(StaticRefFactory::newStaticRef(var, staticVar))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, StaticRefNotUnique, getId(), var, staticVar);

  return *this;
}

void
Model::Impl::addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef) {
  string id = macroStaticRef->getId();
  std::pair<std::map<std::string, boost::shared_ptr<MacroStaticRef> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = macroStaticRefs_.emplace(id, macroStaticRef);
#else
  ret = macroStaticRefs_.insert(std::make_pair(id, macroStaticRef));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroStaticRefNotUnique, getId(), id);
}

staticRef_const_iterator
Model::Impl::cbeginStaticRef() const {
  return staticRef_const_iterator(this, true);
}

staticRef_const_iterator
Model::Impl::cendStaticRef() const {
  return staticRef_const_iterator(this, false);
}

macroStaticRef_const_iterator
Model::Impl::cbeginMacroStaticRef() const {
  return macroStaticRef_const_iterator(this, true);
}

macroStaticRef_const_iterator
Model::Impl::cendMacroStaticRef() const {
  return macroStaticRef_const_iterator(this, false);
}

staticRef_iterator
Model::Impl::beginStaticRef() {
  return staticRef_iterator(this, true);
}

staticRef_iterator
Model::Impl::endStaticRef() {
  return staticRef_iterator(this, false);
}

macroStaticRef_iterator
Model::Impl::beginMacroStaticRef() {
  return macroStaticRef_iterator(this, true);
}

macroStaticRef_iterator
Model::Impl::endMacroStaticRef() {
  return macroStaticRef_iterator(this, false);
}

const shared_ptr<StaticRef>&
Model::Impl::findStaticRef(const string& key) {
  map<string, shared_ptr<StaticRef> >::const_iterator iter = staticRefs_.find(key);
  if (iter == staticRefs_.end())
    throw DYNError(DYN::Error::API, StaticRefUndefined, key);

  return iter->second;
}

const shared_ptr<MacroStaticRef>&
Model::Impl::findMacroStaticRef(const string& id) {
  map<string, shared_ptr<MacroStaticRef> >::const_iterator iter = macroStaticRefs_.find(id);
  if (iter == macroStaticRefs_.end())
    throw DYNError(DYN::Error::API, MacroStaticRefUndefined, id);

  return iter->second;
}

}  // namespace dynamicdata
