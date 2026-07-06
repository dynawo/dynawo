// Copyright (c) 2015-2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/** @file  DYNModelLine.cpp */

#include <cmath>
#include <vector>
#include <cassert>
#include <iomanip>

#include <DYNTimer.h>

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

ModelLine::ModelLine(const std::shared_ptr<LineInterface>& line) :
ModelQuadripole(line->getID()),
dynBus1_(line->hasConnectionSide1()),
dynBus2_(line->hasConnectionSide2()),
omegaNom_(OMEGA_NOM),
omegaRef_(1.) {
  const double r = line->getR();
  const double x = line->getX();
  const double b1 = line->getB1();
  const double b2 = line->getB2();
  const double g1 = line->getG1();
  const double g2 = line->getG2();
  const bool connected1 = line->getInitialConnected1();
  const bool connected2 = line->getInitialConnected2();

  if      (connected1 && connected2)  connectionState_ = CLOSED;
  else if (connected1)                connectionState_ = CLOSED_1;
  else if (connected2)                connectionState_ = CLOSED_2;
  else                                connectionState_ = OPEN;

  double vNom = connected1 ? line->getVNom1() : line->getVNom2();
  assert(!std::isnan(vNom));

  // init data
  factorPuToA_ = 1000 * SNREF / (sqrt(3) * vNom);

  // R, X, G, B in SI units in IIDM
  const double coeff = vNom * vNom / SNREF;
  const double ad = 1. / hypot(r, x);
  const double ap = atan2(r, x);

  admittance_ = ad * coeff;
  lossAngle_ = ap;
  suscept1_ = b1 * coeff;
  suscept2_ = b2 * coeff;
  conduct1_ = g1 * coeff;
  conduct2_ = g2 * coeff;
  resistance_ = r / coeff;
  reactance_ = x / coeff;

  // current limits side 1
  const vector<std::unique_ptr<CurrentLimitInterface> >& cLimit1 = line->getCurrentLimitInterfaces1();
  if (cLimit1.size() > 0) {
    currentLimits1_.reset(new ModelCurrentLimits());
    currentLimits1_->setSide(ModelCurrentLimits::SIDE_1);
    currentLimits1_->setFactorPuToA(factorPuToA_);
    // Due to IIDM convention
    if (cLimit1[0]->getLimit() < maximumValueCurrentLimit) {
      const double limit = cLimit1[0]->getLimit() / factorPuToA_;
      currentLimits1_->addLimit(cLimit1[0]->getName(), limit, cLimit1[0]->getAcceptableDuration(), false);
    }
    for (unsigned int i = 1; i < cLimit1.size(); ++i) {
      if (cLimit1[i-1]->isFictitious()) continue;
      if (cLimit1[i-1]->getLimit() < maximumValueCurrentLimit) {
        const double limit = cLimit1[i-1]->getLimit() / factorPuToA_;
        currentLimits1_->addLimit(cLimit1[i]->getName(), limit, cLimit1[i]->getAcceptableDuration(), false);
      }
    }
    for (unsigned int i = 1; i < cLimit1.size(); ++i) {
      if (!cLimit1[i]->isFictitious()) continue;
      if (cLimit1[i]->getLimit() < maximumValueCurrentLimit) {
        const double limit = cLimit1[i]->getLimit() / factorPuToA_;
        currentLimits1_->addLimit(cLimit1[i]->getName(), limit, cLimit1[i]->getAcceptableDuration(), true);
      }
    }
  }

  // current limits side 2
  const vector<std::unique_ptr<CurrentLimitInterface> >& cLimit2 = line->getCurrentLimitInterfaces2();
  if (cLimit2.size() > 0) {
    currentLimits2_.reset(new ModelCurrentLimits());
    currentLimits2_->setSide(ModelCurrentLimits::SIDE_2);
    currentLimits2_->setFactorPuToA(factorPuToA_);
    // Due to IIDM convention
    if (cLimit2[0]->getLimit() < maximumValueCurrentLimit) {
      const double limit = cLimit2[0]->getLimit() / factorPuToA_;
      currentLimits2_->addLimit(cLimit2[0]->getName(), limit, cLimit2[0]->getAcceptableDuration(), false);
    }
    for (unsigned int i = 1; i < cLimit2.size(); ++i) {
      if (cLimit2[i-1]->isFictitious()) continue;
      if (cLimit2[i-1]->getLimit() < maximumValueCurrentLimit) {
        const double limit = cLimit2[i-1]->getLimit() / factorPuToA_;
        currentLimits2_->addLimit(cLimit2[i]->getName(), limit, cLimit2[i]->getAcceptableDuration(), false);
      }
    }
    for (unsigned int i = 1; i < cLimit2.size(); ++i) {
      if (!cLimit2[i]->isFictitious()) continue;
      if (cLimit2[i]->getLimit() < maximumValueCurrentLimit) {
        const double limit = cLimit2[i]->getLimit() / factorPuToA_;
        currentLimits2_->addLimit(cLimit2[i]->getName(), limit, cLimit2[i]->getAcceptableDuration(), true);
      }
    }
  }

  const double P01 = line->getP1() / SNREF;
  const double Q01 = line->getQ1() / SNREF;
  const double uNode1 = line->getBusInterface1()->getV0();
  const double thetaNode1 = line->getBusInterface1()->getAngle0();
  const double unomNode1 = line->getBusInterface1()->getVNom();
  const double ur01 = uNode1 / unomNode1 * cos(thetaNode1 * DEG_TO_RAD);
  const double ui01 = uNode1 / unomNode1 * sin(thetaNode1 * DEG_TO_RAD);
  const double U201 = ur01 * ur01 + ui01 * ui01;
  if (!doubleIsZero(U201)) {
    ir01_ = (P01 * ur01 + Q01 * ui01) / U201;
    ii01_ = (P01 * ui01 - Q01 * ur01) / U201;
  }

  const double P02 = line->getP2() / SNREF;
  const double Q02 = line->getQ2() / SNREF;
  const double uNode2 = line->getBusInterface2()->getV0();
  const double thetaNode2 = line->getBusInterface2()->getAngle0();
  const double unomNode2 = line->getBusInterface2()->getVNom();
  const double ur02 = uNode2 / unomNode2 * cos(thetaNode2 * DEG_TO_RAD);
  const double ui02 = uNode2 / unomNode2 * sin(thetaNode2 * DEG_TO_RAD);
  const double U202 = ur02 * ur02 + ui02 * ui02;
  if (!doubleIsZero(U202)) {
    ir02_ = (P02 * ur02 + Q02 * ui02) / U202;
    ii02_ = (P02 * ui02 - Q02 * ur02) / U202;
  }
}

void
ModelLine::initSize() {
  // initSize() may be called more than once even after init, so take care of resetting the various sizes and offset
  sizeF_ = 0;
  sizeY_ = 0;
  sizeZ_ = 0;
  sizeG_ = 0;
  sizeMode_ = 0;
  sizeCalculatedVar_ = 0;

  if (network_->isInitModel())
    return;

  if (dynBus1_) {
    sizeF_ += 2;
    sizeY_ += 4;  // V_re, V_im, i_re and i_im side 1
  }
  if (dynBus2_) {
    sizeF_ += 2;
    sizeY_ += 4;  // V_re, V_im, i_re and i_im side 2
  }
  if (dynLineModel_) {
    sizeF_ += 2;
    sizeY_ += 3;  // IBranch_re, IBranch_im, omegaRef
  }

  sizeZ_ = 2;
  sizeMode_ = 2;
  sizeCalculatedVar_ = nbCalculatedVariables_;

  if (currentLimits1_) {
    sizeZ_ += currentLimits1_->sizeZ();
    sizeG_ += currentLimits1_->sizeG();
    offsetGCl2_ = currentLimits1_->sizeG();
  }

  if (currentLimits2_) {
    sizeZ_ += currentLimits2_->sizeZ();
    sizeG_ += currentLimits2_->sizeG();
  }
}

