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
 * @file HvdcOperatorActivePowerRange.cpp
 * @brief Provides HvdcOperatorActivePowerRange definition
 */

#include <IIDM/extensions/hvdcOperatorActivePowerRange/xml/HvdcOperatorActivePowerRangeFormatter.h>
#include <IIDM/extensions/hvdcOperatorActivePowerRange/HvdcOperatorActivePowerRange.h>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace hvdcoperatoractivepowerrange {
namespace xml {

void exportHvdcOperatorActivePowerRange(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
    HvdcOperatorActivePowerRange const* ext = identifiable.findExtension<HvdcOperatorActivePowerRange>();
    if (ext) {
        root.empty_element(xml_prefix, "hvdcOperatorActivePowerRange",
                           ::xml::sax::formatter::AttributeList
                                   ("fromCS1toCS2", ext->oprFromCS1toCS2())
                                   ("fromCS2toCS1", ext->oprFromCS2toCS1())
        );
    }
}

} // end of namespace IIDM::extensions::hvdcoperatoractivepowerrange::xml::
} // end of namespace IIDM::extensions::hvdcoperatoractivepowerrange::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
