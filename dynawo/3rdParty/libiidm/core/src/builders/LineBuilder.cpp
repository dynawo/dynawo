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
 * @file builders/LineBuilder.cpp
 * @brief Line builder implementation file
 */
//=============================================================================
#include <IIDM/builders/LineBuilder.h>

#include <IIDM/components/Line.h>

namespace IIDM {

namespace builders {

LineBuilder::builded_type
LineBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_r = m_r;
  builded.m_x = m_x;
  builded.m_g1 = m_g1;
  builded.m_b1 = m_b1;
  builded.m_g2 = m_g2;
  builded.m_b2 = m_b2;

  builded.m_p1 = m_p1;
  builded.m_q1 = m_q1;
  builded.m_p2 = m_p2;
  builded.m_q2 = m_q2;

  builded.m_currentLimits1 = m_currentLimits1;
  builded.m_currentLimits2 = m_currentLimits2;

  return builded;
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
