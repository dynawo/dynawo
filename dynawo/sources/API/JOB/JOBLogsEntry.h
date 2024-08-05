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
 * @file JOBLogsEntry.h
 * @brief logs entries description : interface file
 *
 */

#ifndef API_JOB_JOBLOGSENTRY_H_
#define API_JOB_JOBLOGSENTRY_H_

#include "JOBAppenderEntry.h"

#include <boost/shared_ptr.hpp>
#include <string>
#include <vector>

namespace job {

/**
 * @class LogsEntry
 * @brief Logs entries container class
 */
class LogsEntry {
 public:
  /// @brief Constructor
  LogsEntry() = default;

  /**
   * @brief Copy constructor
   * @param other original to copy
   */
  LogsEntry(const LogsEntry& other);

  /**
   * @brief Assignement OPerator
   * @param other original to copy
   * @returns reference on current entry
   */
  LogsEntry& operator=(const LogsEntry& other);

  /**
   * @brief Appender entry adder
   * @param appenderEntry : appender for the job
   */
  void addAppenderEntry(const boost::shared_ptr<AppenderEntry>& appenderEntry);

  /**
   * @brief Appender entries getter
   * @return Vector of the appenders for the job
   */
  const std::vector<boost::shared_ptr<AppenderEntry> >& getAppenderEntries() const;

 private:
  /**
   * @brief Copy
   * @param other original to copy
   */
  void copy(const LogsEntry& other);

 private:
  std::vector<boost::shared_ptr<AppenderEntry> > appenders_;  ///< Appenders for the job
};

}  // namespace job

#endif  // API_JOB_JOBLOGSENTRY_H_
