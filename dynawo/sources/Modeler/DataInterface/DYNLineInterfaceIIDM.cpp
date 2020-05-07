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
 * @file  DYNLineInterfaceIIDM.cpp
 *
 * @brief Line data interface : implementation file for IIDM interface
 *
 */
#include <IIDM/components/Line.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/BasicTypes.h>

#include "DYNCommon.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNStateVariable.h"
#include "DYNModelConstants.h"

#include "DYNTrace.h"

using boost::shared_ptr;
using std::string;
using std::vector;

namespace DYN {

LineInterfaceIIDM::LineInterfaceIIDM(IIDM::Line& line) :
lineIIDM_(line),
initialConnected1_(boost::none),
initialConnected2_(boost::none) {
  setType(ComponentInterface::LINE);
  stateVariables_.resize(5);
  stateVariables_[VAR_P1] = StateVariable("p1", StateVariable::DOUBLE);  // P1
  stateVariables_[VAR_P2] = StateVariable("p2", StateVariable::DOUBLE);  // P2
  stateVariables_[VAR_Q1] = StateVariable("q1", StateVariable::DOUBLE);  // Q1
  stateVariables_[VAR_Q2] = StateVariable("q2", StateVariable::DOUBLE);  // Q2
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
}

LineInterfaceIIDM::~LineInterfaceIIDM() {
}

void
LineInterfaceIIDM::setBusInterface1(const shared_ptr<BusInterface>& busInterface) {
  busInterface1_ = busInterface;
}

void
LineInterfaceIIDM::setVoltageLevelInterface1(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface1_ = voltageLevelInterface;
}

void
LineInterfaceIIDM::setBusInterface2(const shared_ptr<BusInterface>& busInterface) {
  busInterface2_ = busInterface;
}

void
LineInterfaceIIDM::setVoltageLevelInterface2(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface2_ = voltageLevelInterface;
}

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
  if (lineIIDM_.has_connection(IIDM::side_1)) {
    return lineIIDM_.voltageLevel1().nominalV();
  }
  return 0;
}

double
LineInterfaceIIDM::getVNom2() const {
  if (lineIIDM_.has_connection(IIDM::side_2)) {
    return lineIIDM_.voltageLevel2().nominalV();
  }
  return 0;
}

double
LineInterfaceIIDM::getR() const {
  return lineIIDM_.r();
}

double
LineInterfaceIIDM::getX() const {
  if (doubleIsZero(lineIIDM_.x()) && doubleIsZero(lineIIDM_.r())) {
    Trace::warn() << DYNLog(PossibleDivisionByZero, lineIIDM_.id()) << Trace::endline;
    return 0.01;  // default parameter
  }
  return lineIIDM_.x();
}

double
LineInterfaceIIDM::getB1() const {
  return lineIIDM_.b1();
}

double
LineInterfaceIIDM::getB2() const {
  return lineIIDM_.b2();
}

double
LineInterfaceIIDM::getG1() const {
  return lineIIDM_.g1();
}

double
LineInterfaceIIDM::getG2() const {
  return lineIIDM_.g2();
}

double
LineInterfaceIIDM::getP1() {
  double P = 0;
  if (getInitialConnected1()) {
    if (!lineIIDM_.has_p1()) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.id(), "P1") << Trace::endline;
    } else {
      P = lineIIDM_.p1();
    }
  }
  return P;
}

double
LineInterfaceIIDM::getQ1() {
  double Q = 0;
  if (getInitialConnected1()) {
    if (!lineIIDM_.has_q1()) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.id(), "Q1") << Trace::endline;
    } else {
      Q = lineIIDM_.q1();
    }
  }
  return Q;
}

double
LineInterfaceIIDM::getP2() {
  double P = 0;
  if (getInitialConnected2()) {
    if (!lineIIDM_.has_p2()) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.id(), "P2") << Trace::endline;
    } else {
      P = lineIIDM_.p2();
    }
  }
  return P;
}

double
LineInterfaceIIDM::getQ2() {
  double Q = 0;
  if (getInitialConnected2()) {
    if (!lineIIDM_.has_q2()) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "line", lineIIDM_.id(), "Q2") << Trace::endline;
    } else {
      Q = lineIIDM_.q2();
    }
  }
  return Q;
}

