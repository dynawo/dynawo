// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/** @file  DYNModelBusInjected.cpp */

#include <cmath>
#include <iostream>
#include <cassert>

#include <boost/algorithm/string/predicate.hpp>

#include "PARParametersSet.h"

#include <DYNTimer.h>

#include "DYNModelBusInjected.h"
#include "DYNModelConstants.h"
#include "DYNModelNetwork.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNSparseMatrix.h"
#include "DYNDerivative.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNBusInterface.h"
#include "DYNModelSubNetwork.hpp"

using std::vector;
using boost::shared_ptr;
using std::map;
using std::string;

using parameters::ParametersSet;

namespace DYN {

ModelBusInjected::ModelBusInjected(const std::shared_ptr<BusInterface>& bus, bool isNodeBreaker) :
ModelBus(bus, isNodeBreaker),
bus_(bus),
stateUmax_(false),
stateUmin_(false),
U2Pu_(0.0),
UPu_(0.0),
U_(0.0),
irConnection_(0.0),
iiConnection_(0.0),
hasConnection_(bus->hasConnection()),
hasShortCircuitCapabilities_(false),
startingPointMode_(WARM) {
  derivatives_.reset(new BusDerivatives());
  derivativesPrim_.reset(new BusDerivatives());
  unom_ = bus->getVNom();
  uMax_ = bus->getVMax() / unom_;
  uMin_ = bus->getVMin() / unom_;
  constraintId_ = bus->getID();
  const vector<string>& busBarSections = bus->getBusBarSectionIdentifiers();
  if (isNodeBreaker && !busBarSections.empty()) {
    constraintId_ = busBarSections[0];
  }
}

void
ModelBusInjected::initSize() {
  ModelBus::initSize();
  sizeF_ = 2;
  sizeY_ = 2;  // Ur and Ui

  if (network_->isInitModel())
    return;

  if (hasConnection_ || hasShortCircuitCapabilities_)
    sizeY_ += 2;  // ir and ii
  sizeG_ += 2;  // U>Umax and U<Umin
  sizeCalculatedVar_ = nbCalculatedVariables_;
}

void
ModelBusInjected::init(int& yNum) {
  if (!(network_->isStartingFromDump() && internalVariablesFoundInDump_) && (startingPointMode_ == WARM)) {
    u0_ = bus_.lock()->getV0() / unom_;
    ur0_ = u0_ * cos(angle0_);
    ui0_ = u0_ * sin(angle0_);
  }

  urYNum_ = yNum++;
  uiYNum_ = yNum++;

  if (!network_->isInitModel() && (hasConnection_ || hasShortCircuitCapabilities_)) {
    irYNum_ = yNum++;
    iiYNum_ = yNum++;
  }
}

void
ModelBusInjected::getY0() {
  ModelBus::getY0();

  if (network_->isInitModel()) {
    y_[urNum_] = getSwitchOff() ? 0. : ur0_;
    y_[uiNum_] = getSwitchOff() ? 0. : ui0_;
    return;
  }

  if (network_->isStartingFromDump() && internalVariablesFoundInDump_) {
    ur0_ = y_[urNum_];
    ui0_ = y_[uiNum_];
    ir0_ = y_[irNum_];
    ii0_ = y_[iiNum_];
    return;
  }

  y_[urNum_] = getSwitchOff() ? 0. : ur0_;
  y_[uiNum_] = getSwitchOff() ? 0. : ui0_;
  yp_[urNum_] = 0.;
  yp_[uiNum_] = 0.;

  if (hasConnection_ || hasShortCircuitCapabilities_) {
    y_[irNum_] = ir0_;
    y_[iiNum_] = ii0_;
    yp_[irNum_] = 0.;
    yp_[iiNum_] = 0.;
  }
}

double
ModelBusInjected::ur() const {
  if (getSwitchOff())
    return 0.;

  return network_->isInit() ? ur0_ : y_[urNum_];
}

double
ModelBusInjected::ui() const {
  if (getSwitchOff())
    return 0.;

  return network_->isInit() ? ui0_ : y_[uiNum_];
}

double
ModelBusInjected::urp() const {
  if (!getSwitchOff() && !network_->isInit()) {
      return yp_[urNum_];
  } else {
    return 0.;
  }
}

double
ModelBusInjected::uip() const {
  if (!getSwitchOff() && !network_->isInit()) {
      return yp_[uiNum_];
  } else {
    return 0.;
  }
}

void
ModelBusInjected::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  bool success = false;
  double value = getParameterDynamicNoThrow<double>(params, "bus_uMax", success);
  if (success)
    uMax_ = value;

