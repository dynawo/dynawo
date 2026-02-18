//
// Copyright (c) 2015-2026, RTE (http://www.rte-france.com)
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
 * @file  NetworkBridge.cpp
 *
 * @brief  enables dynamic switchoff/on events of tfos and lines to be propagated to ModelNetwork
 *
 */

#include "DYNNetworkBridge.h"
#include "DYNModelTwoWindingsTransformer.h"
#include "DYNModelLine.h"
#include "DYNModelBus.h"
#include "DYNSubModel.h"

namespace DYN {

const char NetworkBridge::BRIDGE_PREFIX[] = "NetworkBridge_";

NetworkBridge::NetworkBridge(const std::shared_ptr<ModelTwoWindingsTransformer> & tfo) :
  NetworkBridge(tfo->id(), tfo->getModelBus1(), tfo->getModelBus2(), "transformer") {
}

NetworkBridge::NetworkBridge(const std::shared_ptr<ModelLine> & line) :
  NetworkBridge(line->id(), line->getModelBus1(), line->getModelBus2(), "line") {
}

NetworkBridge::NetworkBridge(const std::string & staticId,
                             const std::shared_ptr<ModelBus> & modelBus1,
                             const std::shared_ptr<ModelBus> & modelBus2,
                             const std::string & stateVarPrefix) :
  NetworkComponent(BRIDGE_PREFIX+staticId),
  modelBus1_(modelBus1),
  modelBus2_(modelBus2),
  stateVarPrefix_(stateVarPrefix) {
}

NetworkComponent::StateChange_t
NetworkBridge::evalZ(const double t) {
  return (getDynamicState() == lastActedUponState_) ? NetworkComponent::NO_CHANGE : NetworkComponent::TOPO_CHANGE;
}

void
NetworkBridge::addBusNeighbors() {
  lastActedUponState_ = getDynamicState();

  if (lastActedUponState_ == CLOSED) {
    modelBus1_->addNeighbor(modelBus2_);
    modelBus2_->addNeighbor(modelBus1_);
  }
}

State
NetworkBridge::getDynamicState() {
  if (dynModel_ == nullptr)
    throw DYNError(Error::MODELER, UnmappedNetworkBridge, id());

  // Modelica and CPP enums match and are liable to break much more than this if they change
  State dynState = static_cast<State>(dynModel_->getVariableValue(stateVarPrefix_+"_state"));

  // reasonable assumption at init, will heuristically limit topology recomputations
  if (dynState == UNDEFINED_STATE)
    return CLOSED;

  // dynamic state has latency compared to running_value and may not be caught in time
  // by solver's calls to evalZ(), even if stored in nonsilent Z vector
  return (dynModel_->getVariableValue(stateVarPrefix_+"_running_value") > 0.5) ? CLOSED : OPEN;
}

}  // namespace DYN
