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
 * @file  DYNModelLoad.cpp
 *
 * @brief
 *
 */
#include <cmath>
#include <cassert>

#include "PARParametersSet.h"

#include "DYNModelLoad.h"

#include <DYNTimer.h>

#include "DYNCommon.h"
#include "DYNNumericalUtils.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNVariableForModel.h"
#include "DYNDerivative.h"
#include "DYNLoadInterface.h"
#include "DYNBusInterface.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNModelVoltageLevel.h"

using std::map;
using std::string;
using std::vector;

using boost::shared_ptr;

using parameters::ParametersSet;

namespace DYN {

ModelLoad::ModelLoad(const LoadInterface& load, const ModelBus& bus) :
NetworkComponent(load.getID()),
load_(load),
modelBus_(bus),
stateModified_(false),
kp_(0.),
kq_(0.),
P0_(0.),
Q0_(0.),
ir0_(0.),
ii0_(0.),
alpha_(1.),
beta_(1.),
isRestorative_(false),
isPControllable_(false),
isQControllable_(false),
isControllable_(false),
Tp_(0.),
TpIsZero_(true),
Tq_(0.),
TqIsZero_(true),
zPMax_(0.),
zQMax_(0.),
alphaLong_(0.),
betaLong_(0.),
u0_(0.),
DeltaPc0_(0),
DeltaQc0_(0),
zP0_(1),
zQ0_(1),
zPprim0_(0),
zQprim0_(0),
yOffset_(0),
DeltaPcYNum_(0),
DeltaQcYNum_(0),
zPYNum_(0),
zQYNum_(0),
startingPointMode_(WARM) {
  connectionState_ = const_cast<LoadInterface&>(load).getInitialConnected() ? CLOSED : OPEN;
}

void
ModelLoad::initSize() {
  if (network_->isInitModel()) {
    sizeF_ = 0;
    sizeY_ = 0;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = 0;
  } else {
    sizeF_ = 0;
    if (isRestorative_)
      sizeF_ += 2;  // zP and zQ equations

    sizeY_ = 0;
    if (isPControllable_ || isControllable_)
      sizeY_ += 1;  // DeltaPc
    if (isQControllable_ || isControllable_)
      sizeY_ += 1;  // DeltaQc
    if (isRestorative_)
      sizeY_ += 2;  // zP and zQ

    sizeZ_ = 1;
    sizeG_ = 0;
    sizeMode_ = 1;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

void ModelLoad::evalStaticYType() {
  unsigned int yTypeIndex = 0;
  if (isPControllable_ || isControllable_) {
    yType_[yTypeIndex] = EXTERNAL;  // DeltaPc
    ++yTypeIndex;
  }
  if (isQControllable_ || isControllable_) {
    yType_[yTypeIndex] = EXTERNAL;  // DeltaQc
    ++yTypeIndex;
  }

  if (isRestorative_) {
    yType_[yTypeIndex] = DIFFERENTIAL;  // differential equations for zP and zQ
    ++yTypeIndex;
    yType_[yTypeIndex] = DIFFERENTIAL;
    ++yTypeIndex;
  }
}

void ModelLoad::evalStaticFType() {
  if (isRestorative_) {
    fType_[0] = DIFFERENTIAL_EQ;  // differential equations
    fType_[1] = DIFFERENTIAL_EQ;
  }
}

void
ModelLoad::evalF(const propertyF_t type) {
  if (network_->isInitModel())
    return;
  if (type == ALGEBRAIC_EQ)
    return;

  if (isRestorative_) {
    if (!isRunning()) {
      f_[0] = zPPrim();
      f_[1] = zQPrim();
    } else if (TpIsZero_) {
      f_[0] = zPPrim();
    } else if (TqIsZero_) {
      f_[1] = zQPrim();
    } else {
      const double U = getNonCstModelBus().getCurrentU(ModelBus::UPuType_);

      double zPprimValue = 0.;
      const double zp = zP();
      const double zPdiff = pow_dynawo(U / u0_, alphaLong_) - zp * pow_dynawo(U, alpha_) * kp_;
      if ((zp > 0. && zp < zPMax_) || (zp <= 0. && zPdiff > 0.) || (zp >= zPMax_ && zPdiff < 0.))
        zPprimValue = zPdiff;
      f_[0] = Tp_ * zPPrim() - zPprimValue;

      double zQprimValue = 0.;
      const double zq = zQ();
      const double zQdiff = (pow_dynawo(U / u0_, betaLong_) - zq * pow_dynawo(U, beta_) * kq_);
      if ((zq > 0. && zQ() < zQMax_) || (zq <= 0. && zQdiff > 0.) || (zq >= zQMax_ && zQdiff < 0.))
          zQprimValue = zQdiff;
      f_[1] = Tq_ * zQPrim() - zQprimValue;
    }
  }
}

void
ModelLoad::setFequations(std::map<int, std::string>& fEquationIndex) {
  if (network_->isInitModel())
    return;

  if (isRestorative_) {
    int index = 0;
    if (!TpIsZero_ && isRunning())
      fEquationIndex[index] = std::string("Tp_*zPPrim() - zPprimValue localModel:").append(id());
    else
      fEquationIndex[index] = std::string("zPPrim() localModel:").append(id());  // z is constant
    ++index;


    if (!TqIsZero_ && isRunning())
      fEquationIndex[index] = std::string("Tq_*zQPrim() - zQprimValue localModel:").append(id());
    else
      fEquationIndex[index] = std::string("zQPrim() localModel:").append(id());  // z is constant
    ++index;
  }

  assert(fEquationIndex.size() == static_cast<size_t>(sizeF()) && "ModelLoad:fEquationIndex.size() != f_.size()");
}

void
ModelLoad::setGequations(std::map<int, std::string>& /*gEquationIndex*/) {
  /* no G equation */
}

void
ModelLoad::init(int& yNum) {
  if (!network_->isStartingFromDump() || !internalVariablesFoundInDump_) {
    const auto& loadInterface = getLoadInterface();
    auto& loadInterfaceNonCst = getNonCstLoadInterface();
    const double thetaNode = loadInterface.getBusInterface()->getAngle0();
    const double unomNode = loadInterface.getBusInterface()->getVNom();
    switch (startingPointMode_) {
    case FLAT:
      P0_ = loadInterface.getP0() / SNREF;
      Q0_ = loadInterface.getQ0() / SNREF;
      u0_ = loadInterface.getBusInterface()->getVNom() / unomNode;
      break;
    case WARM:
      P0_ = loadInterfaceNonCst.getP() / SNREF;
      Q0_ = loadInterfaceNonCst.getQ() / SNREF;
      u0_ = loadInterfaceNonCst.getBusInterface()->getV0() / unomNode;
      break;
    }

    if (isConnected() && !doubleIsZero(u0_)) {
      const double ur0 = u0_ * cos(thetaNode * DEG_TO_RAD);
      const double ui0 = u0_ * sin(thetaNode * DEG_TO_RAD);
      ir0_ = (P0_ * ur0 + Q0_ * ui0) / (ur0 * ur0 + ui0 * ui0);
      ii0_ = (P0_ * ui0 - Q0_ * ur0) / (ur0 * ur0 + ui0 * ui0);
    } else {
      ir0_ = 0.;
      ii0_ = 0.;
    }
  }
  if (isConnected() && !doubleIsZero(u0_)) {
    kp_ = 1. / pow_dynawo(u0_, alpha_);
    kq_ = 1. / pow_dynawo(u0_, beta_);
  } else {
    kp_ = 0.;
    kq_ = 0.;
    ir0_ = 0.;
    ii0_ = 0.;
  }
  if (!network_->isInitModel()) {
    assert(yNum >= 0);
    yOffset_ = static_cast<unsigned int>(yNum);
    unsigned int localIndex = 0;

    if (isPControllable_ || isControllable_) {
      DeltaPcYNum_ = localIndex;
      ++localIndex;
    }
    if (isQControllable_ || isControllable_) {
      DeltaQcYNum_ = localIndex;
      ++localIndex;
    }

    if (isRestorative_) {
      zPYNum_ = localIndex;
      ++localIndex;
      zQYNum_ = localIndex;
      ++localIndex;
    }

    yNum += localIndex;
  }
}

void
ModelLoad::evalJt(const double cj, const int rowOffset, SparseMatrix& jt) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelLoad::evalJt");
#endif
  if (network_->isInitModel())
    return;

  if (isRestorative_) {
    if (!isRunning()) {
      // column for equations Zp
      jt.changeCol();
      jt.addTerm(globalYIndex(zPYNum_) + rowOffset, cj);

      // column for equations Zq
      jt.changeCol();
      jt.addTerm(globalYIndex(zQYNum_) + rowOffset, cj);
    } else {
      const double ur = modelBus_.ur();
      const double ui = modelBus_.ui();
      const double U = sqrt(ur * ur + ui * ui);
      const int urYNum = modelBus_.urYNum();
      const int uiYNum = modelBus_.uiYNum();

      // column for equations Zp
      jt.changeCol();
      // @f[0]/@zp, @f[0]/@ur, @f[0]/@ui
      const double zp = zP();
      const double powUAlpha = pow_dynawo(U, alpha_);
      const double zPdiff = pow_dynawo(U / u0_, alphaLong_) - zp * powUAlpha * kp_;
      if (TpIsZero_) {
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, cj);
      } else if ((zp > 0. && zp < zPMax_) || (zp <= 0. && zPdiff > 0.) || (zp >= zPMax_ && zPdiff < 0.)) {
        const double termZp = -powUAlpha * kp_;
        const double powUAlphaLongMinus2 = pow_dynawo(U, alphaLong_ - 2.);
        const double powU0AlphaLong = pow_dynawo(u0_, alphaLong_);
        const double powUAlphaMinus2 = pow_dynawo(U, alpha_ - 2.);
        const double termUr = alphaLong_ * ur *  powUAlphaLongMinus2 / powU0AlphaLong - zp * alpha_ * ur * powUAlphaMinus2 * kp_;
        const double termUi = alphaLong_ * ui *  powUAlphaLongMinus2 / powU0AlphaLong - zp * alpha_ * ui * powUAlphaMinus2 * kp_;
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, -termZp + cj * Tp_);
        jt.addTerm(urYNum + rowOffset, -termUr);
        jt.addTerm(uiYNum + rowOffset, -termUi);
      } else {
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, cj * Tp_);
      }

      // column for equations Zq
      jt.changeCol();
      // @f[1]/@zq, @f[1]/@ur, @f[1]/@ui
      const double zq = zQ();
      const double powUBeta = pow_dynawo(U, beta_);
      const double zQdiff = pow_dynawo(U / u0_, betaLong_) - zq * powUBeta * kq_;
      if (TqIsZero_) {
        jt.addTerm(globalYIndex(zQYNum_) + rowOffset, cj);
      } else if ((zq > 0. && zq < zQMax_) || (zq <= 0. && zQdiff > 0.) || (zq >= zQMax_ && zQdiff < 0.)) {
        const double termZq = -powUBeta * kq_;
        const double powUBetaLongMinus2 = pow_dynawo(U, betaLong_ - 2.);
        const double powU0BetaLong = pow_dynawo(u0_, betaLong_);
        const double powUBetaMinus2 = pow_dynawo(U, beta_ - 2.);
        const double termUr = betaLong_ * ur * powUBetaLongMinus2 / powU0BetaLong - zq * beta_ * ur * powUBetaMinus2 * kq_;
        const double termUi = betaLong_ * ui * powUBetaLongMinus2 / powU0BetaLong - zq * beta_ * ui * powUBetaMinus2 * kq_;
        jt.addTerm(globalYIndex(zQYNum_) + rowOffset, - termZq + cj * Tq_);
        jt.addTerm(urYNum + rowOffset, -termUr);
        jt.addTerm(uiYNum + rowOffset, -termUi);
      } else {
        jt.addTerm(globalYIndex(zQYNum_) + rowOffset, cj * Tq_);
      }
    }
  }
}

