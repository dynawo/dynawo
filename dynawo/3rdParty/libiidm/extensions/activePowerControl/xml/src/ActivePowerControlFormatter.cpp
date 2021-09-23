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
 * @file ActivePowerControlFormatter.cpp
 * @brief Provides ActivePowerControlFormatter definition
 */

#include <IIDM/extensions/activePowerControl/xml/ActivePowerControlFormatter.h>
#include <IIDM/extensions/activePowerControl/ActivePowerControl.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace activepowercontrol {
namespace xml {

void exportActivePowerControl(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  ActivePowerControl const* ext = identifiable.findExtension<ActivePowerControl>();
  if (ext) {
    root.empty_element(xml_prefix, "activePowerControl",
      ::xml::sax::formatter::AttributeList
        ("participate", ext->participate())
        ("droop", ext->droop())
    );
  }
}

} // end of namespace IIDM::extensions::activepowercontrol::xml::
} // end of namespace IIDM::extensions::activepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
