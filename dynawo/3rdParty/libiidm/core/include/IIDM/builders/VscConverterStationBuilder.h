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
 * @file builders/VscConverterStationBuilder.h
 * @brief VscConverterStation builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_VSCCONVERTERSTATIONBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_VSCCONVERTERSTATIONBUILDER_H

#include <string>
#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/InjectionBuilder.h>

#include <IIDM/components/VscConverterStation.h>

namespace IIDM {
namespace builders {

/**
 * @class VscConverterStationBuilder
 * @brief IIDM::VscConverterStation builder
 */
class IIDM_EXPORT VscConverterStationBuilder: public InjectionBuilder<VscConverterStation, VscConverterStationBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(VscConverterStationBuilder, double, lossFactor)
  MACRO_IIDM_BUILDER_PROPERTY(VscConverterStationBuilder, bool, regulating)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VscConverterStationBuilder, double, voltageSetpoint)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VscConverterStationBuilder, double, reactivePowerSetpoint)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VscConverterStationBuilder, MinMaxReactiveLimits, minMaxReactiveLimits)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VscConverterStationBuilder, ReactiveCapabilityCurve, reactiveCapabilityCurve)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
