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
 * @file  DYNModelShuntCompensator.cpp
 *
 * @brief
 *
 */

#include "DYNModelShuntCompensator.h"

#include <DYNTimer.h>

#include "PARParametersSet.h"

#include "DYNModelBus.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNBusInterface.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNMessageTimeline.h"
#include "DYNModelVoltageLevel.h"

using boost::shared_ptr;

using std::vector;
using std::string;

using parameters::ParametersSet;

namespace DYN {

ModelShuntCompensator::ModelShuntCompensator(const std::shared_ptr<ShuntCompensatorInterface>& shunt) :
NetworkComponent(shunt->getID()),
shunt_(shunt),
modelBus_(),
noReclosingDelay_(0.),
stateModified_(false),
ir0_(0.),
ii0_(0.),
startingPointMode_(WARM) {
  // init data
  currentSection_ = shunt->getCurrentSection();
  maximumSection_ = shunt->getMaximumSection();
  suscepAtMaximumSec_ = shunt->getB(maximumSection_);
  vNom_ = shunt->getVNom();
  suscepPu_ = shunt->getB(currentSection_) * vNom_ * vNom_ / SNREF;
  tLastOpening_ = VALDEF;
  type_ = (suscepAtMaximumSec_ > 0) ? CAPACITOR : REACTANCE;
  connectionState_ = shunt->getInitialConnected() ? CLOSED : OPEN;
  cannotBeDisconnected_ = false;
}

void
ModelShuntCompensator::initSize() {
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
    sizeZ_ = 4;  // connectionState, isCapacitor, isAvailable, currentSection
    sizeG_ = 1;  // time out for availability
    sizeMode_ = 1;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

double
ModelShuntCompensator::ir(const double ui) const {
  double ir = 0.;
  if (isConnected()) {
    ir = -suscepPu_ * ui;
  }
  return ir;
}

double
ModelShuntCompensator::ii(const double ur) const {
  double ii = 0.;
  if (isConnected()) {
    ii = suscepPu_ * ur;
  }
  return ii;
}

double
ModelShuntCompensator::ir_dUr() const {
  return 0.;
}

double
ModelShuntCompensator::ir_dUi() const {
  double ir_dUi = 0.;
  if (isConnected()) {
    ir_dUi = -suscepPu_;
  }

  return ir_dUi;
}

double
ModelShuntCompensator::ii_dUr() const {
  double ii_dUr = 0.;
  if (isConnected()) {
    ii_dUr = suscepPu_;
  }
  return ii_dUr;
}

double
ModelShuntCompensator::ii_dUi() const {
  return 0.;
}

void
ModelShuntCompensator::setModelBus(const std::shared_ptr<ModelBus>& model) {
  modelBus_ = model;
  cannotBeDisconnected_ = connectionState_ == CLOSED && !modelBus_->getVoltageLevel()->canBeDisconnected(modelBus_->getBusIndex());
}

void
ModelShuntCompensator::evalNodeInjection() {
  if (network_->isInitModel()) {
    modelBus_->irAdd(ir0_);
    modelBus_->iiAdd(ii0_);
  } else {
    const double ur = modelBus_->ur();
    const double ui = modelBus_->ui();
    modelBus_->irAdd(ir(ui));
    modelBus_->iiAdd(ii(ur));
  }
}

void
ModelShuntCompensator::evalYMat() {
  /* not needed */
}

void
ModelShuntCompensator::evalF(propertyF_t /*type*/) {
  // not needed
}

void
ModelShuntCompensator::evalDerivatives(const double /*cj*/) {
  if (isConnected()) {
    const int urYNum = modelBus_->urYNum();
    const int uiYNum = modelBus_->uiYNum();
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr());
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii_dUr());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi());
  }
}

void
ModelShuntCompensator::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState(id_ + "_isCapacitor_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_isAvailable_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_currentSection_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q_value", CONTINUOUS));
}

void
ModelShuntCompensator::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState("@ID@_isCapacitor_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_isAvailable_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_currentSection_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q_value", CONTINUOUS));
}

void
ModelShuntCompensator::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  const string shName = id_;
  addElementWithValue(shName + string("_state"), "ShuntCompensator", elements, mapElement);
  addElementWithValue(shName + string("_isCapacitor"), "ShuntCompensator", elements, mapElement);
  addElementWithValue(shName + string("_isAvailable"), "ShuntCompensator", elements, mapElement);
  addElementWithValue(shName + string("_currentSection"), "ShuntCompensator", elements, mapElement);
  addElementWithValue(shName + string("_Q"), "ShuntCompensator", elements, mapElement);
}

