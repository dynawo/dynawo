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

#include "DYNStaticVarCompensatorInterfaceIIDM.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"
#include <dlfcn.h>
#include <iostream>

using powsybl::iidm::StaticVarCompensator;
using std::string;
using boost::shared_ptr;
using std::stringstream;

namespace DYN {

StaticVarCompensatorInterfaceIIDM::~StaticVarCompensatorInterfaceIIDM() {
  // destroy the class
  destroy_extension_(extension_);

  if (handle_) {
    dlclose(handle_);
  }
}

StaticVarCompensatorInterfaceIIDM::StaticVarCompensatorInterfaceIIDM(StaticVarCompensator& svc) :
InjectorInterfaceIIDM(svc, svc.getId()),
staticVarCompensatorIIDM_(svc) {
  setType(ComponentInterface::SVC);
  stateVariables_.resize(4);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);  // connectionState
  stateVariables_[VAR_REGULATINGMODE] = StateVariable("regulatingMode", StateVariable::INT);  // regulatingMode

  // load the library
  string lib = getEnvVar("DYNAWO_IIDM_EXTENSION");
  if (!exists(lib))
    throw DYNError(Error::STATIC_DATA, WrongExtensionPath, lib);
  handle_ = dlopen(lib.c_str(), RTLD_NOW | RTLD_LOCAL);
  if (!handle_) {
    stringstream msg;
    msg << "Load error :" << dlerror();
    Trace::error() << msg.str() << Trace::endline;
    throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib);
  }

  // reset errors
  dlerror();

  create_t* create_extension = reinterpret_cast<create_t*> (dlsym(handle_, "create"));
  const char* dlsym_error = dlerror();
  if (dlsym_error) {
    stringstream msg;
    msg << "Load error :" << dlsym_error;
    Trace::error() << msg.str() << Trace::endline;
    throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib+"::create");
  }

  destroy_extension_ = reinterpret_cast<destroy_t*> (dlsym(handle_, "destroy"));
  dlsym_error = dlerror();
  if (dlsym_error) {
    stringstream msg;
    msg << "Load error :" << dlsym_error;
    Trace::error() << msg.str() << Trace::endline;
    throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, lib+"::destroy");
  }

  // create an instance of the class
  extension_ = create_extension(svc);
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
  staticVarCompensatorIIDM_.getTerminal().setP(-1 * getValue<double>(VAR_P) * SNREF);
  staticVarCompensatorIIDM_.getTerminal().setQ(-1 * getValue<double>(VAR_Q) * SNREF);
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  int regulatingMode = getValue<int>(VAR_REGULATINGMODE);
  bool standbyMode(false);
  switch (regulatingMode) {
    case StaticVarCompensatorInterface::OFF:
      staticVarCompensatorIIDM_.setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::OFF);
      break;
    case StaticVarCompensatorInterface::STANDBY:
      standbyMode = true;
      break;
    case StaticVarCompensatorInterface::RUNNING_Q:
      staticVarCompensatorIIDM_.setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::REACTIVE_POWER);
      break;
    case StaticVarCompensatorInterface::RUNNING_V:
      staticVarCompensatorIIDM_.setRegulationMode(powsybl::iidm::StaticVarCompensator::RegulationMode::VOLTAGE);
      break;
    default:
      throw DYNError(Error::STATIC_DATA, RegulationModeNotInIIDM, regulatingMode, staticVarCompensatorIIDM_.getId());
  }
  extension_->exportStandByMode(standbyMode);

  if (getVoltageLevelInterfaceInjector()->isNodeBreakerTopology()) {
    // should be removed once a solution has been found to propagate switches (de)connection
    // following component (de)connection (only Modelica models)
    if (connected && !getInitialConnected())
      getVoltageLevelInterfaceInjector()->connectNode(staticVarCompensatorIIDM_.getTerminal().getNodeBreakerView().getNode());
    else if (!connected && getInitialConnected())
      getVoltageLevelInterfaceInjector()->disconnectNode(staticVarCompensatorIIDM_.getTerminal().getNodeBreakerView().getNode());
  }

  if (connected)
    staticVarCompensatorIIDM_.getTerminal().connect();
  else
    staticVarCompensatorIIDM_.getTerminal().disconnect();
}

