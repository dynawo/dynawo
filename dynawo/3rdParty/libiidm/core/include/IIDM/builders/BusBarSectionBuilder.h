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
 * @file builders/BusBarSectionBuilder.h
 * @brief BusBarSection builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_BUSBARSECTIONBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_BUSBARSECTIONBUILDER_H

#include <boost/optional.hpp>


#include <IIDM/builders/IdentifiableBuilder.h>

namespace IIDM {
class BusBarSection;

namespace builders {

/**
 * @class BusBarSectionBuilder
 * @brief IIDM::BusBarSection builder
 */
class BusBarSectionBuilder: public IdentifiableBuilder<IIDM::BusBarSection, BusBarSectionBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(BusBarSectionBuilder, node_type, node)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(BusBarSectionBuilder, double, v)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(BusBarSectionBuilder, double, angle)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
