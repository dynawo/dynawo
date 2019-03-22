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
 * @file builders/TieLineBuilder.cpp
 * @brief TieLine builder implementation file
 */

#include <IIDM/builders/TieLineBuilder.h>

#include <IIDM/components/TieLine.h>

namespace IIDM {

namespace builders {

TieLineBuilder::builded_type
TieLineBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_id_1 = m_id_1;
  builded.m_name_1 = m_name_1;
  builded.m_r_1 = m_r_1;
  builded.m_x_1 = m_x_1;
  builded.m_g1_1 = m_g1_1;
  builded.m_g2_1 = m_g2_1;
  builded.m_b1_1 = m_b1_1;
  builded.m_b2_1 = m_b2_1;
  builded.m_xnodeP_1 = m_xnodeP_1;
  builded.m_xnodeQ_1 = m_xnodeQ_1;

  builded.m_id_2 = m_id_2;
  builded.m_name_2 = m_name_2;
  builded.m_r_2 = m_r_2;
  builded.m_x_2 = m_x_2;
  builded.m_g1_2 = m_g1_2;
  builded.m_g2_2 = m_g2_2;
  builded.m_b1_2 = m_b1_2;
  builded.m_b2_2 = m_b2_2;
  builded.m_xnodeP_2 = m_xnodeP_2;
  builded.m_xnodeQ_2 = m_xnodeQ_2;

  builded.m_ucteXnodeCode = m_ucteXnodeCode;

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
