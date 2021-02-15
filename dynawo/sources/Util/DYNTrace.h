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
#ifndef UTIL_DYNTRACE_H_
#define UTIL_DYNTRACE_H_

#include <string>
#include <vector>

#include "DYNTraceStream.h"
#include "DYNTraceAppender.h"

#include <boost/log/sinks.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/unordered_map.hpp>
#include <boost/log/attributes.hpp>
#include <boost/thread/mutex.hpp>

/**
 * @brief API to DYN::Trace::debug
 * @param tag : Tag added to the log, can be used as a filter in logging sinks.
 * @return A TraceStream that can be used for stream-like logging.
*/
extern "C" DYN::TraceStream TraceDebug(const std::string& tag = "");
/**
 * @brief API to DYN::Trace::info
 * @param tag : Tag added to the log, can be used as a filter in logging sinks.
 * @return A TraceStream that can be used for stream-like logging.
*/
extern "C" DYN::TraceStream TraceInfo(const std::string& tag = "");
/**
 * @brief API to DYN::Trace::error
 * @param tag : Tag added to the log, can be used as a filter in logging sinks.
 * @return A TraceStream that can be used for stream-like logging.
*/
extern "C" DYN::TraceStream TraceError(const std::string& tag = "");
/**
 * @brief API to DYN::Trace::warn
 * @param tag : Tag added to the log, can be used as a filter in logging sinks.
 * @return A TraceStream that can be used for stream-like logging.
*/
extern "C" DYN::TraceStream TraceWarn(const std::string& tag = "");
/**
 * @brief API to DYN::Trace::log
 * @param slv : Severity level of the log.
 * @param tag : Tag added to the log, can be used as a filter in logging sinks.
 * @param message : Message to log.
*/
extern "C" void TraceLog(DYN::SeverityLevel slv, const std::string& tag, const std::string& message);
/**
 * @brief API to DYN::Trace::logExists
 * @param tag : Tag added to the log, can be used as a filter in logging sinks.
 * @param slv : Severity level.
 * @return true if this log with this level exists
*/
extern "C" bool TraceLogExists(const std::string& tag, DYN::SeverityLevel slv);

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
   * @brief Determines if logging is enabled
   *
   * @returns whether the logging is currently enabled
   */
  static bool isLoggingEnabled();

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
   * @brief Get debug severity level stream.
   *
   * Get a debug severity level stream for logging.
   * @code Trace::debug("MyTag") << "Hello world!" << Trace::endline; @endcode
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @return A TraceStream that can be used for stream-like logging.
   */
  static TraceStream debug(const std::string& tag);

  /**
   * @brief Get info severity level stream.
   *
   * Get an info severity level stream for logging.
   * @code Trace::info("MyTag") << "Hello world!" << Trace::endline; @endcode
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @return A TraceStream that can be used for stream-like logging.
   */
  static TraceStream info(const std::string& tag);

  /**
    * @brief Get error severity level stream.
    *
    * Get an error severity level stream for logging.
    * @code Trace::error("MyTag") << "Hello world!" << Trace::endline; @endcode
    * @param tag : Tag added to the log, can be used as a filter in logging sinks.
    * @return A TraceStream that can be used for stream-like logging.
    */
  static TraceStream error(const std::string& tag);

  /**
   * @brief Get warning severity level stream.
   *
   * Get a warning severity level stream for logging.
   * @code Trace::warn("MyTag") << "Hello world!" << Trace::endline; @endcode
   * @param tag : Tag added to the log, can be used as a filter in logging sinks.
   * @return A TraceStream that can be used for stream-like logging.
   */
  static TraceStream warn(const std::string& tag);

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
   * @brief Destructor
   */
  ~Trace();

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
  friend TraceStream (::TraceDebug)(const std::string& tag);  ///< Method TraceDebug must get access to @p debug() private function
  friend TraceStream (::TraceInfo)(const std::string& tag);  ///< Method TraceInfo must get access to @p info() private function
  friend TraceStream (::TraceError)(const std::string& tag);  ///< Method TraceError must get access to @p error() private function
  friend TraceStream (::TraceWarn)(const std::string& tag);  ///< Method TraceWarn must get access to @p warn() private function
  friend void (::TraceLog)(DYN::SeverityLevel slv,
    const std::string& tag, const std::string& message);  ///< Method TraceLog must get access to @p log() private function
  friend bool (::TraceLogExists)(const std::string& tag, DYN::SeverityLevel slv);  ///< Method TraceLogExists must get access to @p logExists() private function

 private:
  boost::unordered_map<boost::log::attributes::current_thread_id::value_type, TraceSinks, Hasher> sinks_;  ///< thread specific sinks
  std::vector< boost::shared_ptr<Trace::TextSink> > originalSinks_;  ///< Original sinks
  boost::mutex mutex_;  ///< mutex to synchronize logs at init
};

}  // namespace DYN

#endif  // UTIL_DYNTRACE_H_
