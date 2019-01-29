//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file GeneratorStartupBuilder.cpp
 * @brief Provides GeneratorStartupBuilder
 */

#include <IIDM/extensions/generatorStartup/GeneratorStartupBuilder.h>

namespace IIDM {
namespace extensions {
namespace generator_startup {

GeneratorStartup GeneratorStartupBuilder::build() const {
  GeneratorStartup builded;
  builded.m_predefinedActivePowerSetpoint = m_predefinedActivePowerSetpoint;
  builded.m_marginalCost = m_marginalCost;
  builded.m_plannedOutageRate = m_plannedOutageRate;
  builded.m_forcedOutageRate = m_forcedOutageRate;
  return builded;
}

} // end of namespace IIDM::extensions::generator_startup::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
