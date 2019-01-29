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
 * @file HvdcAngleDroopActivePowerControl.cpp
 * @brief Provides HvdcAngleDroopActivePowerControl definition
 */

#include <IIDM/extensions/hvdcAngleDroopActivePowerControl/xml/HvdcAngleDroopActivePowerControlFormatter.h>
#include <IIDM/extensions/hvdcAngleDroopActivePowerControl/HvdcAngleDroopActivePowerControl.h>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace hvdcangledroopactivepowercontrol {
namespace xml {

void exportHvdcAngleDroopActivePowerControl(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
    HvdcAngleDroopActivePowerControl const* ext = identifiable.findExtension<HvdcAngleDroopActivePowerControl>();
    if (ext) {
        root.empty_element(xml_prefix, "hvdcAngleDroopActivePowerControl",
                           ::xml::sax::formatter::AttributeList
                                   ("p0", ext->p0())
                                   ("droop", ext->droop())
                                   ("enabled", ext->enabled())
        );
    }
}

} // end of namespace IIDM::extensions::hvdcangledroopactivepowercontrol::xml::
} // end of namespace IIDM::extensions::hvdcangledroopactivepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
