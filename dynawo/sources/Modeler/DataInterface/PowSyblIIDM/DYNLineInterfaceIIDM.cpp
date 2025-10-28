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
#include "DYNBusInterface.h"

namespace DYN {

LineInterfaceIIDM::LineInterfaceIIDM(powsybl::iidm::Line& line) : LineInterface(false),
                                                                  lineIIDM_(line),
                                                                  initialConnected1_(boost::none),
                                                                  initialConnected2_(boost::none) {
  setType(ComponentInterface::LINE);
  stateVariables_.resize(5);
  stateVariables_[VAR_P1] = StateVariable("p1", StateVariable::DOUBLE);     // P1
  stateVariables_[VAR_P2] = StateVariable("p2", StateVariable::DOUBLE);     // P2
  stateVariables_[VAR_Q1] = StateVariable("q1", StateVariable::DOUBLE);     // Q1
  stateVariables_[VAR_Q2] = StateVariable("q2", StateVariable::DOUBLE);     // Q2
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);  // connectionState

  auto libPath = IIDMExtensions::findLibraryPath();

  auto activeSeasonExtensionDef = IIDMExtensions::getExtension<ActiveSeasonIIDMExtension>(libPath.generic_string());
  activeSeasonExtension_ = std::get<IIDMExtensions::CREATE_FUNCTION>(activeSeasonExtensionDef)(line);
  destroyActiveSeasonExtension_ = std::get<IIDMExtensions::DESTROY_FUNCTION>(activeSeasonExtensionDef);

  auto currentLimitsPerSeasonExtensionDef = IIDMExtensions::getExtension<CurrentLimitsPerSeasonIIDMExtension>(libPath.generic_string());
  currentLimitsPerSeasonExtension_ = std::get<IIDMExtensions::CREATE_FUNCTION>(currentLimitsPerSeasonExtensionDef)(line);
  destroyCurrentLimitsPerSeasonExtension_ = std::get<IIDMExtensions::DESTROY_FUNCTION>(currentLimitsPerSeasonExtensionDef);
  if (!std::isnan(lineIIDM_.getTerminal1().getP()) || !std::isnan(lineIIDM_.getTerminal1().getQ()) ||
      !std::isnan(lineIIDM_.getTerminal2().getP()) || !std::isnan(lineIIDM_.getTerminal2().getQ())) {
      hasInitialConditions(true);
  }
}

LineInterfaceIIDM::~LineInterfaceIIDM() {
  destroyActiveSeasonExtension_(activeSeasonExtension_);
  destroyCurrentLimitsPerSeasonExtension_(currentLimitsPerSeasonExtension_);
}

void
LineInterfaceIIDM::setVoltageLevelInterface1(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface1_ = voltageLevelInterface;
}

void
LineInterfaceIIDM::setBusInterface1(const std::shared_ptr<BusInterface>& busInterface) {
  busInterface1_ = busInterface;
}

void
LineInterfaceIIDM::setVoltageLevelInterface2(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  voltageLevelInterface2_ = voltageLevelInterface;
}

void
LineInterfaceIIDM::setBusInterface2(const std::shared_ptr<BusInterface>& busInterface) {
  busInterface2_ = busInterface;
}

std::shared_ptr<BusInterface>
LineInterfaceIIDM::getBusInterface1() const {
  return busInterface1_;
}

std::shared_ptr<BusInterface>
LineInterfaceIIDM::getBusInterface2() const {
  return busInterface2_;
}

double
LineInterfaceIIDM::getVNom1() const {
  return lineIIDM_.getTerminal1().getVoltageLevel().getNominalV();
}

double
LineInterfaceIIDM::getVNom2() const {
  return lineIIDM_.getTerminal2().getVoltageLevel().getNominalV();
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
  if (initialConnected1_ == boost::none)
    initialConnected1_ = isConnected1();
  return initialConnected1_.value();
}