void
ModelLine::init(int& yNum) {
  if (network_->isInitModel())
    return;

  assert(yNum >= 0);
  yOffset_ = yNum;
  int localIndex = 0;

  if (dynBus1_) {
    ur1YNum_ = localIndex++;
    ui1YNum_ = localIndex++;
    ir1YNum_ = localIndex++;
    ii1YNum_ = localIndex++;
    yNum += 4;
  }
  if (dynBus2_) {
    ur2YNum_ = localIndex++;
    ui2YNum_ = localIndex++;
    ir2YNum_ = localIndex++;
    ii2YNum_ = localIndex++;
    yNum += 4;
  }
  if (dynLineModel_) {
    irbYNum_ = localIndex++;
    iibYNum_ = localIndex++;
    omegaRefNum_ = localIndex++;
    yNum += 3;
  }
}

void
ModelLine::getY0() {
  if (network_->isInitModel())
    return;

  if (network_->isStartingFromDump() && internalVariablesFoundInDump_) {
    if (dynBus1_) {
      ir01_ = y_[ir1YNum_];
      ii01_ = y_[ii1YNum_];
    }
    if (dynBus2_) {
      ir02_ = y_[ir2YNum_];
      ii02_ = y_[ii2YNum_];
    }
    if (dynLineModel_) {
      ir01_ = y_[irbYNum_];
      ii01_ = y_[iibYNum_];
    }
    State currState = static_cast<State>(static_cast<int>(z_[0]));
    checkValidState(currState);
    setConnectionState(currState);
    setCurrentLimitsDesactivate(z_[1]);

    bool closed1 = isClosedSide1(currState);
    bool closed2 = isClosedSide2(currState);
    if ((closed1 != (modelBus1_->getConnectionState() == CLOSED)) || (closed2 != (modelBus2_->getConnectionState() == CLOSED))) {
      topologyModified_ = true;
      if ( closed1)  modelBus1_->getVoltageLevel()->connectNode(   modelBus1_->getBusIndex());
      if ( closed2)  modelBus2_->getVoltageLevel()->connectNode(   modelBus2_->getBusIndex());
      if (!closed1)  modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
      if (!closed2)  modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
    }

    return;
  }

  z_[0] = getConnectionState();
  z_[1] = getCurrentLimitsDesactivate();

  if (dynBus1_) {
    y_[ur1YNum_] = modelBus1_->ur();
    y_[ui1YNum_] = modelBus1_->ui();
    y_[ir1YNum_] = ir01_;
    y_[ii1YNum_] = ii01_;
  }
  if (dynBus2_) {
    y_[ur2YNum_] = modelBus2_->ur();
    y_[ui2YNum_] = modelBus2_->ui();
    y_[ir2YNum_] = ir02_;
    y_[ii2YNum_] = ii02_;
  }
  if (dynLineModel_) {
    y_[irbYNum_] = ir01_;
    y_[iibYNum_] = ii01_;
    y_[omegaRefNum_] = 1;
    yp_[irbYNum_] = 0;
    yp_[iibYNum_] = 0;
    yp_[omegaRefNum_] = 0;
  }
}

void
ModelLine::evalStaticYType() {
  if (network_->isInitModel())
    return;

  if (dynBus1_) {
    yType_[ur1YNum_] = ALGEBRAIC;
    yType_[ui1YNum_] = ALGEBRAIC;
    yType_[ir1YNum_] = ALGEBRAIC;
    yType_[ii1YNum_] = ALGEBRAIC;
  }
  if (dynBus2_) {
    yType_[ur2YNum_] = ALGEBRAIC;
    yType_[ui2YNum_] = ALGEBRAIC;
    yType_[ir2YNum_] = ALGEBRAIC;
    yType_[ii2YNum_] = ALGEBRAIC;
  }
  if (dynLineModel_)
    yType_[omegaRefNum_] = EXTERNAL;
}

void
ModelLine::evalDynamicYType() {
  if (network_->isInitModel())
    return;

  if (dynLineModel_) {
    bool closedLine = getConnectionState() == CLOSED;
    yType_[irbYNum_] = closedLine ? DIFFERENTIAL : ALGEBRAIC;
    yType_[iibYNum_] = closedLine ? DIFFERENTIAL : ALGEBRAIC;
  }
}

void
ModelLine::evalStaticFType() {
  if (network_->isInitModel())
    return;

  for (int eqYNum=0; eqYNum < 2*dynBus1_ + 2*dynBus2_; ++eqYNum)  // 2 algebraic eqs per dynamic bus
    fType_[eqYNum] = ALGEBRAIC_EQ;
}

void
ModelLine::evalDynamicFType() {
  if (network_->isInitModel())
    return;

  if (dynLineModel_) {
    bool closedLine = getConnectionState() == CLOSED;
    fType_[0] = closedLine ? DIFFERENTIAL_EQ : ALGEBRAIC_EQ;
    fType_[1] = closedLine ? DIFFERENTIAL_EQ : ALGEBRAIC_EQ;
  }
}

void
ModelLine::setFequations(std::map<int, std::string>& fEquationIndex) {
  int eqYNum = 0;
  if (dynBus1_) {
    fEquationIndex[eqYNum++] = id() + " - real part of the current side 1: Re(i1) = c1.1 * Re(U1) + c1.2 * Im(U1) + c1.3 * Re(U2) + c1.4 * Im(U2)";
    fEquationIndex[eqYNum++] = id() + " - imaginary part of the current side 1: Im(i1) = c2.1 * Re(U1) + c2.2 * Im(U1) + c2.3 * Re(U2) + c2.4 * Im(U2)";
  }
  if (dynBus2_) {
    fEquationIndex[eqYNum++] = id() + " - real part of the current side 2: Re(i2) = c3.1 * Re(U1) + c3.2 * Im(U1) + c3.3 * Re(U2) + c3.4 * Im(U2)";
    fEquationIndex[eqYNum++] = id() + " - imaginary part of the current side 2: Im(i2) = c4.1 * Re(U1) + c4.2 * Im(U1) + c4.3 * Re(U2) + c4.4 * Im(U2)";
  }
  if (dynLineModel_) {
    fEquationIndex[eqYNum++] = id() + " - branch re current: 0 = omegaNom * (Re(U1) - Re(U2) + L * omegaRef * Im(Ib) - R * Re(Ib)) - L * d(Re(Ib))/dt";
    fEquationIndex[eqYNum++] = id() + " - branch im current: 0 = omegaNom * (Im(U1) - Im(U2) - L * omegaRef * Re(Ib) - R * Im(Ib)) - L * d(Im(Ib))/dt";
  }
}