  success = false;
  value = getParameterDynamicNoThrow<double>(params, "bus_uMin", success);
  if (success)
    uMin_ = value;

  bool startingPointModeFound = false;
  const std::string startingPointMode = getParameterDynamicNoThrow<string>(params, "startingPointMode", startingPointModeFound);
  if (startingPointModeFound) {
    startingPointMode_ = getStartingPointMode(startingPointMode);
  }

  vector<string> ids;
  ids.push_back(id_);
  ids.push_back("bus");
  for (const auto& busBarSectionId : busBarSectionIdentifiers_) {
    ids.push_back(busBarSectionId);
  }
  success = false;
  const bool boolValue = getParameterDynamicNoThrow<bool>(params, "hasShortCircuitCapabilities", success, ids);
  if (success)
    hasShortCircuitCapabilities_ = boolValue;
}

void
ModelBusInjected::resetDerivatives() {
  derivatives_->reset();
  derivativesPrim_->reset();
}

void
ModelBusInjected::evalDerivatives(const double /*cj*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer3("ModelNetwork::ModelBusInjected::evalDerivatives");
#endif
  if (!network_->isInitModel() && (hasConnection_ || hasShortCircuitCapabilities_)) {
    derivatives_->addDerivative(IR_DERIVATIVE, irYNum_, -1);
    derivatives_->addDerivative(II_DERIVATIVE, iiYNum_, -1);
  }
}

void
ModelBusInjected::evalF(const propertyF_t type) {
  if (network_->isInitModel()) {
    f_[0] = ir0_;
    f_[1] = ii0_;
  } else {
    if (type == DIFFERENTIAL_EQ && !hasDifferentialVoltages_)
      return;
    if (getSwitchOff()) {
      f_[0] = y_[urNum_];
      f_[1] = y_[uiNum_];
    } else {
      f_[0] = irConnection_;
      f_[1] = iiConnection_;

      if (hasConnection_ || hasShortCircuitCapabilities_) {
        f_[0] -= y_[irNum_];
        f_[1] -= y_[iiNum_];
      }
    }
  }
}

void
ModelBusInjected::setFequations(std::map<int, std::string>& fEquationIndex) {
  if (getSwitchOff()) {
    fEquationIndex[0] = std::string(":y_[urNum_] localModel:").append(id());
    fEquationIndex[1] = std::string(":y_[uiNum_] localModel:").append(id());
  } else {
    fEquationIndex[0] = std::string("irConnection_ localModel:").append(id());
    fEquationIndex[1] = std::string("iiConnection_ localModel:").append(id());

    if (hasConnection_ || hasShortCircuitCapabilities_) {
      fEquationIndex[0] = std::string("irConnection_ - y_[irNum_] localModel:").append(id());
      fEquationIndex[1] = std::string("iiConnection_ - y_[iiNum_] localModel:").append(id());
    }
  }

  assert(fEquationIndex.size() == static_cast<size_t>(sizeF()) && "ModelBusInjected: fEquationIndex.size != f_.size()");
}

void
ModelBusInjected::resetNodeInjection() {
  if (network_->isInit() || network_->isInitModel()) {
    ir0_ = 0.0;
    ii0_ = 0.0;
  } else {
    irConnection_ = 0.0;
    iiConnection_ = 0.0;
  }
}

void
ModelBusInjected::irAdd(const double ir) {
  if (network_->isInit() || network_->isInitModel()) {
    ir0_ += ir;
  } else {
    irConnection_ += ir;
  }
}

void
ModelBusInjected::iiAdd(const double ii) {
  if (network_->isInit() || network_->isInitModel()) {
    ii0_ += ii;
  } else {
    iiConnection_ += ii;
  }
}

void
ModelBusInjected::collectSilentZ(BitMask* silentZTable) {
  silentZTable[numSubNetworkNum_].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations);
  silentZTable[connectionStateNum_].setFlags(NotUsedInDiscreteEquations);
}

void
ModelBusInjected::evalStaticYType() {
  if (!network_->isInitModel() && (hasConnection_ || hasShortCircuitCapabilities_)) {
    yType_[2] = ALGEBRAIC;
    yType_[3] = ALGEBRAIC;
  }
}

void
ModelBusInjected::evalDynamicYType() {
  if (hasDifferentialVoltages_ && !getSwitchOff()) {
    yType_[0] = DIFFERENTIAL;
    yType_[1] = DIFFERENTIAL;
  } else {
    yType_[0] = ALGEBRAIC;
    yType_[1] = ALGEBRAIC;
  }
}

void
ModelBusInjected::evalDynamicFType() {
  fType_[0] = ALGEBRAIC_EQ;
  fType_[1] = ALGEBRAIC_EQ;
  if (hasDifferentialVoltages_ && !getSwitchOff()) {
    fType_[0] = DIFFERENTIAL_EQ;
    fType_[1] = DIFFERENTIAL_EQ;
  }
}

void
ModelBusInjected::evalCalculatedVars() {
  if (getSwitchOff() || voltageIsZero()) {
    calculatedVars_[upuNum_] = 0.;
    calculatedVars_[phipuNum_] = 0.;
    calculatedVars_[uNum_] = 0.;
    calculatedVars_[phiNum_] = 0.;
  } else {
    calculatedVars_[uNum_] = getCurrentU(ModelBusInjected::UType_);
    calculatedVars_[upuNum_] = getCurrentU(ModelBusInjected::UPuType_);
    calculatedVars_[phipuNum_] = atan2(y_[uiNum_], y_[urNum_]);
    calculatedVars_[phiNum_] = calculatedVars_[phipuNum_] * RAD_TO_DEG;
  }
}

void
ModelBusInjected::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  ModelCPP::dumpInStream(streamVariables, angle0_);
  ModelCPP::dumpInStream(streamVariables, u0_);
  ModelCPP::dumpInStream(streamVariables, U_);
  ModelCPP::dumpInStream(streamVariables, U2Pu_);
  ModelCPP::dumpInStream(streamVariables, UPu_);
}

void
ModelBusInjected::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> angle0_;
  streamVariables >> c;
  streamVariables >> u0_;
  streamVariables >> c;
  streamVariables >> U_;
  streamVariables >> c;
  streamVariables >> U2Pu_;
  streamVariables >> c;
  streamVariables >> UPu_;
}

void
ModelBusInjected::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_Upu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_phipu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_U_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated(id_ + "_phi_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN_V_re", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN_V_im", CONTINUOUS));
  if (hasConnection_ || hasShortCircuitCapabilities_) {
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN_i_re", FLOW));
    variables.push_back(VariableNativeFactory::createState(id_ + "_ACPIN_i_im", FLOW));
  }
  ModelBus::instantiateVariables(variables);  // Z variables

  for (unsigned int i = 0; i < busBarSectionIdentifiers_.size(); ++i) {
    std::string busBarSectionId = busBarSectionIdentifiers_[i];
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_Upu_value", id_ + "_Upu_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_phipu_value", id_ + "_phipu_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_U_value", id_ + "_U_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_phi_value", id_ + "_phi_value"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_V_re", id_ + "_ACPIN_V_re"));
    variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_V_im", id_ + "_ACPIN_V_im"));
    if (hasConnection_ || hasShortCircuitCapabilities_) {
      variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_i_re", id_ + "_ACPIN_i_re"));
      variables.push_back(VariableAliasFactory::create(busBarSectionId + "_ACPIN_i_im", id_ + "_ACPIN_i_im"));
    }
  }
}

void
ModelBusInjected::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("bus_uMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("bus_uMin", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("bus_hasShortCircuitCapabilities", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
}

void
ModelBusInjected::defineNonGenericParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(id_ + "_hasShortCircuitCapabilities", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  for (auto& busBarSectionId : busBarSectionIdentifiers_) {
    parameters.push_back(ParameterModeler(busBarSectionId + "_hasShortCircuitCapabilities", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));
  }
}

void
ModelBusInjected::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_Upu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_phipu_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_U_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("@ID@_phi_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN_V_re", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN_V_im", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN_i_re", FLOW));
  variables.push_back(VariableNativeFactory::createState("@ID@_ACPIN_i_im", FLOW));
  ModelBus::defineVariables(variables);  // Z variables
}

void
ModelBusInjected::defineElementsById(const std::string& id, std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  const string ACName = id + string("_ACPIN");
  addElement(ACName, Element::STRUCTURE, elements, mapElement);
  const string ACNameV = id + string("_ACPIN_V");
  addSubElement("V", ACName, Element::STRUCTURE, id_, modelType_, elements, mapElement);
  addSubElement("re", ACNameV, Element::TERMINAL, id_, modelType_, elements, mapElement);
  addSubElement("im", ACNameV, Element::TERMINAL, id_, modelType_, elements, mapElement);
  if (hasConnection_ || hasShortCircuitCapabilities_) {
    const string ACNameI = id + string("_ACPIN_i");
    addSubElement("i", ACName, Element::STRUCTURE, id_, modelType_, elements, mapElement);
    addSubElement("re", ACNameI, Element::TERMINAL, id_, modelType_, elements, mapElement);
    addSubElement("im", ACNameI, Element::TERMINAL, id_, modelType_, elements, mapElement);
  }

  // Calculated variables addition
  addElementWithValue(id + string("_Upu"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_phipu"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_U"), modelType_, elements, mapElement);
  addElementWithValue(id + string("_phi"), modelType_, elements, mapElement);

  ModelBus::defineElementsById(id, elements, mapElement);
}

static const bool U_SUP = true;
static const bool U_INF = false;
static const bool CSTR_BEGIN = true;
static const bool CSTR_END = false;

void
ModelBusInjected::logConstraint(bool sup, bool begin) {
  using constraints::ConstraintData;
  Message msg(Message::CONSTRAINT_KEY, KeyConstraint_t::names(sup ? KeyConstraint_t::USupUmax : KeyConstraint_t::UInfUmin));
  ConstraintData data(sup ? ConstraintData::USupUmax : ConstraintData::UInfUmin, (sup ? uMax_: uMin_)*unom_, getCurrentU(ModelBus::UType_));
  network_->addConstraint(constraintId_, begin, msg, modelType_, data);
}

NetworkComponent::StateChange_t
ModelBusInjected::evalZ(const double /*t*/, bool onlyEvaluateStateChange) {
  using constraints::ConstraintData;

  if (!onlyEvaluateStateChange && network_->hasConstraints()) {
    if (g_[0] == ROOT_UP) {
      logConstraint(U_SUP, CSTR_BEGIN);
      stateUmax_ = true;
    } else if (g_[0] == ROOT_DOWN && stateUmax_) {
      logConstraint(U_SUP, CSTR_END);
      stateUmax_ = false;
    }

    if (g_[1] == ROOT_UP) {
      logConstraint(U_INF, CSTR_BEGIN);
      stateUmin_ = true;
    } else if (g_[1] == ROOT_DOWN && stateUmin_) {
      logConstraint(U_INF, CSTR_END);
      stateUmin_ = false;
    }
  }

  refreshConnectionStateFromZ(DO_LOG_TIMELINE);
  return topologyModified_? NetworkComponent::TOPO_CHANGE: NetworkComponent::NO_CHANGE;
}

