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
 * @file  DYNModelLine.cpp
 *
 * @brief
 *
 */
#include <cmath>
#include <vector>
#include <cassert>
#include "PARParametersSet.h"

#include "DYNModelLine.h"

#include "DYNCommun.h"
#include "DYNModelConstants.h"
#include "DYNModelBus.h"
#include "DYNModelCurrentLimits.h"
#include "DYNCommonModeler.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNLineInterface.h"
#include "DYNCurrentLimitInterface.h"
#include "DYNBusInterface.h"
#include "DYNModelNetwork.h"
#include "DYNModelVoltageLevel.h"

using parameters::ParametersSet;

using std::vector;
using boost::shared_ptr;
using std::map;
using std::string;

namespace DYN {

ModelLine::ModelLine(const shared_ptr<LineInterface>& line) :
Impl(line->getID()),
ir1_dUr1_(0.),
ir1_dUi1_(0.),
ir1_dUr2_(0.),
ir1_dUi2_(0.),
ii1_dUr1_(0.),
ii1_dUi1_(0.),
ii1_dUr2_(0.),
ii1_dUi2_(0.),
ir2_dUr1_(0.),
ir2_dUi1_(0.),
ir2_dUr2_(0.),
ir2_dUi2_(0.),
ii2_dUr1_(0.),
ii2_dUi1_(0.),
ii2_dUr2_(0.),
ii2_dUi2_(0.) {
  double r = line->getR();
  double x = line->getX();
  double b1 = line->getB1();
  double b2 = line->getB2();
  double g1 = line->getG1();
  double g2 = line->getG2();
  bool connected1 = line->getInitialConnected1();
  bool connected2 = line->getInitialConnected2();

  double vNom = NAN;
  if (connected1 && connected2) {
    connectionState_ = CLOSED;
    vNom = line->getVNom1();
  } else if (connected1) {
    connectionState_ = CLOSED_1;
    vNom = line->getVNom1();
  } else if (connected2) {
    connectionState_ = CLOSED_2;
    vNom = line->getVNom2();
  } else {
    connectionState_ = OPEN;
    if (line->getBusInterface1()) {
      vNom = line->getVNom1();
    }
    if (line->getBusInterface2()) {
      vNom = line->getVNom2();
    }
    assert(vNom == vNom);  // control that vNom != NAN
  }

  if (line->getBusInterface1() && line->getBusInterface2())
    knownBus_ = BUS1_BUS2;
  else if (line->getBusInterface1())
    knownBus_ = BUS1;
  else
    knownBus_ = BUS2;

  // init data
  factorPuToA_ = 1000 * SNREF / (sqrt(3) * vNom);

  // R, X, G, B en valeur reelle dans IIDM
  double coeff = vNom * vNom / SNREF;
  double ad = 1. / sqrt(r * r + x * x);
  double ap = atan2(r, x);

  admittance_ = ad * coeff;
  lossAngle_ = ap;
  suscept1_ = b1 * coeff;
  suscept2_ = b2 * coeff;
  conduct1_ = g1 * coeff;
  conduct2_ = g2 * coeff;

  currentLimitsDesactivate_ = 0.;

  // current limits side 1
  vector<shared_ptr<CurrentLimitInterface> > cLimit1 = line->getCurrentLimitInterfaces1();
  if (cLimit1.size() > 0) {
    currentLimits1_.reset(new ModelCurrentLimits());
    currentLimits1_->setSide(ModelCurrentLimits::SIDE_1);
    currentLimits1_->setNbLimits(cLimit1.size());
    for (unsigned int i = 0; i < cLimit1.size(); ++i) {
      double limit = cLimit1[i]->getLimit() / factorPuToA_;
      currentLimits1_->addLimit(limit);
      currentLimits1_->addAcceptableDuration(cLimit1[i]->getAcceptableDuration());
    }
  }

  // current limits side 2
  vector<shared_ptr<CurrentLimitInterface> > cLimit2 = line->getCurrentLimitInterfaces2();
  if (cLimit2.size() > 0) {
    currentLimits2_.reset(new ModelCurrentLimits());
    currentLimits2_->setSide(ModelCurrentLimits::SIDE_2);
    currentLimits2_->setNbLimits(cLimit2.size());
    for (unsigned int i = 0; i < cLimit2.size(); ++i) {
      double limit = cLimit2[i]->getLimit() / factorPuToA_;
      currentLimits2_->addLimit(limit);
      currentLimits2_->addAcceptableDuration(cLimit2[i]->getAcceptableDuration());
    }
  }

  ir01_ = 0;
  ii01_ = 0;
  if (line->getBusInterface1()) {
    double P01 = line->getP1() / SNREF;
    double Q01 = line->getQ1() / SNREF;
    double uNode1 = line->getBusInterface1()->getV0();
    double tetaNode1 = line->getBusInterface1()->getAngle0();
    double unomNode1 = line->getBusInterface1()->getVNom();
    double ur01 = uNode1 / unomNode1 * cos(tetaNode1 * DEG_TO_RAD);
    double ui01 = uNode1 / unomNode1 * sin(tetaNode1 * DEG_TO_RAD);
    double U201 = ur01 * ur01 + ui01 * ui01;
    if (doubleNotEquals(U201, 0.)) {
      ir01_ = (P01 * ur01 + Q01 * ui01) / U201;
      ii01_ = (P01 * ui01 - Q01 * ur01) / U201;
    }
  }

  ir02_ = 0;
  ii02_ = 0;
  if (line->getBusInterface2()) {
    double P02 = line->getP2() / SNREF;
    double Q02 = line->getQ2() / SNREF;
    double uNode2 = line->getBusInterface2()->getV0();
    double tetaNode2 = line->getBusInterface2()->getAngle0();
    double unomNode2 = line->getBusInterface2()->getVNom();
    double ur02 = uNode2 / unomNode2 * cos(tetaNode2 * DEG_TO_RAD);
    double ui02 = uNode2 / unomNode2 * sin(tetaNode2 * DEG_TO_RAD);
    double U202 = ur02 * ur02 + ui02 * ui02;
    if (doubleNotEquals(U202, 0.)) {
      ir02_ = (P02 * ur02 + Q02 * ui02) / U202;
      ii02_ = (P02 * ui02 - Q02 * ur02) / U202;
    }
  }
}

void
ModelLine::initSize() {
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
    sizeZ_ = 2;
    sizeG_ = 0;
    sizeMode_ = 2;
    sizeCalculatedVar_ = nbCalculatedVariables_;

    if (currentLimits1_) {
      sizeZ_ += currentLimits1_->sizeZ();
      sizeG_ += currentLimits1_->sizeG();
    }

    if (currentLimits2_) {
      sizeZ_ += currentLimits2_->sizeZ();
      sizeG_ += currentLimits2_->sizeG();
    }
  }
}

