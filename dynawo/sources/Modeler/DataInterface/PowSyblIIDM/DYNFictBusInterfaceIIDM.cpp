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
 * @file  DYNFictBusInterfaceIIDM.cpp
 *
 * @brief Fictitious Bus : implementation file to create bus from scratch
 *
 */
#include <cmath>  // M_PI

#include "DYNFictBusInterfaceIIDM.h"
#include "DYNCommonConstants.h"
#include "DYNStateVariable.h"
#include "DYNTrace.h"
using boost::shared_ptr;
using std::string;

namespace DYN {
FictBusInterfaceIIDM::FictBusInterfaceIIDM(const string& Id, double VNom, const string& country) : Id_(Id),
                                          Vnom_(VNom), hasConnection_(false),
                                          U0_(VNom), angle0_(defaultAngle0), country_(country) {
  setType(ComponentInterface::BUS);
  stateVariables_.resize(2);
  bool neededForCriteriaCheck = true;
  stateVariables_[VAR_V] = StateVariable("v", StateVariable::DOUBLE, neededForCriteriaCheck);  // V
  stateVariables_[VAR_ANGLE] = StateVariable("angle", StateVariable::DOUBLE);  // angle
}

double
FictBusInterfaceIIDM::getV0() const {
  return U0_;
}

double
FictBusInterfaceIIDM::getVMin() const {
  return Vnom_ * uMinPu;
}

double
FictBusInterfaceIIDM::getVMax() const {
  return Vnom_ * uMaxPu;
}

double
FictBusInterfaceIIDM::getAngle0() const {
  return angle0_;
}

double
FictBusInterfaceIIDM::getVNom() const {
  return Vnom_;
}

string
FictBusInterfaceIIDM::getID() const {
  return Id_;
}

void
FictBusInterfaceIIDM::hasConnection(bool hasConnection) {
  hasConnection_ = hasConnection;
}

bool
FictBusInterfaceIIDM::hasConnection() const {
  return hasConnection_;
}

void
FictBusInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("U", StaticParameter("U", StaticParameter::DOUBLE).setValue(getV0())));
  staticParameters_.insert(std::make_pair("Theta", StaticParameter("Theta", StaticParameter::DOUBLE).setValue(getAngle0())));
  staticParameters_.insert(std::make_pair("Upu", StaticParameter("Upu", StaticParameter::DOUBLE).setValue(getV0() / getVNom())));
  staticParameters_.insert(std::make_pair("Theta_pu", StaticParameter("Theta_pu", StaticParameter::DOUBLE).setValue(getAngle0() * M_PI / 180)));
}

int
FictBusInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "v" )
    index = VAR_V;
  else if ( varName == "angle" )
    index = VAR_ANGLE;
  return index;
}

}  // namespace DYN
