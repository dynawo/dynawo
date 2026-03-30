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
 * @file  DYNModelBusBridged.cpp
 */

#include "DYNModelBusBridged.h"
#include "DYNBusInterface.h"
#include "DYNModelNetwork.h"

namespace DYN {

ModelBusBridged::ModelBusBridged(const std::shared_ptr<BusInterface> & bus) :
ModelBus("NetworkBridge_" + bus->getID(), bus) {
}

double
ModelBusBridged::ur() const {
  if (getSwitchOff())
    return 0.;

  if (!network_->isInit())
    throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "ur() after init", id());

  if (dynModel_ == nullptr)
    throw DYNError(Error::MODELER, UnmappedNetworkBridge, id());

  return dynModel_->getVariableValue("bus_terminal_V_re");
}

double
ModelBusBridged::ui() const {
  if (getSwitchOff())
    return 0.;

  if (!network_->isInit())
    throw DYNError(Error::MODELER, UnhandledBridgedBusCall, "ui() after init", id());

  if (dynModel_ == nullptr)
    throw DYNError(Error::MODELER, UnmappedNetworkBridge, id());

  return dynModel_->getVariableValue("bus_terminal_V_im");
}

}  // namespace DYN
