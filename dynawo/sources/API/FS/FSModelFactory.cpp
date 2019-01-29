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
 * @file  FSModelFactory.cpp
 *
 * @brief Dynawo final state model factory : implementation file
 *
 */

#include "FSModelFactory.h"
#include "FSModelImpl.h"

using std::string;

namespace finalState {

boost::shared_ptr<Model>
ModelFactory::newModel(const string& id) {
  return boost::shared_ptr<Model>(new Model::Impl(id));
}

}  // namespace finalState
