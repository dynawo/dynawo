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
 * @file builders/Transformer3WindingsBuilder.cpp
 * @brief Transformer3 builder implementation file
 */
//=============================================================================
#include <IIDM/builders/Transformer3WindingsBuilder.h>

#include <IIDM/components/Transformer3Windings.h>

namespace IIDM {

namespace builders {

Transformer3WindingsBuilder::builded_type
Transformer3WindingsBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_r1 = m_r1;
  builded.m_x1 = m_x1;
  builded.m_r2 = m_r2;
  builded.m_x2 = m_x2;
  builded.m_r3 = m_r3;
  builded.m_x3 = m_x3;
  builded.m_g1 = m_g1;
  builded.m_b1 = m_b1;

  builded.m_ratedU1 = m_ratedU1;
  builded.m_ratedU2 = m_ratedU2;
  builded.m_ratedU3 = m_ratedU3;

  builded.m_p1 = m_p1;
  builded.m_q1 = m_q1;
  builded.m_p2 = m_p2;
  builded.m_q2 = m_q2;
  builded.m_p3 = m_p3;
  builded.m_q3 = m_q3;

  builded.m_ratioTapChanger2 = m_ratioTapChanger2;
  builded.m_ratioTapChanger3 = m_ratioTapChanger3;
  builded.m_currentLimits1 = m_currentLimits1;
  builded.m_currentLimits2 = m_currentLimits2;
  builded.m_currentLimits3 = m_currentLimits3;

  return builded;
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
