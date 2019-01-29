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

#include <IIDM/extensions/voltageLevelShortCircuits/VoltageLevelShortCircuitsBuilder.h>

namespace IIDM {
namespace extensions {
namespace voltagelevelshortcircuits {

VoltageLevelShortCircuits VoltageLevelShortCircuitsBuilder::build() const {
  VoltageLevelShortCircuits builded;
  builded.m_minShortCircuitsCurrent = m_minShortCircuitsCurrent;
  builded.m_maxShortCircuitsCurrent = m_maxShortCircuitsCurrent;
  return builded;
}

} // end of namespace IIDM::extensions::voltagelevelshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
