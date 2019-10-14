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
 * @file builders/TieLineBuilder.h
 * @brief TieLine builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_TIELINEBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_TIELINEBUILDER_H

#include <boost/optional.hpp>


#include <IIDM/builders/IdentifiableBuilder.h>

#include <IIDM/components/CurrentLimit.h>

namespace IIDM {
class TieLine;

namespace builders {

/**
 * @class LineBuilder
 * @brief IIDM::Line builder
 */
class TieLineBuilder: public IdentifiableBuilder<IIDM::TieLine, TieLineBuilder> {
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, CurrentLimits, currentLimits1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, CurrentLimits, currentLimits2)

  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, std::string, id_1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, std::string, name_1)
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, r_1     )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, x_1     )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, g1_1    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, g2_1    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, b1_1    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, b2_1    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, xnodeP_1)
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, xnodeQ_1)

  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, std::string, id_2)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, std::string, name_2)
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, r_2     )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, x_2     )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, g1_2    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, g2_2    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, b1_2    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, b2_2    )
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, xnodeP_2)
  MACRO_IIDM_BUILDER_PROPERTY(TieLineBuilder, double, xnodeQ_2)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, std::string, ucteXnodeCode)

  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, double, p1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, double, q1)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, double, p2)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(TieLineBuilder, double, q2)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
