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
 * @file VoltageRegulationBuilder.cpp
 * @brief Provides VoltageRegulationBuilder
 */

#include <IIDM/extensions/voltageRegulation/VoltageRegulationBuilder.h>

namespace IIDM {
namespace extensions {
namespace voltageregulation {

VoltageRegulation VoltageRegulationBuilder::build() const {
  VoltageRegulation builded;
  builded.m_voltageRegulatorOn = m_voltageRegulatorOn;
  builded.m_targetV = m_targetV;
  builded.m_regulatingTerminal = m_regulatingTerminal;
  return builded;
}

} // end of namespace IIDM::extensions::voltageregulation::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
