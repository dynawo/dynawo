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
 * @file builders/StaticVarCompensatorBuilder.h
 * @brief StaticVarCompensator builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_STATICVARCOMPENSATORBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_STATICVARCOMPENSATORBUILDER_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/InjectionBuilder.h>

#include <IIDM/components/StaticVarCompensator.h>


namespace IIDM {
namespace builders {

/**
 * @class StaticVarCompensatorBuilder
 * @brief IIDM::StaticVarCompensator builder
 */
class IIDM_EXPORT StaticVarCompensatorBuilder: public InjectionBuilder<IIDM::StaticVarCompensator, StaticVarCompensatorBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(StaticVarCompensatorBuilder, builded_type::e_regulation_mode, regulationMode)
  MACRO_IIDM_BUILDER_PROPERTY(StaticVarCompensatorBuilder, double, bmin)
  MACRO_IIDM_BUILDER_PROPERTY(StaticVarCompensatorBuilder, double, bmax)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(StaticVarCompensatorBuilder, double, voltageSetPoint)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(StaticVarCompensatorBuilder, double, reactivePowerSetPoint)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
