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
 * @file builders/LoadBuilder.h
 * @brief Load builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_LOADBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_LOADBUILDER_H

#include <boost/optional.hpp>


#include <IIDM/builders/InjectionBuilder.h>

#include <IIDM/components/Load.h>


namespace IIDM {
namespace builders {

/**
 * @class LoadBuilder
 * @brief IIDM::Load builder
 */
class LoadBuilder: public InjectionBuilder<IIDM::Load, LoadBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(LoadBuilder, double, p0)
  MACRO_IIDM_BUILDER_PROPERTY(LoadBuilder, double, q0)
  MACRO_IIDM_BUILDER_PROPERTY(LoadBuilder, builded_type::e_type, type)

public:
  LoadBuilder();
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
