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
 * @file  DYNModelTapChanger.cpp
 *
 * @brief Model of tap changer : implementation
 *
 */
#include "DYNModelTapChanger.h"
#include "DYNMacrosMessage.h"

namespace DYN {

ModelTapChanger::~ModelTapChanger() {}

void ModelTapChanger::evalG(double /*t*/, double /*valueMonitored*/,
                            bool /*nnodeOff*/, state_g* /*g*/,
                            double /*disable*/, double /*locked*/,
                            bool /*tfoClosed*/) {
  // not needed
}

void ModelTapChanger::evalZ(double /*t*/, state_g* /*g*/,
                            ModelNetwork* /*network*/, double /*disable*/,
                            bool /*nodeOff*/, double /*locked*/,
                            bool /*tfoClosed*/) {
  // not needed
}

}  // namespace DYN