void
ModelBusInjected::evalG(const double /*t*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelBusInjected::evalG");
#endif
  if (!network_->hasConstraints()) return;
  const double upu = getCurrentU(ModelBusInjected::UPuType_);
  g_[0] = (upu - uMax_ > 0) ? ROOT_UP : ROOT_DOWN;  // U > Umax
  g_[1] = (uMin_ - upu > 0 && !getSwitchOff()) ? ROOT_UP : ROOT_DOWN;  // U < Umin
}

void
ModelBusInjected::setGequations(std::map<int, std::string>& gEquationIndex) {
  gEquationIndex[0] = "U > UMax localModel:"+id();
  gEquationIndex[1] = "U < UMin localModel:"+id();

  assert(gEquationIndex.size() == static_cast<size_t>(sizeG()) && "Model Bus: gEquationIndex.size() != g_.size()");
}

void
ModelBusInjected::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
  switch (numCalculatedVar) {
    case upuNum_:
    case phipuNum_:
    case uNum_:
    case phiNum_:
      numVars.push_back(urYNum_);
      numVars.push_back(uiYNum_);
      break;
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

void
ModelBusInjected::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  const double ur = y_[urNum_];
  const double ui = y_[uiNum_];
  switch (numCalculatedVar) {
    case upuNum_: {
      if (getSwitchOff() || voltageIsZero()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        res[0] = ur * 1 / sqrt(ur * ur + ui * ui);
        res[1] = ui * 1 / sqrt(ur * ur + ui * ui);
      }
      break;
    }
    case phipuNum_: {
      if (getSwitchOff() || voltageIsZero()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        const double v3 = 1 / ur;
        const double v2 = 1 / (1 + pow(ui / ur, 2));
        res[0] = -ui * pow(ur, -2) * v2;
        res[1] = v3*v2;
      }
      break;
    }
    case uNum_: {
      if (getSwitchOff() || voltageIsZero()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        res[0] = ur * 1 / sqrt(ur * ur + ui * ui) * unom_;
        res[1] = ui * 1 / sqrt(ur * ur + ui * ui) * unom_;
      }
      break;
    }
    case phiNum_: {
      if (getSwitchOff() || voltageIsZero()) {
        res[0] = 0.0;
        res[1] = 0.0;
      } else {
        const double v3 = 1 / ur;
        const double v2 = 1 / (1 + pow(ui / ur, 2));
        res[0] = -ui * pow(ur, -2) * v2*RAD_TO_DEG;
        res[1] = v3 * v2*RAD_TO_DEG;
      }
      break;
    }
    default:
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
  }
}

double
ModelBusInjected::evalCalculatedVarI(unsigned numCalculatedVar) const {
  double output = 0.0;
  const double ur = y_[urNum_];
  const double ui = y_[uiNum_];
  switch (numCalculatedVar) {
    case upuNum_:
      if (getSwitchOff() || voltageIsZero())
        output = 0.0;
      else
        output = sqrt(ur * ur + ui * ui);  // Voltage module in pu
      break;
    case phipuNum_:
      if (getSwitchOff() || voltageIsZero())
        output = 0.0;
      else
        output = atan2(ui, ur);  // Voltage angle in pu
      break;
    case uNum_:
      if (getSwitchOff() || voltageIsZero())
        output = 0.0;
      else
        output = sqrt(ur * ur + ui * ui) * unom_;  // Voltage module in kV
      break;
    case phiNum_:
      if (getSwitchOff() || voltageIsZero())
        output = 0.0;
      else
        output = atan2(ui, ur) * RAD_TO_DEG;  // Voltage angle in degree
      break;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
  }
  return output;
}

void
ModelBusInjected::evalJt(const double /*cj*/, const int rowOffset, SparseMatrix& jt) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelBusInjected::evalJt");
#endif

  if (getSwitchOff()) {
    jt.changeCol();
    jt.addTerm(urYNum() + rowOffset, 1.0);
    jt.changeCol();
    jt.addTerm(uiYNum() + rowOffset, 1.0);
  } else if (derivatives_->empty()) {  // Disconnected bus
    jt.changeCol();
    jt.changeCol();
  } else {
    // Column for the real part of the node current
    // ----------------------------------
    // Switching column
    jt.changeCol();
    const auto& irDerivativesValues = derivatives_->getValues(IR_DERIVATIVE);
    const auto& irDerivativesIndices = derivatives_->getIndices(IR_DERIVATIVE);
    for (unsigned int i = 0 ; i < irDerivativesIndices.size(); ++i) {
      jt.addTerm(irDerivativesIndices[i] + rowOffset, irDerivativesValues[i]);
    }

    // Column for the imaginary part of the node current
    // ---------------------------------------
    // Switching column
    jt.changeCol();
    const auto& iiDerivativesValues = derivatives_->getValues(II_DERIVATIVE);
    const auto& iiDerivativesIndices = derivatives_->getIndices(II_DERIVATIVE);
    for (unsigned int i = 0 ; i < iiDerivativesIndices.size(); ++i) {
      jt.addTerm(iiDerivativesIndices[i] + rowOffset, iiDerivativesValues[i]);
    }
  }
}

