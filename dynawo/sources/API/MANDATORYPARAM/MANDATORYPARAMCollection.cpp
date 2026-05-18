//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file MANDATORYPARAMCollection.cpp
 * @brief Mandatory parameters collection : implementation file
 */

#include "MANDATORYPARAMCollection.h"

namespace mandatoryParameters {

void
Collection::addParameter(const std::string& name, const std::string& type) {
  parameters_.emplace_back(name, type);
}

const std::vector<Parameter>&
Collection::getParameters() const {
  return parameters_;
}

}  // namespace mandatoryParameters
