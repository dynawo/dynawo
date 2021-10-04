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
 * @file StateOfChargeFormatter.cpp
 * @brief Provides StateOfChargeFormatter definition
 */

#include <IIDM/extensions/stateOfCharge/xml/StateOfChargeFormatter.h>

#include <IIDM/extensions/StateOfCharge.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace stateofcharge {
namespace xml {

void exportStateOfCharge(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  StateOfCharge const* ext = identifiable.findExtension<StateOfCharge>();
  if (ext) {
    root.empty_element(xml_prefix, "stateOfCharge",
      ::xml::sax::formatter::AttributeList
        ("min", ext->min())
        ("max", ext->max())
        ("current", ext->current())
        ("storageCapacity", ext->storageCapacity())
    );
  }
}

} // end of namespace IIDM::extensions::stateofcharge::xml::
} // end of namespace IIDM::extensions::stateofcharge::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
