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
 * @file  DYNModelDanglingLine.cpp
 *
 * @brief
 *
 */
#include <cmath>
#include <vector>
#include <cassert>
#include "PARParametersSet.h"

#include "DYNModelDanglingLine.h"
#include "DYNModelConstants.h"
#include "DYNModelBus.h"
#include "DYNModelCurrentLimits.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNDanglingLineInterface.h"
#include "DYNCurrentLimitInterface.h"
#include "DYNBusInterface.h"
#include "DYNSparseMatrix.h"
#include "DYNModelNetwork.h"
#include "DYNModelVoltageLevel.h"

using parameters::ParametersSet;

using std::vector;
using boost::shared_ptr;
using std::map;
using std::string;

namespace DYN {

ModelDanglingLine::ModelDanglingLine(const shared_ptr<DanglingLineInterface>& line) :
NetworkComponent(line->getID()),
stateModified_(false),
modelType_("DanglingLine")  {
  // init data
  double vNom = line->getVNom();
  double r = line->getR();
  double x = line->getX();
  double b = line->getB();
  double g = line->getG();
  double P = line->getP() / SNREF;
  double Q = line->getQ() / SNREF;
  // to avoid nan for dangling line model if the line is not connected
  if (std::isnan(P) && std::isnan(Q)) {
    P = 0.;
    Q = 0.;
  }
  P0_ = line->getP0() / SNREF;
  Q0_ = line->getQ0() / SNREF;

  // R, X, G, B in SI units in IIDM
  double coeff = vNom * vNom / SNREF;
  double ad = 1. / sqrt(r * r + x * x);
  double ap = atan2(r, x);

  admittance_ = ad * coeff;
  lossAngle_ = ap;
  suscept1_ = b * coeff;
  conduct1_ = g * coeff;
  suscept2_ = 0.;
  conduct2_ = 0.;

  if (line->getInitialConnected())
    connectionState_ = CLOSED;
  else
    connectionState_ = OPEN;

  currentLimitsDesactivate_ = 0.;


  double factorPuToA = sqrt(3.) * vNom / (1000. * SNREF);
  // current limits
  vector<shared_ptr<CurrentLimitInterface> > cLimit = line->getCurrentLimitInterfaces();
  if (cLimit.size() > 0) {
    currentLimits_.reset(new ModelCurrentLimits());
    currentLimits_->setSide(ModelCurrentLimits::SIDE_UNDEFINED);
    currentLimits_->setFactorPuToA(factorPuToA);
    // Due to IIDM convention
    if (cLimit[0]->getLimit() < maximumValueCurrentLimit) {
      double limit = cLimit[0]->getLimit() / factorPuToA;
      currentLimits_->addLimit(limit, cLimit[0]->getAcceptableDuration());
    }
    for (unsigned int i = 1; i < cLimit.size(); ++i) {
      if (cLimit[i-1]->getLimit() < maximumValueCurrentLimit) {
        double limit = cLimit[i-1]->getLimit() / factorPuToA;
        currentLimits_->addLimit(limit, cLimit[i]->getAcceptableDuration());
      }
    }
  }


  // calculate voltage at the fictitious node
  // node attributes
  double uNode = line->getBusInterface()->getV0();
  double thetaNode = line->getBusInterface()->getAngle0();
  double unomNode = line->getBusInterface()->getVNom();
  double ur0 = uNode / unomNode * cos(thetaNode * DEG_TO_RAD);
  double ui0 = uNode / unomNode * sin(thetaNode * DEG_TO_RAD);
  ir0_ = (P * ur0 + Q * ui0) / (ur0 * ur0 + ui0 * ui0);
  ii0_ = (P * ui0 - Q * ur0) / (ur0 * ur0 + ui0 * ui0);

  double rpu = r / coeff;
  double xpu = x / coeff;
  double gpu = g * coeff;
  double bpu = b * coeff;

  double iLine_r = ir0_ - (gpu * ur0 - bpu * ui0);
  double iLine_i = ii0_ - (gpu * ui0 + bpu * ur0);

  urFict0_ = ur0 - (rpu * iLine_r - xpu * iLine_i);
  uiFict0_ = ui0 - (xpu * iLine_r + rpu * iLine_i);
  ir1_dUiFict_ = 0.;
  ir1_dUrFict_ = 0.;
  ir2_dUiFict_ = 0.;
  ir2_dUrFict_ = 0.;
  ii1_dUi_ = 0.;
  ii1_dUr_ = 0.;
  ii2_dUr_ = 0.;
  ir1_dUi_ = 0.;
  ir1_dUr_ = 0.;
  ir2_dUi_ = 0.;
  ir2_dUr_ = 0.;
  ii2_dUi_ = 0.;
  ii1_dUiFict_ = 0.;
  ii1_dUrFict_ = 0.;
  ii2_dUiFict_ = 0.;
  ii2_dUrFict_ = 0.;
  urFictYNum_ = 0;
  uiFictYNum_ = 0;
  P_ = 0.;
  Q_ = 0.;
}

void
ModelDanglingLine::init(int& yNum) {
  if (!network_->isInitModel()) {
    urFictYNum_ = yNum;
    ++yNum;
    uiFictYNum_ = yNum;
    ++yNum;
  }
}

void
ModelDanglingLine::initSize() {
  if (network_->isInitModel()) {
    sizeF_ = 0;
    sizeY_ = 0;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = 0;
  } else {
    sizeF_ = 2;  // fictitious node
    sizeY_ = 2;  // voltage of fictitious node
    sizeZ_ = 2;  // connectionState
    sizeG_ = 0;
    sizeMode_ = 2;
    sizeCalculatedVar_ = nbCalculatedVariables_;

    if (currentLimits_) {
      sizeZ_ += currentLimits_->sizeZ();
      sizeG_ += currentLimits_->sizeG();
    }
  }
}

void
ModelDanglingLine::evalYMat() {
  ir1_dUr_ = ir1_dUr();
  ir1_dUi_ = ir1_dUi();
  ii1_dUr_ = ii1_dUr();
  ii1_dUi_ = ii1_dUi();
  ir1_dUrFict_ = ir1_dUrFict();
  ir1_dUiFict_ = ir1_dUiFict();
  ii1_dUrFict_ = ii1_dUrFict();
  ii1_dUiFict_ = ii1_dUiFict();
  ir2_dUr_ = ir2_dUr();
  ir2_dUi_ = ir2_dUi();
  ii2_dUr_ = ii2_dUr();
  ii2_dUi_ = ii2_dUi();
  ir2_dUrFict_ = ir2_dUrFict();
  ir2_dUiFict_ = ir2_dUiFict();
  ii2_dUrFict_ = ii2_dUrFict();
  ii2_dUiFict_ = ii2_dUiFict();
}

void
ModelDanglingLine::evalStaticYType() {
  yType_[0] = ALGEBRAIC;  // ur fictitious node
  yType_[1] = ALGEBRAIC;  // ui fictitious node
}

void
ModelDanglingLine::evalStaticFType() {
  fType_[0] = ALGEBRAIC_EQ;  // sum of ir in fictitious node
  fType_[1] = ALGEBRAIC_EQ;  // sum of ii in fictitious node
}

void
ModelDanglingLine::evalF(propertyF_t type) {
  if (network_->isInitModel())
    return;
  if (type ==DIFFERENTIAL_EQ)
    return;

  double ur1 = modelBus_->ur();
  double ui1 = modelBus_->ui();
  double ur2 = ur_Fict();
  double ui2 = ui_Fict();
  double irLine = ir2(ur1, ui1, ur2, ui2);
  double iiLine = ii2(ur1, ui1, ur2, ui2);
  double irLoad = ir_Load(ur2, ui2);
  double iiLoad = ii_Load(ur2, ui2);

  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    f_[0] = irLine + irLoad;
    f_[1] = iiLine + iiLoad;
  } else {
    f_[0] = y_[urFictNum_];
    f_[1] = y_[uiFictNum_];
  }
}

