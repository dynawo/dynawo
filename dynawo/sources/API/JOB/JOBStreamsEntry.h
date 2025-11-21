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
 * @file JOBStreamsEntry.h
 * @brief output streams entries container : interface file
 */

#ifndef API_JOB_JOBSTREAMSENTRY_H_
#define API_JOB_JOBSTREAMSENTRY_H_

#include "JOBStreamEntry.h"

#include <vector>
#include <memory>

namespace job {

/**
 * @class StreamsEntry
 * @brief Streams entries container class
 */
class StreamsEntry {
 public:
  /// @brief Constructor
  StreamsEntry() = default;

  /// @brief Destructor
  ~StreamsEntry() = default;

  /**
   * @brief Copy constructor
   * @param other original to copy
   */
  StreamsEntry(const StreamsEntry& other);

  /**
   * @brief Assignement Operator
   * @param other original to copy
   * @returns reference on current entry
   */
  StreamsEntry& operator=(const StreamsEntry& other);

  /**
   * @brief Stream entry adder
   * @param streamEntry : stream for the job
   */
  void addStreamEntry(const std::shared_ptr<StreamEntry>& streamEntry);

  /**
   * @brief Stream entries getter
   * @return Vector of the streams for the job
   */
  const std::vector<std::shared_ptr<StreamEntry> >& getStreamEntries() const;

 private:
  /**
   * @brief Copy
   * @param other original to copy
   */
  void copy(const StreamsEntry& other);

 private:
  std::vector<std::shared_ptr<StreamEntry> > streams_;  ///< Streams for the job
};


}  // namespace job

#endif  // API_JOB_JOBSTREAMSENTRY_H_
