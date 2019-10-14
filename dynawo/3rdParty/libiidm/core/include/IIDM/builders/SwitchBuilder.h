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
 * @file builders/SwitchBuilder.h
 * @brief Switch builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_SWITCHBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_SWITCHBUILDER_H

#include <boost/optional.hpp>


#include <IIDM/builders/IdentifiableBuilder.h>
#include <IIDM/components/ConnectionPoint.h>

#include <IIDM/components/Switch.h>

namespace IIDM {
namespace builders {

/**
 * @class SwitchBuilder
 * @brief IIDM::Switch builder
 */
class SwitchBuilder: public IdentifiableBuilder<IIDM::Switch, SwitchBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(SwitchBuilder, builded_type::e_type, type)
  MACRO_IIDM_BUILDER_PROPERTY(SwitchBuilder, bool, retained)
  MACRO_IIDM_BUILDER_PROPERTY(SwitchBuilder, bool, opened)
  MACRO_IIDM_BUILDER_PROPERTY(SwitchBuilder, bool, fictitious)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
