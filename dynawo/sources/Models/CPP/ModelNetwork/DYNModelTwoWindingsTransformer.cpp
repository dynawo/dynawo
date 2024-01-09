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
 * @file  DYNModelTwoWindingsTransformer.cpp
 *
 * @brief  describes two winding transformers
 * The equivalent π model used is:
 *
 * 1                            2
 * o-----ρejα-----+-----r+jx-----o
 *                |
 *               g+jb
 *                |
 *                v
 *
 * b, g, r, x shall be specified at the side 2 voltage.
 */
#include <cmath>
#include <cassert>
#include "PARParametersSet.h"

#include "DYNModelTwoWindingsTransformer.h"
#include "DYNCommon.h"
#include "DYNModelRatioTapChanger.h"
#include "DYNModelPhaseTapChanger.h"
#include "DYNModelTapChanger.h"
#include "DYNModelBus.h"
#include "DYNModelCurrentLimits.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNCurrentLimitInterface.h"
#include "DYNStepInterface.h"
#include "DYNPhaseTapChangerInterface.h"
#include "DYNRatioTapChangerInterface.h"
#include "DYNBusInterface.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNMessageTimeline.h"
#include "DYNModelVoltageLevel.h"

using parameters::ParametersSet;

using std::vector;
using std::string;
using std::map;
using boost::shared_ptr;