bool
LineInterfaceIIDM::getInitialConnected2() {
  if (initialConnected2_ == boost::none)
    initialConnected2_ = isConnected2();
  return initialConnected2_.value();
}

bool
LineInterfaceIIDM::isConnected1() const {
  bool connected = lineIIDM_.getTerminal1().isConnected();
  if (connected && voltageLevelInterface1_->isNodeBreakerTopology())
    connected = voltageLevelInterface1_->isNodeConnected(static_cast<unsigned int>(lineIIDM_.getTerminal1().getNodeBreakerView().getNode()));
  return connected;
}

bool
LineInterfaceIIDM::isConnected2() const {
  bool connected = lineIIDM_.getTerminal2().isConnected();
  if (connected && voltageLevelInterface2_->isNodeBreakerTopology())
    connected = voltageLevelInterface2_->isNodeConnected(static_cast<unsigned int>(lineIIDM_.getTerminal2().getNodeBreakerView().getNode()));
  return connected;
}

bool
LineInterfaceIIDM::isConnected() const {
  return isConnected1() && isConnected2();
}

bool
LineInterfaceIIDM::isPartiallyConnected() const {
  return isConnected1() || isConnected2();
}

std::string
LineInterfaceIIDM::getID() const {
  return lineIIDM_.getId();
}

void
LineInterfaceIIDM::addCurrentLimitInterface1(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) {
  currentLimitInterfaces1_.push_back(std::move(currentLimitInterface));
}

void
LineInterfaceIIDM::addCurrentLimitInterface2(std::unique_ptr<CurrentLimitInterface> currentLimitInterface) {
  currentLimitInterfaces2_.push_back(std::move(currentLimitInterface));
}

const std::vector<std::unique_ptr<CurrentLimitInterface> >&
LineInterfaceIIDM::getCurrentLimitInterfaces1() const {
  return currentLimitInterfaces1_;
}

const std::vector<std::unique_ptr<CurrentLimitInterface> >&
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

  if (voltageLevelInterface1_->isNodeBreakerTopology()) {
    // should be removed once a solution has been found to propagate switches (de)connection
    // following component (de)connection (only Modelica models)
    if (connected1 && !getInitialConnected1())
      voltageLevelInterface1_->connectNode(static_cast<unsigned int>(lineIIDM_.getTerminal1().getNodeBreakerView().getNode()));
    else if (!connected1 && getInitialConnected1())
      voltageLevelInterface1_->disconnectNode(static_cast<unsigned int>(lineIIDM_.getTerminal1().getNodeBreakerView().getNode()));
  } else {
    if (connected1)
      lineIIDM_.getTerminal1().connect();
    else
      lineIIDM_.getTerminal1().disconnect();
  }
  if (voltageLevelInterface2_->isNodeBreakerTopology()) {
    // should be removed once a solution has been found to propagate switches (de)connection
    // following component (de)connection (only Modelica models)
    if (connected2 && !getInitialConnected2())
      voltageLevelInterface2_->connectNode(static_cast<unsigned int>(lineIIDM_.getTerminal2().getNodeBreakerView().getNode()));
    else if (!connected2 && getInitialConnected2())
      voltageLevelInterface2_->disconnectNode(static_cast<unsigned int>(lineIIDM_.getTerminal2().getNodeBreakerView().getNode()));
  } else {
    if (connected2)
      lineIIDM_.getTerminal2().connect();
    else
      lineIIDM_.getTerminal2().disconnect();
  }
}

std::string
LineInterfaceIIDM::getActiveSeason() const {
  return activeSeasonExtension_ ? activeSeasonExtension_->getValue() : std::string("UNDEFINED");
}

