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
 * @file IIDM/extensions/connectablePosition/xml/ConnectablePositionHandler.h
 * @brief Provides ConnectablePositionHandler interface, used for input
 */

#ifndef LIBIIDM_EXTENSIONS_CONNECTABLEPOSITION_XML_GUARD_CONNECTABLEPOSITION_HANDLER_H
#define LIBIIDM_EXTENSIONS_CONNECTABLEPOSITION_XML_GUARD_CONNECTABLEPOSITION_HANDLER_H

#include <IIDM/xml/import/ExtensionHandler.h>
#include <IIDM/extensions/connectablePosition/ConnectablePosition.h>

#include <xml/sax/parser/ComposableElementHandler.h>
#include <xml/sax/parser/Attributes.h>
#include <xml/sax/parser/CDataCollector.h>

#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace connectable_position {
namespace xml {

class FeederHandler : public ::xml::sax::parser::SimpleElementHandler {
public:
  FeederHandler() {}

  boost::optional<ConnectablePosition::Feeder> feeder;

protected:
  virtual void do_startElement(elementName_type const& name, attributes_type const& attributes) IIDM_OVERRIDE;
};

class ConnectablePositionHandler: public IIDM::xml::ExtensionHandler, private ::xml::sax::parser::ComposableElementHandler {
public:
  static elementName_type const& root();

  static std::string const& uri() { return root().ns; }

  static const std::string& xsd_path();

  virtual elementName_type const& root_element() const IIDM_OVERRIDE IIDM_FINAL { return root(); }

  ConnectablePositionHandler();

private:
    FeederHandler m_feederHandler;
    FeederHandler m_feeder1Handler;
    FeederHandler m_feeder2Handler;
    FeederHandler m_feeder3Handler;

    virtual ConnectablePosition* do_make() IIDM_OVERRIDE IIDM_FINAL;
};

} // end of namespace IIDM::extensions::connectable_position::xml::
} // end of namespace IIDM::extensions::connectable_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
