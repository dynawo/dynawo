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
 * @file builders/BusBuilder.h
 * @brief Bus builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_BUSBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_BUSBUILDER_H

#include <boost/optional.hpp>


#include <IIDM/builders/IdentifiableBuilder.h>

namespace IIDM {
class Bus;

namespace builders {

/**
 * @class BusBuilder
 * @brief IIDM::Bus builder
 */
class BusBuilder: public IdentifiableBuilder<IIDM::Bus, BusBuilder> {
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(BusBuilder, double, v)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(BusBuilder, double, angle)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