void
ModelLine::evalF(const propertyF_t type) {
  if (network_->isInitModel())
    return;

  int eqFNum = 0;
  if (dynBus1_) {
    f_[eqFNum++] = ir1_dUr1_ * ur1() + ir1_dUi1_ * ui1() + ir1_dUr2_ * ur2() + ir1_dUi2_ * ui2() - y_[ir1YNum_];
    f_[eqFNum++] = ii1_dUr1_ * ur1() + ii1_dUi1_ * ui1() + ii1_dUr2_ * ur2() + ii1_dUi2_ * ui2() - y_[ii1YNum_];
  }
  if (dynBus2_) {
    f_[eqFNum++] = ir2_dUr1_ * ur1() + ir2_dUi1_ * ui1() + ir2_dUr2_ * ur2() + ir2_dUi2_ * ui2() - y_[ir2YNum_];
    f_[eqFNum++] = ii2_dUr1_ * ur1() + ii2_dUi1_ * ui1() + ii2_dUr2_ * ur2() + ii2_dUi2_ * ui2() - y_[ii2YNum_];
  }

  if (!dynLineModel_)
    return;

  if (getConnectionState() != CLOSED) {
    if (type == DIFFERENTIAL_EQ)
      return;
    f_[eqFNum]   = y_[irbYNum_];
    f_[eqFNum+1] = y_[iibYNum_];
    return;
  }

  f_[eqFNum]   = -reactance_*yp_[irbYNum_] - omegaNom_*(resistance_*y_[irbYNum_]-reactance_*omegaRef_* y_[iibYNum_]) + omegaNom_*ur1() - omegaNom_*ur2();
  f_[eqFNum+1] = -reactance_*yp_[iibYNum_] - omegaNom_*(resistance_*y_[iibYNum_]+reactance_*omegaRef_* y_[irbYNum_]) + omegaNom_*ui1() - omegaNom_*ui2();
}

void
ModelLine::evalJt(const double cj, const int rowOffset, SparseMatrix& jt) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelLine::evalJt");
#endif
  if (network_->isInitModel())
    return;

  if (dynBus1_) {
    // 0 = ir1_dUr1_ * ur1 + ir1_dUi1_ * ui1 + ir1_dUr2_ * ur2 + ir1_dUi2_ * ui2 - ir1
    jt.changeCol();
    jt.addTerm(ur1YNumGlobal()        + rowOffset, ir1_dUr1_);
    jt.addTerm(ui1YNumGlobal()        + rowOffset, ir1_dUi1_);
    jt.addTerm(ur2YNumGlobal()        + rowOffset, ir1_dUr2_);
    jt.addTerm(ui2YNumGlobal()        + rowOffset, ir1_dUi2_);
    jt.addTerm(globalYIndex(ir1YNum_) + rowOffset, -1);

    // 0 = ii1_dUr1_ * ur1 + ii1_dUi1_ * ui1 + ii1_dUr2_ * ur2 + ii1_dUi2_ * ui2 - ii1
    jt.changeCol();
    jt.addTerm(ur1YNumGlobal()        + rowOffset, ii1_dUr1_);
    jt.addTerm(ui1YNumGlobal()        + rowOffset, ii1_dUi1_);
    jt.addTerm(ur2YNumGlobal()        + rowOffset, ii1_dUr2_);
    jt.addTerm(ui2YNumGlobal()        + rowOffset, ii1_dUi2_);
    jt.addTerm(globalYIndex(ii1YNum_) + rowOffset, -1);
  }

  if (dynBus2_) {
    // 0 = ir2_dUr1_ * ur1 + ir2_dUi1_ * ui1 + ir2_dUr2_ * ur2 + ir2_dUi2_ * ui2 - ir2
    jt.changeCol();
    jt.addTerm(ur1YNumGlobal()        + rowOffset, ir2_dUr1_);
    jt.addTerm(ui1YNumGlobal()        + rowOffset, ir2_dUi1_);
    jt.addTerm(ur2YNumGlobal()        + rowOffset, ir2_dUr2_);
    jt.addTerm(ui2YNumGlobal()        + rowOffset, ir2_dUi2_);
    jt.addTerm(globalYIndex(ir2YNum_) + rowOffset, -1);

    // 0 = ii2_dUr1_ * ur1 + ii2_dUi1_ * ui1 + ii2_dUr2_ * ur2 + ii2_dUi2_ * ui2 - ii2
    jt.changeCol();
    jt.addTerm(ur1YNumGlobal()        + rowOffset, ii2_dUr1_);
    jt.addTerm(ui1YNumGlobal()        + rowOffset, ii2_dUi1_);
    jt.addTerm(ur2YNumGlobal()        + rowOffset, ii2_dUr2_);
    jt.addTerm(ui2YNumGlobal()        + rowOffset, ii2_dUi2_);
    jt.addTerm(globalYIndex(ii2YNum_) + rowOffset, -1);
  }

  if (!dynLineModel_)
    return;

  const int irbYNumGlobal = globalYIndex(irbYNum_);
  const int iibYNumGlobal = globalYIndex(iibYNum_);

  if (getConnectionState() != CLOSED) {
    jt.changeCol();
    jt.addTerm(irbYNumGlobal + rowOffset, 1);
    jt.changeCol();
    jt.addTerm(iibYNumGlobal + rowOffset, 1);
    return;
  }

  // column for equation IBranch_re
  jt.changeCol();
  jt.addTerm(irbYNumGlobal + rowOffset, - omegaNom_ * resistance_ - cj * reactance_);
  jt.addTerm(iibYNumGlobal + rowOffset, omegaNom_ * reactance_ * omegaRef_);
  jt.addTerm(ur1YNumGlobal() + rowOffset, omegaNom_);
  jt.addTerm(ur2YNumGlobal() + rowOffset, -omegaNom_);

  // column for equation IBranch_im
  jt.changeCol();
  jt.addTerm(irbYNumGlobal + rowOffset, - omegaNom_ * reactance_ * omegaRef_);
  jt.addTerm(iibYNumGlobal + rowOffset, -omegaNom_ * resistance_ - cj * reactance_);
  jt.addTerm(ui1YNumGlobal() + rowOffset, omegaNom_);
  jt.addTerm(ui2YNumGlobal() + rowOffset, -omegaNom_);
}

void
ModelLine::evalJtPrim(const int rowOffset, SparseMatrix& jtPrim) {
  if (network_->isInitModel())
    return;

  if (dynBus1_) {
    jtPrim.changeCol();
    jtPrim.changeCol();
  }

  if (dynBus2_) {
    jtPrim.changeCol();
    jtPrim.changeCol();
  }

  if (dynLineModel_ && (getConnectionState() == CLOSED)) {
    jtPrim.changeCol();
    jtPrim.addTerm(globalYIndex(irbYNum_) + rowOffset, - reactance_);  // column for equation IBranch_re
    jtPrim.changeCol();
    jtPrim.addTerm(globalYIndex(iibYNum_) + rowOffset, - reactance_);  // column for equation IBranch_im
  }
}

void
ModelLine::evalNodeInjection() {
  if (network_->isInitModel()) {
    if (!dynBus1_) {
      modelBus1_->irAdd(ir01_);
      modelBus1_->iiAdd(ii01_);
    }
    if (!dynBus2_) {
      modelBus2_->irAdd(ir02_);
      modelBus2_->iiAdd(ii02_);
    }
    return;
  }

  const double ur1Val = ur1();
  const double ui1Val = ui1();
  const double ur2Val = ur2();
  const double ui2Val = ui2();

  if (!dynBus1_) {
    modelBus1_->irAdd(ir1(ur1Val, ui1Val, ur2Val, ui2Val));
    modelBus1_->iiAdd(ii1(ur1Val, ui1Val, ur2Val, ui2Val));
  }
  if (!dynBus2_) {
    modelBus2_->irAdd(ir2(ur1Val, ui1Val, ur2Val, ui2Val));
    modelBus2_->iiAdd(ii2(ur1Val, ui1Val, ur2Val, ui2Val));
  }
  if (dynLineModel_) {
    if (getConnectionState() != CLOSED)
      return;
    modelBus1_->irAdd(conduct1_ * ur1Val + suscept1_ * urp1() / omegaNom_ - suscept1_ * omegaRef_ * ui1Val + y_[irbYNum_]);
    modelBus1_->iiAdd(conduct1_ * ui1Val + suscept1_ * uip1() / omegaNom_ + suscept1_ * omegaRef_ * ur1Val + y_[iibYNum_]);
    modelBus2_->irAdd(conduct2_ * ur2Val + suscept2_ * urp2() / omegaNom_ - suscept2_ * omegaRef_ * ui2Val - y_[irbYNum_]);
    modelBus2_->iiAdd(conduct2_ * ui2Val + suscept2_ * uip2() / omegaNom_ + suscept2_ * omegaRef_ * ur2Val - y_[iibYNum_]);
  }
}

