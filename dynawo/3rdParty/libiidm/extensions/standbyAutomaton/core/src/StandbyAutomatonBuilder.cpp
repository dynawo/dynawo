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

#include <IIDM/extensions/standbyAutomaton/StandbyAutomatonBuilder.h>

namespace IIDM {
namespace extensions {
namespace standbyautomaton {

StandbyAutomaton StandbyAutomatonBuilder::build() const {
  StandbyAutomaton builded;
  builded.m_b0 = m_b0;
  builded.m_standBy = m_standBy;
  builded.m_lowVoltageSetPoint = m_lowVoltageSetPoint;
  builded.m_highVoltageSetPoint = m_highVoltageSetPoint;
  builded.m_lowVoltageThreshold = m_lowVoltageThreshold;
  builded.m_highVoltageThreshold = m_highVoltageThreshold;
  return builded;
}

} // end of namespace IIDM::extensions::standbyautomaton::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
