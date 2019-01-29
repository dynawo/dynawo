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
 * @file components/NetworkOf.h
 * @brief Provides the networkOf template functions
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_NETWORKOF_H
#define LIBIIDM_COMPONENTS_GUARD_NETWORKOF_H

#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class IIDM_EXPORT Network;

inline Network * network_of(Network & network) { return &network; }
inline Network const* network_of(Network const& network) { return &network; }

template <typename Parent>
inline Network const* network_of(ContainedIn<Parent> const& contained) {
  return contained.has_parent() ? network_of(contained.parent()) : IIDM_NULLPTR;
}

template <>
inline Network const* network_of(ContainedIn<Network> const& contained) {
  return contained.has_parent() ? &contained.parent() : IIDM_NULLPTR;
}


template <typename Parent>
inline Network * network_of(ContainedIn<Parent> & contained) {
  return contained.has_parent() ? network_of(contained.parent()) : IIDM_NULLPTR;
}

template <>
inline Network * network_of(ContainedIn<Network> & contained) {
  return contained.has_parent() ? &contained.parent() : IIDM_NULLPTR;
}

} // end of namespace IIDM::

#endif