void
ModelBusInjected::evalJtPrim(const int rowOffset, SparseMatrix& jtPrim) {
  // y' in network equations - differential voltages
  if (hasDifferentialVoltages_ && !getSwitchOff() && !derivativesPrim_->empty()) {
    jtPrim.changeCol();
    const auto& irDerivativesValues = derivativesPrim_->getValues(IR_DERIVATIVE);
    const auto& irDerivativesIndices = derivativesPrim_->getIndices(IR_DERIVATIVE);
    for (unsigned int i = 0 ; i < irDerivativesIndices.size(); ++i) {
      jtPrim.addTerm(irDerivativesIndices[i] + rowOffset, irDerivativesValues[i]);
    }

    jtPrim.changeCol();
    const auto& iiDerivativesValues = derivativesPrim_->getValues(II_DERIVATIVE);
    const auto& iiDerivativesIndices = derivativesPrim_->getIndices(II_DERIVATIVE);
    for (unsigned int i = 0 ; i < iiDerivativesIndices.size(); ++i) {
      jtPrim.addTerm(iiDerivativesIndices[i] + rowOffset, iiDerivativesValues[i]);
    }
  } else {
    // no y' in network equations, we only change the column index in Jacobian
    // column change - real part of the node current
    jtPrim.changeCol();
    // column change - imaginary part of the node current
    jtPrim.changeCol();
  }
}

