//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

/**
 * @file  TLEventFactory.cpp
 *
 * @brief Dynawo event factory :  implementation file
 *
 */

#include "TLEventFactory.h"
#include "TLEvent.h"

namespace timeline {

std::unique_ptr<Event>
EventFactory::newEvent() {
  return std::unique_ptr<Event>(new Event());
}

}  // namespace timeline
