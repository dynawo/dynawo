//
// Copyright (c) 2025, RTE
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file JOBChannelEntry.h
 * @brief single channel entry description : interface file
 */

#ifndef API_JOB_JOBCHANNELENTRY_H_
#define API_JOB_JOBCHANNELENTRY_H_

#include <string>
#include <boost/optional.hpp>

namespace job {

/**
 * @class ChannelEntry
 * @brief Channel entry container class
 */
class ChannelEntry {
 public:
  /**
   * @brief id attribute getter
   * @return Channel id
   */
  const std::string& getId() const;

  /**
   * @brief kind attribute getter
   * @return Channel kind
   */
  const std::string& getKind() const;

  /**
   * @brief type attribute getter
   * @return Channel type
   */
  const std::string& getType() const;

  /**
   * @brief endpoint attribute getter
   * @return Channel endpoint
   */
  const std::string& getEndpoint() const;

  /**
   * @brief id attribute setter
   * @param id Channel id
   */
  void setId(const std::string& id);

  /**
   * @brief kind attribute setter
   * @param kind Channel kind
   */
  void setKind(const std::string& kind);

  /**
   * @brief type attribute setter
   * @param type Channel type
   */
  void setType(const std::string& type);

  /**
   * @brief endpoint
   * @param endpoint Channel endpoint
   */
  void setEndpoint(const std::string& endpoint);

 private:
  std::string id_;          ///< Channel id
  std::string kind_;        ///< Channel kind
  std::string type_;        ///< Channel type (ex: ZMQ)
  std::string endpoint_;    ///< Channel endpoint
};

}  // namespace job

#endif  // API_JOB_JOBCHANNELENTRY_H_
