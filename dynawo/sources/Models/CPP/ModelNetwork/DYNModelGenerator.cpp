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
#include "DYNTrace.h"
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
Impl(generator->getID()),
stateModified_(false) {
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
    ir0_ = (-PcPu() * ur0 - QcPu() * ui0) / U20;
    ii0_ = (-PcPu() * ui0 + QcPu() * ur0) / U20;
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

void
ModelGenerator::evalNodeInjection() {
  if (network_->isInitModel()) {
    modelBus_->irAdd(ir0_);
    modelBus_->iiAdd(ii0_);
  } else if (isConnected() && !modelBus_->getSwitchOff()) {
     double U2 = modelBus_->getCurrentU(ModelBus::U2PuType_);
     if (doubleIsZero(U2))
      return;
     double Pc = PcPu();
     double Qc = QcPu();
     double ur = modelBus_->ur();
     double ui = modelBus_->ui();
     modelBus_->irAdd(ir(ur, ui, U2, Pc, Qc));
     modelBus_->iiAdd(ii(ur, ui, U2, Pc, Qc));
  }
}

void
ModelGenerator::evalDerivatives(const double /*cj*/) {
  if (!network_->isInitModel() && isConnected() && !modelBus_->getSwitchOff()) {
    double ur = modelBus_->ur();
    double ui = modelBus_->ui();
    double U2 = ur * ur + ui * ui;
    if (doubleIsZero(U2))
      return;
    double Pc = PcPu();
    double Qc = QcPu();
    int urYNum = modelBus_->urYNum();
    int uiYNum = modelBus_->uiYNum();
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr(ur, ui, U2, Pc, Qc));
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi(ur, ui, U2, Pc, Qc));
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii_dUr(ur, ui, U2, Pc, Qc));
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi(ur, ui, U2, Pc, Qc));
  }
}

void
ModelGenerator::evalF(propertyF_t /*type*/) {
  // not needed
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
ModelGenerator::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& /*params*/) {
  // no parameter
}

void
ModelGenerator::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  string genName = id_;
  // ========  CONNECTION STATE ======
  addElementWithValue(genName + string("_state"), elements, mapElement);

  // ========  Active power target ======
  addElementWithValue(genName + string("_Pc"), elements, mapElement);

  // ========  Reactive power target ======
  addElementWithValue(genName + string("_Qc"), elements, mapElement);

  // ========  P VALUE  ======
  addElementWithValue(genName + string("_P"), elements, mapElement);

  // ========  Q VALUE  ======
  addElementWithValue(genName + string("_Q"), elements, mapElement);

  // ========  state VALUE as continuous variable ======
  addElementWithValue(genName + string("_genState"), elements, mapElement);
}

