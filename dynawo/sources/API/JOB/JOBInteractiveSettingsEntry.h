//
// Copyright (c) 2025, RTE
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

#ifndef API_JOB_JOBINTERACTIVESETTINGSENTRY_H_
#define API_JOB_JOBINTERACTIVESETTINGSENTRY_H_

#include <memory>
#include <vector>
#include "JOBClockEntry.h"
#include "JOBChannelsEntry.h"
#include "JOBStreamsEntry.h"

namespace job {

/**
 * @class InteractiveSettingsEntry
 * @brief Container for interactive mode options: clock, channels, streams
 */
class InteractiveSettingsEntry {
 public:
  /**
   * @brief constructor
   */
  InteractiveSettingsEntry();

  /**
   * @brief Copy constructor
   * @param other original to copy
   */
  InteractiveSettingsEntry(const InteractiveSettingsEntry& other);

  /**
   * @brief Assignement Operator
   * @param other original to copy
   * @returns reference on current entry
   */
  InteractiveSettingsEntry& operator=(const InteractiveSettingsEntry& other);


  /**
   * @brief Clock entry container setter
   * @param clockEntry : Clock entry for the interactive simulation
   */
  void setClockEntry(std::shared_ptr<ClockEntry> clockEntry);

  /**
   * @brief Clock entry getter
   * @return clock entry for the interactive simulation
   */
  const std::shared_ptr<ClockEntry> getClockEntry() const;

  /**
   * @brief Channels entry container setter
   * @param channelEntry : Channels entry for the interactive simulation
   */
  void setChannelsEntry(std::shared_ptr<ChannelsEntry> channelsEntry);

  /**
   * @brief Channels entry getter
   * @return Channels entry for the interactive simulation
   */
  const std::shared_ptr<ChannelsEntry> getChannelsEntry() const;

  /**
   * @brief Output streams entry container setter
   * @param streamsEntry : Output streams entry for the interactive simulation
   */
  void setStreamsEntry(std::shared_ptr<StreamsEntry> streamsEntry);

  /**
   * @brief Output streams entry getter
   * @return Output streams entry for the interactive simulation
   */
  const std::shared_ptr<StreamsEntry> getStreamsEntry() const;

  /**
   * @brief couplingTimeStep attribute getter
   * @return couplingTimeStep for the interactive simulation
   */
  double getCouplingTimeStep() const;

  /**
   * @brief couplingTimeStep setter
   * @param couplingTimeStep : time step for the interactive simulation
   */
  void setCouplingTimeStep(const double couplingTimeStep);

 private:
  /**
   * @brief Copy
   * @param other original to copy
   */
  void copy(const InteractiveSettingsEntry& other);

 private:
  std::shared_ptr<ClockEntry> clock_;         ///< Clock entry container
  std::shared_ptr<ChannelsEntry> channels_;   ///< Channels entry container
  std::shared_ptr<StreamsEntry> streams_;     ///< Streams entry container
  double couplingTimeStep_;                   ///< Time step in s between two I/O phases with external systems in interactive mode
};

}  // namespace job

#endif  // API_JOB_JOBINTERACTIVESETTINGSENTRY_H_
