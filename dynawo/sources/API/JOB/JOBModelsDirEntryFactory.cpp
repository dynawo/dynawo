//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "JOBModelsDirEntryFactory.h"
#include "JOBModelsDirEntry.h"

namespace job {

std::unique_ptr<ModelsDirEntry>
ModelsDirEntryFactory::newInstance() {
  return std::unique_ptr<ModelsDirEntry>(new ModelsDirEntry());
}

}  // namespace job
