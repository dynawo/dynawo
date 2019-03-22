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
 * @file xml/import/NetworkHandler.h
 * @brief Provides NetworkHandler interface
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_NETWORKHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_NETWORKHANDLER_H

#include <xml/sax/parser/ComposableElementHandler.h>

#include <IIDM/xml/import/SubstationHandler.h>
#include <IIDM/xml/import/LinesHandler.h>
#include <IIDM/xml/import/HvdcLineHandler.h>

#include <IIDM/Network.h>

namespace IIDM {
namespace xml {

class NetworkHandler: public ::xml::sax::parser::ComposableElementHandler {
public:
  explicit NetworkHandler(elementName_type const& root_element);

  bool has_network() const { return static_cast<bool>(m_network); }

  IIDM::Network const& network() const { return *m_network; }
  IIDM::Network & network() { return *m_network; }

private:
  mutable boost::optional<IIDM::Network> m_network;

  SubstationHandler substation_handler;
  LineHandler line_handler;
  TieLineHandler tieline_handler;
  HvdcLineHandler hvdcline_handler;

private:
  void create(attributes_type const& attributes);

  template <typename Handler>//Handler is either LineHandler or TieLineHandler
  void set_connectable_handler(path_type const& path, Handler& handler);

  void add_substation();
  void add_hvdcline();
};

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