void
ModelLine::evalDerivatives(const double cj) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer3("ModelNetwork::ModelLine::evalDerivatives");
#endif
  if (dynLineModel_) {
    if (getConnectionState() != CLOSED)
      return;

    const double ir1_dUr1 = conduct1_ + cj * suscept1_ / omegaNom_;
    const double ir1_dUi1 = - omegaRef_ * suscept1_;
    constexpr double ir1_dIbr = 1.;
    const double ii1_dUr1 = conduct1_ + cj * suscept1_ / omegaNom_;
    const double ii1_dUi1 = omegaRef_ * suscept1_;
    constexpr double ii1_dIbi = 1.;
    const double ir2_dUr2 = conduct2_ + cj * suscept2_ / omegaNom_;
    const double ir2_dUi2 = - omegaRef_ * suscept2_;
    constexpr double ir2_dIbr = -1.;
    const double ii2_dUr2 = conduct2_ + cj * suscept2_ / omegaNom_;
    const double ii2_dUi2 = omegaRef_ * suscept2_;
    constexpr double ii2_dIbi = -1.;

    auto& modelBus1 = *modelBus1_;
    auto& derivatives1 = *modelBus1.derivatives();
    auto& irDerivatives1 = derivatives1.getDerivatives(IR_DERIVATIVE);
    auto& iiDerivatives1 = derivatives1.getDerivatives(II_DERIVATIVE);

    auto& modelBus2 = *modelBus2_;
    auto& derivatives2 = *modelBus2.derivatives();
    auto& irDerivatives2 = derivatives2.getDerivatives(IR_DERIVATIVE);
    auto& iiDerivatives2 = derivatives2.getDerivatives(II_DERIVATIVE);

    irDerivatives1.addValue(ur1YNumGlobal(),        ir1_dUr1);
    irDerivatives1.addValue(ui1YNumGlobal(),        ir1_dUi1);
    irDerivatives1.addValue(globalYIndex(irbYNum_), ir1_dIbr);
    iiDerivatives1.addValue(ur1YNumGlobal(),        ii1_dUr1);
    iiDerivatives1.addValue(ui1YNumGlobal(),        ii1_dUi1);
    iiDerivatives1.addValue(globalYIndex(iibYNum_), ii1_dIbi);

    irDerivatives2.addValue(ur2YNumGlobal(),        ir2_dUr2);
    irDerivatives2.addValue(ur2YNumGlobal(),        ir2_dUi2);
    irDerivatives2.addValue(globalYIndex(irbYNum_), ir2_dIbr);
    iiDerivatives2.addValue(ui2YNumGlobal(),        ii2_dUr2);
    iiDerivatives2.addValue(ui2YNumGlobal(),        ii2_dUi2);
    iiDerivatives2.addValue(globalYIndex(iibYNum_), ii2_dIbi);
    return;
  }

  if (!dynBus1_) {
    auto & irDerivatives1 = modelBus1_->derivatives()->getDerivatives(IR_DERIVATIVE);
    irDerivatives1.addValue(ur1YNumGlobal(), ir1_dUr1_);
    irDerivatives1.addValue(ui1YNumGlobal(), ir1_dUi1_);
    irDerivatives1.addValue(ur2YNumGlobal(), ir1_dUr2_);
    irDerivatives1.addValue(ui2YNumGlobal(), ir1_dUi2_);

    auto & iiDerivatives1 = modelBus1_->derivatives()->getDerivatives(II_DERIVATIVE);
    iiDerivatives1.addValue(ur1YNumGlobal(), ii1_dUr1_);
    iiDerivatives1.addValue(ui1YNumGlobal(), ii1_dUi1_);
    iiDerivatives1.addValue(ur2YNumGlobal(), ii1_dUr2_);
    iiDerivatives1.addValue(ui2YNumGlobal(), ii1_dUi2_);
  }

  if (!dynBus2_) {
    auto & irDerivatives2 = modelBus2_->derivatives()->getDerivatives(IR_DERIVATIVE);
    irDerivatives2.addValue(ur1YNumGlobal(), ir2_dUr1_);
    irDerivatives2.addValue(ui1YNumGlobal(), ir2_dUi1_);
    irDerivatives2.addValue(ur2YNumGlobal(), ir2_dUr2_);
    irDerivatives2.addValue(ui2YNumGlobal(), ir2_dUi2_);

    auto & iiDerivatives2 = modelBus2_->derivatives()->getDerivatives(II_DERIVATIVE);
    iiDerivatives2.addValue(ur1YNumGlobal(), ii2_dUr1_);
    iiDerivatives2.addValue(ui1YNumGlobal(), ii2_dUi1_);
    iiDerivatives2.addValue(ur2YNumGlobal(), ii2_dUr2_);
    iiDerivatives2.addValue(ui2YNumGlobal(), ii2_dUi2_);
  }
}

void
ModelLine::evalDerivativesPrim() {
  if (!dynLineModel_)
    return;

  if (getConnectionState() != CLOSED)
    return;

  auto& derivativesPrim1 = modelBus1_->derivativesPrim();
  derivativesPrim1->addDerivative(IR_DERIVATIVE, ur1YNumGlobal(), suscept1_ / omegaNom_);
  derivativesPrim1->addDerivative(II_DERIVATIVE, ui1YNumGlobal(), suscept1_ / omegaNom_);

  auto& derivativesPrim2 = modelBus2_->derivativesPrim();
  derivativesPrim2->addDerivative(IR_DERIVATIVE, ur2YNumGlobal(), suscept2_ / omegaNom_);
  derivativesPrim2->addDerivative(II_DERIVATIVE, ui2YNumGlobal(), suscept2_ / omegaNom_);
}

void
ModelLine::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN1_V_re", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN1_V_im", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN1_i_re", FLOW));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN1_i_im", FLOW));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN2_V_re", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN2_V_im", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN2_i_re", FLOW));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN2_i_im", FLOW));
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
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState("@ID@_desactivate_currentLimits_value", BOOLEAN));
}

void
ModelLine::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  if (dynBus1_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN1_V_re", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN1_V_im", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN1_i_re", FLOW));
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN1_i_im", FLOW));
  }
  if (dynBus2_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN2_V_re", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN2_V_im", CONTINUOUS));
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN2_i_re", FLOW));
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN2_i_im", FLOW));
  }
  if (dynLineModel_) {
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
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState(id_ + "_desactivate_currentLimits_value", BOOLEAN));
}

