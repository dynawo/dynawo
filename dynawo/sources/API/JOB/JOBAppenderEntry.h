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
 * @file JOBAppenderEntry.h
 * @brief Appender entries description : interface file
 *
 */

#ifndef API_JOB_JOBAPPENDERENTRY_H_
#define API_JOB_JOBAPPENDERENTRY_H_

#include <string>

namespace job {

/**
 * @class AppenderEntry
 * @brief Appender entries container class
 */
class AppenderEntry {
 public:
  /**
   * @brief AppenderEntry constructor
   */
  AppenderEntry();

  /**
   * @brief Tag attribute getter
   * @return Tag filtered by the appender
   */
  const std::string& getTag() const;

  /**
   * @brief File path attribute getter
   * @return Output file path of the appender
   */
  const std::string& getFilePath() const;

  /**
   * @brief Level filter attribute getter
   * @return Minimum severity level exported by the appender
   */
  const std::string& getLvlFilter() const;

  /**
   * @brief show level tag attribute getter
   * @return @b true if the level tag of the log should be printed
   */
  bool getShowLevelTag() const;

  /**
   * @brief separator between log information getter
   * @return the separator used to separate information inside the log
   */
  const std::string& getSeparator() const;

  /**
   * @brief get the time stamp format used inside the log
   * @return the time stamp format used
   */
  const std::string& getTimeStampFormat() const;

  /**
   * @brief Tag attribute setter
   * @param tag Tag filtered by the appender
   */
  void setTag(const std::string& tag);

  /**
   * @brief File path attribute setter
   * @param filePath Output file path of the appender
   */
  void setFilePath(const std::string& filePath);

  /**
   * @brief Level filter attribute setter
   * @param lvlFilter Minimum severity level exported by the appender
   */
  void setLvlFilter(const std::string& lvlFilter);

  /**
   * @brief indicates if the level tag associated to the log should be printed
   * @param showTag @b true if the level tag should be printed
   */
  void setShowLevelTag(const bool showTag);

  /**
   * @brief set the separator used when printing log
   * @param separator separator to used
   */
  void setSeparator(const std::string& separator);

  /**
   * @brief set the format of the time to print before the log
   * @param format format of the time
   */
  void setTimeStampFormat(const std::string& format);

 private:
  std::string tag_;              ///< Tag filtered by the appender
  std::string filePath_;         ///< Output file path of the appender
  std::string lvlFilter_;        ///< Minimum severity level exported by the appender
  bool showLevelTag_;            ///< @b true if the tag of the log should be printed
  std::string separator_;        ///< separator used between each log information
  std::string timeStampFormat_;  ///< format of the timestamp information , "" if no time to print
};

}  // namespace job

#endif  // API_JOB_JOBAPPENDERENTRY_H_
