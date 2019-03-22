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
 * @file xml/import/SubstationHandler.h
 * @brief Provides SubstationHandler interface
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_SUBSTATIONHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_SUBSTATIONHANDLER_H

#include <IIDM/xml/import/ContainerHandler.h>

#include <IIDM/xml/import/VoltageLevelHandler.h>
#include <IIDM/xml/import/Transformer2WindingsHandler.h>
#include <IIDM/xml/import/Transformer3WindingsHandler.h>

#include <IIDM/builders/SubstationBuilder.h>
#include <IIDM/components/Substation.h>

namespace IIDM {
namespace xml {

class SubstationHandler: public ContainerHandler<IIDM::builders::SubstationBuilder> {
private:
  typedef ContainerHandler<IIDM::builders::SubstationBuilder> parent_type;

public:
  SubstationHandler(elementName_type const& root_element);

private:
  VoltageLevelHandler voltagelevel_handler;
  Transformer2WindingsHandler transformer2windings_handler;
  Transformer3WindingsHandler transformer3windings_handler;

  void add_voltageLevel(VoltageLevelHandler const& vl_handler);

protected:
  void configure(attributes_type const& attributes) IIDM_OVERRIDE;
};


} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
