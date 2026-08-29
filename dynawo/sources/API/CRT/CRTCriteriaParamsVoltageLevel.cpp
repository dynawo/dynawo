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

#include "CRTCriteriaParamsVoltageLevel.h"

#include <limits>

namespace criteria {

CriteriaParamsVoltageLevel::CriteriaParamsVoltageLevel() :
    uMinPu_(-std::numeric_limits<double>::max()),
    uMaxPu_(std::numeric_limits<double>::max()),
    uNomMin_(-std::numeric_limits<double>::max()),
    uNomMax_(std::numeric_limits<double>::max()) {}

void
CriteriaParamsVoltageLevel::setUMaxPu(double uMaxPu) {
  uMaxPu_ = uMaxPu;
}

double
CriteriaParamsVoltageLevel::getUMaxPu() const {
  return uMaxPu_;
}

bool
CriteriaParamsVoltageLevel::hasUMaxPu() const {
  return uMaxPu_ < std::numeric_limits<double>::max();
}

void
CriteriaParamsVoltageLevel::setUNomMax(double uMaxNom) {
  uNomMax_ = uMaxNom;
}

double
CriteriaParamsVoltageLevel::getUNomMax() const {
  return uNomMax_;
}

bool
CriteriaParamsVoltageLevel::hasUNomMax() const {
  return uNomMax_ < std::numeric_limits<double>::max();
}

void
CriteriaParamsVoltageLevel::setUMinPu(double uMinPu) {
  uMinPu_ = uMinPu;
}

double
CriteriaParamsVoltageLevel::getUMinPu() const {
  return uMinPu_;
}

bool
CriteriaParamsVoltageLevel::hasUMinPu() const {
  return uMinPu_ > -std::numeric_limits<double>::max();
}

void
CriteriaParamsVoltageLevel::setUNomMin(double uNomMin) {
  uNomMin_ = uNomMin;
}

double
CriteriaParamsVoltageLevel::getUNomMin() const {
  return uNomMin_;
}

bool
CriteriaParamsVoltageLevel::hasUNomMin() const {
  return uNomMin_ > -std::numeric_limits<double>::max();
}

bool
CriteriaParamsVoltageLevel::empty() const {
  return !hasUMaxPu() && !hasUMinPu() && !hasUNomMax() && !hasUNomMin();
}

void
CriteriaParamsVoltageLevel::reset() {
  uMinPu_ = -std::numeric_limits<double>::max();
  uMaxPu_ = std::numeric_limits<double>::max();
  uNomMin_ = -std::numeric_limits<double>::max();
  uNomMax_ = std::numeric_limits<double>::max();
}

}  // namespace criteria