void
ModelLine::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  if (dynBus1_) {
    const string ACName = id_ + string("_ACPIN1");
    const string ACNameV = id_ + string("_ACPIN1_V");
    const string ACNameI = id_ + string("_ACPIN1_i");
    addElement(ACName, Element::STRUCTURE, elements, mapElement);
    addSubElement("V", ACName, Element::STRUCTURE, id_, "Line", elements, mapElement);
    addSubElement("re", ACNameV, Element::TERMINAL, id_, "Line", elements, mapElement);
    addSubElement("im", ACNameV, Element::TERMINAL, id_, "Line", elements, mapElement);
    addSubElement("i", ACName, Element::STRUCTURE, id_, "Line", elements, mapElement);
    addSubElement("re", ACNameI, Element::TERMINAL, id_, "Line", elements, mapElement);
    addSubElement("im", ACNameI, Element::TERMINAL, id_, "Line", elements, mapElement);
  }
  if (dynBus2_) {
    const string ACName = id_ + string("_ACPIN2");
    const string ACNameV = id_ + string("_ACPIN2_V");
    const string ACNameI = id_ + string("_ACPIN2_i");
    addElement(ACName, Element::STRUCTURE, elements, mapElement);
    addSubElement("V", ACName, Element::STRUCTURE, id_, "Line", elements, mapElement);
    addSubElement("re", ACNameV, Element::TERMINAL, id_, "Line", elements, mapElement);
    addSubElement("im", ACNameV, Element::TERMINAL, id_, "Line", elements, mapElement);
    addSubElement("i", ACName, Element::STRUCTURE, id_, "Line", elements, mapElement);
    addSubElement("re", ACNameI, Element::TERMINAL, id_, "Line", elements, mapElement);
    addSubElement("im", ACNameI, Element::TERMINAL, id_, "Line", elements, mapElement);
  }
  if (dynLineModel_) {
    const string name = id_ + string("_iBranch");
    addElement(name, Element::STRUCTURE, elements, mapElement);
    addSubElement("re", name, Element::TERMINAL, id(), "Line", elements, mapElement);
    addSubElement("im", name, Element::TERMINAL, id(), "Line", elements, mapElement);
    addElementWithValue(id_ + string("_omegaRef"), "Line", elements, mapElement);
  }
  addElementWithValue(id_ + string("_i1"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_i2"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_P1"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_P2"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_Q1"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_Q2"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_iS1ToS2Side1"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_iS2ToS1Side1"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_iS1ToS2Side2"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_iS2ToS1Side2"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_iSide1"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_iSide2"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_U1"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_U2"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_lineState"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_state"), "Line", elements, mapElement);
  addElementWithValue(id_ + string("_desactivate_currentLimits"), "Line", elements, mapElement);
}

#define CL_ACTIVE(currentLimits, gOffset) (currentLimits && \
  (currentLimits->evalZ(id(), t, &g_[gOffset], currentLimitsDesactivate_, "Line", network_) == ModelCurrentLimits::COMPONENT_OPEN))

NetworkComponent::StateChange_t
ModelLine::evalZ(const double t) {
  State currState = getConnectionState();
  checkValidState(currState);

  if (currState != OPEN) {
    if (CL_ACTIVE(currentLimits1_, 0) || CL_ACTIVE(currentLimits2_, offsetGCl2_))  z_[0] = OPEN;
    if (isClosedSide1(currState) && (modelBus1_->getConnectionState() == OPEN))    z_[0] = (static_cast<State>(z_[0]) == CLOSED) ? CLOSED_2 : OPEN;
    if (isClosedSide2(currState) && (modelBus2_->getConnectionState() == OPEN))    z_[0] = (static_cast<State>(z_[0]) == CLOSED) ? CLOSED_1 : OPEN;
  }

  State newState = static_cast<State>(static_cast<int>(z_[0]));
  checkValidState(newState);
  if (newState != currState) {
    if      ( isClosedSide1(newState) && !isClosedSide1(currState))   modelBus1_->getVoltageLevel()->connectNode(   modelBus1_->getBusIndex());
    else if (!isClosedSide1(newState) &&  isClosedSide1(currState))   modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
    if      ( isClosedSide2(newState) && !isClosedSide2(currState))   modelBus2_->getVoltageLevel()->connectNode(   modelBus2_->getBusIndex());
    else if (!isClosedSide2(newState) &&  isClosedSide2(currState))   modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());

    if      ((newState == CLOSED)     && (currState == OPEN))         DYNAddTimelineEvent(network_, id_, LineClosed);
    else if ( isClosedSide1(newState) && !isClosedSide1(currState))   DYNAddTimelineEvent(network_, id_, LineCloseSide1);
    else if ( isClosedSide2(newState) && !isClosedSide2(currState))   DYNAddTimelineEvent(network_, id_, LineCloseSide2);

    if      ((newState == OPEN)       && (currState == CLOSED))       DYNAddTimelineEvent(network_, id_, LineOpen);
    else if (!isClosedSide1(newState) &&  isClosedSide1(currState))   DYNAddTimelineEvent(network_, id_, LineOpenSide1);
    else if (!isClosedSide2(newState) &&  isClosedSide2(currState))   DYNAddTimelineEvent(network_, id_, LineOpenSide2);

    setConnectionState(newState);
    updateYMat_ = true;
    topologyModified_ = true;
    Trace::info() << DYNLog(LineStateChange, id_, currState, newState) << Trace::endline;
  }

  if (doubleNotEquals(z_[1], getCurrentLimitsDesactivate())) {
    setCurrentLimitsDesactivate(z_[1]);
    Trace::debug() << DYNLog(DeactivateCurrentLimits, id_) << Trace::endline;
  }

  return topologyModified_ ? TOPO_CHANGE : NO_CHANGE;
}

#undef CL_ACTIVE

void
ModelLine::collectSilentZ(BitMask* silentZTable) {
  silentZTable[0].setFlags(NotUsedInDiscreteEquations);
  silentZTable[1].setFlags(NotUsedInDiscreteEquations);
}

void
ModelLine::evalG(const double t) {
  if (network_->isInitModel())
    return;

  if (currentLimits1_)
    currentLimits1_->evalG(t, evalCalculatedVarI(i1Num_), currentLimitsDesactivate_, &g_[0]);

  if (currentLimits2_)
    currentLimits2_->evalG(t, evalCalculatedVarI(i2Num_), currentLimitsDesactivate_, &g_[offsetGCl2_]);
}

void
ModelLine::setGequations(std::map<int, std::string>& gEquationIndex) {
  if (currentLimits1_) {
    for (int i = 0; i < currentLimits1_->sizeG(); ++i)
      gEquationIndex[i] = "Model Line "+ id()+" : current limit 1.";
  }

  if (currentLimits2_) {
    for (int i = 0; i < currentLimits2_->sizeG(); ++i)
      gEquationIndex[i + offsetGCl2_] = "Model Line "+ id()+" : current limit 2.";
  }

  assert(gEquationIndex.size() == static_cast<size_t>(sizeG_) && "ModelLine: gEquationIndex.size() != sizeG_");
}

