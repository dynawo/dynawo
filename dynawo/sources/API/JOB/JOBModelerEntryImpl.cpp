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
 * @file JOBModelerEntryImpl.cpp
 * @brief Modeler entry description : implementation file
 *
 */

#include "JOBModelerEntryImpl.h"

namespace job {

ModelerEntry::Impl::Impl() :
compileDir_("") {
}

ModelerEntry::Impl::~Impl() {
}

void
ModelerEntry::Impl::setPreCompiledModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& preCompiledModelsDirEntry) {
  preCompiledModelsDirEntry_ = preCompiledModelsDirEntry;
}

void
ModelerEntry::Impl::setModelicaModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& modelicaModelsDirEntry) {
  modelicaModelsDirEntry_ = modelicaModelsDirEntry;
}

boost::shared_ptr<ModelsDirEntry>
ModelerEntry::Impl::getPreCompiledModelsDirEntry() const {
  return preCompiledModelsDirEntry_;
}

boost::shared_ptr<ModelsDirEntry>
ModelerEntry::Impl::getModelicaModelsDirEntry() const {
  return modelicaModelsDirEntry_;
}

void
ModelerEntry::Impl::setCompileDir(const std::string& compileDir) {
  compileDir_ = compileDir;
}

std::string
ModelerEntry::Impl::getCompileDir() const {
  return compileDir_;
}

void
ModelerEntry::Impl::setNetworkEntry(const boost::shared_ptr<NetworkEntry>& networkEntry) {
  networkEntry_ = networkEntry;
}

boost::shared_ptr<NetworkEntry>
ModelerEntry::Impl::getNetworkEntry() const {
  return networkEntry_;
}

void
ModelerEntry::Impl::addDynModelsEntry(const boost::shared_ptr<DynModelsEntry>& dynModelsEntry) {
  dynModelsEntries_.push_back(dynModelsEntry);
}

std::vector<boost::shared_ptr<DynModelsEntry> >
ModelerEntry::Impl::getDynModelsEntries() const {
  return dynModelsEntries_;
}

void
ModelerEntry::Impl::setInitialStateEntry(const boost::shared_ptr<InitialStateEntry>& initialStateEntry) {
  initialStateEntry_ = initialStateEntry;
}

boost::shared_ptr<InitialStateEntry>
ModelerEntry::Impl::getInitialStateEntry() const {
  return initialStateEntry_;
}

}  // namespace job
