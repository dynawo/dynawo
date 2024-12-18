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
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
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
using std::string;
using std::abs;

namespace DYN {

ModelHvdcLink::ModelHvdcLink(const std::shared_ptr<HvdcLineInterface>& dcLine) :
NetworkComponent(dcLine->getID()),
dcLine_(dcLine),
stateModified_(false),
ir01_(0.),
ii01_(0.),
ir02_(0.),
ii02_(0.),
startingPointMode_(WARM) {
  // retrieve data from VscConverterInterface and HvdcLineInterface (IIDM)
  setAttributes(dcLine);
}

void
ModelHvdcLink::init(int& /*yNum*/) {
  if (!network_->isStartingFromDump() || !internalVariablesFoundInDump_) {
    std::shared_ptr<HvdcLineInterface> dcLine = dcLine_.lock();
    // no state variable for simple hvdc model: no indexes to set
    // calculate active power at the two points of common coupling
    setConvertersActivePower(dcLine);

    // calculate reactive power at the two points of common coupling
    setConvertersReactivePower(dcLine);
    switch (startingPointMode_) {
    case FLAT:
      if (dcLine->getConverter1()->getBusInterface()) {
        double uNode1 = dcLine->getConverter1()->getBusInterface()->getVNom();
        double thetaNode1 = dcLine->getConverter1()->getBusInterface()->getAngle0();
        double unomNode1 = dcLine->getConverter1()->getBusInterface()->getVNom();
        double ur01 = uNode1 / unomNode1 * cos(thetaNode1 * DEG_TO_RAD);
        double ui01 = uNode1 / unomNode1 * sin(thetaNode1 * DEG_TO_RAD);
        double U201 = ur01 * ur01 + ui01 * ui01;
        if (!doubleIsZero(U201)) {
          ir01_ = (P01_ * ur01 + Q01_ * ui01) / U201;
          ii01_ = (P01_ * ui01 - Q01_ * ur01) / U201;
        }
      }
      if (dcLine->getConverter2()->getBusInterface()) {
        double uNode2 = dcLine->getConverter2()->getBusInterface()->getVNom();
        double thetaNode2 = dcLine->getConverter2()->getBusInterface()->getAngle0();
        double unomNode2 = dcLine->getConverter2()->getBusInterface()->getVNom();
        double ur02 = uNode2 / unomNode2 * cos(thetaNode2 * DEG_TO_RAD);
        double ui02 = uNode2 / unomNode2 * sin(thetaNode2 * DEG_TO_RAD);
        double U202 = ur02 * ur02 + ui02 * ui02;
        if (!doubleIsZero(U202)) {
          ir02_ = (P02_ * ur02 + Q02_ * ui02) / U202;
          ii02_ = (P02_ * ui02 - Q02_ * ur02) / U202;
        }
      }
      break;
    case WARM:
      if (dcLine->getConverter1()->getBusInterface()) {
        double uNode1 = dcLine->getConverter1()->getBusInterface()->getV0();
        double thetaNode1 = dcLine->getConverter1()->getBusInterface()->getAngle0();
        double unomNode1 = dcLine->getConverter1()->getBusInterface()->getVNom();
        double ur01 = uNode1 / unomNode1 * cos(thetaNode1 * DEG_TO_RAD);
        double ui01 = uNode1 / unomNode1 * sin(thetaNode1 * DEG_TO_RAD);
        double U201 = ur01 * ur01 + ui01 * ui01;
        if (!doubleIsZero(U201)) {
          ir01_ = (P01_ * ur01 + Q01_ * ui01) / U201;
          ii01_ = (P01_ * ui01 - Q01_ * ur01) / U201;
        }
      }
      if (dcLine->getConverter2()->getBusInterface()) {
        double uNode2 = dcLine->getConverter2()->getBusInterface()->getV0();
        double thetaNode2 = dcLine->getConverter2()->getBusInterface()->getAngle0();
        double unomNode2 = dcLine->getConverter2()->getBusInterface()->getVNom();
        double ur02 = uNode2 / unomNode2 * cos(thetaNode2 * DEG_TO_RAD);
        double ui02 = uNode2 / unomNode2 * sin(thetaNode2 * DEG_TO_RAD);
        double U202 = ur02 * ur02 + ui02 * ui02;
        if (!doubleIsZero(U202)) {
          ir02_ = (P02_ * ur02 + Q02_ * ui02) / U202;
          ii02_ = (P02_ * ui02 - Q02_ * ur02) / U202;
        }
      }
      break;
    }
  }
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
    if (!network_->isStartingFromDump() || !internalVariablesFoundInDump_) {
      // get init value for state variables

      // get init value for discrete variables
      z_[state1Num_] = getConnected1();
      z_[state2Num_] = getConnected2();
    } else {
      // get init value for state variables

      // get init value for discrete variables
      setConnected1(static_cast<State>(static_cast<int>(z_[state1Num_])));
      switch (connectionState1_) {
        case CLOSED:
        {
          if (modelBus1_->getConnectionState() != CLOSED) {
            modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
            stateModified_ = true;
          }
          break;
        }
        case OPEN:
        {
          if (modelBus1_->getConnectionState() != OPEN) {
            modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
            stateModified_ = true;
          }
          break;
        }
        case CLOSED_1:
        case CLOSED_2:
        case CLOSED_3:
        {
          throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
        }
        case UNDEFINED_STATE:
        {
          throw DYNError(Error::MODELER, UndefinedComponentState, id_);
        }
      }

      setConnected2(static_cast<State>(static_cast<int>(z_[state2Num_])));
      switch (connectionState2_) {
        case CLOSED:
        {
          if (modelBus2_->getConnectionState() != CLOSED) {
            modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
            stateModified_ = true;
          }
          break;
        }
        case OPEN:
        {
          if (modelBus2_->getConnectionState() != OPEN) {
            modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
            stateModified_ = true;
          }
          break;
        }
        case CLOSED_1:
        case CLOSED_2:
        case CLOSED_3:
        {
          throw DYNError(Error::MODELER, UnsupportedComponentState, id_);
        }
        case UNDEFINED_STATE:
        {
          throw DYNError(Error::MODELER, UndefinedComponentState, id_);
        }
      }
    }
  }
}

