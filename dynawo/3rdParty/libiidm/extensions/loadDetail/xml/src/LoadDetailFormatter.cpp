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
 * @file LoadDetailFormatter.cpp
 * @brief Provides LoadDetailFormatter definition
 */

#include <IIDM/extensions/loadDetail/xml/LoadDetailFormatter.h>
#include <IIDM/extensions/loadDetail/LoadDetail.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace load_detail {
namespace xml {

void exportLoadDetail(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  LoadDetail const* ext = identifiable.findExtension<LoadDetail>();
  if (ext) {
    root.empty_element(xml_prefix, "detail",
      ::xml::sax::formatter::AttributeList("fixedActivePower", ext->fixedActivePower())
                                          ("fixedReactivePower", ext->fixedReactivePower())
                                          ("variableActivePower", ext->variableActivePower())
                                          ("variableReactivePower", ext->variableReactivePower())
    );
  }
}

} // end of namespace IIDM::extensions::load_detail::xml::
} // end of namespace IIDM::extensions::load_detail::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
