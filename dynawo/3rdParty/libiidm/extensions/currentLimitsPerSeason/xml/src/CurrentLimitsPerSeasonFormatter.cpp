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
 * @file StandbyAutomatonFormatter.cpp
 * @brief Provides StandbyAutomatonFormatter definition
 */

#include <IIDM/extensions/currentLimitsPerSeason/xml/CurrentLimitsPerSeasonFormatter.h>

#include <IIDM/extensions/CurrentLimitsPerSeason.h>
#include <IIDM/components/Identifiable.h>
#include <IIDM/xml/export/export_functions.h>

#include <string>

#include <xml/sax/formatter/Document.h>

#include <iostream>

namespace IIDM {
namespace extensions {
namespace currentlimitsperseason {
namespace xml {

using ::xml::sax::formatter::Element;
using ::xml::sax::formatter::AttributeList;

void exportCurrentLimitsPerSeason(IIDM::Identifiable const& identifiable, Element& parent, std::string const& xml_prefix) {
  CurrentLimitsPerSeason const* ext = identifiable.findExtension<CurrentLimitsPerSeason>();
  if (ext) {
    Element element = parent.element(xml_prefix, "currentLimitsPerSeason");

    for (CurrentLimitsPerSeason::season_const_iterator it = ext->begin(); it != ext->end(); ++it) {
      Element season = element.element( xml_prefix, "season", AttributeList("name", it->name()) );

      if (it->single_sided()) {
        IIDM::CurrentLimits const* limits = it->find(IIDM::side_1);
        if (limits) {
          IIDM::xml::to_xml(season, "currentLimits", *limits, xml_prefix);
        }
      } else {
        IIDM::CurrentLimits const* limits;
        if ( (limits = it->find(IIDM::side_1)) ) IIDM::xml::to_xml(season, "currentLimits1", *limits, xml_prefix);
        if ( (limits = it->find(IIDM::side_2)) ) IIDM::xml::to_xml(season, "currentLimits2", *limits, xml_prefix);
        if ( (limits = it->find(IIDM::side_3)) ) IIDM::xml::to_xml(season, "currentLimits3", *limits, xml_prefix);
      }
    }
  }
}

} // end of namespace IIDM::extensions::currentlimitsperseason::xml::
} // end of namespace IIDM::extensions::currentlimitsperseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
