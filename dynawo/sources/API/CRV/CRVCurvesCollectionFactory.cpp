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
 * @file  CRVCurvesCollectionFactory.cpp
 *
 * @brief Dynawo curves collections factory : implementation file
 *
 */

#include "CRVCurvesCollectionFactory.h"
#include "CRVCurvesCollection.h"

#include "make_unique.hpp"

using std::string;

namespace curves {

std::unique_ptr<CurvesCollection>
CurvesCollectionFactory::newInstance(const string& id) {
  return DYN::make_unique<CurvesCollection>(id);
}

std::unique_ptr<CurvesCollection>
CurvesCollectionFactory::copyInstance(const std::shared_ptr<CurvesCollection>& original) {
  return DYN::make_unique<CurvesCollection>(*original);
}

std::unique_ptr<CurvesCollection>
CurvesCollectionFactory::copyInstance(const CurvesCollection& original) {
  return DYN::make_unique<CurvesCollection>(original);
}

}  // namespace curves
