//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

/**
 * @file GeneratorOperatorActivePowerRangeBuilder.cpp
 * @brief Provides GeneratorOperatorActivePowerRangeBuilder
 */

#include <IIDM/extensions/generatorOperatorActivePowerRange/GeneratorOperatorActivePowerRangeBuilder.h>

namespace IIDM {
namespace extensions {
namespace generator_operator_activepower_range {

GeneratorOperatorActivePowerRange GeneratorOperatorActivePowerRangeBuilder::build() const {
  GeneratorOperatorActivePowerRange builded(m_activePowerLimitation);
  return builded;
}

} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
