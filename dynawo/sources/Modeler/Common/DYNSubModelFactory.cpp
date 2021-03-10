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
#include "DYNSubModelFactory.h"
#include "DYNTrace.h"
#include "DYNSubModel.h"
#include "DYNCommon.h"

#include <boost/dll/import.hpp>
#include <boost/make_shared.hpp>

using std::map;
using std::string;
using std::stringstream;

namespace DYN {
typedef SubModelFactory* getSubModelFactory_t();

SubModelFactories SubModelFactory::factories_;

SubModelFactories::SubModelFactories() {
}

SubModelFactories::~SubModelFactories() {
  SubmodelFactoryIterator iter = factoryMap_.begin();
  for (; iter != factoryMap_.end(); ++iter) {
    boost::function<deleteSubModelFactory_t>& deleteFactory = factoryMapDelete_.find(iter->first)->second;

    deleteFactory(iter->second);
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

void SubModelFactories::add(const std::string& lib, const boost::function<deleteSubModelFactory_t>& deleteFactory) {
  factoryMapDelete_.insert(std::make_pair(lib, deleteFactory));
}

boost::shared_ptr<SubModel> SubModelFactory::createSubModelFromLib(const std::string & lib) {
  SubModelFactories::SubmodelFactoryIterator iter = factories_.find(lib);
  SubModel* subModel;
  boost::shared_ptr<SubModel> subModelShared;
  boost::shared_ptr<boost::dll::shared_library> sharedLib;

  if (factories_.end(iter)) {
    std::string func;
    boost::function<getSubModelFactory_t> getFactory;
    boost::function<deleteSubModelFactory_t> deleteFactory;

    boost::optional<boost::filesystem::path> libPath = getLibraryPathFromName(lib);
    if (!libPath.is_initialized()) {
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib);
    }

    try {
      sharedLib = boost::make_shared<boost::dll::shared_library>(libPath->generic_string());
      func = "getFactory";
      getFactory = boost::dll::import<getSubModelFactory_t>(*sharedLib, func.c_str());
      func = "deleteFactory";
      deleteFactory = boost::dll::import<deleteSubModelFactory_t>(*sharedLib, func.c_str());
    } catch (const boost::system::system_error& e) {
      Trace::error() << "Load error :" << e.what() << Trace::endline;
      if (func.empty()) {
        throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib);
      } else {
        throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib + "::" + func);
      }
    }

    SubModelFactory* factory = getFactory();
    factory->lib_ = sharedLib;
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
