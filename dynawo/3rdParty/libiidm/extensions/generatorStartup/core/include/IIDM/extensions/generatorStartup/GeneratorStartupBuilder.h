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
 * @file IIDM/extensions/generatorStartup/GeneratorStartupBuilder.h
 * @brief Provides GeneratorStartup interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATORSTARTUP_GUARD_GENERATORSTARTUP_BUILDER_H
#define LIBIIDM_EXTENSIONS_GENERATORSTARTUP_GUARD_GENERATORSTARTUP_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/generatorStartup/GeneratorStartup.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generator_startup {

class GeneratorStartupBuilder {
public:
  typedef GeneratorStartup builded_type;
  typedef GeneratorStartupBuilder builder_type;

  GeneratorStartup build() const;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<float>, predefinedActivePowerSetpoint)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<float>, marginalCost)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<float>, plannedOutageRate)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<float>, forcedOutageRate)
};

} // end of namespace IIDM::extensions::generator_startup::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
