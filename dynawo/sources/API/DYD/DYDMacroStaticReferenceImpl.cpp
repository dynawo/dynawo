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
 * @file DYDMacroStaticReferenceImpl.cpp
 * @brief MacroStaticReference description : implementation file
 *
 */

#include "DYNMacrosMessage.h"

#include "DYDMacroStaticReferenceImpl.h"
#include "DYDStaticRefFactory.h"
#include "DYDStaticRef.h"
#include "DYDIterators.h"

using std::string;
using std::map;
using std::vector;
using boost::shared_ptr;

namespace dynamicdata {

MacroStaticReference::Impl::Impl(const string& id) :
id_(id) {
}

MacroStaticReference::Impl::~Impl() {
}

string
MacroStaticReference::Impl::getId() const {
  return id_;
}

void
MacroStaticReference::Impl::addStaticRef(const string& var, const string& staticVar) {
  // The staticRef key in the map is var_staticVar
  string key = var + '_' + staticVar;
  std::pair<std::map<std::string, boost::shared_ptr<StaticRef> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = staticRefs_.emplace(key, shared_ptr<StaticRef>(StaticRefFactory::newStaticRef(var, staticVar)));
#else
  ret = staticRefs_.insert(std::make_pair(key, shared_ptr<StaticRef>(StaticRefFactory::newStaticRef(var, staticVar))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, StaticRefNotUniqueInMacro, id_, var, staticVar);
}

staticRef_const_iterator
MacroStaticReference::Impl::cbeginStaticRef() const {
  return staticRef_const_iterator(this, true);
}

staticRef_const_iterator
MacroStaticReference::Impl::cendStaticRef() const {
  return staticRef_const_iterator(this, false);
}

staticRef_iterator
MacroStaticReference::Impl::beginStaticRef() {
  return staticRef_iterator(this, true);
}

staticRef_iterator
MacroStaticReference::Impl::endStaticRef() {
  return staticRef_iterator(this, false);
}

const shared_ptr<StaticRef>&
MacroStaticReference::Impl::findStaticRef(const string& key) {
  map<string, shared_ptr<StaticRef> >::const_iterator iter = staticRefs_.find(key);
  if (iter == staticRefs_.end())
    throw DYNError(DYN::Error::API, StaticRefUndefined, key);

  return iter->second;
}

}  // namespace dynamicdata

