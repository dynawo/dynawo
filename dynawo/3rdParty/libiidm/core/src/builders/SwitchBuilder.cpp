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
 * @file builders/SwitchBuilder.cpp
 * @brief Switch builder implementation file
 */
//=============================================================================

#include <IIDM/builders/SwitchBuilder.h>

namespace IIDM {

namespace builders {

SwitchBuilder::builded_type
SwitchBuilder::build(id_type const& id) const {
  return builded_type(make_identifier(id), m_type, m_retained, m_opened, m_fictitious);
}

} // end of namespace IIDM::builders::
} // end of namespace IIDM::
