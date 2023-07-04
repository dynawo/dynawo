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
 * @file  DYNTwoWTransformerInterfaceIIDM.cpp
 *
 * @brief Two windings transformer data interface : implementation file for IIDM implementation
 *
 */

#include "DYNTwoWTransformerInterfaceIIDM.h"

#include <powsybl/iidm/TwoWindingsTransformer.hpp>

#include "DYNCommon.h"
#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNStepInterfaceIIDM.h"
#include "DYNBusInterface.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNStateVariable.h"
#include "DYNModelConstants.h"

#include "DYNTrace.h"

using boost::shared_ptr;
using std::string;
using std::vector;

namespace DYN {

TwoWTransformerInterfaceIIDM::TwoWTransformerInterfaceIIDM(powsybl::iidm::TwoWindingsTransformer& tfo) :
    tfoIIDM_(tfo),
    initialConnected1_(boost::none),
    initialConnected2_(boost::none) {
  setType(ComponentInterface::TWO_WTFO);
  if (tfo.hasRatioTapChanger() || tfo.hasPhaseTapChanger())
    stateVariables_.resize(6);
  else
    stateVariables_.resize(5);
  stateVariables_[VAR_P1] = StateVariable("p1", StateVariable::DOUBLE);  // P1
  stateVariables_[VAR_P2] = StateVariable("p2", StateVariable::DOUBLE);  // P2
  stateVariables_[VAR_Q1] = StateVariable("q1", StateVariable::DOUBLE);  // Q1
  stateVariables_[VAR_Q2] = StateVariable("q2", StateVariable::DOUBLE);  // Q2
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);  // connectionState
  if (tfo.hasRatioTapChanger() || tfo.hasPhaseTapChanger())
    stateVariables_[VAR_TAPINDEX] = StateVariable("tapIndex", StateVariable::INT);

  auto libPath = IIDMExtensions::findLibraryPath();
  auto activeSeasonExtensionDef = IIDMExtensions::getExtension<ActiveSeasonIIDMExtension>(libPath.generic_string());
  activeSeasonExtension_ = std::get<IIDMExtensions::CREATE_FUNCTION>(activeSeasonExtensionDef)(tfo);
  destroyActiveSeasonExtension_ = std::get<IIDMExtensions::DESTROY_FUNCTION>(activeSeasonExtensionDef);
}

TwoWTransformerInterfaceIIDM::~TwoWTransformerInterfaceIIDM() {
  destroyActiveSeasonExtension_(activeSeasonExtension_);
}

void
TwoWTransformerInterfaceIIDM::setBusInterface1(const shared_ptr<BusInterface>& busInterface) {
  busInterface1_ = busInterface;
}

void
TwoWTransformerInterfaceIIDM::setVoltageLevelInterface1(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface1_ = voltageLevelInterface;
}

void
TwoWTransformerInterfaceIIDM::setBusInterface2(const shared_ptr<BusInterface>& busInterface) {
  busInterface2_ = busInterface;
}

void
TwoWTransformerInterfaceIIDM::setVoltageLevelInterface2(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface2_ = voltageLevelInterface;
}

shared_ptr<BusInterface>
TwoWTransformerInterfaceIIDM::getBusInterface1() const {
  return busInterface1_;
}

shared_ptr<BusInterface>
TwoWTransformerInterfaceIIDM::getBusInterface2() const {
  return busInterface2_;
}

string
TwoWTransformerInterfaceIIDM::getID() const {
  return tfoIIDM_.getId();
}

bool
TwoWTransformerInterfaceIIDM::getInitialConnected1() {
  if (initialConnected1_ == boost::none)
    initialConnected1_ = isConnected1();
  return initialConnected1_.value();
}

bool
TwoWTransformerInterfaceIIDM::getInitialConnected2() {
  if (initialConnected2_ == boost::none)
    initialConnected2_ = isConnected2();
  return initialConnected2_.value();
}

bool
TwoWTransformerInterfaceIIDM::isConnected1() const {
  bool connected = tfoIIDM_.getTerminal1().isConnected();
  if (connected && voltageLevelInterface1_->isNodeBreakerTopology())
    connected = voltageLevelInterface1_->isNodeConnected(static_cast<unsigned int>(tfoIIDM_.getTerminal1().getNodeBreakerView().getNode()));
  return connected;
}

