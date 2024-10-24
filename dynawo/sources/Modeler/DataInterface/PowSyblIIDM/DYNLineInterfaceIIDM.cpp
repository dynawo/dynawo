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
  // no static parameter
}

}  // namespace DYN
