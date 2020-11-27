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
 * @file JOBOutputsEntry.h
 * @brief Outputs entries description : interface file
 * Outputs contains: init values, constraints, time line, final state, curves, logs
 */

#ifndef API_JOB_JOBOUTPUTSENTRY_H_
#define API_JOB_JOBOUTPUTSENTRY_H_

#include <string>
#include <boost/shared_ptr.hpp>

namespace job {
class InitValuesEntry;
class ConstraintsEntry;
class TimelineEntry;
class TimetableEntry;
class FinalStateEntry;
class CurvesEntry;
class LogsEntry;
class LineariseEntry;
class ModalAnalysisEntry;
class AllModesEntry;
class SubParticipationEntry;
/**
 * @class OutputsEntry
 * @brief Outputs entries container class
 */
class OutputsEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~OutputsEntry() {}

  /**
   * @brief Outputs directory setter
   * @param outputsDirectory : directory for simulation outputs
   */
  virtual void setOutputsDirectory(const std::string& outputsDirectory) = 0;

  /**
   * @brief Outputs directory getter
   * @return directory for simulation outputs
   */
  virtual std::string getOutputsDirectory() const = 0;

  /**
   * @brief Init Values entry setter
   * @param initValuesEntry: initValues entry container for the job
   */
  virtual void setInitValuesEntry(const boost::shared_ptr<InitValuesEntry>& initValuesEntry) = 0;

  /**
   * @brief Init Values entries container getter
   * @return the init values entry container
   */
  virtual boost::shared_ptr<InitValuesEntry> getInitValuesEntry() const = 0;

  /**
   * @brief Constraints entry setter
   * @param constraintsEntry : contraints entry container for the job
   */
  virtual void setConstraintsEntry(const boost::shared_ptr<ConstraintsEntry>& constraintsEntry) = 0;

  /**
   * @brief Constraints entries container getter
   * @return the constraints entry container
   */
  virtual boost::shared_ptr<ConstraintsEntry> getConstraintsEntry() const = 0;

  /**
   * @brief Timeline entry setter
   * @param timelineEntry : timeline entry container for the job
   */
  virtual void setTimelineEntry(const boost::shared_ptr<TimelineEntry>& timelineEntry) = 0;

  /**
   * @brief Timeline entries container getter
   * @return the timeline entry container
   */
  virtual boost::shared_ptr<TimelineEntry> getTimelineEntry() const = 0;

  /**
   * @brief Timetable entry setter
   * @param timetableEntry : timetable entry container for the job
   */
  virtual void setTimetableEntry(const boost::shared_ptr<TimetableEntry>& timetableEntry) = 0;

  /**
   * @brief Timetable entries container getter
   * @return the timetable entry container
   */
  virtual boost::shared_ptr<TimetableEntry> getTimetableEntry() const = 0;

  /**
   * @brief Final State entry setter
   * @param finalStateEntry : final state entry container for the job
   */
  virtual void setFinalStateEntry(const boost::shared_ptr<FinalStateEntry>& finalStateEntry) = 0;

  /**
   * @brief FinalSate entries container getter
   * @return the final state entry container
   */
  virtual boost::shared_ptr<FinalStateEntry> getFinalStateEntry() const = 0;

  /**
   * @brief Curves entry setter
   * @param curvesEntry : curves for the job
   */
  virtual void setCurvesEntry(const boost::shared_ptr<CurvesEntry>& curvesEntry) = 0;

  /**
   * @brief Curves entry getter
   * @return the curves entry container
   */
  virtual boost::shared_ptr<CurvesEntry> getCurvesEntry() const = 0;

  /**
   * @brief Logs entry container setter
   * @param logsEntry : logs entries container for the job
   */
  virtual void setLogsEntry(const boost::shared_ptr<LogsEntry>& logsEntry) = 0;

  /**
   * @brief Logs entries container getter
   * @return the log entry container
   */
  virtual boost::shared_ptr<LogsEntry> getLogsEntry() const = 0;

  /**
   * @brief Linearise entry setter
   * @param lineariseEntry : linearise entry container for the job
   */
  virtual void setLineariseEntry(const boost::shared_ptr<LineariseEntry>& lineariseEntry) = 0;

  /**
   * @brief Linearise entries container getter
   * @return the linearise entry container
   */
  virtual boost::shared_ptr<LineariseEntry> getLineariseEntry() const = 0;

  /**
   * @brief ModalAnalysis entry setter
   * @param ModalAnalysisEntry : ModalAnalysis entry container for the job
   */
  virtual void setModalAnalysisEntry(const boost::shared_ptr<ModalAnalysisEntry>& modalanalysisEntry) = 0;

  /**
   * @brief ModalAnalysis entries container getter
   * @return the modalanalysis entry container
   */
  virtual boost::shared_ptr<ModalAnalysisEntry> getModalAnalysisEntry() const = 0;

  /**
   * @brief All Modes entry setter
   * @param AllModesEntry : AllModes entry container for the job
   */
  virtual void setAllModesEntry(const boost::shared_ptr<AllModesEntry>& allmodesEntry) = 0;

  /**
   * @brief AllModes entries container getter
   * @return the allmodes entry container
   */
  virtual boost::shared_ptr<AllModesEntry> getAllModesEntry() const = 0;

  /**
   * @brief Sub Participation entry setter
   * @param SubParticipationEntry : SubParticipation entry container for the job
   */
  virtual void setSubParticipationEntry(const boost::shared_ptr<SubParticipationEntry>& subparticipationEntry) = 0;

  /**
   * @brief SubParticipation entries container getter
   * @return the subparticipation entry container
   */

  virtual boost::shared_ptr<SubParticipationEntry> getSubParticipationEntry() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBOUTPUTSENTRY_H_
