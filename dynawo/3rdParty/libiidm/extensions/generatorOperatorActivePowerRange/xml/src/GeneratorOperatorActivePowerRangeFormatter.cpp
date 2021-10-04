//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

/**
 * @file GeneratorOperatorActivePowerRangeFormatter.cpp
 * @brief Provides GeneratorOperatorActivePowerRangeFormatter definition
 */

#include <IIDM/extensions/generatorOperatorActivePowerRange/xml/GeneratorOperatorActivePowerRangeFormatter.h>
#include <IIDM/extensions/generatorOperatorActivePowerRange/GeneratorOperatorActivePowerRange.h>
#include <IIDM/components/Identifiable.h>

#include <string>

#include <xml/sax/formatter/Document.h>

namespace IIDM {
namespace extensions {
namespace generator_operator_activepower_range {
namespace xml {

void exportGeneratorOperatorActivePowerRange(IIDM::Identifiable const& identifiable, ::xml::sax::formatter::Element& root, std::string const& xml_prefix) {
  //Serialization (write)
    GeneratorOperatorActivePowerRange const* ext = identifiable.findExtension<GeneratorOperatorActivePowerRange>();
    if (ext) {
        root.empty_element(xml_prefix, "generatorOperatorActivePowerRange",
                           ::xml::sax::formatter::AttributeList
                                   ("activePowerLimitation", ext->activePowerLimitation())
        );
    }
}

} // end of namespace IIDM::extensions::generator_operator_activepower_range::xml::
} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