void
ModelLine::evalCalculatedVars() {
  const double ur1Val = ur1();
  const double ui1Val = ui1();
  const double ur2Val = ur2();
  const double ui2Val = ui2();
  const double ir1Val = ir1(ur1Val, ui1Val, ur2Val, ui2Val);
  const double ii1Val = ii1(ur1Val, ui1Val, ur2Val, ui2Val);
  const double ir2Val = ir2(ur1Val, ui1Val, ur2Val, ui2Val);
  const double ii2Val = ii2(ur1Val, ui1Val, ur2Val, ui2Val);

  calculatedVars_[u1Num_] = hypot(ur1Val, ui1Val);  // Voltage amplitude side 1
  calculatedVars_[u2Num_] = hypot(ur2Val, ui2Val);  // Voltage amplitude side 2
  calculatedVars_[i1Num_] = hypot(ir1Val, ii1Val);  // Current amplitude side 1
  calculatedVars_[i2Num_] = hypot(ir2Val, ii2Val);  // Current amplitude side 2
  calculatedVars_[p1Num_] = ur1Val * ir1Val + ui1Val * ii1Val;        // Active power side 1
  calculatedVars_[p2Num_] = ur2Val * ir2Val + ui2Val * ii2Val;        // Active power side 2
  calculatedVars_[q1Num_] = ir1Val * ui1Val - ii1Val * ur1Val;        // Reactive power side 1
  calculatedVars_[q2Num_] = ir2Val * ui2Val - ii2Val * ur2Val;        // Reactive power side 2
  calculatedVars_[iS1ToS2Side1Num_] = sign(calculatedVars_[p1Num_]) * calculatedVars_[i1Num_] * factorPuToA_;
  calculatedVars_[iS2ToS1Side1Num_] = -calculatedVars_[iS1ToS2Side1Num_];
  calculatedVars_[iS2ToS1Side2Num_] = sign(calculatedVars_[p2Num_]) * calculatedVars_[i2Num_] * factorPuToA_;
  calculatedVars_[iS1ToS2Side2Num_] = -calculatedVars_[iS2ToS1Side2Num_];
  calculatedVars_[iSide1Num_] = std::abs(calculatedVars_[iS1ToS2Side1Num_]);
  calculatedVars_[iSide2Num_] = std::abs(calculatedVars_[iS1ToS2Side2Num_]);
  calculatedVars_[lineStateNum_] = connectionState_;
}

int
ModelLine::varSide(unsigned i) const {
  if (i == i1Num_)           return 1;
  if (i == i2Num_)           return 2;
  if (i == p1Num_)           return 1;
  if (i == p2Num_)           return 2;
  if (i == q1Num_)           return 1;
  if (i == q2Num_)           return 2;

  if (i == iS1ToS2Side1Num_) return 1;
  if (i == iS2ToS1Side1Num_) return 1;
  if (i == iSide1Num_)       return 1;
  if (i == iS2ToS1Side2Num_) return 2;
  if (i == iS1ToS2Side2Num_) return 2;
  if (i == iSide2Num_)       return 2;

  return 0;
}

double
ModelLine::evalCalculatedVarI(unsigned i) const {
  if (i == lineStateNum_)
    return connectionState_;

  double ur1Val = ur1();
  double ui1Val = ui1();
  if (i == u1Num_)
    return hypot(ur1Val, ui1Val);  // Voltage amplitude side 1

  double ur2Val = ur2();
  double ui2Val = ui2();
  if (i == u2Num_)
    return hypot(ur2Val, ui2Val);  // Voltage amplitude side 2

  // variables side 1, requiring i only this side
  if (varSide(i) == 1) {
    double ir1Val = ir1(ur1Val, ui1Val, ur2Val, ui2Val);
    double ii1Val = ii1(ur1Val, ui1Val, ur2Val, ui2Val);

    if (i == p1Num_)
      return ur1Val * ir1Val + ui1Val * ii1Val;  // Active power side 1

    if (i == q1Num_)
      return ir1Val * ui1Val - ii1Val * ur1Val;  // Reactive power side 1

    double i1Val = hypot(ir1Val, ii1Val);
    if (i == i1Num_)
      return i1Val;  // Current side 1

    double i1ValA = i1Val * factorPuToA_;
    if (i == iSide1Num_)
      return i1ValA;

    double i121 = sign(ur1Val * ir1Val + ui1Val * ii1Val) * i1ValA;
    if (i == iS1ToS2Side1Num_)
      return i121;
    if (i == iS2ToS1Side1Num_)
      return -i121;
  }

  // variables side 2, requiring i only this side
  if (varSide(i) == 2) {
    double ir2Val = ir2(ur1Val, ui1Val, ur2Val, ui2Val);
    double ii2Val = ii2(ur1Val, ui1Val, ur2Val, ui2Val);

    if (i == p2Num_)
      return ur2Val * ir2Val + ui2Val * ii2Val;  // Active power side 2

    if (i == q2Num_)
      return ir2Val * ui2Val - ii2Val * ur2Val;  // Reactive power side 2

    double i2Val = hypot(ir2Val, ii2Val);
    if (i == i2Num_)
      return i2Val;  // Current side 2

    double i2ValA = i2Val * factorPuToA_;
    if (i == iSide2Num_)
      return i2ValA;

    double i212 = sign(ur2Val * ir2Val + ui2Val * ii2Val) * i2ValA;
    if (i == iS2ToS1Side2Num_)
      return i212;
    if (i == iS1ToS2Side2Num_)
      return -i212;
  }

  throw DYNError(Error::MODELER, UndefCalculatedVarI, i);
}

void
ModelLine::getIndexesOfVariablesUsedForCalculatedVarI(unsigned i, vector<int> & numVars) const {
  bool needU1 = false, needU2 = false;
  switch (i) {
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
      needU1 = true;
      needU2 = true;
      break;
    }
    case u1Num_: {
      needU1 = true;
      break;
    }
    case u2Num_: {
      needU2 = true;
      break;
    }
    case lineStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, i);
  }
  if (needU1) {
    numVars.push_back(ur1YNumGlobal());
    numVars.push_back(ui1YNumGlobal());
  }
  if (needU2) {
    numVars.push_back(ur2YNumGlobal());
    numVars.push_back(ui2YNumGlobal());
  }
}

