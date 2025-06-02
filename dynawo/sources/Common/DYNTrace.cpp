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
 * @file DYNTrace.cpp
 * @brief Trace system implementation
 *
 * Implementation of Trace system for Dynawo based on Boost.Log.
 * For more details about Boost.Log, see library
 * <A HREF="http://boost-log.sourceforge.net/libs/log/doc/html/index.html"> documentation</A>
 *
 */
#include <fstream>
#include <ostream>
#include <iomanip>

#include <boost/version.hpp>
#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/attributes.hpp>
#include <boost/log/attributes/attribute_value_set.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/sources/severity_logger.hpp>
#include <boost/log/sources/record_ostream.hpp>
#include <boost/log/sinks/sync_frontend.hpp>
#include <boost/log/sinks/text_ostream_backend.hpp>
#include <boost/log/support/date_time.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/sinks.hpp>

#if BOOST_VERSION / 100 % 1000 < 56
#include <boost/utility/empty_deleter.hpp>
#else
#include <boost/core/null_deleter.hpp>
#endif

#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "config.h"
#include "gitversion.h"

using std::string;
using std::vector;

namespace logging = boost::log;
namespace expr = boost::log::expressions;
namespace src = boost::log::sources;
namespace sinks = boost::log::sinks;
namespace attrs = boost::log::attributes;
namespace keywords = boost::log::keywords;

