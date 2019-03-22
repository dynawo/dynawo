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
 * @file builders/VscConverterStationBuilder.cpp
 * @brief VscConverterStation builder implementation file
 */
//=============================================================================

#include <IIDM/builders/VscConverterStationBuilder.h>

#include <IIDM/components/VscConverterStation.h>

namespace IIDM {

namespace builders {

VscConverterStationBuilder::builded_type
VscConverterStationBuilder::build(id_type const& id) const {

  if (!m_minMaxReactiveLimits && !m_reactiveCapabilityCurve) {
    throw builder_exception(id +": LccConverterStation needs either reactiveCapabilityCurve or minMaxReactiveLimits.");
  }

  builded_type builded(make_identifier(id), properties());

  builded.m_lossFactor = m_lossFactor;
  builded.m_regulating = m_regulating;

  builded.m_voltageSetpoint = m_voltageSetpoint;
  builded.m_reactivePowerSetpoint = m_reactivePowerSetpoint;

  builded.m_minMaxReactiveLimits = m_minMaxReactiveLimits;
  builded.m_reactiveCapabilityCurve = m_reactiveCapabilityCurve;

  return configure_injection(builded);
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
