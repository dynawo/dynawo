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
#include "DYNCommon.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
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

ModelLoad::ModelLoad(const shared_ptr<LoadInterface>& load) :
Impl(load->getID()),
stateModified_(false),
kp_(0.),
kq_(0.),
alpha_(1.),
beta_(1.),
isRestorative_(false),
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
zQYNum_(0) {
  // init data
  P0_ = load->getP() / SNREF;
  Q0_ = load->getQ() / SNREF;
  connectionState_ = load->getInitialConnected() ? CLOSED : OPEN;
  double uNode = load->getBusInterface()->getV0();
  double tetaNode = load->getBusInterface()->getAngle0();
  double unomNode = load->getBusInterface()->getVNom();
  double ur0 = uNode / unomNode * cos(tetaNode * DEG_TO_RAD);
  double ui0 = uNode / unomNode * sin(tetaNode * DEG_TO_RAD);
  ir0_ = (P0_ * ur0 + Q0_ * ui0) / (ur0 * ur0 + ui0 * ui0);
  ii0_ = (P0_ * ui0 - Q0_ * ur0) / (ur0 * ur0 + ui0 * ui0);
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
    if (isControllable_)
      sizeY_ += 2;  // DeltaPc and DeltaQc
    if (isRestorative_)
      sizeY_ += 2;  // zP and zQ

    sizeZ_ = 1;
    sizeG_ = 0;
    sizeMode_ = 1;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

void ModelLoad::evalYType() {
  unsigned int yTypeIndex = 0;
  if (isControllable_) {
    yType_[yTypeIndex] = EXTERNAL;  // DeltaPc
    ++yTypeIndex;
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

void ModelLoad::evalFType() {
  if (isRestorative_) {
    fType_[0] = DIFFERENTIAL_EQ;  // differential equations
    fType_[1] = DIFFERENTIAL_EQ;
  }
}

void
ModelLoad::evalF(propertyF_t type) {
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
      double U = modelBus_->getCurrentU(ModelBus::UPuType_);

      double zPprimValue = 0.;
      double zp = zP();
      double zPdiff = pow(U / u0_, alphaLong_) - zp * pow(U, alpha_) * kp_;
      if ((zp > 0. && zp < zPMax_) || (zp <= 0. && zPdiff > 0.) || (zp >= zPMax_ && zPdiff < 0.))
        zPprimValue = zPdiff;
      f_[0] = Tp_ * zPPrim() - zPprimValue;

      double zQprimValue = 0.;
      double zq = zQ();
      double zQdiff = (pow(U / u0_, betaLong_) - zq * pow(U, beta_) * kq_);
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

  unsigned int index = 0;

  if (isRestorative_) {
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

  assert(fEquationIndex.size() == (unsigned int) sizeF() && "ModelLoad:fEquationIndex.size() != f_.size()");
}

void
ModelLoad::setGequations(std::map<int, std::string>& /*gEquationIndex*/) {
  /* no G equation */
}

void
ModelLoad::init(int& yNum) {
  if (!network_->isInitModel()) {
    assert(yNum >= 0);
    yOffset_ = static_cast<unsigned int>(yNum);
    unsigned int localIndex = 0;

    if (isControllable_) {
      DeltaPcYNum_ = localIndex;
      ++localIndex;
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
ModelLoad::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) {
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
      double ur = modelBus_->ur();
      double ui = modelBus_->ui();
      double U = sqrt(ur * ur + ui * ui);
      int urYNum = modelBus_->urYNum();
      int uiYNum = modelBus_->uiYNum();

      // column for equations Zp
      jt.changeCol();
      // @f[0]/@zp, @f[0]/@ur, @f[0]/@ui
      double zp = zP();
      double powUAlpha = pow(U, alpha_);
      double zPdiff = pow(U / u0_, alphaLong_) - zp * powUAlpha * kp_;
      if (TpIsZero_) {
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, cj);
      } else if ((zp > 0. && zp < zPMax_) || (zp <= 0. && zPdiff > 0.) || (zp >= zPMax_ && zPdiff < 0.)) {
        double termZp = -powUAlpha * kp_;
        double powUAlphaLongMinus2 = pow(U, alphaLong_ - 2.);
        double powU0AlphaLong = pow(u0_, alphaLong_);
        double powUAlphaMinus2 = pow(U, alpha_ - 2.);
        double termUr = alphaLong_ * ur *  powUAlphaLongMinus2 / powU0AlphaLong - zp * alpha_ * ur * powUAlphaMinus2 * kp_;
        double termUi = alphaLong_ * ui *  powUAlphaLongMinus2 / powU0AlphaLong - zp * alpha_ * ui * powUAlphaMinus2 * kp_;
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, -termZp + cj * Tp_);
        jt.addTerm(urYNum + rowOffset, -termUr);
        jt.addTerm(uiYNum + rowOffset, -termUi);
      } else {
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, cj * Tp_);
      }

      // column for equations Zq
      jt.changeCol();
      // @f[1]/@zq, @f[1]/@ur, @f[1]/@ui
      double zq = zQ();
      double powUBeta = pow(U, beta_);
      double zQdiff = pow(U / u0_, betaLong_) - zq * powUBeta * kq_;
      if (TqIsZero_) {
        jt.addTerm(globalYIndex(zQYNum_) + rowOffset, cj);
      } else if ((zq > 0. && zq < zQMax_) || (zq <= 0. && zQdiff > 0.) || (zq >= zQMax_ && zQdiff < 0.)) {
        double termZq = -powUBeta * kq_;
        double powUBetaLongMinus2 = pow(U, betaLong_ - 2.);
        double powU0BetaLong = pow(u0_, betaLong_);
        double powUBetaMinus2 = pow(U, beta_ - 2.);
        double termUr = betaLong_ * ur * powUBetaLongMinus2 / powU0BetaLong - zq * beta_ * ur * powUBetaMinus2 * kq_;
        double termUi = betaLong_ * ui * powUBetaLongMinus2 / powU0BetaLong - zq * beta_ * ui * powUBetaMinus2 * kq_;
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
ModelLoad::evalJtPrim(SparseMatrix& jt, const int& rowOffset) {
  if (isRestorative_) {
    if (!isRunning()) {
      // column for equations Zp
      jt.changeCol();
      jt.addTerm(globalYIndex(zPYNum_) + rowOffset, 1);
      // column for equations Zq
      jt.changeCol();
      jt.addTerm(globalYIndex(zQYNum_) + rowOffset, 1);
    } else {
      // column for equations Zp
      jt.changeCol();
      if (TpIsZero_) {
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, 1);
      } else {
        jt.addTerm(globalYIndex(zPYNum_) + rowOffset, Tp_);
      }

      // column for equations Zq
      jt.changeCol();
      if (TqIsZero_) {
        jt.addTerm(globalYIndex(zQYNum_) + rowOffset, 1);
      } else {
        jt.addTerm(globalYIndex(zQYNum_) + rowOffset, Tq_);
      }
    }
  }
}

double
ModelLoad::P(const double& /*ur*/, const double& /*ui*/, const double& U) const {
  return zP() * P0_ * (1. + deltaPc()) * pow(U, alpha_) * kp_;
}

double
ModelLoad::Q(const double& /*ur*/, const double& /*ui*/, const double& U) const {
  return zQ() * Q0_ * (1. + deltaQc()) * pow(U, beta_) * kq_;
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
  else if (!isControllable_)
    return 0.;
  else
    return y_[DeltaQcYNum_];
}

double
ModelLoad::deltaPc() const {
  if (network_->isInit())
    return DeltaPc0_;
  else if (!isControllable_)
    return 0.;
  else
    return y_[DeltaPcYNum_];
}

void
ModelLoad::getI(double ur, double ui, double U, double U2, double& ir, double& ii) const {
  double p = P(ur, ui, U);
  double q = Q(ur, ui, U);
  ii = (p * ui - q * ur) / U2;
  ir = (p * ur + q * ui) / U2;
}

double
ModelLoad::ir_dZp(const double& ur, const double& /*ui*/, const double& U, const double& U2) const {
  return 1. / U2 * (P0_ * (1. + deltaPc()) * kp_) * pow(U, alpha_) * ur;
}

double
ModelLoad::ir_dZq(const double& /*ur*/, const double& ui, const double& U, const double& U2) const {
  return 1. / U2 * (Q0_ * (1. + deltaQc()) * kq_) * pow(U, beta_) * ui;
}

double
ModelLoad::ii_dZp(const double& /*ur*/, const double& ui, const double& U, const double& U2) const {
  return 1. / U2 * (P0_ * (1. + deltaPc()) * kp_) * pow(U, alpha_) * ui;
}

double
ModelLoad::ii_dZq(const double& ur, const double& /*ui*/, const double& U, const double& U2) const {
  return 1. / U2 * (-1. * Q0_ * (1. + deltaQc()) * kq_) * pow(U, beta_) * ur;
}

double
ModelLoad::P_dUr(const double& ur, const double& /*ui*/, const double& U, const double& U2) const {
  return 1. / U2 * zP() * P0_ * (1. + deltaPc()) * kp_ * alpha_ * ur * pow(U, alpha_);
}

double
ModelLoad::P_dUi(const double& /*ur*/, const double& ui, const double& U, const double& U2) const {
  return 1. / U2 * zP() * P0_ * (1. + deltaPc()) * kp_ * alpha_ * ui * pow(U, alpha_);
}

double
ModelLoad::Q_dUr(const double& ur, const double& /*ui*/, const double& U, const double& U2) const {
  double Q_dUr = 0.;
  if (!modelBus_->getSwitchOff()) {
    Q_dUr = 1. / U2 * zQ() * Q0_ * (1. + deltaQc()) * kq_ * beta_ * ur * pow(U, beta_);
  }
  return Q_dUr;
}

double
ModelLoad::Q_dUi(const double& /*ur*/, const double& ui, const double& U, const double& U2) const {
  return 1. / U2 * zQ() * Q0_ * (1. + deltaQc()) * kq_ * beta_ * ui * pow(U, beta_);
}

void
ModelLoad::evalNodeInjection() {
  if (isRunning()) {
    if (network_->isInitModel()) {
      modelBus_->irAdd(ir0_);
      modelBus_->iiAdd(ii0_);
    } else {
      double U = modelBus_->getCurrentU(ModelBus::UPuType_);
      if (doubleIsZero(U))
        return;
      double U2 = modelBus_->getCurrentU(ModelBus::U2PuType_);
      double ur = modelBus_->ur();
      double ui = modelBus_->ui();
      double ii;
      double ir;
      getI(ur, ui, U, U2, ir, ii);
      modelBus_->irAdd(ir);
      modelBus_->iiAdd(ii);
    }
  }
}

void
ModelLoad::evalDerivatives(const double /*cj*/) {
  if (network_->isInitModel())
    return;
  if (isRunning()) {
    int urYNum = modelBus_->urYNum();
    int uiYNum = modelBus_->uiYNum();
    double ur = modelBus_->ur();
    double ui = modelBus_->ui();
    double U2 = ur * ur + ui * ui;
    if (doubleIsZero(U2))
      return;
    double U = sqrt(U2);
    double p = P(ur, ui, U);
    double q = Q(ur, ui, U);
    double PdUr = P_dUr(ur, ui, U, U2);
    double QdUr = Q_dUr(ur, ui, U, U2);
    double PdUi = P_dUi(ur, ui, U, U2);
    double QdUi = Q_dUi(ur, ui, U, U2);
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr(ur, ui, U2, p, q, PdUr, QdUr));
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi(ur, ui, U2, p, q, PdUi, QdUi));
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii_dUr(ur, ui, U2, p, q, PdUr, QdUr));
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi(ur, ui, U2, p, q, PdUi, QdUi));
    if (isRestorative_) {
      modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, globalYIndex(zPYNum_), ir_dZp(ur, ui, U, U2));
      modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, globalYIndex(zQYNum_), ir_dZq(ur, ui, U, U2));
      modelBus_->derivatives()->addDerivative(II_DERIVATIVE, globalYIndex(zPYNum_), ii_dZp(ur, ui, U, U2));
      modelBus_->derivatives()->addDerivative(II_DERIVATIVE, globalYIndex(zQYNum_), ii_dZq(ur, ui, U, U2));
    }
  }
}

