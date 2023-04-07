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

#include "JOBConstraintsEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBFinalStateValuesEntry.h"
#include "JOBFinalValuesEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBLogsEntry.h"
#include "JOBLostEquipmentsEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBTimetableEntry.h"

#include <boost/shared_ptr.hpp>
#include <string>

namespace job {

/**
 * @class OutputsEntry
 * @brief Outputs entries container class
 */
class OutputsEntry {
 public:
  /// @brief Destructor
  ~OutputsEntry();

  /// @brief Default constructor
  OutputsEntry();

  /**
   * @brief Copy constructor
   * @param other original to copy
   */
  OutputsEntry(const OutputsEntry& other);

  /**
   * @brief Assignement OPerator
   * @param other original to copy
   * @returns reference on current entry
   */
  OutputsEntry& operator=(const OutputsEntry& other);

  /**
   * @brief Outputs directory setter
   * @param outputsDirectory : directory for simulation outputs
   */
  void setOutputsDirectory(const std::string& outputsDirectory);

  /**
   * @brief Outputs directory getter
   * @return directory for simulation outputs
   */
  const std::string& getOutputsDirectory() const;

  /**
   * @brief Init Values entry setter
   * @param initValuesEntry : initValues entry container for the job
   */
  void setInitValuesEntry(const boost::shared_ptr<InitValuesEntry>& initValuesEntry);

  /**
   * @brief Init Values entries container getter
   * @return the init values entry container
   */
  boost::shared_ptr<InitValuesEntry> getInitValuesEntry() const;

  /**
   * @brief Final Values entry setter
   * @param FinalValuesEntry : FinalValues entry container for the job
   */
  void setFinalValuesEntry(const boost::shared_ptr<FinalValuesEntry>& finalValuesEntry);

  /**
   * @brief Final Values entries container getter
   * @return the final values entry container
   */
  boost::shared_ptr<FinalValuesEntry> getFinalValuesEntry() const;

  /**
   * @brief Constraints entry setter
   * @param constraintsEntry : contraints entry container for the job
   */
  void setConstraintsEntry(const boost::shared_ptr<ConstraintsEntry>& constraintsEntry);

  /**
   * @brief Constraints entries container getter
   * @return the constraints entry container
   */
  boost::shared_ptr<ConstraintsEntry> getConstraintsEntry() const;

  /**
   * @brief Timeline entry setter
   * @param timelineEntry : timeline entry container for the job
   */
  void setTimelineEntry(const boost::shared_ptr<TimelineEntry>& timelineEntry);

  /**
   * @brief Timeline entries container getter
   * @return the timeline entry container
   */
  boost::shared_ptr<TimelineEntry> getTimelineEntry() const;

  /**
   * @brief Timetable entry setter
   * @param timetableEntry : timetable entry container for the job
   */
  void setTimetableEntry(const boost::shared_ptr<TimetableEntry>& timetableEntry);

  /**
   * @brief Timetable entries container getter
   * @return the timetable entry container
   */
  boost::shared_ptr<TimetableEntry> getTimetableEntry() const;

  /**
   * @brief Add final State entry
   * @param finalStateEntry final state entry container for the job
   */
  void addFinalStateEntry(const boost::shared_ptr<FinalStateEntry>& finalStateEntry);

  /**
   * @brief FinalSate entries container getter
   * @return the final state entries container
   */
  inline const std::vector<boost::shared_ptr<FinalStateEntry> >& getFinalStateEntries() const {
    return finalStateEntries_;
  }

  /**
   * @brief Curves entry setter
   * @param curvesEntry : curves for the job
   */
  void setCurvesEntry(const boost::shared_ptr<CurvesEntry>& curvesEntry);

  /**
   * @brief Curves entry getter
   * @return the curves entry container
   */
  boost::shared_ptr<CurvesEntry> getCurvesEntry() const;

  /**
   * @brief FinalStateValues entry setter
   * @param finalStateValuesEntry : final state values entry container for the job
   */
  void setFinalStateValuesEntry(const boost::shared_ptr<FinalStateValuesEntry>& finalStateValuesEntry);

  /**
   * @brief FinalStateValues entries container getter
   * @return the final state values entry container
   */
  boost::shared_ptr<FinalStateValuesEntry> getFinalStateValuesEntry() const;

  /**
   * @brief lostEquipments entry setter
   * @param lostEquipmentsEntry : lostEquipments for the job
   */
  void setLostEquipmentsEntry(const boost::shared_ptr<LostEquipmentsEntry>& lostEquipmentsEntry);

  /**
   * @brief lostEquipments entry getter
   * @return the lostEquipments entry container
   */
  boost::shared_ptr<LostEquipmentsEntry> getLostEquipmentsEntry() const;

  /**
   * @brief Logs entry container setter
   * @param logsEntry : logs entries container for the job
   */
  void setLogsEntry(const boost::shared_ptr<LogsEntry>& logsEntry);

  /**
   * @brief Logs entries container getter
   * @return the log entry container
   */
  boost::shared_ptr<LogsEntry> getLogsEntry() const;

 private:
  /**
   * @brief Copy
   * @param other original to copy
   */
  void copy(const OutputsEntry& other);

 private:
  std::string outputsDirectory_;                                        ///< directory for simulation outputs
  boost::shared_ptr<InitValuesEntry> initValuesEntry_;                  ///< Init Values entries container
  boost::shared_ptr<FinalValuesEntry> finalValuesEntry_;                ///< Final Values entries container
  boost::shared_ptr<ConstraintsEntry> constraintsEntry_;                ///< Constraints entries container
  boost::shared_ptr<TimelineEntry> timelineEntry_;                      ///< Timeline entries container
  boost::shared_ptr<TimetableEntry> timetableEntry_;                    ///< Timetable entries container
  std::vector<boost::shared_ptr<FinalStateEntry> > finalStateEntries_;  ///< Final State entries container
  boost::shared_ptr<CurvesEntry> curvesEntry_;                          ///< Curves entries container
  boost::shared_ptr<FinalStateValuesEntry> finalStateValuesEntry_;      ///< Final State values entries container
  boost::shared_ptr<LostEquipmentsEntry> lostEquipmentsEntry_;          ///< Lost equipments entries container
  boost::shared_ptr<LogsEntry> logsEntry_;                              ///< Logs entries containe
};

}  // namespace job

#endif  // API_JOB_JOBOUTPUTSENTRY_H_
