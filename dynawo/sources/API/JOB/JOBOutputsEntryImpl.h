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
 * @file JOBOutputsEntryImpl.h
 * @brief Outputs entries description : header file
 *
 */

#ifndef API_JOB_JOBOUTPUTSENTRYIMPL_H_
#define API_JOB_JOBOUTPUTSENTRYIMPL_H_

#include <string>

#include "JOBOutputsEntry.h"

namespace job {

/**
 * @class OutputsEntry::Impl
 * @brief OutputsEntry implemented class
 */
class OutputsEntry::Impl : public OutputsEntry {
 public:
  /*
   * @brief Default constructor
   */
  Impl();

  /*
   * @brief Default destructor
   */
  virtual ~Impl();

  /**
   * @copydoc OutputsEntry::setOutputsDirectory()
   */
  void setOutputsDirectory(const std::string& outputsDirectory);

  /**
   * @copydoc OutputsEntry::getOutputsDirectory()
   */
  std::string getOutputsDirectory() const;

  /**
   * @copydoc OutputsEntry::setInitValuesEntry()
   */
  void setInitValuesEntry(const boost::shared_ptr<InitValuesEntry>& initValuesEntry);

  /**
   * @copydoc OutputsEntry::getInitValuesEntry()
   */
  boost::shared_ptr<InitValuesEntry> getInitValuesEntry() const;

  /**
   * @copydoc OutputsEntry::setConstraintsEntry()
   */
  void setConstraintsEntry(const boost::shared_ptr<ConstraintsEntry>& constraintsEntry);

  /**
   * @copydoc OutputsEntry::getConstraintsEntry()
   */
  boost::shared_ptr<ConstraintsEntry> getConstraintsEntry() const;

  /**
   * @copydoc OutputsEntry::setTimelineEntry()
   */
  void setTimelineEntry(const boost::shared_ptr<TimelineEntry>& timelineEntry);

  /**
   * @copydoc OutputsEntry::getTimelineEntry()
   */
  boost::shared_ptr<TimelineEntry> getTimelineEntry() const;

  /**
   * @copydoc OutputsEntry::setFinalStateEntry()
   */
  void setFinalStateEntry(const boost::shared_ptr<FinalStateEntry>& finalStateEntry);

  /**
   * @copydoc OutputsEntry::getFinalStateEntry()
   */
  boost::shared_ptr<FinalStateEntry> getFinalStateEntry() const;

  /**
   * @copydoc OutputsEntry::setCurvesEntry()
   */
  void setCurvesEntry(const boost::shared_ptr<CurvesEntry>& curvesEntry);

  /**
   * @copydoc OutputsEntry::getCurvesEntry()
   */
  boost::shared_ptr<CurvesEntry> getCurvesEntry() const;

  /**
   * @copydoc OutputsEntry::setLogsEntry()
   */
  void setLogsEntry(const boost::shared_ptr<LogsEntry>& logsEntry);

  /**
   * @copydoc OutputsEntry::getLogsEntry()
   */
  boost::shared_ptr<LogsEntry> getLogsEntry() const;

 /**
   * @copydoc OutputsEntry::setLineariseEntry()
   */

  void setLineariseEntry(const boost::shared_ptr<LineariseEntry>& lineariseEntry);

  /**
   * @copydoc OutputsEntry::getTimelineEntry()
   */
  boost::shared_ptr<LineariseEntry> getLineariseEntry() const;

 /**
   * @copydoc OutputsEntry::setModalAnalysisEntry()
   */
  void setModalAnalysisEntry(const boost::shared_ptr<ModalAnalysisEntry>& modalanalysisEntry);

  /**
   * @copydoc OutputsEntry::getModalAnalysisEntry()
   */
  boost::shared_ptr<ModalAnalysisEntry> getModalAnalysisEntry() const;

 /**
   * @copydoc OutputsEntry::setAllModesEntry()
   */
  void setAllModesEntry(const boost::shared_ptr<AllModesEntry>& allmodesEntry);

  /**
   * @copydoc OutputsEntry::getAllModesEntry()
   */
  boost::shared_ptr<AllModesEntry> getAllModesEntry() const;

 /**
   * @copydoc OutputsEntry::setSubParticipationEntry()
   */
  void setSubParticipationEntry(const boost::shared_ptr<SubParticipationEntry>& subparticipationEntry);

  /**
   * @copydoc OutputsEntry::getSubParticipationEntry()
   */
  boost::shared_ptr<SubParticipationEntry> getSubParticipationEntry() const;

 private:
  std::string outputsDirectory_;  ///< directory for simulation outputs
  boost::shared_ptr<InitValuesEntry> initValuesEntry_;  ///< Init Values entries container
  boost::shared_ptr<ConstraintsEntry> constraintsEntry_;  ///< Constraints entries container
  boost::shared_ptr<TimelineEntry> timelineEntry_;  ///< Timeline entries container
  boost::shared_ptr<FinalStateEntry> finalStateEntry_;  ///< Final State entries container
  boost::shared_ptr<CurvesEntry> curvesEntry_;  ///< Curves entries container
  boost::shared_ptr<LogsEntry> logsEntry_;  ///< Logs entries container
  boost::shared_ptr<LineariseEntry> lineariseEntry_;  ///< Linearise entries container
  boost::shared_ptr<ModalAnalysisEntry> modalanalysisEntry_;  ///< ModalAnalysis entries container
  boost::shared_ptr<AllModesEntry> allmodesEntry_;  ///< AllModes entries container
  boost::shared_ptr<SubParticipationEntry> subparticipationEntry_;  ///< SubParticipation entries container
};

}  // namespace job

#endif  // API_JOB_JOBOUTPUTSENTRYIMPL_H_
