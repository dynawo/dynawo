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

#include "DYNLccConverterInterfaceIIDM.h"

#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/LccConverterStation.hpp>

#include <string>


namespace DYN {

LccConverterInterfaceIIDM::LccConverterInterfaceIIDM(powsybl::iidm::LccConverterStation& lcc) : LccConverterInterface(false),
                                                                                                InjectorInterfaceIIDM(lcc, lcc.getId()),
                                                                                                lccConverterIIDM_(lcc) {
  if (hasQInjector() || hasPInjector()) {
    hasInitialConditions(true);
  }
  setType(ComponentInterface::LCC_CONVERTER);
}

int
LccConverterInterfaceIIDM::getComponentVarIndex(const std::string& /*varName*/) const {
  return -1;
}

void
LccConverterInterfaceIIDM::exportStateVariablesUnitComponent() {
  /* not needed */
}

void
LccConverterInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(-1 * getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(-1 * getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(-1 * getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(-1 * getQ())));
  staticParameters_.insert(std::make_pair("powerFactor", StaticParameter("powerFactor", StaticParameter::DOUBLE).setValue(getPowerFactor())));
  if (getBusInterface()) {
    double U0 = getBusInterface()->getV0();
    double vNom = lccConverterIIDM_.getHvdcLine().get().getNominalV();
    double theta = getBusInterface()->getAngle0();
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
LccConverterInterfaceIIDM::setBusInterface(const std::shared_ptr<BusInterface>& busInterface) {
  setBusInterfaceInjector(busInterface);
}

void
LccConverterInterfaceIIDM::setVoltageLevelInterface(const std::shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  setVoltageLevelInterfaceInjector(voltageLevelInterface);
}

std::shared_ptr<BusInterface>
LccConverterInterfaceIIDM::getBusInterface() const {
  return getBusInterfaceInjector();
}

bool
LccConverterInterfaceIIDM::getInitialConnected() {
  return getInitialConnectedInjector();
}

bool
LccConverterInterfaceIIDM::isConnected() const {
  return isConnectedInjector();
}

double
LccConverterInterfaceIIDM::getVNom() const {
  return getVNomInjector();
}

bool
LccConverterInterfaceIIDM::hasP() {
  return hasPInjector();
}

bool
LccConverterInterfaceIIDM::hasQ() {
  return hasQInjector();
}

double
LccConverterInterfaceIIDM::getP() {
  return getPInjector();
}

double
LccConverterInterfaceIIDM::getQ() {
  return getQInjector();
}

const std::string&
LccConverterInterfaceIIDM::getID() const {
  return lccConverterIIDM_.getId();
}

double
LccConverterInterfaceIIDM::getLossFactor() const {
  return lccConverterIIDM_.getLossFactor();
}

double
LccConverterInterfaceIIDM::getPowerFactor() const {
  return lccConverterIIDM_.getPowerFactor();
}

powsybl::iidm::LccConverterStation&
LccConverterInterfaceIIDM::getLccIIDM() {
  return lccConverterIIDM_;
}

}  // namespace DYN
