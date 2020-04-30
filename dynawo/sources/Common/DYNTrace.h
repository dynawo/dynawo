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
 * @file DYNTrace.h
 * @brief Trace system header
 *
 * The aim of this Trace system interface is to be easy to reimplement
 * in case of logging library change.
 *
 * @todo Add a way to create sinks/appender dynamically by loading a
 * configuration file.
 */
#ifndef COMMON_DYNTRACE_H_
#define COMMON_DYNTRACE_H_

#include <string>
#include <vector>

#include "DYNTraceStream.h"

namespace DYN {

/**
 * @brief Trace static class
 *
 * Trace static class is used to generate log files and configure them.
 * It is also the only interface for logging streams in Dynawo.@n
 * Traces generated before any call to @p init() static function are
 * ignored.
 */
class Trace {
 public:
  /**
   * @brief Trace appender class
   *
   * Trace appender class is used to configure an appender for trace
   * system. Appenders are created after trace configuration file parsing.
   * Default trace appender (before any configuration) puts all traces in
   * std::clog excepted errors that are put into std::cerr.
   */
  class TraceAppender {
   public:
    /**
     * @brief TraceAppender constructor
     */
    TraceAppender() { }

    /**
     * @brief TraceAppender destructor
     */
    ~TraceAppender() { }

    /**
     * @brief Tag attribute getter
     * @return Tag filtered by the appender
     */
    std::string getTag() {
      return tag_;
    }

    /**
     * @brief File path attribute getter
     * @return Output file path of the appender
     */
    std::string getFilePath() {
      return filePath_;
    }

    /**
     * @brief Level filter attribute getter
     * @return Minimum severity level exported by the appender
     */
    SeverityLevel getLvlFilter() {
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
    std::string getSeparator() const {
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
    std::string getTimeStampFormat() const {
      return timeStampFormat_;
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

   private:
    std::string tag_;  ///< Tag filtered by the appender
    std::string filePath_;  ///< Output file path of the appender
    SeverityLevel lvlFilter_;  ///< Minimum severity level exported by the appender
    bool showLevelTag_;  ///< @b true if the tag of the log should be printed
    std::string separator_;  ///< separator used between each log information date severity log
    bool showTimeStamp_;  ///< @b true if the timestamp of the log should be printed
    std::string timeStampFormat_;  ///< format of the timestamp information , "" if no time to print
  };

  /**
   * @brief Init function.
   *
   * Configure the appenders/sinks. Traces generated before any call to
   * this function are ignored.
   */
  static void init();

  /**
   * @brief Disable logging
   *
   * When no log file is needed, disable logging which is showed in console.
   */
  static void disableLogging();

  /**
   * @brief Add custom appenders to trace system
   * @param[in] appenders: Appenders to add
   */
  static void addAppenders(std::vector<TraceAppender> & appenders);

  /**
   * @brief Reset all custom appenders of trace system
   */
  static void resetCustomAppenders();

  /**
   * @brief Get SeverityLevel associated to a string
   *
   * @note Must be accorded to @p SeverityLevel enum in @p DYNTraceStream.h.
   * @throws General exception if the string has not been given any
   * equivalent SeverityLevel representation in the method.
   * @param level : String to convert.
   * @return Severity level representation of the string.
   */
  static SeverityLevel severityLevelFromString(std::string level);

  /**
   * @brief Get string representation of a severity level
   *
   * @note Must be accorded to @p SeverityLevel enum in @p DYNTraceStream.h.
   * @throws General exception if the SeverityLevel has not been given any
   * equivalent string representation in the method.
   * @param level : Severity level to convert.
   * @return String representation of the severity level.
   */
  static std::string stringFromSeverityLevel(SeverityLevel level);

  /**
   * @brief Get debug severity level stream.
   *
   * Get a debug severity level stream for logging.
   * @code Trace::debug("MyTag") << "Hello world!" << Trace::endline; @endcode
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @return A TraceStream that can be used for stream-like logging.
   */
  static TraceStream debug(const std::string& tag = "");

  /**
   * @brief Get info severity level stream.
   *
   * Get an info severity level stream for logging.
   * @code Trace::info("MyTag") << "Hello world!" << Trace::endline; @endcode
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @return A TraceStream that can be used for stream-like logging.
   */
  static TraceStream info(const std::string& tag = "");

  /**
   * @brief Get warning severity level stream.
   *
   * Get a warning severity level stream for logging.
   * @code Trace::warn("MyTag") << "Hello world!" << Trace::endline; @endcode
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @return A TraceStream that can be used for stream-like logging.
   */
  static TraceStream warn(const std::string& tag = "");

  /**
   * @brief Get error severity level stream.
   *
   * Get an error severity level stream for logging.
   * @code Trace::error("MyTag") << "Hello world!" << Trace::endline; @endcode
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @return A TraceStream that can be used for stream-like logging.
   */
  static TraceStream error(const std::string& tag = "");

  /**
   * @brief Get network identifier
   * @return network identifier
   */
  static std::string network();

  /**
   * @brief Get equations identifier
   * @return equations identifier
   */
  static std::string equations();

  /**
   * @brief Get variables identifier
   * @return variables identifier
   */
  static std::string variables();

  /**
   * @brief Get parameters identifier
   * @return parameters identifier
   */
  static std::string parameters();

  /**
   * @brief Print end of line in trace.
   *
   * @param os: Trace to add end of line.
   * @return The TraceStream with the end of line added.
   */
  static TraceStream& endline(TraceStream& os);  ///< End of line function for stream-like logging

  /**
   * @brief test if a log exists
   *
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @param slv : Severity level.
   * @return true if this log with this level exists
   */
  static bool logExists(const std::string& tag, SeverityLevel slv);

 private:
  /**
   * @brief Add a log to logging core.
   *
   * Add a message of given severity level with a given tag to the logging core.
   * If tag=="" , no tag is added the log.
   * The logging core get all the messages and each sink get info from the core
   * that a log has arrived and is responsible for filtering.
   * @param slv : Severity level of the log.
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @param message : Message to log.
   */
  static void log(SeverityLevel slv, const std::string& tag, const std::string& message);

  friend class TraceStream;  ///< Class TraceStream must get access to @p log() private function
};

}  // namespace DYN

#endif  // COMMON_DYNTRACE_H_