void
ModelLine::evalJCalculatedVarI(unsigned i, vector<double>& res) const {
  if (i >= nbCalculatedVariables_)
    throw DYNError(Error::MODELER, UndefJCalculatedVarI, i);

  if (i == lineStateNum_)
    return;

  if (i == u1Num_) {
    double U1 = evalCalculatedVarI(u1Num_);
    res[0] = (doubleIsZero(U1)) ? 0 : ur1() / U1;  // dU1/dUr1
    res[1] = (doubleIsZero(U1)) ? 0 : ui1() / U1;  // dU1/dUi1
    return;
  }

  if (i == u2Num_) {
    double U2 = evalCalculatedVarI(u2Num_);
    res[0] = (doubleIsZero(U2)) ? 0 : ur2() / U2;  // dU2/dUr2
    res[1] = (doubleIsZero(U2)) ? 0 : ui2() / U2;  // dU2/dUi2
    return;
  }

  res[0] = 0.;
  res[1] = 0.;
  res[2] = 0.;
  res[3] = 0.;

  if (((varSide(i) == 1) && !isClosedSide1(getConnectionState())) || ((varSide(i) == 2) && !isClosedSide2(getConnectionState())))
    return;

  double ur1Val = ur1();
  double ui1Val = ui1();
  double ur2Val = ur2();
  double ui2Val = ui2();

  if (varSide(i) == 1) {
    double ir1Val = ir1(ur1Val, ui1Val, ur2Val, ui2Val);
    double ii1Val = ii1(ur1Val, ui1Val, ur2Val, ui2Val);

    if (i == p1Num_) {
      res[0] = ir1Val + ur1Val * ir1_dUr1_ +          ui1Val * ii1_dUr1_;  // dP1/dUr1
      res[1] =          ur1Val * ir1_dUi1_ + ii1Val + ui1Val * ii1_dUi1_;  // dP1/dUi1
      res[2] =          ur1Val * ir1_dUr2_ +          ui1Val * ii1_dUr2_;  // dP1/dUr2
      res[3] =          ur1Val * ir1_dUi2_ +          ui1Val * ii1_dUi2_;  // dP1/dUi2
      return;
    }

    if (i == q1Num_) {
      res[0] =          ui1Val * ir1_dUr1_ - ii1Val - ur1Val * ii1_dUr1_;  // dQ1/dUr1
      res[1] = ir1Val + ui1Val * ir1_dUi1_          - ur1Val * ii1_dUi1_;  // dQ1/dUi1
      res[2] =          ui1Val * ir1_dUr2_          - ur1Val * ii1_dUr2_;  // dQ1/dUr2
      res[3] =          ui1Val * ir1_dUi2_          - ur1Val * ii1_dUi2_;  // dQ1/dUi2
      return;
    }

    // i1Num_, iSide1Num_, iS1ToS2Side1Num_ and iS2ToS1Side1Num_ left
    double i1Val = hypot(ir1Val, ii1Val);
    if (doubleIsZero(i1Val))
      return;

    double factor = 1.;
    if (i != i1Num_) {
      factor *= factorPuToA_;
      if (i != iSide1Num_)
        factor *= sign(ur1Val * ir1Val + ui1Val * ii1Val);  // sign(P1)
      if (i == iS2ToS1Side1Num_)
        factor *= -1;
    }

    res[0] = factor * (ii1_dUr1_ * ii1Val + ir1_dUr1_ * ir1Val) / i1Val;   // di1/dUr1
    res[1] = factor * (ii1_dUi1_ * ii1Val + ir1_dUi1_ * ir1Val) / i1Val;   // di1/dUi1
    res[2] = factor * (ii1_dUr2_ * ii1Val + ir1_dUr2_ * ir1Val) / i1Val;   // di1/dUr2
    res[3] = factor * (ii1_dUi2_ * ii1Val + ir1_dUi2_ * ir1Val) / i1Val;   // di1/dUi2
  }

  if (varSide(i) == 2) {
    double ir2Val = ir2(ur1Val, ui1Val, ur2Val, ui2Val);
    double ii2Val = ii2(ur1Val, ui1Val, ur2Val, ui2Val);

    if (i == p2Num_) {
      res[0] =          ur2Val * ir2_dUr1_ + ui2Val *          ii2_dUr1_;  // dP2/dUr1
      res[1] =          ur2Val * ir2_dUi1_ + ui2Val *          ii2_dUi1_;  // dP2/dUi1
      res[2] = ir2Val + ur2Val * ir2_dUr2_ + ui2Val *          ii2_dUr2_;  // dP2/dUr2
      res[3] =          ur2Val * ir2_dUi2_ + ii2Val + ui2Val * ii2_dUi2_;  // dP2/dUi2
      return;
    }

    if (i == q2Num_) {
      res[0] =          ui2Val * ir2_dUr1_          - ur2Val * ii2_dUr1_;  // dQ2/dUr1
      res[1] =          ui2Val * ir2_dUi1_          - ur2Val * ii2_dUi1_;  // dQ2/dUi1
      res[2] =          ui2Val * ir2_dUr2_ - ii2Val - ur2Val * ii2_dUr2_;  // dQ2/dUr2
      res[3] = ir2Val + ui2Val * ir2_dUi2_          - ur2Val * ii2_dUi2_;  // dQ2/dUi2
      return;
    }

    // i2Num_, iSide2Num_, iS2ToS1Side2Num_ or iS1ToS2Side2Num_ left
    double i2Val = hypot(ir2Val, ii2Val);
    if (doubleIsZero(i2Val))
      return;

    double factor = 1.;
    if (i != i2Num_) {
      factor *= factorPuToA_;
      if (i != iSide2Num_)
        factor *= sign(ur2Val * ir2Val + ui2Val * ii2Val);  // sign(P2)
      if (i == iS1ToS2Side2Num_)
        factor *= -1;
    }

    res[0] = factor * (ii2_dUr1_ * ii2Val + ir2_dUr1_ * ir2Val) / i2Val;   // dI2/dUr1
    res[1] = factor * (ii2_dUi1_ * ii2Val + ir2_dUi1_ * ir2Val) / i2Val;   // dI2/dUi1
    res[2] = factor * (ii2_dUr2_ * ii2Val + ir2_dUr2_ * ir2Val) / i2Val;   // dI2/dUr2
    res[3] = factor * (ii2_dUi2_ * ii2Val + ir2_dUi2_ * ir2Val) / i2Val;   // dI2/dUi2
  }
}

NetworkComponent::StateChange_t
ModelLine::evalState(const double /*time*/) {
  if (topologyModified_) {
    topologyModified_ = false;
    return NetworkComponent::TOPO_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelLine::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  ModelCPP::dumpInStream(streamVariables, ir01_);
  ModelCPP::dumpInStream(streamVariables, ii01_);
  ModelCPP::dumpInStream(streamVariables, ir02_);
  ModelCPP::dumpInStream(streamVariables, ii02_);
}

void
ModelLine::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> ir01_;
  streamVariables >> c;
  streamVariables >> ii01_;
  streamVariables >> c;
  streamVariables >> ir02_;
  streamVariables >> c;
  streamVariables >> ii02_;
}

void
ModelLine::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  bool success = false;
  const double maxTimeOperation = getParameterDynamicNoThrow<double>(params, "line_currentLimit_maxTimeOperation", success);
  if (success) {
    if (currentLimits1_)
      currentLimits1_->setMaxTimeOperation(maxTimeOperation);
    if (currentLimits2_)
      currentLimits2_->setMaxTimeOperation(maxTimeOperation);
  }

  success = false;
  const bool isDynamic = getParameterDynamicNoThrow<bool>(params, "line_isDynamic", success);
  if (success)
    dynLineModel_ = isDynamic;

  if (dynLineModel_) {
    if ((getConnectionState() == CLOSED_1) || (getConnectionState() == CLOSED_2))
      throw DYNError(Error::MODELER, DynamicLineStatusNotSupported, id_);

    if (dynBus1_ || dynBus2_)
      throw DYNError(Error::MODELER, DynamicLineStatusNotSupported2, id_);

    modelBus1_->setHasDifferentialVoltages(true);
    modelBus2_->setHasDifferentialVoltages(true);
  }
}

