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
 * @file IIDM/extensions/standbyAutomaton/StandbyAutomatonBuilder.h
 * @brief Provides StandbyAutomatonBuilder
 */

#ifndef LIBIIDM_EXTENSIONS_STANDBYAUTOMATON_GUARD_STANDBYAUTOMATON_BUILDER_H
#define LIBIIDM_EXTENSIONS_STANDBYAUTOMATON_GUARD_STANDBYAUTOMATON_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/standbyAutomaton/StandbyAutomaton.h>
#include <IIDM/cpp11.h>

#include <string>

namespace IIDM {
namespace extensions {
namespace standbyautomaton {

class StandbyAutomatonBuilder {
public:
  typedef StandbyAutomaton builded_type;
  typedef StandbyAutomatonBuilder builder_type;

  StandbyAutomaton build() const;
  
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, bool, standBy)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, b0)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, lowVoltageSetPoint)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, highVoltageSetPoint)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, lowVoltageThreshold)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, highVoltageThreshold)
};

} // end of namespace IIDM::extensions::standbyautomaton::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
