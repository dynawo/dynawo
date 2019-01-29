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

#include <IIDM/extensions/hvdcAngleDroopActivePowerControl/HvdcAngleDroopActivePowerControl.h>

#include <cmath>

namespace IIDM {
namespace extensions {
namespace hvdcangledroopactivepowercontrol {

HvdcAngleDroopActivePowerControl::HvdcAngleDroopActivePowerControl(double p0, double droop, bool enabled):
    m_p0(checkP0(p0)),
    m_droop(checkDroop(droop)),
    m_enabled(enabled)
{
}

HvdcAngleDroopActivePowerControl* HvdcAngleDroopActivePowerControl::do_clone() const {
    return new HvdcAngleDroopActivePowerControl(m_p0, m_droop, m_enabled);
}

double HvdcAngleDroopActivePowerControl::checkP0(double p0) const {
    if (std::isnan(p0)) {
        throw std::runtime_error("p0 is not set");
    }
    return p0;
}

double HvdcAngleDroopActivePowerControl::checkDroop(double droop) const {
    if (std::isnan(droop)) {
        throw std::runtime_error("droop is not set");
    }
    return droop;
}

} // end of namespace IIDM::extensions::hvdcangledroopactivepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
