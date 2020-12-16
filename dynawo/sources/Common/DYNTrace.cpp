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
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
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

using std::string;
using std::vector;

namespace logging = boost::log;
namespace expr = boost::log::expressions;
namespace src = boost::log::sources;
namespace sinks = boost::log::sinks;
namespace attrs = boost::log::attributes;
namespace keywords = boost::log::keywords;

namespace DYN {

static vector< boost::shared_ptr<Trace::TextSink> > originalSinks;

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
std::ostream& operator<<(std::ostream& strm, SeverityLevel level) {
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

Trace::Trace() {}

Trace& Trace::instance() {
  static Trace instance;
  return instance;
}

void Trace::init() {
  // Setup the formatters for the sinks
  logging::formatter onlyMsg = expr::stream << expr::smessage;

  // Construct the sink
  boost::shared_ptr< TextSink > sink = boost::make_shared< TextSink >();
  sink->set_formatter(onlyMsg);

  // Add a stream to write log to
#if BOOST_VERSION / 100 % 1000 < 56
  boost::shared_ptr< std::ostream > stream(&std::clog, boost::empty_deleter());
#else
  boost::shared_ptr< std::ostream > stream(&std::clog, boost::null_deleter());
#endif
  sink->locked_backend()->add_stream(stream);

  // Register the sink in the logging core
  logging::core::get()->add_sink(sink);
  originalSinks.push_back(sink);

  logging::add_common_attributes();
}

void Trace::disableLogging() {
  logging::core::get()->set_logging_enabled(false);
}

void Trace::addAppenders(std::vector<TraceAppender> & appenders) {
  // remove old appenders (console_log)
  Trace::resetCustomAppenders();

  logging::attributes::current_thread_id::value_type currentId =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();

  TraceSinks traceSink;

  std::stringstream s;
  // Add appender
  for (unsigned int i = 0; i < appenders.size(); ++i) {
    const std::ios_base::openmode mode = std::ios_base::out;
    boost::shared_ptr< FileSink > sink(new FileSink(
      keywords::file_name = appenders[i].getFilePath(),
      keywords::open_mode = mode));

    // build format for each appenders depending on its attributes
    string separator = appenders[i].getSeparator();
    bool showTag = appenders[i].getShowLevelTag();
    bool showTimeStamp = appenders[i].getShowTimeStamp();
    string dateFormat = appenders[i].getTimeStampFormat();

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

    if (appenders[i].getTag() == "") {
      sink->set_filter(severity >= appenders[i].getLvlFilter() && !expr::has_attr(tag_attr) && thread_attr == currentId);
    } else {
      sink->set_filter(severity >= appenders[i].getLvlFilter() && tag_attr == appenders[i].getTag() && thread_attr == currentId);
    }
    logging::core::get()->add_sink(sink);
    traceSink.sinks.push_back(sink);
  }

  {
    boost::lock_guard<boost::mutex> lock(instance().mutex_);
    instance().sinks_.insert_or_assign(currentId, traceSink);
  }

  logging::add_common_attributes();
}

void Trace::resetCustomAppenders() {
  boost::lock_guard<boost::mutex> lock(instance().mutex_);

  vector< boost::shared_ptr<TextSink> >::iterator itOSinks;
  for (itOSinks = originalSinks.begin(); itOSinks != originalSinks.end(); ++itOSinks) {
    logging::core::get()->remove_sink(*itOSinks);
  }
  originalSinks.clear();

  logging::attributes::current_thread_id::value_type currentId =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();
  if (instance().sinks_.find(currentId) == instance().sinks_.end()) {
    return;
  }
  TraceSinks& traceSink = instance().sinks_.at(currentId);
  for (vector< boost::shared_ptr<FileSink> >::const_iterator itSinks = traceSink.sinks.begin(); itSinks != traceSink.sinks.end(); ++itSinks) {
    logging::core::get()->remove_sink(*itSinks);
  }
  traceSink.sinks.clear();
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

void Trace::log(SeverityLevel slv, const std::string& tag, const std::string& message) {
  src::severity_logger< SeverityLevel > slg;
  logging::attributes::current_thread_id current;

  if (tag != "")
    slg.add_attribute("Tag", attrs::constant< std::string >(tag));

  slg.add_attribute("Thread", current);

  BOOST_LOG_SEV(slg, slv) << message;
}

bool
Trace::logExists(const std::string& tag, SeverityLevel slv) {
  boost::log::attribute_value_set set;
  logging::attributes::current_thread_id::value_type current_id =
    logging::attributes::current_thread_id().get_value().extract<logging::attributes::current_thread_id::value_type>().get();
  set.insert("Severity",  attrs::make_attribute_value(slv));
  if (tag != "")
    set.insert("Tag",  attrs::make_attribute_value(tag));
  set.insert("Thread", attrs::make_attribute_value(current_id));
  if (instance().sinks_.find(current_id) == instance().sinks_.end()) {
    return false;
  }
  const TraceSinks& traceSinks = instance().sinks_.at(current_id);
  for (vector< boost::shared_ptr<FileSink> >::const_iterator itSinks = traceSinks.sinks.begin(); itSinks != traceSinks.sinks.end(); ++itSinks) {
    if ((*itSinks)->will_consume(set))
      return true;
  }
  for (vector< boost::shared_ptr<FileSink> >::const_iterator itSinks = traceSinks.persistantSinks.begin();
    itSinks != traceSinks.persistantSinks.end(); ++itSinks) {
    if ((*itSinks)->will_consume(set))
      return true;
  }
  return false;
}

SeverityLevel
Trace::severityLevelFromString(std::string level) {
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
Trace::stringFromSeverityLevel(SeverityLevel level) {
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
