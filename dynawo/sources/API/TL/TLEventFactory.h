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
 * @file  TLEventFactory.h
 *
 * @brief Dynawo event factory : header file
 *
 */
#ifndef API_TL_TLEVENTFACTORY_H_
#define API_TL_TLEVENTFACTORY_H_

#include "TLEvent.h"

#include <memory>


namespace timeline {
/**
 * @class EventFactory
 * @brief Event factory class
 *
 * EventFactory encapsulate methods for creating new
 * @p Event objects.
 */
class EventFactory {
 public:
  /**
   * @brief Create new Event instance
   *
   * @return unique pointer to a new @p Event
   */
  static std::unique_ptr<Event> newEvent();
};
}  // namespace timeline

#endif  // API_TL_TLEVENTFACTORY_H_
