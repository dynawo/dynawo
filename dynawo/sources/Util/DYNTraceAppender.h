//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file DYNTraceAppender.h
 * @brief Trace system appender
 *
 * Trace appender class is used to configure an appender for trace
 * system. Appenders are created after trace configuration file parsing.
 * Default trace appender (before any configuration) puts all traces in
 * std::clog excepted errors that are put into std::cerr.
 *
 */
#ifndef UTIL_DYNTRACEAPPENDER_H_
#define UTIL_DYNTRACEAPPENDER_H_

#include <string>
#include "DYNTraceStream.h"

namespace DYN {
/**
 * @brief Trace appender class
 *
 */
class TraceAppender {
 public:
  /**
   * @brief TraceAppender constructor
   */
  TraceAppender();

  /**
   * @brief TraceAppender destructor
   */
  ~TraceAppender();

  /**
   * @brief Tag attribute getter
   * @return Tag filtered by the appender
   */
  const std::string& getTag() const {
    return tag_;
  }

  /**
   * @brief File path attribute getter
   * @return Output file path of the appender
   */
  const std::string& getFilePath() const {
    return filePath_;
  }

  /**
   * @brief Level filter attribute getter
   * @return Minimum severity level exported by the appender
   */
  SeverityLevel getLvlFilter() const {
    return lvlFilter_;
  }

  /**
   * @brief show level tag attribute getter
   * @return @b true if the level tag of the log should be printed
   */
  bool getShowLevelTag() const {
    return showLevelTag_;
  }

  /**
   * @brief separator between log information getter
   * @return the separator used to separate information inside the log
   */
  const std::string& getSeparator() const {
    return separator_;
  }

  /**
   * @brief get show time stamp
   * @return the time stamp format used
   */
  bool getShowTimeStamp() const {
    return showTimeStamp_;
  }

  /**
   * @brief get the time stamp format used inside the log
   * @return the time stamp format used
   */
  const std::string& getTimeStampFormat() const {
    return timeStampFormat_;
  }

  /**
   * @brief Determines if log is appended to existing file
   * @returns whether the log must appended to existing log file
   */
  bool doesAppend() const {
    return append_;
  }

  /**
   * @brief Determines if log should be kept when reseting
   * @returns whether the log should be kept when reseting
   */
  bool isPersistant() const {
    return persistant_;
  }

  /**
   * @brief Tag attribute setter
   * @param tag: Tag filtered by the appender
   */
  void setTag(std::string tag) {
    tag_ = tag;
  }

  /**
   * @brief File path attribute setter
   * @param filePath: Output file path of the appender
   */
  void setFilePath(std::string filePath) {
    filePath_ = filePath;
  }

  /**
   * @brief Level filter attribute setter
   * @param lvlFilter: Minimum severity level exported by the appender
   */
  void setLvlFilter(SeverityLevel lvlFilter) {
    lvlFilter_ = lvlFilter;
  }

  /**
   * @brief indicates if the level tag associated to the log should be printed
   * @param showTag @b true if the level tag should be printed
   */
  void setShowLevelTag(const bool showTag) {
    showLevelTag_ = showTag;
  }

  /**
   * @brief set the separator used when printing log
   * @param separator separator to used
   */
  void setSeparator(const std::string& separator) {
    separator_ = separator;
  }

  /**
   * @brief indicates if the log time stamp should be displayed
   * @param showTimeStamp @b true if the time stamp should be printed
   */
  void setShowTimeStamp(const bool showTimeStamp) {
    showTimeStamp_ = showTimeStamp;
  }

  /**
   * @brief set the format of the time to print before the log
   * @param format format of the time
   */
  void setTimeStampFormat(const std::string& format) {
    timeStampFormat_ = format;
  }

  /**
   * @brief Set the append attribute
   *
   * @param append determines if the log must appended to existing file
   */
  void setAppend(bool append) {
    append_ = append;
  }

  /**
   * @brief Set the persistant attribute
   *
   * @param persistant determines if the log must be kept when reseting
   */
  void setPersistant(bool persistant) {
    persistant_ = persistant;
  }

 private:
  std::string tag_;  ///< Tag filtered by the appender
  std::string filePath_;  ///< Output file path of the appender
  SeverityLevel lvlFilter_;  ///< Minimum severity level exported by the appender
  bool showLevelTag_;  ///< @b true if the tag of the log should be printed
  std::string separator_;  ///< separator used between each log information date severity log
  bool showTimeStamp_;  ///< @b true if the timestamp of the log should be printed
  std::string timeStampFormat_;  ///< format of the timestamp information , "" if no time to print
  bool append_;  ///< Append to existing file instead of erasing
  bool persistant_;  ///< Do not remove this appender when reseting
};

}  // namespace DYN

#endif  // UTIL_DYNTRACEAPPENDER_H_
