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
 * @file builders/BusBarSectionBuilder.cpp
 * @brief BusBarSection builder implementation file
 */
//=============================================================================

#include <IIDM/builders/BusBarSectionBuilder.h>

#include <IIDM/components/BusBarSection.h>

namespace IIDM {

namespace builders {

BusBarSectionBuilder::builded_type
BusBarSectionBuilder::build(id_type const& id) const {
  builded_type builded(make_identifier(id), properties());

  builded.m_node=m_node;
  builded.m_v=m_v;
  builded.m_angle=m_angle;

  return builded;
}

} // end of namespace IIDM::builders::
} // end of namespace IIDM::
