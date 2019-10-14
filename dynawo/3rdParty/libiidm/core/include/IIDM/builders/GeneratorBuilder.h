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
 * @file builders/GeneratorBuilder.h
 * @brief Generator builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_GENERATORBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_GENERATORBUILDER_H

#include <string>
#include <boost/optional.hpp>


#include <IIDM/builders/InjectionBuilder.h>

#include <IIDM/components/Generator.h>

namespace IIDM {
namespace builders {

/**
 * @class GeneratorBuilder
 * @brief IIDM::Generator builder
 */
class GeneratorBuilder: public InjectionBuilder<Generator, GeneratorBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(GeneratorBuilder, Generator::energy_source_enum, energySource)
  MACRO_IIDM_BUILDER_PROPERTY(GeneratorBuilder, bool, regulating)
  MACRO_IIDM_BUILDER_PROPERTY(GeneratorBuilder, double, pmin)
  MACRO_IIDM_BUILDER_PROPERTY(GeneratorBuilder, double, pmax)
  MACRO_IIDM_BUILDER_PROPERTY(GeneratorBuilder, double, targetP)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(GeneratorBuilder, double, targetQ)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(GeneratorBuilder, double, targetV)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(GeneratorBuilder, double, ratedS)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(GeneratorBuilder, MinMaxReactiveLimits, minMaxReactiveLimits)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(GeneratorBuilder, ReactiveCapabilityCurve, reactiveCapabilityCurve)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(GeneratorBuilder, TerminalReference, regulatingTerminal)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
