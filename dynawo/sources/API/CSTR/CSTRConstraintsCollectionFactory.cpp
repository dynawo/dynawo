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
 * @file  CSTRConstraintsCollectionFactory.cpp
 *
 * @brief Dynawo constraints factory : implementation file
 *
 */

#include "CSTRConstraintsCollectionFactory.h"

#include "CSTRConstraintsCollection.h"

using boost::shared_ptr;
using std::string;

namespace constraints {

shared_ptr<ConstraintsCollection>
ConstraintsCollectionFactory::newInstance(const string& id) {
  return shared_ptr<ConstraintsCollection>(new ConstraintsCollection(id));
}

shared_ptr<ConstraintsCollection>
ConstraintsCollectionFactory::copyInstance(boost::shared_ptr<ConstraintsCollection> original) {
  return shared_ptr<ConstraintsCollection>(new ConstraintsCollection(*original));
}

shared_ptr<ConstraintsCollection>
ConstraintsCollectionFactory::copyInstance(const ConstraintsCollection& original) {
  return shared_ptr<ConstraintsCollection>(new ConstraintsCollection(original));
}

}  // namespace constraints
