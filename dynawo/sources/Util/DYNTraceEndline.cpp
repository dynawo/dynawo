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
 * @file DYNTraceEnline.cpp
 * @brief Trace system implementation for endline
 *
 */
#include <ostream>

#include "DYNTrace.h"
#include "DYNTraceStream.h"
#include "DYNError.h"
#include "DYNMacrosMessage.h"

using std::string;

namespace DYN {

#if _DEBUG_
const SeverityLevel Trace::defaultLevel_ = DEBUG;
#else
const SeverityLevel Trace::defaultLevel_ = INFO;
#endif

TraceStream& Trace::endline(TraceStream& os) {
  return eol(os);
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
