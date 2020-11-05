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
 * @file  DYNShuntCompensatorInterfaceIIDM.cpp
 *
 * @brief Shunt Compensator data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include <powsybl/iidm/ShuntCompensator.hpp>

#include "DYNShuntCompensatorInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

ShuntCompensatorInterfaceIIDM::~ShuntCompensatorInterfaceIIDM() {
}

ShuntCompensatorInterfaceIIDM::ShuntCompensatorInterfaceIIDM(powsybl::iidm::ShuntCompensator& shunt) :
InjectorInterfaceIIDM(shunt, shunt.getId()),
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
  shuntCompensatorIIDM_.getTerminal().setQ(getValue<double>(VAR_Q) * SNREF);
  shuntCompensatorIIDM_.setCurrentSectionCount(getValue<int>(VAR_CURRENTSECTION));

  if (connected)
    shuntCompensatorIIDM_.getTerminal().connect();
  else
    shuntCompensatorIIDM_.getTerminal().disconnect();
}

void
ShuntCompensatorInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(getQ())));
  double B = shuntCompensatorIIDM_.getbPerSection();
  staticParameters_.insert(std::make_pair("isCapacitor", StaticParameter("isCapacitor", StaticParameter::BOOL).setValue(B > 0)));
}

void
ShuntCompensatorInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  setBusInterfaceInjector(busInterface);
}

void
ShuntCompensatorInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  setVoltageLevelInterfaceInjector(voltageLevelInterface);
}

shared_ptr<BusInterface>
ShuntCompensatorInterfaceIIDM::getBusInterface() const {
  return getBusInterfaceInjector();
}

bool
ShuntCompensatorInterfaceIIDM::getInitialConnected() {
  return getInitialConnectedInjector();
}

double
ShuntCompensatorInterfaceIIDM::getVNom() const {
  return getVNomInjector();
}

double
ShuntCompensatorInterfaceIIDM::getQ() {
  return getQInjector();
}

string
ShuntCompensatorInterfaceIIDM::getID() const {
  return shuntCompensatorIIDM_.getId();
}

int
ShuntCompensatorInterfaceIIDM::getCurrentSection() const {
  return shuntCompensatorIIDM_.getCurrentSectionCount();
}

int
ShuntCompensatorInterfaceIIDM::getMaximumSection() const {
  return shuntCompensatorIIDM_.getMaximumSectionCount();
}

double
ShuntCompensatorInterfaceIIDM::getBPerSection() const {
  return shuntCompensatorIIDM_.getbPerSection();
}

}  // namespace DYN
