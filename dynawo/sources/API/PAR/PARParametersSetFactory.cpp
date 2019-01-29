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
 * @file PARParametersSetFactory.cpp
 * @brief Dynawo parameters set factory : implementation file
 *
 */

#include "PARParametersSetFactory.h"
#include "PARParametersSetImpl.h"

using std::map;
using std::string;


namespace parameters {

boost::shared_ptr<ParametersSet>
ParametersSetFactory::newInstance(string id) {
  return boost::shared_ptr<ParametersSet>(new ParametersSet::Impl(id));
}

boost::shared_ptr<ParametersSet>
ParametersSetFactory::copyInstance(boost::shared_ptr<ParametersSet> original) {
  return boost::shared_ptr<ParametersSet>(new ParametersSet::Impl(dynamic_cast<ParametersSet::Impl&> (*original)));
}

boost::shared_ptr<ParametersSet>
ParametersSetFactory::copyInstance(const ParametersSet& original) {
  return boost::shared_ptr<ParametersSet>(new ParametersSet::Impl(dynamic_cast<const ParametersSet::Impl&> (original)));
}

}  // namespace parameters
