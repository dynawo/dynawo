//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNUpdatableParameterDiscrete.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNUpdatableParameterDiscrete.h"
#include "DYNUpdatableParameterDiscrete.hpp"
#include "DYNSparseMatrix.h"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"

using std::vector;
using std::string;
using std::map;

using boost::shared_ptr;

using parameters::ParametersSet;
using parameters::Parameter;


extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::UpdatableParameterDiscreteFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::UpdatableParameterDiscreteFactory::create() const {
  DYN::SubModel* model(new DYN::UpdatableParameterDiscrete());
  return model;
}

extern "C" void DYN::UpdatableParameterDiscreteFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

UpdatableParameterDiscrete::UpdatableParameterDiscrete() :
ModelCPP("UpdatableParameterDiscrete"),
inputValue_(0.),
updated_(false) {
  isUpdatableDuringSimulation_ = true;
}

void
UpdatableParameterDiscrete::init(const double /*t0*/) {
  // not needed
}

void
UpdatableParameterDiscrete::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
UpdatableParameterDiscrete::initializeStaticData() {
  // not needed
}

void
UpdatableParameterDiscrete::getSize() {
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of F(t,y,y') function
void
UpdatableParameterDiscrete::evalF(double /*t*/, propertyF_t type) {
}


// evaluation of root functions
void
UpdatableParameterDiscrete::evalG(const double /*t*/) {
  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

// evaluation of root functions
void
UpdatableParameterDiscrete::evalZ(const double /*t*/) {
  // not needed
}

void
UpdatableParameterDiscrete::setFequations() {
}

void
UpdatableParameterDiscrete::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableParameterDiscrete::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int /*rowOffset*/) {
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableParameterDiscrete::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int /*rowOffset*/) {
}

void
UpdatableParameterDiscrete::collectSilentZ(BitMask* /*silentZTable*/) {
  // not needed
}

// evaluation of modes (alternatives) of F(t,y,y') functions
modeChangeType_t
UpdatableParameterDiscrete::evalMode(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

void
UpdatableParameterDiscrete::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // not needed
}

void
UpdatableParameterDiscrete::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // not needed
}

double
UpdatableParameterDiscrete::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return inputValue_;
}

void
UpdatableParameterDiscrete::evalCalculatedVars() {
  calculatedVars_[inputValueIdx_] = inputValue_;
}

void
UpdatableParameterDiscrete::getY0() {
}

void
UpdatableParameterDiscrete::evalStaticYType() {
}

void
UpdatableParameterDiscrete::evalStaticFType() {
}

void
UpdatableParameterDiscrete::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("input_value", DISCRETE));
}

void
UpdatableParameterDiscrete::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("external_input", VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
}

void
UpdatableParameterDiscrete::setSubModelParameters() {
  // not needed
}

void
UpdatableParameterDiscrete::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement("input", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "input", Element::TERMINAL, name(), modelType(), elements, mapElement);
}

void
UpdatableParameterDiscrete::updateParameters(std::shared_ptr<ParametersSet>& parametersSet) {
  const std::shared_ptr<Parameter> param = parametersSet->getParameter("external_input");
  if (param->getType() == Parameter::ParameterType::INT) {
    inputValue_ = param->getInt();
    updated_ = true;
    Trace::debug() << "UpdatableParameterDiscrete: updated int value : " << inputValue_ << Trace::endline;
  } else if (param->getType() == Parameter::ParameterType::BOOL) {
    inputValue_ = param->getBool();
    updated_ = true;
    Trace::debug() << "UpdatableParameterDiscrete: updated bool value : " << inputValue_ << Trace::endline;
  } else if (param->getType() == Parameter::ParameterType::DOUBLE) {
    inputValue_ = param->getDouble();
    updated_ = true;
    Trace::debug() << "UpdatableParameterDiscrete: updated double value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterBadType, param->getName());
  }
}

void
UpdatableParameterDiscrete::updateParameter(const std::string& name, double value)  {
  if (!name.compare("external_input")) {
    inputValue_ = value;
    updated_ = true;
    Trace::debug() << "UpdatableParameterDiscrete --> updated value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterNotDefined, name);
  }
}

}  // namespace DYN