boost::optional<double>
LineInterfaceIIDM::getCurrentLimitPermanent(const std::string& season, CurrentLimitSide side) const {
  if (!currentLimitsPerSeasonExtension_) {
    return boost::none;
  }
  switch (side) {
    case CURRENT_LIMIT_SIDE_1:
    case CURRENT_LIMIT_SIDE_2:
    case CURRENT_LIMIT_SIDE_3:
      // all correct values
      break;
    default:
      return boost::none;
  }
  const auto& map = currentLimitsPerSeasonExtension_->getCurrentLimits();
  auto found = map.find(season);
  if (found != map.end() && found->second.currentLimits.count(side) > 0 && found->second.currentLimits.at(side)) {
    return found->second.currentLimits.at(side)->permanentLimit;
  }

  return boost::none;
}

boost::optional<unsigned int>
LineInterfaceIIDM::getCurrentLimitNbTemporary(const std::string& season, CurrentLimitSide side) const {
  if (!currentLimitsPerSeasonExtension_) {
    return boost::none;
  }
  switch (side) {
    case CURRENT_LIMIT_SIDE_1:
    case CURRENT_LIMIT_SIDE_2:
    case CURRENT_LIMIT_SIDE_3:
      // all correct values
      break;
    default:
      return boost::none;
  }
  const auto& map = currentLimitsPerSeasonExtension_->getCurrentLimits();
  auto found = map.find(season);
  if (found != map.end()&& found->second.currentLimits.count(side) > 0 && found->second.currentLimits.at(side)) {
    return static_cast<unsigned int>(found->second.currentLimits.at(side)->temporaryLimits.size());
  }

  return boost::none;
}

