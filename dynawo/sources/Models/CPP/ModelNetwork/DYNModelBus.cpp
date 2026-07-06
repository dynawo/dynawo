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
#include "DYNModelSwitch.h"
#include "DYNVariableForModel.h"

namespace DYN {

ModelBus::ModelBus(const std::shared_ptr<BusInterface> & bus, bool isNodeBreaker) :
NetworkComponent(bus->getID()),
busIndex_(bus->getBusIndex()),
modelType_(isNodeBreaker? "Bus" : "Node"),
isNodeBreaker_(isNodeBreaker) {
  busBarSectionIdentifiers_.clear();
  busBarSectionIdentifiers_ = bus->getBusBarSectionIdentifiers();

  angle0_ = bus->getAngle0() * DEG_TO_RAD;
  ur0_ = cos(angle0_);
  ui0_ = sin(angle0_);
}

void
ModelBus::initSize() {
  sizeF_ = 0;
  sizeG_ = 0;
  sizeY_ = 0;
  sizeZ_ = network_->isInitModel() ? 0 : 3;  // numSubnet, switchOff, state
  sizeMode_ = 0;
  sizeCalculatedVar_ = 0;
}

void
ModelBus::getY0() {
  if (network_->isInitModel())
    return;

  if (network_->isStartingFromDump() && internalVariablesFoundInDump_) {
    refreshConnectionStateFromZ(DO_NOT_LOG_TIMELINE);
    return;
  }

  // We assume here that z_[numSubNetworkNum_] was already initialized!!

  if (doubleNotEquals(z_[switchOffNum_], -1.) && doubleNotEquals(z_[switchOffNum_], 1.))
    z_[switchOffNum_] = fromNativeBool(false);

  z_[connectionStateNum_] = connectionState_;
}

void
ModelBus::refreshConnectionStateFromZ(bool logTimeline) {
  State currState = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
  if (currState == connectionState_)
    return;

  if (isNodeBreaker_ && connectableSwitches_.empty())
    throw DYNError(Error::MODELER, CalculatedBusNoSwitchStateChange, id_);

  if (currState == OPEN) {
    switchOff();
    if (logTimeline)
      DYNAddTimelineEvent(network_, id_, NodeOff);
    for (unsigned int i = 0; i < connectableSwitches_.size(); ++i)
      connectableSwitches_[i].lock()->open();  // open all switch connected to this node
  } else if (currState == CLOSED) {
    switchOn();
    if (logTimeline)
      DYNAddTimelineEvent(network_, id_, NodeOn);
  }

  topologyModified_ = true;
  connectionState_ = currState;
}

void
ModelBus::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_numcc_value",     DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_switchOff_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value",     INTEGER));
}

void
ModelBus::instantiateVariables(std::vector<boost::shared_ptr<Variable> > & variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_numcc_value",     DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_switchOff_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value",     INTEGER));

  for (unsigned int i = 0; i < busBarSectionIdentifiers_.size(); ++i) {
    std::string busBarSectionId = busBarSectionIdentifiers_[i];
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_numcc_value",     id_ + "_numcc_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_switchOff_value", id_ + "_switchOff_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_state_value",     id_ + "_state_value"));
  }
}

void
ModelBus::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  defineElementsById(id_, elements, mapElement);
  for (const auto& busBarSectionIdentifier : busBarSectionIdentifiers_)
    defineElementsById(busBarSectionIdentifier, elements, mapElement);
}

void
ModelBus::defineElementsById(const std::string& id, std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  // Discrete variables addition
  addElementWithValue(id + std::string("_numcc"),     modelType_, elements, mapElement);
  addElementWithValue(id + std::string("_switchOff"), modelType_, elements, mapElement);
  addElementWithValue(id + std::string("_state"),     modelType_, elements, mapElement);
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
