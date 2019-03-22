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
 * @file xml/import/GeneratorHandler.cpp
 * @brief ReactiveCapabilityCurveHandler, and GeneratorHandler definition
 */

#include <IIDM/xml/import/GeneratorHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/Handler_utils.h"
#include "internals/import/TerminalReferenceHandler.h"

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;


namespace xml {
namespace sax {
namespace parser {

template<>
Attributes::SearchedAttribute::operator IIDM::Generator::energy_source_enum () const {
  if (!value) throw std::runtime_error("no value for attribute "+name);

  if (*value=="HYDRO"  ) return IIDM::Generator::source_hydro;
  if (*value=="NUCLEAR") return IIDM::Generator::source_nuclear;
  if (*value=="WIND"   ) return IIDM::Generator::source_wind;
  if (*value=="THERMAL") return IIDM::Generator::source_thermal;
  if (*value=="SOLAR"  ) return IIDM::Generator::source_solar;

  return IIDM::Generator::source_other;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
namespace xml {

GeneratorHandler::GeneratorHandler(elementName_type const& root_element):
  ConnectableHandler<IIDM::builders::GeneratorBuilder, false, IIDM::side_1>(root_element)
{
  curve_handler.onEnd( make_setter(builder(), &builder_type::reactiveCapabilityCurve, curve_handler.curve) );
  onElement( root_element+iidm_ns("reactiveCapabilityCurve"), curve_handler );

  limits_handler.onEnd( make_setter(builder(), &builder_type::minMaxReactiveLimits, limits_handler.limits) );
  onElement( root_element+iidm_ns("minMaxReactiveLimits"), limits_handler );

  onStartElement(
    root_element+iidm_ns("regulatingTerminal"),
    lambda::bind(&GeneratorHandler::set_regulatingTerminal, lambda::ref(*this), lambda_args::arg2 )
  );
}

void GeneratorHandler::set_regulatingTerminal(attributes_type const& attributes) {
  builder().regulatingTerminal( make_terminalReference(attributes) );
}

void GeneratorHandler::configure(attributes_type const& attributes) {
  ConnectableHandler<IIDM::builders::GeneratorBuilder, false, IIDM::side_1>::configure(attributes);

  builder()
    .energySource( attributes["energySource"] )
    .regulating( attributes["voltageRegulatorOn"] )
    .pmin( attributes["minP"] )
    .pmax( attributes["maxP"] )
    .targetP( attributes["targetP"] )
    .targetQ( attributes["targetQ"] )
    .targetV( attributes["targetV"] )
    .ratedS( attributes["ratedS"] )
    .p( attributes["p"] )
    .q( attributes["q"] )
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::
