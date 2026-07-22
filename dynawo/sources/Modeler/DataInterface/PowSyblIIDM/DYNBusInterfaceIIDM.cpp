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
 * @file  DYNBusInterfaceIIDM.cpp
 *
 * @brief Bus data interface  : implementation file for IIDM interface
 *
 */
#include <cmath>  // M_PI

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>
#include <powsybl/iidm/BusbarSection.hpp>
#include <powsybl/iidm/Connectable.hpp>
#include "DYNBusInterfaceIIDM.h"
#include "DYNCommonConstants.h"
#include "DYNStateVariable.h"
#include "DYNTrace.h"
#include "DYNCommon.h"
using boost::shared_ptr;
using powsybl::iidm::Bus;
using std::string;

namespace DYN {

BusInterfaceIIDM::BusInterfaceIIDM(Bus& bus) :
BusInterface(false),
busIIDM_(bus),
hasConnection_(false) {
  setType(ComponentInterface::BUS);
  if (!std::isnan(busIIDM_.getV())) {
    hasInitialConditions(true);
    U0_ = busIIDM_.getV();
  }
  if (!std::isnan(busIIDM_.getAngle())) {
    hasInitialConditions(true);
    angle0_ = busIIDM_.getAngle();
  }

  stateVariables_.resize(2);
  bool neededForCriteriaCheck = true;
  stateVariables_[VAR_V] = StateVariable("v", StateVariable::DOUBLE, neededForCriteriaCheck);  // V
  stateVariables_[VAR_ANGLE] = StateVariable("angle", StateVariable::DOUBLE);  // angle
}

const std::string&
BusInterfaceIIDM::getID() const {
  return busIIDM_.getId();
}

double
BusInterfaceIIDM::getVMax() const {
  if (std::isnan(busIIDM_.getVoltageLevel().getHighVoltageLimit())) {
    return uMaxPu * getVNom();   // default data
  }
  return busIIDM_.getVoltageLevel().getHighVoltageLimit();
}

double
BusInterfaceIIDM::getVMin() const {
  if (std::isnan(busIIDM_.getVoltageLevel().getLowVoltageLimit())) {
    return uMinPu * getVNom();   // default data
  }
  return busIIDM_.getVoltageLevel().getLowVoltageLimit();
}

double
BusInterfaceIIDM::getV0() const {
  if (!U0_) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Bus", busIIDM_.getId(), "v") << Trace::endline;
    return getVNom();
  }
  return U0_.value();
}

double
BusInterfaceIIDM::getAngle0() const {
  if (!angle0_) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Bus", busIIDM_.getId(), "angle") << Trace::endline;
    return defaultAngle0;
  }
  return angle0_.value();
}

double
BusInterfaceIIDM::getVNom() const {
  return busIIDM_.getVoltageLevel().getNominalV();
}

double
BusInterfaceIIDM::getStateVarV() const {
  return getValue<double>(VAR_V);
}

double
BusInterfaceIIDM::getStateVarAngle() const {
  return getValue<double>(VAR_ANGLE);
}

void
BusInterfaceIIDM::hasConnection(bool hasConnection) {
  hasConnection_ = hasConnection;
}

bool
BusInterfaceIIDM::hasConnection() const {
  return hasConnection_;
}

int
BusInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "v" )
    index = VAR_V;
  else if ( varName == "angle" )
    index = VAR_ANGLE;
  return index;
}

void
BusInterfaceIIDM::exportStateVariablesUnitComponent() {
  // Avoid to dump any value if none whas given at init and bus stayed deconnected the whole simulation
  if (std::isnan(busIIDM_.getV()) && (getStateVarV() == 0.))
    return;

  // Also avoid to dump very small values (that can't be read by iidm library anymore) instead of 0 on some architectures
  busIIDM_.setV(doubleRounded(getStateVarV()));
  busIIDM_.setAngle(doubleRounded(getStateVarAngle()));
}

void
BusInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("U", StaticParameter("U", StaticParameter::DOUBLE).setValue(getV0())));
  staticParameters_.insert(std::make_pair("Theta", StaticParameter("Theta", StaticParameter::DOUBLE).setValue(getAngle0())));
  staticParameters_.insert(std::make_pair("Upu", StaticParameter("Upu", StaticParameter::DOUBLE).setValue(getV0() / getVNom())));
  staticParameters_.insert(std::make_pair("Theta_pu", StaticParameter("Theta_pu", StaticParameter::DOUBLE).setValue(getAngle0() * M_PI / 180)));
  staticParameters_.insert(std::make_pair("Umax", StaticParameter("Umax", StaticParameter::DOUBLE).setValue(getVMax())));
  staticParameters_.insert(std::make_pair("Umax_pu", StaticParameter("Umax_pu", StaticParameter::DOUBLE).setValue(getVMax() / getVNom())));
  staticParameters_.insert(std::make_pair("Umin", StaticParameter("Umin", StaticParameter::DOUBLE).setValue(getVMin())));
  staticParameters_.insert(std::make_pair("Umin_pu", StaticParameter("Umin_pu", StaticParameter::DOUBLE).setValue(getVMin() / getVNom())));
  staticParameters_.insert(std::make_pair("UNom", StaticParameter("UNom", StaticParameter::DOUBLE).setValue(getVNom())));
}

}  // namespace DYN
