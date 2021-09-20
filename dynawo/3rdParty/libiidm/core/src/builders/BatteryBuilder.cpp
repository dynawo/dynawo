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
 * @file builders/BatteryBuilder.cpp
 * @brief Load builder implementation file
 */
//=============================================================================
#include <IIDM/builders/BatteryBuilder.h>

#include <IIDM/components/Battery.h>

namespace IIDM {

namespace builders {

BatteryBuilder::builded_type
BatteryBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  if (!m_minMaxReactiveLimits && !m_reactiveCapabilityCurve) {
    throw builder_exception(id +": battery needs either reactiveCapabilityCurve or minMaxReactiveLimits.");
  }

  builded.m_p0 = m_p0;
  builded.m_q0 = m_q0;

  builded.m_pmin = m_pmin;
  builded.m_pmax = m_pmax;

  builded.m_minMaxReactiveLimits = m_minMaxReactiveLimits;
  builded.m_reactiveCapabilityCurve = m_reactiveCapabilityCurve;

  return configure_injection(builded);
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