bool
TwoWTransformerInterfaceIIDM::isConnected2() const {
  bool connected = tfoIIDM_.getTerminal2().isConnected();
  if (connected && voltageLevelInterface2_->isNodeBreakerTopology())
    connected = voltageLevelInterface2_->isNodeConnected(static_cast<unsigned int>(tfoIIDM_.getTerminal2().getNodeBreakerView().getNode()));
  return connected;
}

bool
TwoWTransformerInterfaceIIDM::isConnected() const {
  return isConnected1() && isConnected2();
}

bool
TwoWTransformerInterfaceIIDM::isPartiallyConnected() const {
  return isConnected1() || isConnected2();
}

double
TwoWTransformerInterfaceIIDM::getVNom1() const {
  return tfoIIDM_.getTerminal1().getVoltageLevel().getNominalV();
}

double
TwoWTransformerInterfaceIIDM::getVNom2() const {
  return tfoIIDM_.getTerminal2().getVoltageLevel().getNominalV();
}

double
TwoWTransformerInterfaceIIDM::getRatedU1() const {
  return tfoIIDM_.getRatedU1();
}

double
TwoWTransformerInterfaceIIDM::getRatedU2() const {
  return tfoIIDM_.getRatedU2();
}

shared_ptr<PhaseTapChangerInterface>
TwoWTransformerInterfaceIIDM::getPhaseTapChanger() const {
  return phaseTapChanger_;
}

shared_ptr<RatioTapChangerInterface>
TwoWTransformerInterfaceIIDM::getRatioTapChanger() const {
  return ratioTapChanger_;
}

void
TwoWTransformerInterfaceIIDM::setPhaseTapChanger(const shared_ptr<PhaseTapChangerInterface>& tapChanger) {
  phaseTapChanger_ = tapChanger;
}

void
TwoWTransformerInterfaceIIDM::setRatioTapChanger(const shared_ptr<RatioTapChangerInterface>& tapChanger) {
  ratioTapChanger_ = tapChanger;
}

double
TwoWTransformerInterfaceIIDM::getR() const {
  return tfoIIDM_.getR();
}

double
TwoWTransformerInterfaceIIDM::getX() const {
  return tfoIIDM_.getX();
}

double
TwoWTransformerInterfaceIIDM::getG() const {
  return tfoIIDM_.getG();
}

double
TwoWTransformerInterfaceIIDM::getB() const {
  return tfoIIDM_.getB();
}

void
TwoWTransformerInterfaceIIDM::addCurrentLimitInterface1(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces1_.push_back(currentLimitInterface);
}

void
TwoWTransformerInterfaceIIDM::addCurrentLimitInterface2(const shared_ptr<CurrentLimitInterface>& currentLimitInterface) {
  currentLimitInterfaces2_.push_back(currentLimitInterface);
}

vector<shared_ptr<CurrentLimitInterface> >
TwoWTransformerInterfaceIIDM::getCurrentLimitInterfaces1() const {
  return currentLimitInterfaces1_;
}

vector<shared_ptr<CurrentLimitInterface> >
TwoWTransformerInterfaceIIDM::getCurrentLimitInterfaces2() const {
  return currentLimitInterfaces2_;
}

int
TwoWTransformerInterfaceIIDM::getComponentVarIndex(const string& varName) const {
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
  else if ( varName == "tapIndex" )
    index = VAR_TAPINDEX;
  return index;
}

