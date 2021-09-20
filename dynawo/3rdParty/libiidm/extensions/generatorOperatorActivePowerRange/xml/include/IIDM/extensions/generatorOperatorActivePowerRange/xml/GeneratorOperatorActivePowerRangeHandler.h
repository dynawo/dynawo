//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

/**
 * @file IIDM/extensions/generatorOperatorActivePowerRange/xml/GeneratorOperatorActivePowerRangeHandler.h
 * @brief Provides GeneratorOperatorActivePowerRangeHandler interface, used for input
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_XML_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_HANDLER_H
#define LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_XML_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_HANDLER_H

#include <IIDM/xml/import/ExtensionHandler.h>
#include <IIDM/extensions/generatorOperatorActivePowerRange/GeneratorOperatorActivePowerRange.h>

#include <xml/sax/parser/CDataCollector.h>

#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generator_operator_activepower_range {
namespace xml {

class GeneratorOperatorActivePowerRangeHandler: public IIDM::xml::ExtensionHandler, private ::xml::sax::parser::CDataCollector {
public:
  static const elementName_type root;

  static std::string const& uri() { return root.ns; }

  static std::string xsd_path();

  virtual elementName_type const& root_element() const IIDM_OVERRIDE IIDM_FINAL { return root; }

private:
  virtual GeneratorOperatorActivePowerRange* do_make() IIDM_OVERRIDE IIDM_FINAL;
};

} // end of namespace IIDM::extensions::generator_operator_activepower_range::xml::
} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
