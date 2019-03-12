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

#include "DYNModelStaticVarCompensator.h"

#include "DYNModelBus.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNTimer.h"
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

ModelStaticVarCompensator::ModelStaticVarCompensator(const shared_ptr<StaticVarCompensatorInterface>& svc) :
Impl(svc->getID()),
Statism_(0.01),
kG_(4),
kP_(1),
Ti_(0.005) {
  // init data
  vNom_ = svc->getVNom();
  vSetPoint_ = svc->getVSetPoint();
  double coeff = vNom_ * vNom_ / SNREF;
  bMin_ = svc->getBMin() * coeff;
  bMax_ = svc->getBMax() * coeff;
  connectionState_ = svc->getInitialConnected() ? CLOSED : OPEN;
  mode_ = svc->getRegulationMode();
  isRunning_ = (mode_ == StaticVarCompensatorInterface::RUNNING_V);
  isStandBy_ = false;
  bShunt_ = 0;

  if (svc->hasStandbyAutomaton()) {
    uMinActivation_ = svc->getUMinActivation();
    uMaxActivation_ = svc->getUMaxActivation();
    uSetPointMin_ = svc->getUSetPointMin();
    uSetPointMax_ = svc->getUSetPointMax();
    hasStandByAutomaton_ = true;
    isStandBy_ = svc->isStandBy();
    bShunt_ = svc->getB0() * coeff;
    bMax_ = bMax_ + bShunt_;
    bMin_ = bMin_ + bShunt_;
  }

  // calculate initial conditions
  bSvc0_ = 0.;
  piIn0_ = 0.;
  piOut0_ = 0.;
  feedBack0_ = 0.;
  feedBackPrim0_ = 0.;
  ir0_ = 0.;
  ii0_ = 0.;

  double bTotal0 = 0.;
  double ur0 = 0.;
  double ui0 = 0.;
  double U0 = 0.;
  double Q0 = svc->getQ() / SNREF;
  if (svc->getBusInterface()) {
    double uBus0 = svc->getBusInterface()->getV0();
    double tetaBus0 = svc->getBusInterface()->getAngle0();
    double unomBus = svc->getBusInterface()->getVNom();
    ur0 = uBus0 / unomBus * cos(tetaBus0 * DEG_TO_RAD);
    ui0 = uBus0 / unomBus * sin(tetaBus0 * DEG_TO_RAD);
    U0 = sqrt(ur0 * ur0 + ui0 * ui0);
    if (!doubleIsZero(U0)) {
      bTotal0 = -1. * Q0 / (U0 * U0);  // in order to have the same convention as a shunt : b < 0 when Q > 0 (network convention)
      ir0_ = Q0 * ui0 / (ur0 * ur0 + ui0 * ui0);
      ii0_ = - Q0 * ur0 / (ur0 * ur0 + ui0 * ui0);
    }

    bSvc0_ = bTotal0;
    piIn0_ = 0.;
    piOut0_ = bSvc0_;
    feedBack0_ = bSvc0_;
    feedBackPrim0_ = 0.;
    vSetPoint_ = - Statism_ * Q0 * vNom_ + U0 * vNom_;  /// adapt vSetPoint to the model
  }
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
    sizeF_ = 4;
    sizeY_ = 4;
    sizeZ_ = 3;  // mode, state and uSetPoint
    sizeG_ = 6;

    if (hasStandByAutomaton_)
      sizeG_ += 2;

    sizeMode_ = 1;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

void
ModelStaticVarCompensator::evalYType() {
  yType_[0] = ALGEBRIC;  // piIn
  yType_[1] = ALGEBRIC;  // piOut
  yType_[2] = ALGEBRIC;  // bSvc
  yType_[3] = DIFFERENTIAL;  // feedBack
}

void
ModelStaticVarCompensator::evalFType() {
  fType_[0] = ALGEBRIC_EQ;  // algebraic equations
  fType_[1] = ALGEBRIC_EQ;
  fType_[2] = ALGEBRIC_EQ;
  fType_[3] = DIFFERENTIAL_EQ;  // differential equations
}

void
ModelStaticVarCompensator::evalF() {
  if (network_->isInitModel())
    return;

  int index = 0;
  double ur = modelBus_->ur();
  double ui = modelBus_->ui();
  double vNetwork = sqrt(ur * ur + ui * ui) * vNom_;

  // equation 0 : 0 = piIn - KG * ((vSetPoint_ - vNetwork) / vNom_ + Statism_ * q / SNREF)
  // -------------------------------------------------------------------------------------
  if (isRunning_ && isConnected() && !modelBus_->getSwitchOff())
    f_[index] = piIn() - kG_ * ((vSetPoint_ - vNetwork) / vNom_ + Statism_ * Q() / SNREF);
  else
    f_[index] = piIn();
  index += 1;

  // equation 1 : 0 = piOut - KP * piIn - feedBack;
  // -----------------------------------------------
  f_[index] = piOut() - kP_ * piIn() - feedBack();
  index += 1;

  // equation 2 : 0 = bSvc - min( max(piOut,BMIN),BMAX));
  // -----------------------------------------------------
  double tmp;
  if (piOut() > bMax_)
    tmp = bMax_;
  else if (piOut() < bMin_)
    tmp = bMin_;
  else
    tmp = piOut();

  f_[index] = bSvc() - tmp;
  index += 1;

  // equation 3 : 0 = T * d(feedBack)/dt - K * bSvc + feedBack
  // ----------------------------------------------------------
  f_[index] = kP_ * Ti_ * feedBackPrim() - bSvc() + feedBack();
  index += 1;
}

void
ModelStaticVarCompensator::setFequations(map<int, string>& fEquationIndex) {
  if (network_->isInitModel())
    return;

  int index = 0;
  if (isRunning_ && isConnected() && !modelBus_->getSwitchOff())
    fEquationIndex[index] = string("piIn - KG * ((vSetPoint_ - vNetwork) / vNom_ + Statism * Q / SNREF localModel:").append(id());
  else
    fEquationIndex[index] = string("y_[piInYNum_] localModel:").append(id());
  ++index;
  fEquationIndex[index] = string("piOut - KP * piIn - feedBack localModel:").append(id());
  ++index;
  fEquationIndex[index] = string("bSvc - min( max(piOut,BMIN),BMAX)) localModel:").append(id());
  ++index;
  fEquationIndex[index] = string("KP * Ti * d(feedBack)/dt - bSvc + feedBack localModel:").append(id());
  ++index;

  assert(fEquationIndex.size() == (unsigned int) sizeF() && "ModelStaticVarCompensator:fEquationIndex.size() != f_.size()");
}

void
ModelStaticVarCompensator::init(int& yNum) {
  if (!network_->isInitModel()) {
    piInYNum_ = yNum;
    ++yNum;
    piOutYNum_ = yNum;
    ++yNum;
    bSvcYNum_ = yNum;
    ++yNum;
    feedBackYNum_ = yNum;
    ++yNum;
  }
}

double
ModelStaticVarCompensator::Q() const {
  double ur = modelBus_->ur();
  double ui = modelBus_->ui();
  return - bSvc() * (ur * ur + ui * ui) * SNREF;
}

double
ModelStaticVarCompensator::piIn() const {
  if (network_->isInit())
    return piIn0_;
  else
    return y_[piInNum_];
}

double
ModelStaticVarCompensator::piOut() const {
  if (network_->isInit())
    return piOut0_;
  else
    return y_[piOutNum_];
}

double
ModelStaticVarCompensator::bSvc() const {
  if (network_->isInit())
    return bSvc0_;
  else
    return y_[bSvcNum_];
}

double
ModelStaticVarCompensator::feedBack() const {
  if (network_->isInit())
    return feedBack0_;
  else
    return y_[feedBackNum_];
}

double
ModelStaticVarCompensator::feedBackPrim() const {
  if (network_->isInit())
    return feedBackPrim0_;
  else
    return yp_[feedBackNum_];
}

double
ModelStaticVarCompensator::ir(const double& ui) const {
  double ir = 0.;
  if (network_->isInitModel()) {
    ir = ir0_;
  } else {
    if ((isRunning_ || isStandBy_) && isConnected()) {
      ir = - bSvc() * ui;
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
    if ((isRunning_ || isStandBy_) && isConnected()) {
      ii = bSvc() * ur;
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
  if ((isRunning_ || isStandBy_) && isConnected()) {
    ir_dUi = - bSvc();
  }
  return ir_dUi;
}

double
ModelStaticVarCompensator::ir_dBSvc(const double& ui) const {
  double ir_dBSvc = 0.;
  if ((isRunning_ || isStandBy_) && isConnected()) {
    ir_dBSvc = - ui;
  }
  return ir_dBSvc;
}

double
ModelStaticVarCompensator::ii_dUr() const {
  double ii_dUr = 0.;
  if ((isRunning_ || isStandBy_) && isConnected()) {
    ii_dUr = bSvc();
  }
  return ii_dUr;
}

double
ModelStaticVarCompensator::ii_dUi() const {
  return 0.;
}

double
ModelStaticVarCompensator::ii_dBSvc(const double& ur) const {
  double ii_dBSvc = 0.;
  if ((isRunning_ || isStandBy_) && isConnected()) {
    ii_dBSvc = ur;
  }
  return ii_dBSvc;
}

void
ModelStaticVarCompensator::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) {
  if (network_->isInitModel())
    return;
  double ur = modelBus_->ur();
  double ui = modelBus_->ui();
  int urYNum = modelBus_->urYNum();
  int uiYNum = modelBus_->uiYNum();
  double U = sqrt(ur * ur + ui * ui);

  // colonne pour équations piIn
  jt.changeCol();

  if (isRunning_ && isConnected() && !modelBus_->getSwitchOff()) {
    // @f[0]/@piIn, @f[0]/@ur, @f[0]/@ui, @f[0]/@bSvc
    double Q_dUr = -2. * bSvc() * ur * SNREF;
    double Q_dUi = -2. * bSvc() * ui * SNREF;
    double termPiIn = 1.;
    double termUr = kG_ * ur * pow(U, -1) - kG_ * Statism_ * Q_dUr / SNREF;
    double termUi = kG_ * ui * pow(U, -1) - kG_ * Statism_ * Q_dUi / SNREF;
    double Q_bSvc = - U * U * SNREF;
    double termSvc = -kG_ * Statism_ * Q_bSvc /SNREF;

    jt.addTerm(piInYNum_ + rowOffset, termPiIn);
    jt.addTerm(urYNum + rowOffset, termUr);
    jt.addTerm(uiYNum + rowOffset, termUi);
    jt.addTerm(bSvcYNum_ + rowOffset, termSvc);
  } else {
    jt.addTerm(piInYNum_ + rowOffset, 1.0);
  }

  // colonne pour équations piOut
  jt.changeCol();

  // @f[1]/@piOut, @f[1]/@piIn, @f[1]/@feedBack, @f[1]/@ur, @f[1]/@ui
  jt.addTerm(piOutYNum_ + rowOffset, 1.);
  jt.addTerm(piInYNum_ + rowOffset, -kP_);
  jt.addTerm(feedBackYNum_ + rowOffset, -1.);

  // colonne pour équations bSvc
  jt.changeCol();

  // @f[2]/@bSvc, @f[2]/@piOut
  double termBSvc = 1.;
  double termPiOut = 0.;
  if (piOut() > bMax_)
    termPiOut = 0.;
  else if (piOut() < bMin_)
    termPiOut = 0.;
  else
    termPiOut = -1.;

  jt.addTerm(bSvcYNum_ + rowOffset, termBSvc);
  jt.addTerm(piOutYNum_ + rowOffset, termPiOut);

  // colonne pour équations feedBack
  jt.changeCol();

  // @f[3]/@feedBack, @f[3]/@bSvc
  jt.addTerm(feedBackYNum_ + rowOffset, 1. + cj * kP_ * Ti_);
  jt.addTerm(bSvcYNum_ + rowOffset, -1.);
}

void
ModelStaticVarCompensator::evalJtPrim(SparseMatrix& jt, const int& rowOffset) {
  jt.changeCol();
  jt.changeCol();
  jt.changeCol();

  jt.changeCol();
  // colonne pour équations feedBack
  double T = kP_ * Ti_;
  jt.addTerm(feedBackYNum_ + rowOffset, T);
}

void
ModelStaticVarCompensator::getY0() {
  if (!network_->isInitModel()) {
    y_[0] = piIn0_;
    y_[1] = piOut0_;
    y_[2] = bSvc0_;
    y_[3] = feedBack0_;
    yp_[3] = feedBackPrim0_;

    z_[0] = mode_;
    z_[1] = getConnected();
    z_[2] = vSetPoint_;
  }
}

void
ModelStaticVarCompensator::evalZ(const double& /*t*/) {
  z_[1] = getConnected();
  mode_ = (StaticVarCompensatorInterface::RegulationMode_t)z_[0];

  if (g_[0] == ROOT_UP && !isRunning_) {
    network_->addEvent(id_, DYNTimeline(SVarCRunning));
    isRunning_ = true;
  }

  if (g_[1] == ROOT_UP && isRunning_) {
    network_->addEvent(id_, DYNTimeline(SVarCOff));
    isRunning_ = false;
  }

  if (hasStandByAutomaton_) {
    if (g_[6] == ROOT_UP) {
      network_->addEvent(id_, DYNTimeline(SVarCUminreached));
      isRunning_ = true;
      vSetPoint_ = uSetPointMin_;
      z_[0] = StaticVarCompensatorInterface::RUNNING_V;
      z_[2] = uSetPointMin_;
    }

    if (g_[7] == ROOT_UP) {
      network_->addEvent(id_, DYNTimeline(SVarCUmaxreached));
      isRunning_ = true;
      vSetPoint_ = uSetPointMax_;
      z_[0] = StaticVarCompensatorInterface::RUNNING_V;
      z_[2] = uSetPointMax_;
    }
  }
}

void
ModelStaticVarCompensator::evalG(const double& /*t*/) {
  g_[0] = (doubleEquals(z_[0], 0.)) ? ROOT_UP : ROOT_DOWN;
  g_[1] = (doubleEquals(z_[0], 2.)) ? ROOT_UP : ROOT_DOWN;

  double b = piOut();
  g_[2] = (bMin_ - b > 0.) ? ROOT_UP : ROOT_DOWN;  // B < BMin
  g_[3] = (b - bMax_ > 0.) ? ROOT_UP : ROOT_DOWN;  // B > Bmax
  g_[4] = (b - bMin_ > 0.) ? ROOT_UP : ROOT_DOWN;  // B > BMin
  g_[5] = (bMax_ - b > 0.) ? ROOT_UP : ROOT_DOWN;  // B < Bmax

  if (hasStandByAutomaton_) {
    g_[6] = ((uMinActivation_ - modelBus_->getCurrentV() > 0.) && mode_ == StaticVarCompensatorInterface::STANDBY) ? ROOT_UP : ROOT_DOWN;
    g_[7] = ((uMaxActivation_ - modelBus_->getCurrentV() < 0.) && mode_ == StaticVarCompensatorInterface::STANDBY) ? ROOT_UP : ROOT_DOWN;
  }
}

void
ModelStaticVarCompensator::evalCalculatedVars() {
  // Q
  calculatedVars_[qNum_] = (isConnected())?-Q():0.;
}

void
ModelStaticVarCompensator::getDefJCalculatedVarI(int numCalculatedVar, vector<int>& numVars) {
  if (numCalculatedVar == qNum_ && isConnected()) {
    int urYNum = modelBus_->urYNum();
    int uiYNum = modelBus_->uiYNum();
    numVars.push_back(urYNum);
    numVars.push_back(uiYNum);
    numVars.push_back(bSvcYNum_);
  }
}


void
ModelStaticVarCompensator::evalJCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/, vector<double>& res) {
  if (numCalculatedVar == qNum_ && isConnected()) {
    double ur = y[0];
    double ui = y[1];
    double b = y[2];
    // QProduced = SNREF * b * (ur * ur + ui * ui * ui)
    res[0] = SNREF * b * 2. * ur;  // @Q/@Ur
    res[1] = SNREF * b * 2. * ui;  // @Q/@Ui
    res[2] = SNREF * (ur * ur + ui * ui);  // @Q/@BSvc
  }
}

double
ModelStaticVarCompensator::evalCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/) {
  if (numCalculatedVar == qNum_ && isConnected()) {
    double ur = y[0];
    double ui = y[1];
    double b = y[2];
    return SNREF * b * (ur * ur + ui * ui);
  }
  return 0.;
}

void
ModelStaticVarCompensator::setGequations(map<int, string>& gEquationIndex) {
  gEquationIndex[0] = "SVC is running";
  gEquationIndex[1] = "SVC is OFF";
  gEquationIndex[2] = "B < BMin";
  gEquationIndex[3] = "B > Bmax";
  gEquationIndex[4] = "B > BMin";
  gEquationIndex[5] = "B < Bmax";

  if (hasStandByAutomaton_) {
    gEquationIndex[6] = "U < Umin";
    gEquationIndex[7] = "U > Umax";
  }

  assert(gEquationIndex.size() == (unsigned int) sizeG() && "Model Static Var Compensator: gEquationIndex.size() != g_.size()");
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
ModelStaticVarCompensator::evalDerivatives() {
  if (network_->isInitModel())
    return;
  if (isConnected()) {
    int urYNum = modelBus_->urYNum();
    int uiYNum = modelBus_->uiYNum();
    double ur = modelBus_->ur();
    double ui = modelBus_->ui();
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr());
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii_dUr());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi());
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, bSvcYNum_, ir_dBSvc(ui));
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, bSvcYNum_, ii_dBSvc(ur));
  }
}

