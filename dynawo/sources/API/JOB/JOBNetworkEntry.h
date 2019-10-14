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
 * @file JOBNetworkEntry.h
 * @brief Network model entries description : interface file
 *
 */

#ifndef API_JOB_JOBNETWORKENTRY_H_
#define API_JOB_JOBNETWORKENTRY_H_

#include <string>

namespace job {

/**
 * @class NetworkEntry
 * @brief Network model entries container class
 */
class NetworkEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~NetworkEntry() {}

  /**
   * @brief IIDM file setter
   * @param iidmFile : IIDM file for the job
   */
  virtual void setIidmFile(const std::string& iidmFile) = 0;

  /**
   * @brief IIDM file getter
   * @return IIDM file for the job
   */
  virtual std::string getIidmFile() const = 0;

  /**
   * @brief network's parameters file setter
   * @param networkParFile : network's parameters file for the job
   */
  virtual void setNetworkParFile(const std::string& networkParFile) = 0;

  /**
   * @brief network's parameters file getter
   * @return network's parameters file for the job
   */
  virtual std::string getNetworkParFile() const = 0;

  /**
   * @brief network's parameters set number setter
   * @param parId : Network parameters set number for the job
   */
  virtual void setNetworkParId(const std::string& parId) = 0;

  /**
   * @brief Network parameters set number getter
   * @return Network parameters set number for the job
   */
  virtual std::string getNetworkParId() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBNETWORKENTRY_H_
