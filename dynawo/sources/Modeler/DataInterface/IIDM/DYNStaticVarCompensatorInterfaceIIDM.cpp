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
 * @file  DYNStaticVarCompensatorInterfaceIIDM.cpp
 *
 * @brief Static Var Compensator data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include <IIDM/components/StaticVarCompensator.h>

#include <IIDM/extensions/StandbyAutomaton.h>

#include "DYNStaticVarCompensatorInterfaceIIDM.h"


using IIDM::extensions::standbyautomaton::StandbyAutomaton;
using std::string;
using boost::shared_ptr;

namespace DYN {

StaticVarCompensatorInterfaceIIDM::~StaticVarCompensatorInterfaceIIDM() {
}

StaticVarCompensatorInterfaceIIDM::StaticVarCompensatorInterfaceIIDM(IIDM::StaticVarCompensator& svc) :
InjectorInterfaceIIDM<IIDM::StaticVarCompensator>(svc, svc.id()),
staticVarCompensatorIIDM_(svc) {
  setType(ComponentInterface::SVC);
  sa_ = staticVarCompensatorIIDM_.findExtension<StandbyAutomaton>();
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);  // connectionState
  if (sa_) {
    stateVariables_.resize(4);
    stateVariables_[VAR_REGULATINGMODE] = StateVariable("regulatingMode", StateVariable::INT);  // regulatingMode
  }
}

int
StaticVarCompensatorInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "p" )
    index = VAR_P;
  else if ( varName == "q" )
    index = VAR_Q;
  else if ( varName == "state" )
    index = VAR_STATE;
  else if ( varName == "regulatingMode" )
    index = VAR_REGULATINGMODE;
  return index;
}

void
StaticVarCompensatorInterfaceIIDM::exportStateVariablesUnitComponent() {
  staticVarCompensatorIIDM_.p(-1 * getValue<double>(VAR_P)* SNREF);
  staticVarCompensatorIIDM_.q(-1 * getValue<double>(VAR_Q)* SNREF);
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  bool standbyMode(false);
  if (hasStandbyAutomaton()) {
    int regulatingMode = getValue<int>(VAR_REGULATINGMODE);
    switch (regulatingMode) {
      case StaticVarCompensatorInterface::OFF:
        staticVarCompensatorIIDM_.regulationMode(IIDM::StaticVarCompensator::regulation_off);
        break;
      case StaticVarCompensatorInterface::STANDBY:
        standbyMode = true;
        break;
      case StaticVarCompensatorInterface::RUNNING_Q:
        staticVarCompensatorIIDM_.regulationMode(IIDM::StaticVarCompensator::regulation_reactive_power);
        break;
      case StaticVarCompensatorInterface::RUNNING_V:
        staticVarCompensatorIIDM_.regulationMode(IIDM::StaticVarCompensator::regulation_voltage);
        break;
      default:
        throw DYNError(Error::STATIC_DATA, RegulationModeNotInIIDM, regulatingMode, staticVarCompensatorIIDM_.id());
    }
    if (sa_) {
      sa_->standBy(standbyMode);
    } else {
      if (standbyMode)
        throw DYNError(Error::STATIC_DATA, NoExtension, "standbyMode", "StandbyAutomaton");
    }
  }
  if (staticVarCompensatorIIDM_.has_connection()) {
    if (staticVarCompensatorIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        staticVarCompensatorIIDM_.connect();
      else
        staticVarCompensatorIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(staticVarCompensatorIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(staticVarCompensatorIIDM_.node());
    }
  }
}

void
StaticVarCompensatorInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(getQ())));
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(getQ() / SNREF)));
  int regulatingMode = getRegulationMode();
  staticParameters_.insert(std::make_pair("regulatingMode", StaticParameter("regulatingMode", StaticParameter::INT).setValue(regulatingMode)));
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom;
    if (staticVarCompensatorIIDM_.voltageLevel().nominalV() > 0)
      vNom = staticVarCompensatorIIDM_.voltageLevel().nominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, staticVarCompensatorIIDM_.voltageLevel().id());

    double theta = busInterface_->getAngle0();
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(theta)));
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(theta * M_PI / 180)));
  } else {
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
  }
}

void
StaticVarCompensatorInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::setBusInterface(busInterface);
}

void
StaticVarCompensatorInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
StaticVarCompensatorInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::getBusInterface();
}

bool
StaticVarCompensatorInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::getInitialConnected();
}

