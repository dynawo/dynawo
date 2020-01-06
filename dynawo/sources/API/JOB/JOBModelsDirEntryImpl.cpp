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
 * @file JOBModelsDirEntryImpl.cpp
 * @brief ModelsDir entry description : implementation file
 *
 */

#include "JOBModelsDirEntryImpl.h"

namespace job {

ModelsDirEntry::Impl::Impl() :
modelExtension_(""),
useStandardModels_(false) {
}

ModelsDirEntry::Impl::~Impl() {
}

void
ModelsDirEntry::Impl::setModelExtension(const std::string& modelExtension) {
  modelExtension_ = modelExtension;
}

void
ModelsDirEntry::Impl::setUseStandardModels(const bool useStandardModels) {
  useStandardModels_ = useStandardModels;
}

std::string
ModelsDirEntry::Impl::getModelExtension() const {
  return modelExtension_;
}

bool
ModelsDirEntry::Impl::getUseStandardModels() const {
  return useStandardModels_;
}

void
ModelsDirEntry::Impl::clearDirectories() {
  dirs_.clear();
}

std::vector<UserDefinedDirectory>
ModelsDirEntry::Impl::getDirectories() const {
  return dirs_;
}

void
ModelsDirEntry::Impl::addDirectory(const UserDefinedDirectory& directory) {
  dirs_.push_back(directory);
}

}  // namespace job