void
ModelShuntCompensator::evalG(const double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelShuntCompensator::evalG");
#endif
  // Time out reached for availability
  g_[0] = (doubleEquals(tLastOpening_, VALDEF) || t >= tLastOpening_ + noReclosingDelay_) ? ROOT_UP : ROOT_DOWN;
}

NetworkComponent::StateChange_t
ModelShuntCompensator::evalZ(const double t) {
  z_[isCapacitorNum_] = isCapacitor() ? 1. : 0.;
  z_[isAvailableNum_] = isAvailable() ? 1. : 0.;
  z_[currentSectionNum_] = getCurrentSection();

  if (modelBus_->getConnectionState() == OPEN)
    z_[connectionStateNum_] = OPEN;

  State currState = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
  if (currState != getConnected()) {
    stateModified_ = true;
    Trace::info() << DYNLog(ShuntStateChange, id_, getConnected(), currState) << Trace::endline;
    if (currState == OPEN) {
      DYNAddTimelineEvent(network_, id_, ShuntDisconnected);
      tLastOpening_ = t;
      currentSection_ = 0;
      suscepPu_ = 0.;
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else if (currState == CLOSED) {
      DYNAddTimelineEvent(network_, id_, ShuntConnected);
      currentSection_ = maximumSection_;
      suscepPu_ = suscepAtMaximumSec_ * vNom_ * vNom_ / SNREF;
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
    setConnected(currState);
  }
  return stateModified_ ? NetworkComponent::STATE_CHANGE : NetworkComponent::NO_CHANGE;
}

void
ModelShuntCompensator::collectSilentZ(BitMask* silentZTable) {
  silentZTable[connectionStateNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[isCapacitorNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[isAvailableNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[currentSectionNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
}

void
ModelShuntCompensator::getY0() {
  if (!network_->isInitModel()) {
    if (!network_->isStartingFromDump() || !internalVariablesFoundInDump_) {
      z_[connectionStateNum_] = getConnected();
      z_[isCapacitorNum_] = isCapacitor() ? 1. : 0.;
      z_[isAvailableNum_] = 1.;  // always available at the beginning of the simulation
      z_[currentSectionNum_] = getCurrentSection();
    } else {
      State shuntCurrState = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
      if (shuntCurrState == CLOSED) {
        if (modelBus_->getConnectionState() != CLOSED) {
          modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
          stateModified_ = true;
        }
      } else if (shuntCurrState == OPEN) {
        if (modelBus_->getConnectionState() != OPEN) {
          modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
          stateModified_ = true;
        }
      } else if (shuntCurrState == UNDEFINED_STATE) {
        throw DYNError(Error::MODELER, UndefinedComponentState, id_);
      } else {
        throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
      }
      connectionState_ = shuntCurrState;
      currentSection_ = static_cast<int>(z_[currentSectionNum_]);
    }
  }
}

void
ModelShuntCompensator::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  ModelCPP::dumpInStream(streamVariables, ir0_);
  ModelCPP::dumpInStream(streamVariables, ii0_);
  ModelCPP::dumpInStream(streamVariables, suscepPu_);
  ModelCPP::dumpInStream(streamVariables, tLastOpening_);
}

void
ModelShuntCompensator::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> ir0_;
  streamVariables >> c;
  streamVariables >> ii0_;
  streamVariables >> c;
  streamVariables >> suscepPu_;
  streamVariables >> c;
  streamVariables >> tLastOpening_;
}

bool
ModelShuntCompensator::isAvailable() const {
  if (!zConnected_[isAvailableNum_]) {
    return true;
  }
  if (getConnected() == CLOSED && cannotBeDisconnected_) {
    return false;
  } else if (getConnected() == OPEN && modelBus_->getVoltageLevel()->isClosestBBSSwitchedOff(modelBus_)) {
    return false;
  } else {
    if (g_[0] == ROOT_UP)
      return true;

    return false;
  }
}

void
ModelShuntCompensator::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  bool startingPointModeFound = false;
  std::string startingPointMode = getParameterDynamicNoThrow<string>(params, "startingPointMode", startingPointModeFound);
  if (startingPointModeFound) {
    startingPointMode_ = getStartingPointMode(startingPointMode);
  }
  try {
    switch (type_) {
      case CAPACITOR: {
        vector<string> ids;
        ids.push_back(id_);
        ids.push_back("capacitor");
        noReclosingDelay_ = getParameterDynamic<double>(params, "no_reclosing_delay", ids);
        break;
      }
      case REACTANCE: {
        vector<string> ids;
        ids.push_back(id_);
        ids.push_back("reactance");
        noReclosingDelay_ = getParameterDynamic<double>(params, "no_reclosing_delay", ids);
        break;
      }
    }
  } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    throw DYNError(Error::MODELER, NetworkParameterNotFoundFor, id_);
  }
}

void
ModelShuntCompensator::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("capacitor_no_reclosing_delay", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("reactance_no_reclosing_delay", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelShuntCompensator::defineNonGenericParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(id_ + "_no_reclosing_delay", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

NetworkComponent::StateChange_t
ModelShuntCompensator::evalState(const double /*time*/) {
  if (stateModified_) {
    stateModified_ = false;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelShuntCompensator::evalCalculatedVars() {
  const double ur = modelBus_->ur();
  const double ui = modelBus_->ui();
  const double i1 = ir(ui);
  const double i2 = ii(ur);
  calculatedVars_[qNum_] = (ui * i1 - ur * i2);   // Q value
}

void
ModelShuntCompensator::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const {
  switch (numCalculatedVar) {
    case qNum_: {
      const int urYNum = modelBus_->urYNum();
      const int uiYNum = modelBus_->uiYNum();
      numVars.push_back(urYNum);
      numVars.push_back(uiYNum);
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelShuntCompensator::evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const {
  switch (numCalculatedVar) {
    case qNum_: {
      if (isConnected()) {
        const double ur = modelBus_->ur();
        const double ui = modelBus_->ui();
         // q = -ui*ui*suscepPu_ - ur*ur*suscepPu_
        res[0] = -2. * ur * suscepPu_;  // @Q/@ur
        res[1] = -2. * ui * suscepPu_;  // @Q/@ui
      }
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelShuntCompensator::evalCalculatedVarI(unsigned numCalculatedVar) const {
  switch (numCalculatedVar) {
    case qNum_: {
      if (isConnected()) {
        const double ur = modelBus_->ur();
        const double ui = modelBus_->ui();
        const double ir = -suscepPu_ * ui;
        const double ii = suscepPu_ * ur;
        return (ui * ir - ur * ii);   // Q value
      }
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return 0.;
}

void
ModelShuntCompensator::init(int& /*yNum*/) {
  double Q = 0.;
  double uNode = 0.;
  const std::shared_ptr<ShuntCompensatorInterface> shunt = shunt_.lock();
  const double thetaNode = shunt->getBusInterface()->getAngle0();
  const double unomNode = shunt->getBusInterface()->getVNom();
  switch (startingPointMode_) {
  case FLAT:
    uNode = shunt->getBusInterface()->getVNom();
    Q = shunt->getB(currentSection_) * vNom_ * vNom_ / SNREF;
    break;
  case WARM:
    Q = shunt->getQ() / SNREF;
    uNode = shunt->getBusInterface()->getV0();
    break;
  }
  const double ur0 = uNode / unomNode * cos(thetaNode * DEG_TO_RAD);
  const double ui0 = uNode / unomNode * sin(thetaNode * DEG_TO_RAD);
  ir0_ = Q * ui0 / (ur0 * ur0 + ui0 * ui0);
  ii0_ = - Q * ur0 / (ur0 * ur0 + ui0 * ui0);
}

void
ModelShuntCompensator::evalJt(const double /*cj*/, const int /*rowOffset*/, SparseMatrix& /*jt*/) {
  /* not needed */
}

void
ModelShuntCompensator::evalJtPrim(const int /*rowOffset*/, SparseMatrix& /*jtPrim*/) {
  /* not needed */
}

void
ModelShuntCompensator::setFequations(std::map<int, std::string>& /*fEquationIndex*/) {
  // No F equation
}

void
ModelShuntCompensator::setGequations(std::map<int, std::string>& gEquationIndex) {
  gEquationIndex[0] = "ModelShuntCompensator " + id() + " : Time out reached for reclosing delay";

  assert(gEquationIndex.size() == static_cast<size_t>(sizeG()) && "Shunt compensator model: gEquationIndex.size() != gLocal_.size()");
}

}  // namespace DYN
