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

#include "DYNCommon.h"
#include "DYNCommonModeler.h"
#include "DYNModelConstants.h"
#include "DYNModelBus.h"
#include "DYNModelCurrentLimits.h"
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
#include "DYNSparseMatrix.h"

using parameters::ParametersSet;

using std::vector;
using boost::shared_ptr;
using std::map;
using std::string;

namespace DYN {

ModelLine::ModelLine(const shared_ptr<LineInterface>& line) :
Impl(line->getID()),
topologyModified_(false),
updateYMat_(true),
isDynamic_(false),
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
ii2_dUi2_(0.),
yOffset_(0.),
IbReNum_(0.),
IbImNum_(0.),
omegaRefNum_(0.),
omegaNom_(OMEGA_NOM),
omegaRef_(1.),
modelType_("Line") {
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

  // R, X, G, B in SI units in IIDM
  double coeff = vNom * vNom / SNREF;
  double ad = 1. / sqrt(r * r + x * x);
  double ap = atan2(r, x);

  admittance_ = ad * coeff;
  lossAngle_ = ap;
  suscept1_ = b1 * coeff;
  suscept2_ = b2 * coeff;
  conduct1_ = g1 * coeff;
  conduct2_ = g2 * coeff;
  resistance_ = r / coeff;
  reactance_ = x / coeff;

  currentLimitsDesactivate_ = 0.;

  // current limits side 1
  vector<shared_ptr<CurrentLimitInterface> > cLimit1 = line->getCurrentLimitInterfaces1();
  if (cLimit1.size() > 0) {
    currentLimits1_.reset(new ModelCurrentLimits());
    currentLimits1_->setSide(ModelCurrentLimits::SIDE_1);
    // Due to IIDM convention
    if (cLimit1[0]->getLimit() < maximumValueCurrentLimit) {
      double limit = cLimit1[0]->getLimit() / factorPuToA_;
      currentLimits1_->addLimit(limit, cLimit1[0]->getAcceptableDuration());
    }
    for (unsigned int i = 1; i < cLimit1.size(); ++i) {
      if (cLimit1[i-1]->getLimit() < maximumValueCurrentLimit) {
        double limit = cLimit1[i-1]->getLimit() / factorPuToA_;
        currentLimits1_->addLimit(limit, cLimit1[i]->getAcceptableDuration());
      }
    }
  }

  // current limits side 2
  vector<shared_ptr<CurrentLimitInterface> > cLimit2 = line->getCurrentLimitInterfaces2();
  if (cLimit2.size() > 0) {
    currentLimits2_.reset(new ModelCurrentLimits());
    currentLimits2_->setSide(ModelCurrentLimits::SIDE_2);
    // Due to IIDM convention
    if (cLimit2[0]->getLimit() < maximumValueCurrentLimit) {
      double limit = cLimit2[0]->getLimit() / factorPuToA_;
      currentLimits2_->addLimit(limit, cLimit2[0]->getAcceptableDuration());
    }
    for (unsigned int i = 1; i < cLimit2.size(); ++i) {
      if (cLimit2[i-1]->getLimit() < maximumValueCurrentLimit) {
        double limit = cLimit2[i-1]->getLimit() / factorPuToA_;
        currentLimits2_->addLimit(limit, cLimit2[i]->getAcceptableDuration());
      }
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
    if (!doubleIsZero(U201)) {
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
    if (!doubleIsZero(U202)) {
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
    if (isDynamic_) {
      sizeF_ = 2;
      sizeY_ = 3;  // IBranch_re, IBranch_im, omegaRef
    }
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
ModelLine::init(int& yNum) {
  if (!network_->isInitModel()) {
    assert(yNum >= 0);
    yOffset_ = static_cast<unsigned int>(yNum);
    unsigned int localIndex = 0;

    if (isDynamic_) {
      IbReNum_ = localIndex;
      ++localIndex;
      IbImNum_ = localIndex;
      ++localIndex;
      omegaRefNum_ = localIndex;
      ++localIndex;
    }

    yNum += localIndex;
  }
}

void
ModelLine::evalYMat() {
  if (updateYMat_) {
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
    updateYMat_ = false;
  }
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
  if (getConnectionState() == CLOSED) {
    double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ir1_dUr1 = G1;
  } else if (getConnectionState() == CLOSED_1) {
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
  if (getConnectionState() == CLOSED) {
    double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ir1_dUi1 = -B1;
  } else if (getConnectionState() == CLOSED_1) {
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
  if (getConnectionState() == CLOSED) {
    ir1_dUr2 = -admittance_ * sin(lossAngle_);
  }
  return ir1_dUr2;
}

double
ModelLine::ir1_dUi2() const {
  double ir1_dUi2 = 0.;
  if (getConnectionState() == CLOSED) {
    ir1_dUi2 = -admittance_ * cos(lossAngle_);
  }
  return ir1_dUi2;
}

double
ModelLine::ii1_dUr1() const {
  double ii1_dUr1 = 0.;
  if (getConnectionState() == CLOSED) {
    double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ii1_dUr1 = B1;
  } else if (getConnectionState() == CLOSED_1) {
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
  if (getConnectionState() == CLOSED) {
    double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ii1_dUi1 = G1;
  } else if (getConnectionState() == CLOSED_1) {
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
  if (getConnectionState() == CLOSED) {
    ii1_dUr2 = admittance_ * cos(lossAngle_);
  }
  return ii1_dUr2;
}

double
ModelLine::ii1_dUi2() const {
  double ii1_dUi2 = 0.;
  if (getConnectionState() == CLOSED) {
    ii1_dUi2 = -admittance_ * sin(lossAngle_);
  }
  return ii1_dUi2;
}

double
ModelLine::ir2_dUr1() const {
  double ir2_dUr1 = 0.;
  if (getConnectionState() == CLOSED) {
    ir2_dUr1 = -admittance_ * sin(lossAngle_);
  }
  return ir2_dUr1;
}

double
ModelLine::ir2_dUi1() const {
  double ir2_dUi1 = 0.;
  if (getConnectionState() == CLOSED) {
    ir2_dUi1 = -admittance_ * cos(lossAngle_);
  }
  return ir2_dUi1;
}

double
ModelLine::ir2_dUr2() const {
  double ir2_dUr2 = 0.;
  if (getConnectionState() == CLOSED) {
    double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ir2_dUr2 = G2;
  } else if (getConnectionState() == CLOSED_2) {
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
  if (getConnectionState() == CLOSED) {
    double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ir2_dUi2 = -B2;
  } else if (getConnectionState() == CLOSED_2) {
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
  if (getConnectionState() == CLOSED) {
    ii2_dUr1 = admittance_ * cos(lossAngle_);
  }
  return ii2_dUr1;
}

double
ModelLine::ii2_dUi1() const {
  double ii2_dUi1 = 0.;
  if (getConnectionState() == CLOSED) {
    ii2_dUi1 = -admittance_ * sin(lossAngle_);
  }
  return ii2_dUi1;
}

double
ModelLine::ii2_dUr2() const {
  double ii2_dUr2 = 0.;
  if (getConnectionState() == CLOSED) {
    double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ii2_dUr2 = B2;
  } else if (getConnectionState() == CLOSED_2) {
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
  if (getConnectionState() == CLOSED) {
    double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ii2_dUi2 = G2;
  } else if (getConnectionState() == CLOSED_2) {
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
  } else if (!isDynamic_) {
    if (modelBus1_ || modelBus2_) {
      double ur1Val = ur1();
      double ui1Val = ui1();
      double ur2Val = ur2();
      double ui2Val = ui2();
      if (modelBus1_) {
        double irAdd1 = ir1(ur1Val, ui1Val, ur2Val, ui2Val);
        double iiAdd1 = ii1(ur1Val, ui1Val, ur2Val, ui2Val);
        modelBus1_->irAdd(irAdd1);
        modelBus1_->iiAdd(iiAdd1);
      }

      if (modelBus2_) {
        double irAdd2 = ir2(ur1Val, ui1Val, ur2Val, ui2Val);
        double iiAdd2 = ii2(ur1Val, ui1Val, ur2Val, ui2Val);
        modelBus2_->irAdd(irAdd2);
        modelBus2_->iiAdd(iiAdd2);
      }
    }
  } else if (getConnectionState() == CLOSED) {
    if (modelBus1_) {
      double ur1Val = ur1();
      double ui1Val = ui1();
      double urp1Val = urp1();
      double uip1Val = uip1();
      double irAdd1 = conduct1_ * ur1Val + suscept1_ * urp1Val / omegaNom_ - suscept1_ * omegaRef_ * ui1Val + y_[IbReNum_];
      double iiAdd1 = conduct1_ * ui1Val + suscept1_ * uip1Val / omegaNom_ + suscept1_ * omegaRef_ * ur1Val + y_[IbImNum_];
      modelBus1_->irAdd(irAdd1);
      modelBus1_->iiAdd(iiAdd1);
    }
    if (modelBus2_) {
      double ur2Val = ur2();
      double ui2Val = ui2();
      double urp2Val = urp2();
      double uip2Val = uip2();
      double irAdd2 = conduct2_ * ur2Val + suscept2_ * urp2Val / omegaNom_ - suscept2_ * omegaRef_ * ui2Val - y_[IbReNum_];
      double iiAdd2 = conduct2_ * ui2Val + suscept2_ * uip2Val / omegaNom_ + suscept2_ * omegaRef_ * ur2Val - y_[IbImNum_];
      modelBus2_->irAdd(irAdd2);
      modelBus2_->iiAdd(iiAdd2);
    }
  }
}

void
ModelLine::evalF(propertyF_t type) {
  if (!isDynamic_ || network_->isInitModel())
    return;
  bool connStateClosed = getConnectionState() == CLOSED;
  if (type == DIFFERENTIAL_EQ && !connStateClosed)
    return;

  if ((modelBus1_ || modelBus2_) && connStateClosed) {
    double ur1Val = ur1();
    double ui1Val = ui1();
    double ur2Val = ur2();
    double ui2Val = ui2();
    f_[0] = - reactance_ * yp_[IbReNum_] - omegaNom_ * (resistance_ * y_[IbReNum_] - reactance_ * omegaRef_ * y_[IbImNum_]);
    f_[1] = - reactance_ * yp_[IbImNum_] - omegaNom_ * (resistance_ * y_[IbImNum_] + reactance_ * omegaRef_ * y_[IbReNum_]);
    if (modelBus1_) {
      f_[0] += omegaNom_ * ur1Val;
      f_[1] += omegaNom_ * ui1Val;
    }
    if (modelBus2_) {
      f_[0] -= omegaNom_ * ur2Val;
      f_[1] -= omegaNom_ * ui2Val;
    }
  } else {
    f_[0] = y_[IbReNum_];
    f_[1] = y_[IbImNum_];
  }
}

void
ModelLine::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) {
  if (!isDynamic_ || network_->isInitModel())
    return;

  if ((modelBus1_ || modelBus2_) && getConnectionState() == CLOSED) {
    int ur1YNum = modelBus1_->urYNum();
    int ui1YNum = modelBus1_->uiYNum();
    int ur2YNum = modelBus2_->urYNum();
    int ui2YNum = modelBus2_->uiYNum();

    // column for equation IBranch_re
    jt.changeCol();
    jt.addTerm(globalYIndex(IbReNum_) + rowOffset, - omegaNom_ * resistance_ - cj * reactance_);
    jt.addTerm(globalYIndex(IbImNum_) + rowOffset, omegaNom_ * reactance_ * omegaRef_);
    if (modelBus1_)
      jt.addTerm(ur1YNum + rowOffset, omegaNom_);
    if (modelBus2_)
      jt.addTerm(ur2YNum + rowOffset, -omegaNom_);

    // column for equation IBranch_im
    jt.changeCol();
    jt.addTerm(globalYIndex(IbReNum_) + rowOffset, - omegaNom_ * reactance_ * omegaRef_);
    jt.addTerm(globalYIndex(IbImNum_) + rowOffset, -omegaNom_ * resistance_ - cj * reactance_);
    if (modelBus1_)
      jt.addTerm(ui1YNum + rowOffset, omegaNom_);
    if (modelBus2_)
      jt.addTerm(ui2YNum + rowOffset, -omegaNom_);
  } else {
    jt.changeCol();
    jt.addTerm(globalYIndex(IbReNum_) + rowOffset, 1);
    jt.changeCol();
    jt.addTerm(globalYIndex(IbImNum_) + rowOffset, 1);
  }
}

void
ModelLine::evalJtPrim(SparseMatrix& jt, const int& rowOffset) {
  if (!isDynamic_ || network_->isInitModel())
    return;

  if (getConnectionState() == CLOSED) {
    // column for equation IBranch_re
    jt.changeCol();
    jt.addTerm(globalYIndex(IbReNum_) + rowOffset, - reactance_);
    // column for equation IBranch_im
    jt.changeCol();
    jt.addTerm(globalYIndex(IbImNum_) + rowOffset, - reactance_);
  }
}

void
ModelLine::evalDerivativesPrim() {
  if (isDynamic_ && getConnectionState() == CLOSED) {
    switch (knownBus_) {
      case BUS1_BUS2: {
        int ur1YNum = modelBus1_->urYNum();
        int ui1YNum = modelBus1_->uiYNum();
        int ur2YNum = modelBus2_->urYNum();
        int ui2YNum = modelBus2_->uiYNum();
        double ir1_dUrp1 = suscept1_ / omegaNom_;
        double ii1_dUip1 = suscept1_ / omegaNom_;
        double ir2_dUrp2 = suscept2_ / omegaNom_;
        double ii2_dUip2 = suscept2_ / omegaNom_;

        modelBus1_->derivativesPrim()->addDerivative(IR_DERIVATIVE, ur1YNum, ir1_dUrp1);
        modelBus1_->derivativesPrim()->addDerivative(II_DERIVATIVE, ui1YNum, ii1_dUip1);

        modelBus2_->derivativesPrim()->addDerivative(IR_DERIVATIVE, ur2YNum, ir2_dUrp2);
        modelBus2_->derivativesPrim()->addDerivative(II_DERIVATIVE, ui2YNum, ii2_dUip2);
        break;
      }
    case BUS1:
    case BUS2: {
      break;
      }
    }
  }
}

void
ModelLine::evalDerivatives(const double cj) {
  if (isDynamic_ && getConnectionState() == CLOSED) {
    switch (knownBus_) {
      case BUS1_BUS2: {
        int ur1YNum = modelBus1_->urYNum();
        int ui1YNum = modelBus1_->uiYNum();
        int ur2YNum = modelBus2_->urYNum();
        int ui2YNum = modelBus2_->uiYNum();
        double ir1_dUr1 = conduct1_ + cj * suscept1_ / omegaNom_;
        double ir1_dUi1 = - omegaRef_ * suscept1_;
        double ir1_dIbr = 1;
        double ii1_dUr1 = conduct1_ + cj * suscept1_ / omegaNom_;
        double ii1_dUi1 = omegaRef_ * suscept1_;
        double ii1_dIbi = 1;
        double ir2_dUr2 = conduct2_ + cj * suscept2_ / omegaNom_;
        double ir2_dUi2 = - omegaRef_ * suscept2_;
        double ir2_dIbr = -1;
        double ii2_dUr2 = conduct2_ + cj * suscept2_ / omegaNom_;
        double ii2_dUi2 = omegaRef_ * suscept2_;
        double ii2_dIbi = -1;

        modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ur1YNum, ir1_dUr1);
        modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, ui1YNum, ir1_dUi1);
        modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, globalYIndex(IbReNum_), ir1_dIbr);
        modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ur1YNum, ii1_dUr1);
        modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, ui1YNum, ii1_dUi1);
        modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, globalYIndex(IbImNum_), ii1_dIbi);

        modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ur2YNum, ir2_dUr2);
        modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, ur2YNum, ir2_dUi2);
        modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, globalYIndex(IbReNum_), ir2_dIbr);
        modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ui2YNum, ii2_dUr2);
        modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, ui2YNum, ii2_dUi2);
        modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, globalYIndex(IbImNum_), ii2_dIbi);
        break;
      }
    case BUS1:
    case BUS2: {
        break;
      }
    }
  } else if (!isDynamic_) {
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
}

void
ModelLine::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  if (isDynamic_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_iBranch_re", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState(id_ + "_iBranch_im", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState(id_ + "_omegaRef_value", CONTINUOUS));
  }
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
  variables.push_back(VariableNativeFactory::createState("@ID@_iBranch_re", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_iBranch_im", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_omegaRef_value", CONTINUOUS));
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
  if (isDynamic_) {
    string name = lineName + string("_iBranch");
    addElement(name, Element::STRUCTURE, elements, mapElement);
    addSubElement("re", name, Element::TERMINAL, elements, mapElement);
    addSubElement("im", name, Element::TERMINAL, elements, mapElement);
    addElementWithValue(lineName + string("_omegaRef"), elements, mapElement);
  }
  addElementWithValue(lineName + string("_i1"), elements, mapElement);
  addElementWithValue(lineName + string("_i2"), elements, mapElement);
  addElementWithValue(lineName + string("_P1"), elements, mapElement);
  addElementWithValue(lineName + string("_P2"), elements, mapElement);
  addElementWithValue(lineName + string("_Q1"), elements, mapElement);
  addElementWithValue(lineName + string("_Q2"), elements, mapElement);
  addElementWithValue(lineName + string("_iS1ToS2Side1"), elements, mapElement);
  addElementWithValue(lineName + string("_iS2ToS1Side1"), elements, mapElement);
  addElementWithValue(lineName + string("_iS1ToS2Side2"), elements, mapElement);
  addElementWithValue(lineName + string("_iS2ToS1Side2"), elements, mapElement);
  addElementWithValue(lineName + string("_iSide1"), elements, mapElement);
  addElementWithValue(lineName + string("_iSide2"), elements, mapElement);
  addElementWithValue(lineName + string("_U1"), elements, mapElement);
  addElementWithValue(lineName + string("_U2"), elements, mapElement);
  addElementWithValue(lineName + string("_lineState"), elements, mapElement);
  addElementWithValue(lineName + string("_state"), elements, mapElement);
  addElementWithValue(lineName + string("_desactivate_currentLimits"), elements, mapElement);
}

