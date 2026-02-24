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
 * @file  LEQLostEquipment.cpp
 *
 * @brief Dynawo lost equipment : implementation file
 *
 */
#include "LEQLostEquipment.h"

using std::string;

namespace lostEquipments {

LostEquipment::LostEquipment(const std::string& id, const std::string& type) : id_(id), type_(type) {}

void
LostEquipment::setId(const string& id) {
  id_ = id;
}

void
LostEquipment::setType(const string& type) {
  type_ = type;
}

const string&
LostEquipment::getId() const {
  return id_;
}

const string&
LostEquipment::getType() const {
  return type_;
}

}  // namespace lostEquipments
