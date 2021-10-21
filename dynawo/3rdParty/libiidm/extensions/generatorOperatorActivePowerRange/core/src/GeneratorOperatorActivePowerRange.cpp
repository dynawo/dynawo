//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

#include <IIDM/extensions/generatorOperatorActivePowerRange/GeneratorOperatorActivePowerRange.h>

#include <cmath>

namespace IIDM {
namespace extensions {
namespace generator_operator_activepower_range {

GeneratorOperatorActivePowerRange::GeneratorOperatorActivePowerRange(double activePowerLimitation) {
  m_activePowerLimitation = checkActivePowerLimitation(activePowerLimitation);
}

GeneratorOperatorActivePowerRange* GeneratorOperatorActivePowerRange::do_clone() const {
  return new GeneratorOperatorActivePowerRange(m_activePowerLimitation);
}

double GeneratorOperatorActivePowerRange::checkActivePowerLimitation(double activePowerLimitation) const {
    if (std::isnan(activePowerLimitation)) {
        throw std::runtime_error("activePowerLimitation is not set");
    }
    return activePowerLimitation;
}

} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
