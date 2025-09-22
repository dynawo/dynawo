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

/**
 * @file JOBChannelsEntry.h
 * @brief channels entries container : interface file
 */

#ifndef API_JOB_JOBCHANNELSENTRY_H_
#define API_JOB_JOBCHANNELSENTRY_H_

#include "JOBChannelEntry.h"

#include <vector>
#include <memory>
#include <map>

namespace job {

/**
 * @class ChannelsEntry
 * @brief Channels entries container class
 */
class ChannelsEntry {
 public:
  /// @brief Constructor
  ChannelsEntry() = default;

  /**
   * @brief Copy constructor
   * @param other original to copy
   */
  ChannelsEntry(const ChannelsEntry& other);

  /**
   * @brief Assignement Operator
   * @param other original to copy
   * @returns reference on current entry
   */
  ChannelsEntry& operator=(const ChannelsEntry& other);

  /**
   * @brief Channel entry adder
   * @param channelEntry : channel for the job
   */
  void addChannelEntry(const std::shared_ptr<ChannelEntry>& channelEntry);

  /**
   * @brief Channel entries getter
   * @return Vector of the channels for the job
   */
  const std::vector<std::shared_ptr<ChannelEntry> >& getChannelEntries() const;

  /**
   * @brief Channel entry getter by id
   * @return Channel entry with id
   */
  const std::shared_ptr<ChannelEntry> getChannelEntryById(const std::string& id) const;

 private:
  /**
   * @brief Copy
   * @param other original to copy
   */
  void copy(const ChannelsEntry& other);

 private:
  std::vector<std::shared_ptr<ChannelEntry> > channels_;                ///< Channels for the job
  std::map<std::string, std::shared_ptr<ChannelEntry> > channelsById_;  ///< Channels for the job by Id
};

}  // namespace job

#endif  // API_JOB_JOBCHANNELSENTRY_H_
