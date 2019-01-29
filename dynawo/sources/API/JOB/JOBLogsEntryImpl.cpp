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
 * @file JOBLogsEntryImpl.cpp
 * @brief Logs entry description : implementation file
 *
 */

#include "JOBLogsEntryImpl.h"

namespace job {

LogsEntry::Impl::Impl() :
  appenders_() {
}


LogsEntry::Impl::~Impl() {
}

void
LogsEntry::Impl::addAppenderEntry(const boost::shared_ptr<AppenderEntry> & appenderEntry) {
  appenders_.push_back(appenderEntry);
}

std::vector<boost::shared_ptr<AppenderEntry> >
LogsEntry::Impl::getAppenderEntries() const {
  return appenders_;
}

}  // namespace job