namespace DYN {

ModelTwoWindingsTransformer::ModelTwoWindingsTransformer(const shared_ptr<TwoWTransformerInterface>& tfo) :
NetworkComponent(tfo->getID()),
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
topologyModified_(false),
stateIndexModified_(false),
updateYMat_(true),
tapChangerIndex_(0),
modelType_("TwoWindingsTransformer") {
  // init data
  // ---------

  // state
  bool connected1 = tfo->getInitialConnected1();
  bool connected2 = tfo->getInitialConnected2();

  vNom1_ = std::numeric_limits<double>::quiet_NaN();
  vNom2_ = std::numeric_limits<double>::quiet_NaN();
  if (connected1 && connected2) {
    connectionState_ = CLOSED;
    vNom1_ = tfo->getVNom1();
    vNom2_ = tfo->getVNom2();
  } else if (connected1) {
    connectionState_ = CLOSED_1;
    vNom1_ = tfo->getVNom1();
    if (tfo->getBusInterface2()) {
      vNom2_ = tfo->getVNom2();
    } else {
      vNom2_ = tfo->getRatedU2();  // bus2 is unknown, so for the per unit we decided to use the ratedU2, not correct but better than nothing
    }
  } else if (connected2) {
    connectionState_ = CLOSED_2;
    vNom2_ = tfo->getVNom2();
    if (tfo->getBusInterface1()) {
      vNom1_ = tfo->getVNom1();
    } else {
      vNom1_ = tfo->getRatedU1();  // bus1 is unknown, so for the per unit we decided to use the ratedU2, not correct but better than nothing
    }
  } else {
    connectionState_ = OPEN;  // should not happened, filtered by model network
    if (tfo->getBusInterface1()) {
      vNom1_ = tfo->getBusInterface1()->getVNom();
    } else {
      vNom1_ = tfo->getRatedU1();  // bus1 is unknown, so for the per unit we decided to use the ratedU2, not correct but better than nothing
    }

    if (tfo->getBusInterface2()) {
      vNom2_ = tfo->getBusInterface2()->getVNom();
    } else {
      vNom2_ = tfo->getRatedU2();  // bus2 is unknown, so for the per unit we decided to use the ratedU2, not correct but better than nothing
    }
    assert(!std::isnan(vNom1_));  // control that vNom != NAN
    assert(!std::isnan(vNom2_));  // control that vNom != NAN
  }

  if (tfo->getBusInterface1() && tfo->getBusInterface2())
    knownBus_ = BUS1_BUS2;
  else if (tfo->getBusInterface1())
    knownBus_ = BUS1;
  else
    knownBus_ = BUS2;

  currentLimitsDesactivate_ = 0.;
  disableInternalTapChanger_ = 0.;
  tapChangerLocked_ = 0.;

  // tap changer and tap init
  double coeff = vNom2_ * vNom2_ / SNREF;  // PU with respect to the secondary voltage
  double ratio = tfo->getRatedU2() / tfo->getRatedU1() * vNom1_ / vNom2_;

  shared_ptr<PhaseTapChangerInterface> phaseTapChanger = tfo->getPhaseTapChanger();
  shared_ptr<RatioTapChangerInterface> ratioTapChanger = tfo->getRatioTapChanger();
  double r = tfo->getR() / coeff;
  double x = tfo->getX() / coeff;
  double g = tfo->getG() * coeff;
  double b = tfo->getB() * coeff;

  if (phaseTapChanger) {
    const int lowIndex = phaseTapChanger->getLowPosition();
    modelPhaseChanger_.reset(new ModelPhaseTapChanger(tfo->getID(), lowIndex));

    vector<shared_ptr<StepInterface> > steps = phaseTapChanger->getSteps();
    double rTapChanger = ratioTapChanger ? ratioTapChanger->getCurrentR() / 100. : 0.;
    double xTapChanger = ratioTapChanger ? ratioTapChanger->getCurrentX() / 100. : 0.;
    double bTapChanger = ratioTapChanger ? ratioTapChanger->getCurrentB() / 100. : 0.;
    double gTapChanger = ratioTapChanger ? ratioTapChanger->getCurrentG() / 100. : 0.;
    double rhoTapChanger = ratioTapChanger ? ratioTapChanger->getCurrentRho() : 1;
    for (unsigned int i = 0; i < steps.size(); ++i) {
      double rho = ratio * rhoTapChanger * steps[i]->getRho();
      double phaseShift = steps[i]->getAlpha() * DEG_TO_RAD;
      double rTap = r * (1. + rTapChanger + steps[i]->getR() / 100.);
      double xTap = x * (1. + xTapChanger + steps[i]->getX() / 100.);
      double gTap = g * (1. + gTapChanger + steps[i]->getG() / 100.);
      double bTap = b * (1. + bTapChanger + steps[i]->getB() / 100.);
      modelPhaseChanger_->addStep(TapChangerStep(rho, phaseShift, rTap, xTap, gTap, bTap));
    }
    modelPhaseChanger_->setHighStepIndex(phaseTapChanger->getNbTap() + lowIndex - 1);
    modelPhaseChanger_->setCurrentStepIndex(phaseTapChanger->getCurrentPosition());

    // At the moment, only current regulation is supported.
    bool regulating = phaseTapChanger->isCurrentLimiter() && phaseTapChanger->getRegulating();
    double thresholdI = phaseTapChanger->getRegulationValue();
    modelPhaseChanger_->setRegulating(regulating);
    modelPhaseChanger_->setThresholdI(thresholdI);
  } else if (ratioTapChanger) {
    if (tfo->getRatioTapChanger()->hasLoadTapChangingCapabilities() && tfo->getRatioTapChanger()->getTerminalRefSide() != "") {
      const int lowIndex = ratioTapChanger->getLowPosition();
      modelRatioChanger_.reset(new ModelRatioTapChanger(tfo->getID(), tfo->getRatioTapChanger()->getTerminalRefSide(), lowIndex));

      terminalRefId_ = tfo->getRatioTapChanger()->getTerminalRefId();
      side_ = tfo->getRatioTapChanger()->getTerminalRefSide();
      vector<shared_ptr<StepInterface> > steps = ratioTapChanger->getSteps();
      for (unsigned int i = 0; i < steps.size(); ++i) {
        double rho = ratio * steps[i]->getRho();
        double rTap = r * (1. + steps[i]->getR() / 100.);
        double xTap = x * (1. + steps[i]->getX() / 100.);
        double gTap = g * (1. + steps[i]->getG() / 100.);
        double bTap = b * (1. + steps[i]->getB() / 100.);
        modelRatioChanger_->addStep(TapChangerStep(rho, 0, rTap, xTap, gTap, bTap));
      }
      modelRatioChanger_->setHighStepIndex(ratioTapChanger->getNbTap() + lowIndex - 1);
      modelRatioChanger_->setCurrentStepIndex(ratioTapChanger->getCurrentPosition());

      bool regulating = ratioTapChanger->getRegulating();
      double targetV = ratioTapChanger->getTargetV();
      modelRatioChanger_->setRegulating(regulating);
      modelRatioChanger_->setTargetV(targetV);
    } else {
      const int currentStepIndex = ratioTapChanger->getCurrentPosition();
      modelTapChanger_.reset(new ModelTapChanger(tfo->getID(), currentStepIndex));
      vector<shared_ptr<StepInterface> > steps = ratioTapChanger->getSteps();
      // The steps law begins at 0 while the lowIndex could have another value.
      int indexInSteps = currentStepIndex - ratioTapChanger->getLowPosition();
      double rho = ratio * steps[indexInSteps]->getRho();
      double rTap = r * (1. + steps[indexInSteps]->getR() / 100.);
      double xTap = x * (1. + steps[indexInSteps]->getX() / 100.);
      double gTap = g * (1. + steps[indexInSteps]->getG() / 100.);
      double bTap = b * (1. + steps[indexInSteps]->getB() / 100.);
      modelTapChanger_->addStep(TapChangerStep(rho, 0, rTap, xTap, gTap, bTap));
      modelTapChanger_->setHighStepIndex(currentStepIndex);
      modelTapChanger_->setCurrentStepIndex(currentStepIndex);
    }
  } else {
    // create default ratio changer
    modelTapChanger_.reset(new ModelTapChanger(tfo->getID(), 0));
    modelTapChanger_->addStep(TapChangerStep(ratio, 0, r, x, g, b));
    modelTapChanger_->setHighStepIndex(0);
    modelTapChanger_->setCurrentStepIndex(0);
    modelTapChanger_->setFictitious(true);
  }

  factorPuToASide1_ = 1000. * SNREF / (sqrt(3.) * vNom1_);
  factorPuToASide2_ = 1000. * SNREF / (sqrt(3.) * vNom2_);

  // current limits side 1
  vector<shared_ptr<CurrentLimitInterface> > cLimit1 = tfo->getCurrentLimitInterfaces1();
  if (cLimit1.size() > 0) {
    currentLimits1_.reset(new ModelCurrentLimits());
    currentLimits1_->setSide(ModelCurrentLimits::SIDE_1);
    currentLimits1_->setFactorPuToA(factorPuToASide1_);
    // Due to IIDM convention
    if (cLimit1[0]->getLimit() < maximumValueCurrentLimit) {
      double limit = cLimit1[0]->getLimit() / factorPuToASide1_;
      currentLimits1_->addLimit(limit, cLimit1[0]->getAcceptableDuration());
    }
    for (unsigned int i = 1; i < cLimit1.size(); ++i) {
      if (cLimit1[i-1]->getLimit() < maximumValueCurrentLimit) {
        double limit = cLimit1[i-1]->getLimit() / factorPuToASide1_;
        currentLimits1_->addLimit(limit, cLimit1[i]->getAcceptableDuration());
      }
    }
  }

  // current limits side 2
  vector<shared_ptr<CurrentLimitInterface> > cLimit2 = tfo->getCurrentLimitInterfaces2();
  if (cLimit2.size() > 0) {
    currentLimits2_.reset(new ModelCurrentLimits());
    currentLimits2_->setSide(ModelCurrentLimits::SIDE_2);
    currentLimits2_->setFactorPuToA(factorPuToASide2_);
    // Due to IIDM convention
    if (cLimit2[0]->getLimit() < maximumValueCurrentLimit) {
      double limit = cLimit2[0]->getLimit() / factorPuToASide2_;
      currentLimits2_->addLimit(limit, cLimit2[0]->getAcceptableDuration());
    }
    for (unsigned int i = 1; i < cLimit2.size(); ++i) {
      if (cLimit2[i-1]->getLimit() < maximumValueCurrentLimit) {
        double limit = cLimit2[i-1]->getLimit() / factorPuToASide2_;
        currentLimits2_->addLimit(limit, cLimit2[i]->getAcceptableDuration());
      }
    }
  }

  ir01_ = 0;
  ii01_ = 0;
  if (tfo->getBusInterface1()) {
    double P01 = tfo->getP1() / SNREF;
    double Q01 = tfo->getQ1() / SNREF;
    double uNode1 = tfo->getBusInterface1()->getV0();
    double thetaNode1 = tfo->getBusInterface1()->getAngle0();
    double unomNode1 = tfo->getBusInterface1()->getVNom();
    double ur01 = uNode1 / unomNode1 * cos(thetaNode1 * DEG_TO_RAD);
    double ui01 = uNode1 / unomNode1 * sin(thetaNode1 * DEG_TO_RAD);
    double U201 = ur01 * ur01 + ui01 * ui01;
    if (!doubleIsZero(U201)) {
      ir01_ = (P01 * ur01 + Q01 * ui01) / U201;
      ii01_ = (P01 * ui01 - Q01 * ur01) / U201;
    }
  }

  ir02_ = 0;
  ii02_ = 0;
  if (tfo->getBusInterface2()) {
    double P02 = tfo->getP2() / SNREF;
    double Q02 = tfo->getQ2() / SNREF;
    double uNode2 = tfo->getBusInterface2()->getV0();
    double thetaNode2 = tfo->getBusInterface2()->getAngle0();
    double unomNode2 = tfo->getBusInterface2()->getVNom();
    double ur02 = uNode2 / unomNode2 * cos(thetaNode2 * DEG_TO_RAD);
    double ui02 = uNode2 / unomNode2 * sin(thetaNode2 * DEG_TO_RAD);
    double U202 = ur02 * ur02 + ui02 * ui02;
    if (!doubleIsZero(U202)) {
      ir02_ = (P02 * ur02 + Q02 * ui02) / U202;
      ii02_ = (P02 * ui02 - Q02 * ur02) / U202;
    }
  }
}

void
ModelTwoWindingsTransformer::initSize() {
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
    sizeZ_ = 3;
    sizeG_ = 0;
    sizeMode_ = 3;
    sizeCalculatedVar_ = nbCalculatedVariables_;

    if (currentLimits1_) {
      sizeZ_ += currentLimits1_->sizeZ();
      sizeG_ += currentLimits1_->sizeG();
    }

    if (currentLimits2_) {
      sizeZ_ += currentLimits2_->sizeZ();
      sizeG_ += currentLimits2_->sizeG();
    }

    sizeZ_ += 3;  // add tap changer locked variable, disable_internal_tapChanger and deltaUTarget

    if (modelRatioChanger_) {
      sizeG_ += modelRatioChanger_->sizeG();
      sizeZ_ += modelRatioChanger_->sizeZ();
    }

    if (modelPhaseChanger_) {
      sizeG_ += modelPhaseChanger_->sizeG();
      sizeZ_ += modelPhaseChanger_->sizeZ();
    }
  }
}

