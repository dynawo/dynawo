//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file JOBModelsDirEntry.cpp
 * @brief ModelsDir entry description : implementation file
 *
 */

#include "JOBModelsDirEntry.h"

namespace job {

ModelsDirEntry::ModelsDirEntry() : modelExtension_(""), useStandardModels_(false) {}

void
ModelsDirEntry::setModelExtension(const std::string& modelExtension) {
  modelExtension_ = modelExtension;
}

void
ModelsDirEntry::setUseStandardModels(const bool useStandardModels) {
  useStandardModels_ = useStandardModels;
}

const std::string&
ModelsDirEntry::getModelExtension() const {
  return modelExtension_;
}

bool
ModelsDirEntry::getUseStandardModels() const {
  return useStandardModels_;
}

void
ModelsDirEntry::clearDirectories() {
  dirs_.clear();
}

std::vector<UserDefinedDirectory>
ModelsDirEntry::getDirectories() const {
  return dirs_;
}

void
ModelsDirEntry::addDirectory(const UserDefinedDirectory& directory) {
  dirs_.push_back(directory);
}

}  // namespace job
