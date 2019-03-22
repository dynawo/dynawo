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
 * @file builders/DanglingLineBuilder.h
 * @brief DanglingLine builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_DANGLINGLINEBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_DANGLINGLINEBUILDER_H

#include <string>
#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/InjectionBuilder.h>

#include <IIDM/components/CurrentLimit.h>

namespace IIDM {
class DanglingLine;

namespace builders {

/**
 * @class DanglingLineBuilder
 * @brief IIDM::DanglingLine builder
 */
class IIDM_EXPORT DanglingLineBuilder: public InjectionBuilder<IIDM::DanglingLine, DanglingLineBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(DanglingLineBuilder, double, p0)
  MACRO_IIDM_BUILDER_PROPERTY(DanglingLineBuilder, double, q0)
  MACRO_IIDM_BUILDER_PROPERTY(DanglingLineBuilder, double, r )
  MACRO_IIDM_BUILDER_PROPERTY(DanglingLineBuilder, double, x )
  MACRO_IIDM_BUILDER_PROPERTY(DanglingLineBuilder, double, g )
  MACRO_IIDM_BUILDER_PROPERTY(DanglingLineBuilder, double, b )
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(DanglingLineBuilder, std::string, ucte_xNodeCode)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(DanglingLineBuilder, IIDM::CurrentLimits, currentLimits)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
