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
 * @file JOBModelerEntry.cpp
 * @brief Modeler entry description : implementation file
 *
 */

#include "JOBModelerEntry.h"

namespace job {

void
ModelerEntry::setPreCompiledModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& preCompiledModelsDirEntry) {
  preCompiledModelsDirEntry_ = preCompiledModelsDirEntry;
}

void
ModelerEntry::setModelicaModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& modelicaModelsDirEntry) {
  modelicaModelsDirEntry_ = modelicaModelsDirEntry;
}

boost::shared_ptr<ModelsDirEntry>
ModelerEntry::getPreCompiledModelsDirEntry() const {
  return preCompiledModelsDirEntry_;
}

boost::shared_ptr<ModelsDirEntry>
ModelerEntry::getModelicaModelsDirEntry() const {
  return modelicaModelsDirEntry_;
}

void
ModelerEntry::setCompileDir(const std::string& compileDir) {
  compileDir_ = compileDir;
}

const std::string&
ModelerEntry::getCompileDir() const {
  return compileDir_;
}

void
ModelerEntry::setNetworkEntry(const boost::shared_ptr<NetworkEntry>& networkEntry) {
  networkEntry_ = networkEntry;
}

boost::shared_ptr<NetworkEntry>
ModelerEntry::getNetworkEntry() const {
  return networkEntry_;
}

void
ModelerEntry::addDynModelsEntry(const boost::shared_ptr<DynModelsEntry>& dynModelsEntry) {
  dynModelsEntries_.push_back(dynModelsEntry);
}

std::vector<boost::shared_ptr<DynModelsEntry> >
ModelerEntry::getDynModelsEntries() const {
  return dynModelsEntries_;
}

void
ModelerEntry::setInitialStateEntry(const boost::shared_ptr<InitialStateEntry>& initialStateEntry) {
  initialStateEntry_ = initialStateEntry;
}

boost::shared_ptr<InitialStateEntry>
ModelerEntry::getInitialStateEntry() const {
  return initialStateEntry_;
}

}  // namespace job
