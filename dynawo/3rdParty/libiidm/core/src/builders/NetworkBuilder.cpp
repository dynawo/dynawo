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
 * @file builders/NetworkBuilder.cpp
 * @brief Network builder implementation file
 */
//=============================================================================
#include <IIDM/builders/NetworkBuilder.h>

#include <IIDM/Network.h>

namespace IIDM {

namespace builders {

NetworkBuilder::builded_type
NetworkBuilder::build(id_type const& id) const {
  return builded_type(id, m_sourceFormat, m_caseDate, m_forecastDistance);
}

} // end of namespace IIDM::builders::

} // end of namespace IIDM::
