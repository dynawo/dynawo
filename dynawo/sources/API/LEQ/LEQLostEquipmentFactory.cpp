//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQLostEquipmentFactory.cpp
 *
 * @brief Dynawo lost equipment factory : implementation file
 *
 */

#include "LEQLostEquipmentFactory.h"
#include "LEQLostEquipment.h"

using boost::shared_ptr;

namespace lostEquipments {

shared_ptr<LostEquipment>
LostEquipmentFactory::newLostEquipment() {
  return shared_ptr<LostEquipment>(new LostEquipment());
}

shared_ptr<LostEquipment>
LostEquipmentFactory::newLostEquipment(const std::string& id, const std::string& type) {
  return shared_ptr<LostEquipment>(new LostEquipment(id, type));
}

}  // namespace lostEquipments