boost::optional<std::string>
LineInterfaceIIDM::getCurrentLimitTemporaryName(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const {
  if (!currentLimitsPerSeasonExtension_) {
    return boost::none;
  }
  switch (side) {
    case CURRENT_LIMIT_SIDE_1:
    case CURRENT_LIMIT_SIDE_2:
    case CURRENT_LIMIT_SIDE_3:
      // all correct values
      break;
    default:
      return boost::none;
  }
  const auto& map = currentLimitsPerSeasonExtension_->getCurrentLimits();
  auto found = map.find(season);
  if (found != map.end()&& found->second.currentLimits.count(side) > 0 && found->second.currentLimits.at(side)) {
    auto size = found->second.currentLimits.at(side)->temporaryLimits.size();
    if (indexTemporary < size) {
      return found->second.currentLimits.at(side)->temporaryLimits.at(indexTemporary).name;
    }
  }

  return boost::none;
}

boost::optional<unsigned long>
LineInterfaceIIDM::getCurrentLimitTemporaryAcceptableDuration(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const {
  if (!currentLimitsPerSeasonExtension_) {
    return boost::none;
  }
  switch (side) {
    case CURRENT_LIMIT_SIDE_1:
    case CURRENT_LIMIT_SIDE_2:
    case CURRENT_LIMIT_SIDE_3:
      // all correct values
      break;
    default:
      return boost::none;
  }
  const auto& map = currentLimitsPerSeasonExtension_->getCurrentLimits();
  auto found = map.find(season);
  if (found != map.end() && found->second.currentLimits.count(side) > 0 && found->second.currentLimits.at(side)) {
    auto size = found->second.currentLimits.at(side)->temporaryLimits.size();
    if (indexTemporary < size) {
      return found->second.currentLimits.at(side)->temporaryLimits.at(indexTemporary).acceptableDuration;
    }
  }

  return boost::none;
}

boost::optional<double>
LineInterfaceIIDM::getCurrentLimitTemporaryValue(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const {
  if (!currentLimitsPerSeasonExtension_) {
    return boost::none;
  }
  switch (side) {
    case CURRENT_LIMIT_SIDE_1:
    case CURRENT_LIMIT_SIDE_2:
    case CURRENT_LIMIT_SIDE_3:
      // all correct values
      break;
    default:
      return boost::none;
  }
  const auto& map = currentLimitsPerSeasonExtension_->getCurrentLimits();
  auto found = map.find(season);
  if (found != map.end() && found->second.currentLimits.count(side) > 0 && found->second.currentLimits.at(side)) {
    auto size = found->second.currentLimits.at(side)->temporaryLimits.size();
    if (indexTemporary < size) {
      return found->second.currentLimits.at(side)->temporaryLimits.at(indexTemporary).value;
    }
  }

  return boost::none;
}

boost::optional<bool>
LineInterfaceIIDM::getCurrentLimitTemporaryFictitious(const std::string& season, CurrentLimitSide side, unsigned int indexTemporary) const {
  if (!currentLimitsPerSeasonExtension_) {
    return boost::none;
  }
  switch (side) {
    case CURRENT_LIMIT_SIDE_1:
    case CURRENT_LIMIT_SIDE_2:
    case CURRENT_LIMIT_SIDE_3:
      // all correct values
      break;
    default:
      return boost::none;
  }
  const auto& map = currentLimitsPerSeasonExtension_->getCurrentLimits();
  auto found = map.find(season);
  if (found != map.end() && found->second.currentLimits.count(side) > 0 && found->second.currentLimits.at(side)) {
    auto size = found->second.currentLimits.at(side)->temporaryLimits.size();
    if (indexTemporary < size) {
      return found->second.currentLimits.at(side)->temporaryLimits.at(indexTemporary).fictitious;
    }
  }

  return boost::none;
}


void
LineInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  const double P1 = getP1();
  const double P2 = getP2();
  const double Q1 = getQ1();
  const double Q2 = getQ2();
  staticParameters_.insert(std::make_pair("p1_pu", StaticParameter("p1_pu", StaticParameter::DOUBLE).setValue(P1 / SNREF)));
  staticParameters_.insert(std::make_pair("p2_pu", StaticParameter("p2_pu", StaticParameter::DOUBLE).setValue(P2 / SNREF)));
  staticParameters_.insert(std::make_pair("q1_pu", StaticParameter("q1_pu", StaticParameter::DOUBLE).setValue(Q1 / SNREF)));
  staticParameters_.insert(std::make_pair("q2_pu", StaticParameter("q2_pu", StaticParameter::DOUBLE).setValue(Q2 / SNREF)));
  staticParameters_.insert(std::make_pair("p1", StaticParameter("p1", StaticParameter::DOUBLE).setValue(P1)));
  staticParameters_.insert(std::make_pair("p2", StaticParameter("p2", StaticParameter::DOUBLE).setValue(P2)));
  staticParameters_.insert(std::make_pair("q1", StaticParameter("q1", StaticParameter::DOUBLE).setValue(Q1)));
  staticParameters_.insert(std::make_pair("q2", StaticParameter("q2", StaticParameter::DOUBLE).setValue(Q2)));

  if (busInterface1_) {
    const double v10 = busInterface1_->getV0();
    const double vNom1 = getVNom1();

    const double theta1 = busInterface1_->getAngle0();
    staticParameters_.insert(std::make_pair("v1_pu", StaticParameter("v1_pu", StaticParameter::DOUBLE).setValue(v10 / vNom1)));
    staticParameters_.insert(std::make_pair("angle1_pu", StaticParameter("angle1_pu", StaticParameter::DOUBLE).setValue(theta1 * M_PI / 180)));
    staticParameters_.insert(std::make_pair("v1", StaticParameter("v1", StaticParameter::DOUBLE).setValue(v10)));
    staticParameters_.insert(std::make_pair("angle1", StaticParameter("angle1", StaticParameter::DOUBLE).setValue(theta1)));
    staticParameters_.insert(std::make_pair("v1Nom", StaticParameter("v1Nom", StaticParameter::DOUBLE).setValue(vNom1)));
  } else {
    staticParameters_.insert(std::make_pair("v1_pu", StaticParameter("v1_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle1_pu", StaticParameter("angle1_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v1", StaticParameter("v1", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle1", StaticParameter("angle1", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v1Nom", StaticParameter("v1Nom", StaticParameter::DOUBLE).setValue(1.)));
  }

  if (busInterface2_) {
    const double v20 = busInterface2_->getV0();
    const double vNom2 = getVNom2();

    const double theta2 = busInterface2_->getAngle0();
    staticParameters_.insert(std::make_pair("v2_pu", StaticParameter("v2_pu", StaticParameter::DOUBLE).setValue(v20 / vNom2)));
    staticParameters_.insert(std::make_pair("angle2_pu", StaticParameter("angle2_pu", StaticParameter::DOUBLE).setValue(theta2 * M_PI / 180)));
    staticParameters_.insert(std::make_pair("v2", StaticParameter("v2", StaticParameter::DOUBLE).setValue(v20)));
    staticParameters_.insert(std::make_pair("angle2", StaticParameter("angle2", StaticParameter::DOUBLE).setValue(theta2)));
    staticParameters_.insert(std::make_pair("v2Nom", StaticParameter("v2Nom", StaticParameter::DOUBLE).setValue(vNom2)));
  } else {
    staticParameters_.insert(std::make_pair("v2_pu", StaticParameter("v2_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle2_pu", StaticParameter("angle_pu2", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v2", StaticParameter("v2", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle2", StaticParameter("angle2", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v2Nom", StaticParameter("v2Nom", StaticParameter::DOUBLE).setValue(1.)));
  }

  const double r = getR();
  const double x = getX();
  const double b1 = getB1();
  const double b2 = getB2();
  const double g1 = getG1();
  const double g2 = getG2();
  staticParameters_.insert(std::make_pair("r", StaticParameter("r", StaticParameter::DOUBLE).setValue(r)));
  staticParameters_.insert(std::make_pair("x", StaticParameter("x", StaticParameter::DOUBLE).setValue(x)));
  staticParameters_.insert(std::make_pair("b1", StaticParameter("b1", StaticParameter::DOUBLE).setValue(b1)));
  staticParameters_.insert(std::make_pair("b2", StaticParameter("b2", StaticParameter::DOUBLE).setValue(b2)));
  staticParameters_.insert(std::make_pair("g1", StaticParameter("g1", StaticParameter::DOUBLE).setValue(g1)));
  staticParameters_.insert(std::make_pair("g2", StaticParameter("g2", StaticParameter::DOUBLE).setValue(g2)));

  const bool connected1 = getInitialConnected1();
  const bool connected2 = getInitialConnected2();

  double vNom = std::numeric_limits<double>::quiet_NaN();
  if ((connected1 && connected2) || connected1) {
    vNom = getVNom1();
  } else if (connected2) {
    vNom = getVNom2();
  }
  assert(vNom == vNom);  // control that vNom != NAN
  if (vNom > 0) {
    const double coeff = vNom * vNom / SNREF;
    staticParameters_.insert(std::make_pair("r_pu", StaticParameter("r_pu", StaticParameter::DOUBLE).setValue(r / coeff)));
    staticParameters_.insert(std::make_pair("x_pu", StaticParameter("x_pu", StaticParameter::DOUBLE).setValue(x / coeff)));
    staticParameters_.insert(std::make_pair("b1_pu", StaticParameter("b1_pu", StaticParameter::DOUBLE).setValue(b1 * coeff)));
    staticParameters_.insert(std::make_pair("b2_pu", StaticParameter("b2_pu", StaticParameter::DOUBLE).setValue(b2 * coeff)));
    staticParameters_.insert(std::make_pair("g1_pu", StaticParameter("g1_pu", StaticParameter::DOUBLE).setValue(g1 * coeff)));
    staticParameters_.insert(std::make_pair("g2_pu", StaticParameter("g2_pu", StaticParameter::DOUBLE).setValue(g2 * coeff)));
  } else {
    if ((connected1 && connected2) || connected1) {
      throw DYNError(Error::MODELER, UndefinedNominalV, lineIIDM_.getTerminal1().getVoltageLevel().getId());
    } else if (connected2) {
      throw DYNError(Error::MODELER, UndefinedNominalV, lineIIDM_.getTerminal2().getVoltageLevel().getId());
    }
  }
}

}  // namespace DYN
