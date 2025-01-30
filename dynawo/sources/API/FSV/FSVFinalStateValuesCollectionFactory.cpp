//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVFinalStateValuesCollectionFactory.cpp
 *
 * @brief Dynawo final state values collections factory : implementation file
 *
 */

#include "FSVFinalStateValuesCollectionFactory.h"

#include "FSVFinalStateValuesCollection.h"

using std::string;

namespace finalStateValues {

std::unique_ptr<FinalStateValuesCollection>
FinalStateValuesCollectionFactory::newInstance(const string& id) {
  return std::unique_ptr<FinalStateValuesCollection>(new FinalStateValuesCollection(id));
}

std::unique_ptr<FinalStateValuesCollection>
FinalStateValuesCollectionFactory::copyInstance(const std::shared_ptr<FinalStateValuesCollection>& original) {
  return std::unique_ptr<FinalStateValuesCollection>(new FinalStateValuesCollection(*original));
}

std::unique_ptr<FinalStateValuesCollection>
FinalStateValuesCollectionFactory::copyInstance(const FinalStateValuesCollection& original) {
  return std::unique_ptr<FinalStateValuesCollection>(new FinalStateValuesCollection(original));
}

}  // namespace finalStateValues
