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
 * @file  TLEventCmp.h
 *
 * @brief Dynawo timeline event comparator : header file
 *
 */
#ifndef API_TL_TLEVENTCMP_H_
#define API_TL_TLEVENTCMP_H_

#include <boost/shared_ptr.hpp>

namespace timeline {
class Event;

/**
 * @class EventCmp
 * @brief Event comparator class
 *
 * To store Event in a set, you should implement an operator to compare 2 events
 */
class EventCmp {
 public:
  /**
   * @brief operator to compare 2 events
   *
   * @param E1 event 1 to compare
   * @param E2 event 2 to compare
   * @return @b true if E1 < E2 @b false else
   *
   * @see implementation in TLEventCmp.cpp
   */
  bool operator()(const boost::shared_ptr<Event>& E1, const boost::shared_ptr<Event>& E2) const;
};

}  // namespace timeline

#endif  // API_TL_TLEVENTCMP_H_
