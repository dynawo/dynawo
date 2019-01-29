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
 * @file builders/ShuntCompensatorBuilder.cpp
 * @brief ShuntCompensator builder implementation file
 */
//=============================================================================
#include <IIDM/builders/ShuntCompensatorBuilder.h>

#include <IIDM/components/ShuntCompensator.h>

namespace IIDM {

namespace builders {

ShuntCompensatorBuilder::builded_type
ShuntCompensatorBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_section_current = m_section_current;
  builded.m_section_max = m_section_max;
  builded.m_b_per_section = m_b_per_section;

  return configure_injection(builded);
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