void
ModelDanglingLine::setFequations(std::map<int, std::string>& fEquationIndex) {
  if (network_->isInitModel())
    return;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    fEquationIndex[0] = std::string("irLine + irLoad localModel:").append(id());
    fEquationIndex[1] = std::string("iiLine + iiLoad localModel:").append(id());
  } else {
    fEquationIndex[0] = std::string("y_[urFictNum_] localModel:").append(id());
    fEquationIndex[1] = std::string("y_[uiFictNum_] localModel:").append(id());
  }

  assert(fEquationIndex.size() == static_cast<size_t>(sizeF_) && "ModelDanglingLine: fEquationIndex.size() != f_.size()");
}

void
ModelDanglingLine::evalG(const double& t) {
  if (currentLimits_) {
    int offset = 0;
    currentLimits_->evalG(t, i1(), &(g_[offset]), currentLimitsDesactivate_);
  }
}

void
ModelDanglingLine::setGequations(std::map<int, std::string>& gEquationIndex) {
  if (currentLimits_) {
    for (int i = 0; i < currentLimits_->sizeG(); ++i) {
      gEquationIndex[i] = "DanglingLine: currentLimits.";
    }
  }

  assert(gEquationIndex.size() == static_cast<size_t>(sizeG_) && "ModelDanglingLine: gEquationIndex.size() != sizeG_");
}

