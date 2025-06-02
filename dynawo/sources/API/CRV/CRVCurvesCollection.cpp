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
 * @file  CRVCurvesCollection.cpp
 *
 * @brief Curves collection : implementation file
 *
 */
#include "CRVCurvesCollection.h"
#include "CRVCurve.h"

using std::string;

namespace curves {

CurvesCollection::CurvesCollection(const string& id) :
id_(id) {
}

void
CurvesCollection::add(const std::shared_ptr<Curve>& curve) {
  curves_.push_back(curve);
}

void
CurvesCollection::updateCurves(const double time) {
  for (const auto& curve : curves_)
    curve->update(time);
}

}  // namespace curves
