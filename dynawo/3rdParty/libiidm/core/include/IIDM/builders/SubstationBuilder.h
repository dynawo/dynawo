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
 * @file builders/SubstationBuilder.h
 * @brief Substation builder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_SUBSTATIONBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_SUBSTATIONBUILDER_H

#include <string>
#include <boost/optional.hpp>

#include <IIDM/Export.h>

#include <IIDM/builders/IdentifiableBuilder.h>

namespace IIDM {
class Substation;

namespace builders {

/**
 * @class SubstationBuilder
 * @brief IIDM::Substation builder
 */
class IIDM_EXPORT SubstationBuilder: public IdentifiableBuilder<IIDM::Substation, SubstationBuilder> {
  MACRO_IIDM_BUILDER_PROPERTY(SubstationBuilder, std::string, country)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(SubstationBuilder, std::string, tso)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(SubstationBuilder, std::string, geographicalTags)

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
