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
 * @file CongestionManagementBuilder.cpp
 * @brief Provides CongestionManagementBuilder
 */

#include <IIDM/extensions/congestionManagement/CongestionManagementBuilder.h>

namespace IIDM {
namespace extensions {
namespace congestion_management {

CongestionManagement CongestionManagementBuilder::build() const {
  CongestionManagement builded;
  builded.m_enabled = m_enabled;
  return builded;
}

} // end of namespace IIDM::extensions::congestion_management::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
