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
 * @file builders/HvdcLineBuilder.h
 * @brief HvdcLine builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_HVDCLINEBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_HVDCLINEBUILDER_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/IdentifiableBuilder.h>

#include <IIDM/components/HvdcLine.h>

namespace IIDM {
namespace builders {

/**
 * @class LineBuilder
 * @brief IIDM::Line builder
 */
class IIDM_EXPORT HvdcLineBuilder: public IdentifiableBuilder<IIDM::HvdcLine, HvdcLineBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(HvdcLineBuilder, double, r)
  MACRO_IIDM_BUILDER_PROPERTY(HvdcLineBuilder, double, nominalV)
  MACRO_IIDM_BUILDER_PROPERTY(HvdcLineBuilder, double, activePowerSetpoint)
  MACRO_IIDM_BUILDER_PROPERTY(HvdcLineBuilder, double, maxP)

  MACRO_IIDM_BUILDER_PROPERTY(HvdcLineBuilder, HvdcLine::mode_enum, convertersMode)

  MACRO_IIDM_BUILDER_PROPERTY(HvdcLineBuilder, id_type, converterStation1)
  MACRO_IIDM_BUILDER_PROPERTY(HvdcLineBuilder, id_type, converterStation2)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