double
ModelDanglingLine::i1() const {
  double ur1 = modelBus_->ur();
  double ui1 = modelBus_->ui();
  double ur2 = ur_Fict();
  double ui2 = ui_Fict();
  double irBus1 = ir1(ur1, ui1, ur2, ui2);
  double iiBus1 = ii1(ur1, ui1, ur2, ui2);
  return sqrt(irBus1 * irBus1 + iiBus1 * iiBus1);
}

double
ModelDanglingLine::ir_Load(const double& ur, const double& ui) const {
  double u2 = ur * ur + ui * ui;
  double ir = (P0_ * ur + Q0_ * ui) / u2;
  return ir;
}

double
ModelDanglingLine::ii_Load(const double& ur, const double& ui) const {
  double u2 = ur * ur + ui * ui;
  double ii = (P0_ * ui - Q0_ * ur) / u2;
  return ii;
}

double
ModelDanglingLine::ir1(const double& ur, const double& ui, const double& urFict, const double& uiFict) const {
  double ir1 = ir1_dUr_ * ur + ir1_dUi_ * ui + ir1_dUrFict_ * urFict + ir1_dUiFict_ * uiFict;

  return ir1;
}

double
ModelDanglingLine::ii1(const double& ur, const double& ui, const double& urFict, const double& uiFict) const {
  double ii1 = ii1_dUr_ * ur + ii1_dUi_ * ui + ii1_dUrFict_ * urFict + ii1_dUiFict_ * uiFict;

  return ii1;
}

double
ModelDanglingLine::ir2(const double& ur, const double& ui, const double& urFict, const double& uiFict) const {
  double ir2 = ir2_dUr_ * ur + ir2_dUi_ * ui + ir2_dUrFict_ * urFict + ir2_dUiFict_ * uiFict;

  return ir2;
}

double
ModelDanglingLine::ii2(const double& ur, const double& ui, const double& urFict, const double& uiFict) const {
  double ii2 = ii2_dUr_ * ur + ii2_dUi_ * ui + ii2_dUrFict_ * urFict + ii2_dUiFict_ * uiFict;

  return ii2;
}

double
ModelDanglingLine::ir1_dUr() const {
  double ir1_dUr = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ir1_dUr = G1;
  }

  return ir1_dUr;
}

double
ModelDanglingLine::ir1_dUi() const {
  double ir1_dUi = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ir1_dUi = -B1;
  }
  return ir1_dUi;
}

double
ModelDanglingLine::ii1_dUr() const {
  double ii1_dUr = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ii1_dUr = B1;
  }
  return ii1_dUr;
}

