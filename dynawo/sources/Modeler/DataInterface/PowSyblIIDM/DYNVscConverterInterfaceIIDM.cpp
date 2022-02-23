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
 * @file  DYNVscConverterInterfaceIIDM.cpp
 *
 * @brief Vsc Converter data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include "DYNVscConverterInterfaceIIDM.h"

#include "DYNInjectorInterfaceIIDM.h"

#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/VscConverterStation.hpp>

#include <boost/shared_ptr.hpp>
#include <string>

using boost::shared_ptr;

namespace DYN {

VscConverterInterfaceIIDM::VscConverterInterfaceIIDM(powsybl::iidm::VscConverterStation& vsc) : InjectorInterfaceIIDM(vsc, vsc.getId()),
                                                                                                vscConverterIIDM_(vsc) {
  setType(ComponentInterface::VSC_CONVERTER);
}

void
VscConverterInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(-1 * getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(-1 * getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("targetQ_pu", StaticParameter("targetQ_pu",
      StaticParameter::DOUBLE).setValue(-1 * getReactivePowerSetpoint() / SNREF)));
  staticParameters_.insert(std::make_pair("qMax_pu", StaticParameter("qMax_pu", StaticParameter::DOUBLE).setValue(getQMax() / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(-1 * getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(-1 * getQ())));
  staticParameters_.insert(std::make_pair("targetQ", StaticParameter("targetQ", StaticParameter::DOUBLE).setValue(-1 * getReactivePowerSetpoint())));
  staticParameters_.insert(std::make_pair("qMax", StaticParameter("qMax", StaticParameter::DOUBLE).setValue(getQMax())));
  if (getBusInterface()) {
    double U0 = getBusInterface()->getV0();
    double vNom = vscConverterIIDM_.getHvdcLine().get().getNominalV();
    double theta = getBusInterface()->getAngle0();
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(theta * M_PI / 180)));
    staticParameters_.insert(std::make_pair("targetV_pu", StaticParameter("targetV_pu", StaticParameter::DOUBLE).setValue(getVoltageSetpoint() / getVNom())));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(theta)));
    staticParameters_.insert(std::make_pair("targetV", StaticParameter("targetV", StaticParameter::DOUBLE).setValue(getVoltageSetpoint())));
  } else {
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("targetV_pu", StaticParameter("targetV_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("targetV", StaticParameter("targetV", StaticParameter::DOUBLE).setValue(0.)));
  }
}

void
VscConverterInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  setBusInterfaceInjector(busInterface);
}

void
VscConverterInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  setVoltageLevelInterfaceInjector(voltageLevelInterface);
}

shared_ptr<BusInterface>
VscConverterInterfaceIIDM::getBusInterface() const {
  return getBusInterfaceInjector();
}

bool
VscConverterInterfaceIIDM::getInitialConnected() {
  return getInitialConnectedInjector();
}

bool
VscConverterInterfaceIIDM::isConnected() const {
  return isConnectedInjector();
}

double
VscConverterInterfaceIIDM::getVNom() const {
  return getVNomInjector();
}

bool
VscConverterInterfaceIIDM::hasP() {
  return hasPInjector();
}

bool
VscConverterInterfaceIIDM::hasQ() {
  return hasQInjector();
}

double
VscConverterInterfaceIIDM::getP() {
  return getPInjector();
}

double
VscConverterInterfaceIIDM::getQMax() {
  return vscConverterIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getMaxQ(-1 * getP());
}

double
VscConverterInterfaceIIDM::getQMin() {
  return vscConverterIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getMinQ(-1 * getP());
}

std::vector<VscConverterInterface::ReactiveCurvePoint> VscConverterInterfaceIIDM::getReactiveCurvesPoints() const {
  std::vector<VscConverterInterface::ReactiveCurvePoint> ret;
  if (vscConverterIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::CURVE) {
    const auto& reactiveCurve = vscConverterIIDM_.getReactiveLimits<powsybl::iidm::ReactiveCapabilityCurve>();
    for (const auto& point : reactiveCurve.getPoints()) {
      ret.emplace_back(point.getP(), point.getMinQ(), point.getMaxQ());
    }
  }

  return ret;
}

double
VscConverterInterfaceIIDM::getQ() {
  return getQInjector();
}

std::string
VscConverterInterfaceIIDM::getID() const {
  return vscConverterIIDM_.getId();
}

double
VscConverterInterfaceIIDM::getLossFactor() const {
  return vscConverterIIDM_.getLossFactor();
}

bool
VscConverterInterfaceIIDM::getVoltageRegulatorOn() const {
  return vscConverterIIDM_.isVoltageRegulatorOn();
}

double
VscConverterInterfaceIIDM::getReactivePowerSetpoint() const {
  return vscConverterIIDM_.getReactivePowerSetpoint();
}

double
VscConverterInterfaceIIDM::getVoltageSetpoint() const {
  return vscConverterIIDM_.getVoltageSetpoint();
}

powsybl::iidm::VscConverterStation&
VscConverterInterfaceIIDM::getVscIIDM() {
  return vscConverterIIDM_;
}

int
VscConverterInterfaceIIDM::getComponentVarIndex(const std::string& /*varName*/) const {
  return -1;
}

}  // namespace DYN
