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
 * @file IIDM/extensions/activePowerControl/ActivePowerControlBuilder.h
 * @brief Provides ActivePowerControlBuilder
 */

#ifndef LIBIIDM_EXTENSIONS_ACTIVEPOWERCONTROL_GUARD_ACTIVEPOWERCONTROL_BUILDER_H
#define LIBIIDM_EXTENSIONS_ACTIVEPOWERCONTROL_GUARD_ACTIVEPOWERCONTROL_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/activePowerControl/ActivePowerControl.h>

namespace IIDM {
namespace extensions {
namespace activepowercontrol {

class ActivePowerControlBuilder {
public:
  typedef ActivePowerControl builded_type;
  typedef ActivePowerControlBuilder builder_type;

  ActivePowerControl build() const;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, bool, participate)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, droop)
};

} // end of namespace IIDM::extensions::activepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
