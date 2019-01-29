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
 * @file  DYNModelShuntCompensator.cpp
 *
 * @brief
 *
 */
#include "DYNModelShuntCompensator.h"

#include "PARParametersSet.h"

#include "DYNModelBus.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNTimer.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNDerivative.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNBusInterface.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNMessageTimeline.h"
#include "DYNModelVoltageLevel.h"

using boost::shared_ptr;

using std::vector;
using std::map;
using std::string;

using parameters::ParametersSet;

namespace DYN {

ModelShuntCompensator::ModelShuntCompensator(const shared_ptr<ShuntCompensatorInterface>& shunt) :
Impl(shunt->getID()),
modelBus_(),
noReclosingDelay_(0.) {
  // init data
  suscepPerSect_ = shunt->getBPerSection();
  currentSection_ = shunt->getCurrentSection();
  maximumSection_ = shunt->getMaximumSection();
  vNom_ = shunt->getVNom();
  suscepPu_ = (suscepPerSect_ * currentSection_) * vNom_ * vNom_ / SNREF;
  tLastOpening_ = VALDEF;
  type_ = (suscepPerSect_ > 0) ? CAPACITOR : REACTANCE;
  connectionState_ = shunt->getInitialConnected() ? CLOSED : OPEN;

  double Q = shunt->getQ() / SNREF;
  double uNode = shunt->getBusInterface()->getV0();
  double tetaNode = shunt->getBusInterface()->getAngle0();
  double unomNode = shunt->getBusInterface()->getVNom();
  double ur0 = uNode / unomNode * cos(tetaNode * DEG_TO_RAD);
  double ui0 = uNode / unomNode * sin(tetaNode * DEG_TO_RAD);
  ir0_ = Q * ui0 / (ur0 * ur0 + ui0 * ui0);
  ii0_ = - Q * ur0 / (ur0 * ur0 + ui0 * ui0);
}

void
ModelShuntCompensator::initSize() {
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
    sizeZ_ = 4;  // connectionState, isCapacitor, isAvailable, currentSection
    sizeG_ = 1;  // time out for availability
    sizeMode_ = 1;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

double
ModelShuntCompensator::ir(const double& ui) const {
  double ir = 0.;
  if (isConnected()) {
    ir = -suscepPu_ * ui;
  }
  return ir;
}

double
ModelShuntCompensator::ii(const double& ur) const {
  double ii = 0.;
  if (isConnected()) {
    ii = suscepPu_ * ur;
  }
  return ii;
}

double
ModelShuntCompensator::ir_dUr() const {
  return 0.;
}

double
ModelShuntCompensator::ir_dUi() const {
  double ir_dUi = 0.;
  if (isConnected()) {
    ir_dUi = -suscepPu_;
  }

  return ir_dUi;
}

double
ModelShuntCompensator::ii_dUr() const {
  double ii_dUr = 0.;
  if (isConnected()) {
    ii_dUr = suscepPu_;
  }
  return ii_dUr;
}

double
ModelShuntCompensator::ii_dUi() const {
  return 0.;
}

void
ModelShuntCompensator::evalNodeInjection() {
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
ModelShuntCompensator::evalYMat() {
  /* not needed */
}

void
ModelShuntCompensator::evalDerivatives() {
  if (isConnected()) {
    int urYNum = modelBus_->urYNum();
    int uiYNum = modelBus_->uiYNum();
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, urYNum, ir_dUr());
    modelBus_->derivatives()->addDerivative(IR_DERIVATIVE, uiYNum, ir_dUi());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, urYNum, ii_dUr());
    modelBus_->derivatives()->addDerivative(II_DERIVATIVE, uiYNum, ii_dUi());
  }
}

void
ModelShuntCompensator::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(id_ + "_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_isCapacitor_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_isAvailable_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState(id_ + "_currentSection_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Q_value", CONTINUOUS));
}

void
ModelShuntCompensator::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("@ID@_state_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_isCapacitor_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_isAvailable_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createState("@ID@_currentSection_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Q_value", CONTINUOUS));
}

void
ModelShuntCompensator::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  string shName = id_;
  // ========  CONNECTION STATE ======
  string name = shName + string("_state");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ======== IS CAPACITOR =========
  name = shName + string("_isCapacitor");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ======== IS Available =========
  name = shName + string("_isAvailable");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ========  CURRENT SECTION ======
  name = shName + string("_currentSection");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);

  // ======== Q value ===============
  name = shName + string("_Q");
  addElement(name, Element::STRUCTURE, elements, mapElement);
  addSubElement("value", name, Element::TERMINAL, elements, mapElement);
}

void
ModelShuntCompensator::evalG(const double& t) {
  // Time out reached for availability
  g_[0] = (t >= tLastOpening_ + noReclosingDelay_) ? ROOT_UP : ROOT_DOWN;
}

void
ModelShuntCompensator::evalZ(const double& t) {
  z_[0] = getConnected();
  z_[1] = isCapacitor() ? 1. : 0.;
  z_[2] = isAvailable(t) ? 1. : 0.;
  z_[3] = getCurrentSection();
}