bool
LineInterfaceIIDM::getInitialConnected1() {
  if (initialConnected1_ == boost::none) {
    initialConnected1_ = false;
    if (lineIIDM_.has_connection(IIDM::side_1)) {
      if (lineIIDM_.connection(IIDM::side_1)->is_bus()) {
        initialConnected1_ = lineIIDM_.isConnected(IIDM::side_1);
      } else {
        initialConnected1_ = voltageLevelInterface1_->isNodeConnected(lineIIDM_.connection(IIDM::side_1)->node());
      }
    }
  }
  return initialConnected1_.value();
}

bool
LineInterfaceIIDM::getInitialConnected2() {
  if (initialConnected2_ == boost::none) {
    initialConnected2_ = false;
    if (lineIIDM_.has_connection(IIDM::side_2)) {
      if (lineIIDM_.connection(IIDM::side_2)->is_bus()) {
        initialConnected2_ = lineIIDM_.isConnected(IIDM::side_2);
      } else {
        initialConnected2_ = voltageLevelInterface2_->isNodeConnected(lineIIDM_.connection(IIDM::side_2)->node());
      }
    }
  }
  return initialConnected2_.value();
}

string
LineInterfaceIIDM::getID() const {
  return lineIIDM_.id();
}

void
LineInterfaceIIDM::addCurrentLimitInterface1(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces1_.push_back(currentLimitInterface);
}

void
LineInterfaceIIDM::addCurrentLimitInterface2(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces2_.push_back(currentLimitInterface);
}

vector<shared_ptr<CurrentLimitInterface> >
LineInterfaceIIDM::getCurrentLimitInterfaces1() const {
  return currentLimitInterfaces1_;
}

vector<shared_ptr<CurrentLimitInterface> >
LineInterfaceIIDM::getCurrentLimitInterfaces2() const {
  return currentLimitInterfaces2_;
}

int
LineInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "p1" )
    index = VAR_P1;
  else if ( varName == "q1" )
    index = VAR_Q1;
  else if ( varName == "p2" )
    index = VAR_P2;
  else if ( varName == "q2" )
    index = VAR_Q2;
  else if ( varName == "state" )
    index = VAR_STATE;
  return index;
}

void
LineInterfaceIIDM::exportStateVariablesUnitComponent() {
  int state = getValue<int>(VAR_STATE);
  lineIIDM_.p1(getValue<double>(VAR_P1) * SNREF);
  lineIIDM_.q1(getValue<double>(VAR_Q1) * SNREF);
  lineIIDM_.p2(getValue<double>(VAR_P2) * SNREF);
  lineIIDM_.q2(getValue<double>(VAR_Q2) * SNREF);

  bool connected1 = (state == CLOSED) || (state == CLOSED_1);
  bool connected2 = (state == CLOSED) || (state == CLOSED_2);

  if (lineIIDM_.has_connection(IIDM::side_1)) {
    if (lineIIDM_.connection(IIDM::side_1)->is_bus()) {
      if (connected1)
        lineIIDM_.connect(IIDM::side_1);
      else
        lineIIDM_.disconnect(IIDM::side_1);
    } else {  // is _node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected1 && !getInitialConnected1())
        voltageLevelInterface1_->connectNode(lineIIDM_.connection(IIDM::side_1)->node());
      else if (!connected1 && getInitialConnected1())
        voltageLevelInterface1_->disconnectNode(lineIIDM_.connection(IIDM::side_1)->node());
    }
  }

  if (lineIIDM_.has_connection(IIDM::side_2)) {
    if (lineIIDM_.connection(IIDM::side_2)->is_bus()) {
      if (connected2)
        lineIIDM_.connect(IIDM::side_2);
      else
        lineIIDM_.disconnect(IIDM::side_2);
    } else {   // is_node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected2 && !getInitialConnected2())
        voltageLevelInterface2_->connectNode(lineIIDM_.connection(IIDM::side_2)->node());
      else if (!connected2 && getInitialConnected2())
        voltageLevelInterface2_->disconnectNode(lineIIDM_.connection(IIDM::side_2)->node());
    }
  }
}

void
LineInterfaceIIDM::importStaticParameters() {
  // no static parameter
}

}  // namespace DYN
