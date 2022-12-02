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
 * @file  DYNSwitchInterfaceIIDM.cpp
 *
 * @brief  Switch data interface : implementation file for IIDM implementation
 *
 */
#include <powsybl/iidm/Switch.hpp>
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNModelConstants.h"

using boost::shared_ptr;

namespace DYN {

SwitchInterfaceIIDM::~SwitchInterfaceIIDM() {
}

SwitchInterfaceIIDM::SwitchInterfaceIIDM(powsybl::iidm::Switch& sw) : switchIIDM_(sw) {
  setType(ComponentInterface::SWITCH);
  stateVariables_.resize(1);
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);
}

bool
SwitchInterfaceIIDM::isOpen() const {
  return switchIIDM_.isOpen();
}

bool
SwitchInterfaceIIDM::isConnected() const {
  return !isOpen();
}

std::string
SwitchInterfaceIIDM::getID() const {
  return switchIIDM_.getId();
}

void
SwitchInterfaceIIDM::setBusInterface1(const shared_ptr<BusInterface>& busInterface) {
  busInterface1_ = busInterface;
}

void
SwitchInterfaceIIDM::setBusInterface2(const shared_ptr<BusInterface>& busInterface) {
  busInterface2_ = busInterface;
}

shared_ptr<BusInterface>
SwitchInterfaceIIDM::getBusInterface1() const {
  return busInterface1_;
}

shared_ptr<BusInterface>
SwitchInterfaceIIDM::getBusInterface2() const {
  return busInterface2_;
}

int
SwitchInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if (varName == "state")
    index = VAR_STATE;
  return index;
}

void
SwitchInterfaceIIDM::exportStateVariablesUnitComponent() {
  int state = getValue<int>(VAR_STATE);
  switchIIDM_.setOpen(state != CLOSED);
}

void
SwitchInterfaceIIDM::open() {
  switchIIDM_.setOpen(true);
}

void
SwitchInterfaceIIDM::close() {
  switchIIDM_.setOpen(false);
}

void
SwitchInterfaceIIDM::importStaticParameters() {
  // no static parameter
}

bool
SwitchInterfaceIIDM::isRetained() const {
  return switchIIDM_.isRetained();
}

}  // namespace DYN
