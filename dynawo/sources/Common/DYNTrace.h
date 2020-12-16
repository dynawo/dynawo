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

#include <boost/log/sinks.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/unordered_map.hpp>
#include <boost/log/attributes.hpp>
#include <boost/thread/mutex.hpp>

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
  typedef boost::log::sinks::synchronous_sink< boost::log::sinks::text_file_backend > FileSink;  ///< File sink for log
  typedef boost::log::sinks::synchronous_sink< boost::log::sinks::text_ostream_backend > TextSink;  ///< Text sink for log

  /**
   * @brief Stucture defining traces for a specific thread
   */
  struct TraceSinks {
    std::vector< boost::shared_ptr<FileSink> > sinks;  ///<  vector of file sink
    std::vector< boost::shared_ptr<FileSink> > persistantSinks;  ///<  vector of persistant file sink
  };

  /**
   * @brief Hash for current_thread_id::value_type
   *
   * This structure is required in order current_thread_id::value_type to be used as a key in an unordered_map
   */
  struct Hasher {
    /**
     * @brief Calling operator
     *
     * @param id the value to hash
     * @returns the hash of the id
     */
    std::size_t operator()(const boost::log::attributes::current_thread_id::value_type& id) const {
      // the thread id is unique in the same process
      return static_cast<std::size_t>(id.native_id());
    }
  };


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
    TraceAppender():
      tag_(),
      filePath_(),
      lvlFilter_(INFO),
      showLevelTag_(false),
      separator_(),
      showTimeStamp_(false),
      timeStampFormat_(),
      append_(false),
      persistant_(false) { }

    /**
     * @brief TraceAppender destructor
     */
    ~TraceAppender() { }

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
  static void addAppenders(const std::vector<TraceAppender>& appenders);

  /**
   * @brief Reset non-persistant custom appenders of trace system
   */
  static void resetCustomAppenders();

  /**
   * @brief Reset persistant custom appenders of trace system
   */
  static void resetPersistantCustomAppenders();

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
   * @brief Get compile identifier
   * @return compile identifier
   */
  static std::string compile();

  /**
   * @brief Get modeler identifier
   * @return modeler identifier
   */
  static std::string modeler();

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
   * This tests only the file logs
   *
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @param slv : Severity level.
   * @return true if this log with this level exists
   */
  static bool logExists(const std::string& tag, SeverityLevel slv);

  /**
   * @brief Test if a standard log exists
   *
   * This test the level of the standard output log
   *
   * @param slv Severity level
   * @returns whether the standard log accepts the log level
   */
  static bool standardLogExists(SeverityLevel slv) {
    return slv >= defaultLevel_;
  }

 private:
  static const SeverityLevel defaultLevel_;  ///< Default log level for standard output

 private:
 /**
  * @brief Retrieves static instance
  *
  * @returns static instance
  */
  static Trace& instance();

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

  /**
   * @brief Constructor
   */
  Trace();

  /**
   * @brief Init function.
   *
   * Implementation of static function
   */
  void init_();

    /**
   * @brief Add custom appenders to trace system
   *
   * Implementation of static function
   *
   * @param[in] appenders: Appenders to add
   */
  void addAppenders_(const std::vector<TraceAppender>& appenders);

  /**
   * @brief Reset non-persistant custom appenders of trace system
   *
   * Implementation of static function
   */
  void resetCustomAppenders_();

  /**
   * @brief Reset persistant custom appenders of trace system
   *
   * Implementation of static function
   */
  void resetPersistantCustomAppenders_();

  /**
   * @brief test if a log exists
   *
   * Implementation of static function
   *
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @param slv : Severity level.
   * @return true if this log with this level exists
   */
  bool logExists_(const std::string& tag, SeverityLevel slv);

  /**
   * @brief Add a log to logging core.
   *
   * Implementation of static function
   *
   * @param slv : Severity level of the log.
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @param message : Message to log.
   */
  void log_(SeverityLevel slv, const std::string& tag, const std::string& message);

  friend class TraceStream;  ///< Class TraceStream must get access to @p log() private function

 private:
  boost::unordered_map<boost::log::attributes::current_thread_id::value_type, TraceSinks, Hasher> sinks_;  ///< thread specific sinks
  std::vector< boost::shared_ptr<Trace::TextSink> > originalSinks_;  ///< Original sinks
  boost::mutex mutex_;  ///< mutex to synchronize logs at init
};

}  // namespace DYN

#endif  // COMMON_DYNTRACE_H_