void
ModelTwoWindingsTransformer::evalYMat() {
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

void
ModelTwoWindingsTransformer::init(int& /*yNum*/) {
  // not needed
}

void
ModelTwoWindingsTransformer::evalJt(SparseMatrix& /*jt*/, const double& /*cj*/, const int& /*rowOffset*/) {
  // not needed
}

void
ModelTwoWindingsTransformer::evalJtPrim(SparseMatrix& /*jt*/, const int& /*rowOffset*/) {
  // not needed
}

void
ModelTwoWindingsTransformer::defineNonGenericParameters(std::vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(id_ + "_t1st_THT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_tNext_THT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_t1st_HT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(id_ + "_tNext_HT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelTwoWindingsTransformer::setFequations(std::map<int, std::string>& /*fEquationIndex*/) {
  // not needed
}

void
ModelTwoWindingsTransformer::evalNodeInjection() {
  if ( network_->isInitModel() ) {
    if (modelBus1_) {
      modelBus1_->irAdd(ir01_);
      modelBus1_->iiAdd(ii01_);
    }
    if (modelBus2_) {
      modelBus2_->irAdd(ir02_);
      modelBus2_->iiAdd(ii02_);
    }
  } else {
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
  }
}

double
ModelTwoWindingsTransformer::ir1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ir1_dUr1_ * ur1 + ir1_dUi1_ * ui1 + ir1_dUr2_ * ur2 + ir1_dUi2_ * ui2;
}

double
ModelTwoWindingsTransformer::ii1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ii1_dUr1_ * ur1 + ii1_dUi1_ * ui1 + ii1_dUr2_ * ur2 + ii1_dUi2_ * ui2;
}

double
ModelTwoWindingsTransformer::ir2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ir2_dUr1_ * ur1 + ir2_dUi1_ * ui1 + ir2_dUr2_ * ur2 + ir2_dUi2_ * ui2;
}

double
ModelTwoWindingsTransformer::ii2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  return ii2_dUr1_ * ur1 + ii2_dUi1_ * ui1 + ii2_dUr2_ * ur2 + ii2_dUi2_ * ui2;
}

void
ModelTwoWindingsTransformer::setCurrentStepIndex(const int& stepIndex) {
  if (modelRatioChanger_)
    modelRatioChanger_->setCurrentStepIndex(stepIndex);
  else if (modelPhaseChanger_)
    modelPhaseChanger_->setCurrentStepIndex(stepIndex);
  else
    modelTapChanger_->setCurrentStepIndex(stepIndex);
}

int
ModelTwoWindingsTransformer::getCurrentStepIndex() const {
  if (modelRatioChanger_)
    return modelRatioChanger_->getCurrentStepIndex();
  else if (modelPhaseChanger_)
    return modelPhaseChanger_->getCurrentStepIndex();
  else
    return modelTapChanger_->getCurrentStepIndex();
}

double
ModelTwoWindingsTransformer::getRho() const {
  if (modelRatioChanger_)
    return modelRatioChanger_->getCurrentStep().getRho();
  else if (modelPhaseChanger_)
    return modelPhaseChanger_->getCurrentStep().getRho();
  else
    return modelTapChanger_->getCurrentStep().getRho();
}

double
ModelTwoWindingsTransformer::getAlpha() const {
  if (modelRatioChanger_)
    return modelRatioChanger_->getCurrentStep().getAlpha();
  else if (modelPhaseChanger_)
    return modelPhaseChanger_->getCurrentStep().getAlpha();
  else
    return modelTapChanger_->getCurrentStep().getAlpha();
}

double
ModelTwoWindingsTransformer::getR() const {
  if (modelRatioChanger_)
    return modelRatioChanger_->getCurrentStep().getR();
  else if (modelPhaseChanger_)
    return modelPhaseChanger_->getCurrentStep().getR();
  else
    return modelTapChanger_->getCurrentStep().getR();
}

double
ModelTwoWindingsTransformer::getX() const {
  if (modelRatioChanger_)
    return modelRatioChanger_->getCurrentStep().getX();
  else if (modelPhaseChanger_)
    return modelPhaseChanger_->getCurrentStep().getX();
  else
    return modelTapChanger_->getCurrentStep().getX();
}

double
ModelTwoWindingsTransformer::getB() const {
  if (modelRatioChanger_)
    return modelRatioChanger_->getCurrentStep().getB();
  else if (modelPhaseChanger_)
    return modelPhaseChanger_->getCurrentStep().getB();
  else
    return modelTapChanger_->getCurrentStep().getB();
}

double
ModelTwoWindingsTransformer::getG() const {
  if (modelRatioChanger_)
    return modelRatioChanger_->getCurrentStep().getG();
  else if (modelPhaseChanger_)
    return modelPhaseChanger_->getCurrentStep().getG();
  else
    return modelTapChanger_->getCurrentStep().getG();
}

double
ModelTwoWindingsTransformer::ir1_dUr1() const {
  double ir1_dUr1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double r = getR();
  double x = getX();
  double g = getG();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    double G1 = admittance * sin(lossAngle) + g;
    ir1_dUr1 = rho * rho * G1;
  } else if (getConnectionState() == CLOSED_1) {
    ir1_dUr1 = rho * rho * g;
  }
  return ir1_dUr1;
}

double
ModelTwoWindingsTransformer::ir1_dUi1() const {
  double ir1_dUi1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double r = getR();
  double x = getX();
  double b = getB();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    double B1 = b - admittance * cos(lossAngle);
    ir1_dUi1 = -rho * rho * B1;
  } else if (getConnectionState() == CLOSED_1) {
    ir1_dUi1 = -rho * rho*b;
  }
  return ir1_dUi1;
}

