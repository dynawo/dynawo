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
uMinPu_(-std::numeric_limits<double>::max()),
uMaxPu_(std::numeric_limits<double>::max()),
uNomMin_(-std::numeric_limits<double>::max()),
uNomMax_(std::numeric_limits<double>::max()),
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
CriteriaParams::Impl::setUMaxPu(double uMaxPu) {
  uMaxPu_ = uMaxPu;
}

double
CriteriaParams::Impl::getUMaxPu() const {
  return uMaxPu_;
}

bool
CriteriaParams::Impl::hasUMaxPu() const {
  return uMaxPu_ < std::numeric_limits<double>::max();
}

void
CriteriaParams::Impl::setUNomMax(double uMaxNom) {
  uNomMax_ = uMaxNom;
}

double
CriteriaParams::Impl::getUNomMax() const {
  return uNomMax_;
}

bool
CriteriaParams::Impl::hasUNomMax() const {
  return uNomMax_ < std::numeric_limits<double>::max();
}

void
CriteriaParams::Impl::setUMinPu(double uMinPu) {
  uMinPu_ = uMinPu;
}

double
CriteriaParams::Impl::getUMinPu() const {
  return uMinPu_;
}

bool
CriteriaParams::Impl::hasUMinPu() const {
  return uMinPu_ > -std::numeric_limits<double>::max();
}

void
CriteriaParams::Impl::setUNomMin(double uNomMin) {
  uNomMin_ = uNomMin;
}

double
CriteriaParams::Impl::getUNomMin() const {
  return uNomMin_;
}

bool
CriteriaParams::Impl::hasUNomMin() const {
  return uNomMin_ > -std::numeric_limits<double>::max();
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
