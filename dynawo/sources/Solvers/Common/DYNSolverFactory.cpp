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
 * @file DYNSolverFactory.cpp
 * @brief Solver factory implementation
 *
 */

#include <dlfcn.h>
#include <sstream>
#include <iostream>

#include "DYNTrace.h"
#include "DYNSolverFactory.h"

using std::map;
using std::string;
using std::stringstream;

namespace DYN {

  SolverFactories SolverFactory::factories_;

  /**
   * @brief type of the function return by dlsym
   */
  typedef SolverFactory * getFactory_t();

  SolverFactories::SolverFactories() {
  }

  SolverFactories::~SolverFactories() {
    std::map<std::string, SolverFactory*>::iterator iter = factoryMap_.begin();
    for (; iter != factoryMap_.end(); ++iter)
      delete iter->second;
  }

  std::map<std::string, SolverFactory*>::iterator
  SolverFactories::find(const std::string & lib) {
    return (factoryMap_.find(lib));
  }

  bool
  SolverFactories::end(std::map<std::string, SolverFactory*>::iterator & iter) {
    return (iter == factoryMap_.end());
  }

  void
  SolverFactories::add(const std::string & lib, SolverFactory * factory) {
    factoryMap_[lib] = factory;
  }

  void
  SolverFactories::reset() {
    std::map<std::string, SolverFactory*>::iterator iter = factoryMap_.begin();
    for (; iter != factoryMap_.end(); ++iter) {
      void * handle = iter->second->handle_;
      delete iter->second;

      if (handle)
        dlclose(handle);
    }
    factoryMap_.clear();
  }

  Solver* SolverFactory::createSolverFromLib(const std::string & lib) {
    map<string, SolverFactory* >::iterator iter = factories_.find(lib);
    Solver* solver;

    if (factories_.end(iter)) {
      // Loading library
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
      SolverFactory * factory = getFactory();
      factory->handle_ = handle;
      factories_.add(lib, factory);
      solver = factory->create();
    } else {
      solver = iter->second->create();
    }
    return solver;
  }

  SolverFactory::SolverFactory() {
    handle_ = NULL;
  }

  SolverFactory::~SolverFactory() {
    // if( handle_ != NULL)
    // {
    //   dlclose(handle_);
    // }
  }

  void SolverFactory::resetFactories() {
    factories_.reset();
  }

}  // end of namespace DYN
