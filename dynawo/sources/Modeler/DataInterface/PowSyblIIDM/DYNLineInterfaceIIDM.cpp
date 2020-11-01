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
 * @file  DYNLineInterfaceIIDM.cpp
 *
 * @brief Line data interface : implementation file for IIDM interface
 *
 */

#include "DYNLineInterfaceIIDM.h"

#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Line.hpp>
#include <powsybl/iidm/VoltageLevel.hpp>

#include "DYNCommon.h"
#include "DYNModelConstants.h"
#include "DYNStateVariable.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNTrace.h"

using boost::shared_ptr;

namespace DYN {

LineInterfaceIIDM::LineInterfaceIIDM(powsybl::iidm::Line& line) : lineIIDM_(line),
                                                                  initialConnected1_(boost::none),
                                                                  initialConnected2_(boost::none) {
  setType(ComponentInterface::LINE);
  stateVariables_.resize(5);
  stateVariables_[VAR_P1] = StateVariable("p1", StateVariable::DOUBLE);     // P1
  stateVariables_[VAR_P2] = StateVariable("p2", StateVariable::DOUBLE);     // P2
  stateVariables_[VAR_Q1] = StateVariable("q1", StateVariable::DOUBLE);     // Q1
  stateVariables_[VAR_Q2] = StateVariable("q2", StateVariable::DOUBLE);     // Q2
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);  // connectionState
}

LineInterfaceIIDM::~LineInterfaceIIDM() {
}

void
LineInterfaceIIDM::setBusInterface1(const shared_ptr<BusInterface>& busInterface) {
  busInterface1_ = busInterface;
}

void
LineInterfaceIIDM::setBusInterface2(const shared_ptr<BusInterface>& busInterface) {
  busInterface2_ = busInterface;
}
/*
void
LineInterfaceIIDM::setVoltageLevelInterface1(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface1_ = voltageLevelInterface;
}

void
LineInterfaceIIDM::setVoltageLevelInterface2(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface2_ = voltageLevelInterface;
}
*/
shared_ptr<BusInterface>
LineInterfaceIIDM::getBusInterface1() const {
  return busInterface1_;
}

shared_ptr<BusInterface>
LineInterfaceIIDM::getBusInterface2() const {
  return busInterface2_;
}

double
LineInterfaceIIDM::getVNom1() const {
  if (lineIIDM_.getTerminal1().isConnected()) {
    return lineIIDM_.getTerminal1().getVoltageLevel().getNominalVoltage();
// DG: Or maybe "return voltageLevelInterface1_.get()->getVNom();"
// DG: But that does only work if a setVoltageLevelInterface1() has been called before. ctor does not set the voltageLevelInterface1_
// DG; which is "buggous". We must consider voltageLevelInterface1_ useless at all: it is set but nothing calls it, no getSomething().
// DG; I would have get rid of the voltageLevelInterface1_ stuff if there was not a pure virtual method based ont it... TODO
  }
  return 0.0;
}

double
LineInterfaceIIDM::getVNom2() const {
  if (lineIIDM_.getTerminal2().isConnected()) {
    return lineIIDM_.getTerminal2().getVoltageLevel().getNominalVoltage();
  }
  return 0.0;
}

double
LineInterfaceIIDM::getR() const {
  return lineIIDM_.getR();
}

double
LineInterfaceIIDM::getX() const {
  if (doubleIsZero(lineIIDM_.getX()) && doubleIsZero(lineIIDM_.getR())) {
    Trace::warn() << DYNLog(PossibleDivisionByZero, lineIIDM_.getId()) << Trace::endline;
    return 0.01;  // default parameter
  }
  return lineIIDM_.getX();
}

double
LineInterfaceIIDM::getB1() const {
  return lineIIDM_.getB1();
}

double
LineInterfaceIIDM::getB2() const {
  return lineIIDM_.getB2();
}

double
LineInterfaceIIDM::getG1() const {
  return lineIIDM_.getG1();
}

double
LineInterfaceIIDM::getG2() const {
  return lineIIDM_.getG2();
}