void
ModelShuntCompensator::getY0() {
  if (!network_->isInitModel()) {
    z_[0] = getConnected();
    z_[1] = isCapacitor() ? 1. : 0.;
    z_[2] = 1.;  // always available at the beginning of the simulation
    z_[3] = getCurrentSection();
  }
}

bool
ModelShuntCompensator::isAvailable(const double& t) const {
  if (modelBus_->getVoltageLevel()->isClosestBBSSwitchedOff(modelBus_)) {
    return false;
  } else {
    if (tLastOpening_ != VALDEF)
      return (t >= tLastOpening_ + noReclosingDelay_);

    return true;
  }
}

void
ModelShuntCompensator::setSubModelParameters(const std::tr1::unordered_map<std::string, ParameterModeler>& params) {
  try {
    switch (type_) {
      case CAPACITOR: {
        vector<string> ids;
        ids.push_back(id_);
        ids.push_back("CAPACITOR");
        noReclosingDelay_ = getParameterDynamic<double>(params, "no_reclosing_delay", ids);
        break;
      }
      case REACTANCE: {
        vector<string> ids;
        ids.push_back(id_);
        ids.push_back("REACTANCE");
        noReclosingDelay_ = getParameterDynamic<double>(params, "no_reclosing_delay", ids);
        break;
      }
    }
  } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    throw DYNError(Error::MODELER, ParameterNotFoundFor, id_);
  }
}

void
ModelShuntCompensator::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("CAPACITOR_no_reclosing_delay", DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("REACTANCE_no_reclosing_delay", DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelShuntCompensator::defineNonGenericParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(id_ + "_no_reclosing_delay", DOUBLE, EXTERNAL_PARAMETER));
}

NetworkComponent::StateChange_t
ModelShuntCompensator::evalState(const double& time) {
  if ((State) z_[0] != getConnected()) {
    Trace::debug() << DYNLog(ShuntStateChange, id_, getConnected(), z_[0]) << Trace::endline;
    if ((State) z_[0] == OPEN) {
      network_->addEvent(id_, DYNTimeline(ShuntDisconnected));
      tLastOpening_ = time;
      setConnected(OPEN);
      currentSection_ = 0;
      modelBus_->getVoltageLevel()->disconnectNode(modelBus_->getBusIndex());
    } else {
      network_->addEvent(id_, DYNTimeline(ShuntConnected));
      setConnected(CLOSED);
      currentSection_ = maximumSection_;
      modelBus_->getVoltageLevel()->connectNode(modelBus_->getBusIndex());
    }
    suscepPu_ = (suscepPerSect_ * currentSection_) * vNom_ * vNom_ / SNREF;
    return NetworkComponent::STATE_CHANGE;
  }
  return NetworkComponent::NO_CHANGE;
}

void
ModelShuntCompensator::evalCalculatedVars() {
  double ur = modelBus_->ur();
  double ui = modelBus_->ui();
  double i1 = ir(ui);
  double i2 = ii(ur);
  calculatedVars_[qNum_] = (ui * i1 - ur * i2);   // Q value
}

void
ModelShuntCompensator::getDefJCalculatedVarI(int numCalculatedVar, std::vector<int>& numVars) {
  switch (numCalculatedVar) {
    case qNum_: {
      if (isConnected()) {
        int urYNum = modelBus_->urYNum();
        int uiYNum = modelBus_->uiYNum();
        numVars.push_back(urYNum);
        numVars.push_back(uiYNum);
      }
      break;
    }
  }
}

void
ModelShuntCompensator::evalJCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/, std::vector<double>& res) {
  switch (numCalculatedVar) {
    case qNum_: {
      if (isConnected()) {
        double ur = y[0];
        double ui = y[1];
         // q = -ui*ui*suscepPu_ - ur*ur*suscepPu_
        res[0] = -2. * ur * suscepPu_;  // @Q/@ur
        res[1] = -2. * ui * suscepPu_;  // @Q/@ui
      }
      break;
    }
  }
}

double
ModelShuntCompensator::evalCalculatedVarI(int numCalculatedVar, double* y, double* /*yp*/) {
  switch (numCalculatedVar) {
    case qNum_: {
      if (isConnected()) {
        double ur = y[0];
        double ui = y[1];
        double ir = -suscepPu_ * ui;
        double ii = suscepPu_ * ur;
        return (ui * ir - ur * ii);   // Q value
      }
      break;
    }
  }
  return 0.;
}

void
ModelShuntCompensator::init(int& /*yNum*/) {
  /* not needed */
}

void
ModelShuntCompensator::evalJt(SparseMatrix& /*jt*/, const double& /*cj*/, const int& /*rowOffset*/) {
  /* not needed */
}

void
ModelShuntCompensator::evalJtPrim(SparseMatrix& /*jt*/, const int& /*rowOffset*/) {
  /* not needed */
}

void
ModelShuntCompensator::setFequations(std::map<int, std::string>& /*fEquationIndex*/) {
  // No F equation
}

void
ModelShuntCompensator::setGequations(std::map<int, std::string>& gEquationIndex) {
  gEquationIndex[0] = "Time out reached for reclosing delay";

  assert(gEquationIndex.size() == (unsigned int) sizeG() && "Shunt compensator model: gEquationIndex.size() != gLocal_.size()");
}

}  // namespace DYN