NetworkComponent::StateChange_t
ModelLine::evalZ(const double& t) {
  int offsetRoot = 0;
  ModelCurrentLimits::state_t currentLimitState;

  if (currentLimits1_) {
    currentLimitState = currentLimits1_->evalZ(id(), t, &(g_[offsetRoot]), network_, currentLimitsDesactivate_, modelType_);
    offsetRoot += currentLimits1_->sizeG();
    if (currentLimitState == ModelCurrentLimits::COMPONENT_OPEN)
      z_[0] = OPEN;
  }

  if (currentLimits2_) {
    currentLimitState = currentLimits2_->evalZ(id(), t, &(g_[offsetRoot]), network_, currentLimitsDesactivate_, modelType_);
    if (currentLimitState == ModelCurrentLimits::COMPONENT_OPEN)
      z_[0] = OPEN;
  }

  State currState = static_cast<State>(static_cast<int>(z_[0]));
  if (currState != getConnectionState()) {
    if (currState == CLOSED && knownBus_ != BUS1_BUS2) {
      Trace::error() << DYNLog(UnableToCloseLine, id_) << Trace::endline;
    } else if (currState == CLOSED_1 && knownBus_ == BUS2) {
      Trace::error() << DYNLog(UnableToCloseLineSide1, id_) << Trace::endline;
    } else if (currState == CLOSED_2 && knownBus_ == BUS1) {
      Trace::error() << DYNLog(UnableToCloseLineSide2, id_) << Trace::endline;
    } else {
      topologyModified_ = true;
      Trace::info() << DYNLog(LineStateChange, id_, getConnectionState(), currState) << Trace::endline;
      switch (currState) {
      // z_[0] represents the actual state
      // getConnectionState() represents the previous state
      // compare them to know what happened, which timeline message to generate
      // and which topology action to take
      case UNDEFINED_STATE:
        topologyModified_ = false;
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
          topologyModified_ = false;
          throw DYNError(Error::MODELER, NoThirdSide, id_);
        case UNDEFINED_STATE:
          topologyModified_ = false;
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
            topologyModified_ = false;
            throw DYNError(Error::MODELER, NoThirdSide, id_);
          case UNDEFINED_STATE:
            topologyModified_ = false;
            throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
          }
          break;
          case CLOSED_1:
            if (isDynamic_)
              throw DYNError(Error::MODELER, DynamicLineStatusNotSupported, id_);
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
              topologyModified_ = false;
              throw DYNError(Error::MODELER, NoThirdSide, id_);
            case UNDEFINED_STATE:
              topologyModified_ = false;
              throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
            }
            break;
            case CLOSED_2:
              if (isDynamic_)
                throw DYNError(Error::MODELER, DynamicLineStatusNotSupported, id_);
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
                topologyModified_ = false;
                throw DYNError(Error::MODELER, NoThirdSide, id_);
              case UNDEFINED_STATE:
                topologyModified_ = false;
                throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
              }
              break;
              case CLOSED_3:
                topologyModified_ = false;
                throw DYNError(Error::MODELER, NoThirdSide, id_);
      }
    }
    setConnectionState(static_cast<State>(static_cast<int>(z_[0])));
  }

  if (doubleNotEquals(z_[1], getCurrentLimitsDesactivate())) {
    setCurrentLimitsDesactivate(z_[1]);
    Trace::info() << DYNLog(DeactivateCurrentLimits, id_) << Trace::endline;
  }

  if (topologyModified_) {
    updateYMat_ = true;
    return NetworkComponent::TOPO_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelLine::collectSilentZ(bool* silentZTable) {
  silentZTable[0] = true;
  silentZTable[1] = true;
}

void
ModelLine::evalG(const double& t) {
  int offset = 0;
  if (currentLimits1_ || currentLimits2_) {
    double ur1Val = ur1();
    double ui1Val = ui1();
    double ur2Val = ur2();
    double ui2Val = ui2();
    if (currentLimits1_) {
      currentLimits1_->evalG(t, i1(ur1Val, ui1Val, ur2Val, ui2Val), &(g_[offset]), currentLimitsDesactivate_);
      offset += currentLimits1_->sizeG();
    }

    if (currentLimits2_) {
      currentLimits2_->evalG(t, i2(ur1Val, ui1Val, ur2Val, ui2Val), &(g_[offset]), currentLimitsDesactivate_);
    }
  }
}

void
ModelLine::setFequations(std::map<int, std::string>& fEquationIndex) {
  if (isDynamic_) {
    std::stringstream fRe;
    fRe << id() << " - real part of the branch current: 0 = omegaNom * (Re(U1) - Re(U2) + L * omegaRef * Im(Ib) - R * Re(Ib)) - L * d(Re(Ib))/dt";
    fEquationIndex[0] = fRe.str();

    std::stringstream fIm;
    fIm << id() << " - imaginary part of the branch current: 0 = omegaNom * (Im(U1) - Im(U2) - L * omegaRef * Re(Ib) - R * Im(Ib)) - L * d(Im(Ib))/dt";
    fEquationIndex[1] = fIm.str();
  }
}

void
ModelLine::evalYType() {
  if (isDynamic_) {
    if (getConnectionState() == CLOSED) {
      yType_[0] = DIFFERENTIAL;
      yType_[1] = DIFFERENTIAL;
    } else {
      yType_[0] = ALGEBRAIC;
      yType_[1] = ALGEBRAIC;
    }
    yType_[2] = EXTERNAL;
  }
}

void
ModelLine::updateYType() {
  evalYType();
}

void
ModelLine::evalFType() {
  if (isDynamic_) {
    if (getConnectionState() == CLOSED) {
      fType_[0] = DIFFERENTIAL_EQ;
      fType_[1] = DIFFERENTIAL_EQ;
    } else {
      fType_[0] = ALGEBRAIC_EQ;
      fType_[1] = ALGEBRAIC_EQ;
    }
  }
}

void
ModelLine::updateFType() {
  evalFType();
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

  calculatedVars_[i1Num_] = sqrt(irBus1 * irBus1 + iiBus1 * iiBus1);  // Current side 1
  calculatedVars_[i2Num_] = sqrt(irBus2 * irBus2 + iiBus2 * iiBus2);  // Current side 2
  calculatedVars_[p1Num_] = P1;  // Active power side 1
  calculatedVars_[p2Num_] = P2;  // Active power side 2
  calculatedVars_[q1Num_] = irBus1 * ui1Val - iiBus1 * ur1Val;  // Reactive power side 1
  calculatedVars_[q2Num_] = irBus2 * ui2Val - iiBus2 * ur2Val;  // Reactive power side 2
  calculatedVars_[iS1ToS2Side1Num_] = signP1 * calculatedVars_[i1Num_] * factorPuToA_;
  calculatedVars_[iS2ToS1Side1Num_] = -1. * calculatedVars_[iS1ToS2Side1Num_];
  calculatedVars_[iS2ToS1Side2Num_] = signP2 * calculatedVars_[i2Num_] * factorPuToA_;
  calculatedVars_[iS1ToS2Side2Num_] = -1. * calculatedVars_[iS2ToS1Side2Num_];

  calculatedVars_[iSide1Num_] = std::abs(calculatedVars_[iS1ToS2Side1Num_]);
  calculatedVars_[iSide2Num_] = std::abs(calculatedVars_[iS1ToS2Side2Num_]);
  if (modelBus1_)
    calculatedVars_[u1Num_] = modelBus1_->getCurrentU(ModelBus::UPuType_);
  else
    calculatedVars_[u1Num_] = 0;
  if (modelBus2_)
    calculatedVars_[u2Num_] = modelBus2_->getCurrentU(ModelBus::UPuType_);
  else
    calculatedVars_[u2Num_] = 0;
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
ModelLine::urp1() const {
  double urp1 = 0.;
  if (modelBus1_)
    urp1 = modelBus1_->urp();
  return urp1;
}

double
ModelLine::uip1() const {
  double uip1 = 0.;
  if (modelBus1_)
    uip1 = modelBus1_->uip();
  return uip1;
}

double
ModelLine::urp2() const {
  double urp2 = 0.;
  if (modelBus2_)
    urp2 = modelBus2_->urp();
  return urp2;
}

double
ModelLine::uip2() const {
  double uip2 = 0.;
  if (modelBus2_)
    uip2 = modelBus2_->uip();
  return uip2;
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
ModelLine::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int> & numVars) const {
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
ModelLine::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;

  switch (numCalculatedVar) {
  case i1Num_:
  case iS1ToS2Side1Num_:
  case iS2ToS1Side1Num_:
  case iSide1Num_:
  case i2Num_:
  case iS2ToS1Side2Num_:
  case iS1ToS2Side2Num_:
  case iSide2Num_:
  case p1Num_:
  case p2Num_:
  case q1Num_:
  case q2Num_: {
    // in the y vector, we have access only at variables declared in getDefJCalculatedVarI
    switch (knownBus_) {
      case BUS1_BUS2: {
        ur1 = modelBus1_->ur();
        ui1 = modelBus1_->ui();
        ur2 = modelBus2_->ur();
        ui2 = modelBus2_->ui();
        break;
      }
      case BUS1: {
        ur1 = modelBus1_->ur();
        ui1 = modelBus1_->ui();
        break;
      }
      case BUS2: {
        ur2 = modelBus2_->ur();
        ui2 = modelBus2_->ui();
        break;
      }
    }
    break;
  }
  case u1Num_:
  case u2Num_:
  case lineStateNum_:
    break;
  default:
    throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
  double Ir1 = ir1(ur1, ui1, ur2, ui2);
  double Ii1 = ii1(ur1, ui1, ur2, ui2);
  double Ir2 = ir2(ur1, ui1, ur2, ui2);
  double Ii2 = ii2(ur1, ui1, ur2, ui2);

  bool closed1 = (getConnectionState() == CLOSED || getConnectionState() == CLOSED_1);
  bool closed2 = (getConnectionState() == CLOSED || getConnectionState() == CLOSED_2);

  switch (numCalculatedVar) {
    case i1Num_:
    case iS1ToS2Side1Num_:
    case iS2ToS1Side1Num_:
    case iSide1Num_: {
      double I1 = sqrt(Ii1 * Ii1 + Ir1 * Ir1);
      double factor = 1.;
      if (numCalculatedVar == iS1ToS2Side1Num_) {
        double P1 = Ir1 * ur1 + Ii1 * ui1;
        factor = sign(P1) * factorPuToA_;
      } else if (numCalculatedVar == iS2ToS1Side1Num_) {
        double P1 = Ir1 * ur1 + Ii1 * ui1;
        factor = sign(-1 * P1) * factorPuToA_;
      } else if (numCalculatedVar == iSide1Num_) {
        factor = factorPuToA_;
      }

      if (closed1 && !doubleIsZero(I1)) {
        res[0] = factor * (ii1_dUr1_ * Ii1 + ir1_dUr1_ * Ir1) / I1;   // dI1/dUr1
        res[1] = factor * (ii1_dUi1_ * Ii1 + ir1_dUi1_ * Ir1) / I1;   // dI1/dUi1
        res[2] = factor * (ii1_dUr2_ * Ii1 + ir1_dUr2_ * Ir1) / I1;   // dI1/dUr2
        res[3] = factor * (ii1_dUi2_ * Ii1 + ir1_dUi2_ * Ir1) / I1;   // dI1/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case i2Num_:
    case iS2ToS1Side2Num_:
    case iS1ToS2Side2Num_:
    case iSide2Num_: {
      double I2 = sqrt(Ii2 * Ii2 + Ir2 * Ir2);
      double factor = 1.;
      if (numCalculatedVar == iS2ToS1Side2Num_) {
        double P2 = ur2 * Ir2 + ui2 * Ii2;
        factor = sign(P2) * factorPuToA_;
      } else if (numCalculatedVar == iS1ToS2Side2Num_) {
        double P2 = ur2 * Ir2 + ui2 * Ii2;
        factor = sign(-1 * P2) * factorPuToA_;
      } else if (numCalculatedVar == iSide2Num_) {
        factor = factorPuToA_;
      }
      if (closed2 && !doubleIsZero(I2)) {
        res[0] = factor * (ii2_dUr1_ * Ii2 + ir2_dUr1_ * Ir2) / I2;   // dI2/dUr1
        res[1] = factor * (ii2_dUi1_ * Ii2 + ir2_dUi1_ * Ir2) / I2;   // dI2/dUi1
        res[2] = factor * (ii2_dUr2_ * Ii2 + ir2_dUr2_ * Ir2) / I2;   // dI2/dUr2
        res[3] = factor * (ii2_dUi2_ * Ii2 + ir2_dUi2_ * Ir2) / I2;   // dI2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case p1Num_: {
      if (closed1) {
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
      if (closed2) {
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
      if (closed1) {
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
      if (closed2) {
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
          ur1 = modelBus1_->ur();
          ui1 = modelBus1_->ui();
          break;
        case BUS2:
          break;
      }
      if (closed1) {
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
        case BUS2:
          ur2 = modelBus2_->ur();
          ui2 = modelBus2_->ui();
          break;
        case BUS1:
          break;
      }
      if (closed2) {
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
  }
}

double
ModelLine::evalCalculatedVarI(unsigned numCalculatedVar) const {
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;

  switch (numCalculatedVar) {
  case i1Num_:
  case iS1ToS2Side1Num_:
  case iS2ToS1Side1Num_:
  case iSide1Num_:
  case i2Num_:
  case iS2ToS1Side2Num_:
  case iS1ToS2Side2Num_:
  case iSide2Num_:
  case p1Num_:
  case p2Num_:
  case q1Num_:
  case q2Num_: {
    // in the y vector, we have access only at variables declared in getDefJCalculatedVarI
    switch (knownBus_) {
      case BUS1_BUS2: {
        ur1 = modelBus1_->ur();
        ui1 = modelBus1_->ui();
        ur2 = modelBus2_->ur();
        ui2 = modelBus2_->ui();
        break;
      }
      case BUS1: {
        ur1 = modelBus1_->ur();
        ui1 = modelBus1_->ui();
        break;
      }
      case BUS2: {
        ur2 = modelBus2_->ur();
        ui2 = modelBus2_->ui();
        break;
      }
    }
    break;
  }
  case u1Num_:
  case u2Num_:
  case lineStateNum_:
    break;
  default:
    throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
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
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_1) {
        output = modelBus1_->getCurrentU(ModelBus::UPuType_);
      }
    }
    break;
    case u2Num_: {
      if (getConnectionState() == CLOSED || getConnectionState() == CLOSED_2) {
        output = modelBus2_->getCurrentU(ModelBus::UPuType_);
      }
    }
    break;
    case lineStateNum_:
      output = connectionState_;
      break;
  }
  return output;
}

void
ModelLine::getY0() {
  if (!network_->isInitModel()) {
    if (isDynamic_) {
      y_[0] = ir01_;
      y_[1] = ii01_;
      y_[2] = 1;
      yp_[0] = 0;
      yp_[1] = 0;
      yp_[2] = 0;
    }
    z_[0] = getConnectionState();
    z_[1] = getCurrentLimitsDesactivate();
  }
}

NetworkComponent::StateChange_t
ModelLine::evalState(const double& /*time*/) {
  StateChange_t state = NetworkComponent::NO_CHANGE;
  if (topologyModified_) {
    state = NetworkComponent::TOPO_CHANGE;
    topologyModified_ = false;
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
ModelLine::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params) {
  bool success = false;
  double maxTimeOperation = getParameterDynamicNoThrow<double>(params, "line_currentLimit_maxTimeOperation", success);
  if (success) {
    if (currentLimits1_)
      currentLimits1_->setMaxTimeOperation(maxTimeOperation);
    if (currentLimits2_)
      currentLimits2_->setMaxTimeOperation(maxTimeOperation);
  }

  // isDynamic parameter
  success = false;
  bool isDynamic = getParameterDynamicNoThrow<bool>(params, "line_isDynamic", success);
  if (success) {
    isDynamic_ = isDynamic;
    if (isDynamic_ && getConnectionState() == CLOSED) {
      modelBus1_->setHasDifferentialVoltages(true);
      modelBus2_->setHasDifferentialVoltages(true);
    } else if (isDynamic_ && (getConnectionState() == CLOSED_1 || getConnectionState() == CLOSED_2)) {
        throw DYNError(Error::MODELER, DynamicLineStatusNotSupported, id_);
    }
  }
}

void
ModelLine::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("line_currentLimit_maxTimeOperation", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("line_isDynamic", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
}

void
ModelLine::defineNonGenericParameters(std::vector<ParameterModeler>& /*parameters*/) {
  /* no non generic parameter */
}
}  // namespace DYN
