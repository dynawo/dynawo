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
 * @file JOBLogsEntryImpl.h
 * @brief logs entries description : header file
 *
 */

#ifndef API_JOB_JOBLOGSENTRYIMPL_H_
#define API_JOB_JOBLOGSENTRYIMPL_H_

#include <vector>
#include <boost/shared_ptr.hpp>

#include "JOBLogsEntry.h"

namespace job {
class AppenderEntry;
/**
 * @class LogsEntry::Impl
 * @brief Logs entries container : implemented class
 */
class LogsEntry::Impl : public LogsEntry {
 public:
  /**
   * @brief LogsEntry constructor
   */
  Impl();

  /**
   * @brief LogsEntry destructor
   */
  virtual ~Impl();

  /**
   * @copydoc LogsEntry::addAppenderEntry()
   */
  void addAppenderEntry(const boost::shared_ptr<AppenderEntry> & appenderEntry);

  /**
   * @copydoc LogsEntry::getAppenderEntries()
   */
  std::vector<boost::shared_ptr<AppenderEntry> > getAppenderEntries() const;

 private:
  std::vector<boost::shared_ptr<AppenderEntry> > appenders_;  ///< Appenders for the job
};

}  // namespace job

#endif  // API_JOB_JOBLOGSENTRYIMPL_H_
