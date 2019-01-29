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
 * @file builders/HvdcLineBuilder.cpp
 * @brief HvdcLine builder implementation file
 */

#include <IIDM/builders/HvdcLineBuilder.h>

namespace IIDM {
namespace builders {

HvdcLineBuilder::builded_type
HvdcLineBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_r = m_r;
  builded.m_nominalV = m_nominalV;
  builded.m_activePowerSetpoint = m_activePowerSetpoint;
  builded.m_maxP = m_maxP;
  builded.m_convertersMode = m_convertersMode;
  builded.m_converterStation1 = m_converterStation1;
  builded.m_converterStation2 = m_converterStation2;

  return builded;
}

} // end of namespace IIDM::builders::
} // end of namespace IIDM::
