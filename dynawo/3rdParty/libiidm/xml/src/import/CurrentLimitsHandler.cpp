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
 * @file xml/import/CurrentLimitsHandler.cpp
 * @brief Provides CurrentLimitsHandler definition
 */

#include <IIDM/xml/import/CurrentLimitsHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include <xml/sax/parser/Attributes.h>

#include <boost/algorithm/string/trim.hpp>

#include <iostream>

namespace IIDM {
namespace xml {

void CurrentLimitsHandler::do_startElement(elementName_type const& name, attributes_type const& attributes) {
  if (name == root_name) {
    limits = IIDM::CurrentLimits( attributes["permanentLimit"].as< boost::optional<double> >() );
  } else if (name == iidm_ns("temporaryLimit")) {
    limits->add(
      attributes["name"],
      attributes["value"],
      attributes["acceptableDuration"],
      attributes["fictitious"]
    );
  }
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
