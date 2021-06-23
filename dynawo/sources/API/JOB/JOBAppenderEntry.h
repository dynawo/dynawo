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
 * @file JOBAppenderEntry.h
 * @brief Appender entries description : interface file
 *
 */

#ifndef API_JOB_JOBAPPENDERENTRY_H_
#define API_JOB_JOBAPPENDERENTRY_H_

#include <string>
#include <boost/shared_ptr.hpp>

namespace job {

/**
 * @class AppenderEntry
 * @brief Appender entries container class
 */
class AppenderEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~AppenderEntry() {}

  /**
   * @brief Tag attribute getter
   * @return Tag filtered by the appender
   */
  virtual std::string getTag() const = 0;

  /**
   * @brief File path attribute getter
   * @return Output file path of the appender
   */
  virtual std::string getFilePath() const = 0;

  /**
   * @brief Level filter attribute getter
   * @return Minimum severity level exported by the appender
   */
  virtual std::string getLvlFilter() const = 0;

  /**
   * @brief show level tag attribute getter
   * @return @b true if the level tag of the log should be printed
   */
  virtual bool getShowLevelTag() const = 0;

  /**
   * @brief separator between log information getter
   * @return the separator used to separate information inside the log
   */
  virtual std::string getSeparator() const = 0;

  /**
   * @brief get the time stamp format used inside the log
   * @return the time stamp format used
   */
  virtual std::string getTimeStampFormat() const = 0;

  /**
   * @brief Tag attribute setter
   * @param tag: Tag filtered by the appender
   */
  virtual void setTag(const std::string& tag) = 0;

  /**
   * @brief File path attribute setter
   * @param filePath: Output file path of the appender
   */
  virtual void setFilePath(const std::string& filePath) = 0;

  /**
   * @brief Level filter attribute setter
   * @param lvlFilter: Minimum severity level exported by the appender
   */
  virtual void setLvlFilter(const std::string& lvlFilter) = 0;

  /**
   * @brief indicates if the level tag associated to the log should be printed
   * @param showTag @b true if the level tag should be printed
   */
  virtual void setShowLevelTag(const bool showTag) = 0;

  /**
   * @brief set the separator used when printing log
   * @param separator separator to used
   */
  virtual void setSeparator(const std::string& separator) = 0;

  /**
   * @brief set the format of the time to print before the log
   * @param format format of the time
   */
  virtual void setTimeStampFormat(const std::string& format) = 0;

  /**
   * @brief Clone current appender entry
   * @returns copy of current appender entry
   */
  virtual boost::shared_ptr<AppenderEntry> clone() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBAPPENDERENTRY_H_