double
ModelTwoWindingsTransformer::ir1_dUr2() const {
  double ir1_dUr2 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ir1_dUr2 = -rho * admittance * sin(lossAngle - alpha);
  }
  return ir1_dUr2;
}

double
ModelTwoWindingsTransformer::ir1_dUi2() const {
  double ir1_dUi2 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();


  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ir1_dUi2 = -rho * admittance * cos(lossAngle - alpha);
  }
  return ir1_dUi2;
}

double
ModelTwoWindingsTransformer::ii1_dUr1() const {
  double ii1_dUr1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double r = getR();
  double x = getX();
  double b = getB();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    double B1 = b - admittance * cos(lossAngle);
    ii1_dUr1 = rho * rho * B1;
  } else if (getConnectionState() == CLOSED_1) {
    ii1_dUr1 = rho * rho * b;
  }
  return ii1_dUr1;
}

double
ModelTwoWindingsTransformer::ii1_dUi1() const {
  double ii1_dUi1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double r = getR();
  double x = getX();
  double g = getG();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    double G1 = admittance * sin(lossAngle) + g;
    ii1_dUi1 = rho * rho * G1;
  } else if (getConnectionState() == CLOSED_1) {
    ii1_dUi1 = rho * rho * g;
  }

  return ii1_dUi1;
}

double
ModelTwoWindingsTransformer::ii1_dUr2() const {
  double ii1_dUr2 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ii1_dUr2 = rho * admittance * cos(lossAngle - alpha);
  }
  return ii1_dUr2;
}

double
ModelTwoWindingsTransformer::ii1_dUi2() const {
  double ii1_dUi2 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ii1_dUi2 = -rho * admittance * sin(lossAngle - alpha);
  }
  return ii1_dUi2;
}

double
ModelTwoWindingsTransformer::ir2_dUr1() const {
  double ir2_dUr1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ir2_dUr1 = -rho * admittance * sin(alpha + lossAngle);
  }
  return ir2_dUr1;
}

double
ModelTwoWindingsTransformer::ir2_dUi1() const {
  double ir2_dUi1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ir2_dUi1 = -rho * admittance * cos(alpha + lossAngle);
  }
  return ir2_dUi1;
}

double
ModelTwoWindingsTransformer::ir2_dUr2() const {
  double ir2_dUr2 = 0.;

  // Get infos from current step
  double r = getR();
  double x = getX();
  double g = getG();
  double b = getB();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ir2_dUr2 = admittance * sin(lossAngle);
  } else if (getConnectionState() == CLOSED_2) {
    double G = admittance * sin(lossAngle) + g;
    double B = b - admittance * cos(lossAngle);
    double denom = G * G + B * B;

    double GT = 1. / denom * (admittance * admittance * g + (admittance * sin(lossAngle) * (g * g + b * b)));

    ir2_dUr2 = GT;
  }
  return ir2_dUr2;
}

double
ModelTwoWindingsTransformer::ir2_dUi2() const {
  double ir2_dUi2 = 0.;

  // Get infos from current step
  double r = getR();
  double x = getX();
  double g = getG();
  double b = getB();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ir2_dUi2 = admittance * cos(lossAngle);
  } else if (getConnectionState() == CLOSED_2) {
    double G = admittance * sin(lossAngle) + g;
    double B = b - admittance * cos(lossAngle);
    double denom = G * G + B * B;

    double BT = 1. / denom * (admittance * admittance * b - admittance * cos(lossAngle) * (g * g + b * b));
    ir2_dUi2 = -BT;
  }
  return ir2_dUi2;
}

double
ModelTwoWindingsTransformer::ii2_dUr1() const {
  double ii2_dUr1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ii2_dUr1 = rho * admittance * cos(alpha + lossAngle);
  }
  return ii2_dUr1;
}

double
ModelTwoWindingsTransformer::ii2_dUi1() const {
  double ii2_dUi1 = 0.;

  // Get infos from current step
  double rho = getRho();
  double alpha = getAlpha();
  double r = getR();
  double x = getX();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ii2_dUi1 = -rho * admittance * sin(alpha + lossAngle);
  }
  return ii2_dUi1;
}

double
ModelTwoWindingsTransformer::ii2_dUr2() const {
  double ii2_dUr2 = 0.;

  // Get infos from current step
  double r = getR();
  double x = getX();
  double g = getG();
  double b = getB();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ii2_dUr2 = -admittance * cos(lossAngle);
  } else if (getConnectionState() == CLOSED_2) {
    double G = admittance * sin(lossAngle) + g;
    double B = b - admittance * cos(lossAngle);
    double denom = G * G + B * B;

    double BT = 1. / denom * (admittance * admittance * b - admittance * cos(lossAngle) * (g * g + b * b));

    ii2_dUr2 = BT;
  }
  return ii2_dUr2;
}

double
ModelTwoWindingsTransformer::ii2_dUi2() const {
  double ii2_dUi2 = 0.;

  // Get infos from current step
  double r = getR();
  double x = getX();
  double g = getG();
  double b = getB();

  double admittance = 1. / sqrt(r * r + x * x);
  double lossAngle = atan2(r, x);
  if (getConnectionState() == CLOSED) {
    ii2_dUi2 = admittance * sin(lossAngle);
  } else if (getConnectionState() == CLOSED_2) {
    double G = admittance * sin(lossAngle) + g;
    double B = b - admittance * cos(lossAngle);
    double denom = G * G + B * B;

    double GT = 1. / denom * (admittance * admittance * g + admittance * sin(lossAngle) * (g * g + b * b));

    ii2_dUi2 = GT;
  }

  return ii2_dUi2;
}

void
ModelTwoWindingsTransformer::evalF(propertyF_t /*type*/) {
  // not needed
}

