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
 * @file DYNTraceStream.h
 * @brief Trace stream header
 *
 * Trace streams are used by @p Trace static class for
 * stream-like logging
 */

#ifndef COMMON_DYNTRACESTREAM_H_
#define COMMON_DYNTRACESTREAM_H_

#include <boost/shared_ptr.hpp>
#include <sstream>
#include <string>

#ifdef _MSC_VER
#undef ERROR  // avoid conflict with macro ERROR defined somewhere on Windows !
#endif

namespace DYN {

/**
 * @brief Severity level used for traces filtering
 *
 * Severity levels used for traces filtering. Must be ordered by severity.
 * @note Must be accorded to @p severityLevelFromString and
 * @p stringFromSeverityLevel functions in @p DYNTrace.cpp.
 */
enum SeverityLevel {
  DEBUG,  ///< Debug severity level
  INFO,   ///< Information severity level
  WARN,   ///< Warning severity level
  ERROR   ///< @verbatim Error severity level @endverbatim
};

/**
 * @brief Trace stream class
 *
 * Trace stream class defines objects for stream-like logging.
 * Allows severity levels and a tag for logs filtering.
 */
class TraceStream {
 public:
  /**
   * @brief Default constructor
   *
   * Creates a new TraceStream with empty buffer, severity level @p INFO and
   * no tag associated.
   */
  TraceStream();

  /// @brief Destructor
  ~TraceStream() = default;

  /**
   * @brief Constructor
   *
   * Creates a new TraceStream with empty buffer and given severity level and tag.
   * Default tag is "" which means no tag.
   * @param slv : Severity level of TraceStream message
   * @param tag : Tag to add to the message
   */
  explicit TraceStream(SeverityLevel slv, const std::string& tag = "");

  /**
   * @brief Copy constructor
   *
   * Creates a new TraceStream with empty buffer and same severity level and tag as
   * TraceStream object given.
   * @param ts : TraceStream to copy
   *
   * @note Copying buffer content seemed to be a bad behaviour. It could have some
   * side effects that do not appear by creating an empty buffer.
   */
  TraceStream(const TraceStream& ts);

  /**
   * @brief Copy assignemnt operator
   *
   * Creates a new TraceStream with empty buffer and same severity level and tag as
   * TraceStream object given.
   * @param ts : TraceStream to copy
   * @return Created TraceStream
   *
   * @note Copying buffer content seemed to be a bad behaviour. It could have some
   * side effects that do not appear by creating an empty buffer.
   */
  TraceStream& operator=(const TraceStream& ts);

  /**
   * @brief Operator<< overload for C strings
   *
   * Not treated by template operator<< overload
   * @param t : C string to add to TraceStream instance
   * @return Reference to TraceStream instance
   */
  TraceStream& operator<<(const char* t);

  /**
   * @brief Operator<< overload for stream-like logging
   *
   * Template operator<< overload to allow stream-like logging using
   * @p TraceStream objects. Implemented in header file to avoid explicit
   * instanciation.
   * @param t : Object to add at the end of the TraceStream instance
   * @return Reference to TraceStream instance
   *
   * @note It is possible to modify this choice of implicit instanciation if
   * we need more control about what is allowed in @p TraceStream's buffer .
   */
  template<typename T>
  TraceStream& operator<<(const T& t) {
    if (buffer_) {
      (*buffer_) << t;
    }
    return *this;
  }

  /**
   * @brief Flushes the buffer content to the logging core
   *
   * Add a log with TraceStream's severity level and tag to the logging core.
   * The buffer content is used as a message and is then emptied.
   */
  void flush();

  /**
   * @brief TraceStream function pointer
   *
   * TraceStream function pointer is used to define end of line
   * operator that automatically flushes the content of the buffer
   * to the logging core.
   */
  typedef TraceStream& (*tspf)(TraceStream&);

  /**
   * @brief Operator<< overload for TraceStream function pointer
   *
   * Calls function pointer method on the TraceStream instance
   * when a function pointer is passed on the stream.
   * @return Reference to TraceStream instance
   */
  TraceStream& operator<<(tspf);

 private:
  boost::shared_ptr<std::stringstream> buffer_;  ///< Internal buffer owning trace message.
  SeverityLevel slv_;                            ///< Severity level of the message.
  std::string tag_;                              ///< Tag added to the message. "" means no tag.
};

/**
 * @brief Operator<< overload for end of line function pointer
 *
 * Flushes the content of the buffer to the logging core when
 * end of line function pointer is passed on the stream.
 * @param os : Reference to a TraceStream instance to flush
 * @return Reference to given TraceStream instance
 */
TraceStream& eol(TraceStream& os);

}  // namespace DYN

#endif  // COMMON_DYNTRACESTREAM_H_
