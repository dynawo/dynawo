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
 * @file ActiveSeasonFormatter.cpp
 * @brief Provides ActiveSeasonFormatter definition
 */
 
#include <IIDM/extensions/activeSeason/xml/ActiveSeasonFormatter.h>
#include <IIDM/extensions/activeSeason/ActiveSeason.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace activeseason {
namespace xml {

void exportActiveSeason(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  ActiveSeason const* ext = identifiable.findExtension<ActiveSeason>();
  if (ext) {
    root.simple_element(xml_prefix, "activeSeason", ext->value());
  }
}

} // end of namespace IIDM::extensions::activeseason::xml::
} // end of namespace IIDM::extensions::activeseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
