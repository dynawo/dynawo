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
 * @file  DYNDelayManager.cpp
 *
 * @brief  Delay data manager implementation file
 *
 */

#include "DYNDelayManager.h"

namespace DYN {
size_t
DelayManager::addDelay(const double* value, const double* delay, double delayMax) {
  Delay new_delay(value, delay, delayMax);

  delays_.push_back(new_delay);
  return generateId();
}

size_t
DelayManager::addDelay(const double* value, double delay) {
  Delay new_delay(value, delay);

  delays_.push_back(new_delay);
  return generateId();
}

void
DelayManager::saveTimepoint(size_t value_id, double time) {
  // value id corresponds to index+1
  Delay& delay = getDelayById(value_id);

  delay.saveTimepoint(time);
}

std::pair<double, double>
DelayManager::getDelay(size_t value_id, double time) const {
  const Delay& delay = getDelayById(value_id);

  return delay.getDelay(time);
}

std::pair<double, double>
DelayManager::getLastDelay(size_t value_id) const {
  const Delay& delay = getDelayById(value_id);

  return delay.getLastDelay();
}

size_t
DelayManager::size(size_t value_id) const {
  const Delay& delay = getDelayById(value_id);

  return delay.size();
}

}  // namespace DYN
