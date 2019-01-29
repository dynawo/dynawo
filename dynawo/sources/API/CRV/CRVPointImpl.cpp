//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

/**
 * @file  CRVPointImpl.cpp
 *
 * @brief Dynawo curve point : implementation file
 *
 */
#include "CRVPointImpl.h"

namespace curves {

Point::Impl::Impl(const double& time, const double& value) :
time_(time),
value_(value) {
}

Point::Impl::~Impl() {
}

void
Point::Impl::setTime(const double& time) {
  time_ = time;
}

void
Point::Impl::setValue(const double& value) {
  value_ = value;
}

double
Point::Impl::getTime() const {
  return time_;
}

double
Point::Impl::getValue() const {
  return value_;
}

}  // namespace curves