void
ModelHvdcLink::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  // streamVariables << P01_;
  // streamVariables << Q01_;
  // streamVariables << P02_;
  // streamVariables << Q02_;
  // streamVariables << ir01_;
  // streamVariables << ii01_;
  // streamVariables << ir02_;
  // streamVariables << ii02_;
  ModelCPP::dumpInStream(streamVariables, P01_);
  ModelCPP::dumpInStream(streamVariables, Q01_);
  ModelCPP::dumpInStream(streamVariables, P02_);
  ModelCPP::dumpInStream(streamVariables, Q02_);
  ModelCPP::dumpInStream(streamVariables, ir01_);
  ModelCPP::dumpInStream(streamVariables, ii01_);
  ModelCPP::dumpInStream(streamVariables, ir02_);
  ModelCPP::dumpInStream(streamVariables, ii02_);
}

void
ModelHvdcLink::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> P01_;
  streamVariables >> c;
  streamVariables >> Q01_;
  streamVariables >> c;
  streamVariables >> P02_;
  streamVariables >> c;
  streamVariables >> Q02_;
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
ModelHvdcLink::evalStaticYType() {
  // no state variable for simple hvdc model
}

void
ModelHvdcLink::evalStaticFType() {
  // no equation for simple hvdc model because no state variable
}

void
ModelHvdcLink::setFequations(std::map<int, std::string>& /*fEquationIndex*/) {
  // no equation for simple hvdc model because no state variable
}