void
StaticVarCompensatorInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(getPInjector())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(getQ())));
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(getPInjector() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(getQ() / SNREF)));
  int regulatingMode = getRegulationMode();
  staticParameters_.insert(std::make_pair("regulatingMode", StaticParameter("regulatingMode", StaticParameter::INT).setValue(regulatingMode)));
  if (getBusInterface()) {
    double U0 = getBusInterface()->getV0();
    double vNom;
    if (staticVarCompensatorIIDM_.getTerminal().getVoltageLevel().getNominalVoltage() > 0)
      vNom = staticVarCompensatorIIDM_.getTerminal().getVoltageLevel().getNominalVoltage();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, staticVarCompensatorIIDM_.getTerminal().getVoltageLevel().getId());

    double teta = getBusInterface()->getAngle0();
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(teta)));
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(teta * M_PI / 180)));
  } else {
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
  }
}

void
StaticVarCompensatorInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  setBusInterfaceInjector(busInterface);
}

shared_ptr<BusInterface>
StaticVarCompensatorInterfaceIIDM::getBusInterface() const {
  return getBusInterfaceInjector();
}

void
StaticVarCompensatorInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  setVoltageLevelInterfaceInjector(voltageLevelInterface);
}

bool
StaticVarCompensatorInterfaceIIDM::getInitialConnected() {
  return getInitialConnectedInjector();
}

double
StaticVarCompensatorInterfaceIIDM::getVNom() const {
  return getVNomInjector();
}

string
StaticVarCompensatorInterfaceIIDM::getID() const {
  return staticVarCompensatorIIDM_.getId();
}

double
StaticVarCompensatorInterfaceIIDM::getBMin() const {
  return staticVarCompensatorIIDM_.getBmin();
}

double
StaticVarCompensatorInterfaceIIDM::getBMax() const {
  return staticVarCompensatorIIDM_.getBmax();
}

double
StaticVarCompensatorInterfaceIIDM::getP() {
  return getPInjector();
}

double
StaticVarCompensatorInterfaceIIDM::getQ() {
  return getQInjector();
}

double
StaticVarCompensatorInterfaceIIDM::getVSetPoint() const {
  return staticVarCompensatorIIDM_.getVoltageSetpoint();
}

double
StaticVarCompensatorInterfaceIIDM::getReactivePowerSetPoint() const {
  return staticVarCompensatorIIDM_.getReactivePowerSetpoint();
}

double
StaticVarCompensatorInterfaceIIDM::getUMinActivation() const {
  return extension_->getUMinActivation();
}

double
StaticVarCompensatorInterfaceIIDM::getUMaxActivation() const {
  return extension_->getUMaxActivation();
}

double
StaticVarCompensatorInterfaceIIDM::getUSetPointMin() const {
  return extension_->getUSetPointMin();
}

double
StaticVarCompensatorInterfaceIIDM::getUSetPointMax() const {
  return extension_->getUSetPointMax();
}

bool
StaticVarCompensatorInterfaceIIDM::hasStandbyAutomaton() const {
  return extension_->hasStandbyAutomaton();
}

bool
StaticVarCompensatorInterfaceIIDM::isStandBy() const {
  return extension_->isStandBy();
}

double
StaticVarCompensatorInterfaceIIDM::getB0() const {
  return extension_->getB0();
}

StaticVarCompensatorInterface::RegulationMode_t StaticVarCompensatorInterfaceIIDM::getRegulationMode() const {
  if (extension_->isStandBy()) {
    return StaticVarCompensatorInterface::STANDBY;
  }

  const powsybl::iidm::StaticVarCompensator::RegulationMode& regMode = staticVarCompensatorIIDM_.getRegulationMode();
  switch (regMode) {
    case powsybl::iidm::StaticVarCompensator::RegulationMode::VOLTAGE:
      return StaticVarCompensatorInterface::RUNNING_V;
    case powsybl::iidm::StaticVarCompensator::RegulationMode::REACTIVE_POWER:
      return StaticVarCompensatorInterface::RUNNING_Q;
    case powsybl::iidm::StaticVarCompensator::RegulationMode::OFF:
      return StaticVarCompensatorInterface::OFF;
    default:
      return StaticVarCompensatorInterface::OFF;
  }
}

}  // namespace DYN
