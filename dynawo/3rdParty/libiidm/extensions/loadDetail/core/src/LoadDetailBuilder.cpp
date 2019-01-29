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
 * @file LoadDetailBuilder.cpp
 * @brief Provides LoadDetailBuilder
 */

#include <IIDM/extensions/loadDetail/LoadDetailBuilder.h>

namespace IIDM {
namespace extensions {
namespace load_detail {

LoadDetail LoadDetailBuilder::build() const {
  LoadDetail builded;
  builded.m_fixedActivePower = m_fixedActivePower;
  builded.m_fixedReactivePower = m_fixedReactivePower;
  builded.m_variableActivePower = m_variableActivePower;
  builded.m_variableReactivePower = m_variableReactivePower;
  return builded;
}

} // end of namespace IIDM::extensions::load_detail::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
