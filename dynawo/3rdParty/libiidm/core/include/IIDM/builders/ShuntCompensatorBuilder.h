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
 * @file builders/ShuntCompensatorBuilder.h
 * @brief ShuntCompensator builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_SHUNTCOMPENSATORBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_SHUNTCOMPENSATORBUILDER_H

#include <boost/optional.hpp>


#include <IIDM/builders/InjectionBuilder.h>

#include <IIDM/components/ShuntCompensator.h>


namespace IIDM {
namespace builders {

/**
 * @class ShuntCompensatorBuilder
 * @brief IIDM::ShuntCompensator builder
 */
class ShuntCompensatorBuilder: public InjectionBuilder<IIDM::ShuntCompensator, ShuntCompensatorBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(ShuntCompensatorBuilder, builded_type::section_id, section_current)
  MACRO_IIDM_BUILDER_PROPERTY(ShuntCompensatorBuilder, builded_type::section_id, section_max)
  MACRO_IIDM_BUILDER_PROPERTY(ShuntCompensatorBuilder, double, b_per_section)

public:
  builded_type build(id_type const&) const;
};


} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
