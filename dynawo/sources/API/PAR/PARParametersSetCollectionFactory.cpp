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
 * @file PARParametersSetCollectionFactory.cpp
 * @brief Dynawo parameters set collection factory : implementation file
 *
 */

#include "PARParametersSetCollectionFactory.h"
#include "PARParametersSetCollection.h"

using boost::shared_ptr;

namespace parameters {

shared_ptr<ParametersSetCollection>
ParametersSetCollectionFactory::newCollection() {
  return shared_ptr<ParametersSetCollection>(new ParametersSetCollection());
}

shared_ptr<ParametersSetCollection>
ParametersSetCollectionFactory::copyCollection(shared_ptr<ParametersSetCollection> original) {
  return shared_ptr<ParametersSetCollection>(new ParametersSetCollection(*original));
}

}  // namespace parameters