void
ModelLoad::evalJtPrim(const int rowOffset, SparseMatrix& jtPrim) {
  if (isRestorative_) {
    if (!isRunning()) {
      // column for equations Zp
      jtPrim.changeCol();
      jtPrim.addTerm(globalYIndex(zPYNum_) + rowOffset, 1);
      // column for equations Zq
      jtPrim.changeCol();
      jtPrim.addTerm(globalYIndex(zQYNum_) + rowOffset, 1);
    } else {
      // column for equations Zp
      jtPrim.changeCol();
      if (TpIsZero_) {
        jtPrim.addTerm(globalYIndex(zPYNum_) + rowOffset, 1);
      } else {
        jtPrim.addTerm(globalYIndex(zPYNum_) + rowOffset, Tp_);
      }

      // column for equations Zq
      jtPrim.changeCol();
      if (TqIsZero_) {
        jtPrim.addTerm(globalYIndex(zQYNum_) + rowOffset, 1);
      } else {
        jtPrim.addTerm(globalYIndex(zQYNum_) + rowOffset, Tq_);
      }
    }
  }
}

double
ModelLoad::P(const double U) const {
  return zP() * P0_ * (1. + deltaPc()) * pow_dynawo(U, alpha_) * kp_;
}

double
ModelLoad::Q(const double U) const {
  return zQ() * Q0_ * (1. + deltaQc()) * pow_dynawo(U, beta_) * kq_;
}

