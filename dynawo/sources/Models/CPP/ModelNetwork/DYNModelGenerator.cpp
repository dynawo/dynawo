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

#include <DYNNumericalUtils.h>
#include <DYNTimer.h>

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

ModelGenerator::ModelGenerator(const std::shared_ptr<GeneratorInterface>& generator) :
NetworkComponent(generator->getID()),
generator_(generator),
Pc_(0.),
Qc_(0.),
ir0_(0.),
ii0_(0.),
alpha_(1.),
beta_(1.),
isVoltageDependant_(false),
stateModified_(false),
startingPointMode_(WARM) {
  connectionState_ = generator->getInitialConnected() ? CLOSED : OPEN;
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
    if (isVoltageDependant_) {
      const double uPuOverU0PuSquare = U2 / U0Pu_square_;
      const double P = P0_ * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
      const double Q = Q0_ * pow_dynawo(uPuOverU0PuSquare, halfBeta_);
      const double ur = modelBus_->ur();
      const double ui = modelBus_->ui();
      const double ir = -(P * ur + Q * ui) / U2;
      const double ii = -(P * ui - Q * ur) / U2;
      modelBus_->irAdd(ir);
      modelBus_->iiAdd(ii);
    } else {
      double Pc = PcPu();
      double Qc = QcPu();
      double ur = modelBus_->ur();
      double ui = modelBus_->ui();
      modelBus_->irAdd(ir(ur, ui, U2, Pc, Qc));
      modelBus_->iiAdd(ii(ur, ui, U2, Pc, Qc));
    }
  }
}

void
ModelGenerator::evalDerivatives(const double /*cj*/) {
  auto& modelBus = *modelBus_;
  if (!network_->isInitModel() && isConnected() && modelBus.getSwitchOff()) {
    const double ur = modelBus.ur();
    const double ui = modelBus.ui();
    const double U2 = ur * ur + ui * ui;
    if (doubleIsZero(U2))
      return;
    if (isVoltageDependant_) {
      int urYNum = modelBus.urYNum();
      int uiYNum = modelBus.uiYNum();

      const double uPuOverU0PuSquare = U2 / U0Pu_square_;
      const double p = P0_ * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
      const double q = Q0_ * pow_dynawo(uPuOverU0PuSquare, halfBeta_);

      double PdUr = 1. / U2 * P0_ * alpha_ * ur * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
      double QdUr = 1. / U2 * Q0_ * beta_ * ur * pow_dynawo(uPuOverU0PuSquare, halfBeta_);
      double PdUi = 1. / U2 * P0_ * alpha_ * ui * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
      double QdUi = 1. / U2 * Q0_ * beta_ * ui * pow_dynawo(uPuOverU0PuSquare, halfBeta_);

      double ir_dUrValue = -((PdUr * ur + p) + (QdUr * ui) - 2. * ur * (p * ur + q * ui) / U2) / U2;
      double ir_dUiValue = -((PdUi * ur) + (QdUi * ui + q) - 2. * ui * (p * ur + q * ui) / U2) / U2;
      double ii_dUrValue = -((PdUr * ui) - (QdUr * ur + q) - 2. * ur * (p * ui - q * ur) / U2) / U2;
      double ii_dUiValue = -((PdUi * ui + p) - (QdUi * ur) - 2. * ui * (p * ui - q * ur) / U2) / U2;

      auto& derivatives = *modelBus.derivatives();
      auto& irDerivatives = derivatives.getDerivatives(IR_DERIVATIVE);
      auto& iiDerivatives = derivatives.getDerivatives(II_DERIVATIVE);
      irDerivatives.addValue(urYNum, ir_dUrValue);
      irDerivatives.addValue(uiYNum, ir_dUiValue);
      iiDerivatives.addValue(urYNum, ii_dUrValue);
      iiDerivatives.addValue(uiYNum, ii_dUiValue);
    } else {
      double Pc = PcPu();
      double Qc = QcPu();
      int urYNum = modelBus.urYNum();
      int uiYNum = modelBus.uiYNum();
      double ir_dUrValue = ir_dUr(ur, ui, U2, Pc, Qc);
      double ir_dUiValue = ir_dUi(ur, ui, U2, Pc, Qc);
      double ii_dUrValue = ii_dUr(ur, ui, U2, Pc, Qc);
      double ii_dUiValue = ii_dUi(ur, ui, U2, Pc, Qc);
      auto& derivatives = *modelBus.derivatives();
      auto& irDerivatives = derivatives.getDerivatives(IR_DERIVATIVE);
      auto& iiDerivatives = derivatives.getDerivatives(II_DERIVATIVE);
      irDerivatives.addValue(urYNum, ir_dUrValue);
      irDerivatives.addValue(uiYNum, ir_dUiValue);
      iiDerivatives.addValue(urYNum, ii_dUrValue);
      iiDerivatives.addValue(uiYNum, ii_dUiValue);
    }
  }
}

void
ModelGenerator::evalF(propertyF_t /*type*/) {
  // not needed
}

