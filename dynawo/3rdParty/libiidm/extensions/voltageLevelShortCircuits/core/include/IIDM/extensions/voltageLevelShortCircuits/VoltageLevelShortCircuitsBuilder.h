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
 * @file IIDM/extensions/voltageLevelShortCircuits/VoltageLevelShortCircuitsBuilder.h
 * @brief Provides VoltageLevelShortCircuitsBuilder
 */

#ifndef LIBIIDM_EXTENSIONS_VOLTAGELEVELSHORTCIRCUITS_GUARD_VOLTAGELEVELSHORTCIRCUITS_BUILDER_H
#define LIBIIDM_EXTENSIONS_VOLTAGELEVELSHORTCIRCUITS_GUARD_VOLTAGELEVELSHORTCIRCUITS_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/voltageLevelShortCircuits/VoltageLevelShortCircuits.h>

namespace IIDM {
namespace extensions {
namespace voltagelevelshortcircuits {

class VoltageLevelShortCircuitsBuilder {
public:
  typedef VoltageLevelShortCircuits builded_type;
  typedef VoltageLevelShortCircuitsBuilder builder_type;

  VoltageLevelShortCircuits build() const;
  
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, minShortCircuitsCurrent)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, maxShortCircuitsCurrent)
};

} // end of namespace IIDM::extensions::voltagelevelshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
