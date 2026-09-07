//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQLostEquipmentsCollectionFactory.cpp
 *
 * @brief Dynawo lost equipments collection factory : implementation file
 *
 */

#include "LEQLostEquipmentsCollectionFactory.h"
#include "LEQLostEquipmentsCollection.h"

#include "make_unique.hpp"


namespace lostEquipments {

std::unique_ptr<LostEquipmentsCollection>
LostEquipmentsCollectionFactory::newInstance() {
  return DYN::make_unique<LostEquipmentsCollection>();
}

}  // namespace lostEquipments
