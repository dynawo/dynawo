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
}

int
LccConverterInterfaceIIDM::getComponentVarIndex(const std::string& /*varName*/) const {
  return -1;
}

void
LccConverterInterfaceIIDM::exportStateVariablesUnitComponent() {
}

void
LccConverterInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(-1 * getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(-1 * getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(-1 * getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(-1 * getQ())));
  staticParameters_.insert(std::make_pair("powerFactor", StaticParameter("powerFactor", StaticParameter::DOUBLE).setValue(getPowerFactor())));
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom = lccConverterIIDM_.voltageLevel().nominalV();
    double theta = busInterface_->getAngle0();
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(theta * M_PI / 180)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(theta)));
  } else {
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
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

bool
LccConverterInterfaceIIDM::isConnected() const {
  return InjectorInterfaceIIDM<IIDM::LccConverterStation>::isConnected();
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

IIDM::LccConverterStation&
LccConverterInterfaceIIDM::getLccIIDM() {
  return lccConverterIIDM_;
}

}  // namespace DYN
