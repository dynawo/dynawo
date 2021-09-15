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
 * @file  DYNShuntCompensatorInterfaceIIDM.cpp
 *
 * @brief Shunt Compensator data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include <IIDM/components/ShuntCompensator.h>

#include "DYNShuntCompensatorInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

ShuntCompensatorInterfaceIIDM::~ShuntCompensatorInterfaceIIDM() {
}

ShuntCompensatorInterfaceIIDM::ShuntCompensatorInterfaceIIDM(IIDM::ShuntCompensator& shunt) :
InjectorInterfaceIIDM<IIDM::ShuntCompensator>(shunt, shunt.id()),
shuntCompensatorIIDM_(shunt) {
  setType(ComponentInterface::SHUNT);
  stateVariables_.resize(3);
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
  stateVariables_[VAR_CURRENTSECTION] = StateVariable("currentSection", StateVariable::INT);   // currentSection
}

int
ShuntCompensatorInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "currentSection" )
    index = VAR_CURRENTSECTION;
  else if ( varName == "q" )
    index = VAR_Q;
  else if ( varName == "state" )
    index = VAR_STATE;
  return index;
}

void
ShuntCompensatorInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  shuntCompensatorIIDM_.q(getValue<double>(VAR_Q) * SNREF);
  shuntCompensatorIIDM_.currentSection(getValue<int>(VAR_CURRENTSECTION));

  if (shuntCompensatorIIDM_.has_connection()) {
    if (shuntCompensatorIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        shuntCompensatorIIDM_.connect();
      else
        shuntCompensatorIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(shuntCompensatorIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(shuntCompensatorIIDM_.node());
    }
  }
}

void
ShuntCompensatorInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(getQ())));
  double B = shuntCompensatorIIDM_.bPerSection();
  staticParameters_.insert(std::make_pair("isCapacitor", StaticParameter("isCapacitor", StaticParameter::BOOL).setValue(B > 0)));
}

void
ShuntCompensatorInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM<IIDM::ShuntCompensator>::setBusInterface(busInterface);
}

void
ShuntCompensatorInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::ShuntCompensator>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
ShuntCompensatorInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::ShuntCompensator>::getBusInterface();
}

bool
ShuntCompensatorInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::ShuntCompensator>::getInitialConnected();
}

bool
ShuntCompensatorInterfaceIIDM::isConnected() const {
  return InjectorInterfaceIIDM<IIDM::ShuntCompensator>::isConnected();
}

double
ShuntCompensatorInterfaceIIDM::getVNom() const {
  return InjectorInterfaceIIDM<IIDM::ShuntCompensator>::getVNom();
}

double
ShuntCompensatorInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::ShuntCompensator>::getQ();
}

string
ShuntCompensatorInterfaceIIDM::getID() const {
  return shuntCompensatorIIDM_.id();
}

int
ShuntCompensatorInterfaceIIDM::getCurrentSection() const {
  return shuntCompensatorIIDM_.currentSection();
}

int
ShuntCompensatorInterfaceIIDM::getMaximumSection() const {
  return shuntCompensatorIIDM_.maximumSection();
}

double
ShuntCompensatorInterfaceIIDM::getB(const int section) const {
  return shuntCompensatorIIDM_.bPerSection() * section;
}

bool
ShuntCompensatorInterfaceIIDM::isLinear() const {
  return true;
}

}  // namespace DYN
