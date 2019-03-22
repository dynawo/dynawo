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

//=============================================================================
/**
 * @file builders/DanglingLineBuilder.cpp
 * @brief DanglingLine builder implementation file
 */
//=============================================================================

#include <IIDM/builders/DanglingLineBuilder.h>

#include <IIDM/components/DanglingLine.h>

namespace IIDM {

namespace builders {

DanglingLineBuilder::builded_type
DanglingLineBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_p0 = m_p0;
  builded.m_q0 = m_q0;
  builded.m_r = m_r;
  builded.m_x = m_x;
  builded.m_g = m_g;
  builded.m_b = m_b;
  builded.m_ucte_xNodeCode = m_ucte_xNodeCode;
  builded.m_currentLimits = m_currentLimits;

  return configure_injection(builded);
}

} // end of namespace IIDM::builders::
} // end of namespace IIDM::
