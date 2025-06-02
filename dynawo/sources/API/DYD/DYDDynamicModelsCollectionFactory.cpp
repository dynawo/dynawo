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
 * @file DYDDynamicModelsCollectionFactory.cpp
 * @brief Dynamic models collection factory : implementation file
 *
 */

#include "DYDDynamicModelsCollectionFactory.h"
#include "DYDDynamicModelsCollection.h"

using boost::shared_ptr;

namespace dynamicdata {

shared_ptr<DynamicModelsCollection>
DynamicModelsCollectionFactory::newCollection() {
  return shared_ptr<DynamicModelsCollection>(new DynamicModelsCollection());
}

shared_ptr<DynamicModelsCollection>
DynamicModelsCollectionFactory::copyCollection(const shared_ptr<DynamicModelsCollection>& original) {
  return shared_ptr<DynamicModelsCollection>(new DynamicModelsCollection(*original));
}

}  // namespace dynamicdata
