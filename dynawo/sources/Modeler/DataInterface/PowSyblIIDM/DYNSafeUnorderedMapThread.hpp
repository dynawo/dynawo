//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAPTHREAD_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAPTHREAD_HPP_

#include "DYNSafeUnorderedMap.hpp"

#include <thread>

namespace DYN {
template<typename T, typename Hash = std::hash<std::thread::id>, typename KeyEqual = std::equal_to<std::thread::id>,
         typename Allocator = std::allocator<std::pair<const std::thread::id, T> > >
using SafeUnorderedMapThread = SafeUnorderedMap<std::thread::id, T, Hash, KeyEqual, Allocator>;
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSAFEUNORDEREDMAPTHREAD_HPP_
