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

/** @file  DYNModelBus.cpp */

#include "DYNModelBus.h"
#include "DYNModelSubNetwork.hpp"
#include "DYNModelNetwork.h"
#include "DYNBusInterface.h"
#include "DYNVariableForModel.h"

namespace DYN {

ModelBus::ModelBus(const std::string & id, const std::shared_ptr<BusInterface> & bus) :
NetworkComponent(id),
busIndex_(bus->getBusIndex()) {
  busBarSectionIdentifiers_.clear();
  busBarSectionIdentifiers_ = bus->getBusBarSectionIdentifiers();
}

void
ModelBus::initSize() {
  sizeZ_ = network_->isInitModel() ? 0 : 3;  // numSubnet, switchOff, state
}

void
ModelBus::instantiateVariables(std::vector<boost::shared_ptr<Variable> > & variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_numcc_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_switchOff_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
}

void
ModelBus::collectSilentZ(BitMask* silentZTable) {
  silentZTable[numSubNetworkNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[connectionStateNum_].setFlags(NotUsedInDiscreteEquations);
}

void
ModelBus::switchOn() {
  assert(z_!= NULL);
  z_[switchOffNum_] = fromNativeBool(false);
}

void
ModelBus::switchOff() {
  assert(z_!= NULL);
  z_[switchOffNum_] = fromNativeBool(true);
}

bool
ModelBus::getSwitchOff() const {
  if (z_ == NULL) return false;  // Might happen when we initialize connection to calculated variables (done before model init)
  return toNativeBool(z_[switchOffNum_]);
}

void
ModelBus::addNeighbor(const std::shared_ptr<ModelBus>& bus) {
  neighbors_.push_back(bus);
}

void
ModelBus::clearNeighbors() {
  neighbors_.clear();
}

void
ModelBus::exploreNeighbors(const int numSubNetwork, const boost::shared_ptr<SubNetwork>& subNetwork) {
  for (const auto& neighbor : neighbors_) {
    std::shared_ptr<ModelBus> bus = neighbor.lock();
    if (!bus->isNumSubNetworkSet()) {  // Bus not yet treated
      bus->setNumSubNetwork(numSubNetwork);
      subNetwork->addBus(bus);
      bus->exploreNeighbors(numSubNetwork, subNetwork);
    }
  }
}


}  // namespace DYN
