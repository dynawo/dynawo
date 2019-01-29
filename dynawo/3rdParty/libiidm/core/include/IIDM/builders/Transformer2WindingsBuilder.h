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
 * @file builders/Transformer2WindingsBuilder.h
 * @brief Transformer2 builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_TRANSFORMER2WINDINGSBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_TRANSFORMER2WINDINGSBUILDER_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/IdentifiableBuilder.h>

#include <IIDM/components/Transformer2Windings.h>

#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/TapChanger.h>

namespace IIDM {
namespace builders {

/**
 * @brief IIDM::Transformer2 builder
 */
class IIDM_EXPORT Transformer2WindingsBuilder: public IdentifiableBuilder<IIDM::Transformer2Windings, Transformer2WindingsBuilder> {
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, PhaseTapChanger, phaseTapChanger)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, RatioTapChanger, ratioTapChanger)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, CurrentLimits, currentLimits1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, CurrentLimits, currentLimits2)

  MACRO_IIDM_BUILDER_PROPERTY(Transformer2WindingsBuilder, double, r )
  MACRO_IIDM_BUILDER_PROPERTY(Transformer2WindingsBuilder, double, x )
  MACRO_IIDM_BUILDER_PROPERTY(Transformer2WindingsBuilder, double, g )
  MACRO_IIDM_BUILDER_PROPERTY(Transformer2WindingsBuilder, double, b )
  MACRO_IIDM_BUILDER_PROPERTY(Transformer2WindingsBuilder, double, ratedU1)
  MACRO_IIDM_BUILDER_PROPERTY(Transformer2WindingsBuilder, double, ratedU2)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, double, p1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, double, p2)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, double, q1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Transformer2WindingsBuilder, double, q2)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
