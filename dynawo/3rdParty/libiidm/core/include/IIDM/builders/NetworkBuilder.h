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
 * @file builders/NetworkBuilder.h
 * @brief Network builder
 */

#ifndef LIBIIDM_BUILDERS_GUARD_NETWORKBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_NETWORKBUILDER_H

#include <string>


#include <IIDM/builders/builders_utils.h>
#include <IIDM/BasicTypes.h>

namespace IIDM {
class Network;

namespace builders {

/**
 * @class NetworkBuilder
 * @brief IIDM::Network builder
 */
class NetworkBuilder {
public:
  typedef IIDM::Network builded_type;

  MACRO_IIDM_BUILDER_PROPERTY(NetworkBuilder, std::string, sourceFormat)
  MACRO_IIDM_BUILDER_PROPERTY(NetworkBuilder, std::string, caseDate)
  MACRO_IIDM_BUILDER_PROPERTY(NetworkBuilder, int, forecastDistance)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
