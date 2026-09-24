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

/** @file  DYNModelBusBridged.cpp */

#include "DYNModelBusBridged.h"
#include "DYNBusInterface.h"
#include "DYNModelNetwork.h"

namespace DYN {

double
ModelBusBridged::ur() const {
  if (!network_->isInit())
    throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "ur() outside of init", id());

  // we would like something along the line of dynModel_->getVariableValue("bus_terminal_V_re") here,
  // however the modelica init has not run yet

  return getSwitchOff() ? 0. : ur0_;
}

double
ModelBusBridged::ui() const {
  if (!network_->isInit())
    throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "ui() outside of init", id());

  return getSwitchOff() ? 0. : ui0_;
}

void
ModelBusBridged::initSize() {
  ModelBus::initSize();
  if (!network_->isInitModel())
    sizeG_ += 1;  // connection event from dynamic model needs to be propagated
}

NetworkComponent::StateChange_t
ModelBusBridged::evalZ(const double t, bool /*onlyEvaluateStateChange*/) {
  if (topologyModified_) {
    topologyModified_ = false;
    return NetworkComponent::TOPO_CHANGE;
  }

  return NetworkComponent::NO_CHANGE;
}

void
ModelBusBridged::evalG(const double t) {
  if (dynModel_ == nullptr)
    throw DYNError(Error::MODELER, UnmappedNetworkBridge, id());

  double dynConnState = dynModel_->getVariableValue("bus_state");
  if (dynConnState != z_[connectionStateNum_]) {
    g_[0] = (g_[0] != ROOT_UP) ? ROOT_UP : ROOT_DOWN;
    z_[connectionStateNum_] = dynConnState;
    refreshConnectionStateFromZ(DO_LOG_TIMELINE);
  }
}

void
ModelBusBridged::setGequations(std::map<int, std::string> & gEquationIndex) {
  gEquationIndex[0] = "Connection state change propagation by : "+id();
}

}  // namespace DYN
