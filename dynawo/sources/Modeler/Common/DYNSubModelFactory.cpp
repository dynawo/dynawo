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
typedef SubModelFactory* getFactory_t();

SubModelFactories SubModelFactory::factories_;

SubModelFactories::SubModelFactories() {
}

SubModelFactories::~SubModelFactories() {
  SubmodelFactoryIterator iter = factoryMap_.begin();
  for (; iter != factoryMap_.end(); ++iter) {
    void* handle = iter->second->handle_;

    destroy_model_t* deleteFactory = factoryMapDestroy_.find(iter->first)->second;

    deleteFactory(iter->second);

    if (handle) {
      dlclose(handle);
    }
  }
}

SubModelFactories::SubmodelFactoryIterator SubModelFactories::find(const std::string& lib) {
  return (factoryMap_.find(lib));
}

bool SubModelFactories::end(SubmodelFactoryIterator& iter) {
  return (iter == factoryMap_.end());
}

void
SubModelFactories::add(const std::string& lib, SubModelFactory* factory) {
  factoryMap_.insert(std::make_pair(lib, factory));
}

void SubModelFactories::add(const std::string& lib, destroy_model_t* deleteFactory) {
  factoryMapDestroy_.insert(std::make_pair(lib, deleteFactory));
}

boost::shared_ptr<SubModel> SubModelFactory::createSubModelFromLib(const std::string & lib) {
  SubModelFactories::SubmodelFactoryIterator iter = factories_.find(lib);
  SubModel* subModel;
  boost::shared_ptr<SubModel> subModelShared;

  if (factories_.end(iter)) {
    // load the library
    void* handle;
    handle = dlopen(lib.c_str(), RTLD_NOW);
    if (!handle) {
      stringstream msg;
      msg << "Load error :" << dlerror();
      Trace::error() << msg.str() << Trace::endline;
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib);
    }

    // reset errors
    dlerror();

    getFactory_t* getFactory = reinterpret_cast<getFactory_t*> (dlsym(handle, "getFactory"));
    const char* dlsym_error = dlerror();
    if (dlsym_error) {
      stringstream msg;
      msg << "Load error :" << dlsym_error;
      Trace::error() << msg.str() << Trace::endline;
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib+"::getFactory");
    }

    destroy_model_t* deleteFactory = reinterpret_cast<destroy_model_t*>(dlsym(handle, "deleteFactory"));
    dlsym_error = dlerror();
    if (dlsym_error) {
      stringstream msg;
      msg << "Load error :" << dlsym_error;
      Trace::error() << msg.str() << Trace::endline;
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib+"::deleteFactory");
    }

    SubModelFactory* factory = getFactory();
    factory->handle_ = handle;
    factories_.add(lib, factory);
    factories_.add(lib, deleteFactory);
    subModel = factory->create();
    SubModelDelete deleteSubModel(factory);
    subModelShared.reset(subModel, deleteSubModel);
  } else {
    subModel = iter->second->create();
    SubModelDelete deleteSubModel(iter->second);
    subModelShared.reset(subModel, deleteSubModel);
  }
  return subModelShared;
}

SubModelDelete::SubModelDelete(SubModelFactory* factory) : factory_(factory) {
}

void SubModelDelete::operator()(SubModel* subModel) {
  factory_->destroy(subModel);
}

}  // namespace DYN