double
ModelLoad::zQ() const {
  if (isRestorative_) {
    if (network_->isInit())
      return zQ0_;
    else
      return y_[zQYNum_];
  } else {
    return 1.;
  }
}

double
ModelLoad::zP() const {
  if (isRestorative_) {
    if (network_->isInit())
      return zP0_;
    else
      return y_[zPYNum_];
  } else {
    return 1.;
  }
}

double
ModelLoad::zQPrim() const {
  if (isRestorative_) {
    if (network_->isInit())
      return zQprim0_;
    else
      return yp_[zQYNum_];
  } else {
    return 0.;
  }
}

double
ModelLoad::zPPrim() const {
  if (isRestorative_) {
    if (network_->isInit())
      return zPprim0_;
    else
      return yp_[zPYNum_];
  } else {
    return 0.;
  }
}

double
ModelLoad::deltaQc() const {
  if (network_->isInit())
    return DeltaQc0_;
  else if (!(isQControllable_ || isControllable_))
    return 0.;
  else
    return y_[DeltaQcYNum_];
}

double
ModelLoad::deltaPc() const {
  if (network_->isInit())
    return DeltaPc0_;
  else if (!(isPControllable_ || isControllable_))
    return 0.;
  else
    return y_[DeltaPcYNum_];
}

