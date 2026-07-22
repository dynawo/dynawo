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
 * @file JOBLostEquipmentsEntry.cpp
 * @brief lostEquipments entry description : implementation file
 *
 */

#include "JOBLostEquipmentsEntry.h"

namespace job {

LostEquipmentsEntry::LostEquipmentsEntry() : dumpLostEquipments_(false) {}

void
LostEquipmentsEntry::setDumpLostEquipments(const bool dumpLostEquipments) {
  dumpLostEquipments_ = dumpLostEquipments;
}

bool
LostEquipmentsEntry::getDumpLostEquipments() const {
  return dumpLostEquipments_;
}

}  // namespace job
