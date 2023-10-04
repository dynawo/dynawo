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
#include <sstream>

namespace DYN {

DelayManager::DelayManager() : delays_(), triggered_(false) {}

void
DelayManager::addDelay(size_t id, const double* time, const double* value, double delayMax) {
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

std::vector<std::string>
DelayManager::dumpDelays() const {
  std::stringstream ss;
  std::vector<std::string> ret;

  for (boost::unordered_map<size_t, Delay>::const_iterator it = delays_.begin(); it != delays_.end(); ++it) {
    ss.str("");
    std::vector<std::pair<double, double> > values;
    it->second.points(values);

    ss << it->first << ":";
    ss << it->second.getDelayMax() << ":";
    for (std::vector<std::pair<double, double> >::const_iterator itvec = values.begin(); itvec != values.end(); ++itvec) {
      ss << itvec->first << "," << itvec->second << ";";
    }
    ret.push_back(ss.str());
  }

  return ret;
}

bool
DelayManager::loadDelays(const std::vector<std::string>& values) {
  for (std::vector<std::string>::const_iterator it = values.begin(); it != values.end(); ++it) {
    std::istringstream is(*it);
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
      } else if (*last_time > time) {
        // last_time >= time : error
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
      items.push_back(std::make_pair(time, value));

      is >> c;
      if (c != ';') {
        return false;
      }
    }

    Delay new_delay(items, delayMax);
    delays_.insert(std::make_pair(id, new_delay));
  }

  return true;
}

void
DelayManager::setGomc(state_g* const p_glocal, size_t offset, const double time, const std::string& /*name*/) {
  size_t index = offset;

  boost::unordered_map<size_t, Delay>::iterator it;
  triggered_ = false;
  for (it = delays_.begin(); it != delays_.end(); ++it, ++index) {
    double delayTime = it->second.getDelayMax();
    if (!(time < delayTime || doubleEquals(time, delayTime)) && !it->second.isTriggeredValue()) {
      p_glocal[index] = ROOT_UP;
      triggered_ = true;
    } else {
      p_glocal[index] = ROOT_DOWN;
    }
  }
}

void
DelayManager::evalMode(const double time, const std::string& name) {
  boost::unordered_map<size_t, Delay>::iterator it;
  for (it = delays_.begin(); it != delays_.end(); ++it) {
    double delayTime = it->second.getDelayMax();
    if (!(time < delayTime || doubleEquals(time, delayTime))) {
      it->second.trigger(time, delayTime, name);
    }
  }
}

void
DelayManager::notifyEndTrigger() {
  boost::unordered_map<size_t, Delay>::iterator it;
  for (it = delays_.begin(); it != delays_.end(); ++it) {
    if (it->second.isTriggered()) {
      it->second.resetTrigger();
    }
  }
}

}  // namespace DYN
