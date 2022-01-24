//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include <limits>
#include <iostream>
#include "CRTCriteriaParamsImpl.h"


namespace criteria {

CriteriaParams::Impl::Impl() :
scope_(UNDEFINED_SCOPE),
type_(UNDEFINED_TYPE),
pMin_(-std::numeric_limits<double>::max()),
pMax_(std::numeric_limits<double>::max()) {}

void
CriteriaParams::Impl::setScope(CriteriaScope_t scope) {
  scope_ = scope;
}

CriteriaParams::CriteriaScope_t
CriteriaParams::Impl::getScope() const {
  return scope_;
}

void
CriteriaParams::Impl::setType(CriteriaType_t type) {
  type_ = type;
}

CriteriaParams::CriteriaType_t
CriteriaParams::Impl::getType() const {
  return type_;
}

void
CriteriaParams::Impl::setId(const std::string& id) {
  id_ = id;
}

const std::string&
CriteriaParams::Impl::getId() const {
  return id_;
}

void
CriteriaParams::Impl::addVoltageLevel(const CriteriaParamsVoltageLevel& vl) {
  voltageLevels_.push_back(vl);
}

const std::vector<CriteriaParamsVoltageLevel>&
CriteriaParams::Impl::getVoltageLevels() const {
  return voltageLevels_;
}

bool CriteriaParams::Impl::hasVoltageLevels() const {
  return !voltageLevels_.empty();
}

void
CriteriaParams::Impl::setPMax(double pMax) {
  pMax_ = pMax;
}

double
CriteriaParams::Impl::getPMax() const {
  return pMax_;
}

bool
CriteriaParams::Impl::hasPMax() const {
  return pMax_ < std::numeric_limits<double>::max();
}

void
CriteriaParams::Impl::setPMin(double pMin) {
  pMin_ = pMin;
}

double
CriteriaParams::Impl::getPMin() const {
  return pMin_;
}

bool
CriteriaParams::Impl::hasPMin() const {
  return pMin_ > -std::numeric_limits<double>::max();
}

}  // namespace criteria
