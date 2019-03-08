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
 * @file  DYNModelGenerator.cpp
 *
 * @brief
 *
 */
#include <cmath>
#include <vector>

#include "DYNModelGenerator.h"
#include "DYNModelBus.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNTimer.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNGeneratorInterface.h"
#include "DYNBusInterface.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNMessageTimeline.h"
#include "DYNModelVoltageLevel.h"

using boost::shared_ptr;
using std::vector;
using std::map;
using std::string;

namespace DYN {

ModelGenerator::ModelGenerator(const shared_ptr<GeneratorInterface>& generator) :
Impl(generator->getID()) {
  // init data
  Pc_ = -1. * generator->getP();
  Qc_ = -1. * generator->getQ();
  connectionState_ = generator->getInitialConnected() ? CLOSED : OPEN;
  double uNode = generator->getBusInterface()->getV0();
  double tetaNode = generator->getBusInterface()->getAngle0();
  double unomNode = generator->getBusInterface()->getVNom();
  double ur0 = uNode / unomNode * cos(tetaNode * DEG_TO_RAD);
  double ui0 = uNode / unomNode * sin(tetaNode * DEG_TO_RAD);
  double U20 = ur0 * ur0 + ui0 * ui0;
  if (!doubleIsZero(U20)) {
    ir0_ = (-Pc() * ur0 - Qc() * ui0) / U20;
    ii0_ = (-Pc() * ui0 + Qc() * ur0) / U20;
  } else {
    ir0_ = 0.;
    ii0_ = 0.;
  }
}

void
ModelGenerator::initSize() {
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
    sizeZ_ = 3;  // connectionState, Pc, Qc
    sizeG_ = 0;
    sizeMode_ = 1;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

double
ModelGenerator::Pc() const {
  return Pc_ / SNREF;
}

double
ModelGenerator::Qc() const {
  return Qc_ / SNREF;
}

double
ModelGenerator::ir(const double& ur, const double& ui, const double& U2) const {
  double ir = 0.;
  if (isConnected() && !modelBus_->getSwitchOff()) {
    if (!doubleIsZero(U2))
      ir = (-Pc() * ur - Qc() * ui) / U2;
  }
  return ir;
}

double
ModelGenerator::ii(const double& ur, const double& ui, const double& U2) const {
  double ii = 0.;
  if (isConnected() && !modelBus_->getSwitchOff()) {
    if (!doubleIsZero(U2))
      ii = (-Pc() * ui + Qc() * ur) / U2;
  }
  return ii;
}

double
ModelGenerator::ir_dUr(const double& ur, const double& ui, const double& U2) const {
  double ir_dUr = 0.;
  if (isConnected() && !modelBus_->getSwitchOff()) {
    if (!doubleIsZero(U2))
      ir_dUr = (-Pc() - 2. * ur * (-Pc() * ur - Qc() * ui) / U2) / U2;
  }
  return ir_dUr;
}

double
ModelGenerator::ir_dUi(const double& ur, const double& ui, const double& U2) const {
  double ir_dUi = 0.;
  if (isConnected()&& !modelBus_->getSwitchOff()) {
    if (!doubleIsZero(U2))
      ir_dUi = (-Qc() - 2. * ui * (-Pc() * ur - Qc() * ui) / U2) / U2;
  }
  return ir_dUi;
}

double
ModelGenerator::ii_dUr(const double& ur, const double& ui, const double& U2) const {
  double ii_dUr = 0.;
  if (isConnected()&& !modelBus_->getSwitchOff()) {
    if (!doubleIsZero(U2))
      ii_dUr = (Qc() - 2. * ur * (-Pc() * ui + Qc() * ur) / U2) / U2;
  }
  return ii_dUr;
}

double
ModelGenerator::ii_dUi(const double& ur, const double& ui, const double& U2) const {
  double ii_dUi = 0.;
  if (isConnected()&& !modelBus_->getSwitchOff()) {
    if (!doubleIsZero(U2))
      ii_dUi = (-Pc() - 2 * ui * (-Pc() * ui + Qc() * ur) / U2) / U2;
  }
  return ii_dUi;
}

void
ModelGenerator::evalNodeInjection() {
  if (network_->isInitModel()) {
    modelBus_->irAdd(ir0_);
    modelBus_->iiAdd(ii0_);
  } else {
     double ur = modelBus_->ur();
     double ui = modelBus_->ui();
     double U2 = ur * ur + ui * ui;
     modelBus_->irAdd(ir(ur, ui, U2));
     modelBus_->iiAdd(ii(ur, ui, U2));
  }
}

void
ModelGenerator::evalDerivatives() {
  // Timer timer3("ModelGen::evalDerivatives");
  if (!network_->isInitModel() && isConnected()) {
    double ur = modelBus_->ur();
    double ui = modelBus_->ui();
    double U2 = ur * ur + ui * ui;
    int urYNum = modelBus_->urYNum();
    int uiYNum = modelBus_->uiYNum();
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr(ur, ui, U2));
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi(ur, ui, U2));
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii_dUr(ur, ui, U2));
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi(ur, ui, U2));
  }
}

void
ModelGenerator::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_Pc_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_Qc_value", DISCRETE));
  variables.push_back(VariableAliasFactory::create(id_ + "_GENERATOR_state_value", id_ + "_state_value"));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_genState_value", CONTINUOUS));
}

void
ModelGenerator::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_Pc_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_Qc_value", DISCRETE));
  variables.push_back(VariableAliasFactory::create("@ID@_GENERATOR_state_value", "@ID@_state_value"));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_genState_value", CONTINUOUS));
}

