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
 * @file JOBTimelineEntryImpl.h
 * @brief Timeline entries description : header file
 *
 */

#ifndef API_JOB_JOBTIMELINEENTRYIMPL_H_
#define API_JOB_JOBTIMELINEENTRYIMPL_H_

#include <string>
#include "JOBTimelineEntry.h"

namespace job {

/**
 * @class TimelineEntry::Impl
 * @brief Timeline entries container class
 */
class TimelineEntry::Impl : public TimelineEntry {
 public:
  /**
   * @brief constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc TimelineEntry::setOutputFile()
   */
  void setOutputFile(const std::string & outputFile);

  /**
   * @copydoc TimelineEntry::setExportMode()
   */
  void setExportMode(const std::string & exportMode);

  /**
   * @copydoc TimelineEntry::getOutputFile()
   */
  std::string getOutputFile() const;

  /**
   * @copydoc TimelineEntry::getExportMode()
   */
  std::string getExportMode() const;

  /**
   * @copydoc TimelineEntry::setMaxPriority()
   */
  void setMaxPriority(const boost::optional<int> maxPriority);

  /**
   * @copydoc TimelineEntry::getMaxPriority()
   */
  boost::optional<int> getMaxPriority() const;

  /**
   * @copydoc TimelineEntry::clone()
   */
  boost::shared_ptr<TimelineEntry> clone() const;

 private:
  std::string outputFile_;  ///< Export file for timeline
  std::string exportMode_;  ///< Export mode TXT, CSV, XML for timeline output file
  boost::optional<int> maxPriority_;  ///< maximum priority allowed when exporting timeline
};

}  // namespace job

#endif  // API_JOB_JOBTIMELINEENTRYIMPL_H_
