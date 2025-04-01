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
 * @file  DYNModelSwitch.cpp
 *
 * @brief
 *
 */
#include <cmath>
#include <cassert>

#include "DYNModelSwitch.h"
#include "DYNModelBus.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNTimer.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNSwitchInterface.h"
#include "DYNBusInterface.h"
#include "DYNModelNetwork.h"
#include "DYNMessageTimeline.h"

using std::vector;
using std::map;
using std::string;
using boost::shared_ptr;

namespace DYN {

ModelSwitch::ModelSwitch(const shared_ptr<SwitchInterface>& sw) :
NetworkComponent(sw->getID()),
topologyModified_(false),
inLoop_(false),
canBeClosed_(!sw->isOpen() || sw->isRetained()) {
  // init data
  if (sw->isOpen())
    connectionState_ = OPEN;
  else
    connectionState_ = CLOSED;
  ir0_ = 0;
  ii0_ = 0;
  irYNum_ = 0;
  iiYNum_ = 0;
}

boost::shared_ptr<ModelBus>
ModelSwitch::getModelBus1() const {
  if (!modelBus1_)
    throw DYNError(Error::MODELER, SwitchMissingBus1, id());

  return modelBus1_;
}

boost::shared_ptr<ModelBus>
ModelSwitch::getModelBus2() const {
  if (!modelBus2_)
    throw DYNError(Error::MODELER, SwitchMissingBus2, id());

  return modelBus2_;
}

void
ModelSwitch::initSize() {
  if (network_->isInitModel()) {
    sizeF_ = 2;
    sizeY_ = 2;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = 0;
  } else {
    sizeF_ = 2;
    sizeY_ = 2;
    sizeZ_ = 1;
    sizeG_ = 0;
    sizeMode_ = 1;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

void
ModelSwitch::evalNodeInjection() {
  if (network_->isInit()) {
    modelBus1_->irAdd(ir0_);
    modelBus1_->iiAdd(ii0_);
    modelBus2_->irAdd(-ir0_);
    modelBus2_->iiAdd(-ii0_);
  } else {
    modelBus1_->irAdd(y_[0]);
    modelBus1_->iiAdd(y_[1]);
    modelBus2_->irAdd(-y_[0]);
    modelBus2_->iiAdd(-y_[1]);
  }
}

NetworkComponent::StateChange_t
ModelSwitch::evalZ(const double& /*t*/) {
  State currState = static_cast<State>(static_cast<int>(z_[0]));
  if (currState != getConnectionState()) {
    topologyModified_ = true;
    Trace::info() << DYNLog(SwitchStateChange, id_, getConnectionState(), currState) << Trace::endline;
    if (currState == CLOSED) {
      DYNAddTimelineEvent(network_, id_, SwitchClosed);
    } else if (currState == OPEN) {
      DYNAddTimelineEvent(network_, id_, SwitchOpened);
    }
    setConnectionState(currState);
  }
  return topologyModified_ ? NetworkComponent::TOPO_CHANGE: NetworkComponent::NO_CHANGE;
}

void
ModelSwitch::evalF(propertyF_t type) {
  if (type == DIFFERENTIAL_EQ)
    return;
  if (getConnectionState() == CLOSED && !modelBus1_->getSwitchOff()) {
    if (inLoop_) {
      // 1 is the default value for the current in a loop
      f_[0] = y_[0] - 1.;
      f_[1] = y_[1] - 1.;
    } else {
      f_[0] = modelBus1_->ur() - modelBus2_->ur();
      f_[1] = modelBus1_->ui() - modelBus2_->ui();
    }
  } else {
    f_[0] = y_[0];
    f_[1] = y_[1];
  }
}

void
ModelSwitch::collectSilentZ(BitMask* /*silentZTable*/) {
  // no silent z
}

void
ModelSwitch::setFequations(std::map<int, std::string>& fEquationIndex) {
  if (getConnectionState() == CLOSED && !modelBus1_->getSwitchOff()) {
    if (inLoop_) {
      // 1 is the default value for the current in a loop
      fEquationIndex[0] = std::string("y_[irNum_] - 1 localModel:").append(id());
      fEquationIndex[1] = std::string("y_[iiNum_] - 1 localModel:").append(id());
    } else {
      fEquationIndex[0] = modelBus1_->id() + "->ur() - " + modelBus2_->id() + "->ur() localModel:"+id();
      fEquationIndex[1] = modelBus1_->id() + "->ui() - " + modelBus2_->id() + "->ui() localModel:"+id();
    }
  } else {
    fEquationIndex[0] = std::string("y_[irNum_] localModel:").append(id());
    fEquationIndex[1] = std::string("y_[iiNum_] localModel:").append(id());
  }

  assert(fEquationIndex.size() == static_cast<size_t>(sizeF_) && "ModelSwitch: fEquationIndex.size() != f_.size()");
}

void
ModelSwitch::evalStaticYType() {
  yType_[0] = ALGEBRAIC;
  yType_[1] = ALGEBRAIC;
}

void
ModelSwitch::evalStaticFType() {
  fType_[0] = ALGEBRAIC_EQ;   // no differential variable for switch equation
  fType_[1] = ALGEBRAIC_EQ;
}

void
ModelSwitch::init(int& yNum) {
  irYNum_ = yNum;
  ++yNum;
  iiYNum_ = yNum;
  ++yNum;
}

void
ModelSwitch::getY0() {
  if (network_->isInitModel()) {
    y_[0] = inLoop_ ? 1. : 0.;
    y_[1] = inLoop_ ? 1. : 0.;
  } else {
    y_[0] = inLoop_ ? 1. : ir0_;
    y_[1] = inLoop_ ? 1. : ii0_;
    yp_[0] = 0.;
    yp_[1] = 0.;
    z_[0] = getConnectionState();
  }
}

void
ModelSwitch::setInitialCurrents() {
  ir0_ = y_[0];
  ii0_ = y_[1];
}

void
ModelSwitch::evalDerivatives(const double /*cj*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer3("ModelSwitch::evalDerivatives");
#endif
  if (getConnectionState() == CLOSED) {
    modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, irYNum_, 1.);
    modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, iiYNum_, 1.);

    modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, irYNum_, -1.);
    modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, iiYNum_, -1.);
  }
}

void
ModelSwitch::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_irsw", FLOW));
  variables.push_back(VariableNativeFactory::createState("@ID@_iisw", FLOW));
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_swState_value", CONTINUOUS));
}

void
ModelSwitch::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_irsw", FLOW));
  variables.push_back(VariableNativeFactory::createState(id_ + "_iisw", FLOW));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_swState_value", CONTINUOUS));
}

void
ModelSwitch::defineParameters(vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ModelSwitch::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  string switchName = id_;
  addElementWithValue(switchName + string("_state"), "Switch", elements, mapElement);
  addElementWithValue(switchName + string("_swState"), "Switch", elements, mapElement);
}

NetworkComponent::StateChange_t
ModelSwitch::evalState(const double& /*time*/) {
  if (topologyModified_) {
    topologyModified_ = false;
    return NetworkComponent::TOPO_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelSwitch::open() {
  z_[0] = OPEN;
  if (static_cast<State>(static_cast<int>(z_[0])) != getConnectionState())
    Trace::info() << DYNLog(SwitchStateChange, id_, getConnectionState(), z_[0]) << Trace::endline;
}

void
ModelSwitch::close() {
  z_[0] = CLOSED;
  if (static_cast<State>(static_cast<int>(z_[0])) != getConnectionState())
    Trace::info() << DYNLog(SwitchStateChange, id_, getConnectionState(), z_[0]) << Trace::endline;
}

void
ModelSwitch::addBusNeighbors() {
  shared_ptr<ModelBus> bus1 = modelBus1_;
  shared_ptr<ModelBus> bus2 = modelBus2_;
  if (getConnectionState() == CLOSED) {
    bus1->addNeighbor(bus2);
    bus2->addNeighbor(bus1);
  }
}

void
ModelSwitch::evalJt(SparseMatrix& jt, const double& /*cj*/, const int& rowOffset) {
  // Column for node current / real part of the voltage (i depending on re(V))
  // --------------------------------------------------------------------------

  // Switching column
  jt.changeCol();

  if (getConnectionState() == CLOSED && !modelBus1_->getSwitchOff()) {  // Close switch
    if (inLoop_) {  // Switch breaking a loop : irsw - 1 = 0
      jt.addTerm(irYNum_ + rowOffset, +1);
    } else {  // "Normal" case : ur1 - ur2 = 0
      jt.addTerm(modelBus1_->urYNum() + rowOffset, +1.);
      jt.addTerm(modelBus2_->urYNum() + rowOffset, -1.);
    }
  } else {  // Open switch : irsw = 0
    jt.addTerm(irYNum_ + rowOffset, +1);
  }

  // Column for node current / imaginary part of the voltage (i depending on im(V))
  // ------------------------------------------------------------------------------

  // Switching column
  jt.changeCol();

  if (getConnectionState() == CLOSED && !modelBus1_->getSwitchOff()) {  // Close switch
    if (inLoop_) {  // Switch breaking a loop : iisw -1 = 0
      jt.addTerm(iiYNum_ + rowOffset, +1.);
    } else {  // "Normal" case : ui1 - ui2 = 0
      jt.addTerm(modelBus1_->uiYNum() + rowOffset, +1.);
      jt.addTerm(modelBus2_->uiYNum() + rowOffset, -1.);
    }
  } else {  // Open switch : iisw = 0
    jt.addTerm(iiYNum_ + rowOffset, +1.);
  }
}

void
ModelSwitch::evalJtPrim(SparseMatrix& jt, const int& /*rowOffset*/) {
  // Switching column - node current / real part of the voltage
  jt.changeCol();
  // Switching column - node current / imaginary part of the voltage
  jt.changeCol();
}

void
ModelSwitch::evalCalculatedVars() {
  calculatedVars_[swStateNum_] = getConnectionState();
}

void
ModelSwitch::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& /*numVars*/) const {
  switch (numCalculatedVar) {
    case swStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelSwitch::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& /*res*/) const {
  switch (numCalculatedVar) {
    case swStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelSwitch::evalCalculatedVarI(unsigned numCalculatedVar) const {
  switch (numCalculatedVar) {
    case swStateNum_:
      return getConnectionState();
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
}

void
ModelSwitch::defineNonGenericParameters(vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ModelSwitch::evalG(const double& /*t*/) {
  // not needed
}

void
ModelSwitch::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& /*params*/) {
  // no parameter
}

void
ModelSwitch::setGequations(map<int, string>& /*gEquationIndex*/) {
  // not needed
}

}  // namespace DYN
