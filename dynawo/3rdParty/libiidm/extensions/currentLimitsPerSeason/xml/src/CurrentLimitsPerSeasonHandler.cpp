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
 * @file CurrentLimitsPerSeasonHandler.cpp
 * @brief Provides CurrentLimitsPerSeasonHandler definition
 */

#include <IIDM/extensions/currentLimitsPerSeason/xml/CurrentLimitsPerSeasonHandler.h>

#include <IIDM/xml/ExecUtils.h>

#include "internals/config.h"

#include <boost/bind.hpp>

#include <IIDM/extensions/CurrentLimitsPerSeason.h>

#include <IIDM/xml/import/CurrentLimitsHandler.h>
#include <IIDM/xml/import/iidm_namespace.h>

#include <iostream>

namespace parser = ::xml::sax::parser;

using IIDM::xml::iidm_ns;

namespace IIDM {
namespace extensions {
namespace currentlimitsperseason {
namespace xml {

// ************ class CurrentLimitsPerSeasonHandler ************ //

std::string CurrentLimitsPerSeasonHandler::xsd_path() {
  const std::string xsdPath = getMandatoryEnvVar("IIDM_XML_XSD_PATH");
  return xsdPath + std::string("currentLimitsPerSeason.xsd");
}

CurrentLimitsPerSeasonHandler::elementName_type const& CurrentLimitsPerSeasonHandler::root() {
  static elementName_type const root(
    parser::namespace_uri("http://www.itesla_project.eu/schema/iidm/ext/current-limits-per-season/1_0"), "currentLimitsPerSeason"
  );
  return root;
}

CurrentLimitsPerSeasonHandler::CurrentLimitsPerSeasonHandler():
  season_handler( elementName_type(root().ns, "season"), root() )
{
  onStartElement(root(), boost::bind(&CurrentLimitsPerSeasonHandler::clear, boost::ref(*this)) );

  onElement( root() + elementName_type(root().ns, "season"), season_handler );
  season_handler.onEnd( boost::bind(&CurrentLimitsPerSeasonHandler::add_season, boost::ref(*this)) );
}

void CurrentLimitsPerSeasonHandler::clear() {
  builded = CurrentLimitsPerSeason();
}

void CurrentLimitsPerSeasonHandler::add_season() {
  builded.set(season_handler.make());
}


CurrentLimitsPerSeason* CurrentLimitsPerSeasonHandler::do_make() {
  return new CurrentLimitsPerSeason(builded);
}

// ******************** class SeasonHandler ******************** //

SeasonHandler::SeasonHandler(elementName_type const& element_name, elementName_type const& root):
  limits_handler( elementName_type(root.ns, "currentLimits") ),
  limits1_handler( elementName_type(root.ns, "currentLimits1") ),
  limits2_handler( elementName_type(root.ns, "currentLimits2") ),
  limits3_handler( elementName_type(root.ns, "currentLimits3") )
{
  onStartElement(element_name, boost::bind<void>(&SeasonHandler::start, boost::ref(*this), _2) );

  onElement( element_name+root.ns("currentLimits"), limits_handler );
  onElement( element_name+root.ns("currentLimits1"), limits1_handler );
  onElement( element_name+root.ns("currentLimits2"), limits2_handler );
  onElement( element_name+root.ns("currentLimits3"), limits3_handler );
}


void SeasonHandler::start(attributes_type const& attributes) {
  limits_handler.clear();
  limits1_handler.clear();
  limits2_handler.clear();
  limits3_handler.clear();
  name = attributes["name"].as_string();
}


CurrentLimitsPerSeason::season SeasonHandler::make() const {
  if (limits_handler.limits) {
    return CurrentLimitsPerSeason::season(name, *limits_handler.limits);
  }
  CurrentLimitsPerSeason::season season(name, false);
  if (limits1_handler.limits) season.set(IIDM::side_1, *limits1_handler.limits);
  if (limits2_handler.limits) season.set(IIDM::side_2, *limits2_handler.limits);
  if (limits3_handler.limits) season.set(IIDM::side_3, *limits3_handler.limits);
  return season;
}


} // end of namespace IIDM::extensions::currentlimitsperseason::xml::
} // end of namespace IIDM::extensions::currentlimitsperseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
