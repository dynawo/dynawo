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
 * @file xml/import/LinesHandler.h
 * @brief provides LineHandler and TieLineHandler interfaces
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_LINESHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_LINESHANDLER_H

#include <IIDM/xml/import/ConnectableHandler.h>

#include <IIDM/xml/import/CurrentLimitsHandler.h>

#include <IIDM/BasicTypes.h>
#include <string>

#include <IIDM/builders/LineBuilder.h>
#include <IIDM/builders/TieLineBuilder.h>

namespace IIDM {
namespace xml {

class LineHandler: public ConnectableHandler<IIDM::builders::LineBuilder, true, IIDM::side_2> {
public:
  LineHandler(elementName_type const& root_element);

private:
  CurrentLimitsHandler currentLimits1_handler, currentLimits2_handler;

protected:
  void configure(attributes_type const& attributes) IIDM_OVERRIDE;
};



class TieLineHandler: public ConnectableHandler<IIDM::builders::TieLineBuilder, true, IIDM::side_2> {
public:
  TieLineHandler(elementName_type const& root_element);

private:
  CurrentLimitsHandler currentLimits1_handler, currentLimits2_handler;

protected:
  void configure(attributes_type const& attributes) IIDM_OVERRIDE;
};


} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
