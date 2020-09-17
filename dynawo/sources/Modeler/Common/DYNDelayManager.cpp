//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
#include "DYNCommon.h"

#include <boost/optional.hpp>

#include <cassert>
#include <limits>

namespace DYN {
void
DelayManager::addDelay(size_t id, const double* time, const double* value, double delayMax) {
  Delay new_delay(time, value, delayMax);

  delays_.insert(std::make_pair(id, new_delay));
}

void
DelayManager::saveTimepoint() {
  for (boost::unordered_map<size_t, Delay>::iterator it = delays_.begin(); it != delays_.end(); ++it) {
    it->second.saveTimepoint();
  }
}

double
DelayManager::getDelay(size_t id, double delayValue) const {
  const Delay& delay = getDelayById(id);

  return delay.getDelay(delayValue);
}

const boost::optional<double>&
DelayManager::getInitialValue(size_t id) const {
  const Delay& delay = getDelayById(id);

  return delay.initialValue();
}

}  // namespace DYN