double
LineInterfaceIIDM::getP1() {
  double P = 0.0;
  if (getInitialConnected1()) {
    if (std::isnan(lineIIDM_.getTerminal1().getP())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.getId(), "P1") << Trace::endline;
    } else {
      P = lineIIDM_.getTerminal1().getP();
    }
  }
  return P;
}

double
LineInterfaceIIDM::getQ1() {
  double Q = 0.0;
  if (getInitialConnected1()) {
    if (std::isnan(lineIIDM_.getTerminal1().getQ())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.getId(), "Q1") << Trace::endline;
    } else {
      Q = lineIIDM_.getTerminal1().getQ();
    }
  }
  return Q;
}

double
LineInterfaceIIDM::getP2() {
  double P = 0.0;
  if (getInitialConnected2()) {
    if (std::isnan(lineIIDM_.getTerminal2().getP())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.getId(), "P2") << Trace::endline;
    } else {
      P = lineIIDM_.getTerminal2().getP();
    }
  }
  return P;
}

double
LineInterfaceIIDM::getQ2() {
  double Q = 0.0;
  if (getInitialConnected2()) {
    if (std::isnan(lineIIDM_.getTerminal2().getQ())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.getId(), "Q2") << Trace::endline;
    } else {
      Q = lineIIDM_.getTerminal2().getQ();
    }
  }
  return Q;
}

bool
LineInterfaceIIDM::getInitialConnected1() {
  if (initialConnected1_ == boost::none) {
    initialConnected1_ = lineIIDM_.getTerminal1().isConnected();
  }
  return initialConnected1_.value();
}

bool
LineInterfaceIIDM::getInitialConnected2() {
  if (initialConnected2_ == boost::none) {
    initialConnected2_ = lineIIDM_.getTerminal2().isConnected();
  }
  return initialConnected2_.value();
}

std::string
LineInterfaceIIDM::getID() const {
  return lineIIDM_.getId();
}

void
LineInterfaceIIDM::addCurrentLimitInterface1(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces1_.push_back(currentLimitInterface);
}

void
LineInterfaceIIDM::addCurrentLimitInterface2(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces2_.push_back(currentLimitInterface);
}

std::vector<shared_ptr<CurrentLimitInterface> >
LineInterfaceIIDM::getCurrentLimitInterfaces1() const {
  return currentLimitInterfaces1_;
}

std::vector<shared_ptr<CurrentLimitInterface> >
LineInterfaceIIDM::getCurrentLimitInterfaces2() const {
  return currentLimitInterfaces2_;
}

int
LineInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if (varName == "p1")
    index = VAR_P1;
  else if (varName == "q1")
    index = VAR_Q1;
  else if (varName == "p2")
    index = VAR_P2;
  else if (varName == "q2")
    index = VAR_Q2;
  else if (varName == "state")
    index = VAR_STATE;
  return index;
}

void
LineInterfaceIIDM::exportStateVariablesUnitComponent() {
  int state = getValue<int>(VAR_STATE);

  lineIIDM_.getTerminal1().setP(getValue<double>(VAR_P1) * SNREF);
  lineIIDM_.getTerminal1().setQ(getValue<double>(VAR_Q1) * SNREF);
  lineIIDM_.getTerminal2().setP(getValue<double>(VAR_P2) * SNREF);
  lineIIDM_.getTerminal2().setQ(getValue<double>(VAR_Q2) * SNREF);

  bool connected1 = (state == CLOSED) || (state == CLOSED_1);
  bool connected2 = (state == CLOSED) || (state == CLOSED_2);

  if (lineIIDM_.getTerminal1().isConnected()) {
    if (connected1)
      lineIIDM_.getTerminal1().connect();
    else
      lineIIDM_.getTerminal1().disconnect();
  }

  if (lineIIDM_.getTerminal2().isConnected()) {
    if (connected2)
      lineIIDM_.getTerminal2().connect();
    else
      lineIIDM_.getTerminal2().disconnect();
  }
}

void
LineInterfaceIIDM::importStaticParameters() {
  // no static parameter
}

}  // namespace DYN
