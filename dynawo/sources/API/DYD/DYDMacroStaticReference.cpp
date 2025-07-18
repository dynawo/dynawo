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
 * @file DYDMacroStaticReference.cpp
 * @brief MacroStaticReference description : implementation file
 *
 */

#include "DYDMacroStaticReference.h"

#include "DYDStaticRef.h"
#include "DYDStaticRefFactory.h"
#include "DYNMacrosMessage.h"

using std::map;
using std::string;

namespace dynamicdata {

MacroStaticReference::MacroStaticReference(const string& id) : id_(id) {}

const string&
MacroStaticReference::getId() const {
  return id_;
}

void
MacroStaticReference::addStaticRef(const string& var, const string& staticVar) {
  // The staticRef key in the map is var_staticVar
  string key = var + '_' + staticVar;
  std::pair<std::map<std::string, std::unique_ptr<StaticRef> >::iterator, bool> ret;
  ret = staticRefs_.emplace(key, StaticRefFactory::newStaticRef(var, staticVar));
  if (!ret.second)
    throw DYNError(DYN::Error::API, StaticRefNotUniqueInMacro, id_, var, staticVar);
}

const std::unique_ptr<StaticRef>&
MacroStaticReference::findStaticRef(const string& key) {
  map<string, std::unique_ptr<StaticRef> >::const_iterator iter = staticRefs_.find(key);
  if (iter == staticRefs_.end())
    throw DYNError(DYN::Error::API, StaticRefUndefined, key);

  return iter->second;
}

}  // namespace dynamicdata
