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
 * @file builders/StaticVarCompensatorBuilder.cpp
 * @brief StaticVarCompensator builder implementation file
 */
//=============================================================================
#include <IIDM/builders/StaticVarCompensatorBuilder.h>

#include <IIDM/components/StaticVarCompensator.h>

namespace IIDM {

namespace builders {

StaticVarCompensatorBuilder::builded_type
StaticVarCompensatorBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_regulationMode = m_regulationMode;
  builded.m_bmin = m_bmin;
  builded.m_bmax = m_bmax;
  builded.m_voltageSetPoint = m_voltageSetPoint;
  builded.m_reactivePowerSetPoint = m_reactivePowerSetPoint;

  return configure_injection(builded);
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
