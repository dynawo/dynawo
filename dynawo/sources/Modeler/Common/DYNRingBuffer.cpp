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
 * @file DYNRingBuffer.cpp
 *
 * @brief Ring buffer implementation
 */
#include "DYNRingBuffer.h"
#include "DYNCommon.h"
#include "DYNError.h"
#include "DYNMacrosMessage.h"

#include <algorithm>
#include <boost/bind.hpp>

namespace DYN {
RingBuffer::RingBuffer(double maxDelay) : queue_(), maxDelay_(maxDelay) {}

void
RingBuffer::add(double time, double value) {
  if (queue_.size() > 0 && doubleEquals(queue_.back().first, time)) {
    // ignore if we add multiple time the same value
    return;
  }

#if _DEBUG_
  if (queue_.size() > 0) {
    assert(time > queue_.back().first);
  }
#endif

  queue_.push_back(std::make_pair(time, value));

  removeUseless();
}

void
RingBuffer::removeUseless() {
  double last_time = queue_.back().first;
  // By construction, the queue is sorted by "time" value so if the criteria is no longer passed,
  // it will never be passed again
  std::deque<std::pair<double, double> >::iterator found =
      std::lower_bound(queue_.begin(), queue_.end(), last_time - maxDelay_, boost::bind<bool>(&RingBuffer::comparePairTime, this, _1, _2));

  if (found != queue_.begin() && queue_.size() > 0) {
    // we keep the first point which doesn't respect to enable interpolation
    --found;
  }

  queue_.erase(queue_.begin(), found);
}

double
RingBuffer::get(double time, double delay) const {
  double time_value = time - delay;

  if (delay > maxDelay_ || delay < 0.0) {
    throw DYNError(DYN::Error::SIMULATION, IncorrectDelay, delay, time, maxDelay_);
  }

  std::deque<std::pair<double, double> >::const_iterator found =
      std::lower_bound(queue_.begin(), queue_.end(), time_value, boost::bind<bool>(&RingBuffer::comparePairTime, this, _1, _2));
  if (found == queue_.end()) {
    // it means that the required time is greater than the last value in the queue
    // => we perform linear interpolation using the last two most recent if we can
    if (queue_.size() > 1) {
      std::deque<std::pair<double, double> >::const_reverse_iterator it = queue_.rbegin();
      ++it;
      return interpol(*(queue_.rbegin()), *it, time_value);
    } else {
      return queue_.back().second;
    }
  } else if (doubleEquals(found->first, time_value)) {
    return found->second;
  } else if (found == queue_.begin()) {
    // case first element: it would mean that delay is greater than max delay
    // shouldn't happen by construction with function add
    throw DYNError(DYN::Error::SIMULATION, IncorrectDelay, delay, time, maxDelay_);
  } else {
    const std::pair<double, double>& previous = *(found - 1);
    // linear interpolation
    return interpol(previous, *found, time_value);
  }
}

std::pair<double, double> RingBuffer::end() const {
  return queue_.back();
}

bool
RingBuffer::comparePairTime(const std::pair<double, double>& pair, const double& time_value) const {
  // timed value cannot be too close to each other as these times are sent by the solvers
  return pair.first < time_value;
}

double
RingBuffer::interpol(const std::pair<double, double>& p1, const std::pair<double, double>& p2, double time) {
  double a = (p2.second - p1.second) / (p2.first - p1.first);
  double b = (p2.first * p1.second - p1.first * p2.second) / (p2.first - p1.first);

  return a * time + b;
}

void
RingBuffer::points(std::vector<std::pair<double, double> >& vec) const {
  for (std::deque<std::pair<double, double> >::const_iterator it = queue_.begin(); it != queue_.end(); ++it) {
    vec.push_back(*it);
  }
}

}  // namespace DYN
