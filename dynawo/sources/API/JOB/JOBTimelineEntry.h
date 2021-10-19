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
 * @file JOBTimelineEntry.h
 * @brief Timeline entries description : interface file
 *
 */

#ifndef API_JOB_JOBTIMELINEENTRY_H_
#define API_JOB_JOBTIMELINEENTRY_H_

#include <string>

namespace job {

/**
 * @class TimelineEntry
 * @brief Timeline entries container class
 */
class TimelineEntry {
 public:
  /**
   * @brief constructor
   */
  TimelineEntry();

  /**
   * @brief Output file attribute setter
   * @param outputFile Output file for timeline
   */
  void setOutputFile(const std::string& outputFile);

  /**
   * @brief Export Mode attribute setter
   * @param exportMode Export mode for timeline
   */
  void setExportMode(const std::string& exportMode);

  /**
   * @brief Output file attribute getter
   * @return Output file for timeline
   */
  const std::string& getOutputFile() const;

  /**
   * @brief Export mode attribute getter
   * @return Export mode for timeline
   */
  const std::string& getExportMode() const;

  /**
   * @brief whether to export time setter
   * @param exportWithTime whether to export time when exporting timeline
   */
  void setExportWithTime(const bool exportWithTime);

  /**
   * @brief whether to export time getter
   * @return whether to export time when exporting timeline
   */
  bool getExportWithTime() const;

  /**
   * @brief minimum priority setter
   * @param minPriority minimum priority required when exporting timeline
   */
  void setMinPriority(const int minPriority);

  /**
   * @brief minimum priority getter
   * @return minimum priority required when exporting timeline
   */
  int getMinPriority() const;

 private:
  std::string outputFile_;  ///< Export file for timeline
  std::string exportMode_;  ///< Export mode TXT, CSV, XML for timeline output file
  bool exportWithTime_;   ///< boolean indicating whether to export time when exporting timeline
  int minPriority_;  ///< minimum priority required when exporting timeline
};

}  // namespace job

#endif  // API_JOB_JOBTIMELINEENTRY_H_