double
ModelDanglingLine::ii1_dUi() const {
  double ii1_dUi = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ii1_dUi = G1;
  }
  return ii1_dUi;
}

double
ModelDanglingLine::ir2_dUr() const {
  double ir2_dUr = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ir2_dUr = -admittance_ * sin(lossAngle_);
  }
  return ir2_dUr;
}

double
ModelDanglingLine::ir2_dUi() const {
  double ir2_dUi = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ir2_dUi = -admittance_ * cos(lossAngle_);
  }
  return ir2_dUi;
}

double
ModelDanglingLine::ii2_dUr() const {
  double ii2_dUr = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ii2_dUr = admittance_ * cos(lossAngle_);
  }
  return ii2_dUr;
}

double
ModelDanglingLine::ii2_dUi() const {
  double ii2_dUi = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ii2_dUi = -admittance_ * sin(lossAngle_);
  }
  return ii2_dUi;
}

double
ModelDanglingLine::ir1_dUrFict() const {
  double ir1_dUrFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ir1_dUrFict = -admittance_ * sin(lossAngle_);
  }
  return ir1_dUrFict;
}

double
ModelDanglingLine::ir1_dUiFict() const {
  double ir1_dUiFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ir1_dUiFict = -admittance_ * cos(lossAngle_);
  }
  return ir1_dUiFict;
}

double
ModelDanglingLine::ii1_dUrFict() const {
  double ii1_dUrFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ii1_dUrFict = admittance_ * cos(lossAngle_);
  }
  return ii1_dUrFict;
}

double
ModelDanglingLine::ii1_dUiFict() const {
  double ii1_dUiFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    ii1_dUiFict = -admittance_ * sin(lossAngle_);
  }
  return ii1_dUiFict;
}

double
ModelDanglingLine::ir2_dUrFict() const {
  double ir2_dUrFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ir2_dUrFict = G2;
  }
  return ir2_dUrFict;
}

double
ModelDanglingLine::ir2_dUiFict() const {
  double ir2_dUiFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ir2_dUiFict = -B2;
  }
  return ir2_dUiFict;
}

double
ModelDanglingLine::ii2_dUrFict() const {
  double ii2_dUrFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ii2_dUrFict = B2;
  }
  return ii2_dUrFict;
}

double
ModelDanglingLine::ii2_dUiFict() const {
  double ii2_dUiFict = 0.;
  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ii2_dUiFict = G2;
  }
  return ii2_dUiFict;
}

double
ModelDanglingLine::irLoad_dUr(const double& ur, const double& ui) const {
  double ir_dUr = 0.;
  double U2 = ur * ur + ui * ui;
  if (!doubleIsZero(U2))
    ir_dUr = (P0_ - 2 * ur * (P0_ * ur + Q0_ * ui) / U2) / U2;

  return ir_dUr;
}

double
ModelDanglingLine::irLoad_dUi(const double& ur, const double& ui) const {
  double ir_dUi = 0.;
  double U2 = ur * ur + ui*ui;
  if (!doubleIsZero(U2))
    ir_dUi = (Q0_ - 2 * ui * (P0_ * ur + Q0_ * ui) / U2) / U2;

  return ir_dUi;
}

double
ModelDanglingLine::iiLoad_dUr(const double& ur, const double& ui) const {
  double ii_dUr = 0.;
  double U2 = ur * ur + ui*ui;
  if (!doubleIsZero(U2))
    ii_dUr = (-Q0_ - 2. * ur * (P0_ * ui - Q0_ * ur) / U2) / U2;

  return ii_dUr;
}

double
ModelDanglingLine::iiLoad_dUi(const double& ur, const double& ui) const {
  double ii_dUi = 0;
  double U2 = ur * ur + ui*ui;
  if (!doubleIsZero(U2))
    ii_dUi = (P0_ - 2 * ui * (P0_ * ui - Q0_ * ur) / U2) / U2;

  return ii_dUi;
}

