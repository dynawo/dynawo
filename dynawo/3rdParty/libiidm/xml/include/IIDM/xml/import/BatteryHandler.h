///
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
 * @file xml/import/BatteryHandler.h
 * @brief Provides BatteryHandler interface
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_BATTERYHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_BATTERYHANDLER_H

#include <IIDM/xml/import/ConnectableHandler.h>
#include <IIDM/xml/import/ReactiveInformationsHandler.h>

#include <IIDM/builders/BatteryBuilder.h>

namespace IIDM {
namespace xml {

class BatteryHandler: public ConnectableHandler<IIDM::builders::BatteryBuilder, false, IIDM::side_1> {
public:
  BatteryHandler(elementName_type const& root_element);

private:
  ReactiveCapabilityCurveHandler curve_handler;
  MinMaxReactiveLimitsHandler limits_handler;

protected:
  void configure(attributes_type const& attributes) IIDM_OVERRIDE;
};

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
