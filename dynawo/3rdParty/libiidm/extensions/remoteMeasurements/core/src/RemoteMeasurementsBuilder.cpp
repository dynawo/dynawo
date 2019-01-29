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
 * @file RemoteMeasurementsBuilder.cpp
 * @brief Provides RemoteMeasurementsBuilder
 */

#include <IIDM/extensions/remoteMeasurements/RemoteMeasurementsBuilder.h>

namespace IIDM {
namespace extensions {
namespace remotemeasurements {

RemoteMeasurements RemoteMeasurementsBuilder::build() const {
  RemoteMeasurements builded;
  builded.m_p = m_p;
  builded.m_q = m_q;
  builded.m_p1 = m_p1;
  builded.m_q1 = m_q1;
  builded.m_p2 = m_p2;
  builded.m_q2 = m_q2;
  builded.m_v = m_v;
  builded.m_tapPosition = m_tapPosition;
  return builded;
}

} // end of namespace IIDM::extensions::remotemeasurements::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