void
ModelGenerator::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState(id_ + "_Pc_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_Qc_value", DISCRETE));
  variables.push_back(VariableAliasFactory::create(id_ + "_GENERATOR_state_value", id_ + "_state_value"));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_genState_value", CONTINUOUS));
}

void
ModelGenerator::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState("@ID@_Pc_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_Qc_value", DISCRETE));
  variables.push_back(VariableAliasFactory::create("@ID@_GENERATOR_state_value", "@ID@_state_value"));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_genState_value", CONTINUOUS));
}

void
ModelGenerator::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("generator_alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("generator_beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("generator_isVoltageDependant", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
}

void
ModelGenerator::defineNonGenericParameters(std::vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(id_ + "_alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_isVoltageDependant", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
}

void
ModelGenerator::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  // All the parameters could be non generic ones
  vector<string> ids;
  ids.push_back(id_);
  ids.push_back("generator");
  bool startingPointModeFound = false;
  std::string startingPointMode = getParameterDynamicNoThrow<string>(params, "startingPointMode", startingPointModeFound);
  if (startingPointModeFound) {
    startingPointMode_ = getStartingPointMode(startingPointMode);
  }
  try {
    // Non generic parameters have a higher priority than generic ones
    isVoltageDependant_ = getParameterDynamic<bool>(params, "isVoltageDependant", ids);
    if (isVoltageDependant_) {
      alpha_ = getParameterDynamic<double>(params, "alpha", ids);
      beta_ = getParameterDynamic<double>(params, "beta", ids);
      halfAlpha_ = 0.5 * alpha_;
      halfBeta_ = 0.5 * beta_;
    }
  } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    throw DYNError(Error::MODELER, NetworkParameterNotFoundFor, id_);
  }
  return;
}

void
ModelGenerator::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  string genName = id_;
  // ========  CONNECTION STATE ======
  addElementWithValue(genName + string("_state"), "Generator", elements, mapElement);

  // ========  Active power target ======
  addElementWithValue(genName + string("_Pc"), "Generator", elements, mapElement);

  // ========  Reactive power target ======
  addElementWithValue(genName + string("_Qc"), "Generator", elements, mapElement);

  // ========  P VALUE  ======
  addElementWithValue(genName + string("_P"), "Generator", elements, mapElement);

  // ========  Q VALUE  ======
  addElementWithValue(genName + string("_Q"), "Generator", elements, mapElement);

  // ========  state VALUE as continuous variable ======
  addElementWithValue(genName + string("_genState"), "Generator", elements, mapElement);
}

