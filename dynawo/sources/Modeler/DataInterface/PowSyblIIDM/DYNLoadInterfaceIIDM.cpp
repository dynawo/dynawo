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
 * @file  DYNLoadInterfaceIIDM.cpp
 *
 * @brief Load data interface : implementation file for IIDM structure
 *
 */
//======================================================================

#include "DYNLoadInterfaceIIDM.h"

#include <powsybl/iidm/Load.hpp>

using boost::shared_ptr;
using powsybl::iidm::Load;

namespace DYN {

LoadInterfaceIIDM::~LoadInterfaceIIDM() {
}

LoadInterfaceIIDM::LoadInterfaceIIDM(Load& load) : InjectorInterfaceIIDM(load, load.getId()),
                                                   loadIIDM_(load),
                                                   loadPUnderV_(0.),
                                                   v0_(0.),
                                                   vNom_(0.) {
  setType(ComponentInterface::LOAD);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);       // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);       // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);  // connectionState
}

int
LoadInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if (varName == "p")
    index = VAR_P;
  else if (varName == "q")
    index = VAR_Q;
  else if (varName == "state")
    index = VAR_STATE;
  return index;
}

void
LoadInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);

  loadIIDM_.getTerminal().setP(getValue<double>(VAR_P) * SNREF);
  loadIIDM_.getTerminal().setQ(getValue<double>(VAR_Q) * SNREF);

  if (loadIIDM_.getTerminal().isConnected()) {
    if (connected)
      loadIIDM_.getTerminal().connect();
    else
      loadIIDM_.getTerminal().disconnect();
  }
}

void
LoadInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  double P = getP();
  double P0 = getP0();
  double Q = getQ();
  double Q0 = getQ0();
  double SN = SNREF;
  SN = 1.5 * sqrt(P * P + Q * Q);
  SN = (SN < SNREF ? SNREF : SN);

  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(P / SNREF)));
  staticParameters_.insert(std::make_pair("p0_pu", StaticParameter("p0_pu", StaticParameter::DOUBLE).setValue(P0 / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(Q / SNREF)));
  staticParameters_.insert(std::make_pair("q0_pu", StaticParameter("q0_pu", StaticParameter::DOUBLE).setValue(Q0 / SNREF)));
  staticParameters_.insert(std::make_pair("sn_pu", StaticParameter("sn_pu", StaticParameter::DOUBLE).setValue(SN / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(P)));
  staticParameters_.insert(std::make_pair("p0", StaticParameter("p0", StaticParameter::DOUBLE).setValue(P0)));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(Q)));
  staticParameters_.insert(std::make_pair("q0", StaticParameter("q0", StaticParameter::DOUBLE).setValue(Q0)));
  staticParameters_.insert(std::make_pair("sn", StaticParameter("sn", StaticParameter::DOUBLE).setValue(SN)));

  if (getBusInterface()) {
    v0_ = getBusInterface()->getV0();

    double teta = getBusInterface()->getAngle0();
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(v0_ / vNom_)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(teta * M_PI / 180)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(v0_)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(teta)));
  } else {
    v0_ = 0;
    vNom_ = 0;
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
  }
  // attention to sign convention
}

void
LoadInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM::setBusInterface(busInterface);
}

shared_ptr<BusInterface>
LoadInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM::getBusInterface();
}

void
LoadInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  setVoltageLevelInterface(voltageLevelInterface);
}

bool
LoadInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM::getInitialConnected();
}

double
LoadInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM::getP();
}

double
LoadInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM::getQ();
}

double
LoadInterfaceIIDM::getP0() {
  return loadIIDM_.getP0();
}

double
LoadInterfaceIIDM::getQ0() {
  return loadIIDM_.getQ0();
}

double
LoadInterfaceIIDM::getPUnderVoltage() {
  return loadPUnderV_;
}

}  // namespace DYN
