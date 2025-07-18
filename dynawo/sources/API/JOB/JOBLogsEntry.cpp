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
 * @file JOBLogsEntry.cpp
 * @brief Logs entry description : implementation file
 *
 */

#include "JOBLogsEntry.h"

#include "DYNClone.hpp"

namespace job {

LogsEntry::LogsEntry(const LogsEntry& other) {
  copy(other);
}

LogsEntry& LogsEntry::operator=(const LogsEntry& other) {
  copy(other);
  return *this;
}

void
LogsEntry::copy(const LogsEntry& other) {
  appenders_.reserve(other.appenders_.size());
  for (const auto& appender : other.appenders_) {
      appenders_.push_back(DYN::clone(appender));
  }
}

void
LogsEntry::addAppenderEntry(const std::shared_ptr<AppenderEntry>& appenderEntry) {
  appenders_.push_back(appenderEntry);
}

const std::vector<std::shared_ptr<AppenderEntry> >&
LogsEntry::getAppenderEntries() const {
  return appenders_;
}

}  // namespace job