NetworkComponent::StateChange_t
ModelGenerator::evalZ(const double& /*t*/, bool /*deactivateRootFunctions*/) {
  if (modelBus_->getConnectionState() == OPEN)
    z_[0] = OPEN;

  State currState = static_cast<State>(static_cast<int>(z_[0]));
  if (currState != getConnected()) {
    Trace::info() << DYNLog(GeneratorStateChange, id_, getConnected(), z_[0]) << Trace::endline;
    if (currState == OPEN) {
      DYNAddTimelineEvent(network_, id_, GeneratorDisconnected);
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else {
      DYNAddTimelineEvent(network_, id_, GeneratorConnected);
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
    stateModified_ = true;
    setConnected(currState);
  }

  if (doubleNotEquals(z_[1], Pc_)) {
    DYNAddTimelineEvent(network_, id_, GeneratorTargetP, z_[1]);
    Pc_ = z_[1];
  }

  if (doubleNotEquals(z_[2], Qc_)) {
    DYNAddTimelineEvent(network_, id_, GeneratorTargetQ, z_[2]);
    Qc_ = z_[2];
  }
  return stateModified_ ? STATE_CHANGE : NO_CHANGE;
}

void
ModelGenerator::collectSilentZ(BitMask* silentZTable) {
  silentZTable[0].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[1].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[2].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
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
      if (isVoltageDependant_) {
        const double uPuOverU0PuSquare = U2 / U0Pu_square_;
        const double P = P0_ * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
        const double Q = Q0_ * pow_dynawo(uPuOverU0PuSquare, halfBeta_);
        calculatedVars_[pNum_] = P;
        calculatedVars_[qNum_] = Q;
      } else {
        double Pc = PcPu();
        double Qc = QcPu();
        irCalculated = ir(ur, ui, U2, Pc, Qc);
        iiCalculated = ii(ur, ui, U2, Pc, Qc);

        calculatedVars_[pNum_] = -(ur * irCalculated + ui * iiCalculated);
        calculatedVars_[qNum_] = -(ui * irCalculated - ur * iiCalculated);
      }
    }
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
      int urYNum = modelBus_->urYNum();
      int uiYNum = modelBus_->uiYNum();
      numVars.push_back(urYNum);
      numVars.push_back(uiYNum);
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
          if (isVoltageDependant_) {
            const double uPuOverU0PuSquare = U2 / U0Pu_square_;

            double PdUr = 1. / U2 * P0_ * alpha_ * ur * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
            double PdUi = 1. / U2 * P0_ * alpha_ * ui * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
            res[0] = PdUr;  // @P/@ur
            res[1] = PdUi;  // @P/@ui
          } else {
            double Pc = PcPu();
            double Qc = QcPu();
            res[0] = -(ir(ur, ui, U2, Pc, Qc) + ur * ir_dUr(ur, ui, U2, Pc, Qc) + ui * ii_dUr(ur, ui, U2, Pc, Qc));  // @P/@ur
            res[1] = -(ur * ir_dUi(ur, ui, U2, Pc, Qc) + ii(ur, ui, U2, Pc, Qc) + ui * ii_dUi(ur, ui, U2, Pc, Qc));  // @P/@ui
          }
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
          if (isVoltageDependant_) {
            const double uPuOverU0PuSquare = U2 / U0Pu_square_;

            double QdUr = 1. / U2 * Q0_ * beta_ * ur * pow_dynawo(uPuOverU0PuSquare, halfBeta_);
            double QdUi = 1. / U2 * Q0_ * beta_ * ui * pow_dynawo(uPuOverU0PuSquare, halfBeta_);
            res[0] = QdUr;  // @P/@ur
            res[1] = QdUi;  // @P/@ui
          } else {
            double Pc = PcPu();
            double Qc = QcPu();
            res[0] = -(ui * ir_dUr(ur, ui, U2, Pc, Qc) - (ii(ur, ui, U2, Pc, Qc) + ur * ii_dUr(ur, ui, U2, Pc, Qc)));  // @Q/@ur
            res[1] = -(ir(ur, ui, U2, Pc, Qc) + ui * ir_dUi(ur, ui, U2, Pc, Qc) - ur * ii_dUi(ur, ui, U2, Pc, Qc));  // @Q/@ui
          }
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
          if (isVoltageDependant_) {
            const double uPuOverU0PuSquare = U2 / U0Pu_square_;
            const double P = P0_ * pow_dynawo(uPuOverU0PuSquare, halfAlpha_);
            return P;
          } else {
            double ur = modelBus_->ur();
            double ui = modelBus_->ui();
            double Pc = PcPu();
            double Qc = QcPu();
            return -(ur * ir(ur, ui, U2, Pc, Qc) + ui * ii(ur, ui, U2, Pc, Qc));
          }
        }
      }
      break;
    }
    case qNum_: {
      if (isConnected() && !modelBus_->getSwitchOff()) {
        // q = ui*ir - ur * ii
        double U2 = modelBus_->getCurrentU(ModelBus::U2PuType_);
        if (!doubleIsZero(U2)) {
          if (isVoltageDependant_) {
            const double uPuOverU0PuSquare = U2 / U0Pu_square_;
            const double Q = Q0_ * pow_dynawo(uPuOverU0PuSquare, halfBeta_);
            return Q;
          } else {
            double ur = modelBus_->ur();
            double ui = modelBus_->ui();
            double Pc = PcPu();
            double Qc = QcPu();
            return -(ui * ir(ur, ui, U2, Pc, Qc) - ur * ii(ur, ui, U2, Pc, Qc));
          }
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
  double uNode = 0.;
  std::shared_ptr<GeneratorInterface> generator = generator_.lock();
  double thetaNode = generator->getBusInterface()->getAngle0();
  double unomNode = generator->getBusInterface()->getVNom();
  switch (startingPointMode_) {
  case FLAT:
    Pc_ = isConnected() ? -1. * generator->getTargetP() : 0.;
    Qc_ = isConnected() ? -1. * generator->getTargetQ() : 0.;
    uNode = generator->getBusInterface()->getVNom();
    P0_ = isConnected() ? -1. * generator->getTargetP() / SNREF : 0.;
    Q0_ = isConnected() ? -1. * generator->getTargetQ() / SNREF : 0.;
    u0_ = uNode / unomNode;
    break;
  case WARM:
    Pc_ = isConnected() ? -1. * generator->getP() : 0.;
    Qc_ = isConnected() ? -1. * generator->getQ() : 0.;
    uNode = generator->getBusInterface()->getV0();
    P0_ = isConnected() ? -1. * generator->getP() / SNREF : 0.;
    Q0_ = isConnected() ? -1. * generator->getQ() / SNREF : 0.;
    u0_ = uNode / unomNode;
    break;
  }
  double ur0 = u0_ * cos(thetaNode * DEG_TO_RAD);
  double ui0 = u0_ * sin(thetaNode * DEG_TO_RAD);
  double U20 = ur0 * ur0 + ui0 * ui0;
  U0Pu_square_ = U20;
  assert(doubleEquals(U20, u0_ * u0_));
  if (!doubleIsZero(U20)) {
    ir0_ = (-PcPu() * ur0 - QcPu() * ui0) / U20;
    ii0_ = (-PcPu() * ui0 + QcPu() * ur0) / U20;
  } else {
    ir0_ = 0.;
    ii0_ = 0.;
  }
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
