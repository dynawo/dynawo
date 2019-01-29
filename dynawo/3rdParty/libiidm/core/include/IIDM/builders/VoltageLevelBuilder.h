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
 * @file builders/VoltageLevelBuilder.h
 * @brief VoltageLevel builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_VOLTAGELEVELBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_VOLTAGELEVELBUILDER_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/IdentifiableBuilder.h>
#include <IIDM/components/VoltageLevel.h>

namespace IIDM {
namespace builders {

/**
 * @class VoltageLevelBuilder
 * @brief IIDM::VoltageLevel builder
 */
class IIDM_EXPORT VoltageLevelBuilder: public IdentifiableBuilder<IIDM::VoltageLevel, VoltageLevelBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(VoltageLevelBuilder, builded_type::e_mode, mode)
  MACRO_IIDM_BUILDER_PROPERTY(VoltageLevelBuilder, double, nominalV)
  MACRO_IIDM_BUILDER_PROPERTY(VoltageLevelBuilder, node_type, node_count)
  
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VoltageLevelBuilder, double, lowVoltageLimit)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VoltageLevelBuilder, double, highVoltageLimit)
  
public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
