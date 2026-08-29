//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
   * @brief IIDM file setter
   * @param iidmFile : IIDM file for the job
   */
  void setIidmFile(const std::string& iidmFile);

  /**
   * @brief IIDM file getter
   * @return IIDM file for the job
   */
  const std::string& getIidmFile() const;

  /**
   * @brief network's parameters file setter
   * @param networkParFile : network's parameters file for the job
   */
  void setNetworkParFile(const std::string& networkParFile);

  /**
   * @brief network's parameters file getter
   * @return network's parameters file for the job
   */
  const std::string& getNetworkParFile() const;

  /**
   * @brief network's parameters set number setter
   * @param parId : Network parameters set number for the job
   */
  void setNetworkParId(const std::string& parId);

  /**
   * @brief Network parameters set number getter
   * @return Network parameters set number for the job
   */
  const std::string& getNetworkParId() const;

 private:
  std::string iidmFile_;        ///< IIDM file for the simulation
  std::string networkParFile_;  ///< Parameters file for the network model
  std::string networkParId_;    ///< Number of the parameters set in parameters file
};

}  // namespace job

#endif  // API_JOB_JOBNETWORKENTRY_H_
