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
 * @file BusbarSectionPositionFormatter.cpp
 * @brief Provides BusbarSectionPositionFormatter definition
 */

#include <IIDM/extensions/busbarSectionPosition/xml/BusbarSectionPositionFormatter.h>
#include <IIDM/extensions/busbarSectionPosition/BusbarSectionPosition.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace busbarsection_position {
namespace xml {

void exportBusbarSectionPosition(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  BusbarSectionPosition const* ext = identifiable.findExtension<BusbarSectionPosition>();
  if (ext) {
    root.empty_element(xml_prefix, "busbarSectionPosition",
      ::xml::sax::formatter::AttributeList("busbarIndex", ext->busbarIndex())("sectionIndex", ext->sectionIndex())
    );
  }
}

} // end of namespace IIDM::extensions::busbarsection_position::xml::
} // end of namespace IIDM::extensions::busbarsection_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
