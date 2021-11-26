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
 * @file IIDM/extensions/voltageRegulation/xml/VoltageRegulationHandler.h
 * @brief Provides VoltageRegulationHandler interface, used for input
 */

#ifndef LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_XML_GUARD_VOLTAGEREGULATION_HANDLER_H
#define LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_XML_GUARD_VOLTAGEREGULATION_HANDLER_H

#include <IIDM/xml/import/ExtensionHandler.h>
#include <IIDM/extensions/voltageRegulation/VoltageRegulationBuilder.h>

#include <xml/sax/parser/ComposableElementHandler.h>

#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace voltageregulation {
namespace xml {

class VoltageRegulationHandler: public IIDM::xml::ExtensionHandler, private ::xml::sax::parser::ComposableElementHandler {
public:
  static const elementName_type root;

  static const std::string & uri() { return root.ns; }

  static const std::string& xsd_path();

  VoltageRegulationHandler();

  virtual elementName_type const& root_element() const IIDM_OVERRIDE IIDM_FINAL { return root; }

  void configure(attributes_type const& attributes);

private:
  void set_regulatingTerminal(attributes_type const& attributes);

  virtual VoltageRegulation* do_make() IIDM_FINAL;

private:
  VoltageRegulationBuilder builder;
};

} // end of namespace IIDM::extensions::voltageregulation::xml::
} // end of namespace IIDM::extensions::voltageregulation::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
