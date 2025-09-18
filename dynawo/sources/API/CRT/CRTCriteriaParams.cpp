//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "CRTCriteriaParams.h"

#include <iostream>
#include <limits>

namespace criteria {

CriteriaParams::CriteriaParams() :
    scope_(UNDEFINED_SCOPE),
    type_(UNDEFINED_TYPE),
    pMin_(-std::numeric_limits<double>::max()),
    pMax_(std::numeric_limits<double>::max()) {}

void
CriteriaParams::setScope(CriteriaScope_t scope) {
  scope_ = scope;
}

CriteriaParams::CriteriaScope_t
CriteriaParams::getScope() const {
  return scope_;
}

void
CriteriaParams::setType(CriteriaType_t type) {
  type_ = type;
}

CriteriaParams::CriteriaType_t
CriteriaParams::getType() const {
  return type_;
}

void
CriteriaParams::setId(const std::string& id) {
  id_ = id;
}

const std::string&
CriteriaParams::getId() const {
  return id_;
}

void
CriteriaParams::addVoltageLevel(const CriteriaParamsVoltageLevel& vl) {
  voltageLevels_.push_back(vl);
}

const std::vector<CriteriaParamsVoltageLevel>&
CriteriaParams::getVoltageLevels() const {
  return voltageLevels_;
}

bool CriteriaParams::hasVoltageLevels() const {
  return !voltageLevels_.empty();
}

void
CriteriaParams::setPMax(double pMax) {
  pMax_ = pMax;
}

double
CriteriaParams::getPMax() const {
  return pMax_;
}

bool
CriteriaParams::hasPMax() const {
  return pMax_ < std::numeric_limits<double>::max();
}

void
CriteriaParams::setPMin(double pMin) {
  pMin_ = pMin;
}

double
CriteriaParams::getPMin() const {
  return pMin_;
}

bool
CriteriaParams::hasPMin() const {
  return pMin_ > -std::numeric_limits<double>::max();
}

}  // namespace criteria
