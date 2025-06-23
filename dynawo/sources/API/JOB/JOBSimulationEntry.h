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
 * @file JOBSimulationEntry.h
 * @brief Simulation entries description : interface file
 *
 */

#ifndef API_JOB_JOBSIMULATIONENTRY_H_
#define API_JOB_JOBSIMULATIONENTRY_H_

#include <string>
#include <vector>

namespace job {

/**
 * @class SimulationEntry
 * @brief Simulation entries container class
 */
class SimulationEntry {
 public:
  /**
   * @brief Default constructor
   */
  SimulationEntry();

  /**
   * @brief Start time setter
   * @param startTime : Start time for the job
   */
  void setStartTime(double startTime);

  /**
   * @brief Start time getter
   * @return Start time for the job
   */
  double getStartTime() const;

  /**
   * @brief Stop time setter
   * @param stopTime : Stop time for the job
   */
  void setStopTime(double stopTime);

  /**
   * @brief Stop time getter
   * @return Stop time for the job
   */
  double getStopTime() const;

  /**
   * @brief add a criteria file path to the job
   * @param criteriaFile criteria file path to add
   */
  void addCriteriaFile(const std::string& criteriaFile);

  /**
   * @brief set a unique criteria file path for the job (other are removed)
   * @param criteriaFile criteria file path to set
   */
  void setCriteriaFile(const std::string& criteriaFile);

  /**
   * @brief list of criteria files
   * @return list of criteria files
   */
  const std::vector<std::string>& getCriteriaFiles() const;

  /**
   * @brief criteria step setter
   * @param criteriaStep : number of iterations between 2 criteria check
   */
  void setCriteriaStep(int criteriaStep);

  /**
   * @brief criteria step getter
   * @return number of iterations between 2 criteria check
   */
  int getCriteriaStep() const;

  /**
   * @brief precision setter
   * @param precision : double precision for the job
   */
  void setPrecision(double precision);

  /**
   * @brief precision getter
   * @return precision for the job
   */
  double getPrecision() const;

  /**
   * @brief Retrieves the simulation timeout, or the default value if not set
   * @returns the simulation timeout
   */
  double getTimeout() const {
    return timeout_;
  }

  /**
   * @brief timeout setter
   * @param timeout the timeout of the simulation
   */
  void setTimeout(double timeout) {
    timeout_ = timeout;
  }

  /**
   * @brief timeSync getter
   * @returns the boolean indicating if simulation must be sync with user clock
   */
  bool getTimeSync() const {
    return timeSync_;
  }

  /**
   * @brief timeSync setter
   * @param timeSync boolean indicating if simulation must be sync with user clock
   */
  void setTimeSync(bool timeSync) {
    timeSync_ = timeSync;
  }

  /**
   * @brief timeSyncAcceleration getter
   * @returns the acceleration ratio between simulation time and user clock
   */
  double getTimeSyncAcceleration() const {
    return timeSyncAcceleration_;
  }

  /**
   * @brief timeSyncAcceleration setter
   * @param timeSyncAcceleration acceleration ratio between simulation time and user clock
   */
  void setTimeSyncAcceleration(double timeSyncAcceleration) {
    timeSyncAcceleration_ = timeSyncAcceleration;
  }

  /**
   * @brief eventSubscriberActions getter
   * @returns enable event subscriber
   */
  bool getEventSubscriberActions() const {
    return eventSubscriberActions_;
  }

  /**
   * @brief eventSubscriberActions setter
   * @param eventSubscriberActions enable event subscriber
   */
  void setEventSubscriberActions(bool eventSubscriberActions) {
    eventSubscriberActions_ = eventSubscriberActions;
  }

  /**
   * @brief eventSubscriberTrigger getter
   * @returns enable external step trigger
   */
  bool getEventSubscriberTrigger() const {
    return eventSubscriberTrigger_;
  }

  /**
   * @brief eventSubscriberTrigger setter
   * @param eventSubscriberTrigger enable external step trigger
   */
  void setEventSubscriberTrigger(bool eventSubscriberTrigger) {
    eventSubscriberTrigger_ = eventSubscriberTrigger;
  }

  /**
   * @brief triggerSimulationTimeStepInS getter
   * @returns simulation output period
   */
  double getTriggerSimulationTimeStepInS() const {
    return triggerSimulationTimeStepInS_;
  }

  /**
   * @brief triggerSimulationTimeStepInS setter
   * @param triggerSimulationTimeStepInS simulation output period
   */
  void setTriggerSimulationTimeStepInS(double triggerSimulationTimeStepInS) {
    triggerSimulationTimeStepInS_ = triggerSimulationTimeStepInS;
  }

  /**
   * @brief publishToWebsocket getter
   * @returns publishToWebsocket
   */
  bool getPublishToWebsocket() const {
    return publishToWebsocket_;
  }

  /**
   * @brief publishToWebsocket setter
   * @param publishToWebsocket
   */
  void setPublishToWebsocket(bool publishToWebsocket) {
    publishToWebsocket_ = publishToWebsocket;
  }

  /**
   * @brief publishToZmqCurvesFormat getter
   * @returns publishToZmqCurvesFormat
   */
  const std::string& getPublishToZmqCurvesFormat() const {
    return publishToZmqCurvesFormat_;
  }

  /**
   * @brief publishToZmqCurvesFormat setter
   * @param publishToZmqCurvesFormat
   */
  void setPublishToZmqCurvesFormat(const std::string& publishToZmqCurvesFormat) {
    publishToZmqCurvesFormat_ = publishToZmqCurvesFormat;
  }


  /**
   * @brief publishToZmq getter
   * @returns publishToZmq
   */
  bool getPublishToZmq() const {
    return publishToZmq_;
  }

  /**
   * @brief publishToZmq setter
   * @param publishToZmq
   */
  void setPublishToZmq(bool publishToZmq) {
    publishToZmq_ = publishToZmq;
  }

 private:
  double startTime_;                        ///< Start time of the simulation
  double stopTime_;                         ///< Stop time of the simulation
  std::vector<std::string> criteriaFiles_;  ///< List of criteria files path
  int criteriaStep_;                        ///< criteria verification time step
  double precision_;                        ///< precision of the simulation
  double timeout_;                          ///< simulation timeout
  bool timeSync_;                           ///< indicating if simulation must be sync with user clock
  double timeSyncAcceleration_;             ///< simulation timeout
  bool eventSubscriberActions_;             ///< enables zmq event subscriber
  bool eventSubscriberTrigger_;             ///< enable extrernal step trigger
  double triggerSimulationTimeStepInS_;     ///< simulation refresh rate (zmq enabled)
  bool publishToZmq_;                       ///< publish step resuts to ZMQ
  std::string publishToZmqCurvesFormat_;    ///< format for courves to publish to ZMQ
  bool publishToWebsocket_;                 ///< publish curves update to Websocket
};
}  // namespace job

#endif  // API_JOB_JOBSIMULATIONENTRY_H_