bool
StaticVarCompensatorInterfaceIIDM::isConnected() const {
  return InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::isConnected();
}

double
StaticVarCompensatorInterfaceIIDM::getVNom() const {
  return InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::getVNom();
}

string
StaticVarCompensatorInterfaceIIDM::getID() const {
  return staticVarCompensatorIIDM_.id();
}

double
StaticVarCompensatorInterfaceIIDM::getBMin() const {
  return staticVarCompensatorIIDM_.bmin();
}

double
StaticVarCompensatorInterfaceIIDM::getBMax() const {
  return staticVarCompensatorIIDM_.bmax();
}

double
StaticVarCompensatorInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::getP();
}

double
StaticVarCompensatorInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::StaticVarCompensator>::getQ();
}

bool
StaticVarCompensatorInterfaceIIDM::hasVoltagePerReactivePowerControl() const {
  return false;
}

double
StaticVarCompensatorInterfaceIIDM::getSlope() const {
  return 0.;
}

double
StaticVarCompensatorInterfaceIIDM::getVSetPoint() const {
  if (!staticVarCompensatorIIDM_.has_voltageSetPoint()) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "staticVarCompensator", staticVarCompensatorIIDM_.id(), "VSetPoint") << Trace::endline;
    return 0;
  }
  return staticVarCompensatorIIDM_.voltageSetPoint();
}

double
StaticVarCompensatorInterfaceIIDM::getReactivePowerSetPoint() const {
  if (!staticVarCompensatorIIDM_.has_reactivePowerSetPoint()) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "staticVarCompensator", staticVarCompensatorIIDM_.id(), "ReactivePowerSetPoint") << Trace::endline;
    return 0;
  }
  return staticVarCompensatorIIDM_.reactivePowerSetPoint();
}

double
StaticVarCompensatorInterfaceIIDM::getUMinActivation() const {
  if (!sa_)
    throw DYNError(Error::STATIC_DATA, NoExtension, "lowVoltageThreshold", "StandbyAutomaton");
  return sa_->lowVoltageThreshold();
}

double
StaticVarCompensatorInterfaceIIDM::getUMaxActivation() const {
  if (!sa_)
    throw DYNError(Error::STATIC_DATA, NoExtension, "highVoltageThreshold", "StandbyAutomaton");
  return sa_->highVoltageThreshold();
}

double
StaticVarCompensatorInterfaceIIDM::getUSetPointMin() const {
  if (!sa_)
    throw DYNError(Error::STATIC_DATA, NoExtension, "lowVoltageSetPoint", "StandbyAutomaton");
  return sa_->lowVoltageSetPoint();
}

double
StaticVarCompensatorInterfaceIIDM::getUSetPointMax() const {
  if (!sa_)
    throw DYNError(Error::STATIC_DATA, NoExtension, "highVoltageSetPoint", "StandbyAutomaton");
  return sa_->highVoltageSetPoint();
}

bool
StaticVarCompensatorInterfaceIIDM::hasStandbyAutomaton() const {
  if (!sa_)
    return false;
  return true;
}

bool
StaticVarCompensatorInterfaceIIDM::isStandBy() const {
  if (!sa_)
    throw DYNError(Error::STATIC_DATA, NoExtension, "standBy", "StandbyAutomaton");
  return sa_->standBy();
}

double
StaticVarCompensatorInterfaceIIDM::getB0() const {
  if (!sa_)
    throw DYNError(Error::STATIC_DATA, NoExtension, "b0", "StandbyAutomaton");
  return sa_->b0();
}

StaticVarCompensatorInterface::RegulationMode_t StaticVarCompensatorInterfaceIIDM::getRegulationMode() const {
  if (sa_ && sa_->standBy()) {
    return StaticVarCompensatorInterface::STANDBY;
  }

  IIDM::StaticVarCompensator::e_regulation_mode regMode = staticVarCompensatorIIDM_.regulationMode();
  switch (regMode) {
    case IIDM::StaticVarCompensator::regulation_voltage:
      return StaticVarCompensatorInterface::RUNNING_V;
    case IIDM::StaticVarCompensator::regulation_reactive_power:
      return StaticVarCompensatorInterface::RUNNING_Q;
    case IIDM::StaticVarCompensator::regulation_off:
      return StaticVarCompensatorInterface::OFF;
    default:
      return StaticVarCompensatorInterface::OFF;
  }
}

}  // namespace DYN
