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

typedef sinks::synchronous_sink< sinks::text_ostream_backend > text_sink;  ///< define text sink
typedef sinks::synchronous_sink< sinks::text_file_backend > file_sink;  ///< define file sink

static vector< boost::shared_ptr<file_sink> > sinks;  ///<  vector of file sink
static vector< boost::shared_ptr<file_sink> > persistantSinks;  ///<  vector of persistant file sink
static vector< boost::shared_ptr<text_sink> > originalSinks;  ///< vector of text sink

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
#pragma GCC diagnostic error "-Wmissing-field-initializers"

TraceStream& Trace::endline(TraceStream& os) {
  return eol(os);
}

void Trace::init() {
  // Setup the formatters for the sinks
  logging::formatter onlyMsg = expr::stream << expr::smessage;

  // Construct the sink
  boost::shared_ptr< text_sink > sink = boost::make_shared< text_sink >();
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

void Trace::addAppenders(const std::vector<TraceAppender>& appenders) {
  // remove old appenders (console_log)
  Trace::resetCustomAppenders();

  std::stringstream s;
  // Add appender
  for (unsigned int i = 0; i < appenders.size(); ++i) {
    const std::ios_base::openmode mode = appenders[i].doesAppend() ? std::ios_base::app : std::ios_base::out;
    boost::shared_ptr< file_sink > sink(new file_sink(
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
      sink->set_filter(severity >= appenders[i].getLvlFilter() && !expr::has_attr(tag_attr));
    } else {
      sink->set_filter(severity >= appenders[i].getLvlFilter() && tag_attr == appenders[i].getTag());
    }
    logging::core::get()->add_sink(sink);
    if (appenders[i].isPersistant())
      persistantSinks.push_back(sink);
    else
      sinks.push_back(sink);
  }

  logging::add_common_attributes();
}

void Trace::resetPersistantCustomAppenders() {
  vector< boost::shared_ptr<file_sink> >::iterator itSinks;
  for (itSinks = persistantSinks.begin(); itSinks != persistantSinks.end(); ++itSinks) {
    logging::core::get()->remove_sink(*itSinks);
  }
  persistantSinks.clear();
}

void Trace::resetCustomAppenders() {
  vector< boost::shared_ptr<file_sink> >::iterator itSinks;
  for (itSinks = sinks.begin(); itSinks != sinks.end(); ++itSinks) {
    logging::core::get()->remove_sink(*itSinks);
  }
  sinks.clear();

  vector< boost::shared_ptr<text_sink> >::iterator itOSinks;
  for (itOSinks = originalSinks.begin(); itOSinks != originalSinks.end(); ++itOSinks) {
    logging::core::get()->remove_sink(*itOSinks);
  }
  originalSinks.clear();
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
Trace::fullmodalanalysis() {
  return "FULLMODALANALYSIS";
}

std::string
Trace::subparticipation() {
  return "SUBPARTICIPATION";
}

std::string
Trace::statespace() {
  return "STATESPACE";
}

void Trace::log(SeverityLevel slv, const std::string& tag, const std::string& message) {
  src::severity_logger< SeverityLevel > slg;

  if (tag != "")
    slg.add_attribute("Tag", attrs::constant< std::string >(tag));

  BOOST_LOG_SEV(slg, slv) << message;
}

bool
Trace::logExists(const std::string& tag, SeverityLevel slv) {
  boost::log::attribute_value_set set;
  set.insert("Severity",  attrs::make_attribute_value(slv));
  if (tag != "")
    set.insert("Tag",  attrs::make_attribute_value(tag));
  for (vector< boost::shared_ptr<file_sink> >::iterator itSinks = sinks.begin(); itSinks != sinks.end(); ++itSinks) {
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
