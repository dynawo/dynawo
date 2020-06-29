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
 * @file  DYNVscConverterInterfaceIIDM.cpp
 *
 * @brief Vsc Converter data interface : implementation file for IIDM interface
 *
 */
//======================================================================
#include <IIDM/components/VscConverterStation.h>

#include "DYNVscConverterInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

VscConverterInterfaceIIDM::~VscConverterInterfaceIIDM() {
}

VscConverterInterfaceIIDM::VscConverterInterfaceIIDM(IIDM::VscConverterStation& vsc) :
InjectorInterfaceIIDM<IIDM::VscConverterStation>(vsc, vsc.id()),
vscConverterIIDM_(vsc) {
  setType(ComponentInterface::VSC_CONVERTER);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
}

int
VscConverterInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
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
VscConverterInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  vscConverterIIDM_.p(-1 * getValue<double>(VAR_P) * SNREF);
  vscConverterIIDM_.q(-1 * getValue<double>(VAR_Q) * SNREF);

  if (vscConverterIIDM_.has_connection()) {
    if (vscConverterIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        vscConverterIIDM_.connect();
      else
        vscConverterIIDM_.disconnect();
    } else  {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(vscConverterIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(vscConverterIIDM_.node());
    }
  }
}

void
VscConverterInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(-1 * getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(-1 * getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(-1 * getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(-1 * getQ())));
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom;
    if (vscConverterIIDM_.voltageLevel().nominalV() > 0)
      vNom = vscConverterIIDM_.voltageLevel().nominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, vscConverterIIDM_.voltageLevel().id());

    double teta = busInterface_->getAngle0();
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(teta * M_PI / 180)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(teta)));
  } else {
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
  }
}

void
VscConverterInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM<IIDM::VscConverterStation>::setBusInterface(busInterface);
}

void
VscConverterInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::VscConverterStation>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
VscConverterInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getBusInterface();
}

bool
VscConverterInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getInitialConnected();
}

double
VscConverterInterfaceIIDM::getVNom() const {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getVNom();
}

bool
VscConverterInterfaceIIDM::hasP() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::hasP();
}

bool
VscConverterInterfaceIIDM::hasQ() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::hasQ();
}

double
VscConverterInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getP();
}

double
VscConverterInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getQ();
}

string
VscConverterInterfaceIIDM::getID() const {
  return vscConverterIIDM_.id();
}

double
VscConverterInterfaceIIDM::getLossFactor() const {
  return vscConverterIIDM_.lossFactor();
}

bool
VscConverterInterfaceIIDM::getVoltageRegulatorOn() const {
  return vscConverterIIDM_.voltageRegulatorOn();
}

double
VscConverterInterfaceIIDM::getReactivePowerSetpoint() const {
  if (!vscConverterIIDM_.has_reactivePowerSetpoint()) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "vscConverter", vscConverterIIDM_.id(), "ReactivePowerSetPoint") << Trace::endline;
    return 0;
  }
  return vscConverterIIDM_.reactivePowerSetpoint();
}

double
VscConverterInterfaceIIDM::getVoltageSetpoint() const {
  if (!vscConverterIIDM_.has_voltageSetpoint()) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "vscConverter", vscConverterIIDM_.id(), "VoltageSetPoint") << Trace::endline;
    return 0;
  }
  return vscConverterIIDM_.voltageSetpoint();
}

const IIDM::VscConverterStation&
VscConverterInterfaceIIDM::getVscIIDM() const {
  return vscConverterIIDM_;
}

}  // namespace DYN
