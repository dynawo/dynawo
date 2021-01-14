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
 * @file DYNTraceExternal.cpp
 * @brief Trace system implementation for external methods
 *
 */
#include "DYNTrace.h"

extern "C" void TraceLog(DYN::SeverityLevel slv, const std::string& tag, const std::string& message) {
  DYN::Trace::log(slv, tag, message);
}

extern "C" bool TraceLogExists(const std::string& tag, DYN::SeverityLevel slv) {
  return DYN::Trace::logExists(tag, slv);
}

extern "C" DYN::TraceStream TraceWarn(const std::string& tag) {
  return DYN::Trace::warn(tag);
}

extern "C" DYN::TraceStream TraceDebug(const std::string& tag) {
  return DYN::Trace::debug(tag);
}

extern "C" DYN::TraceStream TraceError(const std::string& tag) {
  return DYN::Trace::error(tag);
}

extern "C" DYN::TraceStream TraceInfo(const std::string& tag) {
  return DYN::Trace::info(tag);
}
