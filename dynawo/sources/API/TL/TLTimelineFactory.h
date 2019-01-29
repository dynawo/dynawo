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
 * @file  TLTimelineFactory.h
 *
 * @brief Dynawo timeline factory : header file
 *
 */
#ifndef API_TL_TLTIMELINEFACTORY_H_
#define API_TL_TLTIMELINEFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "TLExport.h"

namespace timeline {
class Timeline;

/**
 * @class TimelineFactory
 * @brief Timeline factory class
 *
 * TimelineFactory encapsulate methods for creating new
 * @p Timeline objects.
 */
class __DYNAWO_TL_EXPORT TimelineFactory {
 public:
  /**
   * @brief Create new Timeline instance
   *
   * @param id id of the new instance
   *
   * @return shared pointer to a new empty @p Timeline
   */
  static boost::shared_ptr<Timeline> newInstance(const std::string& id);

  /**
   * @brief Create new Timeline instance as a clone of given instance
   *
   * @param[in] original Timeline to be cloned
   *
   * @return Shared pointer to a new @p Timeline copied from original
   */
  static boost::shared_ptr<Timeline> copyInstance(boost::shared_ptr<Timeline> original);

  /**
   * @brief Create new Timeline instance as a clone of given instance
   *
   * @param[in] original Timeline to be cloned
   *
   * @return Shared pointer to a new @p Timeline copied from original
   */
  static boost::shared_ptr<Timeline> copyInstance(const Timeline& original);
};
}  // namespace timeline

#endif  // API_TL_TLTIMELINEFACTORY_H_