void
ModelStaticVarCompensator::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_piIn_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_piOut_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_bSvc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_feedBack_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_QProduced_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_mode_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_uSetPoint_value", DISCRETE));
}

void
ModelStaticVarCompensator::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_piIn_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_piOut_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_bSvc_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_feedBack_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_QProduced_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_mode_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_uSetPoint_value", DISCRETE));
}

void
ModelStaticVarCompensator::defineElements(vector<Element> &elements, map<string, int>& mapElement) {
  string svcName = id_;
  // ======= STATE VARIABLES ========
  string name = svcName + string("_piIn");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  name = svcName + string("_piOut");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  name = svcName + string("_bSvc");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  name = svcName + string("_feedBack");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  CALCULATED VARIABLE ======
  name = svcName + string("_QProduced");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  MODE ======
  name = svcName + string("_mode");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  CONNECTION STATE ======
  name = svcName + string("_state");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  U SET POINT ======
  name = svcName + string("_uSetPoint");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
}

NetworkComponent::StateChange_t
ModelStaticVarCompensator::evalState(const double& /*time*/) {
  if ((State) z_[1] != getConnected()) {
    Trace::debug() << DYNLog(SVCStateChange, id_, getConnected(), z_[1]) << Trace::endline;

    if ((State) z_[1] == OPEN) {
      network_->addEvent(id_, DYNTimeline(SVarCDisconnected));
      setConnected(OPEN);
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else {
      network_->addEvent(id_, DYNTimeline(SVarCConnected));
      setConnected(CLOSED);
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
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
ModelStaticVarCompensator::setSubModelParameters(const std::tr1::unordered_map<std::string, ParameterModeler>& /*params*/) {
  // no parameter
}
}  // namespace DYN