NetworkComponent::StateChange_t
ModelBusInjected::evalState(const double /*time*/) {
  StateChange_t state = NetworkComponent::NO_CHANGE;
  if (topologyModified_) {
    topologyModified_ = false;
    state = NetworkComponent::TOPO_CHANGE;
  }
  return state;
}

void
ModelBusInjected::switchOff() {
  ModelBus::switchOff();
  // force Ur and Ui to be equals to zero (easier to solve)
  if (y_ != NULL) {
    y_[urNum_] = 0.0;
    y_[uiNum_] = 0.0;
  }
}

void
ModelBusInjected::resetCurrentUStatus() {
  currentUStatus_.reset();
}

double
ModelBusInjected::getCurrentU(const UType_t currentURequested) {
  if (getSwitchOff())
    return 0;
  switch (currentURequested) {
    case UType_:
      if (currentUStatus_.getFlags(U)) {
        return U_;
      } else if (currentUStatus_.getFlags(UPu)) {
        U_ = calculateU();
        currentUStatus_.setFlags(U);
        return U_;
      } else if (currentUStatus_.getFlags(U2Pu)) {
        UPu_ = sqrt(U2Pu_);
        U_ = calculateU();
        currentUStatus_.setFlags(UPu | U);
        return U_;
      } else {
        U2Pu_ = calculateU2Pu();
        UPu_ = sqrt(U2Pu_);
        U_ = calculateU();
        currentUStatus_.setFlags(U2Pu | UPu | U);
        return U_;
      }
    case UPuType_:
      if (currentUStatus_.getFlags(UPu)) {
        return UPu_;
      } else if (currentUStatus_.getFlags(U2Pu)) {
        UPu_ = sqrt(U2Pu_);
        currentUStatus_.setFlags(UPu);
        return UPu_;
      } else {
        U2Pu_ = calculateU2Pu();
        UPu_ = sqrt(U2Pu_);
        currentUStatus_.setFlags(U2Pu | UPu);
        return UPu_;
      }
    case U2PuType_:
      if (currentUStatus_.getFlags(U2Pu)) {
        return U2Pu_;
      } else {
        U2Pu_ = calculateU2Pu();
        currentUStatus_.setFlags(U2Pu);
        return U2Pu_;
      }
  }
  return 0;
}

double
ModelBusInjected::calculateU2Pu() const {
  const double urPu = ur();
  const double uiPu = ui();
  return urPu * urPu + uiPu * uiPu;
}

}  // namespace DYN
