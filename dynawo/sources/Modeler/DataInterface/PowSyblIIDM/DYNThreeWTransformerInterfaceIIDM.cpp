//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DYNThreeWTransformerInterfaceIIDM.cpp
 *
 * @brief Three windings transformer data interface : implementation file for IIDM implementation
 *
 */
#include "DYNThreeWTransformerInterfaceIIDM.h"

#include <powsybl/iidm/ThreeWindingsTransformer.hpp>

#include "DYNBusInterface.h"
#include "DYNStateVariable.h"

using boost::shared_ptr;
using std::string;
using std::vector;

namespace DYN {

ThreeWTransformerInterfaceIIDM::ThreeWTransformerInterfaceIIDM(powsybl::iidm::ThreeWindingsTransformer& tfo) :
tfoIIDM_(tfo) {
  setType(ComponentInterface::THREE_WTFO);
}

ThreeWTransformerInterfaceIIDM::~ThreeWTransformerInterfaceIIDM() {
}

void
ThreeWTransformerInterfaceIIDM::setBusInterface1(const shared_ptr<BusInterface>& busInterface) {
  busInterface1_ = busInterface;
}

void
ThreeWTransformerInterfaceIIDM::setBusInterface2(const shared_ptr<BusInterface>& busInterface) {
  busInterface2_ = busInterface;
}

void
ThreeWTransformerInterfaceIIDM::setBusInterface3(const shared_ptr<BusInterface>& busInterface) {
  busInterface3_ = busInterface;
}

void
ThreeWTransformerInterfaceIIDM::setVoltageLevelInterface1(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface1_ = voltageLevelInterface;
}

void
ThreeWTransformerInterfaceIIDM::setVoltageLevelInterface2(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface2_ = voltageLevelInterface;
}

void
ThreeWTransformerInterfaceIIDM::setVoltageLevelInterface3(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface3_ = voltageLevelInterface;
}

shared_ptr<BusInterface>
ThreeWTransformerInterfaceIIDM::getBusInterface1() const {
  return busInterface1_;
}

shared_ptr<BusInterface>
ThreeWTransformerInterfaceIIDM::getBusInterface2() const {
  return busInterface2_;
}

shared_ptr<BusInterface>
ThreeWTransformerInterfaceIIDM::getBusInterface3() const {
  return busInterface3_;
}

string
ThreeWTransformerInterfaceIIDM::getID() const {
  return tfoIIDM_.getId();
}
bool
ThreeWTransformerInterfaceIIDM::getInitialConnected1() {
  if (initialConnected1_ == boost::none) {
    initialConnected1_ = tfoIIDM_.getLeg1().getTerminal().isConnected();
    if (voltageLevelInterface1_->isNodeBreakerTopology()) {
      initialConnected1_ = initialConnected1_ &&
          voltageLevelInterface1_->isNodeConnected(tfoIIDM_.getLeg1().getTerminal().getNodeBreakerView().getNode());
    }
  }
  return initialConnected1_.value();
}

bool
ThreeWTransformerInterfaceIIDM::getInitialConnected2() {
  if (initialConnected2_ == boost::none) {
    initialConnected2_ = tfoIIDM_.getLeg2().getTerminal().isConnected();
    if (voltageLevelInterface2_->isNodeBreakerTopology()) {
      initialConnected2_ = initialConnected2_ &&
          voltageLevelInterface2_->isNodeConnected(tfoIIDM_.getLeg2().getTerminal().getNodeBreakerView().getNode());
    }
  }
  return initialConnected2_.value();
}

bool
ThreeWTransformerInterfaceIIDM::getInitialConnected3() {
  if (initialConnected3_ == boost::none) {
    initialConnected3_ = tfoIIDM_.getLeg3().getTerminal().isConnected();
    if (voltageLevelInterface3_->isNodeBreakerTopology()) {
      initialConnected3_ = initialConnected3_ &&
          voltageLevelInterface3_->isNodeConnected(tfoIIDM_.getLeg3().getTerminal().getNodeBreakerView().getNode());
    }
  }
  return initialConnected3_.value();
}

void
ThreeWTransformerInterfaceIIDM::addCurrentLimitInterface1(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces1_.push_back(currentLimitInterface);
}

void
ThreeWTransformerInterfaceIIDM::addCurrentLimitInterface2(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces2_.push_back(currentLimitInterface);
}

void
ThreeWTransformerInterfaceIIDM::addCurrentLimitInterface3(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces3_.push_back(currentLimitInterface);
}

vector<shared_ptr<CurrentLimitInterface> >
ThreeWTransformerInterfaceIIDM::getCurrentLimitInterfaces1() const {
  return currentLimitInterfaces1_;
}

vector<shared_ptr<CurrentLimitInterface> >
ThreeWTransformerInterfaceIIDM::getCurrentLimitInterfaces2() const {
  return currentLimitInterfaces2_;
}

vector<shared_ptr<CurrentLimitInterface> >
ThreeWTransformerInterfaceIIDM::getCurrentLimitInterfaces3() const {
  return currentLimitInterfaces3_;
}

void
ThreeWTransformerInterfaceIIDM::exportStateVariablesUnitComponent() {
  // No state variable
}

void
ThreeWTransformerInterfaceIIDM::importStaticParameters() {
  // No static parameter
}

int
ThreeWTransformerInterfaceIIDM::getComponentVarIndex(const string& /*varName*/) const {
  return -1;
}

}  // namespace DYN
