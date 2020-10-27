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
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(-1 * getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(-1 * getQ())));
  if (getBusInterface()) {
    double U0 = getBusInterface()->getV0();
    double vNom;
    // DG-    if (vscConverterIIDM_.getHvdcLine().get().getNominalVoltage() > 0)    // DG-: Nominal Voltage cannot be <=0 in powsybl-2
    vNom = vscConverterIIDM_.getHvdcLine().get().getNominalVoltage();
    // DG-    else
    // DG-      throw DYNError(Error::MODELER, UndefinedNominalV, vscConverterIIDM_.getHvdcLine().get().getId());
    double teta = getBusInterface()->getAngle0();
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(teta * M_PI / 180)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(teta)));

  } else {
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
  }
}

void
VscConverterInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM::setBusInterface(busInterface);
}

void
VscConverterInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
VscConverterInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM::getBusInterface();
}

bool
VscConverterInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM::getInitialConnected();
}

double
VscConverterInterfaceIIDM::getVNom() const {
  return InjectorInterfaceIIDM::getVNom();
}

bool
VscConverterInterfaceIIDM::hasP() {
  return InjectorInterfaceIIDM::hasP();
}

bool
VscConverterInterfaceIIDM::hasQ() {
  return InjectorInterfaceIIDM::hasQ();
}

double
VscConverterInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM::getP();
}

double
VscConverterInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM::getQ();
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
  /*  if (std::isnan(vscConverterIIDM_.getReactivePowerSetpoint())) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "vscConverter", vscConverterIIDM_.getId(), "ReactivePowerSetPoint") << Trace::endline;
    return 0.0;
  }         // No way to build such an invalid object in new powsyb: commented since it cannot be tested DG+
*/
  return vscConverterIIDM_.getReactivePowerSetpoint();
}

double
VscConverterInterfaceIIDM::getVoltageSetpoint() const {
  /*  if (std::isnan(vscConverterIIDM_.getVoltageSetpoint())) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "vscConverter", vscConverterIIDM_.getId(), "VoltageSetPoint") << Trace::endline;
    return 0.0;
  }         // No way to build such an invalid object in new powsyb: commented since it cannot be tested DG+
*/
  return vscConverterIIDM_.getVoltageSetpoint();
}

powsybl::iidm::VscConverterStation&
VscConverterInterfaceIIDM::getVscIIDM() {
  return vscConverterIIDM_;
}

}  // namespace DYN
