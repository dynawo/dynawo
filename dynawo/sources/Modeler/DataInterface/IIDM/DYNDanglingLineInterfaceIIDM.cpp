//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

#include <IIDM/components/DanglingLine.h>

#include "DYNCommon.h"
#include "DYNDanglingLineInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;
using std::vector;

namespace DYN {

DanglingLineInterfaceIIDM::~DanglingLineInterfaceIIDM() {
}

DanglingLineInterfaceIIDM::DanglingLineInterfaceIIDM(IIDM::DanglingLine& danglingLine) :
InjectorInterfaceIIDM<IIDM::DanglingLine>(danglingLine, danglingLine.id()),
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
  danglingLineIIDM_.p(getValue<double>(VAR_P) * SNREF);
  danglingLineIIDM_.q(getValue<double>(VAR_Q) * SNREF);

  if (danglingLineIIDM_.has_connection()) {
    if (danglingLineIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        danglingLineIIDM_.connect();
      else
        danglingLineIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(danglingLineIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(danglingLineIIDM_.node());
    }
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
  InjectorInterfaceIIDM<IIDM::DanglingLine>::setBusInterface(busInterface);
}

void
DanglingLineInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::DanglingLine>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
DanglingLineInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::DanglingLine>::getBusInterface();
}

bool
DanglingLineInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::DanglingLine>::getInitialConnected();
}

double
DanglingLineInterfaceIIDM::getVNom() const {
  return InjectorInterfaceIIDM<IIDM::DanglingLine>::getVNom();
}

double
DanglingLineInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::DanglingLine>::getP();
}

double
DanglingLineInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::DanglingLine>::getQ();
}

string
DanglingLineInterfaceIIDM::getID() const {
  return danglingLineIIDM_.id();
}

double
DanglingLineInterfaceIIDM::getP0() const {
  return danglingLineIIDM_.p0();
}

double
DanglingLineInterfaceIIDM::getQ0() const {
  return danglingLineIIDM_.q0();
}

double
DanglingLineInterfaceIIDM::getR() const {
  if (doubleIsZero(danglingLineIIDM_.x()) && doubleIsZero(danglingLineIIDM_.r())) {
    Trace::warn() << DYNLog(PossibleDivisionByZero, danglingLineIIDM_.id()) << Trace::endline;
    return 0.01;  // default parameter
  }
  return danglingLineIIDM_.x();
}

double
DanglingLineInterfaceIIDM::getX() const {
  return danglingLineIIDM_.x();
}

double
DanglingLineInterfaceIIDM::getG() const {
  return danglingLineIIDM_.g();
}

double
DanglingLineInterfaceIIDM::getB() const {
  return danglingLineIIDM_.b();
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
