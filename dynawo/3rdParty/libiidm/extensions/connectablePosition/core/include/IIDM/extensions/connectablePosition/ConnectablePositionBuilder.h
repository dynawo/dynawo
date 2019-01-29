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
 * @file IIDM/extensions/connectablePosition/ConnectablePositionBuilder.h
 * @brief Provides ConnectablePosition interface
 */

#ifndef LIBIIDM_EXTENSIONS_CONNECTABLEPOSITION_GUARD_CONNECTABLEPOSITION_BUILDER_H
#define LIBIIDM_EXTENSIONS_CONNECTABLEPOSITION_GUARD_CONNECTABLEPOSITION_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/connectablePosition/ConnectablePosition.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace connectable_position {

class ConnectablePositionBuilder {
public:
  typedef ConnectablePosition builded_type;
  typedef ConnectablePositionBuilder builder_type;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<ConnectablePosition::Feeder>, feeder)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<ConnectablePosition::Feeder>, feeder1)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<ConnectablePosition::Feeder>, feeder2)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<ConnectablePosition::Feeder>, feeder3)

  ConnectablePosition build() const;
};

} // end of namespace IIDM::extensions::connectable_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