void
ModelDanglingLine::evalNodeInjection() {
  if (network_->isInitModel()) {
    modelBus_->irAdd(ir0_);
    modelBus_->iiAdd(ii0_);
  } else {
    double ur1 = modelBus_->ur();
    double ui1 = modelBus_->ui();
    double urFict = ur_Fict();
    double uiFict = ui_Fict();
    double irAdd = ir1(ur1, ui1, urFict, uiFict);
    double iiAdd = ii1(ur1, ui1, urFict, uiFict);

    modelBus_->irAdd(irAdd);
    modelBus_->iiAdd(iiAdd);
  }
}

void
ModelDanglingLine::evalDerivatives(const double /*cj*/) {
  if (network_->isInitModel())
    return;  ///< current injection constant for the init model
  int ur1YNum = modelBus_->urYNum();
  int ui1YNum = modelBus_->uiYNum();
  int ur2YNum = urFictYNum_;
  int ui2YNum = uiFictYNum_;

  // jacobian for sum current for node
  if (connectionState_ == CLOSED) {
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, ur1YNum, ir1_dUr_);
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, ui1YNum, ir1_dUi_);
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, ur1YNum, ii1_dUr_);
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, ui1YNum, ii1_dUi_);
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, ur2YNum, ir1_dUrFict_);
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, ui2YNum, ir1_dUiFict_);
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, ur2YNum, ii1_dUrFict_);
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, ui2YNum, ii1_dUiFict_);
  }
}

void
ModelDanglingLine::evalJtPrim(SparseMatrix& jt, const int& /*rowOffset*/) {
  // no differential variables in equations
  jt.changeCol();
  jt.changeCol();
}

void
ModelDanglingLine::evalJt(SparseMatrix& jt, const double& /*cj*/, const int& rowOffset) {
  if (network_->isInitModel())
    return;

  double ur = ur_Fict();
  double ui = ui_Fict();
  double irLoad_dUrFict = irLoad_dUr(ur, ui);
  double irLoad_dUiFict = irLoad_dUi(ur, ui);
  double iiLoad_dUrFict = iiLoad_dUr(ur, ui);
  double iiLoad_dUiFict = iiLoad_dUi(ur, ui);

  int ur1YNum = modelBus_->urYNum();
  int ui1YNum = modelBus_->uiYNum();

  if (connectionState_ == CLOSED && !modelBus_->getSwitchOff()) {
    // column for equations SUM(IR) = 0 fictitious node
    jt.changeCol();

    // @f[0]/@ur @f[0]/@ui @f[0]/@urFict @f[0]/@uiFict
    jt.addTerm(ur1YNum + rowOffset, ir2_dUr_);
    jt.addTerm(ui1YNum + rowOffset, ir2_dUi_);
    jt.addTerm(urFictYNum_ + rowOffset, ir2_dUrFict_ + irLoad_dUrFict);
    jt.addTerm(uiFictYNum_ + rowOffset, ir2_dUiFict_ + irLoad_dUiFict);

    // column for equations SUM(II) = 0 fictitious node
    jt.changeCol();

    // @f[1]/@ur @f[1]/@ui @f[1]/@urFict @f[1]/@uiFict
    jt.addTerm(ur1YNum + rowOffset, ii2_dUr_);
    jt.addTerm(ui1YNum + rowOffset, ii2_dUi_);
    jt.addTerm(urFictYNum_ + rowOffset, ii2_dUrFict_ + iiLoad_dUrFict);
    jt.addTerm(uiFictYNum_ + rowOffset, ii2_dUiFict_ + iiLoad_dUiFict);
  } else {
    jt.changeCol();
    jt.addTerm(urFictYNum_ + rowOffset, 1.0);

    jt.changeCol();
    jt.addTerm(uiFictYNum_ + rowOffset, 1.0);
  }
}

double
ModelDanglingLine::ur_Fict() const {
  if (network_->isInit()) {
    if (!modelBus_->getSwitchOff())
      return urFict0_;
    else
      return 0.;
  } else {
    return y_[urFictNum_];
  }
}

