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
 * @file  DYNModelHvdcLink.cpp
 *
 * @brief HVDC link simple model where the converters act like PQ injectors
 *
 */
//======================================================================
#include <iostream>

#include "DYNModelHvdcLink.h"

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
#include "DYNHvdcLineInterface.h"
#include "DYNVscConverterInterface.h"
#include "DYNLccConverterInterface.h"
#include "DYNModelVoltageLevel.h"

using boost::shared_ptr;
using std::vector;
using std::map;
using std::string;
using std::abs;

namespace DYN {

ModelHvdcLink::ModelHvdcLink(const shared_ptr<VscConverterInterface>& vsc1, const shared_ptr<VscConverterInterface>& vsc2,
                             const shared_ptr<HvdcLineInterface>& dcLine) :
Impl(dcLine->getID()) {
  // retrieve data from VscConverterInterface and HvdcLineInterface (iidm)
  setAttributes(vsc1, vsc2, dcLine);

  // calculate active power at the two points of common coupling
  setConvertersActivePower(vsc1, vsc2);

  // calculate reactive power at the two points of common coupling
  setConvertersReactivePowerVsc(vsc1, vsc2);


  ir01_ = 0;
  ii01_ = 0;
  if (vsc1->getBusInterface()) {
    double P01 = vsc1->getP() / SNREF;
    double Q01 = vsc1->getQ() / SNREF;
    double uNode1 = vsc1->getBusInterface()->getV0();
    double tetaNode1 = vsc1->getBusInterface()->getAngle0();
    double unomNode1 = vsc1->getBusInterface()->getVNom();
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
  if (vsc2->getBusInterface()) {
    double P02 = vsc2->getP() / SNREF;
    double Q02 = vsc2->getQ() / SNREF;
    double uNode2 = vsc2->getBusInterface()->getV0();
    double tetaNode2 = vsc2->getBusInterface()->getAngle0();
    double unomNode2 = vsc2->getBusInterface()->getVNom();
    double ur02 = uNode2 / unomNode2 * cos(tetaNode2 * DEG_TO_RAD);
    double ui02 = uNode2 / unomNode2 * sin(tetaNode2 * DEG_TO_RAD);
    double U202 = ur02 * ur02 + ui02 * ui02;
    if (!doubleIsZero(U202)) {
      ir02_ = (P02 * ur02 + Q02 * ui02) / U202;
      ii02_ = (P02 * ui02 - Q02 * ur02) / U202;
    }
  }
}

ModelHvdcLink::ModelHvdcLink(const shared_ptr<LccConverterInterface>& lcc1, const shared_ptr<LccConverterInterface>& lcc2,
                             const shared_ptr<HvdcLineInterface>& dcLine) :
Impl(dcLine->getID()) {
  // retrieve data from LccConverterInterface and HvdcLineInterface (iidm)
  setAttributes(lcc1, lcc2, dcLine);

  // calculate active power at the two points of common coupling
  setConvertersActivePower(lcc1, lcc2);

  // calculate reactive power at the two points of common coupling
  setConvertersReactivePowerLcc(lcc1, lcc2);

  double uNode1 = lcc1->getBusInterface()->getV0();
  double tetaNode1 = lcc1->getBusInterface()->getAngle0();
  double unomNode1 = lcc1->getBusInterface()->getVNom();
  double ur01 = uNode1 / unomNode1 * cos(tetaNode1 * DEG_TO_RAD);
  double ui01 = uNode1 / unomNode1 * sin(tetaNode1 * DEG_TO_RAD);
  ir01_ = (P01_ * ur01 + Q01_ * ui01) / (ur01 * ur01 + ui01 * ui01);
  ii01_ = (P01_ * ui01 - Q01_ * ur01) / (ur01 * ur01 + ui01 * ui01);

  double uNode2 = lcc2->getBusInterface()->getV0();
  double tetaNode2 = lcc2->getBusInterface()->getAngle0();
  double unomNode2 = lcc2->getBusInterface()->getVNom();
  double ur02 = uNode2 / unomNode2 * cos(tetaNode2 * DEG_TO_RAD);
  double ui02 = uNode2 / unomNode2 * sin(tetaNode2 * DEG_TO_RAD);
  ir02_ = (P02_ * ur02 + Q02_ * ui02) / (ur02 * ur02 + ui02 * ui02);
  ii02_ = (P02_ * ui02 - Q02_ * ur02) / (ur02 * ur02 + ui02 * ui02);
}

void
ModelHvdcLink::init(int& /*yNum*/) {
  // no state variable for simple hvdc model: no indexes to set
}

void
ModelHvdcLink::initSize() {
  if (network_->isInitModel()) {
    sizeY_ = 0;
    sizeF_ = 0;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = 0;
  } else {
    sizeY_ = 0;  // no state variable for simple hvdc model
    sizeF_ = 0;  // no equation because no state variable for simple hvdc model
    sizeZ_ = 2;  // 2 discrete variables: connection state for converter1 and converter2
    sizeG_ = 0;  // no root function because no state variable
    sizeMode_ = 0;  // no mode because no state variable
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

void
ModelHvdcLink::getY0() {
  if (!network_->isInitModel()) {
    // get init value for state variables

    // get init value for discrete variables
    z_[0] = getConnected1();
    z_[1] = getConnected2();
  }
}

void
ModelHvdcLink::evalYType() {
  // no state variable for simple hvdc model
}

void
ModelHvdcLink::evalFType() {
  // no equation for simple hvdc model because no state variable
}

void
ModelHvdcLink::setFequations(std::map<int, std::string>& /*fEquationIndex*/) {
  // no equation for simple hvdc model because no state variable
}

void
ModelHvdcLink::evalF() {
  // no equation for simple hvdc model because no state variable
}

void
ModelHvdcLink::evalJt(SparseMatrix& /*jt*/, const double& /*cj*/, const int& /*rowOffset*/) {
  // no jacobian transpose evaluation because no equation
}

void
ModelHvdcLink::evalJtPrim(SparseMatrix& /*jt*/, const int& /*rowOffset*/) {
  // no jacobian transpose derivative evaluation because no equation
}

void
ModelHvdcLink::evalZ(const double& /*t*/) {
  // evaluation of the discrete variables current values
  z_[0] = getConnected1();
  z_[1] = getConnected2();
}

void
ModelHvdcLink::setGequations(std::map<int, std::string>& /*gEquationIndex*/) {
  // no root function
}

void
ModelHvdcLink::evalG(const double& /*t*/) {
  // no root function to evaluate
}

void
ModelHvdcLink::evalCalculatedVars() {
  // calculated variables are the active and reactive power at both sides
  double ur1 = modelBus1_->ur();
  double ui1 = modelBus1_->ui();
  double ur2 = modelBus2_->ur();
  double ui2 = modelBus2_->ui();
  double U1_2 = ur1 * ur1 + ui1 * ui1;
  double U2_2 = ur2 * ur2 + ui2 * ui2;
  double ir1Val = ir1(ur1, ui1, U1_2);
  double ii1Val = ii1(ur1, ui1, U1_2);
  double ir2Val = ir2(ur2, ui2, U2_2);
  double ii2Val = ii2(ur2, ui2, U2_2);
  calculatedVars_[p1Num_] = (isConnected1() && isConnected2())?-(ur1 * ir1Val + ui1 * ii1Val):0.;  // P = -(ur*ir + ui*ii) (generator convention)
  calculatedVars_[q1Num_] = (isConnected1())?-(ui1 * ir1Val - ur1 * ii1Val):0.;  // Q = -(ui*ir - ur*ii) (generator convention)
  calculatedVars_[p2Num_] = (isConnected1() && isConnected2())?-(ur2 * ir2Val + ui2 * ii2Val):0.;  // P = -(ur*ir + ui*ii) (generator convention)
  calculatedVars_[q2Num_] = (isConnected2())?-(ui2 * ir2Val - ur2 * ii2Val):0.;  // Q = -(ui*ir - ur*ii) (generator convention)
}

void
ModelHvdcLink::getDefJCalculatedVarI(int numCalculatedVar, std::vector<int> & numVars) {
  // get the index of variables used to define the jacobian associated to a calculated variable
  switch (numCalculatedVar) {
    case p1Num_:
    case q1Num_: {
      if (isConnected1()) {
        int urYNum1 = modelBus1_->urYNum();
        int uiYNum1 = modelBus1_->uiYNum();
        numVars.push_back(urYNum1);
        numVars.push_back(uiYNum1);
      }
      break;
    }
    case p2Num_:
    case q2Num_: {
      if (isConnected2()) {
        int urYNum2 = modelBus2_->urYNum();
        int uiYNum2 = modelBus2_->uiYNum();
        numVars.push_back(urYNum2);
        numVars.push_back(uiYNum2);
      }
      break;
    }
  }
}

void
ModelHvdcLink::evalJCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/, std::vector<double>& res) {
  switch (numCalculatedVar) {
    case p1Num_: {
      if (isConnected1() && isConnected2()) {
        double ur1 = y[0];
        double ui1 = y[1];
        double U1_2 = ur1 * ur1 + ui1 * ui1;
        // P1 = -( ur1 * ir1 + ui1 * ii1 ) (generator convention)
        res[0] = -(ir1(ur1, ui1, U1_2) + ur1 * ir1_dUr(ur1, ui1, U1_2) + ui1 * ii1_dUr(ur1, ui1, U1_2));  // @P1/@ur1
        res[1] = -(ur1 * ir1_dUi(ur1, ui1, U1_2) + ii1(ur1, ui1, U1_2) + ui1 * ii1_dUi(ur1, ui1, U1_2));  // @P1/@ui1
      } else {
        res[0] = 0.;
        res[1] = 0.;
      }
      break;
    }
    case p2Num_: {
      if (isConnected1() && isConnected2()) {
        double ur2 = y[2];
        double ui2 = y[3];
        double U2_2 = ur2 * ur2 + ui2 * ui2;
        // P2 = -( ur2 * ir2 + ui2 * ii2 ) (generator convention)
        res[0] = -(ir2(ur2, ui2, U2_2) + ur2 * ir2_dUr(ur2, ui2, U2_2) + ui2 * ii2_dUr(ur2, ui2, U2_2));  // @P2/@ur2
        res[1] = -(ur2 * ir2_dUi(ur2, ui2, U2_2) + ii2(ur2, ui2, U2_2) + ui2 * ii2_dUi(ur2, ui2, U2_2));  // @P2/@ui2
      } else {
        res[0] = 0.;
        res[1] = 0.;
      }
      break;
    }
    case q1Num_: {
      if (isConnected1()) {
        double ur1 = y[0];
        double ui1 = y[1];
        double U1_2 = ur1 * ur1 + ui1 * ui1;
        // Q1 = -( ui1 * ir1 - ur1 * ii1 ) (generator convention)
        res[0] = -(ui1 * ir1_dUr(ur1, ui1, U1_2) - (ii1(ur1, ui1, U1_2) + ur1 * ii1_dUr(ur1, ui1, U1_2)));  // @Q1/@ur1
        res[1] = -(ir1(ur1, ui1, U1_2) + ui1 * ir1_dUi(ur1, ui1, U1_2) - ur1 * ii1_dUi(ur1, ui1, U1_2));  // @Q1/@ui1
      } else {
        res[0] = 0.;
        res[1] = 0.;
      }
      break;
    }
    case q2Num_: {
      if (isConnected2()) {
        double ur2 = y[2];
        double ui2 = y[3];
        double U2_2 = ur2 * ur2 + ui2 * ui2;
        // Q2 = -( ui2 * ir2 - ur2 * ii2 ) (generator convention)
        res[0] = -(ui2 * ir2_dUr(ur2, ui2, U2_2) - (ii2(ur2, ui2, U2_2) + ur2 * ii2_dUr(ur2, ui2, U2_2)));  // @Q2/@ur2
        res[1] = -(ir2(ur2, ui2, U2_2) + ui2 * ir2_dUi(ur2, ui2, U2_2) - ur2 * ii2_dUi(ur2, ui2, U2_2));  // @Q2/@ui2
      } else {
        res[0] = 0.;
        res[1] = 0.;
      }
      break;
    }
  }
}

double
ModelHvdcLink::evalCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/) {
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;

  switch (numCalculatedVar) {
    case p1Num_:
    case q1Num_: {
      if (isConnected1()) {
        ur1 = y[0];
        ui1 = y[1];
      }
      break;
    }
    case p2Num_:
    case q2Num_: {
      if (isConnected2()) {
        ur2 = y[0];
        ui2 = y[1];
      }
      break;
    }
  }

  double U1_2 = ur1 * ur1 + ui1 * ui1;
  double U2_2 = ur2 * ur2 + ui2 * ui2;
  switch (numCalculatedVar) {
    case p1Num_: {
      if (isConnected1() && isConnected2()) {
        // P1 = -( ur1 * ir1 + ui1 * ii1 ) (generator convention)
        return -(ur1 * ir1(ur1, ui1, U1_2) + ui1 * ii1(ur1, ui1, U1_2));
      }
      break;
    }
    case p2Num_: {
      if (isConnected1() && isConnected2()) {
        // P2 = -( ur2 * ir2 + ui2* ii2 ) (generator convention)
        return -(ur2 * ir2(ur2, ui2, U2_2) + ui2 * ii2(ur2, ui2, U2_2));
      }
      break;
    }
    case q1Num_: {
      if (isConnected1()) {
       // Q1 = -( ui * ir - ur * ii ) (generator convention)
        return -(ui1 * ir1(ur1, ui1, U1_2) - ur1 * ii1(ur1, ui1, U1_2));
      }
      break;
    }
    case q2Num_: {
      if (isConnected2()) {
        // Q2 = -( ui * ir - ur * ii ) (generator convention)
        return -(ui2 * ir2(ur2, ui2, U2_2) - ur2 * ii2(ur2, ui2, U2_2));
      }
      break;
    }
  }
  return 0.;
}

void
ModelHvdcLink::evalNodeInjection() {
  if (network_->isInitModel()) {
    // Add current injection at point of common coupling 1
    modelBus1_->irAdd(ir01_);
    modelBus1_->iiAdd(ii01_);
    // Add current injection at point of common coupling 2
    modelBus2_->irAdd(ir02_);
    modelBus2_->iiAdd(ii02_);
  } else {
    // Add current injection at point of common coupling 1
    double ur1 = modelBus1_->ur();
    double ui1 = modelBus1_->ui();
    double ur2 = modelBus2_->ur();
    double ui2 = modelBus2_->ui();
    double U1_2 = ur1 * ur1 + ui1 * ui1;
    double U2_2 = ur2 * ur2 + ui2 * ui2;
    modelBus1_->irAdd(ir1(ur1, ui1, U1_2));
    modelBus1_->iiAdd(ii1(ur1, ui1, U1_2));
    // Add current injection at point of common coupling 2
    modelBus2_->irAdd(ir2(ur2, ui2, U2_2));
    modelBus2_->iiAdd(ii2(ur2, ui2, U2_2));
  }
}

void
ModelHvdcLink::evalDerivatives() {
  if (network_->isInitModel())
    return;
  if (isConnected1()) {
    int urYNum = modelBus1_->urYNum();
    int uiYNum = modelBus1_->uiYNum();
    double ur1 = modelBus1_->ur();
    double ui1 = modelBus1_->ui();
    double U1_2 = ur1 * ur1 + ui1 * ui1;
    modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir1_dUr(ur1, ui1, U1_2));
    modelBus1_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir1_dUi(ur1, ui1, U1_2));
    modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii1_dUr(ur1, ui1, U1_2));
    modelBus1_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii1_dUi(ur1, ui1, U1_2));
  }
  if (isConnected2()) {
    int urYNum = modelBus2_->urYNum();
    int uiYNum = modelBus2_->uiYNum();
    double ur2 = modelBus2_->ur();
    double ui2 = modelBus2_->ui();
    double U2_2 = ur2 * ur2 + ui2 * ui2;
    modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir2_dUr(ur2, ui2, U2_2));
    modelBus2_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir2_dUi(ur2, ui2, U2_2));
    modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii2_dUr(ur2, ui2, U2_2));
    modelBus2_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii2_dUi(ur2, ui2, U2_2));
  }
}

