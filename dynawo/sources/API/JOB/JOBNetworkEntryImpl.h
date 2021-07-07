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
 * @file JOBNetworkEntryImpl.h
 * @brief Network model entries description : header file
 *
 */

#ifndef API_JOB_JOBNETWORKENTRYIMPL_H_
#define API_JOB_JOBNETWORKENTRYIMPL_H_

#include <string>
#include "JOBNetworkEntry.h"

namespace job {

/**
 * @class NetworkEntry::Impl
 * @brief Network model entries container class
 */
class NetworkEntry::Impl : public NetworkEntry {
 public:
  /**
   * @brief Default constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc NetworkEntry::setIidmFile()
   */
  void setIidmFile(const std::string& iidmFile);

  /**
   * @copydoc NetworkEntry::getIidmFile()
   */
  std::string getIidmFile() const;

  /**
   * @copydoc NetworkEntry::setNetworkParFile()
   */
  void setNetworkParFile(const std::string& networkParFile);

  /**
   * @copydoc NetworkEntry::getNetworkParFile()
   */
  std::string getNetworkParFile() const;

  /**
   * @copydoc NetworkEntry::setNetworkParId()
   */
  void setNetworkParId(const std::string& parId);

  /**
   * @copydoc NetworkEntry::getNetworkParId()
   */
  std::string getNetworkParId() const;

  /**
   * @copydoc NetworkEntry::clone()
   */
  boost::shared_ptr<NetworkEntry> clone() const;

 private:
  std::string iidmFile_;  ///< IIDM file for the simulation
  std::string networkParFile_;  ///< Parameters file for the network model
  std::string networkParId_;  ///< Number of the parameters set in parameters file
};

}  // namespace job

#endif  // API_JOB_JOBNETWORKENTRYIMPL_H_
