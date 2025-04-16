//
// Copyright (c) 2015-2025, RTE (http://www.rte-france.com)
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
 * @file  STPOOutputsCollectionFactory.cpp
 *
 * @brief Dynawo outputs collections factory : implementation file
 *
 */

#include "STPOOutputsCollectionFactory.h"
#include "STPOOutputsCollection.h"

#include "make_unique.hpp"

using std::string;

namespace stepOutputs {

std::unique_ptr<OutputsCollection>
OutputsCollectionFactory::newInstance(const string& id) {
  return DYN::make_unique<OutputsCollection>(id);
}

std::unique_ptr<OutputsCollection>
OutputsCollectionFactory::copyInstance(const std::shared_ptr<OutputsCollection>& original) {
  return DYN::make_unique<OutputsCollection>(*original);
}

std::unique_ptr<OutputsCollection>
OutputsCollectionFactory::copyInstance(const OutputsCollection& original) {
  return DYN::make_unique<OutputsCollection>(original);
}

}  // namespace stepOutputs
