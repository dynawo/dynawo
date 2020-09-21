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

/**
 * @file  DYNBusInterfaceIIDM.cpp
 *
 * @brief Bus data interface  : implementation file for IIDM interface
 *
 */
#include <cmath>  // M_PI

#include <IIDM/components/Bus.h>
#include <IIDM/components/VoltageLevel.h>
#include "DYNBusInterfaceIIDM.h"
#include "DYNCommonConstants.h"
#include "DYNStateVariable.h"
#include "DYNTrace.h"
using boost::shared_ptr;
using std::string;

namespace DYN {

BusInterfaceIIDM::BusInterfaceIIDM(IIDM::Bus& bus) :
busIIDM_(bus),
hasConnection_(false) {
  setType(ComponentInterface::BUS);
  if (busIIDM_.has_v())
    U0_ = busIIDM_.v();

  if (busIIDM_.has_angle())
    angle0_ = busIIDM_.angle();

  stateVariables_.resize(2);
  bool neededForCriteriaCheck = true;
  stateVariables_[VAR_V] = StateVariable("v", StateVariable::DOUBLE, neededForCriteriaCheck);  // V
  stateVariables_[VAR_ANGLE] = StateVariable("angle", StateVariable::DOUBLE);  // angle
}

BusInterfaceIIDM::~BusInterfaceIIDM() {
}

string
BusInterfaceIIDM::getID() const {
  return busIIDM_.id();
}

double
BusInterfaceIIDM::getVMax() const {
  if (!busIIDM_.voltageLevel().has_highVoltageLimit()) {
    return uMaxPu * getVNom();   // default data
  }
  return busIIDM_.voltageLevel().highVoltageLimit();
}

double
BusInterfaceIIDM::getVMin() const {
  if (!busIIDM_.voltageLevel().has_lowVoltageLimit()) {
    return uMinPu * getVNom();   // default data
  }
  return busIIDM_.voltageLevel().lowVoltageLimit();
}

double
BusInterfaceIIDM::getV0() const {
  if (!U0_) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Bus", busIIDM_.id(), "v") << Trace::endline;
    return defaultV0;
  }
  return U0_.value();
}

double
BusInterfaceIIDM::getAngle0() const {
  if (!angle0_) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "Bus", busIIDM_.id(), "angle") << Trace::endline;
    return defaultAngle0;
  }
  return angle0_.value();
}

double
BusInterfaceIIDM::getVNom() const {
  if ( busIIDM_.voltageLevel().nominalV() > 0)
    return busIIDM_.voltageLevel().nominalV();
  else
    throw DYNError(Error::MODELER, UndefinedNominalV, busIIDM_.voltageLevel().id());
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
  busIIDM_.v(getStateVarV());
  busIIDM_.angle(getStateVarAngle());
}

void
BusInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("U", StaticParameter("U", StaticParameter::DOUBLE).setValue(getV0())));
  staticParameters_.insert(std::make_pair("Teta", StaticParameter("Teta", StaticParameter::DOUBLE).setValue(getAngle0())));
  staticParameters_.insert(std::make_pair("Upu", StaticParameter("Upu", StaticParameter::DOUBLE).setValue(getV0() / getVNom())));
  staticParameters_.insert(std::make_pair("Teta_pu", StaticParameter("Teta_pu", StaticParameter::DOUBLE).setValue(getAngle0() * M_PI / 180)));
}

}  // namespace DYN
