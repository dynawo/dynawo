//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

/**
 * @file IIDM/extensions/generatorOperatorActivePowerRange/xml/GeneratorOperatorActivePowerRangeFormatter.h
 * @brief Provides GeneratorOperatorActivePowerRangeFormatter interface, used for input
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_XML_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_FORMATTER_H
#define LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_XML_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_FORMATTER_H

#include <string>

namespace xml {
namespace sax {
namespace formatter {
class Element;
} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
class Identifiable;

namespace extensions {
namespace generator_operator_activepower_range {
namespace xml {

void exportGeneratorOperatorActivePowerRange(IIDM::Identifiable const&, ::xml::sax::formatter::Element& root, std::string const& xml_prefix);

} // end of namespace IIDM::extensions::generator_operator_activepower_range::xml::
} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
