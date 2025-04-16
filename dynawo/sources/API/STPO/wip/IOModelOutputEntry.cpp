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
 * @file  IOModelOutputEntry.cpp
 *
 * @brief Dynawo ModelOutputEntry : implementation file
 *
 */
#include "IOModelOutputEntry.h"

#include <iostream>
#include <limits>

#include "make_unique.hpp"

using std::string;

namespace dynio {

std::unique_ptr<ModelOutputEntry>
ModelOutputEntryFactory::newModelOutputEntry() {
  return DYN::make_unique<ModelOutputEntry>();
}

ModelOutputEntry::ModelOutputEntry::ModelOutputEntry() :
      modelName_("") {}


void
ModelOutputEntry::setModelName(const string& modelName) {
  modelName_ = modelName;
}

const string&
ModelOutputEntry::getModelName() const {
  return modelName_;
}

void
ModelOutputEntry::addOutputEntry() {}

}  // namespace dynio
