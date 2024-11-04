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
 * @file  DYNModelStaticVarCompensator.cpp
 *
 * @brief
 *
 */
//======================================================================
#include <iostream>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNModelStaticVarCompensator.h"

#include "DYNModelBus.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNBusInterface.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNMessageTimeline.h"
#include "DYNStaticVarCompensatorInterface.h"
#include "DYNModelVoltageLevel.h"

using boost::shared_ptr;
using std::vector;
using std::map;
using std::string;

namespace DYN {

ModelStaticVarCompensator::ModelStaticVarCompensator(const std::shared_ptr<StaticVarCompensatorInterface>& svc) :
NetworkComponent(svc->getID()),
svc_(svc),
stateModified_(false),
startingPointMode_(WARM) {
  // init data
  connectionState_ = svc->getInitialConnected() ? CLOSED : OPEN;
  mode_ = svc->getRegulationMode();

  // calculate initial conditions
  gSvc0_ = 0.;
  bSvc0_ = 0.;
  ir0_ = 0.;
  ii0_ = 0.;
}

void
ModelStaticVarCompensator::initSize() {
  if (network_->isInitModel()) {
    sizeF_ = 0;
    sizeY_ = 0;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = 0;
  } else {
    sizeF_ = 0;
    sizeY_ = 0;
    sizeZ_ = 2;  // mode, state
    sizeG_ = 0;
    sizeMode_ = 1;

    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

void
ModelStaticVarCompensator::evalStaticYType() {
  // not needed
}

void
ModelStaticVarCompensator::evalStaticFType() {
  // not needed
}

void
ModelStaticVarCompensator::evalF(propertyF_t /*type*/) {
  // not needed
}

void
ModelStaticVarCompensator::setFequations(map<int, string>& /*fEquationIndex*/) {
  // not needed
}

void
ModelStaticVarCompensator::init(int& /*yNum*/) {
  if (!network_->isStartingFromDump()) {
    double gTotal0 = 0.;
    double bTotal0 = 0.;
    double ur0 = 0.;
    double ui0 = 0.;
    double U0 = 0.;
    std::shared_ptr<StaticVarCompensatorInterface> svc = svc_.lock();
    double P0 = svc->getP() / SNREF;
    double Q0;
    double unomBus = svc->getBusInterface()->getVNom();
    double thetaBus0 = svc->getBusInterface()->getAngle0();
    double uBus0 = 0.;
    switch (startingPointMode_) {
    case FLAT:
      Q0 = svc->getReactivePowerSetPoint() / SNREF;
      if (svc->getBusInterface()) {
        uBus0 = svc->getBusInterface()->getVNom();
      }
      break;
    case WARM:
      Q0 = svc->getQ() / SNREF;
      if (svc->getBusInterface()) {
        uBus0 = svc->getBusInterface()->getV0();
      }
      break;
    default:
      Q0 = 0.;
      break;
    }
    ur0 = uBus0 / unomBus * cos(thetaBus0 * DEG_TO_RAD);
    ui0 = uBus0 / unomBus * sin(thetaBus0 * DEG_TO_RAD);
    U0 = sqrt(ur0 * ur0 + ui0 * ui0);
    if (!doubleIsZero(U0)) {
      gTotal0 = P0 / (U0 * U0);
      bTotal0 = -1. * Q0 / (U0 * U0);  // in order to have the same convention as a shunt : b < 0 when Q > 0 (network convention)
      ir0_ = Q0 * ui0 / (ur0 * ur0 + ui0 * ui0);
      ii0_ = - Q0 * ur0 / (ur0 * ur0 + ui0 * ui0);
    }
    gSvc0_ = gTotal0;
    bSvc0_ = bTotal0;
  }
}

double
ModelStaticVarCompensator::P() const {
  return gSvc0_ * modelBus_->getCurrentU(ModelBus::U2PuType_);
}

double
ModelStaticVarCompensator::Q() const {
  return - bSvc0_ * modelBus_->getCurrentU(ModelBus::U2PuType_);
}

double
ModelStaticVarCompensator::ir(const double& ui) const {
  double ir = 0.;
  if (network_->isInitModel()) {
    ir = ir0_;
  } else {
    if (isConnected() && !modelBus_->getSwitchOff()) {
      ir = - bSvc0_ * ui;
    }
  }
  return ir;
}

double
ModelStaticVarCompensator::ii(const double& ur) const {
  double ii = 0.;
  if (network_->isInitModel()) {
    ii = ii0_;
  } else {
    if (isConnected() && !modelBus_->getSwitchOff()) {
      ii = bSvc0_ * ur;
    }
  }
  return ii;
}

double
ModelStaticVarCompensator::ir_dUr() const {
  return 0.;
}

double
ModelStaticVarCompensator::ir_dUi() const {
  double ir_dUi = 0.;
  if (isConnected() && !modelBus_->getSwitchOff()) {
    ir_dUi = - bSvc0_;
  }
  return ir_dUi;
}

double
ModelStaticVarCompensator::ii_dUr() const {
  double ii_dUr = 0.;
  if (isConnected() && !modelBus_->getSwitchOff()) {
    ii_dUr = bSvc0_;
  }
  return ii_dUr;
}

double
ModelStaticVarCompensator::ii_dUi() const {
  return 0.;
}

void
ModelStaticVarCompensator::evalJt(SparseMatrix& /*jt*/, const double& /*cj*/, const int& /*rowOffset*/) {
  // not needed
}

void
ModelStaticVarCompensator::evalJtPrim(SparseMatrix& /*jt*/, const int& /*rowOffset*/) {
  // not needed
}

void
ModelStaticVarCompensator::getY0() {
  if (!network_->isInitModel()) {
    if (!network_->isStartingFromDump()) {
      z_[modeNum_] = mode_;
      z_[connectionStateNum_] = getConnected();
    } else {
      mode_ = static_cast<StaticVarCompensatorInterface::RegulationMode_t>(static_cast<int>(z_[modeNum_]));
      State svcCurrState = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
      if (svcCurrState == CLOSED) {
        if (modelBus_->getConnectionState() != CLOSED) {
          modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
          stateModified_ = true;
        }
      } else if (svcCurrState == OPEN) {
        if (modelBus_->getConnectionState() != OPEN) {
          modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
          stateModified_ = true;
        }
      } else if (svcCurrState == UNDEFINED_STATE) {
        throw DYNError(Error::MODELER, UndefinedComponentState, id_);
      } else {
        throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
      }
      setConnected(svcCurrState);
    }
  }
}

void
ModelStaticVarCompensator::dumpInternalVariables(std::stringstream& streamVariables) const {
  boost::archive::binary_oarchive os(streamVariables);
  os << ir0_;
  os << ii0_;
  os << gSvc0_;
  os << bSvc0_;
}

void
ModelStaticVarCompensator::loadInternalVariables(std::stringstream& streamVariables) {
  boost::archive::binary_iarchive is(streamVariables);
  is >> ir0_;
  is >> ii0_;
  is >> gSvc0_;
  is >> bSvc0_;
}

NetworkComponent::StateChange_t
ModelStaticVarCompensator::evalZ(const double& /*t*/) {
  mode_ = static_cast<StaticVarCompensatorInterface::RegulationMode_t>(static_cast<int>(z_[modeNum_]));

  if (modelBus_->getConnectionState() == OPEN)
    z_[connectionStateNum_] = OPEN;

  State currState = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
  if (currState != getConnected()) {
    Trace::info() << DYNLog(SVCStateChange, id_, getConnected(), z_[connectionStateNum_]) << Trace::endline;
    if (currState == OPEN) {
      DYNAddTimelineEvent(network_, id_, SVarCDisconnected);
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else {
      DYNAddTimelineEvent(network_, id_, SVarCConnected);
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
    stateModified_ = true;
    setConnected(currState);
  }
  return stateModified_?NetworkComponent::STATE_CHANGE:NetworkComponent::NO_CHANGE;
}

void
ModelStaticVarCompensator::collectSilentZ(BitMask* silentZTable) {
  silentZTable[connectionStateNum_].setFlags(NotUsedInDiscreteEquations);
}

void
ModelStaticVarCompensator::evalG(const double& /*t*/) {
  // not needed
}

void
ModelStaticVarCompensator::evalCalculatedVars() {
  calculatedVars_[pNum_] = (isConnected())?-P():0.;
  calculatedVars_[qNum_] = (isConnected())?-Q():0.;
}

void
ModelStaticVarCompensator::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
  switch (numCalculatedVar) {
    case pNum_:
      break;
    case qNum_: {
      int urYNum = modelBus_->urYNum();
      int uiYNum = modelBus_->uiYNum();
      numVars.push_back(urYNum);
      numVars.push_back(uiYNum);
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}


void
ModelStaticVarCompensator::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  switch (numCalculatedVar) {
    case pNum_:
      if (isConnected()) {
        double ur = modelBus_->ur();
        double ui = modelBus_->ui();
        double g = gSvc0_;
        // PProduced =  - g * (ur * ur + ui * ui)
        res[0] = - g * 2. * ur;  // @P/@Ur
        res[1] = - g * 2. * ui;  // @P/@Ui
        res[2] = - (ur * ur + ui * ui);  // @P/@GSvc
      }
      break;
    case qNum_: {
      if (isConnected()) {
        double ur = modelBus_->ur();
        double ui = modelBus_->ui();
        double b = bSvc0_;
        // QProduced =  b * (ur * ur + ui * ui)
        res[0] = b * 2. * ur;  // @Q/@Ur
        res[1] = b * 2. * ui;  // @Q/@Ui
        res[2] = (ur * ur + ui * ui);  // @Q/@BSvc
      }
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelStaticVarCompensator::evalCalculatedVarI(unsigned numCalculatedVar) const {
  switch (numCalculatedVar) {
    case pNum_:
      if (isConnected()) {
        return (isConnected())?-P():0.;
      }
    break;
    case qNum_: {
      if (isConnected()) {
        return (isConnected())?-Q():0.;
      }
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return 0.;
}

void
ModelStaticVarCompensator::setGequations(map<int, string>& /*gEquationIndex*/) {
  // not needed
}

void
ModelStaticVarCompensator::evalNodeInjection() {
  if (network_->isInitModel()) {
    modelBus_->irAdd(ir0_);
    modelBus_->iiAdd(ii0_);
  } else {
    double ur = modelBus_->ur();
    double ui = modelBus_->ui();
    modelBus_->irAdd(ir(ui));
    modelBus_->iiAdd(ii(ur));
  }
}

void
ModelStaticVarCompensator::evalYMat() {
  // not needed
}

void
ModelStaticVarCompensator::evalDerivatives(const double /*cj*/) {
  if (network_->isInitModel())
    return;
  if (isConnected()) {
    int urYNum = modelBus_->urYNum();
    int uiYNum = modelBus_->uiYNum();
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr());
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii_dUr());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi());
  }
}

void
ModelStaticVarCompensator::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_mode_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
}

void
ModelStaticVarCompensator::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_mode_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", INTEGER));
}

void
ModelStaticVarCompensator::defineElements(vector<Element> &elements, map<string, int>& mapElement) {
  string svcName = id_;

  // ========  CALCULATED VARIABLE ======
  addElementWithValue(svcName + string("_P"), "StaticVarCompensator", elements, mapElement);
  addElementWithValue(svcName + string("_Q"), "StaticVarCompensator", elements, mapElement);

  // ========  DISCRETE VARIABLE ======
  addElementWithValue(svcName + string("_mode"), "StaticVarCompensator", elements, mapElement);
  addElementWithValue(svcName + string("_state"), "StaticVarCompensator", elements, mapElement);
}

NetworkComponent::StateChange_t
ModelStaticVarCompensator::evalState(const double& /*time*/) {
  if (stateModified_) {
    stateModified_ = false;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelStaticVarCompensator::defineParameters(std::vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ModelStaticVarCompensator::defineNonGenericParameters(std::vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ModelStaticVarCompensator::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  bool startingPointModeFound = false;
  std::string startingPointMode = getParameterDynamicNoThrow<string>(params, "startingPointMode", startingPointModeFound);
  if (startingPointModeFound) {
    startingPointMode_ = getStartingPointMode(startingPointMode);
  }
}
}  // namespace DYN
