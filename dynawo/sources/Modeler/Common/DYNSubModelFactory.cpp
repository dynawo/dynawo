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
 * @file  DYNSubModelFactory.cpp
 *
 * @brief sub-model factory implementation file
 *
 */
#include <map>
#include <iostream>
#include <dlfcn.h>
#include "DYNSubModelFactory.h"
#include "DYNTrace.h"
#include "DYNSubModel.h"

using std::map;
using std::string;
using std::stringstream;

namespace DYN {
SubModelFactories SubModelFactory::factories_;

SubModelFactories::SubModelFactories() {
}

SubModelFactories::~SubModelFactories() {
  std::map<std::string, SubModelFactory*>::iterator iter = factoryMap_.begin();
  for (; iter != factoryMap_.end(); ++iter)
    delete iter->second;
}

std::map<std::string, SubModelFactory*>::iterator
SubModelFactories::find(const std::string & lib) {
  return ( factoryMap_.find(lib));
}

bool
SubModelFactories::end(std::map<std::string, SubModelFactory*>::iterator & iter) {
  return (iter == factoryMap_.end());
}

void
SubModelFactories::add(const std::string & lib, SubModelFactory * factory) {
  factoryMap_[lib] = factory;
}

void
SubModelFactories::reset() {
  std::map<std::string, SubModelFactory*>::iterator iter = factoryMap_.begin();
  for (; iter != factoryMap_.end(); ++iter) {
    void * handle = iter->second->handle_;
    delete iter->second;

    if (handle)
      dlclose(handle);
  }
  factoryMap_.clear();
}

SubModel* SubModelFactory::createSubModelFromLib(const std::string & lib) {
  typedef SubModelFactory * getFactory_t();

  map<string, SubModelFactory* >::iterator iter = factories_.find(lib);
  SubModel* model;

  if (factories_.end(iter)) {
    // load the library
    void *handle;
    handle = dlopen(lib.c_str(), RTLD_NOW);
    char * error;
    if (!handle) {
      stringstream msg;
      msg << "Load error :" << dlerror();
      Trace::error() << msg.str() << Trace::endline;
      throw(msg.str().c_str());
    }

    dlerror();
    getFactory_t* getFactory = reinterpret_cast<getFactory_t*> (dlsym(handle, "getFactory"));
    if ((error = dlerror()) != NULL) {
      stringstream msg;
      msg << "Load error :" << error;
      Trace::error() << msg.str() << Trace::endline;
      throw(msg.str().c_str());
    }
    SubModelFactory * factory = getFactory();
    factory->handle_ = handle;
    factories_.add(lib, factory);
    model = factory->create();
  } else {
    model = iter->second->create();
  }
  return model;
}

void SubModelFactory::resetFactories() {
  factories_.reset();
}

}  // namespace DYN
