//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file  CRVPoint.cpp
 *
 * @brief Dynawo curve point : implementation file
 *
 */
#include "CRVPoint.h"

namespace curves {

Point::Point(const double& time, const double& value) :
time_(time),
value_(value) {
}

void
Point::setTime(const double& time) {
  time_ = time;
}

void
Point::setValue(const double& value) {
  value_ = value;
}

double
Point::getTime() const {
  return time_;
}

double
Point::getValue() const {
  return value_;
}

}  // namespace curves