double
ModelDanglingLine::ui_Fict() const {
  if (network_->isInit()) {
    if (!modelBus_->getSwitchOff())
      return uiFict0_;
    else
      return 0.;
  } else {
    return y_[uiFictNum_];
  }
}

void
ModelDanglingLine::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_i_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_bus_vr", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_bus_vi", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_desactivate_currentLimits_value", BOOLEAN));
}

void
ModelDanglingLine::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_i_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_bus_vr", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_bus_vi", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_desactivate_currentLimits_value", BOOLEAN));
}

void
ModelDanglingLine::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  string lineName = id_;
  // ===== OUTPUT_I =====
  addElementWithValue(lineName + string("_i"), modelType_, elements, mapElement);

  // ===== OUTPUT_P =====
  addElementWithValue(lineName + string("_P"), modelType_, elements, mapElement);

  // ===== OUTPUT_Q =====
  addElementWithValue(lineName + string("_Q"), modelType_, elements, mapElement);

  // ========  CONNECTION STATE ======
  addElementWithValue(lineName + string("_state"), modelType_, elements, mapElement);

  // ========= Desactivate_current_limit
  addElementWithValue(lineName + string("_desactivate_currentLimits"), modelType_, elements, mapElement);
}

NetworkComponent::StateChange_t
ModelDanglingLine::evalZ(const double& t) {
  if (currentLimits_) {
    ModelCurrentLimits::state_t currentLimitState;
    currentLimitState = currentLimits_->evalZ(id(), t, &(g_[0]), network_, currentLimitsDesactivate_, modelType_);
    if (currentLimitState == ModelCurrentLimits::COMPONENT_OPEN)
      z_[0] = OPEN;
  }

  State currState = static_cast<State>(static_cast<int>(z_[0]));
  if (currState != connectionState_) {
    Trace::info() << DYNLog(DanglingLineStateChange, id_, connectionState_, currState) << Trace::endline;
    stateModified_ = true;
    if (currState == CLOSED) {
      DYNAddTimelineEvent(network_, id_, DanglingLineConnected);
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    } else if (currState == OPEN) {
      DYNAddTimelineEvent(network_, id_, DanglingLineDisconnected);
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    }
    connectionState_ = static_cast<State>(static_cast<int>(z_[0]));
  }

  if (doubleNotEquals(z_[1], getCurrentLimitsDesactivate())) {
    setCurrentLimitsDesactivate(z_[1]);
    Trace::debug() << DYNLog(DeactivateCurrentLimits, id_) << Trace::endline;
  }
  return stateModified_?NetworkComponent::STATE_CHANGE:NetworkComponent::NO_CHANGE;
}

void
ModelDanglingLine::collectSilentZ(BitMask* silentZTable) {
  silentZTable[0].setFlags(NotUsedInDiscreteEquations);
  silentZTable[1].setFlags(NotUsedInDiscreteEquations);
}

void
ModelDanglingLine::evalCalculatedVars() {
  double ur1 = modelBus_->ur();
  double ui1 = modelBus_->ui();
  double urFict = ur_Fict();
  double uiFict = ui_Fict();
  double irBus = ir1(ur1, ui1, urFict, uiFict);
  double iiBus = ii1(ur1, ui1, urFict, uiFict);

  calculatedVars_[iNum_] = sqrt(irBus * irBus + iiBus * iiBus);
  calculatedVars_[pNum_] = ur1 * irBus + ui1*iiBus;
  calculatedVars_[qNum_] = ui1 * irBus - ur1*iiBus;
}

