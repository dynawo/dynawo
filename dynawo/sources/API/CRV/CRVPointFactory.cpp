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
 * @file CRVPointFactory.cpp
 *
 * @brief Dynawo curves point factory : implementation file
 *
 */

#include "CRVPointFactory.h"
#include "CRVPoint.h"

#include "make_unique.hpp"


namespace curves {

std::unique_ptr<Point>
PointFactory::newPoint(const double& time, const double& value) {
  return DYN::make_unique<Point>(time, value);
}

}  // namespace curves
