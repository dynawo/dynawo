//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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

#include "DYNIIDMExtensionsTraits.hpp"

namespace DYN {
const char IIDMExtensionTrait<StaticVarCompensatorInterfaceIIDMExtension>::name[] = "StaticVarCompensatorInterfaceIIDMExtension";
const char IIDMExtensionTrait<ActiveSeasonIIDMExtension>::name[] = "ActiveSeasonIIDMExtension";
const char IIDMExtensionTrait<CurrentLimitsPerSeasonIIDMExtension>::name[] = "CurrentLimitsPerSeasonIIDMExtension";
const char IIDMExtensionTrait<GeneratorActivePowerControlIIDMExtension>::name[] = "GeneratorActivePowerControlIIDMExtension";
}  // namespace DYN
