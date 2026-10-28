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

#include "DYNNetworkBridge.h"
#include "DYNSubModel.h"
#include "DYNNetworkComponent.h"

namespace DYN {

void
NetworkBridge::setDynPart(boost::shared_ptr<SubModel> dynModel) {
  dynModel_ = dynModel;
  dynVarName_ = stateVarPrefix_+ "_" + (runningAlias_.empty() ? "running" : runningAlias_);
  if (!dynModel_->hasVariable(dynVarName_)) {
    if (runningAlias_.empty()) {
      Trace::info() << DYNLog(BridgeNoRunningVariable, dynVarName_, getLoggingId()) << Trace::endline;
      assumeRunning_ = true;
    } else {
      throw DYNError(Error::MODELER, BridgeRunningAliasNotFound, dynVarName_, getLoggingId());
    }
  }
}

State
NetworkBridge::getDynConnState() {
  if (dynModel_ == nullptr)
    throw DYNError(Error::MODELER, UnmappedNetworkBridge, getLoggingId());

  if (assumeRunning_)
    return CLOSED;

  // since variable "state" is compiled with SILENT_Z flag, reading it is hazardous as evalG() may not be called
  // after it changed, so use running instead, that is flipped earlier
  return dynModel_->getVariableValue(dynVarName_) > 0.5 ? CLOSED : OPEN;
}

NetworkComponent::StateChange_t
NetworkBridge::evalZ(bool & topoChangeFlag) {
  if (topoChangeFlag) {
    topoChangeFlag = false;
    return NetworkComponent::TOPO_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

}  // namespace DYN
