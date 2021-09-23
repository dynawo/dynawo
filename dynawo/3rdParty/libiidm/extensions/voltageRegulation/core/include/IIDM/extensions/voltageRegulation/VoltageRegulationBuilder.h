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
 * @file IIDM/extensions/voltageRegulation/VoltageRegulationBuilder.h
 * @brief Provides VoltageRegulation interface
 */

#ifndef LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_GUARD_VOLTAGEREGULATION_BUILDER_H
#define LIBIIDM_EXTENSIONS_VOLTAGEREGULATION_GUARD_VOLTAGEREGULATION_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/voltageRegulation/VoltageRegulation.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace voltageregulation {

class VoltageRegulationBuilder {
public:
  typedef VoltageRegulation builded_type;
  typedef VoltageRegulationBuilder builder_type;

  VoltageRegulation build() const;

  MACRO_IIDM_BUILDER_PROPERTY(VoltageRegulationBuilder, bool, voltageRegulatorOn)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VoltageRegulationBuilder, double, targetV)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(VoltageRegulationBuilder, TerminalReference, regulatingTerminal)
};

} // end of namespace IIDM::extensions::voltageregulation::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
