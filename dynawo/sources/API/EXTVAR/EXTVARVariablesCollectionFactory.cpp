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
 * @file EXTVARVariablesCollectionFactory.cpp
 * @brief External variables collection factory : implementation file
 *
 */

#include "EXTVARVariablesCollectionFactory.h"
#include "EXTVARVariablesCollectionImpl.h"

using boost::shared_ptr;

namespace externalVariables {

shared_ptr<VariablesCollection>
VariablesCollectionFactory::newCollection() {
  return shared_ptr<VariablesCollection>(new VariablesCollection::Impl());
}

shared_ptr<VariablesCollection>
VariablesCollectionFactory::copyCollection(shared_ptr<VariablesCollection> original) {
  return shared_ptr<VariablesCollection>(new VariablesCollection::Impl(dynamic_cast<VariablesCollection::Impl&> (*original)));
}

}  // namespace externalVariables
