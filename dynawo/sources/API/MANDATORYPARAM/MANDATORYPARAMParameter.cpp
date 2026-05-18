//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file MANDATORYPARAMParameter.cpp
 * @brief Mandatory parameter description : implementation file
 */

#include "MANDATORYPARAMParameter.h"

namespace mandatoryParameters {

Parameter::Parameter(const std::string& name, const std::string& type) :
name_(name),
type_(type) {}

const std::string&
Parameter::getName() const {
  return name_;
}

const std::string&
Parameter::getType() const {
  return type_;
}

}  // namespace mandatoryParameters