void
ModelLoad::getI(const double ur, const double ui, const double U, const double U2, double& ir, double& ii) const {
  const double p = P(U);
  const double q = Q(U);
  ii = (p * ui - q * ur) / U2;
  ir = (p * ur + q * ui) / U2;
}

double
ModelLoad::ir_dZp(const double ur, const double /*ui*/, const double U, const double U2) const {
  return 1. / U2 * (P0_ * (1. + deltaPc()) * kp_) * pow_dynawo(U, alpha_) * ur;
}

double
ModelLoad::ir_dZq(const double /*ur*/, const double ui, const double U, const double U2) const {
  return 1. / U2 * (Q0_ * (1. + deltaQc()) * kq_) * pow_dynawo(U, beta_) * ui;
}

double
ModelLoad::ii_dZp(const double /*ur*/, const double ui, const double U, const double U2) const {
  return 1. / U2 * (P0_ * (1. + deltaPc()) * kp_) * pow_dynawo(U, alpha_) * ui;
}

double
ModelLoad::ii_dZq(const double ur, const double /*ui*/, const double U, const double U2) const {
  return 1. / U2 * (-1. * Q0_ * (1. + deltaQc()) * kq_) * pow_dynawo(U, beta_) * ur;
}

double
ModelLoad::P_dUr(const double ur, const double /*ui*/, const double U, const double U2) const {
  return 1. / U2 * zP() * P0_ * (1. + deltaPc()) * kp_ * alpha_ * ur * pow_dynawo(U, alpha_);
}

double
ModelLoad::P_dUi(const double /*ur*/, const double ui, const double U, const double U2) const {
  return 1. / U2 * zP() * P0_ * (1. + deltaPc()) * kp_ * alpha_ * ui * pow_dynawo(U, alpha_);
}

double
ModelLoad::Q_dUr(const double ur, const double /*ui*/, const double U, const double U2) const {
  return 1. / U2 * zQ() * Q0_ * (1. + deltaQc()) * kq_ * beta_ * ur * pow_dynawo(U, beta_);
}

double
ModelLoad::Q_dUi(const double /*ur*/, const double ui, const double U, const double U2) const {
  return 1. / U2 * zQ() * Q0_ * (1. + deltaQc()) * kq_ * beta_ * ui * pow_dynawo(U, beta_);
}

void
ModelLoad::evalNodeInjection() {
  auto& modelBusNonCst = getNonCstModelBus();
  const auto& modelBus = getNonCstModelBus();
  if (isRunning()) {
    if (network_->isInitModel()) {
      modelBusNonCst.irAdd(ir0_);
      modelBusNonCst.iiAdd(ii0_);
    } else {
      const double U = modelBusNonCst.getCurrentU(ModelBus::UPuType_);
      if (doubleIsZero(U))
        return;
      const double U2 = U * U;
      const double ur = modelBus.ur();
      const double ui = modelBus.ui();
      double ii;
      double ir;
      getI(ur, ui, U, U2, ir, ii);
      modelBusNonCst.irAdd(ir);
      modelBusNonCst.iiAdd(ii);
    }
  }
}

