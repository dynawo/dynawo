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

#include "DYNTrace.h"
#include "DYNCommon.h"
#include "DYNSolverFactory.h"
#include "DYNMacrosMessage.h"

using std::map;
using std::string;

namespace DYN {
/**
 * @brief type of the function return by dlsym
 */
typedef SolverFactory* getFactory_t();

SolverFactories::SolverFactories() {}

SolverFactories::~SolverFactories() {
  SolverFactoryIterator iter = factoryMap_.begin();
  for (; iter != factoryMap_.end(); ++iter) {
    boost::function<deleteSolverFactory_t>& deleteFactory = factoryMapDelete_.find(iter->first)->second;

    deleteFactory(iter->second);
  }
}

SolverFactories& SolverFactories::getInstance() {
  static SolverFactories factories;  ///< Factories already available
  return factories;
}

SolverFactories::SolverFactoryIterator SolverFactories::find(const std::string& lib) {
  return factoryMap_.find(lib);
}

bool SolverFactories::end(SolverFactoryIterator& iter) {
  return iter == factoryMap_.end();
}

void
SolverFactories::add(const std::string& lib, SolverFactory* factory) {
  factoryMap_.insert(std::make_pair(lib, factory));
}

void SolverFactories::add(const std::string& lib, const boost::function<deleteSolverFactory_t>& deleteFactory) {
  factoryMapDelete_.insert(std::make_pair(lib, deleteFactory));
}

SolverFactory::~SolverFactory() {}

SolverFactory::SolverPtr
SolverFactory::createSolverFromLib(const std::string& lib) {
  SolverFactories::SolverFactoryIterator iter = SolverFactories::getInstance().find(lib);
  Solver* solver;
  SolverPtr solverPtr;
  boost::shared_ptr<boost::dll::shared_library> sharedLib;

  if (SolverFactories::getInstance().end(iter)) {
    std::string func;
    boost::function<getFactory_t> getFactory;
    boost::function<deleteSolverFactory_t> deleteFactory;

    boost::optional<boost::filesystem::path> libPath = getLibraryPathFromName(lib);
    if (!libPath.is_initialized()) {
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib);
    }

    try {
      sharedLib = boost::make_shared<boost::dll::shared_library>(libPath->generic_string());
      func = "getFactory";
#if (BOOST_VERSION >= 107600)
      getFactory = boost::dll::import_symbol<getFactory_t>(*sharedLib, func.c_str());
#else
      getFactory = boost::dll::import<getFactory_t>(*sharedLib, func.c_str());
#endif
      func = "deleteFactory";
#if (BOOST_VERSION >= 107600)
      deleteFactory = boost::dll::import_symbol<deleteSolverFactory_t>(*sharedLib, func.c_str());
#else
      deleteFactory = boost::dll::import<deleteSolverFactory_t>(*sharedLib, func.c_str());
#endif
    } catch (const boost::system::system_error& e) {
      Trace::error() << "Load error :" << e.what() << Trace::endline;
      if (func.empty()) {
        throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib);
      } else {
        throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib + "::" + func);
      }
    }

    SolverFactory* factory = getFactory();
    factory->lib_ = sharedLib;
    SolverFactories::getInstance().add(lib, factory);
    SolverFactories::getInstance().add(lib, deleteFactory);
    solver = factory->create();
    SolverDelete deleteSolver(factory);
    solverPtr = SolverPtr(solver, deleteSolver);
  } else {
    solver = iter->second->create();
    SolverDelete deleteSolver(iter->second);
    solverPtr = SolverPtr(solver, deleteSolver);
  }
  return solverPtr;
}

SolverDelete::SolverDelete(SolverFactory* factory) : factory_(factory) {
}

void SolverDelete::operator()(Solver* solver) {
  factory_->destroy(solver);
}

}  // end of namespace DYN