void
ModelLine::init(int& /*yNum*/) {
  /* not needed */
}

void
ModelLine::evalYMat() {
  ir1_dUr1_ = ir1_dUr1();
  ir1_dUi1_ = ir1_dUi1();
  ir1_dUr2_ = ir1_dUr2();
  ir1_dUi2_ = ir1_dUi2();
  ii1_dUr1_ = ii1_dUr1();
  ii1_dUi1_ = ii1_dUi1();
  ii1_dUr2_ = ii1_dUr2();
  ii1_dUi2_ = ii1_dUi2();
  ir2_dUr1_ = ir2_dUr1();
  ir2_dUi1_ = ir2_dUi1();
  ir2_dUr2_ = ir2_dUr2();
  ir2_dUi2_ = ir2_dUi2();
  ii2_dUr1_ = ii2_dUr1();
  ii2_dUi1_ = ii2_dUi1();
  ii2_dUr2_ = ii2_dUr2();
  ii2_dUi2_ = ii2_dUi2();
}

double
ModelLine::ir1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ir1_dUr1_ * ur1 + ir1_dUi1_ * ui1 + ir1_dUr2_ * ur2 + ir1_dUi2_ * ui2;
}

double
ModelLine::ii1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ii1_dUr1_ * ur1 + ii1_dUi1_ * ui1 + ii1_dUr2_ * ur2 + ii1_dUi2_ * ui2;
}

double
ModelLine::ir2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ir2_dUr1_ * ur1 + ir2_dUi1_ * ui1 + ir2_dUr2_ * ur2 + ir2_dUi2_ * ui2;
}

double
ModelLine::ii2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ii2_dUr1_ * ur1 + ii2_dUi1_ * ui1 + ii2_dUr2_ * ur2 + ii2_dUi2_ * ui2;
}

double
ModelLine::ir1_dUr1() const {
  double ir1_dUr1 = 0.;
  if (connectionState_ == CLOSED) {
    double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ir1_dUr1 = G1;
  } else if (connectionState_ == CLOSED_1) {
    double G = admittance_ * sin(lossAngle_) + conduct2_;
    double B = suscept2_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double GT = conduct1_ + 1. / denom * (admittance_ * admittance_ * conduct2_
      + admittance_ * sin(lossAngle_) * (conduct2_ * conduct2_ + suscept2_ * suscept2_));
    ir1_dUr1 = GT;
  }
  return ir1_dUr1;
}

double
ModelLine::ir1_dUi1() const {
  double ir1_dUi1 = 0.;
  if (connectionState_ == CLOSED) {
    double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ir1_dUi1 = -B1;
  } else if (connectionState_ == CLOSED_1) {
    double G = admittance_ * sin(lossAngle_) + conduct2_;
    double B = suscept2_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double BT = suscept1_ + 1. / denom * (admittance_ * admittance_ * suscept2_
      - admittance_ * cos(lossAngle_) * (conduct2_ * conduct2_ + suscept2_ * suscept2_));
    ir1_dUi1 = -BT;
  }
  return ir1_dUi1;
}

double
ModelLine::ir1_dUr2() const {
  double ir1_dUr2 = 0.;
  if (connectionState_ == CLOSED) {
    ir1_dUr2 = -admittance_ * sin(lossAngle_);
  }
  return ir1_dUr2;
}

double
ModelLine::ir1_dUi2() const {
  double ir1_dUi2 = 0.;
  if (connectionState_ == CLOSED) {
    ir1_dUi2 = -admittance_ * cos(lossAngle_);
  }
  return ir1_dUi2;
}

double
ModelLine::ii1_dUr1() const {
  double ii1_dUr1 = 0.;
  if (connectionState_ == CLOSED) {
    double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ii1_dUr1 = B1;
  } else if (connectionState_ == CLOSED_1) {
    double G = admittance_ * sin(lossAngle_) + conduct2_;
    double B = suscept2_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double BT = suscept1_ + 1. / denom * (admittance_ * admittance_ * suscept2_
      - admittance_ * cos(lossAngle_) * (conduct2_ * conduct2_ + suscept2_ * suscept2_));
    ii1_dUr1 = BT;
  }
  return ii1_dUr1;
}

double
ModelLine::ii1_dUi1() const {
  double ii1_dUi1 = 0.;
  if (connectionState_ == CLOSED) {
    double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ii1_dUi1 = G1;
  } else if (connectionState_ == CLOSED_1) {
    double G = admittance_ * sin(lossAngle_) + conduct2_;
    double B = suscept2_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double GT = conduct1_ + 1. / denom * (admittance_ * admittance_ * conduct2_
      + admittance_ * sin(lossAngle_) * (conduct2_ * conduct2_ + suscept2_ * suscept2_));
    ii1_dUi1 = GT;
  }
  return ii1_dUi1;
}

double
ModelLine::ii1_dUr2() const {
  double ii1_dUr2 = 0.;
  if (connectionState_ == CLOSED) {
    ii1_dUr2 = admittance_ * cos(lossAngle_);
  }
  return ii1_dUr2;
}

double
ModelLine::ii1_dUi2() const {
  double ii1_dUi2 = 0.;
  if (connectionState_ == CLOSED) {
    ii1_dUi2 = -admittance_ * sin(lossAngle_);
  }
  return ii1_dUi2;
}

