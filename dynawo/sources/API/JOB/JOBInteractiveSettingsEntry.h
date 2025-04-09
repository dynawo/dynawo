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
 * @file JOBInteractiveSettingsEntry.h
 * @brief Live settings entries description : interface file
 *
 */

#ifndef API_JOB_JOBINTERACTIVESETTINGSENTRY_H_
#define API_JOB_JOBINTERACTIVESETTINGSENTRY_H_

#include "DYNFileSystemUtils.h"
#include "JOBPeriodicOutputsEntry.h"

#include <string>
#include <vector>

namespace job {

/**
 * @class InteractiveSettingsEntry
 * @brief Live settings entries container class
 */
class InteractiveSettingsEntry {
 public:
  /**
   * @brief Default constructor
   */
  InteractiveSettingsEntry();

  /**
   * @brief Copy constructor
   * @param other the modeler entry to copy
   */
  InteractiveSettingsEntry(const InteractiveSettingsEntry& other);

  /**
   * @brief Copy assignment operator
   * @param other the modeler entry to copy
   * @returns reference to this
   */
  InteractiveSettingsEntry& operator=(const InteractiveSettingsEntry& other);

  /**
   * @brief periodic outputs entries container setter
   * @param periodicOutputsEntry : periodic outputs entries container for the job
   */
  void setPeriodicOutputsEntry(const std::shared_ptr<PeriodicOutputsEntry>& periodicOutputsEntry);

  /**
   * @brief periodic outputs entries container getter
   * @return periodic outputs entries container for the job
   */
  std::shared_ptr<PeriodicOutputsEntry> getPeriodicOutputsEntry() const;

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
  std::shared_ptr<PeriodicOutputsEntry> periodicOutputsEntry_;     ///< preCompiled models directories
  bool timeSync_;                                                  ///< indicating if simulation must be sync with user clock
  double timeSyncAcceleration_;                                    ///< simulation timeout
  bool eventSubscriberActions_;                                    ///< enables zmq event subscriber
  bool eventSubscriberTrigger_;                                    ///< enable extrernal step trigger
  double triggerSimulationTimeStepInS_;                            ///< simulation refresh rate (zmq enabled)
  bool publishToZmq_;                                              ///< publish step resuts to ZMQ
  bool publishToWebsocket_;                                        ///< publish curves update to Websocket
};

}  // namespace job

#endif  // API_JOB_JOBINTERACTIVESETTINGSENTRY_H_
