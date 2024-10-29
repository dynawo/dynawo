//
// Copyright (c) 2024, RTE (http://www.rte-france.com)
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

#include "PARParametersSetFactory.h"

namespace parameters {

std::shared_ptr<ParametersSet>
ParametersSetFactory::newParametersSet(const std::string& id) {
  return std::make_shared<ParametersSet>(id);
}

std::shared_ptr<ParametersSet>
ParametersSetFactory::copySet(const std::shared_ptr<ParametersSet>& original) {
  return std::make_shared<ParametersSet>(*original);
}

}  // namespace parameters
