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
 * @file  NetworkBridgeQuadripole.cpp
 * @brief  enables dynamic switchoff/on events of tfos and lines to be propagated to ModelNetwork
 */

#include "DYNNetworkBridgeQuadripole.h"
#include "DYNSubModel.h"
#include "DYNModelNetwork.h"

namespace DYN {

NetworkBridgeQuadripole::NetworkBridgeQuadripole(const std::shared_ptr<ModelQuadripole> & baseQuadripole,
                                                 const std::string & stateVarPrefix) :
  ModelQuadripole("NetworkBridge_" + baseQuadripole->id()),
  stateVarPrefix_(stateVarPrefix) {
  setModelBus1(baseQuadripole->getModelBus1());
  setModelBus2(baseQuadripole->getModelBus2());
  connectionState_ = baseQuadripole->getConnectionState();
}

void
NetworkBridgeQuadripole::initSize() {
  if (!network_->isInitModel())
    sizeG_ = 1;  // connection event from dynamic model needs to be propagated
}

NetworkComponent::StateChange_t
NetworkBridgeQuadripole::evalZ(const double /*t*/, bool /*onlyEvaluateStateChange*/) {
  if (declareTopoChange_) {
    declareTopoChange_ = false;
    return NetworkComponent::TOPO_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
NetworkBridgeQuadripole::evalG(const double /*t*/) {
  if (dynModel_ == nullptr)
    throw DYNError(Error::MODELER, UnmappedNetworkBridge, id());

  State prevConnectionState = connectionState_;

  // since variable "state" is compiled with SILENT_Z flag, reading it is hazardous as evalG() may not be called
  // after it changed, so use running instead, that is flipped earlier
  connectionState_ = dynModel_->getVariableValue(stateVarPrefix_+"_running") > 0.5 ? CLOSED : OPEN;

  if ((connectionState_ != prevConnectionState) && ((connectionState_ == CLOSED) || (prevConnectionState == CLOSED))) {
    g_[0] = (g_[0] != ROOT_UP) ? ROOT_UP : ROOT_DOWN;
    declareTopoChange_ = true;
  }
}

void
NetworkBridgeQuadripole::setGequations(std::map<int, std::string> & gEquationIndex) {
  gEquationIndex[0] = "Connection state change propagation by : "+id();
}

}  // namespace DYN