NetworkComponent::StateChange_t
ModelGenerator::evalZ(const double& /*t*/) {
  State currState = static_cast<State>(static_cast<int>(z_[0]));
  if (currState != getConnected()) {
    Trace::info() << DYNLog(GeneratorStateChange, id_, getConnected(), z_[0]) << Trace::endline;
    if (currState == OPEN) {
      network_->addEvent(id_, DYNTimeline(GeneratorDisconnected));
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else {
      network_->addEvent(id_, DYNTimeline(GeneratorConnected));
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
    stateModified_ = true;
    setConnected(currState);
  }

  if (doubleNotEquals(z_[1], Pc_)) {
    network_->addEvent(id_, DYNTimeline(GeneratorTargetP, z_[1]));
    Pc_ = z_[1];
  }

  if (doubleNotEquals(z_[2], Qc_)) {
    network_->addEvent(id_, DYNTimeline(GeneratorTargetQ, z_[2]));
    Qc_ = z_[2];
  }
  return (stateModified_)?NetworkComponent::STATE_CHANGE:NetworkComponent::NO_CHANGE;
}

void
ModelGenerator::collectSilentZ(bool* silentZTable) {
  silentZTable[0] = true;
  silentZTable[1] = true;
  silentZTable[2] = true;
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
  if (stateModified_) {
    stateModified_ = false;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelGenerator::evalCalculatedVars() {
  if (isConnected() && !modelBus_->getSwitchOff()) {
    double ur = modelBus_->ur();
    double ui = modelBus_->ui();
    double U2 = modelBus_->getCurrentU(ModelBus::U2PuType_);
    double irCalculated = 0;
    double iiCalculated = 0;
    if (!doubleIsZero(U2)) {
      double Pc = PcPu();
      double Qc = QcPu();
      irCalculated = ir(ur, ui, U2, Pc, Qc);
      iiCalculated = ii(ur, ui, U2, Pc, Qc);
    }
    calculatedVars_[pNum_] = -(ur * irCalculated + ui * iiCalculated);
    calculatedVars_[qNum_] = -(ui * irCalculated - ur * iiCalculated);
  } else {
    calculatedVars_[pNum_] = 0;
    calculatedVars_[qNum_] = 0;
  }
  calculatedVars_[genStateNum_] = connectionState_;
}

void
ModelGenerator::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int> & numVars) const {
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
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelGenerator::evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const {
  switch (numCalculatedVar) {
    case pNum_: {
      if (isConnected() && !modelBus_->getSwitchOff()) {
        // P = -(ur*ir + ui* ii)
        double ur = modelBus_->ur();
        double ui = modelBus_->ui();
        double U2 = ur * ur + ui * ui;
        if (!doubleIsZero(U2)) {
          double Pc = PcPu();
          double Qc = QcPu();
          res[0] = -(ir(ur, ui, U2, Pc, Qc) + ur * ir_dUr(ur, ui, U2, Pc, Qc) + ui * ii_dUr(ur, ui, U2, Pc, Qc));  // @P/@ur
          res[1] = -(ur * ir_dUi(ur, ui, U2, Pc, Qc) + ii(ur, ui, U2, Pc, Qc) + ui * ii_dUi(ur, ui, U2, Pc, Qc));  // @P/@ui
        }
      }
      break;
    }
    case qNum_: {
      if (isConnected() && !modelBus_->getSwitchOff()) {
        // q = ui*ir - ur * ii
        double ur = modelBus_->ur();
        double ui = modelBus_->ui();
        double U2 = ur * ur + ui * ui;
        if (!doubleIsZero(U2)) {
          double Pc = PcPu();
          double Qc = QcPu();
          res[0] = -(ui * ir_dUr(ur, ui, U2, Pc, Qc) - (ii(ur, ui, U2, Pc, Qc) + ur * ii_dUr(ur, ui, U2, Pc, Qc)));  // @Q/@ur
          res[1] = -(ir(ur, ui, U2, Pc, Qc) + ui * ir_dUi(ur, ui, U2, Pc, Qc) - ur * ii_dUi(ur, ui, U2, Pc, Qc));  // @Q/@ui
        }
      }
      break;
    }
    case genStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelGenerator::evalCalculatedVarI(unsigned numCalculatedVar) const {
  switch (numCalculatedVar) {
    case pNum_: {
      if (isConnected() && !modelBus_->getSwitchOff()) {
        // P = ur*ir + ui* ii
        double U2 = modelBus_->getCurrentU(ModelBus::U2PuType_);
        if (!doubleIsZero(U2)) {
          double ur = modelBus_->ur();
          double ui = modelBus_->ui();
          double Pc = PcPu();
          double Qc = QcPu();
          return -(ur * ir(ur, ui, U2, Pc, Qc) + ui * ii(ur, ui, U2, Pc, Qc));
        }
      }
      break;
    }
    case qNum_: {
      if (isConnected() && !modelBus_->getSwitchOff()) {
        // q = ui*ir - ur * ii
        double U2 = modelBus_->getCurrentU(ModelBus::U2PuType_);
        if (!doubleIsZero(U2)) {
          double ur = modelBus_->ur();
          double ui = modelBus_->ui();
          double Pc = PcPu();
          double Qc = QcPu();
          return -(ui * ir(ur, ui, U2, Pc, Qc) - ur * ii(ur, ui, U2, Pc, Qc));
        }
      }
      break;
    }
    case genStateNum_:
      return connectionState_;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
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
