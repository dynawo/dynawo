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
 * @file  DYNVscConverterInterfaceIIDM.cpp
 *
 * @brief Vsc Converter data interface : implementation file for IIDM interface
 *
 */
//======================================================================
#include <IIDM/components/VscConverterStation.h>

#include "DYNVscConverterInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

VscConverterInterfaceIIDM::~VscConverterInterfaceIIDM() {
}

VscConverterInterfaceIIDM::VscConverterInterfaceIIDM(IIDM::VscConverterStation& vsc) :
InjectorInterfaceIIDM<IIDM::VscConverterStation>(vsc, vsc.id()),
vscConverterIIDM_(vsc) {
  setType(ComponentInterface::VSC_CONVERTER);
}

int
VscConverterInterfaceIIDM::getComponentVarIndex(const std::string& /*varName*/) const {
  return -1;
}

void
VscConverterInterfaceIIDM::exportStateVariablesUnitComponent() {
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
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom;
    if (vscConverterIIDM_.voltageLevel().nominalV() > 0)
      vNom = vscConverterIIDM_.voltageLevel().nominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, vscConverterIIDM_.voltageLevel().id());

    double theta = busInterface_->getAngle0();
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
  InjectorInterfaceIIDM<IIDM::VscConverterStation>::setBusInterface(busInterface);
}

void
VscConverterInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::VscConverterStation>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
VscConverterInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getBusInterface();
}

bool
VscConverterInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getInitialConnected();
}

bool
VscConverterInterfaceIIDM::isConnected() const {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::isConnected();
}

double
VscConverterInterfaceIIDM::getVNom() const {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getVNom();
}

bool
VscConverterInterfaceIIDM::hasP() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::hasP();
}

bool
VscConverterInterfaceIIDM::hasQ() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::hasQ();
}

double
VscConverterInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getP();
}

double
VscConverterInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::VscConverterStation>::getQ();
}

double
VscConverterInterfaceIIDM::getQMax() {
  if (vscConverterIIDM_.has_minMaxReactiveLimits()) {
    return vscConverterIIDM_.minMaxReactiveLimits().max();
  } else if (vscConverterIIDM_.has_reactiveCapabilityCurve()) {
    assert(vscConverterIIDM_.reactiveCapabilityCurve().size() > 0);
    double qMax = 0;
    const double pGen = - getP();
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = vscConverterIIDM_.reactiveCapabilityCurve();
    if (pGen <= reactiveCurve[0].p) {
      qMax = reactiveCurve[0].qmax;
    } else if (pGen > reactiveCurve[reactiveCurve.size() - 1].p) {
      qMax = reactiveCurve[reactiveCurve.size() - 1].qmax;
    } else {
      for (unsigned int i = 0; i <= reactiveCurve.size() - 2; ++i) {
        IIDM::ReactiveCapabilityCurve::point current_point = reactiveCurve[i];
        IIDM::ReactiveCapabilityCurve::point next_point = reactiveCurve[i+1];
        if (current_point.p <= pGen && next_point.p >= pGen) {
          qMax = current_point.qmax + (pGen - current_point.p) * (next_point.qmax - current_point.qmax) / (next_point.p - current_point.p);
          break;
        }
      }
    }
    return qMax;
  }
  return 0.;
}

double
VscConverterInterfaceIIDM::getQMin() {
  if (vscConverterIIDM_.has_minMaxReactiveLimits()) {
    return vscConverterIIDM_.minMaxReactiveLimits().min();
  } else if (vscConverterIIDM_.has_reactiveCapabilityCurve()) {
    assert(vscConverterIIDM_.reactiveCapabilityCurve().size() > 0);
    double qMin = 0;
    const double pGen = - getP();
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = vscConverterIIDM_.reactiveCapabilityCurve();
    if (pGen <= reactiveCurve[0].p) {
      qMin = reactiveCurve[0].qmin;
    } else if (pGen > reactiveCurve[reactiveCurve.size() - 1].p) {
      qMin = reactiveCurve[reactiveCurve.size() - 1].qmin;
    } else {
      for (unsigned int i = 0; i <= reactiveCurve.size() - 2; ++i) {
        IIDM::ReactiveCapabilityCurve::point current_point = reactiveCurve[i];
        IIDM::ReactiveCapabilityCurve::point next_point = reactiveCurve[i+1];
        if (current_point.p <= pGen && next_point.p >= pGen) {
          qMin = current_point.qmin + (pGen - current_point.p) * (next_point.qmin - current_point.qmin) / (next_point.p - current_point.p);
        }
      }
    }
    return qMin;
  }
  return 0.;
}

std::vector<VscConverterInterface::ReactiveCurvePoint>
VscConverterInterfaceIIDM::getReactiveCurvesPoints() const {
  std::vector<ReactiveCurvePoint> ret;
  if (vscConverterIIDM_.has_reactiveCapabilityCurve()) {
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = vscConverterIIDM_.reactiveCapabilityCurve();
    for (IIDM::ReactiveCapabilityCurve::const_iterator it = reactiveCurve.begin(); it != reactiveCurve.end(); ++it) {
      ReactiveCurvePoint point(it->p, it->qmin, it->qmax);
      ret.push_back(point);
    }
  }

  return ret;
}

string
VscConverterInterfaceIIDM::getID() const {
  return vscConverterIIDM_.id();
}

double
VscConverterInterfaceIIDM::getLossFactor() const {
  return vscConverterIIDM_.lossFactor();
}

bool
VscConverterInterfaceIIDM::getVoltageRegulatorOn() const {
  return vscConverterIIDM_.voltageRegulatorOn();
}

double
VscConverterInterfaceIIDM::getReactivePowerSetpoint() const {
  if (!vscConverterIIDM_.has_reactivePowerSetpoint()) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "vscConverter", vscConverterIIDM_.id(), "ReactivePowerSetPoint") << Trace::endline;
    return 0;
  }
  return vscConverterIIDM_.reactivePowerSetpoint();
}

double
VscConverterInterfaceIIDM::getVoltageSetpoint() const {
  if (!vscConverterIIDM_.has_voltageSetpoint()) {
    Trace::warn("DATAINTERFACE") << DYNLog(VariableNotSet, "vscConverter", vscConverterIIDM_.id(), "VoltageSetPoint") << Trace::endline;
    return 0;
  }
  return vscConverterIIDM_.voltageSetpoint();
}

IIDM::VscConverterStation&
VscConverterInterfaceIIDM::getVscIIDM() {
  return vscConverterIIDM_;
}

}  // namespace DYN
