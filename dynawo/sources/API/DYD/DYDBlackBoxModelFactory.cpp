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
 * @file DYDBlackBoxModelFactory.cpp
 * @brief Blackbox model factory : implementation file
 *
 */

#include "DYDBlackBoxModelFactory.h"

#include "DYDBlackBoxModel.h"


namespace dynamicdata {

std::unique_ptr<BlackBoxModel>
BlackBoxModelFactory::newModel(const std::string& modelId) {
  return std::unique_ptr<BlackBoxModel>(new BlackBoxModel(modelId));
}

}  // namespace dynamicdata
