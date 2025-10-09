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
 * @file JOBStreamEntry.h
 * @brief Output stream entry description : interface file
 */

#ifndef API_JOB_JOBSTREAMENTRY_H_
#define API_JOB_JOBSTREAMENTRY_H_

#include <string>
#include <boost/optional.hpp>

namespace job {

/**
 * @class StreamEntry
 * @brief Output stream entry container class
 */
class StreamEntry {
 public:
  /**
   * @brief Data attribute getter
   * @return Data identifier for the output stream
   */
  const std::string& getData() const;

  /**
   * @brief Channel attribute getter
   * @return Channel name for the output stream
   */
  const std::string& getChannel() const;

  /**
   * @brief Format attribute getter
   * @return Format of the output stream (eg. JSON, CSV, BYTES, XML, TXT)
   */
  const std::string& getFormat() const;

  /**
   * @brief Data attribute setter
   * @param data Data identifier for the output stream
   */
  void setData(const std::string& data);

  /**
   * @brief Channel attribute setter
   * @param channel Channel name for the output stream
   */
  void setChannel(const std::string& channel);

  /**
   * @brief Format attribute setter
   * @param format Format of the output stream (eg. JSON, CSV, BYTES, XML, TXT)
   */
  void setFormat(const std::string& format);

 private:
  std::string data_;                         ///< Data identifier (required)
  std::string channel_;                      ///< Channel name (required)
  std::string format_;                       ///< Output stream format (required)
};

}  // namespace job

#endif  // API_JOB_JOBSTREAMENTRY_H_
