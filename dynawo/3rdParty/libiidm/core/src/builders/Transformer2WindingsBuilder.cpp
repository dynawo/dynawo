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
 * @file builders/Transformer2WindingsBuilder.cpp
 * @brief Transformer2 builder implementation file
 */
//=============================================================================
#include <IIDM/builders/Transformer2WindingsBuilder.h>

#include <IIDM/components/Transformer2Windings.h>

namespace IIDM {

namespace builders {

Transformer2WindingsBuilder::builded_type
Transformer2WindingsBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_r = m_r;
  builded.m_x = m_x;
  builded.m_g = m_g;
  builded.m_b = m_b;

  builded.m_ratedU1 = m_ratedU1;
  builded.m_ratedU2 = m_ratedU2;

  builded.m_p1 = m_p1;
  builded.m_q1 = m_q1;
  builded.m_p2 = m_p2;
  builded.m_q2 = m_q2;

  builded.m_phaseTapChanger = m_phaseTapChanger;
  builded.m_ratioTapChanger = m_ratioTapChanger;
  builded.m_currentLimits1 = m_currentLimits1;
  builded.m_currentLimits2 = m_currentLimits2;

  return builded;
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
