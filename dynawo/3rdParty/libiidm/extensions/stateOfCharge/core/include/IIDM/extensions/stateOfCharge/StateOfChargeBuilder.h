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
 * @file IIDM/extensions/stateOfCharge/StateOfChargeBuilder.h
 * @brief Provides StateOfChargeBuilder
 */

#ifndef LIBIIDM_EXTENSIONS_STATEOFCHARGE_GUARD_STATEOFCHARGE_BUILDER_H
#define LIBIIDM_EXTENSIONS_STATEOFCHARGE_GUARD_STATEOFCHARGE_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/stateOfCharge/StateOfCharge.h>
#include <IIDM/cpp11.h>

#include <string>

namespace IIDM {
namespace extensions {
namespace stateofcharge {

class StateOfChargeBuilder {
public:
  typedef StateOfCharge builded_type;
  typedef StateOfChargeBuilder builder_type;

  StateOfCharge build() const;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, min)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, max)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, current)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, double, storageCapacity)
};

} // end of namespace IIDM::extensions::stateofcharge::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
