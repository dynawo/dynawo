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
 * @file  DYNGeneratorInterfaceIIDM.cpp
 *
 * @brief Generator data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include <IIDM/components/Generator.h>

#include "DYNGeneratorInterfaceIIDM.h"

using std::string;
using boost::shared_ptr;

namespace DYN {

GeneratorInterfaceIIDM::~GeneratorInterfaceIIDM() {
}

GeneratorInterfaceIIDM::GeneratorInterfaceIIDM(IIDM::Generator& generator) :
InjectorInterfaceIIDM<IIDM::Generator>(generator, generator.id()),
generatorIIDM_(generator) {
  setType(ComponentInterface::GENERATOR);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
  activePowerControl_ = generator.findExtension<IIDM::extensions::generatoractivepowercontrol::GeneratorActivePowerControl>();
}

int
GeneratorInterfaceIIDM::getComponentVarIndex(const std::string& varName) const {
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
GeneratorInterfaceIIDM::exportStateVariablesUnitComponent() {
  bool connected = (getValue<int>(VAR_STATE) == CLOSED);
  generatorIIDM_.p(-1 * getValue<double>(VAR_P) * SNREF);
  generatorIIDM_.q(-1 * getValue<double>(VAR_Q) * SNREF);

  if (generatorIIDM_.has_connection()) {
    if (generatorIIDM_.connectionPoint()->is_bus()) {
      if (connected)
        generatorIIDM_.connect();
      else
        generatorIIDM_.disconnect();
    } else {  // is node()
      // should be removed once a solution has been found to propagate switches (de)connection
      // following component (de)connection (only Modelica models)
      if (connected && !getInitialConnected())
        getVoltageLevelInterface()->connectNode(generatorIIDM_.node());
      else if (!connected && getInitialConnected())
        getVoltageLevelInterface()->disconnectNode(generatorIIDM_.node());
    }
  }
}

void
GeneratorInterfaceIIDM::importStaticParameters() {
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
  double qNom = getQNom();
  staticParameters_.insert(std::make_pair("qNom", StaticParameter("qNom", StaticParameter::DOUBLE).setValue(qNom)));
  double sNom = sqrt(pMax * pMax + qNom * qNom);
  staticParameters_.insert(std::make_pair("sNom", StaticParameter("sNom", StaticParameter::DOUBLE).setValue(sNom)));
  if (busInterface_) {
    double U0 = busInterface_->getV0();
    double vNom;
    if (generatorIIDM_.voltageLevel().nominalV() > 0)
      vNom = generatorIIDM_.voltageLevel().nominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, generatorIIDM_.voltageLevel().id());

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
GeneratorInterfaceIIDM::setBusInterface(const shared_ptr<BusInterface>& busInterface) {
  InjectorInterfaceIIDM<IIDM::Generator>::setBusInterface(busInterface);
}

void
GeneratorInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  InjectorInterfaceIIDM<IIDM::Generator>::setVoltageLevelInterface(voltageLevelInterface);
}

shared_ptr<BusInterface>
GeneratorInterfaceIIDM::getBusInterface() const {
  return InjectorInterfaceIIDM<IIDM::Generator>::getBusInterface();
}

bool
GeneratorInterfaceIIDM::getInitialConnected() {
  return InjectorInterfaceIIDM<IIDM::Generator>::getInitialConnected();
}

bool
GeneratorInterfaceIIDM::isConnected() const {
  return InjectorInterfaceIIDM<IIDM::Generator>::isConnected();
}

double
GeneratorInterfaceIIDM::getP() {
  return InjectorInterfaceIIDM<IIDM::Generator>::getP();
}

double
GeneratorInterfaceIIDM::getPMin() {
  return generatorIIDM_.pmin();
}

double
GeneratorInterfaceIIDM::getPMax() {
  return generatorIIDM_.pmax();
}

double
GeneratorInterfaceIIDM::getTargetP() {
  return - 1.0 * generatorIIDM_.targetP();
}


double
GeneratorInterfaceIIDM::getQ() {
  return InjectorInterfaceIIDM<IIDM::Generator>::getQ();
}

double
GeneratorInterfaceIIDM::getQMax() {
  if (generatorIIDM_.has_minMaxReactiveLimits()) {
    return generatorIIDM_.minMaxReactiveLimits().max();
  } else if (generatorIIDM_.has_reactiveCapabilityCurve()) {
    assert(generatorIIDM_.reactiveCapabilityCurve().size() > 0);
    double qMax = 0;
    const double pGen = - getP();
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = generatorIIDM_.reactiveCapabilityCurve();
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
GeneratorInterfaceIIDM::getQNom() {
  if (generatorIIDM_.has_minMaxReactiveLimits()) {
    return std::max(std::abs(generatorIIDM_.minMaxReactiveLimits().max()), std::abs(generatorIIDM_.minMaxReactiveLimits().min()));
  } else if (generatorIIDM_.has_reactiveCapabilityCurve()) {
    assert(generatorIIDM_.reactiveCapabilityCurve().size() > 0);
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = generatorIIDM_.reactiveCapabilityCurve();
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
    return qNom;
  } else {
    return 0.3 * getPMax();
  }
}

double
GeneratorInterfaceIIDM::getQMin() {
  if (generatorIIDM_.has_minMaxReactiveLimits()) {
    return generatorIIDM_.minMaxReactiveLimits().min();
  } else if (generatorIIDM_.has_reactiveCapabilityCurve()) {
    assert(generatorIIDM_.reactiveCapabilityCurve().size() > 0);
    double qMin = 0;
    const double pGen = - getP();
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = generatorIIDM_.reactiveCapabilityCurve();
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
GeneratorInterfaceIIDM::getTargetQ() {
  if (generatorIIDM_.has_targetQ()) {
    return - 1.0 * generatorIIDM_.targetQ();
  } else {
    return 0;
  }
}

double
GeneratorInterfaceIIDM::getTargetV() {
  if (generatorIIDM_.has_targetV()) {
    return generatorIIDM_.targetV();
  } else {
    return 0;
  }
}

bool
GeneratorInterfaceIIDM::hasActivePowerControl() const {
  if (activePowerControl_) {
    return true;
  }
  return false;
}

bool
GeneratorInterfaceIIDM::isParticipating() const {
  if (hasActivePowerControl()) {
    return activePowerControl_->participate();
  }
  return false;
}

double
GeneratorInterfaceIIDM::getActivePowerControlDroop() const {
  if (hasActivePowerControl() && isParticipating()) {
    return activePowerControl_->droop();
  }
  return 0.;
}

bool
GeneratorInterfaceIIDM::hasCoordinatedReactiveControl() const {
  return false;
}

double
GeneratorInterfaceIIDM::getCoordinatedReactiveControlPercentage() const {
  return 0.;
}

string
GeneratorInterfaceIIDM::getID() const {
  return generatorIIDM_.id();
}

std::vector<GeneratorInterface::ReactiveCurvePoint> GeneratorInterfaceIIDM::getReactiveCurvesPoints() const {
  std::vector<GeneratorInterface::ReactiveCurvePoint> ret;
  if (generatorIIDM_.has_reactiveCapabilityCurve()) {
    const IIDM::ReactiveCapabilityCurve& reactiveCurve = generatorIIDM_.reactiveCapabilityCurve();
    for (IIDM::ReactiveCapabilityCurve::const_iterator it = reactiveCurve.begin(); it != reactiveCurve.end(); ++it) {
      ReactiveCurvePoint point(it->p, it->qmin, it->qmax);
      ret.push_back(point);
    }
  }

  return ret;
}

bool GeneratorInterfaceIIDM::isVoltageRegulationOn() const {
  return generatorIIDM_.voltageRegulatorOn();
}

GeneratorInterface::EnergySource_t
GeneratorInterfaceIIDM::getEnergySource() const {
  switch (generatorIIDM_.energySource()) {
  case IIDM::Generator::source_hydro:
    return SOURCE_HYDRO;
  case IIDM::Generator::source_nuclear:
    return SOURCE_NUCLEAR;
  case IIDM::Generator::source_solar:
    return SOURCE_SOLAR;
  case IIDM::Generator::source_thermal:
    return SOURCE_THERMAL;
  case IIDM::Generator::source_wind:
    return SOURCE_WIND;
  case IIDM::Generator::source_other:
    return SOURCE_OTHER;
  }
  return SOURCE_OTHER;
}


}  // namespace DYN
