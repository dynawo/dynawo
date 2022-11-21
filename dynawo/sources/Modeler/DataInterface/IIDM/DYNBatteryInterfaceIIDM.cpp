//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

//======================================================================
/**
 * @file  DYNBatteryInterfaceIIDM.cpp
 *
 * @brief Battery data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include <IIDM/components/Battery.h>

#include "DYNBatteryInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

BatteryInterfaceIIDM::~BatteryInterfaceIIDM() {
}

BatteryInterfaceIIDM::BatteryInterfaceIIDM(IIDM::Battery& battery) :
InjectorInterfaceIIDM<IIDM::Battery>(battery, battery.id()),
batteryIIDM_(battery) {
  setType(ComponentInterface::GENERATOR);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
  activePowerControl_ = battery.findExtension<IIDM::extensions::activepowercontrol::ActivePowerControl>();
}

int
BatteryInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
  int index = -1;
  if ( varName == "p" )
    index = VAR_P;
  else if ( varName == "q" )
    index = VAR_Q;
  else if ( varName == "state" )
    index = VAR_STATE;
  return index;
}

void
BatteryInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  batteryIIDM_.p(-1 * getValue<double>(VAR_P) * SNREF);
  batteryIIDM_.q(-1 * getValue<double>(VAR_Q) * SNREF);

  if (batteryIIDM_.has_connection()) {
    if (batteryIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        batteryIIDM_.connect();
      else
        batteryIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(batteryIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(batteryIIDM_.node());
    }
  }
}

void
BatteryInterfaceIIDM::importStaticParameters() {
  staticParameters_.clear();
  double pMax = getPMax();
  double qMax = getQMax();
  double qMin = getQMin();
  staticParameters_.insert(std::make_pair("p_pu", StaticParameter("p_pu", StaticParameter::DOUBLE).setValue(getP() / SNREF)));
  staticParameters_.insert(std::make_pair("q_pu", StaticParameter("q_pu", StaticParameter::DOUBLE).setValue(getQ() / SNREF)));
  staticParameters_.insert(std::make_pair("pMin_pu", StaticParameter("pMin_pu", StaticParameter::DOUBLE).setValue(getPMin() / SNREF)));
  staticParameters_.insert(std::make_pair("pMax_pu", StaticParameter("pMax_pu", StaticParameter::DOUBLE).setValue(pMax / SNREF)));
  staticParameters_.insert(std::make_pair("qMax_pu", StaticParameter("qMax_pu", StaticParameter::DOUBLE).setValue(qMax / SNREF)));
  staticParameters_.insert(std::make_pair("qMin_pu", StaticParameter("qMin_pu", StaticParameter::DOUBLE).setValue(qMin / SNREF)));
  staticParameters_.insert(std::make_pair("p", StaticParameter("p", StaticParameter::DOUBLE).setValue(getP())));
  staticParameters_.insert(std::make_pair("q", StaticParameter("q", StaticParameter::DOUBLE).setValue(getQ())));
  staticParameters_.insert(std::make_pair("pMin", StaticParameter("pMin", StaticParameter::DOUBLE).setValue(getPMin())));
  staticParameters_.insert(std::make_pair("pMax", StaticParameter("pMax", StaticParameter::DOUBLE).setValue(pMax)));
  staticParameters_.insert(std::make_pair("qMax", StaticParameter("qMax", StaticParameter::DOUBLE).setValue(qMax)));
  staticParameters_.insert(std::make_pair("qMin", StaticParameter("qMin", StaticParameter::DOUBLE).setValue(qMin)));
  staticParameters_.insert(std::make_pair("targetP_pu", StaticParameter("targetP_pu", StaticParameter::DOUBLE).setValue(getTargetP() / SNREF)));
  staticParameters_.insert(std::make_pair("targetP", StaticParameter("targetP", StaticParameter::DOUBLE).setValue(getTargetP())));
  double sNom = sqrt(pMax * pMax + qMax * qMax);
  staticParameters_.insert(std::make_pair("sNom", StaticParameter("sNom", StaticParameter::DOUBLE).setValue(sNom)));
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom;
    if (batteryIIDM_.voltageLevel().nominalV() > 0)
      vNom = batteryIIDM_.voltageLevel().nominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, batteryIIDM_.voltageLevel().id());

    double theta = busInterface_->getAngle0();
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(theta * M_PI / 180)));
    staticParameters_.insert(std::make_pair("uc_pu", StaticParameter("uc", StaticParameter::DOUBLE).setValue(U0 / vNom)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("uc", StaticParameter("uc", StaticParameter::DOUBLE).setValue(U0)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(theta)));
    staticParameters_.insert(std::make_pair("vNom", StaticParameter("vNom", StaticParameter::DOUBLE).setValue(vNom)));
    staticParameters_.insert(std::make_pair("targetV_pu", StaticParameter("targetV_pu", StaticParameter::DOUBLE).setValue(getTargetV() / vNom)));
    staticParameters_.insert(std::make_pair("targetV", StaticParameter("targetV", StaticParameter::DOUBLE).setValue(getTargetV())));
    staticParameters_.insert(std::make_pair("targetQ_pu", StaticParameter("targetQ_pu", StaticParameter::DOUBLE).setValue(getTargetQ() / SNREF)));
    staticParameters_.insert(std::make_pair("targetQ", StaticParameter("targetQ", StaticParameter::DOUBLE).setValue(getTargetQ())));
  } else {
    staticParameters_.insert(std::make_pair("v_pu", StaticParameter("v_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle_pu", StaticParameter("angle_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("uc_pu", StaticParameter("uc", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("v", StaticParameter("v", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("angle", StaticParameter("angle", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("uc", StaticParameter("uc", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("vNom", StaticParameter("vNom", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("targetV_pu", StaticParameter("targetV_pu", StaticParameter::DOUBLE).setValue(0.)));
    staticParameters_.insert(std::make_pair("targetV", StaticParameter("targetV", StaticParameter::DOUBLE).setValue(0.)));
  }
}

void
BatteryInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM<IIDM::Battery>::setBusInterface(busInterface);
}

void
BatteryInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::Battery>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
BatteryInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::Battery>::getBusInterface();
}

bool
BatteryInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::Battery>::getInitialConnected();
}

double
BatteryInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::Battery>::getP();
}

double
BatteryInterfaceIIDM::getPMin() {
  return batteryIIDM_.pmin();
}

double
BatteryInterfaceIIDM::getPMax() {
  return batteryIIDM_.pmax();
}

double
BatteryInterfaceIIDM::getTargetP() {
  return 0.;
}


double
BatteryInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::Battery>::getQ();
}

double
BatteryInterfaceIIDM::getQMax() {
  if (batteryIIDM_.has_minMaxReactiveLimits()) {
    return batteryIIDM_.minMaxReactiveLimits().max();
  } else if (batteryIIDM_.has_reactiveCapabilityCurve()) {
    assert(batteryIIDM_.reactiveCapabilityCurve().size() > 0);
    double qMax = 0;
    const double pGen = - getP();
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = batteryIIDM_.reactiveCapabilityCurve();
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
        }
      }
    }
    return qMax;
  } else {
    return 0.3 * getPMax();
  }
}

double
BatteryInterfaceIIDM::getQNom() {
  if (batteryIIDM_.has_minMaxReactiveLimits()) {
    return std::max(std::abs(batteryIIDM_.minMaxReactiveLimits().max()), std::abs(batteryIIDM_.minMaxReactiveLimits().min()));
  } else if (batteryIIDM_.has_reactiveCapabilityCurve()) {
    assert(batteryIIDM_.reactiveCapabilityCurve().size() > 0);
    double qNom = 0;
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = batteryIIDM_.reactiveCapabilityCurve();
    double qNom = 0.0;
    for (unsigned int i = 0; i < reactiveCurve.size(); ++i) {
      IIDM::ReactiveCapabilityCurve::point current_point = reactiveCurve[i];
      if (qNom < std::abs(current_point.qmax)) {
        qNom = std::abs(current_point.qmax);
      }
      if (qNom < std::abs(current_point.qmin)) {
        qNom = std::abs(current_point.qmin);
      }
    }
    return qMax;
  } else {
    return 0.3 * getPMax();
  }
}

double
BatteryInterfaceIIDM::getQMin() {
  if (batteryIIDM_.has_minMaxReactiveLimits()) {
    return batteryIIDM_.minMaxReactiveLimits().min();
  } else if (batteryIIDM_.has_reactiveCapabilityCurve()) {
    assert(batteryIIDM_.reactiveCapabilityCurve().size() > 0);
    double qMin = 0;
    const double pGen = - getP();
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = batteryIIDM_.reactiveCapabilityCurve();
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
  } else {
    return -0.3 * getPMax();
  }
}

double
BatteryInterfaceIIDM::getTargetQ() {
  return 0.;
}

double
BatteryInterfaceIIDM::getTargetV() {
  return 0.;
}

bool
BatteryInterfaceIIDM::hasActivePowerControl() const {
  if (activePowerControl_) {
    return true;
  }
  return false;
}

bool
BatteryInterfaceIIDM::isParticipating() const {
  if (hasActivePowerControl()) {
    return activePowerControl_->participate();
  }
  return false;
}

double
BatteryInterfaceIIDM::getActivePowerControlDroop() const {
  if (hasActivePowerControl() && isParticipating()) {
    return activePowerControl_->droop();
  }
  return 0.;
}

bool
BatteryInterfaceIIDM::hasCoordinatedReactiveControl() const {
  return false;
}

double
BatteryInterfaceIIDM::getCoordinatedReactiveControlPercentage() const {
  return 0.;
}

string
BatteryInterfaceIIDM::getID() const {
  return batteryIIDM_.id();
}

std::vector<GeneratorInterface::ReactiveCurvePoint> BatteryInterfaceIIDM::getReactiveCurvesPoints() const {
  std::vector<GeneratorInterface::ReactiveCurvePoint> ret;
  if (batteryIIDM_.has_reactiveCapabilityCurve()) {
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = batteryIIDM_.reactiveCapabilityCurve();
    for (IIDM::ReactiveCapabilityCurve::const_iterator it = reactiveCurve.begin(); it != reactiveCurve.end(); ++it) {
      ReactiveCurvePoint point(it->p, it->qmin, it->qmax);
      ret.push_back(point);
    }
  }

  return ret;
}

bool BatteryInterfaceIIDM::isVoltageRegulationOn() const {
  return false;
}

boost::optional<double>
BatteryInterfaceIIDM::getDroop() const {
  // external IIDM extension is irrelevant for batteries
  return boost::none;
}

boost::optional<bool>
BatteryInterfaceIIDM::isParticipate() const {
  // external IIDM extension is irrelevant for batteries
  return boost::none;
}

}  // namespace DYN
