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
 * @file builders/LineBuilder.h
 * @brief Line builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_LINEBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_LINEBUILDER_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/IdentifiableBuilder.h>

#include <IIDM/components/CurrentLimit.h>

namespace IIDM {
class Line;

namespace builders {
  
/**
 * @class LineBuilder
 * @brief IIDM::Line builder
 */
class IIDM_EXPORT LineBuilder: public IdentifiableBuilder<IIDM::Line, LineBuilder> {
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(LineBuilder, CurrentLimits, currentLimits1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(LineBuilder, CurrentLimits, currentLimits2)

  MACRO_IIDM_BUILDER_PROPERTY(LineBuilder, double, r )
  MACRO_IIDM_BUILDER_PROPERTY(LineBuilder, double, x )
  MACRO_IIDM_BUILDER_PROPERTY(LineBuilder, double, g1)
  MACRO_IIDM_BUILDER_PROPERTY(LineBuilder, double, b1)
  MACRO_IIDM_BUILDER_PROPERTY(LineBuilder, double, g2)
  MACRO_IIDM_BUILDER_PROPERTY(LineBuilder, double, b2)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(LineBuilder, double, p1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(LineBuilder, double, q1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(LineBuilder, double, p2)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(LineBuilder, double, q2)
public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
