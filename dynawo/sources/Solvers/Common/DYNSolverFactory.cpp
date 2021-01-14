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
#include "DYNMacrosMessage.h"

using std::map;
using std::string;
using std::stringstream;

namespace DYN {
/**
 * @brief type of the function return by dlsym
 */
typedef SolverFactory* getFactory_t();

SolverFactories SolverFactory::factories_;

SolverFactories::SolverFactories() { }

SolverFactories::~SolverFactories() {
  SolverFactoryIterator iter = factoryMap_.begin();
  for (; iter != factoryMap_.end(); ++iter) {
    void* handle = iter->second->handle_;

    destroy_solver_t* deleteFactory = factoryMapDestroy_.find(iter->first)->second;

    deleteFactory(iter->second);

    if (handle) {
      dlclose(handle);
    }
  }
}

SolverFactories::SolverFactoryIterator SolverFactories::find(const std::string& lib) {
  return (factoryMap_.find(lib));
}

bool SolverFactories::end(SolverFactoryIterator& iter) {
  return (iter == factoryMap_.end());
}

void
SolverFactories::add(const std::string& lib, SolverFactory* factory) {
  factoryMap_.insert(std::make_pair(lib, factory));
}

void SolverFactories::add(const std::string& lib, destroy_solver_t* deleteFactory) {
  factoryMapDestroy_.insert(std::make_pair(lib, deleteFactory));
}

boost::shared_ptr<Solver> SolverFactory::createSolverFromLib(const std::string& lib) {
  SolverFactories::SolverFactoryIterator iter = factories_.find(lib);
  Solver* solver;
  boost::shared_ptr<Solver> solverShared;

  if (factories_.end(iter)) {
    // load the library
    void* handle;
    handle = dlopen(lib.c_str(), RTLD_NOW);
    if (!handle) {
      stringstream msg;
      msg << "Load error :" << dlerror();
      ::TraceError() << msg.str() << Trace::endline;
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib);
    }

    // reset errors
    dlerror();

    getFactory_t* getFactory = reinterpret_cast<getFactory_t*> (dlsym(handle, "getFactory"));
    const char* dlsym_error = dlerror();
    if (dlsym_error) {
      stringstream msg;
      msg << "Load error :" << dlsym_error;
      ::TraceError() << msg.str() << Trace::endline;
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib+"::getFactory");
    }

    destroy_solver_t* deleteFactory = reinterpret_cast<destroy_solver_t*>(dlsym(handle, "deleteFactory"));
    dlsym_error = dlerror();
    if (dlsym_error) {
      stringstream msg;
      msg << "Load error :" << dlsym_error;
      ::TraceError() << msg.str() << Trace::endline;
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib+"::deleteFactory");
    }

    SolverFactory* factory = getFactory();
    factory->handle_ = handle;
    factories_.add(lib, factory);
    factories_.add(lib, deleteFactory);
    solver = factory->create();
    SolverDelete deleteSolver(factory);
    solverShared.reset(solver, deleteSolver);
  } else {
    solver = iter->second->create();
    SolverDelete deleteSolver(iter->second);
    solverShared.reset(solver, deleteSolver);
  }
  return solverShared;
}

SolverDelete::SolverDelete(SolverFactory* factory) : factory_(factory) {
}

void SolverDelete::operator()(Solver* solver) {
  factory_->destroy(solver);
}

}  // end of namespace DYN
