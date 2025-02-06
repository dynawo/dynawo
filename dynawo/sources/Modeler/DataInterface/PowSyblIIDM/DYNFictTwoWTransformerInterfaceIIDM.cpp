//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNTwoWTransformerInterfaceIIDM.cpp
 *
 * @brief Fictitious Two windings transformer: implementation file to create of TwoWindingTransformer from ThreeWindingTransfomer leg
 *
 */

#include "DYNFictTwoWTransformerInterfaceIIDM.h"

#include <powsybl/iidm/ThreeWindingsTransformer.hpp>

#include "DYNCommon.h"
#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNStepInterfaceIIDM.h"
#include "DYNBusInterface.h"
#include "DYNVoltageLevelInterface.h"
#include "DYNStateVariable.h"
#include "DYNModelConstants.h"

#include "DYNTrace.h"

using std::shared_ptr;
using std::string;
using std::vector;

namespace DYN {

  FictTwoWTransformerInterfaceIIDM::FictTwoWTransformerInterfaceIIDM(const std::string& Id,
                      stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>& leg,
                      bool initialConnected1, double VNom1, double ratedU1, const std::string& activeSeason) :
                      leg_(leg),
                      Id_(Id),
                      initialConnected1_(initialConnected1),
                      initialConnected2_(boost::none),
                      VNom1_(VNom1),
                      RatedU1_(ratedU1),
                      activeSeason_(activeSeason) {
    setType(ComponentInterface::TWO_WTFO);
    if (leg.get().hasPhaseTapChanger() ||
        (leg.get().hasRatioTapChanger() && leg.get().getRatioTapChanger().getRegulationTerminal() &&
         stdcxx::areSame(leg.get().getTerminal(), leg.get().getRatioTapChanger().getRegulationTerminal().get())))
      stateVariables_.resize(6);
    else
      stateVariables_.resize(5);
    stateVariables_[VAR_P1] = StateVariable("p1", StateVariable::DOUBLE);  // P1
    stateVariables_[VAR_P2] = StateVariable("p2", StateVariable::DOUBLE);  // P2
    stateVariables_[VAR_Q1] = StateVariable("q1", StateVariable::DOUBLE);  // Q1
    stateVariables_[VAR_Q2] = StateVariable("q2", StateVariable::DOUBLE);  // Q2
    stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);  // connectionState
    if (leg.get().hasPhaseTapChanger() ||
      (leg.get().hasRatioTapChanger() && leg.get().getRatioTapChanger().getRegulationTerminal() &&
      stdcxx::areSame(leg.get().getTerminal(), leg.get().getRatioTapChanger().getRegulationTerminal().get()))) {
      stateVariables_[VAR_TAPINDEX] = StateVariable("tapIndex", StateVariable::INT);
    }
  }

  void
  FictTwoWTransformerInterfaceIIDM::addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> /*currentLimitInterface*/) {
    /* not needed */
  }

  void
  FictTwoWTransformerInterfaceIIDM::addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) {
    currentLimitInterfaces2_.push_back(std::move(currentLimitInterface));
  }

  const std::vector<std::unique_ptr<CurrentLimitInterface> >&
  FictTwoWTransformerInterfaceIIDM::getCurrentLimitInterfaces2() const {
    return currentLimitInterfaces2_;
  }

  void
  FictTwoWTransformerInterfaceIIDM::setBusInterface1(const std::shared_ptr<BusInterface>& busInterface) {
    busInterface1_ = busInterface;
  }

  void
  FictTwoWTransformerInterfaceIIDM::setVoltageLevelInterface1(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
    voltageLevelInterface1_ = voltageLevelInterface;
  }

  void
  FictTwoWTransformerInterfaceIIDM::setBusInterface2(const std::shared_ptr<BusInterface>& busInterface) {
    busInterface2_ = busInterface;
  }

  void
  FictTwoWTransformerInterfaceIIDM::setVoltageLevelInterface2(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
    voltageLevelInterface2_ = voltageLevelInterface;
  }

  std::shared_ptr<BusInterface>
  FictTwoWTransformerInterfaceIIDM::getBusInterface1() const {
    return busInterface1_;
  }

  std::shared_ptr<BusInterface>
  FictTwoWTransformerInterfaceIIDM::getBusInterface2() const {
    return busInterface2_;
  }

  const std::string&
  FictTwoWTransformerInterfaceIIDM::getID() const {
    return Id_;
  }

  bool
  FictTwoWTransformerInterfaceIIDM::getInitialConnected1() {
    return initialConnected1_;
  }

  bool
  FictTwoWTransformerInterfaceIIDM::getInitialConnected2() {
    if (initialConnected2_ == boost::none) {
      initialConnected2_ = leg_.get().getTerminal().isConnected();
      if (voltageLevelInterface2_->isNodeBreakerTopology()) {
        initialConnected2_ = initialConnected2_
                          && voltageLevelInterface2_->isNodeConnected(static_cast<unsigned int>(leg_.get().getTerminal().getNodeBreakerView().getNode()));
      }
    }
    return initialConnected2_.value();
  }

  double
  FictTwoWTransformerInterfaceIIDM::getVNom1() const {
    return VNom1_;
  }

  double
  FictTwoWTransformerInterfaceIIDM::getVNom2() const {
    return leg_.get().getTerminal().getVoltageLevel().getNominalV();
  }

  double
  FictTwoWTransformerInterfaceIIDM::getRatedU1() const {
    return RatedU1_;
  }

  double
  FictTwoWTransformerInterfaceIIDM::getRatedU2() const {
    return leg_.get().getRatedU();
  }

  const std::unique_ptr<PhaseTapChangerInterface>&
  FictTwoWTransformerInterfaceIIDM::getPhaseTapChanger() const {
    return phaseTapChanger_;
  }

  const std::unique_ptr<RatioTapChangerInterface>&
  FictTwoWTransformerInterfaceIIDM::getRatioTapChanger() const {
    return ratioTapChanger_;
  }

  void
  FictTwoWTransformerInterfaceIIDM::setPhaseTapChanger(std::unique_ptr<PhaseTapChangerInterface> tapChanger) {
    phaseTapChanger_ = std::move(tapChanger);
  }

  void
  FictTwoWTransformerInterfaceIIDM::setRatioTapChanger(std::unique_ptr<RatioTapChangerInterface> tapChanger) {
    ratioTapChanger_ = std::move(tapChanger);
  }

  double
  FictTwoWTransformerInterfaceIIDM::getR() const {
    return leg_.get().getR() * getVNom2() * getVNom2() / (getVNom1() * getVNom1());
  }

  double
  FictTwoWTransformerInterfaceIIDM::getX() const {
    return leg_.get().getX() * getVNom2() * getVNom2() / (getVNom1() * getVNom1());
  }

  double
  FictTwoWTransformerInterfaceIIDM::getG() const {
    return leg_.get().getG() * getVNom2() * getVNom2() / (getVNom1() * getVNom1());
  }

  double
  FictTwoWTransformerInterfaceIIDM::getB() const {
    return leg_.get().getB() * getVNom2() * getVNom2() / (getVNom1() * getVNom1());
  }

  double
  FictTwoWTransformerInterfaceIIDM::getP1() {
    return 0.0;
  }

  double
  FictTwoWTransformerInterfaceIIDM::getQ1() {
    return 0.0;
  }

  double
  FictTwoWTransformerInterfaceIIDM::getP2() {
    return 0.0;
  }

  double
  FictTwoWTransformerInterfaceIIDM::getQ2() {
    return 0.0;
  }

  void
  FictTwoWTransformerInterfaceIIDM::importStaticParameters() {
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
      double thresholdI = getPhaseTapChanger()->getRegulationValue();
      double factorAToPu = sqrt(3) * getVNom1() / (1000 * SNREF);
      staticParameters_.insert(std::make_pair("iMax", StaticParameter("iMax", StaticParameter::DOUBLE).setValue(thresholdI * factorAToPu)));
      staticParameters_.insert(std::make_pair("iStop", StaticParameter("iStop", StaticParameter::DOUBLE).setValue(thresholdI * factorAToPu)));
      staticParameters_.insert(std::make_pair("regulating",
        StaticParameter("regulating", StaticParameter::BOOL).setValue(getPhaseTapChanger()->getRegulating())));
      const vector<std::unique_ptr<StepInterface> >& taps = getPhaseTapChanger()->getSteps();
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
  }

  void
  FictTwoWTransformerInterfaceIIDM::exportStateVariablesUnitComponent() {
    int state = getValue<int>(VAR_STATE);
    leg_.get().getTerminal().setP(getValue<double>(VAR_P2) * SNREF);
    leg_.get().getTerminal().setQ(getValue<double>(VAR_Q2) * SNREF);

    if (getPhaseTapChanger()) {
      getPhaseTapChanger()->setCurrentPosition(getValue<int>(VAR_TAPINDEX));
    }  else if (getRatioTapChanger()) {
      getRatioTapChanger()->setCurrentPosition(getValue<int>(VAR_TAPINDEX));
    }

    bool connected2 = (state == CLOSED) || (state == CLOSED_2);

    if (voltageLevelInterface2_->isNodeBreakerTopology()) {
      if (connected2 && !getInitialConnected2())
        voltageLevelInterface2_->connectNode(static_cast<unsigned int>(leg_.get().getTerminal().getNodeBreakerView().getNode()));
      else if (!connected2 && getInitialConnected2())
        voltageLevelInterface2_->disconnectNode(static_cast<unsigned int>(leg_.get().getTerminal().getNodeBreakerView().getNode()));
    } else {
      if (connected2)
        leg_.get().getTerminal().connect();
      else
        leg_.get().getTerminal().disconnect();
    }
  }

  int
  FictTwoWTransformerInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
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

  bool
  FictTwoWTransformerInterfaceIIDM::isConnected() const {
    bool connected = leg_.get().getTerminal().isConnected();
    if (connected && voltageLevelInterface2_->isNodeBreakerTopology())
      connected = voltageLevelInterface2_->isNodeConnected(static_cast<unsigned int>(leg_.get().getTerminal().getNodeBreakerView().getNode()));
    return connected;
  }
}  // namespace DYN
