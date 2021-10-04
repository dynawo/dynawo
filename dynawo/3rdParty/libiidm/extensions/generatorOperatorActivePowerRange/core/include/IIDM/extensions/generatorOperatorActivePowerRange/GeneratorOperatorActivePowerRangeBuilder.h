//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

/**
 * @file IIDM/extensions/generatorOperatorActivePowerRange/GeneratorOperatorActivePowerRangeBuilder.h
 * @brief Provides GeneratorOperatorActivePowerRange interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_BUILDER_H
#define LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/generatorOperatorActivePowerRange/GeneratorOperatorActivePowerRange.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generator_operator_activepower_range {

class GeneratorOperatorActivePowerRangeBuilder {
public:
  typedef GeneratorOperatorActivePowerRange builded_type;
  typedef GeneratorOperatorActivePowerRangeBuilder builder_type;

  GeneratorOperatorActivePowerRange build() const;

  /*use MACRO_IIDM_BUILDER_PROPERTY and / or MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY
    to create properties + setters and getters in the builder*/
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, activePowerLimitation)
};

} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