void
ModelDanglingLine::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int> & numVars) const {
  switch (numCalculatedVar) {
    case iNum_:
    case pNum_:
    case qNum_:
      numVars.push_back(modelBus_->urYNum());
      numVars.push_back(modelBus_->uiYNum());
      numVars.push_back(urFictYNum_);
      numVars.push_back(uiFictYNum_);
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelDanglingLine::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  double ur1 = modelBus_->ur();
  double ui1 = modelBus_->ui();
  double ur2 = y_[urFictNum_];
  double ui2 = y_[uiFictNum_];

  double Ir1 = ir1(ur1, ui1, ur2, ui2);
  double Ii1 = ii1(ur1, ui1, ur2, ui2);
  switch (numCalculatedVar) {
    case iNum_: {
      double I = sqrt(Ii1 * Ii1 + Ir1 * Ir1);
      if (getConnectionState() == CLOSED && !doubleIsZero(I)) {
        res[0] = (ii1_dUr_ * Ii1 + ir1_dUr_ * Ir1) / I;   // dI1/dUr1
        res[1] = (ii1_dUi_ * Ii1 + ir1_dUi_ * Ir1) / I;   // dI1/dUi1
        res[2] = (ii1_dUrFict_ * Ii1 + ir1_dUrFict_ * Ir1) / I;   // dI1/dUrFict
        res[3] = (ii1_dUiFict_ * Ii1 + ir1_dUiFict_ * Ir1) / I;   // dI1/dUiFict
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case pNum_: {
      if (getConnectionState() == CLOSED) {
        res[0] = Ir1 + ur1 * ir1_dUr_ + ui1 * ii1_dUr_;   // dP/dUr1
        res[1] = ur1 * ir1_dUi_ + Ii1 + ui1 * ii1_dUi_;   // dP/dUi1
        res[2] = ur1 * ir1_dUrFict_ + ui1 * ii1_dUrFict_;   // dP/dUrFict
        res[3] = ur1 * ir1_dUiFict_ + ui1 * ii1_dUiFict_;   // dP/dUiFict
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case qNum_: {
      if (getConnectionState() == CLOSED) {
        res[0] = ui1 * ir1_dUr_ - Ii1 - ur1 * ii1_dUr_;   // dQ/dUr1
        res[1] = Ir1 + ui1 * ir1_dUi_ - ur1 * ii1_dUi_;   // dQ/dUi1
        res[2] = ui1 * ir1_dUrFict_ - ur1 * ii1_dUrFict_;   // dQ/dUrFict
        res[3] = ui1 * ir1_dUiFict_ - ur1 * ii1_dUiFict_;   // dQ/dUiFict
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelDanglingLine::evalCalculatedVarI(unsigned numCalculatedVar) const {
  double output;
  double ur1 = modelBus_->ur();
  double ui1 = modelBus_->ui();
  double ur2 = y_[urFictNum_];
  double ui2 = y_[uiFictNum_];
  double Ir1 = ir1(ur1, ui1, ur2, ui2);
  double Ii1 = ii1(ur1, ui1, ur2, ui2);
  switch (numCalculatedVar) {
    case iNum_:
      output = sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case pNum_:
      output = ur1 * Ir1 + ui1 * Ii1;
      break;
    case qNum_:
      output = ui1 * Ir1 - ur1 * Ii1;
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return output;
}

void
ModelDanglingLine::getY0() {
  if (network_->isInitModel())
    return;

  if (!modelBus_->getSwitchOff()) {
    y_[0] = urFict0_;
    y_[1] = uiFict0_;
  } else {
    y_[0] = 0;
    y_[1] = 0;
  }

  z_[0] = static_cast<double> (connectionState_);
}

NetworkComponent::StateChange_t
ModelDanglingLine::evalState(const double& /*time*/) {
  StateChange_t state = NetworkComponent::NO_CHANGE;
  if (stateModified_) {
    stateModified_ = false;
    state = NetworkComponent::STATE_CHANGE;
  }
  return state;
}

void
ModelDanglingLine::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params) {
  bool success = false;
  double maxTimeOperation = getParameterDynamicNoThrow<double>(params, "dangling_line_currentLimit_maxTimeOperation", success);
  if (success && currentLimits_)
    currentLimits_->setMaxTimeOperation(maxTimeOperation);
}

void
ModelDanglingLine::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("dangling_line_currentLimit_maxTimeOperation", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelDanglingLine::defineNonGenericParameters(vector<ParameterModeler>& /*parameters*/) {
  // not needed
}

}  // namespace DYN
