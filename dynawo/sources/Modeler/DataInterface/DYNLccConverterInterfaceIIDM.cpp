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
 * @file  DYNLccConverterInterfaceIIDM.cpp
 *
 * @brief Lcc Converter data interface : implementation file for IIDM interface
 *
 */
//======================================================================
#include <IIDM/components/LccConverterStation.h>

#include "DYNLccConverterInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

LccConverterInterfaceIIDM::~LccConverterInterfaceIIDM() {
}

LccConverterInterfaceIIDM::LccConverterInterfaceIIDM(IIDM::LccConverterStation& lcc) :
InjectorInterfaceIIDM<IIDM::LccConverterStation>(lcc, lcc.id()),
lccConverterIIDM_(lcc) {
  setType(ComponentInterface::LCC_CONVERTER);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
}

int
LccConverterInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
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
LccConverterInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  lccConverterIIDM_.p(-1 * getValue<double>(VAR_P) * SNREF);
  lccConverterIIDM_.q(-1 * getValue<double>(VAR_Q) * SNREF);

  if (lccConverterIIDM_.has_connection()) {
    if (lccConverterIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        lccConverterIIDM_.connect();
      else
        lccConverterIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(lccConverterIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(lccConverterIIDM_.node());
    }
  }
}

bool
LccConverterInterfaceIIDM::checkCriteria(bool /*checkEachIter*/) {
  return true;
}

void
LccConverterInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_["p_pu"] = StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(-1 * getP() / SNREF);
  staticParameters_["q_pu"] = StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(-1 * getQ() / SNREF);
  staticParameters_["p"] = StaticParameter("p", StaticParameter::DOUBLE).setValue(-1 * getP());
  staticParameters_["q"] = StaticParameter("q", StaticParameter::DOUBLE).setValue(-1 * getQ());
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom = lccConverterIIDM_.voltageLevel().nominalV();
    double teta = busInterface_->getAngle0();
    staticParameters_["v_pu"] = StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom);
    staticParameters_["angle_pu"] = StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(teta * M_PI / 180);
    staticParameters_["v"] = StaticParameter("v", StaticParameter::DOUBLE).setValue(U0);
    staticParameters_["angle"] = StaticParameter("angle", StaticParameter::DOUBLE).setValue(teta);
  } else {
    staticParameters_["v_pu"] = StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.);
    staticParameters_["angle_pu"] = StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.);
    staticParameters_["v"] = StaticParameter("v", StaticParameter::DOUBLE).setValue(0.);
    staticParameters_["angle"] = StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.);
  }
}

void
LccConverterInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM<IIDM::LccConverterStation>::setBusInterface(busInterface);
}

void
LccConverterInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::LccConverterStation>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
LccConverterInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::getBusInterface();
}

bool
LccConverterInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::getInitialConnected();
}

double
LccConverterInterfaceIIDM::getVNom() const {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::getVNom();
}

bool
LccConverterInterfaceIIDM::hasP() {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::hasP();
}

bool
LccConverterInterfaceIIDM::hasQ() {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::hasQ();
}

double
LccConverterInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::getP();
}

double
LccConverterInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::getQ();
}

string
LccConverterInterfaceIIDM::getID() const {
  return lccConverterIIDM_.id();
}

double
LccConverterInterfaceIIDM::getLossFactor() const {
  return lccConverterIIDM_.lossFactor();
}

double
LccConverterInterfaceIIDM::getPowerFactor() const {
  return lccConverterIIDM_.powerFactor();
}

}  // namespace DYN
