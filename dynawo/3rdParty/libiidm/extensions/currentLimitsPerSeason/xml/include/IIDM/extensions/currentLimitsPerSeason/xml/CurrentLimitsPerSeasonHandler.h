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
 * @file IIDM/extensions/currentLimitsPerSeason/xml/CurrentLimitsPerSeasonHandler.h
 * @brief Provides CurrentLimitsPerSeasonHandler interface, used for input
 */

#ifndef LIBIIDM_EXTENSIONS_CURRENTLIMITSPERSEASON_XML_GUARD_CURRENTLIMITSPERSEASON_HANDLER_H
#define LIBIIDM_EXTENSIONS_CURRENTLIMITSPERSEASON_XML_GUARD_CURRENTLIMITSPERSEASON_HANDLER_H

#include <IIDM/xml/import/ExtensionHandler.h>
#include <IIDM/xml/import/CurrentLimitsHandler.h>

#include <IIDM/extensions/currentLimitsPerSeason/CurrentLimitsPerSeason.h>

#include <xml/sax/parser/ComposableElementHandler.h>
#include <xml/sax/parser/Attributes.h>

#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace currentlimitsperseason {
namespace xml {

class SeasonHandler: public ::xml::sax::parser::ComposableElementHandler {
public:
  SeasonHandler(elementName_type const& element_name, elementName_type const& root);

private:
  std::string name;

  IIDM::xml::CurrentLimitsHandler limits_handler;
  IIDM::xml::CurrentLimitsHandler limits1_handler;
  IIDM::xml::CurrentLimitsHandler limits2_handler;
  IIDM::xml::CurrentLimitsHandler limits3_handler;

  void start(attributes_type const& attributes);

public:
  CurrentLimitsPerSeason::season make() const;
};




class CurrentLimitsPerSeasonHandler: public IIDM::xml::ExtensionHandler, private ::xml::sax::parser::ComposableElementHandler {
public:
  static const elementName_type root;

  static std::string const& uri() { return root.ns; }

  static std::string xsd_path();


  CurrentLimitsPerSeasonHandler();

  virtual elementName_type const& root_element() const IIDM_OVERRIDE IIDM_FINAL { return root; }

private:
  virtual CurrentLimitsPerSeason* do_make() IIDM_OVERRIDE IIDM_FINAL;

private:
  SeasonHandler season_handler;
  CurrentLimitsPerSeason builded;

  void clear();
  void add_season();
};

} // end of namespace IIDM::extensions::currentlimitsperseason::xml::
} // end of namespace IIDM::extensions::currentlimitsperseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
