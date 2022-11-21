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
 * @file  DYNGeneratorInterfaceIIDM.cpp
 *
 * @brief Generator data interface : implementation file for IIDM interface
 *
 */
//======================================================================

#include "DYNGeneratorInterfaceIIDM.h"

#include <powsybl/iidm/MinMaxReactiveLimits.hpp>

using std::string;
using std::vector;
using boost::shared_ptr;

namespace DYN {

GeneratorInterfaceIIDM::~GeneratorInterfaceIIDM() {
  destroyGeneratorActivePowerControl_(generatorActivePowerControl_);
}

GeneratorInterfaceIIDM::GeneratorInterfaceIIDM(powsybl::iidm::Generator& generator) :
InjectorInterfaceIIDM(generator, generator.getId()),
generatorIIDM_(generator) {
  setType(ComponentInterface::GENERATOR);
  stateVariables_.resize(3);
  stateVariables_[VAR_P] = StateVariable("p", StateVariable::DOUBLE);  // P
  stateVariables_[VAR_Q] = StateVariable("q", StateVariable::DOUBLE);  // Q
  stateVariables_[VAR_STATE] = StateVariable("state", StateVariable::INT);   // connectionState
  activePowerControl_ = generator.findExtension<powsybl::iidm::extensions::iidm::ActivePowerControl>();
  coordinatedReactiveControl_ = generator.findExtension<powsybl::iidm::extensions::iidm::CoordinatedReactiveControl>();

  auto libPath = IIDMExtensions::findLibraryPath();

  auto generatorActivePowerControlDef = IIDMExtensions::getExtension<GeneratorActivePowerControlIIDMExtension>(libPath.generic_string());
  generatorActivePowerControl_ = std::get<IIDMExtensions::CREATE_FUNCTION>(generatorActivePowerControlDef)(generator);
  destroyGeneratorActivePowerControl_ = std::get<IIDMExtensions::DESTROY_FUNCTION>(generatorActivePowerControlDef);
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
  generatorIIDM_.getTerminal().setP(-1 * getValue<double>(VAR_P) * SNREF);
  generatorIIDM_.getTerminal().setQ(-1 * getValue<double>(VAR_Q) * SNREF);

  if (getVoltageLevelInterfaceInjector()->isNodeBreakerTopology()) {
    // should be removed once a solution has been found to propagate switches (de)connection
    // following component (de)connection (only Modelica models)
    if (connected && !getInitialConnected())
      getVoltageLevelInterfaceInjector()->connectNode(static_cast<unsigned int>(generatorIIDM_.getTerminal().getNodeBreakerView().getNode()));
    else if (!connected && getInitialConnected())
      getVoltageLevelInterfaceInjector()->disconnectNode(static_cast<unsigned int>(generatorIIDM_.getTerminal().getNodeBreakerView().getNode()));
  } else {
    if (connected)
      generatorIIDM_.getTerminal().connect();
    else
      generatorIIDM_.getTerminal().disconnect();
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
  double sNom = sqrt(pMax * pMax + qMax * qMax);
  staticParameters_.insert(std::make_pair("sNom", StaticParameter("sNom", StaticParameter::DOUBLE).setValue(sNom)));
  if (getBusInterface()) {
    double U0 = getBusInterface()->getV0();
    double vNom;
    if (generatorIIDM_.getTerminal().getVoltageLevel().getNominalV() > 0)
      vNom = generatorIIDM_.getTerminal().getVoltageLevel().getNominalV();
    else
      throw DYNError(Error::MODELER, UndefinedNominalV, generatorIIDM_.getTerminal().getVoltageLevel().getId());

    double theta = getBusInterface()->getAngle0();
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
  setBusInterfaceInjector(busInterface);
}

void
GeneratorInterfaceIIDM::setVoltageLevelInterface(const shared_ptr<VoltageLevelInterface>& voltageLevelInterface) {
  setVoltageLevelInterfaceInjector(voltageLevelInterface);
}

shared_ptr<BusInterface>
GeneratorInterfaceIIDM::getBusInterface() const {
  return getBusInterfaceInjector();
}

bool
GeneratorInterfaceIIDM::getInitialConnected() {
  return getInitialConnectedInjector();
}

bool
GeneratorInterfaceIIDM::isConnected() const {
  return isConnectedInjector();
}

double
GeneratorInterfaceIIDM::getP() {
  return getPInjector();
}

double
GeneratorInterfaceIIDM::getPMin() {
  return generatorIIDM_.getMinP();
}

double
GeneratorInterfaceIIDM::getPMax() {
  return generatorIIDM_.getMaxP();
}

double
GeneratorInterfaceIIDM::getTargetP() {
  return - 1.0 * generatorIIDM_.getTargetP();
}


double
GeneratorInterfaceIIDM::getQ() {
  return getQInjector();
}

double
GeneratorInterfaceIIDM::getQMax() {
  if (generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::MIN_MAX) {
    return generatorIIDM_.getReactiveLimits<powsybl::iidm::MinMaxReactiveLimits>().getMaxQ();
  } else if (generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::CURVE) {
    assert(generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveCapabilityCurve>().getPointCount() > 0);
    double qMax = 0.0;
    const double pGen = - getP();
    const auto& points = getReactiveCurvesPoints();

    if (pGen <= points[0].p) {
      qMax = points[0].qmax;
    } else if (pGen > points[points.size() - 1].p) {
      qMax = points[points.size() - 1].qmax;
    } else {
      for (unsigned int i = 0; i <= points.size() - 2; ++i) {
        auto current_point = points[i];
        auto next_point = points[i + 1];
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
  if (generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::MIN_MAX) {
    return std::max(std::abs(generatorIIDM_.getReactiveLimits<powsybl::iidm::MinMaxReactiveLimits>().getMaxQ()),
        std::abs(generatorIIDM_.getReactiveLimits<powsybl::iidm::MinMaxReactiveLimits>().getMinQ()));
  } else if (generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::CURVE) {
    assert(generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveCapabilityCurve>().getPointCount() > 0);
    double qNom = 0.0;
    const auto& points = getReactiveCurvesPoints();
    for (unsigned int i = 0; i < points.size(); ++i) {
      auto current_point = points[i];
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
  if (generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::MIN_MAX) {
    return generatorIIDM_.getReactiveLimits<powsybl::iidm::MinMaxReactiveLimits>().getMinQ();
  } else if (generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::CURVE) {
    assert(generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveCapabilityCurve>().getPointCount() > 0);
    double qMin = 0.0;
    const double pGen = - getP();
    const auto& points = getReactiveCurvesPoints();

    if (pGen <= points[0].p) {
      qMin = points[0].qmin;
    } else if (pGen > points[points.size() - 1].p) {
      qMin = points[points.size() - 1].qmin;
    } else {
      for (unsigned int i = 0; i <= points.size() - 2; ++i) {
        auto current_point = points[i];
        auto next_point = points[i + 1];
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
  if (!std::isnan(generatorIIDM_.getTargetQ())) {
    return - 1.0 * generatorIIDM_.getTargetQ();
  } else {
    return 0;
  }
}

double
GeneratorInterfaceIIDM::getTargetV() {
  if (!std::isnan(generatorIIDM_.getTargetV())) {
    return generatorIIDM_.getTargetV();
  } else {
    return 0;
  }
}


string
GeneratorInterfaceIIDM::getID() const {
  return generatorIIDM_.getId();
}

vector<GeneratorInterface::ReactiveCurvePoint> GeneratorInterfaceIIDM::getReactiveCurvesPoints() const {
  vector<GeneratorInterface::ReactiveCurvePoint> ret;
  if (generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveLimits>().getKind() == powsybl::iidm::ReactiveLimitsKind::CURVE) {
    const auto& reactiveCurve = generatorIIDM_.getReactiveLimits<powsybl::iidm::ReactiveCapabilityCurve>();
    for (const auto& point : reactiveCurve.getPoints()) {
      ret.emplace_back(point.getP(), point.getMinQ(), point.getMaxQ());
    }
  }

  return ret;
}

bool GeneratorInterfaceIIDM::isVoltageRegulationOn() const {
  return generatorIIDM_.isVoltageRegulatorOn();
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
    return activePowerControl_.get().isParticipate();
  }
  return false;
}

double
GeneratorInterfaceIIDM::getActivePowerControlDroop() const {
  if (hasActivePowerControl() && isParticipating()) {
    return activePowerControl_.get().getDroop();
  }
  return 0.;
}

bool
GeneratorInterfaceIIDM::hasCoordinatedReactiveControl() const {
  if (coordinatedReactiveControl_) {
    return true;
  }
  return false;
}

double
GeneratorInterfaceIIDM::getCoordinatedReactiveControlPercentage() const {
  if (hasCoordinatedReactiveControl()) {
    return coordinatedReactiveControl_.get().getQPercent();
  }
  return 0.;
}

boost::optional<double> GeneratorInterfaceIIDM::getDroop() const {
  return generatorActivePowerControl_ ? generatorActivePowerControl_->getDroop() : boost::optional<double>();
}

boost::optional<bool> GeneratorInterfaceIIDM::isParticipate() const {
  return generatorActivePowerControl_ ? generatorActivePowerControl_->isParticipate() : boost::optional<bool>();
}

}  // namespace DYN
