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
#include "DYNTrace.h"
#include <limits>
#include <sstream>

namespace DYN {

DelayManager::DelayManager() : delays_() {}

void
DelayManager::addDelay(size_t id, const double* time, const double* value, const double delayMax) {
  Delay new_delay(time, value, delayMax);

  if (delays_.count(id) > 0) {
    // already present because of load parameters
    Delay& delay = delays_.at(id);
    delay.update(time, value, delayMax);
  } else {
    delays_.insert(std::make_pair(id, new_delay));
  }
}

void
DelayManager::saveTimepoint() {
  for (auto& delayPair : delays_)
    delayPair.second.saveTimepoint();
}

double
DelayManager::getDelay(const size_t id, const double delayValue) const {
  const Delay& delay = getDelayById(id);

  return delay.getDelay(delayValue);
}

const boost::optional<double>&
DelayManager::getInitialValue(const size_t id) const {
  const Delay& delay = getDelayById(id);

  return delay.initialValue();
}

std::vector<std::string>
DelayManager::dumpDelays() const {
  std::stringstream ss;
  std::vector<std::string> ret;

  for (const auto& delayPair : delays_) {
    const auto& delay = delayPair.second;
    ss.str("");
    std::vector<std::pair<double, double> > values;
    delay.points(values);

    ss << delayPair.first << ":";
    ss << double2String(delay.getDelayMax()) << ":";
    for (const auto& value : values) {
      ss << double2String(value.first) << "," << double2String(value.second) << ";";
    }
    ret.push_back(ss.str());
  }

  return ret;
}

bool
DelayManager::loadDelays(const std::vector<std::string>& values, const double restartTime) {
  for (const auto& valueStr : values) {
    std::istringstream is(valueStr);
    size_t id;
    is >> id;
    char c;
    is >> c;
    if (c != ':') {
      return false;
    }
    double delayMax;
    is >> delayMax;
    is >> c;
    if (c != ':') {
      return false;
    }

    boost::optional<double> last_time = boost::make_optional(false, double());
    std::vector<std::pair<double, double> > items;
    while (is.rdbuf()->in_avail()) {
      double time;
      double value;
      is >> time;

      if (!last_time) {
        last_time = value;
      } else if (doubleEquals(time, *last_time)) {
        // if with IDA we dump two times with the same time step we skip one
        last_time = time;

        is >> c;
        if (is.fail()) {
          return false;
        }
        if (c != ',') {
          return false;
        }
        is >> value;
        is >> c;
        if (c != ';') {
          return false;
        }
        continue;
      } else if (*last_time > time) {
        // last_time > time : error
        return false;
      }
      last_time = time;

      is >> c;
      if (is.fail()) {
        return false;
      }
      if (c != ',') {
        return false;
      }

      is >> value;
      items.emplace_back(time, value);

      is >> c;
      if (c != ';') {
        return false;
      }
    }

    Delay new_delay(items, delayMax, restartTime);
    delays_.insert(std::make_pair(id, new_delay));
  }

  return true;
}

void
DelayManager::setGomc(state_g* p_glocal, const size_t offset, const double time) const {
  size_t index = offset;

  for (const auto& delayPair : delays_) {
    const auto& delay = delayPair.second;
    const double delayTime = delay.getDelayTime();
    if (!(time < delayTime || doubleEquals(time, delayTime)) && !delay.isTriggered()) {
      p_glocal[index] = ROOT_UP;
    } else {
      p_glocal[index] = ROOT_DOWN;
    }
    ++index;
  }
}

modeChangeType_t
DelayManager::evalMode(const double time) {
  modeChangeType_t delay_mode = NO_MODE;
  for (auto& delayPair : delays_) {
    auto& delay = delayPair.second;
    double delayTime = delay.getDelayTime();
    if (!(time < delayTime || doubleEquals(time, delayTime)) && !delay.isTriggered()) {
      delay.trigger();
      Trace::debug() << modelName << " mode for delay " << it->first << " delayTime " << delayTime << Trace::endline;
      delay_mode = ALGEBRAIC_J_J_UPDATE_MODE;
    }
  }
  return delay_mode;
}

}  // namespace DYN
