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
 * @file CongestionManagementFormatter.cpp
 * @brief Provides CongestionManagementFormatter definition
 */

#include <IIDM/extensions/congestionManagement/xml/CongestionManagementFormatter.h>
#include <IIDM/extensions/congestionManagement/CongestionManagement.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace congestion_management {
namespace xml {

void exportCongestionManagement(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  CongestionManagement const* ext = identifiable.findExtension<CongestionManagement>();
  if (ext) {
    root.empty_element(xml_prefix, "congestionManagement",
      ::xml::sax::formatter::AttributeList("enabled", ext->enabled())
    );
  }
}

} // end of namespace IIDM::extensions::congestion_management::xml::
} // end of namespace IIDM::extensions::congestion_management::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