double
ModelLine::ir2_dUr1() const {
  double ir2_dUr1 = 0.;
  if (connectionState_ == CLOSED) {
    ir2_dUr1 = -admittance_ * sin(lossAngle_);
  }
  return ir2_dUr1;
}

double
ModelLine::ir2_dUi1() const {
  double ir2_dUi1 = 0.;
  if (connectionState_ == CLOSED) {
    ir2_dUi1 = -admittance_ * cos(lossAngle_);
  }
  return ir2_dUi1;
}

double
ModelLine::ir2_dUr2() const {
  double ir2_dUr2 = 0.;
  if (connectionState_ == CLOSED) {
    double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ir2_dUr2 = G2;
  } else if (connectionState_ == CLOSED_2) {
    double G = admittance_ * sin(lossAngle_) + conduct1_;
    double B = suscept1_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double GT = conduct2_ + 1. / denom * (admittance_ * admittance_ * conduct1_
      + admittance_ * sin(lossAngle_) * (conduct1_ * conduct1_ + suscept1_ * suscept1_));
    ir2_dUr2 = GT;
  }
  return ir2_dUr2;
}

double
ModelLine::ir2_dUi2() const {
  double ir2_dUi2 = 0.;
  if (connectionState_ == CLOSED) {
    double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ir2_dUi2 = -B2;
  } else if (connectionState_ == CLOSED_2) {
    double G = admittance_ * sin(lossAngle_) + conduct1_;
    double B = suscept1_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double BT = suscept2_ + 1. / denom * (admittance_ * admittance_ * suscept1_
      - admittance_ * cos(lossAngle_) * (conduct1_ * conduct1_ + suscept1_ * suscept1_));
    ir2_dUi2 = -BT;
  }
  return ir2_dUi2;
}

double
ModelLine::ii2_dUr1() const {
  double ii2_dUr1 = 0.;
  if (connectionState_ == CLOSED) {
    ii2_dUr1 = admittance_ * cos(lossAngle_);
  }
  return ii2_dUr1;
}

double
ModelLine::ii2_dUi1() const {
  double ii2_dUi1 = 0.;
  if (connectionState_ == CLOSED) {
    ii2_dUi1 = -admittance_ * sin(lossAngle_);
  }
  return ii2_dUi1;
}

double
ModelLine::ii2_dUr2() const {
  double ii2_dUr2 = 0.;
  if (connectionState_ == CLOSED) {
    double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ii2_dUr2 = B2;
  } else if (connectionState_ == CLOSED_2) {
    double G = admittance_ * sin(lossAngle_) + conduct1_;
    double B = suscept1_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double BT = suscept2_ + 1. / denom * (admittance_ * admittance_ * suscept1_
      - admittance_ * cos(lossAngle_) * (conduct1_ * conduct1_ + suscept1_ * suscept1_));
    ii2_dUr2 = BT;
  }
  return ii2_dUr2;
}

double
ModelLine::ii2_dUi2() const {
  double ii2_dUi2 = 0.;
  if (connectionState_ == CLOSED) {
    double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ii2_dUi2 = G2;
  } else if (connectionState_ == CLOSED_2) {
    double G = admittance_ * sin(lossAngle_) + conduct1_;
    double B = suscept1_ - admittance_ * cos(lossAngle_);
    double denom = G * G + B * B;

    double GT = conduct2_ + 1. / denom * (admittance_ * admittance_ * conduct1_
      + admittance_ * sin(lossAngle_)*(conduct1_ * conduct1_ + suscept1_ * suscept1_));
    ii2_dUi2 = GT;
  }
  return ii2_dUi2;
}

void
ModelLine::evalNodeInjection() {
  if (network_->isInitModel()) {
    if (modelBus1_) {
      modelBus1_->irAdd(ir01_);
      modelBus1_->iiAdd(ii01_);
    }

    if (modelBus2_) {
      modelBus2_->irAdd(ir02_);
      modelBus2_->iiAdd(ii02_);
    }
  } else {
    if (modelBus1_) {
      double ur1Val = ur1();
      double ui1Val = ui1();
      double ur2Val = ur2();
      double ui2Val = ui2();
      double irAdd1 = ir1(ur1Val, ui1Val, ur2Val, ui2Val);
      double iiAdd1 = ii1(ur1Val, ui1Val, ur2Val, ui2Val);
      modelBus1_->irAdd(irAdd1);
      modelBus1_->iiAdd(iiAdd1);
    }

    if (modelBus2_) {
      double ur1Val = ur1();
      double ui1Val = ui1();
      double ur2Val = ur2();
      double ui2Val = ui2();
      double irAdd2 = ir2(ur1Val, ui1Val, ur2Val, ui2Val);
      double iiAdd2 = ii2(ur1Val, ui1Val, ur2Val, ui2Val);
      modelBus2_->irAdd(irAdd2);
      modelBus2_->iiAdd(iiAdd2);
    }
  }
}

void
ModelLine::evalJt(SparseMatrix& /*jt*/, const double& /*cj*/, const int& /*rowOffset*/) {
  /* not needed */
}

void
ModelLine::evalJtPrim(SparseMatrix& /*jt*/, const int& /*rowOffset*/) {
  /* not needed */
}

