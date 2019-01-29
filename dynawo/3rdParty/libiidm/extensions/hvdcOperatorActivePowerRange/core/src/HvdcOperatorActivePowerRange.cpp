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

#include <IIDM/extensions/hvdcOperatorActivePowerRange/HvdcOperatorActivePowerRange.h>

#include <cmath>

namespace IIDM {
namespace extensions {
namespace hvdcoperatoractivepowerrange {

HvdcOperatorActivePowerRange::HvdcOperatorActivePowerRange(double oprFromCS1toCS2, double oprFromCS2toCS1):
    m_oprFromCS1toCS2(checkOpr(oprFromCS1toCS2)),
    m_oprFromCS2toCS1(checkOpr(oprFromCS2toCS1))
{
}

HvdcOperatorActivePowerRange* HvdcOperatorActivePowerRange::do_clone() const {
    return new HvdcOperatorActivePowerRange(m_oprFromCS1toCS2, m_oprFromCS2toCS1);
}

double HvdcOperatorActivePowerRange::checkOpr(double opr) const {
    if ((!std::isnan(opr)) && (opr < 0)) {
        // TODO: Add station names in error message
        throw std::runtime_error("OPR must be greater than 0.");
    }
    return opr;
}

} // end of namespace IIDM::extensions::hvdcoperatoractivepowerrange::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