void
ModelLoad::evalDerivatives(const double /*cj*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelLoad::evalDerivatives");
#endif
  auto& modelBus = getNonCstModelBus();
  if (network_->isInitModel())
    return;
  if (isRunning()) {
    const int urYNum = modelBus.urYNum();
    const int uiYNum = modelBus.uiYNum();
    const double ur = modelBus.ur();
    const double ui = modelBus.ui();
    const double U2 = ur * ur + ui * ui;
    if (doubleIsZero(U2))
      return;
    const double U = sqrt(U2);
    const double p = P(U);
    const double q = Q(U);
    const double PdUr = P_dUr(ur, ui, U, U2);
    const double QdUr = Q_dUr(ur, ui, U, U2);
    const double PdUi = P_dUi(ur, ui, U, U2);
    const double QdUi = Q_dUi(ur, ui, U, U2);
    auto& derivatives = modelBus.derivatives();
    derivatives->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr(ur, ui, U2, p, q, PdUr, QdUr));
    derivatives->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi(ur, ui, U2, p, q, PdUi, QdUi));
    derivatives->addDerivative(II_DERIVATIVE, urYNum, ii_dUr(ur, ui, U2, p, q, PdUr, QdUr));
    derivatives->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi(ur, ui, U2, p, q, PdUi, QdUi));
    if (isRestorative_) {
      int zPYNumGlobal = globalYIndex(zPYNum_);
      int zQYNumGlobal = globalYIndex(zQYNum_);
      derivatives->addDerivative(IR_DERIVATIVE, zPYNumGlobal, ir_dZp(ur, ui, U, U2));
      derivatives->addDerivative(IR_DERIVATIVE, zQYNumGlobal, ir_dZq(ur, ui, U, U2));
      derivatives->addDerivative(II_DERIVATIVE, zPYNumGlobal, ii_dZp(ur, ui, U, U2));
      derivatives->addDerivative(II_DERIVATIVE, zQYNumGlobal, ii_dZq(ur, ui, U, U2));
    }
  }
}

void
ModelLoad::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  if (isPControllable_ || isControllable_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_DeltaPc_value", CONTINUOUS));
  }
  if (isQControllable_ || isControllable_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_DeltaQc_value", CONTINUOUS));
  }

  if (isRestorative_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_zP_value", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState(id_ + "_zQ_value", CONTINUOUS));
  }
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Pc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Qc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_loadState_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
}

void
ModelLoad::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_DeltaPc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_DeltaQc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_zP_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_zQ_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Pc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Qc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_loadState_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", INTEGER));
}

void
ModelLoad::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  const string loadName = id_;
  // ======= STATE VARIABLES ========
  if (isPControllable_ || isControllable_) {
    addElementWithValue(loadName + string("_DeltaPc"), "Load", elements, mapElement);
  }
  if (isQControllable_ || isControllable_) {
    addElementWithValue(loadName + string("_DeltaQc"), "Load", elements, mapElement);
  }
  if (isRestorative_) {
    addElementWithValue(loadName + string("_zP"), "Load", elements, mapElement);
    addElementWithValue(loadName + string("_zQ"), "Load", elements, mapElement);
  }
  addElementWithValue(loadName + string("_state"), "Load", elements, mapElement);
  addElementWithValue(loadName + string("_P"), "Load", elements, mapElement);
  addElementWithValue(loadName + string("_Q"), "Load", elements, mapElement);
  addElementWithValue(loadName + string("_Pc"), "Load", elements, mapElement);
  addElementWithValue(loadName + string("_Qc"), "Load", elements, mapElement);
  addElementWithValue(loadName + string("_loadState"), "Load", elements, mapElement);
}

NetworkComponent::StateChange_t
ModelLoad::evalZ(const double /*t*/, bool /*deactivateRootFunctions*/) {
  const auto& modelBus = getModelBus();
  if (modelBus.getConnectionState() == OPEN)
    z_[0] = OPEN;

  const auto currState = static_cast<State>(static_cast<int>(z_[0]));
  if (currState != getConnected()) {
    Trace::info() << DYNLog(LoadStateChange, id_, getConnected(), z_[0]) << Trace::endline;
    if (currState == OPEN) {
      DYNAddTimelineEvent(network_, id_, LoadDisconnected);
      modelBus.getVoltageLevel()->disconnectNode(modelBus.getBusIndex());
    } else {
      DYNAddTimelineEvent(network_, id_, LoadConnected);
      modelBus.getVoltageLevel()->connectNode(modelBus.getBusIndex());
    }
    stateModified_ = true;
    setConnected(currState);
  }
  return stateModified_?NetworkComponent::STATE_CHANGE:NetworkComponent::NO_CHANGE;
}