void
ModelLine::evalDerivatives() {
  switch (knownBus_) {
    case BUS1_BUS2: {
      int ur1YNum = modelBus1_->urYNum();
      int ui1YNum = modelBus1_->uiYNum();
      int ur2YNum = modelBus2_->urYNum();
      int ui2YNum = modelBus2_->uiYNum();
      modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ur1YNum, ir1_dUr1_);
      modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ui1YNum, ir1_dUi1_);
      modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ur1YNum, ii1_dUr1_);
      modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ui1YNum, ii1_dUi1_);
      modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ur2YNum, ir1_dUr2_);
      modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ui2YNum, ir1_dUi2_);
      modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ur2YNum, ii1_dUr2_);
      modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ui2YNum, ii1_dUi2_);

      modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ur2YNum, ir2_dUr2_);
      modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ui2YNum, ir2_dUi2_);
      modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ur2YNum, ii2_dUr2_);
      modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ui2YNum, ii2_dUi2_);
      modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ur1YNum, ir2_dUr1_);
      modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ui1YNum, ir2_dUi1_);
      modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ur1YNum, ii2_dUr1_);
      modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ui1YNum, ii2_dUi1_);
      break;
    }
    case BUS1: {
      int ur1YNum = modelBus1_->urYNum();
      int ui1YNum = modelBus1_->uiYNum();
      modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ur1YNum, ir1_dUr1_);
      modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ui1YNum, ir1_dUi1_);
      modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ur1YNum, ii1_dUr1_);
      modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ui1YNum, ii1_dUi1_);
      break;
    }
    case BUS2: {
      int ur2YNum = modelBus2_->urYNum();
      int ui2YNum = modelBus2_->uiYNum();
      modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ur2YNum, ir2_dUr2_);
      modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ui2YNum, ir2_dUi2_);
      modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ur2YNum, ii2_dUr2_);
      modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ui2YNum, ii2_dUi2_);
      break;
    }
  }
}

void
ModelLine::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_i1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_i2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_iS1ToS2Side1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_iS2ToS1Side1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_iS1ToS2Side2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_iS2ToS1Side2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_iSide1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_iSide2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_U1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_U2_value", CONTINUOUS));
  // state as continuous variable (need for external automaton as inputs of automaton are continuous)
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_lineState_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_desactivate_currentLimits_value", BOOLEAN));
}

void
ModelLine::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_i1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_i2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_iS1ToS2Side1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_iS2ToS1Side1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_iS1ToS2Side2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_iS2ToS1Side2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_iSide1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_iSide2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_U1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_U2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_lineState_value", CONTINUOUS));  // state as continuous variable
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_desactivate_currentLimits_value", BOOLEAN));
}

