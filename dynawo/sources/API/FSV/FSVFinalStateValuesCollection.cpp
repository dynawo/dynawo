//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVFinalStateValuesCollection.cpp
 *
 * @brief Final state values collection : implementation file
 *
 */
#include "FSVFinalStateValuesCollection.h"

#include "FSVFinalStateValue.h"

using std::string;
using std::vector;

namespace finalStateValues {

FinalStateValuesCollection::FinalStateValuesCollection(const string& id) : id_(id) {}

void
FinalStateValuesCollection::add(const std::shared_ptr<FinalStateValue>& finalStateValue) {
  finalStateValues_.push_back(finalStateValue);
}

}  // namespace finalStateValues
