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

//======================================================================
/**
 * @file  DYNDanglingLineInterfaceIIDM.cpp
 *
 * @brief Dangling line data interface : implementation file for IIDM implementation
 *
 */
//======================================================================

#include "DYNDanglingLineInterfaceIIDM.h"

#include <powsybl/iidm/DanglingLine.hpp>

#include "DYNCommon.h"

using std::string;
using boost::shared_ptr;
using std::vector;

namespace DYN {

DanglingLineInterfaceIIDM::~DanglingLineInterfaceIIDM() {
}

DanglingLineInterfaceIIDM::DanglingLineInterfaceIIDM(powsybl::iidm::DanglingLine& danglingLine) :
InjectorInterfaceIIDM(danglingLine, danglingLine.getId()),
danglingLineIIDM_(danglingLine) {
  setType(ComponentInterface::DANGLING_LINE);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
}

int
DanglingLineInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "p" )
    index = VAR_P;
  else if ( varName == "q" )
    index = VAR_Q;
  else if ( varName == "state" )
    index = VAR_STATE;
  return index;
}

void
DanglingLineInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  if (connected) {
    danglingLineIIDM_.getTerminal().setP(getValue<double>(VAR_P) * SNREF);
    danglingLineIIDM_.getTerminal().setQ(getValue<double>(VAR_Q) * SNREF);
  }

  if (getVoltageLevelInterfaceInjector()->isNodeBreakerTopology()) {
    // should be removed once a solution has been found to propagate switches (de)connection
    // following component (de)connection (only Modelica models)
    if (connected && !getInitialConnected())
      getVoltageLevelInterfaceInjector()->connectNode(static_cast<unsigned int>(danglingLineIIDM_.getTerminal().getNodeBreakerView().getNode()));
    else if (!connected && getInitialConnected())
      getVoltageLevelInterfaceInjector()->disconnectNode(static_cast<unsigned int>(danglingLineIIDM_.getTerminal().getNodeBreakerView().getNode()));
  } else {
    if (connected)
      danglingLineIIDM_.getTerminal().connect();
    else
      danglingLineIIDM_.getTerminal().disconnect();
  }
}

void
DanglingLineInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(getQ())));
  // attention to sign (+/-) convention
}

void
DanglingLineInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  setBusInterfaceInjector(busInterface);
}

void
DanglingLineInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  setVoltageLevelInterfaceInjector(voltageLevelInterface);
}

shared_ptr<BusInterface>
DanglingLineInterfaceIIDM::getBusInterface() const {
  return getBusInterfaceInjector();
}

bool
DanglingLineInterfaceIIDM::getInitialConnected() {
  return getInitialConnectedInjector();
}

bool
DanglingLineInterfaceIIDM::isConnected() const {
  return isConnectedInjector();
}

double
DanglingLineInterfaceIIDM::getVNom() const {
  return getVNomInjector();
}

double
DanglingLineInterfaceIIDM::getP() {
  return getPInjector();
}

double
DanglingLineInterfaceIIDM::getQ() {
  return getQInjector();
}

string
DanglingLineInterfaceIIDM::getID() const {
  return danglingLineIIDM_.getId();
}

double
DanglingLineInterfaceIIDM::getP0() const {
  return danglingLineIIDM_.getP0();
}

double
DanglingLineInterfaceIIDM::getQ0() const {
  return danglingLineIIDM_.getQ0();
}

double
DanglingLineInterfaceIIDM::getR() const {
  return danglingLineIIDM_.getR();
}

double
DanglingLineInterfaceIIDM::getX() const {
  if (doubleIsZero(danglingLineIIDM_.getX()) && doubleIsZero(danglingLineIIDM_.getR())) {
    Trace::warn() << DYNLog(PossibleDivisionByZero, danglingLineIIDM_.getId()) << Trace::endline;
    return 0.01;  // default parameter
  }
  return danglingLineIIDM_.getX();
}

double
DanglingLineInterfaceIIDM::getG() const {
  return danglingLineIIDM_.getG();
}

double
DanglingLineInterfaceIIDM::getB() const {
  return danglingLineIIDM_.getB();
}

void
DanglingLineInterfaceIIDM::addCurrentLimitInterface(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces_.push_back(currentLimitInterface);
}

vector<shared_ptr<CurrentLimitInterface> >
DanglingLineInterfaceIIDM::getCurrentLimitInterfaces() const {
  return currentLimitInterfaces_;
}

}  // namespace DYN
