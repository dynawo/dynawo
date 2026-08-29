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
 * @file  DYNVariableNativeFactory.cpp
 *
 * @brief Dynawo native variable : factory file
 */
#include <boost/make_shared.hpp>
#include "DYNVariableNativeFactory.h"
#include "DYNVariableNative.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

shared_ptr<VariableNative>
VariableNativeFactory::create(const string& name, const typeVar_t type, const bool isState, const bool negated) {
  return boost::make_shared<VariableNative>(name, type, isState, negated);
}

}  // namespace DYN
