///
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
 * @file builders/BatteryBuilder.h
 * @brief Battery builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_BATTERYBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_BATTERYBUILDER_H

#include <boost/optional.hpp>

#include <IIDM/builders/InjectionBuilder.h>

#include <IIDM/components/Battery.h>


namespace IIDM {
namespace builders {

/**
 * @class BatteryBuilder
 * @brief IIDM::Battery builder
 */
class BatteryBuilder: public InjectionBuilder<IIDM::Battery, BatteryBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(BatteryBuilder, double, p0)
  MACRO_IIDM_BUILDER_PROPERTY(BatteryBuilder, double, q0)
  MACRO_IIDM_BUILDER_PROPERTY(BatteryBuilder, double, pmin)
  MACRO_IIDM_BUILDER_PROPERTY(BatteryBuilder, double, pmax)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(BatteryBuilder, MinMaxReactiveLimits, minMaxReactiveLimits)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(BatteryBuilder, ReactiveCapabilityCurve, reactiveCapabilityCurve)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
