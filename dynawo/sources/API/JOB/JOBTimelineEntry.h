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
 * @file JOBTimelineEntry.h
 * @brief Timeline entries description : interface file
 *
 */

#ifndef API_JOB_JOBTIMELINEENTRY_H_
#define API_JOB_JOBTIMELINEENTRY_H_

#include <string>

#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>

namespace job {

/**
 * @class TimelineEntry
 * @brief Timeline entries container class
 */
class TimelineEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~TimelineEntry() {}

  /**
   * @brief Output file attribute setter
   * @param outputFile: Output file for timeline
   */
  virtual void setOutputFile(const std::string & outputFile) = 0;

  /**
   * @brief Export Mode attribute setter
   * @param exportMode: Export mode for timeline
   */
  virtual void setExportMode(const std::string & exportMode) = 0;

  /**
   * @brief Output file attribute getter
   * @return Output file for timeline
   */
  virtual std::string getOutputFile() const = 0;

  /**
   * @brief Export mode attribute getter
   * @return Export mode for timeline
   */
  virtual std::string getExportMode() const = 0;

  /**
   * @brief maximum priority setter
   * @param maxPriority maximum priority allowed when exporting timeline
   */
  virtual void setMaxPriority(const boost::optional<int> maxPriority) = 0;

  /**
   * @brief maximum priority getter
   * @return maximum priority allowed when exporting timeline
   */
  virtual boost::optional<int> getMaxPriority() const = 0;

  /**
   * @brief Clone current entry
   * @returns copy of current entry
   */
  virtual boost::shared_ptr<TimelineEntry> clone() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBTIMELINEENTRY_H_
