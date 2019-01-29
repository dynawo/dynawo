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
 * @file DYNTraceStream.cpp
 * @brief Trace stream implementation
 *
 * Trace stream header for Dynawo. Used by @p Trace static class for
 * stream-like logging
 */
#include "DYNTrace.h"
#include "DYNTraceStream.h"

namespace DYN {

TraceStream::TraceStream() :
buffer_(),
slv_(INFO),
tag_("") {
}

TraceStream::TraceStream(SeverityLevel slv, const std::string& tag) :
buffer_(),
slv_(slv),
tag_(tag) {
}

TraceStream::TraceStream(const TraceStream& ts) :
buffer_(),
slv_(ts.slv_),
tag_(ts.tag_) {
}

TraceStream::~TraceStream() {
}

TraceStream&
TraceStream::operator<<(const char* t) {
  buffer_ << t;
  return *this;
}

void
TraceStream::flush() {
  Trace::log(slv_, tag_, buffer_.str());
  buffer_.str(std::string());
}

TraceStream&
TraceStream::operator<<(tspf pf) {
  return (*pf)(*this);
}

TraceStream& eol(TraceStream& os) {
  os.flush();
  return os;
}

}  // namespace DYN
