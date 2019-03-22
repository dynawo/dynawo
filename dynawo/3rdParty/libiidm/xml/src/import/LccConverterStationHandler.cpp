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
 * @file xml/import/LccConverterStationHandler.cpp
 * @brief ReactiveCapabilityCurveHandler, and LccConverterStationHandler definition
 */

#include <IIDM/xml/import/LccConverterStationHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;

namespace IIDM {
namespace xml {

LccConverterStationHandler::LccConverterStationHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::LccConverterStationBuilder, false, IIDM::side_1>(root_element)
{}

void LccConverterStationHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::LccConverterStationBuilder, false, IIDM::side_1>::configure(attributes);

  builder()
    .lossFactor( attributes["lossFactor"] )
    .powerFactor( attributes["powerFactor"] )
    .p( attributes["p"] )
    .q( attributes["q"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
