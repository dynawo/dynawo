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
 * @file builders/Transformer3WindingsBuilder.h
 * @brief Transformer3 builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_TRANSFORMER3WINDINGSBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_TRANSFORMER3WINDINGSBUILDER_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/IdentifiableBuilder.h>

#include <IIDM/components/Transformer3Windings.h>

#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/TapChanger.h>

namespace IIDM {
namespace builders {

/**
 * @brief IIDM::Transformer3 builder
 */
class IIDM_EXPORT Transformer3WindingsBuilder: public IdentifiableBuilder<IIDM::Transformer3Windings, Transformer3WindingsBuilder> {
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, RatioTapChanger, ratioTapChanger2)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, RatioTapChanger, ratioTapChanger3)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, CurrentLimits, currentLimits1)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, CurrentLimits, currentLimits2)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, CurrentLimits, currentLimits3)

MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, r1)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, x1)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, r2)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, x2)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, r3)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, x3)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, g1)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, b1)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, ratedU1)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, ratedU2)
MACRO_IIDM_BUILDER_PROPERTY(Transformer3WindingsBuilder, double, ratedU3)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, double, p1)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, double, p2)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, double, p3)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, double, q1)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, double, q2)
MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer3WindingsBuilder, double, q3)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