void
ModelLine::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  string lineName = id_;
  // ===== I1 =====
  string name = lineName + string("_i1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== I2 =====
  name = lineName + string("_i2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== P1 =====
  name = lineName + string("_P1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== P2 =====
  name = lineName + string("_P2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== Q1 =====
  name = lineName + string("_Q1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== Q2 =====
  name = lineName + string("_Q2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== IS1_To_S2_Side1 =====
  name = lineName + string("_iS1ToS2Side1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== IS2_To_S1_Side1 =====
  name = lineName + string("_iS2ToS1Side1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== IS1_To_S2_Side2 =====
  name = lineName + string("_iS1ToS2Side2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== IS2_To_S1_Side2 =====
  name = lineName + string("_iS2ToS1Side2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== ISide1 =====
  name = lineName + string("_iSide1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== ISide2 =====
  name = lineName + string("_iSide2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== U1 =====
  name = lineName + string("_U1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ===== U2 =====
  name = lineName + string("_U2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  line STATE ======
  name = lineName + string("_lineState");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  CONNECTION STATE ======
  name = lineName + string("_state");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========= Desactivate_current_limit
  name = lineName + string("_desactivate_currentLimits");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
}

void
ModelLine::evalZ(const double& t) {
  z_[0] = connectionState_;
  z_[1] = currentLimitsDesactivate_;

  int offsetRoot = 0;
  ModelCurrentLimits::state_t currentLimitState;

  if (currentLimits1_) {
    currentLimitState = currentLimits1_->evalZ(id() + "_side1", t, &(g_[offsetRoot]), network_, currentLimitsDesactivate_);
    offsetRoot += currentLimits1_->sizeG();
    if (currentLimitState == ModelCurrentLimits::COMPONENT_OPEN)
      z_[0] = OPEN;
  }

  if (currentLimits2_) {
    currentLimitState = currentLimits2_->evalZ(id() + "_side2", t, &(g_[offsetRoot]), network_, currentLimitsDesactivate_);
    offsetRoot += currentLimits2_->sizeG();
    if (currentLimitState == ModelCurrentLimits::COMPONENT_OPEN)
      z_[0] = OPEN;
  }
}

void
ModelLine::evalG(const double& t) {
  int offset = 0;
  if (currentLimits1_) {
    double ur1Val = ur1();
    double ui1Val = ui1();
    double ur2Val = ur2();
    double ui2Val = ui2();
    currentLimits1_->evalG(id() + "_side1", t, i1(ur1Val, ui1Val, ur2Val, ui2Val), &(g_[offset]), currentLimitsDesactivate_);
    offset += currentLimits1_->sizeG();
  }

  if (currentLimits2_) {
    double ur1Val = ur1();
    double ui1Val = ui1();
    double ur2Val = ur2();
    double ui2Val = ui2();
    currentLimits2_->evalG(id() + "_side2", t, i2(ur1Val, ui1Val, ur2Val, ui2Val), &(g_[offset]), currentLimitsDesactivate_);
    offset += currentLimits2_->sizeG();
  }
}

void
ModelLine::setFequations(std::map<int, std::string>& /*fEquationIndex*/) {
  /* no F equation */
}

void
ModelLine::setGequations(std::map<int, std::string>& gEquationIndex) {
  int offset = 0;
  if (currentLimits1_) {
    for (int i = 0; i < currentLimits1_->sizeG(); ++i) {
      gEquationIndex[i] = "Model Line: current limit 1.";
    }
    offset += currentLimits1_->sizeG();
  }

  if (currentLimits2_) {
    for (int i = 0; i < currentLimits2_->sizeG(); ++i) {
      gEquationIndex[i + offset] = "Model Line: current limit 2.";
    }
    offset += currentLimits2_->sizeG();
  }

  assert(gEquationIndex.size() == (unsigned int) sizeG_ && "ModelLine: gEquationIndex.size() != sizeG_");
}

void
ModelLine::evalCalculatedVars() {
  double ur1Val = ur1();
  double ui1Val = ui1();
  double ur2Val = ur2();
  double ui2Val = ui2();
  double irBus1 = ir1(ur1Val, ui1Val, ur2Val, ui2Val);
  double iiBus1 = ii1(ur1Val, ui1Val, ur2Val, ui2Val);
  double irBus2 = ir2(ur1Val, ui1Val, ur2Val, ui2Val);
  double iiBus2 = ii2(ur1Val, ui1Val, ur2Val, ui2Val);
  double P1 = ur1Val * irBus1 + ui1Val * iiBus1;
  double P2 = ur2Val * irBus2 + ui2Val * iiBus2;
  int signP1 = sign(P1);
  int signP2 = sign(P2);

  calculatedVars_[i1Num_] = sqrt(irBus1 * irBus1 + iiBus1 * iiBus1);  // iorigine
  calculatedVars_[i2Num_] = sqrt(irBus2 * irBus2 + iiBus2 * iiBus2);  // iextremite
  calculatedVars_[p1Num_] = P1;  // Porigine
  calculatedVars_[p2Num_] = P2;  // Pextremite
  calculatedVars_[q1Num_] = irBus1 * ui1Val - iiBus1 * ur1Val;  // Qorigine
  calculatedVars_[q2Num_] = irBus2 * ui2Val - iiBus2 * ur2Val;  // Qextremite
  calculatedVars_[iS1ToS2Side1Num_] = signP1 * calculatedVars_[i1Num_] * factorPuToA_;
  calculatedVars_[iS2ToS1Side1Num_] = -1. * calculatedVars_[iS1ToS2Side1Num_];
  calculatedVars_[iS2ToS1Side2Num_] = signP2 * calculatedVars_[i2Num_] * factorPuToA_;
  calculatedVars_[iS1ToS2Side2Num_] = -1. * calculatedVars_[iS2ToS1Side2Num_];

  calculatedVars_[iSide1Num_] = std::abs(calculatedVars_[iS1ToS2Side1Num_]);
  calculatedVars_[iSide2Num_] = std::abs(calculatedVars_[iS1ToS2Side2Num_]);
  calculatedVars_[u1Num_] = std::sqrt(ur1Val * ur1Val + ui1Val * ui1Val);
  calculatedVars_[u2Num_] = std::sqrt(ur2Val * ur2Val + ui2Val * ui2Val);
  calculatedVars_[lineStateNum_] = connectionState_;
}

double
ModelLine::ur1() const {
  double ur1 = 0.;
  if (modelBus1_)
    ur1 = modelBus1_->ur();
  return ur1;
}

double
ModelLine::ui1() const {
  double ui1 = 0.;
  if (modelBus1_)
    ui1 = modelBus1_->ui();
  return ui1;
}

double
ModelLine::ur2() const {
  double ur2 = 0.;
  if (modelBus2_)
    ur2 = modelBus2_->ur();
  return ur2;
}

double
ModelLine::ui2() const {
  double ui2 = 0.;
  if (modelBus2_)
    ui2 = modelBus2_->ui();
  return ui2;
}

double
ModelLine::i1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  double irBus1 = ir1(ur1, ui1, ur2, ui2);
  double iiBus1 = ii1(ur1, ui1, ur2, ui2);
  return sqrt(irBus1 * irBus1 + iiBus1 * iiBus1);
}

double
ModelLine::i2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  double irBus2 = ir2(ur1, ui1, ur2, ui2);
  double iiBus2 = ii2(ur1, ui1, ur2, ui2);
  return sqrt(irBus2 * irBus2 + iiBus2 * iiBus2);
}

void
ModelLine::getDefJCalculatedVarI(int numCalculatedVar, vector<int> & numVars) {
  switch (numCalculatedVar) {
    case i1Num_:
    case i2Num_:
    case p1Num_:
    case p2Num_:
    case q1Num_:
    case q2Num_:
    case iS1ToS2Side1Num_:
    case iS2ToS1Side1Num_:
    case iS1ToS2Side2Num_:
    case iS2ToS1Side2Num_:
    case iSide1Num_:
    case iSide2Num_: {
      switch (knownBus_) {
        case BUS1_BUS2: {
          numVars.push_back(modelBus1_->urYNum());
          numVars.push_back(modelBus1_->uiYNum());
          numVars.push_back(modelBus2_->urYNum());
          numVars.push_back(modelBus2_->uiYNum());
          break;
        }
        case BUS1: {
          numVars.push_back(modelBus1_->urYNum());
          numVars.push_back(modelBus1_->uiYNum());
          break;
        }
        case BUS2: {
          numVars.push_back(modelBus2_->urYNum());
          numVars.push_back(modelBus2_->uiYNum());
          break;
        }
      }
      break;
    }
    case u1Num_: {
      switch (knownBus_) {
        case BUS1_BUS2:
        case BUS1:
          numVars.push_back(modelBus1_->urYNum());
          numVars.push_back(modelBus1_->uiYNum());
          break;
        case BUS2:
          break;
      }
    }
    break;

    case u2Num_: {
      switch (knownBus_) {
        case BUS1_BUS2:
        case BUS2:
          numVars.push_back(modelBus2_->urYNum());
          numVars.push_back(modelBus2_->uiYNum());
          break;
        case BUS1:
          break;
      }
    }
    break;
    case lineStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelLine::evalJCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/, vector<double>& res) {
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;
  if (numCalculatedVar != u1Num_ && numCalculatedVar != u2Num_) {
    // in the y vector, we have access only at variables declared in getDefJCalculatedVarI
    switch (knownBus_) {
      case BUS1_BUS2: {
        ur1 = y[0];
        ui1 = y[1];
        ur2 = y[2];
        ui2 = y[3];
        break;
      }
      case BUS1: {
        ur1 = y[0];
        ui1 = y[1];
        break;
      }
      case BUS2: {
        ur2 = y[0];
        ui2 = y[1];
        break;
      }
    }
  }
  double Ir1 = ir1(ur1, ui1, ur2, ui2);
  double Ii1 = ii1(ur1, ui1, ur2, ui2);
  double Ir2 = ir2(ur1, ui1, ur2, ui2);
  double Ii2 = ii2(ur1, ui1, ur2, ui2);

  switch (numCalculatedVar) {
    case i1Num_: {
      double I1 = sqrt(Ii1 * Ii1 + Ir1 * Ir1);

      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) && doubleNotEquals(I1, 0.)) {
        res[0] = (ii1_dUr1_ * Ii1 + ir1_dUr1_ * Ir1) / I1;   // dI1/dUr1
        res[1] = (ii1_dUi1_ * Ii1 + ir1_dUi1_ * Ir1) / I1;   // dI1/dUi1
        res[2] = (ii1_dUr2_ * Ii1 + ir1_dUr2_ * Ir1) / I1;   // dI1/dUr2
        res[3] = (ii1_dUi2_ * Ii1 + ir1_dUi2_ * Ir1) / I1;   // dI1/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case iS1ToS2Side1Num_: {
      double I1 = sqrt(Ii1 * Ii1 + Ir1 * Ir1);
      double P1 = Ir1 * ur1 + Ii1 * ui1;
      int signP1 = sign(P1);
      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) && doubleNotEquals(I1, 0.)) {
        res[0] = signP1 * factorPuToA_ * (ii1_dUr1_ * Ii1 + ir1_dUr1_ * Ir1) / I1;   // dI1/dUr1
        res[1] = signP1 * factorPuToA_ * (ii1_dUi1_ * Ii1 + ir1_dUi1_ * Ir1) / I1;   // dI1/dUi1
        res[2] = signP1 * factorPuToA_ * (ii1_dUr2_ * Ii1 + ir1_dUr2_ * Ir1) / I1;   // dI1/dUr2
        res[3] = signP1 * factorPuToA_ * (ii1_dUi2_ * Ii1 + ir1_dUi2_ * Ir1) / I1;   // dI1/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case iS2ToS1Side1Num_: {
      double I1 = sqrt(Ii1 * Ii1 + Ir1 * Ir1);
      double P1 = Ir1 * ur1 + Ii1 * ui1;
      int signP1 = sign(-1 * P1);
      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) && doubleNotEquals(I1, 0.)) {
        res[0] = signP1 * factorPuToA_ * (ii1_dUr1_ * Ii1 + ir1_dUr1_ * Ir1) / I1;   // dI1/dUr1
        res[1] = signP1 * factorPuToA_ * (ii1_dUi1_ * Ii1 + ir1_dUi1_ * Ir1) / I1;   // dI1/dUi1
        res[2] = signP1 * factorPuToA_ * (ii1_dUr2_ * Ii1 + ir1_dUr2_ * Ir1) / I1;   // dI1/dUr2
        res[3] = signP1 * factorPuToA_ * (ii1_dUi2_ * Ii1 + ir1_dUi2_ * Ir1) / I1;   // dI1/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case iSide1Num_: {
      double I1 = sqrt(Ii1 * Ii1 + Ir1 * Ir1);
      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) && doubleNotEquals(I1, 0.)) {
        res[0] = factorPuToA_ * (ii1_dUr1_ * Ii1 + ir1_dUr1_ * Ir1) / I1;   // dI1/dUr1
        res[1] = factorPuToA_ * (ii1_dUi1_ * Ii1 + ir1_dUi1_ * Ir1) / I1;   // dI1/dUi1
        res[2] = factorPuToA_ * (ii1_dUr2_ * Ii1 + ir1_dUr2_ * Ir1) / I1;   // dI1/dUr2
        res[3] = factorPuToA_ * (ii1_dUi2_ * Ii1 + ir1_dUi2_ * Ir1) / I1;   // dI1/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case i2Num_: {
      double I2 = sqrt(Ii2 * Ii2 + Ir2 * Ir2);
      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) && doubleNotEquals(I2, 0.)) {
        res[0] = (ii2_dUr1_ * Ii2 + ir2_dUr1_ * Ir2) / I2;   // dI2/dUr1
        res[1] = (ii2_dUi1_ * Ii2 + ir2_dUi1_ * Ir2) / I2;   // dI2/dUi1
        res[2] = (ii2_dUr2_ * Ii2 + ii2_dUr2_ * Ir2) / I2;   // dI2/dUr2
        res[3] = (ii2_dUi2_ * Ii2 + ir2_dUi2_ * Ir2) / I2;   // dI2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case iS2ToS1Side2Num_: {
      double I2 = sqrt(Ii2 * Ii2 + Ir2 * Ir2);
      double P2 = ur2 * Ir2 + ui2 * Ii2;
      int signP2 = sign(P2);
      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) && doubleNotEquals(I2, 0.)) {
        res[0] = signP2 * factorPuToA_ * (ii2_dUr1_ * Ii2 + ir2_dUr1_ * Ir2) / I2;   // dI2/dUr1
        res[1] = signP2 * factorPuToA_ * (ii2_dUi1_ * Ii2 + ir2_dUi1_ * Ir2) / I2;   // dI2/dUi1
        res[2] = signP2 * factorPuToA_ * (ii2_dUr2_ * Ii2 + ii2_dUr2_ * Ir2) / I2;   // dI2/dUr2
        res[3] = signP2 * factorPuToA_ * (ii2_dUi2_ * Ii2 + ir2_dUi2_ * Ir2) / I2;   // dI2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case iS1ToS2Side2Num_: {
      double I2 = sqrt(Ii2 * Ii2 + Ir2 * Ir2);
      double P2 = ur2 * Ir2 + ui2 * Ii2;
      int signP2 = sign(-1 * P2);
      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) && doubleNotEquals(I2, 0.)) {
        res[0] = signP2 * factorPuToA_ * (ii2_dUr1_ * Ii2 + ir2_dUr1_ * Ir2) / I2;   // dI2/dUr1
        res[1] = signP2 * factorPuToA_ * (ii2_dUi1_ * Ii2 + ir2_dUi1_ * Ir2) / I2;   // dI2/dUi1
        res[2] = signP2 * factorPuToA_ * (ii2_dUr2_ * Ii2 + ii2_dUr2_ * Ir2) / I2;   // dI2/dUr2
        res[3] = signP2 * factorPuToA_ * (ii2_dUi2_ * Ii2 + ir2_dUi2_ * Ir2) / I2;   // dI2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case iSide2Num_: {
      double I2 = sqrt(Ii2 * Ii2 + Ir2 * Ir2);
      if ((getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) && doubleNotEquals(I2, 0.)) {
        res[0] = factorPuToA_ * (ii2_dUr1_ * Ii2 + ir2_dUr1_ * Ir2) / I2;   // dI2/dUr1
        res[1] = factorPuToA_ * (ii2_dUi1_ * Ii2 + ir2_dUi1_ * Ir2) / I2;   // dI2/dUi1
        res[2] = factorPuToA_ * (ii2_dUr2_ * Ii2 + ir2_dUr2_ * Ir2) / I2;   // dI2/dUr2
        res[3] = factorPuToA_ * (ii2_dUi2_ * Ii2 + ir2_dUi2_ * Ir2) / I2;   // dI2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case p1Num_: {
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) {
        res[0] = Ir1 + ur1 * ir1_dUr1_ + ui1 * ii1_dUr1_;   // dP1/dUr1
        res[1] = ur1 * ir1_dUi1_ + Ii1 + ui1 * ii1_dUi1_;   // dP1/dUi1
        res[2] = ur1 * ir1_dUr2_ + ui1 * ii1_dUr2_;   // dP1/dUr2
        res[3] = ur1 * ir1_dUi2_ + ui1 * ii1_dUi2_;   // dP1/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case p2Num_: {
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) {
        res[0] = ur2 * ir2_dUr1_ + ui2 * ii2_dUr1_;   // dP2/dUr1
        res[1] = ur2 * ir2_dUi1_ + ui2 * ii2_dUi1_;   // dP2/dUi1
        res[2] = Ir2 + ur2 * ir2_dUr2_ + ui2 * ii2_dUr2_;   // dP2/dUr2
        res[3] = ur2 * ir2_dUi2_ + Ii2 + ui2 * ii2_dUi2_;   // dP2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case q1Num_: {
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) {
        res[0] = ui1 * ir1_dUr1_ - Ii1 - ur1 * ii1_dUr1_;   // dQ1/dUr1
        res[1] = Ir1 + ui1 * ir1_dUi1_ - ur1 * ii1_dUi1_;   // dQ1/dUi1
        res[2] = ui1 * ir1_dUr2_ - ur1 * ii1_dUr2_;   // dQ1/dUr2
        res[3] = ui1 * ir1_dUi2_ - ur1 * ii1_dUi2_;   // dQ1/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case q2Num_: {
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) {
        res[0] = ui2 * ir2_dUr1_ - ur2 * ii2_dUr1_;   // dQ2/dUr1
        res[1] = ui2 * ir2_dUi1_ - ur2 * ii2_dUi1_;   // dQ2/dUi1
        res[2] = ui2 * ir2_dUr2_ - Ii2 - ur2 * ii2_dUr2_;   // dQ2/dUr2
        res[3] = Ir2 + ui2 * ir2_dUi2_ - ur2 * ii2_dUi2_;   // dQ2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case u1Num_: {
      switch (knownBus_) {
        case BUS1_BUS2:
        case BUS1:
          ur1 = y[0];
          ui1 = y[1];
          break;
        case BUS2:
          break;
      }
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) {
        double invU1 = 1. / sqrt(ur1 * ur1 + ui1 * ui1);
        res[0] = ur1 * invU1;  // dU1/dUr1
        res[1] = ui1 * invU1;  // dU1/dUi1
      } else {
        res[0] = 0.;
        res[1] = 0.;
      }
    }
    break;
    case u2Num_: {
      switch (knownBus_) {
        case BUS1_BUS2:
        case BUS1:
          ur2 = y[0];
          ui2 = y[1];
          break;
        case BUS2:
          break;
      }
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) {
        double invU2 = 1. / sqrt(ur2 * ur2 + ui2 * ui2);
        res[0] = ur2 * invU2;  // dU2/dUr2
        res[1] = ui2 * invU2;  // dU2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
      }
    }
    break;
    case lineStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelLine::evalCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/) {
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;
  if (numCalculatedVar != u1Num_ && numCalculatedVar != u2Num_) {
    // in the y vector, we have access only at variables declared in getDefJCalculatedVarI
    switch (knownBus_) {
      case BUS1_BUS2: {
        ur1 = y[0];
        ui1 = y[1];
        ur2 = y[2];
        ui2 = y[3];
        break;
      }
      case BUS1: {
        ur1 = y[0];
        ui1 = y[1];
        break;
      }
      case BUS2: {
        ur2 = y[0];
        ui2 = y[1];
        break;
      }
    }
  }

  double Ir1 = ir1(ur1, ui1, ur2, ui2);
  double Ii1 = ii1(ur1, ui1, ur2, ui2);
  double Ir2 = ir2(ur1, ui1, ur2, ui2);
  double Ii2 = ii2(ur1, ui1, ur2, ui2);
  double P1 = ur1 * Ir1 + ui1 * Ii1;
  double P2 = ur2 * Ir2 + ui2 * Ii2;
  int signP1 = sign(P1);
  int signP2 = sign(P2);

  double output = 0.0;
  switch (numCalculatedVar) {
    case i1Num_:
      output = sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case iS1ToS2Side1Num_:
      output = signP1 * factorPuToA_ * sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case iS2ToS1Side1Num_:
      output = -1. * signP1 * factorPuToA_ * sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case iSide1Num_: {
      double I1 = sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      double output1 = signP1 * factorPuToA_ * I1;
      double output2 = -1. * signP1 * factorPuToA_ * I1;
      output = std::max(output1, output2);
      break;
    }
    case i2Num_:
      output = sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      break;
    case iS2ToS1Side2Num_:
      output = signP2 * factorPuToA_ * sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      break;
    case iS1ToS2Side2Num_:
      output = -1. * signP2 * factorPuToA_ * sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      break;
    case iSide2Num_: {
      double I2 = sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      double output1 = signP2 * factorPuToA_ * I2;
      double output2 = -1. * signP2 * factorPuToA_ * I2;
      output = std::max(output1, output2);
      break;
    }
    case p1Num_:
      output = P1;
      break;
    case p2Num_:
      output = P2;
      break;
    case q1Num_:
      output = ui1 * Ir1 - ur1 * Ii1;
      break;
    case q2Num_:
      output = ui2 * Ir2 - ur2 * Ii2;
      break;
    case u1Num_: {
      switch (knownBus_) {
        case BUS1_BUS2:
        case BUS1:
          ur1 = y[0];
          ui1 = y[1];
          break;
        case BUS2:
          break;
      }
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) {
        output = sqrt(ur1 * ur1 + ui1 * ui1);
      }
    }
    break;
    case u2Num_: {
      switch (knownBus_) {
        case BUS1_BUS2:
        case BUS2:
          ur2 = y[0];
          ui2 = y[1];
          break;
        case BUS1:
          break;
      }
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) {
        output = sqrt(ur2 * ur2 + ui2 * ui2);
      }
    }
    break;
    case lineStateNum_:
      output = connectionState_;
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return output;
}

void
ModelLine::getY0() {
  if (!network_->isInitModel()) {
    z_[0] = getConnectionState();
    z_[1] = getCurrentLimitsDesactivate();
  }
}

NetworkComponent::StateChange_t
ModelLine::evalState(const double& /*time*/) {
  StateChange_t state = NetworkComponent::NO_CHANGE;

  if (static_cast<State>(z_[0]) != getConnectionState()) {
    if ((State) z_[0] == CLOSED && knownBus_ != BUS1_BUS2) {
      Trace::error() << DYNLog(UnableToCloseLine, id_) << Trace::endline;
      return state;
    }

    if ((State) z_[0] == CLOSED_1 && knownBus_ == BUS2) {
      Trace::error() << DYNLog(UnableToCloseLineSide1, id_) << Trace::endline;
      return state;
    }

    if ((State) z_[0] == CLOSED_2 && knownBus_ == BUS1) {
      Trace::error() << DYNLog(UnableToCloseLineSide2, id_) << Trace::endline;
      return state;
    }

    Trace::debug() << DYNLog(LineStateChange, id_, getConnectionState(), z_[0]) << Trace::endline;

    switch ((State) z_[0]) {
      // z_[0] represents the actual state
      // getConnectionState() represents the previous state
      // compare them to know what happened, which timeline message to generate
      // and which topology action to take
      case UNDEFINED:
        throw DYNError(Error::MODELER, UndefinedComponentState, id_);
      case OPEN:
        switch (getConnectionState()) {
          case OPEN:
            break;
          case CLOSED:
            network_->addEvent(id_, DYNTimeline(LineOpen));
            modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
            modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED_1:
            network_->addEvent(id_, DYNTimeline(LineOpenSide1));
            modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
            break;
          case CLOSED_2:
            network_->addEvent(id_, DYNTimeline(LineOpenSide2));
            modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED_3:
            throw DYNError(Error::MODELER, NoThirdSide, id_);
          case UNDEFINED:
            throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
          }
        break;
      case CLOSED:
        switch (getConnectionState()) {
          case OPEN:
            network_->addEvent(id_, DYNTimeline(LineClosed));
            modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
            modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED:
            break;
          case CLOSED_1:
            network_->addEvent(id_, DYNTimeline(LineCloseSide2));
            modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED_2:
            network_->addEvent(id_, DYNTimeline(LineCloseSide1));
            modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
            break;
          case CLOSED_3:
            throw DYNError(Error::MODELER, NoThirdSide, id_);
          case UNDEFINED:
            throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
          }
        break;
      case CLOSED_1:
        switch (getConnectionState()) {
          case OPEN:
            network_->addEvent(id_, DYNTimeline(LineCloseSide1));
            modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
            break;
          case CLOSED:
            network_->addEvent(id_, DYNTimeline(LineOpenSide2));
            modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED_1:
            break;
          case CLOSED_2:
            network_->addEvent(id_, DYNTimeline(LineCloseSide1));
            network_->addEvent(id_, DYNTimeline(LineOpenSide2));
            modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
            modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED_3:
            throw DYNError(Error::MODELER, NoThirdSide, id_);
          case UNDEFINED:
            throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
          }
        break;
      case CLOSED_2:
        switch (getConnectionState()) {
          case OPEN:
            network_->addEvent(id_, DYNTimeline(LineCloseSide2));
            modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED:
            network_->addEvent(id_, DYNTimeline(LineOpenSide1));
            modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
            break;
          case CLOSED_1:
            network_->addEvent(id_, DYNTimeline(LineCloseSide2));
            network_->addEvent(id_, DYNTimeline(LineOpenSide1));
            modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
            modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED_2:
            break;
          case CLOSED_3:
            throw DYNError(Error::MODELER, NoThirdSide, id_);
          case UNDEFINED:
            throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
          }
        break;
      case CLOSED_3:
        throw DYNError(Error::MODELER, NoThirdSide, id_);
    }

    setConnectionState((State) z_[0]);

    state = NetworkComponent::TOPO_CHANGE;
  }

  if (doubleNotEquals(z_[1], getCurrentLimitsDesactivate())) {
    setCurrentLimitsDesactivate(z_[1]);
    Trace::debug() << DYNLog(DeactivateCurrentLimits, id_) << Trace::endline;
  }

  return state;
}

void
ModelLine::addBusNeighbors() {
  if (getConnectionState() == CLOSED) {
    modelBus1_->addNeighbor(modelBus2_);
    modelBus2_->addNeighbor(modelBus1_);
  }
}

void
ModelLine::setSubModelParameters(const std::tr1::unordered_map<std::string, ParameterModeler>& params) {
  bool success = false;
  double maxTimeOperation = getParameterDynamicNoThrow<double>(params, "LINE_currentLimit_maxTimeOperation", success);
  if (success) {
    if (currentLimits1_)
      currentLimits1_->setMaxTimeOperation(maxTimeOperation);
    if (currentLimits2_)
      currentLimits2_->setMaxTimeOperation(maxTimeOperation);
  }
}

void
ModelLine::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("LINE_currentLimit_maxTimeOperation", DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelLine::defineNonGenericParameters(std::vector<ParameterModeler>& /*parameters*/) {
  /* no non generic parameter */
}

}  // namespace DYN
