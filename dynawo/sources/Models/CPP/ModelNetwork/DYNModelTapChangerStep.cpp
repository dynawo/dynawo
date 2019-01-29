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
 * @file  DYNModelTapChangerStep.cpp
 *
 * @brief Implementation file of tap changer step model
 *
 */

#include "DYNModelTapChangerStep.h"

namespace DYN {

TapChangerStep::TapChangerStep(const double& rho, const double& alpha,
        const double& r, const double& x,
        const double& g, const double& b) :
rho_(rho),
alpha_(alpha),
r_(r),
x_(x),
g_(g),
b_(b) {
}

TapChangerStep::~TapChangerStep() {
}

TapChangerStep::TapChangerStep() :
rho_(1),
alpha_(0),
r_(0),
x_(0),
g_(0),
b_(0) {
}

TapChangerStep::TapChangerStep(const TapChangerStep& source) :
rho_(source.rho_),
alpha_(source.alpha_),
r_(source.r_),
x_(source.x_),
g_(source.g_),
b_(source.b_) {
}

double
TapChangerStep::getRho() const {
  return rho_;
}

double
TapChangerStep::getAlpha() const {
  return alpha_;
}

double
TapChangerStep::getR() const {
  return r_;
}

double
TapChangerStep::getX() const {
  return x_;
}

double
TapChangerStep::getG() const {
  return g_;
}

double
TapChangerStep::getB() const {
  return b_;
}

}  // namespace DYN