void
ModelLoad::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  if (isControllable_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_DeltaPc_value", CONTINUOUS));
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
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", DISCRETE));
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
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", DISCRETE));
}

void
ModelLoad::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  string loadName = id_;
  string name;
  // ======= STATE VARIABLES ========
  if (isControllable_) {
    addElementWithValue(loadName + string("_DeltaPc"), elements, mapElement);
    addElementWithValue(loadName + string("_DeltaQc"), elements, mapElement);
  }
  if (isRestorative_) {
    addElementWithValue(loadName + string("_zP"), elements, mapElement);
    addElementWithValue(loadName + string("_zQ"), elements, mapElement);
  }
  addElementWithValue(loadName + string("_state"), elements, mapElement);
  addElementWithValue(loadName + string("_P"), elements, mapElement);
  addElementWithValue(loadName + string("_Q"), elements, mapElement);
  addElementWithValue(loadName + string("_Pc"), elements, mapElement);
  addElementWithValue(loadName + string("_Qc"), elements, mapElement);
  addElementWithValue(loadName + string("_loadState"), elements, mapElement);
}

NetworkComponent::StateChange_t
ModelLoad::evalZ(const double& /*t*/) {
  State currState = static_cast<State>(static_cast<int>(z_[0]));
  if (currState != getConnected()) {
    Trace::info() << DYNLog(LoadStateChange, id_, getConnected(), z_[0]) << Trace::endline;
    if (currState == OPEN) {
      network_->addEvent(id_, DYNTimeline(LoadDisconnected));
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else {
      network_->addEvent(id_, DYNTimeline(LoadConnected));
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
    stateModified_ = true;
    setConnected(currState);
  }
  return (stateModified_)?NetworkComponent::STATE_CHANGE:NetworkComponent::NO_CHANGE;
}

void
ModelLoad::evalG(const double& /*t*/) {
  /* no G equation */
}

void
ModelLoad::getY0() {
  if (!network_->isInitModel()) {
    unsigned int index = 0;
    if (isControllable_) {
      y_[index] = DeltaPc0_;
      ++index;
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
  }
}

void
ModelLoad::collectSilentZ(bool* silentZTable) {
  silentZTable[0] = true;
}

void
ModelLoad::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params) {
  // All the parameters could be non generic ones
  vector<string> ids;
  ids.push_back(id_);
  ids.push_back("load");
  try {
    // Non generic parameters have a higher priority than generic ones
    alpha_ = getParameterDynamic<double>(params, "alpha", ids);
    beta_ = getParameterDynamic<double>(params, "beta", ids);
    isRestorative_ = getParameterDynamic<bool>(params, "isRestorative", ids);
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

  // Connection ModelBus is supposed to be initialized before parameters set
  u0_ = modelBus_->getU0();
  if (isConnected() && !doubleIsZero(u0_)) {
    kp_ = 1. / pow(u0_, alpha_);
    kq_ = 1. / pow(u0_, beta_);
  } else {
    kp_ = 0.;
    kq_ = 0.;
  }
  return;
}

void
ModelLoad::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("load_alpha", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_beta", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("load_isRestorative", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
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
  parameters.push_back(ParameterModeler(id_ + "_isControllable", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_Tp", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_Tq", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_zPMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_zQMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_alphaLong", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_betaLong", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

NetworkComponent::StateChange_t
ModelLoad::evalState(const double& /*time*/) {
  if (stateModified_) {
    stateModified_ = false;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelLoad::evalCalculatedVars() {
  if (isRunning()) {
    double ur = modelBus_->ur();
    double ui = modelBus_->ui();
    double U = modelBus_->getCurrentU(ModelBus::UPuType_);
    // P
    calculatedVars_[pNum_] = P(ur, ui, U);

    // Q
    calculatedVars_[qNum_] = Q(ur, ui, U);

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
  switch (numCalculatedVar) {
    case pNum_: {
      if (isRunning()) {
        numVars.push_back(modelBus_->urYNum());
        numVars.push_back(modelBus_->uiYNum());
        if (isControllable_)
          numVars.push_back(DeltaPcYNum_ + yOffset_);
        if (isRestorative_)
          numVars.push_back(zPYNum_ + yOffset_);
      }
    }
    break;
    case qNum_: {
      if (isRunning()) {
        numVars.push_back(modelBus_->urYNum());
        numVars.push_back(modelBus_->uiYNum());
        if (isControllable_)
          numVars.push_back(DeltaQcYNum_ + yOffset_);
        if (isRestorative_)
          numVars.push_back(zQYNum_ + yOffset_);
      }
    }
    break;
    case pcNum_: {
      if (isRunning() && isControllable_) {
        numVars.push_back(DeltaPcYNum_ + yOffset_);
      }
    }
    break;
    case qcNum_: {
      if (isRunning() && isControllable_) {
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
  switch (numCalculatedVar) {
    case pNum_: {
      if (isRunning()) {
        double ur = modelBus_->ur();
        double ui = modelBus_->ui();
        double deltaPcVal = 0.;
        double zPVal = 1.;
        if (isControllable_) {
          deltaPcVal = deltaPc();
        }
        if (isRestorative_) {
          zPVal = zP();
        }
        double U = sqrt(ur * ur + ui * ui);

        unsigned int indexRes = 0;
        res[indexRes] =  zPVal * P0_ * (1. + deltaPcVal) * kp_ * alpha_ * ur * pow(U, alpha_ - 2.);  // dP/dUr
        ++indexRes;
        res[indexRes] =  zPVal * P0_ * (1. + deltaPcVal) * kp_ * alpha_ * ui * pow(U, alpha_ - 2.);  // dP/dUi
        ++indexRes;
        if (isControllable_) {
          res[indexRes] = zPVal * P0_ * pow(U, alpha_) * kp_;  // dP/d(deltaPc)
          ++indexRes;
        }
        if (isRestorative_) {
          res[indexRes] = P0_ * (1. + deltaPcVal) * pow(U, alpha_) * kp_;  // dP/d(zP)
        }
      }
    }
    break;
    case qNum_: {
      if (isRunning()) {
        double ur = modelBus_->ur();
        double ui = modelBus_->ui();
        double deltaQcVal = 0.;
        double zQVal = 1.;
        if (isControllable_) {
          deltaQcVal = deltaQc();
        }
        if (isRestorative_) {
          zQVal = zQ();
        }
        double U = sqrt(ur * ur + ui * ui);

        unsigned int indexRes = 0;
        res[indexRes] = zQVal * Q0_ * (1. + deltaQcVal) * kq_ * beta_ * ur * pow(U, beta_ - 2.);  // dQ/dUr
        ++indexRes;
        res[indexRes] = zQVal * Q0_ * (1. + deltaQcVal) * kq_ * beta_ * ui * pow(U, beta_ - 2.);  // dQ/dUi
        ++indexRes;
        if (isControllable_) {
          res[indexRes] = zQVal * Q0_ * pow(U, beta_) * kq_;  // dQ/d(deltaQc)
          ++indexRes;
        }
        if (isRestorative_) {
          res[indexRes] = Q0_ * (1. + deltaQcVal) * pow(U, beta_) * kq_;  // dQ/d(zQ)
        }
      }
    }
    break;
    case pcNum_: {
       if (isRunning() && isControllable_) {
         res[0] = P0_ * kp_;  // dPc / d(deltaPc)
       }
    }
    break;
    case qcNum_: {
      if (isRunning() && isControllable_) {
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
  switch (numCalculatedVar) {
    case pNum_: {
      if (isRunning()) {
        double U = modelBus_->getCurrentU(ModelBus::UPuType_);
        double deltaPcVal = 0.;
        double zPVal = 1.;
        if (isControllable_) {
          deltaPcVal = deltaPc();
        }
        if (isRestorative_) {
          zPVal = zP();
        }
        output = zPVal * P0_ * (1. + deltaPcVal) * pow(U, alpha_) * kp_;
      }
    }
    break;
    case qNum_: {
      if (isRunning()) {
        double U = modelBus_->getCurrentU(ModelBus::UPuType_);
        double deltaQcVal = 0.;
        double zQVal = 1.;
        if (isControllable_) {
          deltaQcVal = deltaQc();
        }
        if (isRestorative_) {
          zQVal = zQ();
        }
        output = zQVal * Q0_ * (1. + deltaQcVal) * pow(U, beta_) * kq_;
      }
    }
    break;
    case pcNum_: {
      if (isRunning()) {
        double deltaPcVal = (isControllable_) ? deltaPc() : 0.;
        output = P0_ * (1. + deltaPcVal) * kp_;
      }
    }
    break;
    case qcNum_: {
      if (isRunning()) {
        double deltaQcVal = (isControllable_) ? deltaQc() : 0.;
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
  return (output);
}

}  // namespace DYN