void
ModelLine::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("line_currentLimit_maxTimeOperation", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("line_isDynamic", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
}

void
ModelLine::printInternalParameters(std::ofstream& fstream) const {
  std::string paramName = id() + "_" + "admittance";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << admittance_ << std::endl;
  paramName = id() + "_" + "lossAngle";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << lossAngle_ << std::endl;
  paramName = id() + "_" + "suscept1";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << suscept1_ << std::endl;
  paramName = id() + "_" + "suscept2";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << suscept2_ << std::endl;
  paramName = id() + "_" + "conduct1";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << conduct1_ << std::endl;
  paramName = id() + "_" + "conduct2";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << conduct2_ << std::endl;
  paramName = id() + "_" + "resistance";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << resistance_ << std::endl;
  paramName = id() + "_" + "reactance";
  fstream << std::setw(50) << std::left << paramName << std::right << " =" << std::setw(15) << reactance_ << std::endl;
}

double
ModelLine::ur1() const {
  if (dynBus1_)
    return y_[ur1YNum_];
    // return network_->isInit() ? 1. : y_[ur1YNum_];

  if (isClosedSide1(getConnectionState()))
    return modelBus1_->ur();

  return 0.;
}

double
ModelLine::ui1() const {
  if (dynBus1_)
    return y_[ui1YNum_];
    // return network_->isInit() ? 0. : y_[ui1YNum_];

  if (isClosedSide1(getConnectionState()))
    return modelBus1_->ui();

  return 0.;
}

double
ModelLine::ur2() const {
  if (dynBus2_)
    return y_[ur2YNum_];
    // return network_->isInit() ? 1. : y_[ur2YNum_];

  if (isClosedSide2(getConnectionState()))
    return modelBus2_->ur();

  return 0.;
}

double
ModelLine::ui2() const {
  if (dynBus2_)
    return y_[ui2YNum_];
    // return network_->isInit() ? 0. : y_[ui2YNum_];

  if (isClosedSide2(getConnectionState()))
    return modelBus2_->ui();

  return 0.;
}

double
ModelLine::urp1() const {
  if (isClosedSide1(getConnectionState()))
    return modelBus1_->urp();
  return 0.;
}

double
ModelLine::uip1() const {
  if (isClosedSide1(getConnectionState()))
    return modelBus1_->uip();
  return 0.;
}

double
ModelLine::urp2() const {
  if (isClosedSide2(getConnectionState()))
    return modelBus2_->urp();
  return 0.;
}

double
ModelLine::uip2() const {
  if (isClosedSide2(getConnectionState()))
    return modelBus2_->uip();
  return 0.;
}

int
ModelLine::ur1YNumGlobal() const {
  if (dynBus1_)
    return globalYIndex(ur1YNum_);
  return modelBus1_->urYNum();
}

int
ModelLine::ui1YNumGlobal() const {
  if (dynBus1_)
    return globalYIndex(ui1YNum_);
  return modelBus1_->uiYNum();
}

int
ModelLine::ur2YNumGlobal() const {
  if (dynBus2_)
    return globalYIndex(ur2YNum_);
  return modelBus2_->urYNum();
}

int
ModelLine::ui2YNumGlobal() const {
  if (dynBus2_)
    return globalYIndex(ui2YNum_);
  return modelBus2_->uiYNum();
}

double
ModelLine::ir1(const double ur1, const double ui1, const double ur2, const double ui2) const {
  return ir1_dUr1_ * ur1 + ir1_dUi1_ * ui1 + ir1_dUr2_ * ur2 + ir1_dUi2_ * ui2;
}

double
ModelLine::ii1(const double ur1, const double ui1, const double ur2, const double ui2) const {
  return ii1_dUr1_ * ur1 + ii1_dUi1_ * ui1 + ii1_dUr2_ * ur2 + ii1_dUi2_ * ui2;
}

double
ModelLine::ir2(const double ur1, const double ui1, const double ur2, const double ui2) const {
  return ir2_dUr1_ * ur1 + ir2_dUi1_ * ui1 + ir2_dUr2_ * ur2 + ir2_dUi2_ * ui2;
}

double
ModelLine::ii2(const double ur1, const double ui1, const double ur2, const double ui2) const {
  return ii2_dUr1_ * ur1 + ii2_dUi1_ * ui1 + ii2_dUr2_ * ur2 + ii2_dUi2_ * ui2;
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
ModelLine::ir1_dUr1() const {
  double ir1_dUr1 = 0.;
  if (getConnectionState() == CLOSED) {
    const double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ir1_dUr1 = G1;
  } else if (getConnectionState() == CLOSED_1) {
    const double G = admittance_ * sin(lossAngle_) + conduct2_;
    const double B = suscept2_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double GT = conduct1_ + 1. / denom * (admittance_ * admittance_ * conduct2_
      + admittance_ * sin(lossAngle_) * (conduct2_ * conduct2_ + suscept2_ * suscept2_));
    ir1_dUr1 = GT;
  }

  return ir1_dUr1;
}

double
ModelLine::ir1_dUi1() const {
  double ir1_dUi1 = 0.;
  if (getConnectionState() == CLOSED) {
    const double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ir1_dUi1 = -B1;
  } else if (getConnectionState() == CLOSED_1) {
    const double G = admittance_ * sin(lossAngle_) + conduct2_;
    const double B = suscept2_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double BT = suscept1_ + 1. / denom * (admittance_ * admittance_ * suscept2_
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
    const double B1 = suscept1_ - admittance_ * cos(lossAngle_);
    ii1_dUr1 = B1;
  } else if (getConnectionState() == CLOSED_1) {
    const double G = admittance_ * sin(lossAngle_) + conduct2_;
    const double B = suscept2_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double BT = suscept1_ + 1. / denom * (admittance_ * admittance_ * suscept2_
      - admittance_ * cos(lossAngle_) * (conduct2_ * conduct2_ + suscept2_ * suscept2_));
    ii1_dUr1 = BT;
  }
  return ii1_dUr1;
}

double
ModelLine::ii1_dUi1() const {
  double ii1_dUi1 = 0.;
  if (getConnectionState() == CLOSED) {
    const double G1 = admittance_ * sin(lossAngle_) + conduct1_;
    ii1_dUi1 = G1;
  } else if (getConnectionState() == CLOSED_1) {
    const double G = admittance_ * sin(lossAngle_) + conduct2_;
    const double B = suscept2_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double GT = conduct1_ + 1. / denom * (admittance_ * admittance_ * conduct2_
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
    const double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ir2_dUr2 = G2;
  } else if (getConnectionState() == CLOSED_2) {
    const double G = admittance_ * sin(lossAngle_) + conduct1_;
    const double B = suscept1_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double GT = conduct2_ + 1. / denom * (admittance_ * admittance_ * conduct1_
      + admittance_ * sin(lossAngle_) * (conduct1_ * conduct1_ + suscept1_ * suscept1_));
    ir2_dUr2 = GT;
  }
  return ir2_dUr2;
}

double
ModelLine::ir2_dUi2() const {
  double ir2_dUi2 = 0.;
  if (getConnectionState() == CLOSED) {
    const double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ir2_dUi2 = -B2;
  } else if (getConnectionState() == CLOSED_2) {
    const double G = admittance_ * sin(lossAngle_) + conduct1_;
    const double B = suscept1_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double BT = suscept2_ + 1. / denom * (admittance_ * admittance_ * suscept1_
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
    const double B2 = suscept2_ - admittance_ * cos(lossAngle_);
    ii2_dUr2 = B2;
  } else if (getConnectionState() == CLOSED_2) {
    const double G = admittance_ * sin(lossAngle_) + conduct1_;
    const double B = suscept1_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double BT = suscept2_ + 1. / denom * (admittance_ * admittance_ * suscept1_
      - admittance_ * cos(lossAngle_) * (conduct1_ * conduct1_ + suscept1_ * suscept1_));
    ii2_dUr2 = BT;
  }
  return ii2_dUr2;
}

double
ModelLine::ii2_dUi2() const {
  double ii2_dUi2 = 0.;
  if (getConnectionState() == CLOSED) {
    const double G2 = conduct2_ + admittance_ * sin(lossAngle_);
    ii2_dUi2 = G2;
  } else if (getConnectionState() == CLOSED_2) {
    const double G = admittance_ * sin(lossAngle_) + conduct1_;
    const double B = suscept1_ - admittance_ * cos(lossAngle_);
    const double denom = G * G + B * B;

    const double GT = conduct2_ + 1. / denom * (admittance_ * admittance_ * conduct1_
      + admittance_ * sin(lossAngle_)*(conduct1_ * conduct1_ + suscept1_ * suscept1_));
    ii2_dUi2 = GT;
  }
  return ii2_dUi2;
}

void
ModelLine::checkValidState(State state) const {
  if (state == CLOSED_3)          throw DYNError(Error::MODELER, NoThirdSide, id_);
  if (state == UNDEFINED_STATE)   throw DYNError(Error::MODELER, UndefinedComponentState, id_);
  if (dynLineModel_ &&  ((state == CLOSED_1) || (state == CLOSED_2)))
    throw DYNError(Error::MODELER, DynamicLineStatusNotSupported, id_);
}

}  // namespace DYN
