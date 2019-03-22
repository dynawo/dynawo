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
 * @file IIDM/extensions/currentLimitsPerSeason/CurrentLimitsPerSeasonBuilder.h
 * @brief Provides CurrentLimitsPerSeasonBuilder
 */

#ifndef LIBIIDM_EXTENSIONS_CURRENTLIMITSPERSEASON_GUARD_CURRENTLIMITSPERSEASON_BUILDER_H
#define LIBIIDM_EXTENSIONS_CURRENTLIMITSPERSEASON_GUARD_CURRENTLIMITSPERSEASON_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/currentLimitsPerSeason/CurrentLimitsPerSeason.h>
#include <IIDM/cpp11.h>

#include <string>

namespace IIDM {
namespace extensions {
namespace currentlimitsperseason {

class CurrentLimitsPerSeasonBuilder {
public:
  typedef CurrentLimitsPerSeason builded_type;
  typedef CurrentLimitsPerSeasonBuilder builder_type;

  builded_type build() const;

private:
  builded_type m_builded;
};

} // end of namespace IIDM::extensions::currentlimitsperseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