void
ModelTwoWindingsTransformer::evalDerivatives(const double /*cj*/) {
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
ModelTwoWindingsTransformer::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;
  if (numCalculatedVar != twtStateNum_) {
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
  }

  bool closed1 = getConnectionState() == CLOSED || getConnectionState() == CLOSED_1;
  bool closed2 = getConnectionState() == CLOSED || getConnectionState() == CLOSED_2;

  double Ir1 = ir1(ur1, ui1, ur2, ui2);
  double Ii1 = ii1(ur1, ui1, ur2, ui2);
  double Ir2 = ir2(ur1, ui1, ur2, ui2);
  double Ii2 = ii2(ur1, ui1, ur2, ui2);
  switch (numCalculatedVar) {
    case i1Num_:
    case iS1ToS2Side1Num_:
    case iS2ToS1Side1Num_:
    case iSide1Num_: {
      double I1 = sqrt(Ii1 * Ii1 + Ir1 * Ir1);
      double factor = 1.;
      if (numCalculatedVar == iS1ToS2Side1Num_) {
        double P1 = Ir1 * ur1 + Ii1 * ui1;
        factor = sign(P1) * factorPuToASide1_;
      } else if (numCalculatedVar == iS2ToS1Side1Num_) {
        double P1 = Ir1 * ur1 + Ii1 * ui1;
        factor = sign(-1 * P1) * factorPuToASide1_;
      } else if (numCalculatedVar == iSide1Num_) {
        factor = factorPuToASide1_;
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
        factor = sign(P2) * factorPuToASide2_;
      } else if (numCalculatedVar == iS1ToS2Side2Num_) {
        double P2 = ur2 * Ir2 + ui2 * Ii2;
        factor = sign(-1 * P2) * factorPuToASide2_;
      } else if (numCalculatedVar == iSide2Num_) {
        factor = factorPuToASide2_;
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
        res[0] = Ir1 + ur1 * ir1_dUr1_ + ui1*ii1_dUr1_;   // dP1/dUr1
        res[1] = ur1 * ir1_dUi1_ + Ii1 + ui1*ii1_dUi1_;   // dP1/dUi1
        res[2] = ur1 * ir1_dUr2_ + ui1*ii1_dUr2_;   // dP1/dUr2
        res[3] = ur1 * ir1_dUi2_ + ui1*ii1_dUi2_;   // dP1/dUi2
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
        res[0] = ur2 * ir2_dUr1_ + ui2*ii2_dUr1_;   // dP2/dUr1
        res[1] = ur2 * ir2_dUi1_ + ui2*ii2_dUi1_;   // dP2/dUi1
        res[2] = Ir2 + ur2 * ir2_dUr2_ + ui2*ii2_dUr2_;   // dP2/dUr2
        res[3] = ur2 * ir2_dUi2_ + Ii2 + ui2*ii2_dUi2_;   // dP2/dUi2
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
        res[0] = ui1 * ir1_dUr1_ - Ii1 - ur1*ii1_dUr1_;   // dQ1/dUr1
        res[1] = Ir1 + ui1 * ir1_dUi1_ - ur1*ii1_dUi1_;   // dQ1/dUi1
        res[2] = ui1 * ir1_dUr2_ - ur1*ii1_dUr2_;   // dQ1/dUr2
        res[3] = ui1 * ir1_dUi2_ - ur1*ii1_dUi2_;   // dQ1/dUi2
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
        res[0] = ui2 * ir2_dUr1_ - ur2*ii2_dUr1_;   // dQ2/dUr1
        res[1] = ui2 * ir2_dUi1_ - ur2*ii2_dUi1_;   // dQ2/dUi1
        res[2] = ui2 * ir2_dUr2_ - Ii2 - ur2*ii2_dUr2_;   // dQ2/dUr2
        res[3] = Ir2 + ui2 * ir2_dUi2_ - ur2*ii2_dUi2_;   // dQ2/dUi2
      } else {
        res[0] = 0.;
        res[1] = 0.;
        res[2] = 0.;
        res[3] = 0.;
      }
      break;
    }
    case twtStateNum_:
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelTwoWindingsTransformer::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
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
  // state as continuous variable (need for external automaton as inputs of automaton are continuous)
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_twtState_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState(id_ + "_step_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_desactivate_currentLimits_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState(id_ + "_disable_internal_tapChanger_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState(id_ + "_TAP_CHANGER_locked_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState(id_ + "_TAP_CHANGER_deltaUTarget_value", DISCRETE));
}

void
ModelTwoWindingsTransformer::defineVariables(vector<shared_ptr<Variable> >& variables) {
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
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_twtState_value", CONTINUOUS));  // state as continuous variable
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", INTEGER));
  variables.push_back(VariableNativeFactory::createState("@ID@_step_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_desactivate_currentLimits_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState("@ID@_disable_internal_tapChanger_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState("@ID@_TAP_CHANGER_locked_value", BOOLEAN));
  variables.push_back(VariableNativeFactory::createState("@ID@_TAP_CHANGER_deltaUTarget_value", DISCRETE));
}

void
ModelTwoWindingsTransformer::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  string twtName = id();
  addElementWithValue(twtName + string("_i1"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_i2"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_P1"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_P2"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_Q1"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_Q2"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_iS1ToS2Side1"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_iS2ToS1Side1"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_iS1ToS2Side2"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_iS2ToS1Side2"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_iSide1"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_iSide2"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_twtState"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_state"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_step"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_desactivate_currentLimits"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_disable_internal_tapChanger"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_TAP_CHANGER_locked"), modelType_, elements, mapElement);
  addElementWithValue(twtName + string("_TAP_CHANGER_deltaUTarget"), modelType_, elements, mapElement);
}

NetworkComponent::StateChange_t
ModelTwoWindingsTransformer::evalZ(const double& t) {
  int offsetRoot = 0;
  ModelCurrentLimits::state_t currentLimitState;

  if (currentLimits1_) {
    currentLimitState = currentLimits1_->evalZ(id(), t, &(g_[offsetRoot]), network_, currentLimitsDesactivate_, modelType_);
    offsetRoot += currentLimits1_->sizeG();
    if (currentLimitState == ModelCurrentLimits::COMPONENT_OPEN)
      z_[connectionStateNum_] = OPEN;
  }

  if (currentLimits2_) {
    currentLimitState = currentLimits2_->evalZ(id(), t, &(g_[offsetRoot]), network_, currentLimitsDesactivate_, modelType_);
    offsetRoot += currentLimits2_->sizeG();
    if (currentLimitState == ModelCurrentLimits::COMPONENT_OPEN)
      z_[connectionStateNum_] = OPEN;
  }

  if (modelRatioChanger_ && modelBusMonitored_) {
    modelRatioChanger_->evalZ(t, &(g_[offsetRoot]), network_, disableInternalTapChanger_, modelBusMonitored_->getSwitchOff(), tapChangerLocked_,
        getConnectionState() == CLOSED);
    offsetRoot += modelRatioChanger_->sizeG();
  }

  if (modelPhaseChanger_) {
    double ur1Val = ur1();
    double ui1Val = ui1();
    double ur2Val = ur2();
    double ui2Val = ui2();
    double pSide1 = P1(ur1Val, ui1Val, ur2Val, ui2Val);
    double pSide2 = P2(ur1Val, ui1Val, ur2Val, ui2Val);
    bool P1SupP2 = (pSide1 > pSide2);
    modelPhaseChanger_->evalZ(t, &(g_[offsetRoot]), network_, disableInternalTapChanger_, P1SupP2, tapChangerLocked_, getConnectionState() == CLOSED);
  }

  switch (knownBus_) {
  case BUS1_BUS2:
  {
    if (modelBus1_->getConnectionState() == OPEN && modelBus2_->getConnectionState() == OPEN) {
      z_[0] = OPEN;
    } else if (modelBus1_->getConnectionState() == OPEN) {
      z_[0] = CLOSED_2;

    } else if (modelBus2_->getConnectionState() == OPEN) {
      z_[0] = CLOSED_1;
    }
    break;
  }
  case BUS1:
  {
    if (modelBus1_->getConnectionState() == OPEN)
      z_[0] = OPEN;
    break;
  }
  case BUS2:
  {
    if (modelBus2_->getConnectionState() == OPEN)
      z_[0] = OPEN;
    break;
  }
  }

  State currState = static_cast<State>(static_cast<int>(z_[connectionStateNum_]));
  if (currState != connectionState_) {
    if (currState == CLOSED && knownBus_ != BUS1_BUS2) {
      Trace::warn() << DYNLog(UnableToCloseTfo, id_) << Trace::endline;
    } else if (currState == CLOSED_1 && knownBus_ == BUS2) {
      Trace::warn() << DYNLog(UnableToCloseTfoSide1, id_) << Trace::endline;
    } else if (currState == CLOSED_2 && knownBus_ == BUS1) {
      Trace::warn() << DYNLog(UnableToCloseTfoSide2, id_) << Trace::endline;
    } else {
      topologyModified_ = true;
      Trace::info() << DYNLog(TfoStateChange, id_, getConnectionState(), currState) << Trace::endline;
      switch (currState) {
      // z_[0] represents the actual state
      // getConnectionState() represents the previous state
      // compare them to know what happened, which timeline message to generate
      // and which topology action to take
      case UNDEFINED_STATE:
        throw DYNError(Error::MODELER, UndefinedComponentState, id_);
      case OPEN:
        switch (getConnectionState()) {
        case OPEN:
          break;
        case CLOSED:
          DYNAddTimelineEvent(network_, id_, TwoWTFOOpen);
          modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
          modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
          break;
        case CLOSED_1:
          DYNAddTimelineEvent(network_, id_, TwoWTFOOpenSide1);
          modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
          break;
        case CLOSED_2:
          DYNAddTimelineEvent(network_, id_, TwoWTFOOpenSide2);
          modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
          break;
        case CLOSED_3:
          throw DYNError(Error::MODELER, NoThirdSide, id_);
        case UNDEFINED_STATE:
          throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
        }
        break;
        case CLOSED:
          switch (getConnectionState()) {
          case OPEN:
            DYNAddTimelineEvent(network_, id_, TwoWTFOClosed);
            modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
            modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED:
            break;
          case CLOSED_1:
            DYNAddTimelineEvent(network_, id_, TwoWTFOCloseSide2);
            modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
            break;
          case CLOSED_2:
            DYNAddTimelineEvent(network_, id_, TwoWTFOCloseSide1);
            modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
            break;
          case CLOSED_3:
            throw DYNError(Error::MODELER, NoThirdSide, id_);
          case UNDEFINED_STATE:
            throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
          }
          break;
          case CLOSED_1:
            switch (getConnectionState()) {
            case OPEN:
              DYNAddTimelineEvent(network_, id_, TwoWTFOCloseSide1);
              modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
              break;
            case CLOSED:
              DYNAddTimelineEvent(network_, id_, TwoWTFOOpenSide2);
              modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
              break;
            case CLOSED_1:
              break;
            case CLOSED_2:
              DYNAddTimelineEvent(network_, id_, TwoWTFOCloseSide1);
              DYNAddTimelineEvent(network_, id_, TwoWTFOOpenSide2);
              modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
              modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
              break;
            case CLOSED_3:
              throw DYNError(Error::MODELER, NoThirdSide, id_);
            case UNDEFINED_STATE:
              throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
            }
            break;
            case CLOSED_2:
              switch (getConnectionState()) {
              case OPEN:
                DYNAddTimelineEvent(network_, id_, TwoWTFOCloseSide2);
                modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
                break;
              case CLOSED:
                DYNAddTimelineEvent(network_, id_, TwoWTFOOpenSide1);
                modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
                break;
              case CLOSED_1:
                DYNAddTimelineEvent(network_, id_, TwoWTFOCloseSide2);
                DYNAddTimelineEvent(network_, id_, TwoWTFOOpenSide1);
                modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
                modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
                break;
              case CLOSED_2:
                break;
              case CLOSED_3:
                throw DYNError(Error::MODELER, NoThirdSide, id_);
              case UNDEFINED_STATE:
                throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
              }
              break;
              case CLOSED_3:
                throw DYNError(Error::MODELER, NoThirdSide, id_);
      }
      setConnectionState(static_cast<State>(static_cast<int>(z_[connectionStateNum_])));
    }
  }

  int currStateIndex = static_cast<int>(static_cast<int>(z_[currentStepIndexNum_]));
  if (currStateIndex != getCurrentStepIndex()) {
    if (disableInternalTapChanger_ > 0.) {
      // external automaton
      Trace::debug() << DYNLog(TfoTapChange, id_, getCurrentStepIndex(), z_[currentStepIndexNum_]) << Trace::endline;
    } else {
      // internal automaton
      Trace::debug() << DYNLog(TfoTapChange, id_, z_[currentStepIndexNum_], getCurrentStepIndex()) << Trace::endline;
      z_[currentStepIndexNum_] = getCurrentStepIndex();
    }
    stateIndexModified_ = true;
    setCurrentStepIndex(static_cast<int>(z_[currentStepIndexNum_]));
  }

  if (doubleNotEquals(z_[currentLimitsDesactivateNum_], getCurrentLimitsDesactivate())) {
    setCurrentLimitsDesactivate(z_[currentLimitsDesactivateNum_]);
    Trace::debug() << DYNLog(DeactivateCurrentLimits, id_) << Trace::endline;
  }

  if (doubleNotEquals(z_[disableInternalTapChangerNum_], getDisableInternalTapChanger())) {
    setDisableInternalTapChanger(z_[disableInternalTapChangerNum_]);
    Trace::debug() << DYNLog(DisableInternalTapChanger, id_) << Trace::endline;
  }

  if (doubleNotEquals(z_[tapChangerLockedNum_], getTapChangerLocked())) {
    setTapChangerLocked(z_[tapChangerLockedNum_]);
    if (z_[tapChangerLockedNum_] > 0)
      Trace::debug() << DYNLog(TapChangerLocked, id_) << Trace::endline;
  }
  if (topologyModified_) {
    updateYMat_ = true;
    return NetworkComponent::TOPO_CHANGE;
  } else if (stateIndexModified_) {
    if (modelRatioChanger_ || modelPhaseChanger_)
      updateYMat_ = true;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelTwoWindingsTransformer::collectSilentZ(BitMask* silentZTable) {
  silentZTable[connectionStateNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[currentStepIndexNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[currentLimitsDesactivateNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[disableInternalTapChangerNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[tapChangerLockedNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[deltaUTarget].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
}

double
ModelTwoWindingsTransformer::ur1() const {
  double ur1 = 0.;
  if (modelBus1_)
    ur1 = modelBus1_->ur();
  return ur1;
}

double
ModelTwoWindingsTransformer::ui1() const {
  double ui1 = 0.;
  if (modelBus1_)
    ui1 = modelBus1_->ui();
  return ui1;
}

double
ModelTwoWindingsTransformer::ur2() const {
  double ur2 = 0.;
  if (modelBus2_)
    ur2 = modelBus2_->ur();
  return ur2;
}

double
ModelTwoWindingsTransformer::ui2() const {
  double ui2 = 0.;
  if (modelBus2_)
    ui2 = modelBus2_->ui();
  return ui2;
}

double
ModelTwoWindingsTransformer::P1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  double irBus1 = ir1(ur1, ui1, ur2, ui2);
  double iiBus1 = ii1(ur1, ui1, ur2, ui2);
  return ur1 * irBus1 + ui1 * iiBus1;
}

double
ModelTwoWindingsTransformer::P2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  const double irBus2 = ir2(ur1, ui1, ur2, ui2);
  const double iiBus2 = ii2(ur1, ui1, ur2, ui2);
  return ur2 * irBus2 + ui2 * iiBus2;
}

void
ModelTwoWindingsTransformer::evalG(const double& t) {
  int offset = 0;
  double ur1Val = 0.;
  double ui1Val = 0.;
  double ur2Val = 0.;
  double ui2Val = 0.;
  if (currentLimits1_ || currentLimits2_ || modelPhaseChanger_) {
    ur1Val = ur1();
    ui1Val = ui1();
    ur2Val = ur2();
    ui2Val = ui2();
  }
  if (currentLimits1_) {
    currentLimits1_->evalG(t, i1(ur1Val, ui1Val, ur2Val, ui2Val), &(g_[offset]), currentLimitsDesactivate_);
    offset += currentLimits1_->sizeG();
  }

  if (currentLimits2_) {
    currentLimits2_->evalG(t, i2(ur1Val, ui1Val, ur2Val, ui2Val), &(g_[offset]), currentLimitsDesactivate_);
    offset += currentLimits2_->sizeG();
  }

  if (modelRatioChanger_) {
    double vValue = 0.;
    bool nodeOff = true;
    if (modelBusMonitored_) {
      vValue = modelBusMonitored_->getCurrentU(ModelBus::UType_);
      nodeOff = modelBusMonitored_->getSwitchOff();
    }
    modelRatioChanger_->evalG(t, vValue, nodeOff, &g_[offset], disableInternalTapChanger_, tapChangerLocked_, getConnectionState() == CLOSED, z_[deltaUTarget]);
    offset += modelRatioChanger_->sizeG();
  }

  if (modelPhaseChanger_) {
    double iValue = i2(ur1Val, ui1Val, ur2Val, ui2Val) * factorPuToASide2_;
    modelPhaseChanger_->evalG(t, iValue, false, &g_[offset], disableInternalTapChanger_, tapChangerLocked_, getConnectionState() == CLOSED);
  }
}

void
ModelTwoWindingsTransformer::setGequations(std::map<int, std::string>& gEquationIndex) {
  int offset = 0;
  if (currentLimits1_) {
    for (int i = 0; i < currentLimits1_->sizeG(); ++i) {
      gEquationIndex[i] = "ModelTwoWindingsTransformer "+ id() +" : currentLimits1.";
    }
    offset += currentLimits1_->sizeG();
  }

  if (currentLimits2_) {
    for (int i = 0; i < currentLimits2_->sizeG(); ++i) {
      gEquationIndex[i + offset] = "ModelTwoWindingsTransformer "+ id() +" : currentLimits2.";
    }
    offset += currentLimits2_->sizeG();
  }

  if (modelRatioChanger_) {
    for (int i = 0; i < modelRatioChanger_->sizeG(); ++i) {
      gEquationIndex[i + offset] = "ModelTwoWindingsTransformer "+ id() +" : modelRatioChanger.";
    }
    offset += modelRatioChanger_->sizeG();
  }

  if (modelPhaseChanger_) {
    for (int i = 0; i < modelPhaseChanger_->sizeG(); ++i) {
      gEquationIndex[i + offset] = "ModelTwoWindingsTransformer "+ id() +" : modelPhaseChanger.";
    }
  }


  assert(gEquationIndex.size() == static_cast<size_t>(sizeG_) && "Model TwoWindingsTransformer: gEquationIndex.size() != sizeG_");
}

double
ModelTwoWindingsTransformer::i1(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  double irBus1 = ir1(ur1, ui1, ur2, ui2);
  double iiBus1 = ii1(ur1, ui1, ur2, ui2);
  return sqrt(irBus1 * irBus1 + iiBus1 * iiBus1);
}

double
ModelTwoWindingsTransformer::i2(const double& ur1, const double& ui1, const double& ur2, const double& ui2) const {
  double irBus2 = ir2(ur1, ui1, ur2, ui2);
  double iiBus2 = ii2(ur1, ui1, ur2, ui2);
  return sqrt(irBus2 * irBus2 + iiBus2 * iiBus2);
}

void
ModelTwoWindingsTransformer::evalCalculatedVars() {
  double ur1Val = ur1();
  double ui1Val = ui1();
  double ur2Val = ur2();
  double ui2Val = ui2();
  double irBus1 = ir1(ur1Val, ui1Val, ur2Val, ui2Val);
  double iiBus1 = ii1(ur1Val, ui1Val, ur2Val, ui2Val);
  double irBus2 = ir2(ur1Val, ui1Val, ur2Val, ui2Val);
  double iiBus2 = ii2(ur1Val, ui1Val, ur2Val, ui2Val);
  double P1 = ur1Val * irBus1 + ui1Val * iiBus1;   // in pu, because u and iBus in pu
  double P2 = ur2Val * irBus2 + ui2Val * iiBus2;
  int signP1 = sign(P1);
  int signP2 = sign(P2);

  calculatedVars_[i1Num_] = sqrt(irBus1 * irBus1 + iiBus1 * iiBus1);  // Current side 1
  calculatedVars_[i2Num_] = sqrt(irBus2 * irBus2 + iiBus2 * iiBus2);  // Current side 2
  calculatedVars_[p1Num_] = P1;  // Active power side 1
  calculatedVars_[p2Num_] = P2;  // Active power side 2
  calculatedVars_[q1Num_] = (irBus1 * ui1Val - iiBus1 * ur1Val);  // Reactive power side 1
  calculatedVars_[q2Num_] = (irBus2 * ui2Val - iiBus2 * ur2Val);  // Reactive power side 2

  calculatedVars_[iS1ToS2Side1Num_] = signP1 * calculatedVars_[i1Num_] * factorPuToASide1_;
  calculatedVars_[iS2ToS1Side1Num_] = -1. * calculatedVars_[iS1ToS2Side1Num_];
  calculatedVars_[iS2ToS1Side2Num_] = signP2 * calculatedVars_[i2Num_] * factorPuToASide2_;
  calculatedVars_[iS1ToS2Side2Num_] = -1. * calculatedVars_[iS2ToS1Side2Num_];

  calculatedVars_[iSide1Num_] = std::max(calculatedVars_[iS1ToS2Side1Num_], calculatedVars_[iS2ToS1Side1Num_]);
  calculatedVars_[iSide2Num_] = std::max(calculatedVars_[iS1ToS2Side2Num_], calculatedVars_[iS1ToS2Side2Num_]);
  calculatedVars_[twtStateNum_] = getConnectionState();
}

void
ModelTwoWindingsTransformer::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
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
    case twtStateNum_:
      break;

    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelTwoWindingsTransformer::evalCalculatedVarI(unsigned numCalculatedVar) const {
  double output;
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;
  if (numCalculatedVar != twtStateNum_) {
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
  }
  double Ir1 = ir1(ur1, ui1, ur2, ui2);
  double Ii1 = ii1(ur1, ui1, ur2, ui2);
  double Ir2 = ir2(ur1, ui1, ur2, ui2);
  double Ii2 = ii2(ur1, ui1, ur2, ui2);
  double P1 = ur1 * Ir1 + ui1 * Ii1;
  double P2 = ur2 * Ir2 + ui2 * Ii2;
  int signP1 = sign(P1);
  int signP2 = sign(P2);
  switch (numCalculatedVar) {
    case i1Num_:
      output = sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case iS1ToS2Side1Num_:
      output = signP1 * factorPuToASide1_ * sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case iS2ToS1Side1Num_:
      output = -1 * signP1 * factorPuToASide1_ * sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case iSide1Num_:
      output = factorPuToASide1_ * sqrt(Ir1 * Ir1 + Ii1 * Ii1);
      break;
    case i2Num_:
      output = sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      break;
    case iS2ToS1Side2Num_:
      output = signP2 * factorPuToASide2_ * sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      break;
    case iS1ToS2Side2Num_:
      output = -1 * signP2 * factorPuToASide2_ * sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      break;
    case iSide2Num_:
      output = factorPuToASide2_ * sqrt(Ir2 * Ir2 + Ii2 * Ii2);
      break;
    case p1Num_:
      output = (ur1 * Ir1 + ui1 * Ii1);
      break;
    case p2Num_:
      output = (ur2 * Ir2 + ui2 * Ii2);
      break;
    case q1Num_:
      output = (ui1 * Ir1 - ur1 * Ii1);
      break;
    case q2Num_:
      output = (ui2 * Ir2 - ur2 * Ii2);
      break;
    case twtStateNum_:
      output = getConnectionState();
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return output;
}

void
ModelTwoWindingsTransformer::getY0() {
  if (!network_->isInitModel()) {
    z_[connectionStateNum_] = getConnectionState();
    z_[currentStepIndexNum_] = getCurrentStepIndex();
    z_[currentLimitsDesactivateNum_] = getCurrentLimitsDesactivate();
    z_[disableInternalTapChangerNum_] = getDisableInternalTapChanger();
    z_[tapChangerLockedNum_] = getTapChangerLocked();
    z_[deltaUTarget] = 0.;
  }
}

NetworkComponent::StateChange_t
ModelTwoWindingsTransformer::evalState(const double& /*time*/) {
  NetworkComponent::StateChange_t state = NetworkComponent::NO_CHANGE;
  if (topologyModified_) {
    state = NetworkComponent::TOPO_CHANGE;
    topologyModified_ = false;
  }
  if (stateIndexModified_) {
    if (state != NetworkComponent::TOPO_CHANGE) {
      state = NetworkComponent::STATE_CHANGE;
    }
    stateIndexModified_ = false;
  }
  return state;
}

void
ModelTwoWindingsTransformer::addBusNeighbors() {
  if (getConnectionState() == CLOSED) {
    modelBus1_->addNeighbor(modelBus2_);
    modelBus2_->addNeighbor(modelBus1_);
  }
}

void
ModelTwoWindingsTransformer::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& params) {
  // current limits parameter
  bool success = false;
  double maxTimeOperation = getParameterDynamicNoThrow<double>(params, "transformer_currentLimit_maxTimeOperation", success);
  if (success) {
    if (currentLimits1_)
      currentLimits1_->setMaxTimeOperation(maxTimeOperation);
    if (currentLimits2_)
      currentLimits2_->setMaxTimeOperation(maxTimeOperation);
  }
  try {
    if (modelRatioChanger_ || modelPhaseChanger_) {
      // model tap changer parameter
      vector<string> ids;
      ids.push_back(id_);
      ids.push_back("transformer");

      double t1stTHT = getParameterDynamic<double>(params, "t1st_THT", ids);
      double tNextTHT = getParameterDynamic<double>(params, "tNext_THT", ids);
      double t1stHT = getParameterDynamic<double>(params, "t1st_HT", ids);
      double tNextHT = getParameterDynamic<double>(params, "tNext_HT", ids);

      const bool bus1VHV = (vNom1_ >= VHV_THRESHOLD);
      const bool bus1HV = (vNom1_ >= HV_THRESHOLD && vNom1_ < VHV_THRESHOLD);
      const bool bus2VHV = (vNom2_ >= VHV_THRESHOLD);
      const bool bus2HV = (vNom2_ >= HV_THRESHOLD && vNom2_ < VHV_THRESHOLD);

      // set modelTapChanger parameters
      if (modelRatioChanger_) {
        double tolV = getParameterDynamic<double>(params, "tolV", ids);

        if ((bus1VHV && bus2HV) || (bus2VHV && bus1HV)) {
          modelRatioChanger_->setTFirst(t1stTHT);
          modelRatioChanger_->setTNext(tNextTHT);
        } else {
          modelRatioChanger_->setTFirst(t1stHT);
          modelRatioChanger_->setTNext(tNextHT);
        }
        if (modelBusMonitored_)
          modelRatioChanger_->setTolV(tolV * modelBusMonitored_->getVNom());
      }
      if (modelPhaseChanger_) {
        if ((bus1VHV && bus2HV) || (bus2VHV && bus1HV)) {
          modelPhaseChanger_->setTFirst(t1stTHT);
          modelPhaseChanger_->setTNext(tNextTHT);
        } else {
          modelPhaseChanger_->setTFirst(t1stHT);
          modelPhaseChanger_->setTNext(tNextHT);
        }
      }
    }
  } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    throw DYNError(Error::MODELER, NetworkParameterNotFoundFor, id_);
  }
}

void
ModelTwoWindingsTransformer::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("transformer_currentLimit_maxTimeOperation", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("transformer_t1st_THT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("transformer_tNext_THT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("transformer_t1st_HT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("transformer_tNext_HT", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("transformer_tolV", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

}  // namespace DYN
