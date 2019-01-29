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
 * @file  FSFinalStateCollectionFactory.cpp
 *
 * @brief Dynawo final state collection factory : implementation file
 *
 */

#include "FSFinalStateCollectionFactory.h"
#include "FSFinalStateCollectionImpl.h"

using std::string;

namespace finalState {

boost::shared_ptr<FinalStateCollection>
FinalStateCollectionFactory::newInstance(const string& id) {
  return boost::shared_ptr<FinalStateCollection>(new FinalStateCollection::Impl(id));
}

boost::shared_ptr<FinalStateCollection>
FinalStateCollectionFactory::copyInstance(boost::shared_ptr<FinalStateCollection> original) {
  return boost::shared_ptr<FinalStateCollection>(new FinalStateCollection::Impl(dynamic_cast<FinalStateCollection::Impl&> (*original)));
}

boost::shared_ptr<FinalStateCollection>
FinalStateCollectionFactory::copyInstance(const FinalStateCollection& original) {
  return boost::shared_ptr<FinalStateCollection>(new FinalStateCollection::Impl(dynamic_cast<const FinalStateCollection::Impl&> (original)));
}

}  // namespace finalState
