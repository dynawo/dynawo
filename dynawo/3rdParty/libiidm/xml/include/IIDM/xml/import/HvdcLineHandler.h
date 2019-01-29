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
 * @file xml/import/HvdcLineHandler.h
 * @brief provides HvdcLineHandler interfaces
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_HVDCLINEHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_HVDCLINEHANDLER_H

#include <IIDM/xml/import/IdentifiableHandler.h>

#include <IIDM/xml/import/CurrentLimitsHandler.h>

#include <IIDM/BasicTypes.h>
#include <string>

#include <IIDM/builders/HvdcLineBuilder.h>

namespace IIDM {
namespace xml {

class HvdcLineHandler: public IdentifiableHandler<IIDM::builders::HvdcLineBuilder> {
public:
  HvdcLineHandler(elementName_type const& root_element);

protected:
  void configure(attributes_type const& attributes) IIDM_OVERRIDE;
};


} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