void
ModelGenerator::defineParameters(vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ModelGenerator::defineNonGenericParameters(std::vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ModelGenerator::setSubModelParameters(const std::tr1::unordered_map<std::string, ParameterModeler>& /*params*/) {
  // no parameter
}

void
ModelGenerator::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  string genName = id_;
  // ========  CONNECTION STATE ======
  string name = genName + string("_state");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  Active power target ======
  name = genName + string("_Pc");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  Reactive power target ======
  name = genName + string("_Qc");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  P VALUE  ======
  name = genName + string("_P");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  Q VALUE  ======
  name = genName + string("_Q");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  state VALUE as continuous variable ======
  name = genName + string("_genState");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
}

void
ModelGenerator::evalZ(const double& /*t*/) {
  z_[0] = getConnected();
  z_[1] = Pc_;
  z_[2] = Qc_;
}

void
ModelGenerator::getY0() {
  if (!network_->isInitModel()) {
    z_[0] = getConnected();
    z_[1] = Pc_;
    z_[2] = Qc_;
  }
}

NetworkComponent::StateChange_t
ModelGenerator::evalState(const double& /*time*/) {
  if ((State) z_[0] != getConnected()) {
    Trace::debug() << DYNLog(GeneratorStateChange, id_, getConnected(), z_[0]) << Trace::endline;
    if ((State) z_[0] == OPEN) {
      network_->addEvent(id_, DYNTimeline(GeneratorDisconnected));
      setConnected(OPEN);
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else {
      network_->addEvent(id_, DYNTimeline(GeneratorConnected));
      setConnected(CLOSED);
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
    return NetworkComponent::STATE_CHANGE;
  }

  if (doubleNotEquals(z_[1], Pc_)) {
    network_->addEvent(id_, DYNTimeline(GeneratorTargetP, z_[1]));
    Pc_ = z_[1];
  }

  if (doubleNotEquals(z_[2], Qc_)) {
    network_->addEvent(id_, DYNTimeline(GeneratorTargetQ, z_[2]));
    Qc_ = z_[2];
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelGenerator::evalCalculatedVars() {
  double ur = modelBus_->ur();
  double ui = modelBus_->ui();
  double U2 = ur * ur + ui * ui;
  double ir1 = ir(ur, ui, U2);
  double ii1 = ii(ur, ui, U2);
  calculatedVars_[pNum_] = (isConnected())?-(ur * ir1 + ui * ii1):0.;
  calculatedVars_[qNum_] = (isConnected())?-(ui * ir1 - ur * ii1):0.;
  calculatedVars_[genStateNum_] = connectionState_;
}

void
ModelGenerator::getDefJCalculatedVarI(int numCalculatedVar, std::vector<int> & numVars) {
  switch (numCalculatedVar) {
    case pNum_:
    case qNum_: {
      if (isConnected()) {
        int urYNum = modelBus_->urYNum();
        int uiYNum = modelBus_->uiYNum();
        numVars.push_back(urYNum);
        numVars.push_back(uiYNum);
      }
      break;
    }
    case genStateNum_:
      break;
  }
}

void
ModelGenerator::evalJCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/, std::vector<double>& res) {
  double ur = 0.;
  double ui = 0.;
  double U2 = 0.;
  if (isConnected()) {
    ur = y[0];
    ui = y[1];
    U2 = ur * ur + ui * ui;
  }
  switch (numCalculatedVar) {
    case pNum_: {
      if (isConnected()) {
        // P = -(ur*ir + ui* ii)
        res[0] = -(ir(ur, ui, U2) + ur * ir_dUr(ur, ui, U2) + ui * ii_dUr(ur, ui, U2));  // @P/@ur
        res[1] = -(ur * ir_dUi(ur, ui, U2) + ii(ur, ui, U2) + ui * ii_dUi(ur, ui, U2));  // @P/@ui
      }
      break;
    }
    case qNum_: {
      if (isConnected()) {
        // q = ui*ir - ur * ii
        res[0] = -(ui * ir_dUr(ur, ui, U2) - (ii(ur, ui, U2) + ur * ii_dUr(ur, ui, U2)));  // @Q/@ur
        res[1] = -(ir(ur, ui, U2) + ui * ir_dUi(ur, ui, U2) - ur * ii_dUi(ur, ui, U2));  // @Q/@ui
      }
      break;
    }
    case genStateNum_:
      break;
  }
}

double
ModelGenerator::evalCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/) {
  double ur = 0.;
  double ui = 0.;
  double U2 = 0.;
  if (isConnected()) {
    ur = y[0];
    ui = y[1];
    U2 = ur * ur + ui * ui;
  }
  switch (numCalculatedVar) {
    case pNum_: {
      if (isConnected()) {
        // P = ur*ir + ui* ii
        return -(ur * ir(ur, ui, U2) + ui * ii(ur, ui, U2));
      }
      break;
    }
    case qNum_: {
      if (isConnected()) {
        // q = ui*ir - ur * ii
        return -(ui * ir(ur, ui, U2) - ur * ii(ur, ui, U2));
      }
      break;
    }
    case genStateNum_:
      return connectionState_;
  }
  return 0.;
}

void
ModelGenerator::setFequations(std::map<int, std::string>& /*fEquationIndex*/) {
  // not needed
}

void
ModelGenerator::setGequations(std::map<int, std::string>& /*gEquationIndex*/) {
  // not needed
}

void
ModelGenerator::init(int & /*yNum*/) {
  // not needed
}

void
ModelGenerator::evalJt(SparseMatrix& /*jt*/, const double& /*cj*/, const int& /*rowOffset*/) {
  // not needed
}

void
ModelGenerator::evalJtPrim(SparseMatrix& /*jt*/, const int& /*rowOffset*/) {
  // not needed
}

void
ModelGenerator::evalG(const double& /*t*/) {
  // not needed
}
}  // namespace DYN
