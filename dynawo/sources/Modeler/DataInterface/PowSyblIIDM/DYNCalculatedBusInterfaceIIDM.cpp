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
 * @file  DYNCalculatedBusInterfaceIIDM.cpp
 *
 * @brief Calculated bus interface implementation
 */

#include "DYNCalculatedBusInterfaceIIDM.h"

#include "DYNCommonConstants.h"
#include "DYNStateVariable.h"
#include "DYNTrace.h"
#include "DYNCommon.h"

#include <powsybl/iidm/Bus.hpp>
#include <algorithm>
#include <sstream>
#include <cmath>

using boost::shared_ptr;
using std::string;
using std::set;
using std::vector;

namespace DYN {

CalculatedBusInterfaceIIDM::CalculatedBusInterfaceIIDM(powsybl::iidm::VoltageLevel& voltageLevel, const string& name, const int busIndex) :
busIndex_(busIndex),
name_(name),
voltageLevel_(voltageLevel),
hasConnection_(false) {
  setType(ComponentInterface::CALCULATED_BUS);
  stateVariables_.resize(2);
  bool neededForCriteriaCheck = true;
  stateVariables_[VAR_V] = StateVariable("v", StateVariable::DOUBLE, neededForCriteriaCheck);  // V
  stateVariables_[VAR_ANGLE] = StateVariable("angle", StateVariable::DOUBLE);  // angle
}

void
CalculatedBusInterfaceIIDM::addBusBarSection(const string& bbs) {
  bbsIdentifiers_.push_back(bbs);
}

void
CalculatedBusInterfaceIIDM::setU0(const double& u0) {
  if (!std::isnan(u0))
    U0_ = u0;
}

void
CalculatedBusInterfaceIIDM::setAngle0(const double& angle0) {
  if (!std::isnan(angle0))
    angle0_ = angle0;
}

void
CalculatedBusInterfaceIIDM::addNode(const int node) {
  nodes_.insert(node);
}

string
CalculatedBusInterfaceIIDM::getID() const {
  return name_;
}

double
CalculatedBusInterfaceIIDM::getVMax() const {
  if (std::isnan(voltageLevel_.getHighVoltageLimit())) {
    return uMaxPu * getVNom();   // default data
  }
  return voltageLevel_.getHighVoltageLimit();
}

double
CalculatedBusInterfaceIIDM::getVMin() const {
  if (std::isnan(voltageLevel_.getLowVoltageLimit())) {
    return uMinPu * getVNom();   // default data
  }
  return voltageLevel_.getLowVoltageLimit();
}

double
CalculatedBusInterfaceIIDM::getV0() const {
  if (U0_) {
    return U0_.value();
  } else {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "CalculatedBus", getID(), "v") << Trace::endline;
    return getVNom();  // default value
  }
}

double
CalculatedBusInterfaceIIDM::getAngle0() const {
  if (angle0_) {
    return angle0_.value();
  } else {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "CalculatedBus", getID(), "angle") << Trace::endline;
    return defaultAngle0;  // default value
  }
}

double
CalculatedBusInterfaceIIDM::getVNom() const {
  return voltageLevel_.getNominalV();
}

double
CalculatedBusInterfaceIIDM::getStateVarV() const {
  return getValue<double>(VAR_V);
}

double
CalculatedBusInterfaceIIDM::getStateVarAngle() const {
  return getValue<double>(VAR_ANGLE);
}

void
CalculatedBusInterfaceIIDM::hasConnection(bool hasConnection) {
  hasConnection_ = hasConnection;
}

bool
CalculatedBusInterfaceIIDM::hasConnection() const {
  return hasConnection_;
}

int
CalculatedBusInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "v" )
    index = VAR_V;
  else if ( varName == "angle" )
    index = VAR_ANGLE;
  return index;
}

void
CalculatedBusInterfaceIIDM::exportStateVariablesUnitComponent() {
  double angle = getStateVarAngle();
  if (doubleIsZero(angle))
    angle = 0.;
  for (auto& node : nodes_) {
    const auto& terminal = voltageLevel_.getNodeBreakerView().getTerminal(node);
    if (terminal) {
      const auto& bus = terminal.get().getBusView().getBus();
      if (bus) {
        bus.get().setV(getStateVarV());
        bus.get().setAngle(angle);
      }
    }
  }
}

void
CalculatedBusInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("U", StaticParameter("U", StaticParameter::DOUBLE).setValue(getV0())));
  staticParameters_.insert(std::make_pair("Theta", StaticParameter("Theta", StaticParameter::DOUBLE).setValue(getAngle0())));
  staticParameters_.insert(std::make_pair("Upu", StaticParameter("Upu", StaticParameter::DOUBLE).setValue(getV0() / getVNom())));
  staticParameters_.insert(std::make_pair("Theta_pu", StaticParameter("Theta_pu", StaticParameter::DOUBLE).setValue(getAngle0() * M_PI / 180)));
  staticParameters_.insert(std::make_pair("UNom", StaticParameter("UNom", StaticParameter::DOUBLE).setValue(getVNom())));
}

bool
CalculatedBusInterfaceIIDM::hasNode(const int node) {
  return (nodes_.find(node) != nodes_.end());
}

const vector<string>&
CalculatedBusInterfaceIIDM::getBusBarSectionIdentifiers() const {
  return bbsIdentifiers_;
}

bool
CalculatedBusInterfaceIIDM::hasBusBarSection(const string& bbs) const {
  return std::find(bbsIdentifiers_.begin(), bbsIdentifiers_.end(), bbs) != bbsIdentifiers_.end();
}

set<int>
CalculatedBusInterfaceIIDM::getNodes() const {
  return nodes_;
}

std::ostream& operator<<(std::ostream& stream, const CalculatedBusInterfaceIIDM& calculatedBus) {
  stream << calculatedBus.getID() << " nodes : [";
  set<int> nodes = calculatedBus.getNodes();
  for (set<int>::iterator it = nodes.begin(); it !=nodes.end(); ++it)
    stream << ' ' << *it;
  stream << " ]; busBarSection : [";

  vector<string> bbsIdentifiers = calculatedBus.getBusBarSectionIdentifiers();
  for (unsigned int i =0; i < bbsIdentifiers.size(); ++i)
    stream << ' ' << bbsIdentifiers[i];

  stream << " ]; U0 : " << calculatedBus.getV0() << "; Angle0 : " << calculatedBus.getAngle0();

  return stream;
}

}  // namespace DYN
