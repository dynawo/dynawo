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

#include "CRTCriteriaParams.h"

#include <iostream>
#include <limits>

namespace criteria {

CriteriaParams::CriteriaParams() :
    scope_(UNDEFINED_SCOPE),
    type_(UNDEFINED_TYPE),
    uMinPu_(-std::numeric_limits<double>::max()),
    uMaxPu_(std::numeric_limits<double>::max()),
    uNomMin_(-std::numeric_limits<double>::max()),
    uNomMax_(std::numeric_limits<double>::max()),
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
CriteriaParams::setUMaxPu(double uMaxPu) {
  uMaxPu_ = uMaxPu;
}

double
CriteriaParams::getUMaxPu() const {
  return uMaxPu_;
}

bool
CriteriaParams::hasUMaxPu() const {
  return uMaxPu_ < std::numeric_limits<double>::max();
}

void
CriteriaParams::setUNomMax(double uMaxNom) {
  uNomMax_ = uMaxNom;
}

double
CriteriaParams::getUNomMax() const {
  return uNomMax_;
}

bool
CriteriaParams::hasUNomMax() const {
  return uNomMax_ < std::numeric_limits<double>::max();
}

void
CriteriaParams::setUMinPu(double uMinPu) {
  uMinPu_ = uMinPu;
}

double
CriteriaParams::getUMinPu() const {
  return uMinPu_;
}

bool
CriteriaParams::hasUMinPu() const {
  return uMinPu_ > -std::numeric_limits<double>::max();
}

void
CriteriaParams::setUNomMin(double uNomMin) {
  uNomMin_ = uNomMin;
}

double
CriteriaParams::getUNomMin() const {
  return uNomMin_;
}

bool
CriteriaParams::hasUNomMin() const {
  return uNomMin_ > -std::numeric_limits<double>::max();
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