void
TwoWTransformerInterfaceIIDM::exportStateVariablesUnitComponent() {
  int state = getValue<int>(VAR_STATE);
  tfoIIDM_.getTerminal1().setP(getValue<double>(VAR_P1) * SNREF);
  tfoIIDM_.getTerminal1().setQ(getValue<double>(VAR_Q1) * SNREF);
  tfoIIDM_.getTerminal2().setP(getValue<double>(VAR_P2) * SNREF);
  tfoIIDM_.getTerminal2().setQ(getValue<double>(VAR_Q2) * SNREF);

  if (getPhaseTapChanger()) {
    getPhaseTapChanger()->setCurrentPosition(getValue<int>(VAR_TAPINDEX));
  }  else if (getRatioTapChanger()) {
    getRatioTapChanger()->setCurrentPosition(getValue<int>(VAR_TAPINDEX));
  }

  bool connected1 = (state == CLOSED) || (state == CLOSED_1);
  bool connected2 = (state == CLOSED) || (state == CLOSED_2);

  if (voltageLevelInterface1_->isNodeBreakerTopology()) {
    // should be removed once a solution has been found to propagate switches (de)connection
    // following component (de)connection (only Modelica models)
    if (connected1 && !getInitialConnected1())
      voltageLevelInterface1_->connectNode(static_cast<unsigned int>(tfoIIDM_.getTerminal1().getNodeBreakerView().getNode()));
    else if (!connected1 && getInitialConnected1())
      voltageLevelInterface1_->disconnectNode(static_cast<unsigned int>(tfoIIDM_.getTerminal1().getNodeBreakerView().getNode()));
  } else {
    if (connected1)
      tfoIIDM_.getTerminal1().connect();
    else
      tfoIIDM_.getTerminal1().disconnect();
  }
  if (voltageLevelInterface2_->isNodeBreakerTopology()) {
    // should be removed once a solution has been found to propagate switches (de)connection
    // following component (de)connection (only Modelica models)
    if (connected2 && !getInitialConnected2())
      voltageLevelInterface2_->connectNode(static_cast<unsigned int>(tfoIIDM_.getTerminal2().getNodeBreakerView().getNode()));
    else if (!connected2 && getInitialConnected2())
      voltageLevelInterface2_->disconnectNode(static_cast<unsigned int>(tfoIIDM_.getTerminal2().getNodeBreakerView().getNode()));
  } else {
    if (connected2)
      tfoIIDM_.getTerminal2().connect();
    else
      tfoIIDM_.getTerminal2().disconnect();
  }
}

double
TwoWTransformerInterfaceIIDM::getP1() {
  if (getInitialConnected1()) {
    if (std::isnan(tfoIIDM_.getTerminal1().getP())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "transformer", tfoIIDM_.getId(), "P1") << Trace::endline;
      return 0;
    }
    return tfoIIDM_.getTerminal1().getP();
  } else {
    return 0.;
  }
}

double
TwoWTransformerInterfaceIIDM::getQ1() {
  if (getInitialConnected1()) {
    if (std::isnan(tfoIIDM_.getTerminal1().getQ())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "transformer", tfoIIDM_.getId(), "Q1") << Trace::endline;
      return 0;
    }
    return tfoIIDM_.getTerminal1().getQ();
  } else {
    return 0.;
  }
}

double
TwoWTransformerInterfaceIIDM::getP2() {
  if (getInitialConnected2()) {
    if (std::isnan(tfoIIDM_.getTerminal2().getP())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "transformer", tfoIIDM_.getId(), "P2") << Trace::endline;
      return 0;
    }
    return tfoIIDM_.getTerminal2().getP();
  } else {
    return 0.;
  }
}

double
TwoWTransformerInterfaceIIDM::getQ2() {
  if (getInitialConnected2()) {
    if (std::isnan(tfoIIDM_.getTerminal2().getQ())) {
      Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "transformer", tfoIIDM_.getId(), "Q2") << Trace::endline;
      return 0;
    }
    return tfoIIDM_.getTerminal2().getQ();
  } else {
    return 0.;
  }
}