void
ModelLoad::evalG(const double /*t*/) {
  /* no G equation */
}

void
ModelLoad::getY0() {
  if (!network_->isInitModel()) {
    if (!network_->isStartingFromDump() || !internalVariablesFoundInDump_) {
      unsigned int index = 0;
      if (isPControllable_ || isControllable_) {
        y_[index] = DeltaPc0_;
        ++index;
      }
      if (isQControllable_ || isControllable_) {
        y_[index] = DeltaQc0_;
        ++index;
      }

      if (isRestorative_) {
        y_[index] = zP0_;
        yp_[index] = zPprim0_;
        ++index;
        y_[index] = zQ0_;
        yp_[index] = zQprim0_;
        ++index;
      }

      z_[0] = getConnected();
    } else {
      unsigned int index = 0;
      if (isPControllable_ || isControllable_) {
        DeltaPc0_ = y_[index];
        ++index;
      }
      if (isQControllable_ || isControllable_) {
        DeltaQc0_ = y_[index];
        ++index;
      }

      if (isRestorative_) {
        zP0_ = y_[index];
        zPprim0_ = yp_[index];
        ++index;
        zQ0_ = y_[index];
        zQprim0_ = yp_[index];
        ++index;
      }
      State loadCurrState = static_cast<State>(static_cast<int>(z_[0]));
      if (loadCurrState == CLOSED) {
        if (modelBus_.getConnectionState() != CLOSED) {
          modelBus_.getVoltageLevel()->connectNode(modelBus_.getBusIndex());
          stateModified_ = true;
        }
      } else if (loadCurrState == OPEN) {
        if (modelBus_.getConnectionState() != OPEN) {
          modelBus_.getVoltageLevel()->disconnectNode(modelBus_.getBusIndex());
          stateModified_ = true;
        }
      } else if (loadCurrState == UNDEFINED_STATE) {
        throw DYNError(Error::MODELER, UndefinedComponentState, id_);
      } else {
        throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
      }
      setConnected(loadCurrState);
    }
  }
}

void
ModelLoad::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  ModelCPP::dumpInStream(streamVariables, P0_);
  ModelCPP::dumpInStream(streamVariables, Q0_);
  ModelCPP::dumpInStream(streamVariables, u0_);
  ModelCPP::dumpInStream(streamVariables, ii0_);
  ModelCPP::dumpInStream(streamVariables, ir0_);
}

void
ModelLoad::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> P0_;
  streamVariables >> c;
  streamVariables >> Q0_;
  streamVariables >> c;
  streamVariables >> u0_;
  streamVariables >> c;
  streamVariables >> ii0_;
  streamVariables >> c;
  streamVariables >> ir0_;
}

void
ModelLoad::collectSilentZ(BitMask* silentZTable) {
  silentZTable[0].setFlags(NotUsedInDiscreteEquations);
}

