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
 * @file ConnectablePositionFormatter.cpp
 * @brief Provides ConnectablePositionFormatter definition
 */

#include <IIDM/extensions/connectablePosition/xml/ConnectablePositionFormatter.h>
#include <IIDM/extensions/connectablePosition/ConnectablePosition.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace connectable_position {
namespace xml {

using ::xml::sax::formatter::Element;
using ::xml::sax::formatter::AttributeList;

void toXml(::xml::sax::formatter::Element& parent, const std::string& elementName, const boost::optional<ConnectablePosition::Feeder>& feeder, std::string const& xml_prefix) {
  if (feeder) {
      const char *direction;
      switch (feeder->direction()) {
          case ConnectablePosition::Feeder::TOP:
              direction = "TOP";
              break;
          case ConnectablePosition::Feeder::BOTTOM:
              direction = "BOTTOM";
              break;
          case ConnectablePosition::Feeder::UNDEFINED:
              direction = "UNDEFINED";
              break;
          default:
              throw std::runtime_error("Bad direction");
      }
      parent.empty_element(xml_prefix, elementName,
                           ::xml::sax::formatter::AttributeList("name", feeder->name())
                                                               ("order", feeder->order())
                                                               ("direction", direction)
      );
  }
}

void exportConnectablePosition(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  ConnectablePosition const* ext = identifiable.findExtension<ConnectablePosition>();
  if (ext) {
    Element connectablePosition = root.element(xml_prefix, "position");

    toXml(connectablePosition, "feeder", ext->feeder(), xml_prefix);
    toXml(connectablePosition, "feeder1", ext->feeder1(), xml_prefix);
    toXml(connectablePosition, "feeder2", ext->feeder2(), xml_prefix);
    toXml(connectablePosition, "feeder3", ext->feeder3(), xml_prefix);
  }
}

} // end of namespace IIDM::extensions::connectable_position::xml::
} // end of namespace IIDM::extensions::connectable_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
