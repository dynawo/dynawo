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
 * @file IIDM/extensions/hvdcAngleDroopActivePowerControl/HvdcAngleDroopActivePowerControl.h
 * @brief Provides HvdcAngleDroopActivePowerControl
 */

#ifndef LIBIIDM_EXTENSIONS_HVDCANGLEDROOPACTIVEPOWERCONTROL_GUARD_HVDCANGLEDROOPACTIVEPOWERCONTROL_BUILDER_H
#define LIBIIDM_EXTENSIONS_HVDCANGLEDROOPACTIVEPOWERCONTROL_GUARD_HVDCANGLEDROOPACTIVEPOWERCONTROL_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/hvdcAngleDroopActivePowerControl/HvdcAngleDroopActivePowerControl.h>

namespace IIDM {
namespace extensions {
namespace hvdcangledroopactivepowercontrol {

class HvdcAngleDroopActivePowerControlBuilder {
public:
    typedef HvdcAngleDroopActivePowerControl builded_type;
    typedef HvdcAngleDroopActivePowerControlBuilder builder_type;

    HvdcAngleDroopActivePowerControl build() const;

MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, p0)
MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, droop)
MACRO_IIDM_BUILDER_PROPERTY(builder_type, bool, enabled)
};

} // end of namespace IIDM::extensions::hvdcangledroopactivepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