void
ModelLoad::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  // All the parameters could be non generic ones
  vector<string> ids;
  ids.push_back(id_);
  ids.push_back("load");
  bool startingPointModeFound = false;
  const std::string startingPointMode = getParameterDynamicNoThrow<string>(params, "startingPointMode", startingPointModeFound);
  if (startingPointModeFound) {
    startingPointMode_ = getStartingPointMode(startingPointMode);
  }
  try {
    // Non generic parameters have a higher priority than generic ones
    alpha_ = getParameterDynamic<double>(params, "alpha", ids);
    beta_ = getParameterDynamic<double>(params, "beta", ids);
    isRestorative_ = getParameterDynamic<bool>(params, "isRestorative", ids);
    for (const string& id : ids) {
      if (hasParameter(id + "_isPControllable", params)) {
        const ParameterModeler& isPControllable = findParameter(id + "_isPControllable", params);
        if (isPControllable.hasValue())
          isPControllable_ = getParameterDynamic<bool>(params, "isPControllable", ids);
      }
    }
    for (const string& id : ids) {
      if (hasParameter(id + "_isQControllable", params)) {
        const ParameterModeler& isQControllable = findParameter(id + "_isQControllable", params);
        if (isQControllable.hasValue())
          isQControllable_ = getParameterDynamic<bool>(params, "isQControllable", ids);
      }
    }
    isControllable_ = getParameterDynamic<bool>(params, "isControllable", ids);
    if (isRestorative_) {
      Tp_ = getParameterDynamic<double>(params, "Tp", ids);
      TpIsZero_ = doubleIsZero(Tp_);
      Tq_ = getParameterDynamic<double>(params, "Tq", ids);
      TqIsZero_ = doubleIsZero(Tq_);
      zPMax_ = getParameterDynamic<double>(params, "zPMax", ids);
      zQMax_ = getParameterDynamic<double>(params, "zQMax", ids);
      alphaLong_ = getParameterDynamic<double>(params, "alphaLong", ids);
      betaLong_ = getParameterDynamic<double>(params, "betaLong", ids);
    }
  } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    throw DYNError(Error::MODELER, NetworkParameterNotFoundFor, id_);
  }
}

