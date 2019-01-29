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
 * @file IIDM/extensions/hvdcOperatorActivePowerRange/HvdcOperatorActivePowerRangeBuilder.h
 * @brief Provides HvdcOperatorActivePowerRangeBuilder
 */

#ifndef LIBIIDM_EXTENSIONS_HVDCOPERATORACTIVEPOWERRANGE_GUARD_HVDCOPERATORACTIVEPOWERRANGE_BUILDER_H
#define LIBIIDM_EXTENSIONS_HVDCOPERATORACTIVEPOWERRANGE_GUARD_HVDCOPERATORACTIVEPOWERRANGE_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/hvdcOperatorActivePowerRange/HvdcOperatorActivePowerRange.h>

namespace IIDM {
namespace extensions {
namespace hvdcoperatoractivepowerrange {

class HvdcOperatorActivePowerRangeBuilder {
public:
    typedef HvdcOperatorActivePowerRange builded_type;
    typedef HvdcOperatorActivePowerRangeBuilder builder_type;

    HvdcOperatorActivePowerRange build() const;

MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, oprFromCS1toCS2)
MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, oprFromCS2toCS1)
};

} // end of namespace IIDM::extensions::hvdcoperatoractivepowerrange::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