NetworkComponent::StateChange_t
ModelHvdcLink::evalState(const double& /*time*/) {
  if ((State) z_[0] != getConnected1()) {
    Trace::debug() << DYNLog(Converter1StateChange, id_, getConnected1(), z_[0]) << Trace::endline;
    if ((State) z_[0] == OPEN) {
      network_->addEvent(id_, DYNTimeline(Converter1SwitchOff));
      setConnected1(OPEN);
      modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
    } else {
      network_->addEvent(id_, DYNTimeline(Converter1Connected));
      setConnected1(CLOSED);
      modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
    }
    return NetworkComponent::STATE_CHANGE;
  }

  if ((State) z_[1] != getConnected2()) {
    Trace::debug() << DYNLog(Converter2StateChange, id_, getConnected2(), z_[1]) << Trace::endline;
    if ((State) z_[1] == OPEN) {
      network_->addEvent(id_, DYNTimeline(Converter2SwitchOff));
      setConnected2(OPEN);
      modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
    } else {
      network_->addEvent(id_, DYNTimeline(Converter2Connected));
      setConnected2(CLOSED);
      modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
    }
    return NetworkComponent::STATE_CHANGE;
  }

  return NetworkComponent::NO_CHANGE;
}

void
ModelHvdcLink::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  // at point of common coupling 1
  variables.push_back(VariableNativeFactory::createState(id_ + "_state1_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q1_value", CONTINUOUS));
  // at point of common coupling 2
  variables.push_back(VariableNativeFactory::createState(id_ + "_state2_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q2_value", CONTINUOUS));
}

