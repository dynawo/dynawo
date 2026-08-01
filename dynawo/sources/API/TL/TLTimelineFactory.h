//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  TLTimelineFactory.h
 *
 * @brief Dynawo timeline factory : header file
 *
 */
#ifndef API_TL_TLTIMELINEFACTORY_H_
#define API_TL_TLTIMELINEFACTORY_H_

#include "TLTimeline.h"


namespace timeline {

/**
 * @class TimelineFactory
 * @brief Timeline factory class
 *
 * TimelineFactory encapsulate methods for creating new
 * @p Timeline objects.
 */
class TimelineFactory {
 public:
  /**
   * @brief Create new Timeline instance
   *
   * @param id id of the new instance
   *
   * @return unique pointer to a new empty @p Timeline
   */
  static std::unique_ptr<Timeline> newInstance(const std::string& id);
};
}  // namespace timeline

#endif  // API_TL_TLTIMELINEFACTORY_H_