void
ModelLoad::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("load_alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_isRestorative", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_isPControllable", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_isQControllable", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_isControllable", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_Tp", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_Tq", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_zPMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_zQMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_alphaLong", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_betaLong", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

// All the load parameters can be defined specifically for one load
void
ModelLoad::defineNonGenericParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(id_ + "_alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_isRestorative", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_isPControllable", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_isQControllable", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_isControllable", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_Tp", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_Tq", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_zPMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_zQMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_alphaLong", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_betaLong", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

NetworkComponent::StateChange_t
ModelLoad::evalState(const double /*time*/) {
  if (stateModified_) {
    stateModified_ = false;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelLoad::evalCalculatedVars() {
  auto& modelBus = getNonCstModelBus();
  if (isRunning()) {
    const double U = modelBus.getCurrentU(ModelBus::UPuType_);
    // P
    calculatedVars_[pNum_] = P(U);

    // Q
    calculatedVars_[qNum_] = Q(U);

    calculatedVars_[pcNum_] = P0_ * (1. + deltaPc()) * kp_;
    calculatedVars_[qcNum_] = Q0_ * (1. + deltaQc()) * kq_;

  } else {
    calculatedVars_[pNum_] = 0.;
    calculatedVars_[qNum_] = 0.;
    calculatedVars_[pcNum_] = 0.;
    calculatedVars_[qcNum_] = 0.;
  }
  calculatedVars_[loadStateNum_] = connectionState_;
}

void
ModelLoad::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
  const auto& modelBus = getModelBus();
  switch (numCalculatedVar) {
    case pNum_: {
      numVars.push_back(modelBus.urYNum());
      numVars.push_back(modelBus.uiYNum());
      if (isPControllable_ || isControllable_)
        numVars.push_back(DeltaPcYNum_ + yOffset_);
      if (isRestorative_)
        numVars.push_back(zPYNum_ + yOffset_);
    }
    break;
    case qNum_: {
      numVars.push_back(modelBus.urYNum());
      numVars.push_back(modelBus.uiYNum());
      if (isQControllable_ || isControllable_)
        numVars.push_back(DeltaQcYNum_ + yOffset_);
      if (isRestorative_)
        numVars.push_back(zQYNum_ + yOffset_);
    }
    break;
    case pcNum_: {
      if (isPControllable_ || isControllable_) {
        numVars.push_back(DeltaPcYNum_ + yOffset_);
      }
    }
    break;
    case qcNum_: {
      if (isQControllable_ || isControllable_) {
        numVars.push_back(DeltaQcYNum_ + yOffset_);
      }
    }
    break;
    case loadStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelLoad::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  const auto& modelBus = getModelBus();
  switch (numCalculatedVar) {
    case pNum_: {
      if (isRunning()) {
        const double ur = modelBus.ur();
        const double ui = modelBus.ui();
        double deltaPcVal = 0.;
        double zPVal = 1.;
        if (isPControllable_ || isControllable_) {
          deltaPcVal = deltaPc();
        }
        if (isRestorative_) {
          zPVal = zP();
        }
        const double U = sqrt(ur * ur + ui * ui);

        unsigned int indexRes = 0;
        res[indexRes] =  zPVal * P0_ * (1. + deltaPcVal) * kp_ * alpha_ * ur * pow_dynawo(U, alpha_ - 2.);  // dP/dUr
        ++indexRes;
        res[indexRes] =  zPVal * P0_ * (1. + deltaPcVal) * kp_ * alpha_ * ui * pow_dynawo(U, alpha_ - 2.);  // dP/dUi
        ++indexRes;
        if (isPControllable_ || isControllable_) {
          res[indexRes] = zPVal * P0_ * pow_dynawo(U, alpha_) * kp_;  // dP/d(deltaPc)
          ++indexRes;
        }
        if (isRestorative_) {
          res[indexRes] = P0_ * (1. + deltaPcVal) * pow_dynawo(U, alpha_) * kp_;  // dP/d(zP)
        }
      }
    }
    break;
    case qNum_: {
      if (isRunning()) {
        const double ur = modelBus.ur();
        const double ui = modelBus.ui();
        double deltaQcVal = 0.;
        double zQVal = 1.;
        if (isQControllable_ || isControllable_) {
          deltaQcVal = deltaQc();
        }
        if (isRestorative_) {
          zQVal = zQ();
        }
        const double U = sqrt(ur * ur + ui * ui);

        unsigned int indexRes = 0;
        res[indexRes] = zQVal * Q0_ * (1. + deltaQcVal) * kq_ * beta_ * ur * pow_dynawo(U, beta_ - 2.);  // dQ/dUr
        ++indexRes;
        res[indexRes] = zQVal * Q0_ * (1. + deltaQcVal) * kq_ * beta_ * ui * pow_dynawo(U, beta_ - 2.);  // dQ/dUi
        ++indexRes;
        if (isQControllable_ || isControllable_) {
          res[indexRes] = zQVal * Q0_ * pow_dynawo(U, beta_) * kq_;  // dQ/d(deltaQc)
          ++indexRes;
        }
        if (isRestorative_) {
          res[indexRes] = Q0_ * (1. + deltaQcVal) * pow_dynawo(U, beta_) * kq_;  // dQ/d(zQ)
        }
      }
    }
    break;
    case pcNum_: {
       if (isRunning() && (isPControllable_ || isControllable_)) {
         res[0] = P0_ * kp_;  // dPc / d(deltaPc)
       }
    }
    break;
    case qcNum_: {
      if (isRunning() && (isQControllable_ || isControllable_)) {
         res[0] = Q0_ * kq_;  // dQc / d(deltaQc)
       }
    }
    break;
    case loadStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelLoad::evalCalculatedVarI(unsigned numCalculatedVar) const {
  double output = 0.;
  const auto& modelBus = getModelBus();
  switch (numCalculatedVar) {
    case pNum_: {
      if (isRunning()) {
        const double ur = modelBus.ur();
        const double ui = modelBus.ui();
        const double U = sqrt(ur * ur + ui * ui);
        double deltaPcVal = 0.;
        double zPVal = 1.;
        if (isPControllable_ || isControllable_) {
          deltaPcVal = deltaPc();
        }
        if (isRestorative_) {
          zPVal = zP();
        }
        output = zPVal * P0_ * (1. + deltaPcVal) * pow_dynawo(U, alpha_) * kp_;
      }
    }
    break;
    case qNum_: {
      if (isRunning()) {
        const double ur = modelBus.ur();
        const double ui = modelBus.ui();
        const double U = sqrt(ur * ur + ui * ui);
        double deltaQcVal = 0.;
        double zQVal = 1.;
        if (isQControllable_ || isControllable_) {
          deltaQcVal = deltaQc();
        }
        if (isRestorative_) {
          zQVal = zQ();
        }
        output = zQVal * Q0_ * (1. + deltaQcVal) * pow_dynawo(U, beta_) * kq_;
      }
    }
    break;
    case pcNum_: {
      if (isRunning()) {
        const double deltaPcVal = (isPControllable_ || isControllable_) ? deltaPc() : 0.;
        output = P0_ * (1. + deltaPcVal) * kp_;
      }
    }
    break;
    case qcNum_: {
      if (isRunning()) {
        const double deltaQcVal = (isQControllable_ || isControllable_) ? deltaQc() : 0.;
        output = Q0_ * (1. + deltaQcVal) * kq_;
      }
    }
    break;
    case loadStateNum_:
      output = connectionState_;
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return output;
}

}  // namespace DYN
