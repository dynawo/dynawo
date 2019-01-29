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
 * @file builders/GeneratorBuilder.cpp
 * @brief Generator builder implementation file
 */

#include <IIDM/builders/GeneratorBuilder.h>

#include <IIDM/components/Generator.h>

namespace IIDM {

namespace builders {

GeneratorBuilder::builded_type
GeneratorBuilder::build(id_type const& id) const {
  
  if (!m_minMaxReactiveLimits && !m_reactiveCapabilityCurve) {
    throw builder_exception(id +": generator needs either reactiveCapabilityCurve or minMaxReactiveLimits.");
  }
  
  builded_type builded(make_identifier(id), properties());
  
  builded.m_energySource = m_energySource;
  builded.m_regulating = m_regulating;
  builded.m_pmin = m_pmin;
  builded.m_pmax = m_pmax;
  builded.m_targetP = m_targetP;
  builded.m_targetQ = m_targetQ;
  builded.m_targetV = m_targetV;
  builded.m_ratedS = m_ratedS;

  builded.m_minMaxReactiveLimits = m_minMaxReactiveLimits;
  builded.m_reactiveCapabilityCurve = m_reactiveCapabilityCurve;
  builded.m_regulatingTerminal = m_regulatingTerminal;
  
  return configure_injection(builded);
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
