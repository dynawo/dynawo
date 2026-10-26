// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/**
 * @file  DYNNetworkBridge.h
 * @brief  interface enabling linking with dynamic model by ModelNetwork
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_H_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_H_

#include <boost/shared_ptr.hpp>
#include <string>
#include "DYNNetworkComponent.h"

namespace DYN {
class SubModel;

/** interface allowing linking a NetworkComponent to its dynamic model, for requests forwarding purposes */
class NetworkBridge {
 public:
  /**
   * @brief base constructor for NetworkBridge subclasses
   * @param stateVarPrefix dynamic state variable model type prefix
   */
  explicit NetworkBridge(const std::string & stateVarPrefix) : stateVarPrefix_(stateVarPrefix) {}

  /**
   * @brief sets the pointer to the dynamic model overriding the ModelNetwork component passed at instanciation
   * @param dynModel the pointer to the dynamic model
   */
  void setDynPart(boost::shared_ptr<SubModel> dynModel);

  /**
   * @brief get the connection state as exposed by the dynamic model in a running-like boolean variable
   * @return \b CLOSED if running-equivalent variable is \b true, \b OPEN otherwise
   */
  State getDynConnState();

  /**
   * @brief evalZ implementation of NetworkComponent::evalZ() common to all NetworkBridge subclasses
   * @param topoChangeFlag a reference to an implementation-specific flag signaling that network topology has changed since last call
   * @return \b TOPO_CHANGE if topoChangeFlag is \b true, \b NO_CHANGE otherwise
   */
  NetworkComponent::StateChange_t evalZ(bool & topoChangeFlag);

  /**
   * @brief obtain the NetworkComponent ID for logging purposes
   * @return the NetworkComponent ID to be used in logs for a given instance
   */
  virtual std::string getLoggingId() = 0;

 protected:
  boost::shared_ptr<SubModel> dynModel_ = nullptr;    ///< dynamic model for the ModelNetwork component
  std::string stateVarPrefix_;                        ///< dynamic state variable model type prefix
  std::string runningAlias_;                          ///< dynamic state variable name to use instead of "running", if not empty
  std::string dynVarName_;                            ///< full name of dynamic state variable
  bool assumeRunning_ = false;                        ///< flag bypassing dynamic state variable reading when set
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKBRIDGE_H_