void
ModelHvdcLink::evalF(propertyF_t /*type*/) {
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

NetworkComponent::StateChange_t
ModelHvdcLink::evalZ(const double& /*t*/) {
  if (modelBus1_->getConnectionState() == OPEN)
    z_[state1Num_] = OPEN;
  // evaluation of the discrete variables current values
  State currState1 = static_cast<State>(static_cast<int>(z_[state1Num_]));
  if (currState1 != getConnected1()) {
    Trace::info() << DYNLog(Converter1StateChange, id_, getConnected1(), z_[state1Num_]) << Trace::endline;
    if (currState1 == OPEN) {
      DYNAddTimelineEvent(network_, id_, Converter1SwitchOff);
      modelBus1_->getVoltageLevel()->disconnectNode(modelBus1_->getBusIndex());
    } else {
      DYNAddTimelineEvent(network_, id_, Converter1Connected);
      modelBus1_->getVoltageLevel()->connectNode(modelBus1_->getBusIndex());
    }
    setConnected1(currState1);
    stateModified_ = true;
  }

  if (modelBus2_->getConnectionState() == OPEN)
    z_[state2Num_] = OPEN;

  State currState2 = static_cast<State>(static_cast<int>(z_[state2Num_]));
  if (currState2 != getConnected2()) {
    Trace::info() << DYNLog(Converter2StateChange, id_, getConnected2(), z_[state2Num_]) << Trace::endline;
    if (currState2 == OPEN) {
      DYNAddTimelineEvent(network_, id_, Converter2SwitchOff);
      modelBus2_->getVoltageLevel()->disconnectNode(modelBus2_->getBusIndex());
    } else {
      DYNAddTimelineEvent(network_, id_, Converter2Connected);
      modelBus2_->getVoltageLevel()->connectNode(modelBus2_->getBusIndex());
    }
    setConnected2(currState2);
    stateModified_ = true;
  }
  return stateModified_?NetworkComponent::STATE_CHANGE:NetworkComponent::NO_CHANGE;
}

void
ModelHvdcLink::collectSilentZ(BitMask* silentZTable) {
  silentZTable[state1Num_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[state2Num_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
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
  double U1_2 = modelBus1_->getCurrentU(ModelBus::U2PuType_);
  double U2_2 = modelBus2_->getCurrentU(ModelBus::U2PuType_);
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
ModelHvdcLink::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int> & numVars) const {
  // get the index of variables used to define the jacobian associated to a calculated variable
  switch (numCalculatedVar) {
    case p1Num_:
    case q1Num_: {
      int urYNum1 = modelBus1_->urYNum();
      int uiYNum1 = modelBus1_->uiYNum();
      numVars.push_back(urYNum1);
      numVars.push_back(uiYNum1);
      break;
    }
    case p2Num_:
    case q2Num_: {
      int urYNum2 = modelBus2_->urYNum();
      int uiYNum2 = modelBus2_->uiYNum();
      numVars.push_back(urYNum2);
      numVars.push_back(uiYNum2);
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelHvdcLink::evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const {
  switch (numCalculatedVar) {
    case p1Num_: {
      if (isConnected1() && isConnected2()) {
        double ur1 = modelBus1_->ur();
        double ui1 = modelBus1_->ui();
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
        double ur2 = modelBus2_->ur();
        double ui2 = modelBus2_->ui();
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
        double ur1 = modelBus1_->ur();
        double ui1 = modelBus1_->ui();
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
        double ur2 = modelBus2_->ur();
        double ui2 = modelBus2_->ui();
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
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelHvdcLink::evalCalculatedVarI(unsigned numCalculatedVar) const {
  double ur1 = 0.;
  double ui1 = 0.;
  double ur2 = 0.;
  double ui2 = 0.;

  switch (numCalculatedVar) {
    case p1Num_:
    case q1Num_: {
      if (isConnected1()) {
        ur1 = modelBus1_->ur();
        ui1 = modelBus1_->ui();
      }
      break;
    }
    case p2Num_:
    case q2Num_: {
      if (isConnected2()) {
        ur2 = modelBus2_->ur();
        ui2 = modelBus2_->ui();
      }
      break;
    }
  }

  double U1_2 = modelBus1_->getCurrentU(ModelBus::U2PuType_);
  double U2_2 = modelBus2_->getCurrentU(ModelBus::U2PuType_);
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
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
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
    double U1_2 = modelBus1_->getCurrentU(ModelBus::U2PuType_);
    double U2_2 = modelBus2_->getCurrentU(ModelBus::U2PuType_);
    modelBus1_->irAdd(ir1(ur1, ui1, U1_2));
    modelBus1_->iiAdd(ii1(ur1, ui1, U1_2));
    // Add current injection at point of common coupling 2
    modelBus2_->irAdd(ir2(ur2, ui2, U2_2));
    modelBus2_->iiAdd(ii2(ur2, ui2, U2_2));
  }
}

void
ModelHvdcLink::evalDerivatives(const double /*cj*/) {
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
  if (stateModified_) {
    stateModified_ = false;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelHvdcLink::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  // at point of common coupling 1
  variables.push_back(VariableNativeFactory::createState(id_ + "_state1_value", INTEGER));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q1_value", CONTINUOUS));
  // at point of common coupling 2
  variables.push_back(VariableNativeFactory::createState(id_ + "_state2_value", INTEGER));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_P2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q2_value", CONTINUOUS));
}

void
ModelHvdcLink::defineVariables(vector<shared_ptr<Variable> >& variables) {
  // at point of common coupling 1
  variables.push_back(VariableNativeFactory::createState("@ID@_state1_value", INTEGER));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P1_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q1_value", CONTINUOUS));
  // at point of common coupling 2
  variables.push_back(VariableNativeFactory::createState("@ID@_state2_value", INTEGER));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_P2_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q2_value", CONTINUOUS));
}

void
ModelHvdcLink::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  string hvdcName = id_;
  string name;
  // ========  CONNECTION STATE ======
  // at point of common coupling 1
  addElementWithValue(hvdcName + string("_state1"), "HvdcLink", elements, mapElement);
  // at point of common coupling 2
  addElementWithValue(hvdcName + string("_state2"), "HvdcLink", elements, mapElement);

  // ========  P VALUE  ======
  // at point of common coupling 1
  addElementWithValue(hvdcName + string("_P1"), "HvdcLink", elements, mapElement);
  // at point of common coupling 2
  addElementWithValue(hvdcName + string("_P2"), "HvdcLink", elements, mapElement);

  // ========  Q VALUE  ======
  // at point of common coupling 1
  addElementWithValue(hvdcName + string("_Q1"), "HvdcLink", elements, mapElement);
  // at point of common coupling 2
  addElementWithValue(hvdcName + string("_Q2"), "HvdcLink", elements, mapElement);
}

void
ModelHvdcLink::setAttributes(const std::shared_ptr<HvdcLineInterface>& dcLine) {
  // retrieve data from ConverterInterface  (IIDM)
  lossFactor1_ = dcLine->getConverter1()->getLossFactor() / 100.;
  lossFactor2_ = dcLine->getConverter2()->getLossFactor() / 100.;
  connectionState1_ = dcLine->getConverter1()->getInitialConnected() ? CLOSED : OPEN;
  connectionState2_ = dcLine->getConverter2()->getInitialConnected() ? CLOSED : OPEN;

  // retrieve data from HvdcLineInterface (IIDM)
  vdcNom_ = dcLine->getVNom();
  pSetPoint_ = dcLine->getActivePowerSetpoint();
  converterMode_ = dcLine->getConverterMode();
  rdc_ = dcLine->getResistanceDC();
}

void
ModelHvdcLink::setConvertersActivePower(const std::shared_ptr<HvdcLineInterface>& dcLine) {
  if (dcLine->getConverter1()->hasP() && dcLine->getConverter2()->hasP() && startingPointMode_ == WARM) {
    // retrieve active power at the two points of common coupling from load flow data in IIDM file
    P01_ = -dcLine->getConverter1()->getP() / SNREF;
    P02_ = -dcLine->getConverter2()->getP() / SNREF;
  } else {
    // calculate losses on dc line
    double PdcLoss = rdc_ * (pSetPoint_ / vdcNom_) * (pSetPoint_ / vdcNom_) / SNREF;  // in pu

    // calculate active power at the two points of common coupling (generator convention)
    double P0dc = pSetPoint_ / SNREF;  // in pu
    if (converterMode_ == HvdcLineInterface::RECTIFIER_INVERTER) {
      P01_ = -P0dc;  // RECTIFIER (absorbs power from the grid)
      P02_ = ((P0dc * (1 - lossFactor1_)) - PdcLoss) * (1. - lossFactor2_);  // INVERTER (injects power to the grid)
    } else {   // converterMode_ == HvdcLineInterface::INVERTER_RECTIFIER
      P01_ = ((P0dc * (1 - lossFactor2_)) - PdcLoss) * (1. - lossFactor1_);  // INVERTER (injects power to the grid)
      P02_ = -P0dc;  // RECTIFIER (absorbs power from the grid)
    }
  }
}

void
ModelHvdcLink::setConvertersReactivePower(const std::shared_ptr<HvdcLineInterface>& dcLine) {
  if (dcLine->getConverter1()->hasQ() && dcLine->getConverter2()->hasQ() && startingPointMode_ == WARM) {
    // retrieve reactive power at the two points of common coupling from load flow data in IIDM file
    Q01_ = -dcLine->getConverter1()->getQ() / SNREF;
    Q02_ = -dcLine->getConverter2()->getQ() / SNREF;
  } else {
    // calculate reactive power at the two points of common coupling from set points
    switch (dcLine->getConverter1()->getConverterType()) {
      case ConverterInterface::VSC_CONVERTER:
        {
        std::shared_ptr<VscConverterInterface> vsc1 = std::dynamic_pointer_cast<VscConverterInterface>(dcLine->getConverter1());
        std::shared_ptr<VscConverterInterface> vsc2 = std::dynamic_pointer_cast<VscConverterInterface>(dcLine->getConverter2());
        double qSetPoint1 = vsc1->getReactivePowerSetpoint();  // in Mvar (generator convention)
        double qSetPoint2 = vsc2->getReactivePowerSetpoint();  // in Mvar (generator convention)
        Q01_ = qSetPoint1 / SNREF;
        Q02_ = qSetPoint2 / SNREF;
        break;
        }
      case ConverterInterface::LCC_CONVERTER:
        {
        std::shared_ptr<LccConverterInterface> lcc1 = std::dynamic_pointer_cast<LccConverterInterface>(dcLine->getConverter1());
        std::shared_ptr<LccConverterInterface> lcc2 = std::dynamic_pointer_cast<LccConverterInterface>(dcLine->getConverter2());
        double powerFactor1 = lcc1->getPowerFactor();
        double powerFactor2 = lcc2->getPowerFactor();
        Q01_ = -abs(powerFactor1 * P01_);
        Q02_ = -abs(powerFactor2 * P02_);
        break;
        }
    }
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
ModelHvdcLink::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  bool startingPointModeFound = false;
  std::string startingPointMode = getParameterDynamicNoThrow<string>(params, "startingPointMode", startingPointModeFound);
  if (startingPointModeFound) {
    startingPointMode_ = getStartingPointMode(startingPointMode);
  }
}

}  // namespace DYN
