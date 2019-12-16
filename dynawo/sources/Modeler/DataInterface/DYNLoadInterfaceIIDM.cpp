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
 * @file  DYNLoadInterfaceIIDM.cpp
 *
 * @brief Load data interface : implementation file for IIDM structure
 *
 */
//======================================================================

#include <IIDM/components/Load.h>

#include "DYNLoadInterfaceIIDM.h"

using boost::shared_ptr;
using std::string;

namespace DYN {

LoadInterfaceIIDM::~LoadInterfaceIIDM() {
}

LoadInterfaceIIDM::LoadInterfaceIIDM(IIDM::Load& load) :
InjectorInterfaceIIDM<IIDM::Load>(load, load.id()),
loadIIDM_(load),
loadPUnderV_(0.),
v0_(0.),
vNom_(0.) {
  setType(ComponentInterface::LOAD);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
}

int
LoadInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
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
LoadInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  loadIIDM_.p(getValue<double>(VAR_P) * SNREF);
  loadIIDM_.q(getValue<double>(VAR_Q) * SNREF);

  if (loadIIDM_.has_connection()) {
    if (loadIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        loadIIDM_.connect();
      else
        loadIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(loadIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(loadIIDM_.node());
    }
  }
}

bool
LoadInterfaceIIDM::checkCriteria(bool checkEachIter) {
  loadPUnderV_ = 0;
  if (busInterface_) {
    double v = busInterface_->getStateVarV();

    if (checkEachIter) {
      if ( vNom_ < 100 && v0_ > 0.2 && v < 0.85 * vNom_)
        loadPUnderV_ = getP();
    } else {
      if (v0_ > 0.2 && v < 0.92 * vNom_)
        loadPUnderV_ = getP();
    }
  }
  return true;
}

void
LoadInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  double P = getP();
  double Q = getQ();
  double SN = SNREF;
  SN = 1.5 * sqrt(P * P + Q * Q);
  SN = (SN < SNREF ? SNREF : SN);

  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(P / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(Q / SNREF)));
  staticParameters_.insert(std::make_pair("sn_pu", StaticParameter("sn_pu", StaticParameter::DOUBLE).setValue(SN / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(P)));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(Q)));
  staticParameters_.insert(std::make_pair("sn", StaticParameter("sn", StaticParameter::DOUBLE).setValue(SN)));

  if (busInterface_ && loadIIDM_.has_voltageLevel()) {
    v0_ = busInterface_->getV0();
    if (loadIIDM_.voltageLevel().nominalV() > 0)
      vNom_ = loadIIDM_.voltageLevel().nominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, loadIIDM_.voltageLevel().id());
    double teta = busInterface_->getAngle0();
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
  InjectorInterfaceIIDM<IIDM::Load>::setBusInterface(busInterface);
}

void
LoadInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::Load>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
LoadInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::Load>::getBusInterface();
}

bool
LoadInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::Load>::getInitialConnected();
}

double
LoadInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::Load>::getP();
}

double
LoadInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::Load>::getQ();
}

string
LoadInterfaceIIDM::getID() const {
  return loadIIDM_.id();
}

double
LoadInterfaceIIDM::getPUnderVoltage() {
  return loadPUnderV_;
}

}  // namespace DYN