namespace DYN {

#if _DEBUG_
const SeverityLevel Trace::defaultLevel_ = DEBUG;
#else
const SeverityLevel Trace::defaultLevel_ = INFO;
#endif

/**
 * @brief Operator<< overload for severity level on ostreams
 *
 * The operator puts a human-friendly representation of the severity level to the stream.
 * Used in Boost.Log macros for severity logging.
 * @note Must be accorded to @p SeverityLevel enum in @p DYNTraceStream.h.
 * @see SeverityLevel
 * @todo Change this function to avoid duplication of the severity level into a pair
 * enum/vector. For the moment, solution based on Boost.Log examples.
 */
static std::ostream& operator<<(std::ostream& strm, const SeverityLevel level) {
  strm << Trace::stringFromSeverityLevel(level);
  return strm;
}

#pragma GCC diagnostic ignored "-Wmissing-field-initializers"
BOOST_LOG_ATTRIBUTE_KEYWORD(severity, "Severity", SeverityLevel)
BOOST_LOG_ATTRIBUTE_KEYWORD(tag_attr, "Tag", std::string)
BOOST_LOG_ATTRIBUTE_KEYWORD(thread_attr, "Thread", logging::attributes::current_thread_id::value_type)
#pragma GCC diagnostic error "-Wmissing-field-initializers"

TraceStream& Trace::endline(TraceStream& os) {
  return eol(os);
}

Trace& Trace::instance() {
  static Trace instance;
  return instance;
}

void Trace::init() {
  instance().init_();
}

void Trace::init_() {
  // Setup the formatters for the sinks
  const logging::formatter onlyMsg = expr::stream << expr::smessage;

  // Construct the sink
  const boost::shared_ptr< TextSink > sink = boost::make_shared< TextSink >();
  sink->set_formatter(onlyMsg);

  // Add a stream to write log to
#if BOOST_VERSION / 100 % 1000 < 56
  boost::shared_ptr<std::ostream > stream(&std::clog, boost::empty_deleter());
#else
  boost::shared_ptr<std::ostream > stream(&std::clog, boost::null_deleter());
#endif
  sink->locked_backend()->add_stream(stream);

  // Register the sink in the logging core
  logging::core::get()->add_sink(sink);
  logging::core::get()->set_logging_enabled(true);
  originalSinks_.push_back(sink);

  logging::add_common_attributes();
}

void Trace::disableLogging() {
  logging::core::get()->set_logging_enabled(false);
}

void Trace::enableLogging() {
  logging::core::get()->set_logging_enabled(true);
}

bool Trace::isLoggingEnabled() {
  return logging::core::get()->get_logging_enabled();
}

void Trace::clearAndAddAppenders(const std::vector<TraceAppender>& appenders) {
  instance().clearAndAddAppenders_(appenders);
}

void Trace::clearAndAddAppenders_(const std::vector<TraceAppender>& appenders) {
  // remove old appenders (console_log)
  Trace::resetCustomAppenders();

  traceAppenders_.clear();  // clear previous appenders for a new job
  for (const TraceAppender& appender : appenders) {
    TagAndSeverityLevel tagAndSeverityLevel = std::make_pair(appender.getTag(), appender.getLvlFilter());
    traceAppenders_.insert(std::make_pair(tagAndSeverityLevel, appender));
  }

  const bool eraseSinks = true;
  configureSink(appenders, eraseSinks);
  logging::add_common_attributes();
}

void Trace::configureSink(const std::vector<TraceAppender>& appenders, bool eraseSinks) {
  logging::attributes::current_thread_id::value_type currentId =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();

  TraceSinks& traceSink = sinks_[currentId];
  if (eraseSinks) {
    traceSink.sinks.clear();  // ensure all non-persistent sink are destroyed
  }

  // Add appender
  for (const auto& appender : appenders) {
    boost::shared_ptr<FileSink> sink(new FileSink(
      keywords::file_name = appender.getFilePath(),
      keywords::open_mode = std::ios_base::out));

    // build format for each appenders depending on its attributes
    const string& appenderTag = appender.getTag();
    const SeverityLevel severityLevel = appender.getLvlFilter();
    const string& separator = appender.getSeparator();
    const bool showTag = appender.getShowLevelTag();
    const bool showTimeStamp = appender.getShowTimeStamp();
    const string& dateFormat = appender.getTimeStampFormat();

    logging::formatter fmt;

    if (showTimeStamp && showTag) {
      fmt = expr::stream << expr::format_date_time< boost::posix_time::ptime >("TimeStamp", dateFormat) << separator << severity << separator << expr::message;
    } else if (showTimeStamp) {  // && ! showTag
      fmt = expr::stream << expr::format_date_time< boost::posix_time::ptime >("TimeStamp", dateFormat) << separator << expr::message;
    } else if (showTag) {  // && ! showTimeStamp
      fmt = expr::stream << severity << separator << expr::message;
    } else {  // ! showTimeStamp && ! showTag
      fmt = expr::stream << expr::message;
    }

    sink->set_formatter(fmt);

    if (appenderTag.empty()) {
      sink->set_filter(severity >= severityLevel && !expr::has_attr(tag_attr) && thread_attr == currentId);
    } else {
      sink->set_filter(severity >= severityLevel && tag_attr == appenderTag && thread_attr == currentId);
    }
    logging::core::get()->add_sink(sink);
    TagAndSeverityLevel tagAndSeverityLevel = std::make_pair(appenderTag, severityLevel);
    if (appender.isPersistent()) {
      traceSink.persistentSinks.insert({tagAndSeverityLevel, sink});
    } else {
      traceSink.sinks.insert({tagAndSeverityLevel, sink});
    }
  }

  {
    boost::lock_guard<boost::mutex> lock(mutex_);

    if (sinks_.find(currentId) != sinks_.end()) {
      sinks_.at(currentId) = traceSink;
    } else {
      sinks_.insert(std::make_pair(currentId, traceSink));
    }
  }
}

void Trace::resetPersistentCustomAppenders() {
  instance().resetPersistentCustomAppenders_();
}

void Trace::resetPersistentCustomAppenders_() {
  boost::lock_guard<boost::mutex> lock(mutex_);

  const logging::attributes::current_thread_id::value_type currentId =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();
  if (sinks_.find(currentId) == sinks_.end()) {
    return;
  }
  TraceSinks& traceSink = sinks_.at(currentId);
  for (const auto& persistentSinkPair : traceSink.persistentSinks) {
    logging::core::get()->remove_sink(persistentSinkPair.second);
  }
  traceSink.persistentSinks.clear();
}


void Trace::resetPersistentCustomAppender(const std::string& tag, const SeverityLevel slv) {
  instance().resetPersistentCustomAppender_(tag, slv);
}

void Trace::resetPersistentCustomAppender_(const std::string& tag, const SeverityLevel slv) {
  boost::lock_guard<boost::mutex> lock(mutex_);

  logging::attributes::current_thread_id::value_type currentId =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();
  if (sinks_.find(currentId) == sinks_.end()) {
    return;
  }

  boost::log::attribute_value_set set;
  set.insert("Severity",  attrs::make_attribute_value(slv));
  if (!tag.empty())
    set.insert("Tag",  attrs::make_attribute_value(tag));
  set.insert("Thread", attrs::make_attribute_value(currentId));

  TraceSinks& traceSink = sinks_.at(currentId);
  for (const auto& persistentSinkPair : traceSink.persistentSinks) {
    if (persistentSinkPair.second->will_consume(set))
      logging::core::get()->remove_sink(persistentSinkPair.second);
  }
  TagAndSeverityLevel tagAndSeverityLevel = std::make_pair(tag, slv);
  traceSink.persistentSinks.erase(tagAndSeverityLevel);
}

void Trace::resetCustomAppenders() {
  instance().resetCustomAppenders_();
}

void Trace::resetCustomAppenders_() {
  boost::lock_guard<boost::mutex> lock(mutex_);

  for (const auto& originalSink : originalSinks_)
    logging::core::get()->remove_sink(originalSink);
  originalSinks_.clear();

  const logging::attributes::current_thread_id::value_type currentId =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();
  if (sinks_.find(currentId) == sinks_.end()) {
    return;
  }
  TraceSinks& traceSink = sinks_.at(currentId);
  for (const auto& sinkPair : traceSink.sinks)
    logging::core::get()->remove_sink(sinkPair.second);
  traceSink.sinks.clear();
}

void Trace::resetCustomAppender(const std::string& tag, SeverityLevel slv) {
  instance().resetCustomAppender_(tag, slv);
}

void Trace::resetCustomAppender_(const std::string& tag, SeverityLevel slv) {
  boost::lock_guard<boost::mutex> lock(mutex_);

  logging::attributes::current_thread_id::value_type currentId =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();
  if (sinks_.find(currentId) == sinks_.end()) {
    return;
  }

  boost::log::attribute_value_set set;
  set.insert("Severity",  attrs::make_attribute_value(slv));
  if (tag != "")
    set.insert("Tag",  attrs::make_attribute_value(tag));
  set.insert("Thread", attrs::make_attribute_value(currentId));

  TraceSinks& traceSink = sinks_.at(currentId);
  for (const auto& sinkPair : traceSink.sinks) {
    if (sinkPair.second->will_consume(set))
      logging::core::get()->remove_sink(sinkPair.second);
  }
  TagAndSeverityLevel tagAndSeverityLevel = std::make_pair(tag, slv);
  traceSink.sinks.erase(tagAndSeverityLevel);
}

TraceStream
Trace::debug(const std::string& tag) {
  return TraceStream(DEBUG, tag);
}

TraceStream
Trace::info(const std::string& tag) {
  return TraceStream(INFO, tag);
}

TraceStream
Trace::warn(const std::string& tag) {
  return TraceStream(WARN, tag);
}

TraceStream
Trace::error(const std::string& tag) {
  return TraceStream(ERROR, tag);
}

std::string
Trace::network() {
  return "NETWORK";
}

std::string
Trace::variables() {
  return "VARIABLES";
}

std::string
Trace::equations() {
  return "EQUATIONS";
}

std::string
Trace::parameters() {
  return "PARAMETERS";
}

std::string
Trace::compile() {
  return "COMPILE";
}

std::string
Trace::modeler() {
  return "MODELER";
}

std::string
Trace::solver() {
  return "SOLVER";
}

void Trace::log(SeverityLevel slv, const std::string& tag, const std::string& message) {
  instance().log_(slv, tag, message);
}

void Trace::log_(SeverityLevel slv, const std::string& tag, const std::string& message) {
  src::severity_logger< SeverityLevel > slg;
  logging::attributes::current_thread_id current;

  if (!tag.empty())
    slg.add_attribute("Tag", attrs::constant< std::string >(tag));

  slg.add_attribute("Thread", current);

  BOOST_LOG_SEV(slg, slv) << message;
}

bool
Trace::logExists(const std::string& tag, const SeverityLevel slv) {
  return instance().logExists_(tag, slv);
}

bool
Trace::logExists_(const std::string& tag, const SeverityLevel slv) {
  boost::log::attribute_value_set set;
  logging::attributes::current_thread_id::value_type current_id =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();
  set.insert("Severity",  attrs::make_attribute_value(slv));
  if (!tag.empty())
    set.insert("Tag",  attrs::make_attribute_value(tag));
  set.insert("Thread", attrs::make_attribute_value(current_id));
  if (sinks_.find(current_id) == sinks_.end()) {
    return false;
  }
  const TraceSinks& traceSinks = sinks_.at(current_id);
  for (const auto& sinkPair : traceSinks.sinks) {
    if (sinkPair.second->will_consume(set))
      return true;
  }
  for (const auto& persistentSinkPair : traceSinks.persistentSinks) {
    if (persistentSinkPair.second->will_consume(set))
      return true;
  }
  return false;
}

void
Trace::printDynawoLogHeader(const std::string& tag) {
  info(tag) << " ============================================================ " << endline;
  info(tag) << DYNLog(DynawoVersion) << "  " << std::setw(8) << DYNAWO_VERSION_STRING << endline;
  info(tag) << DYNLog(DynawoRevision) << "  " << std::setw(8) << DYNAWO_GIT_BRANCH << "-" << DYNAWO_GIT_HASH << endline;
  info(tag) << " ============================================================ " << endline;
}

void
Trace::clearLogFile(const std::string& tag, SeverityLevel slv) {
  return instance().clearLogFile_(tag, slv);
}

void
Trace::clearLogFile_(const std::string& tag, SeverityLevel slv) {
  resetCustomAppender(tag, slv);
  std::vector<TraceAppender> variablesAppenderVec;
  TagAndSeverityLevel tagAndSeverityLevel = std::make_pair(tag, slv);
  auto variablesAppenders = traceAppenders_.equal_range(tagAndSeverityLevel);
  for (auto variablesAppendersIt = variablesAppenders.first; variablesAppendersIt != variablesAppenders.second; ++variablesAppendersIt) {
    variablesAppenderVec.push_back(variablesAppendersIt->second);
  }
  const bool eraseSinks = false;
  configureSink(variablesAppenderVec, eraseSinks);
}

SeverityLevel
Trace::severityLevelFromString(const std::string& level) {
  if (level == "DEBUG")
    return DEBUG;
  else if (level == "INFO")
    return INFO;
  else if (level == "WARN")
    return WARN;
  else if (level == "ERROR")
    return ERROR;
  else
    throw DYNError(Error::GENERAL, InvalidSeverityLevel, level);
}

string
Trace::stringFromSeverityLevel(const SeverityLevel level) {
  switch (level) {
    case DEBUG:
      return "DEBUG";
    case INFO:
      return "INFO";
    case WARN:
      return "WARN";
    case ERROR:
      return "ERROR";
    default:
      throw DYNError(Error::GENERAL, InvalidSeverityLevel, static_cast<int> (level));
  }
}

}  // namespace DYN