void
TwoWTransformerInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  double P1 = getP1();
  double P2 = getP2();
  double Q1 = getQ1();
  double Q2 = getQ2();
  staticParameters_.insert(std::make_pair("p1_pu", StaticParameter("p1_pu", StaticParameter::DOUBLE).setValue(P1 / SNREF)));
  staticParameters_.insert(std::make_pair("p2_pu", StaticParameter("p2_pu", StaticParameter::DOUBLE).setValue(P2 / SNREF)));
  staticParameters_.insert(std::make_pair("q1_pu", StaticParameter("q1_pu", StaticParameter::DOUBLE).setValue(Q1 / SNREF)));
  staticParameters_.insert(std::make_pair("q2_pu", StaticParameter("q2_pu", StaticParameter::DOUBLE).setValue(Q2 / SNREF)));
  staticParameters_.insert(std::make_pair("p1", StaticParameter("p1", StaticParameter::DOUBLE).setValue(P1)));
  staticParameters_.insert(std::make_pair("p2", StaticParameter("p2", StaticParameter::DOUBLE).setValue(P2)));
  staticParameters_.insert(std::make_pair("q1", StaticParameter("q1", StaticParameter::DOUBLE).setValue(Q1)));
  staticParameters_.insert(std::make_pair("q2", StaticParameter("q2", StaticParameter::DOUBLE).setValue(Q2)));

  double i1 = 0;
  if (getInitialConnected1() && !doubleIsZero(busInterface1_->getV0())) {
    double V = busInterface1_->getV0() / getVNom1();
    double theta = busInterface1_->getAngle0();
    double ur = V * cos(theta);
    double ui = V * sin(theta);
    double ir = 1 / SNREF * (ur * P1 + ui * Q1) / (V * V);
    double ii = 1 / SNREF * (ui * P1 - ur * Q1) / (V * V);
    i1 = sqrt(ir * ir + ii * ii);
  }

  double i2 = 0;
  if (getInitialConnected2() && !doubleIsZero(busInterface2_->getV0())) {
    double V = busInterface2_->getV0() / getVNom2();
    double theta = busInterface2_->getAngle0();
    double ur = V * cos(theta);
    double ui = V * sin(theta);
    double ir = 1 / SNREF * (ur * P2 + ui * Q2) / (V * V);
    double ii = 1 / SNREF * (ui * P2 - ur * Q2) / (V * V);
    i2 = sqrt(ir * ir + ii * ii);
  }
  staticParameters_.insert(std::make_pair("i1", StaticParameter("i1", StaticParameter::DOUBLE).setValue(i1)));
  staticParameters_.insert(std::make_pair("i2", StaticParameter("i2", StaticParameter::DOUBLE).setValue(i2)));

  int tap0 = 0;
  int tapMin = 0;
  int tapMax = 0;
  if (getPhaseTapChanger()) {
    tap0 = getPhaseTapChanger()->getCurrentPosition();
    tapMin = getPhaseTapChanger()->getLowPosition();
    tapMax = tapMin - 1 + getPhaseTapChanger()->getNbTap();
    double thresholdI = getPhaseTapChanger()->getThresholdI();
    double targetP = getPhaseTapChanger()->getTargetP();
    double factorAToPu = sqrt(3) * getVNom1() / (1000 * SNREF);
    staticParameters_.insert(std::make_pair("pTarget", StaticParameter("pTarget", StaticParameter::DOUBLE).setValue(targetP/SNREF)));
    staticParameters_.insert(std::make_pair("iMax", StaticParameter("iMax", StaticParameter::DOUBLE).setValue(thresholdI * factorAToPu)));
    staticParameters_.insert(std::make_pair("iStop", StaticParameter("iStop", StaticParameter::DOUBLE).setValue(thresholdI * factorAToPu)));
    staticParameters_.insert(std::make_pair("regulating",
        StaticParameter("regulating", StaticParameter::BOOL).setValue(getPhaseTapChanger()->getRegulating())));
    vector<shared_ptr<StepInterface> > taps = getPhaseTapChanger()->getSteps();
    assert(!taps.empty());

    double phaseTapMin = taps[0]->getAlpha();
    double phaseTapMax = taps[taps.size() - 1]->getAlpha();
    int increasePhase = phaseTapMin < phaseTapMax ? 1 : -1;

    staticParameters_.insert(std::make_pair("increasePhase", StaticParameter("increasePhase", StaticParameter::INT).setValue(increasePhase)));
  } else if (getRatioTapChanger()) {
    tap0 = getRatioTapChanger()->getCurrentPosition();
    tapMin = getRatioTapChanger()->getLowPosition();
    tapMax = tapMin - 1 + getRatioTapChanger()->getNbTap();
  }

  staticParameters_.insert(std::make_pair("tapPosition", StaticParameter("tapPosition", StaticParameter::INT).setValue(tap0)));
  staticParameters_.insert(std::make_pair("lowTapPosition", StaticParameter("lowTapPosition", StaticParameter::INT).setValue(tapMin)));
  staticParameters_.insert(std::make_pair("highTapPosition", StaticParameter("highTapPosition", StaticParameter::INT).setValue(tapMax)));
  // attention to sign (+/-) convention
}

std::string
TwoWTransformerInterfaceIIDM::getActiveSeason() const {
  return activeSeasonExtension_ ? activeSeasonExtension_->getValue() : std::string("UNDEFINED");
}
}  // namespace DYN