void
ModelHvdcLink::defineVariables(vector<shared_ptr<Variable> >& variables) {
  // at point of common coupling 1
  variables.push_back(VariableNativeFactory::createState("@ID@_state1_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q1_value", CONTINUOUS));
  // at point of common coupling 2
  variables.push_back(VariableNativeFactory::createState("@ID@_state2_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q2_value", CONTINUOUS));
}

void
ModelHvdcLink::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  string hvdcName = id_;
  string name;
  // ========  CONNECTION STATE ======
  // at point of common coupling 1
  name = hvdcName + string("_state1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
  // at point of common coupling 2
  name = hvdcName + string("_state2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  P VALUE  ======
  // at point of common coupling 1
  name = hvdcName + string("_P1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
  // at point of common coupling 2
  name = hvdcName + string("_P2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  Q VALUE  ======
  // at point of common coupling 1
  name = hvdcName + string("_Q1");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
  // at point of common coupling 2
  name = hvdcName + string("_Q2");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
}

void
ModelHvdcLink::addBusNeighbors() {
  if (isConnected1() && isConnected2()) {
    modelBus1_->addNeighbor(modelBus2_);
    modelBus2_->addNeighbor(modelBus1_);
  }
}

void
ModelHvdcLink::setConvertersReactivePowerVsc(const shared_ptr<VscConverterInterface>& vsc1, const shared_ptr<VscConverterInterface>& vsc2) {
  if (vsc1->hasQ() && vsc2->hasQ()) {
    // retrieve reactive power at the two points of common coupling from load flow data in iidm file
    Q01_ = -vsc1->getQ() / SNREF;
    Q02_ = -vsc2->getQ() / SNREF;
  } else {
    // calculate reactive power at the two points of common coupling from setpoints
    double qSetPoint1 = vsc1->getReactivePowerSetpoint();  // in MVar (generator convention)
    double qSetPoint2 = vsc2->getReactivePowerSetpoint();  // in MVar (generator convention)
    Q01_ = qSetPoint1 / SNREF;
    Q02_ = qSetPoint2 / SNREF;
  }
}

void
ModelHvdcLink::setConvertersReactivePowerLcc(const shared_ptr<LccConverterInterface>& lcc1, const shared_ptr<LccConverterInterface>& lcc2) {
  if (lcc1->hasQ() && lcc2->hasQ()) {
    // retrieve reactive power at the two points of common coupling from load flow data in iidm file
    Q01_ = -lcc1->getQ() / SNREF;
    Q02_ = -lcc2->getQ() / SNREF;
  } else {
    // calculate reactive power at the two points of common coupling
    double powerFactor1 = lcc1->getPowerFactor();
    double powerFactor2 = lcc2->getPowerFactor();
    Q01_ = -abs(powerFactor1 * P01_);
    Q02_ = -abs(powerFactor2 * P02_);
  }
}

double
ModelHvdcLink::getP1() const {
  if (isConnected1() && !modelBus1_->getSwitchOff() && isConnected2() && !modelBus2_->getSwitchOff())
    return P01_;
  else
    return 0.;
}

double
ModelHvdcLink::getP2() const {
  if (isConnected1() && !modelBus1_->getSwitchOff() && isConnected2() && !modelBus2_->getSwitchOff())
    return P02_;
  else
    return 0.;
}

double
ModelHvdcLink::getQ1() const {
  if (isConnected1() && !modelBus1_->getSwitchOff())
    return Q01_;
  else
    return 0.;
}

double
ModelHvdcLink::getQ2() const {
  if (isConnected2() && !modelBus2_->getSwitchOff())
    return Q02_;
  else
    return 0.;
}

double
ModelHvdcLink::ir1(const double& ur1, const double& ui1, const double& U1_2) const {
  double ir = 0.;
  if (!doubleIsZero(U1_2))
    ir = (-getP1() * ur1 - getQ1() * ui1) / U1_2;

  return ir;
}

double
ModelHvdcLink::ii1(const double& ur1, const double& ui1, const double& U1_2) const {
  double ii = 0.;
  if (!doubleIsZero(U1_2))
    ii = (-getP1() * ui1 + getQ1() * ur1) / U1_2;

  return ii;
}

double
ModelHvdcLink::ir2(const double& ur2, const double& ui2, const double& U2_2) const {
  double ir = 0.;
  if (!doubleIsZero(U2_2))
    ir = (-getP2() * ur2 - getQ2() * ui2) / U2_2;

  return ir;
}

double
ModelHvdcLink::ii2(const double& ur2, const double& ui2, const double& U2_2) const {
  double ii = 0.;
  if (!doubleIsZero(U2_2))
    ii = (-getP2() * ui2 + getQ2() * ur2) / U2_2;

  return ii;
}

double
ModelHvdcLink::ir1_dUr(const double& ur1, const double& ui1, const double& U1_2) const {
  double ir_dUr = 0.;
  if (!doubleIsZero(U1_2))
    ir_dUr = (-getP1() - 2. * ur1 * (-getP1() * ur1 - getQ1() * ui1) / U1_2) / U1_2;

  return ir_dUr;
}

double
ModelHvdcLink::ir1_dUi(const double& ur1, const double& ui1, const double& U1_2) const {
  double ir_dUi = 0.;
  if (!doubleIsZero(U1_2))
    ir_dUi = (-getQ1() - 2. * ui1 * (-getP1() * ur1 - getQ1() * ui1) / U1_2) / U1_2;

  return ir_dUi;
}

double
ModelHvdcLink::ii1_dUr(const double& ur1, const double& ui1, const double& U1_2) const {
  double ii_dUr = 0.;
  if (!doubleIsZero(U1_2))
    ii_dUr = (getQ1() - 2. * ur1 * (-getP1() * ui1 + getQ1() * ur1) / U1_2) / U1_2;

  return ii_dUr;
}

double
ModelHvdcLink::ii1_dUi(const double& ur1, const double& ui1, const double& U1_2) const {
  double ii_dUi = 0.;
  if (doubleNotEquals(U1_2, 0.))
    ii_dUi = (-getP1() - 2. * ui1 * (-getP1() * ui1 + getQ1() * ur1) / U1_2) / U1_2;

  return ii_dUi;
}

double
ModelHvdcLink::ir2_dUr(const double& ur2, const double& ui2, const double& U2_2) const {
  double ir_dUr = 0.;
  if (!doubleIsZero(U2_2))
    ir_dUr = (-getP2() - 2. * ur2 * (-getP2() * ur2 - getQ2() * ui2) / U2_2) / U2_2;

  return ir_dUr;
}

double
ModelHvdcLink::ir2_dUi(const double& ur2, const double& ui2, const double& U2_2) const {
  double ir_dUi = 0.;
  if (!doubleIsZero(U2_2))
    ir_dUi = (-getQ2() - 2. * ui2 * (-getP2() * ur2 - getQ2() * ui2) / U2_2) / U2_2;

  return ir_dUi;
}

double
ModelHvdcLink::ii2_dUr(const double& ur2, const double& ui2, const double& U2_2) const {
  double ii_dUr = 0.;
  if (!doubleIsZero(U2_2))
    ii_dUr = (getQ2() - 2. * ur2 * (-getP2() * ui2 + getQ2() * ur2) / U2_2) / U2_2;

  return ii_dUr;
}

double
ModelHvdcLink::ii2_dUi(const double& ur2, const double& ui2, const double& U2_2) const {
  double ii_dUi = 0.;
  if (!doubleIsZero(U2_2))
    ii_dUi = (-getP2() - 2. * ui2 * (-getP2() * ui2 + getQ2() * ur2) / U2_2) / U2_2;

  return ii_dUi;
}

void
ModelHvdcLink::defineParameters(vector<ParameterModeler>& /*parameters*/) {
  /* no parameter */
}

void
ModelHvdcLink::defineNonGenericParameters(vector<ParameterModeler>& /*parameters*/) {
  /* no parameter */
}

void
ModelHvdcLink::setSubModelParameters(const boost::unordered_map<std::string, ParameterModeler>& /*params*/) {
  /* no parameter */
}

}  // namespace DYN
