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
 * @file  DYNUpdatableBoolean.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNUpdatableBoolean.h"
#include "DYNUpdatableBoolean.hpp"
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
  return (new DYN::UpdatableBooleanFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::UpdatableBooleanFactory::create() const {
  DYN::SubModel* model(new DYN::UpdatableBoolean());
  return model;
}

extern "C" void DYN::UpdatableBooleanFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

UpdatableBoolean::UpdatableBoolean() :
ModelCPP("UpdatableBoolean"),
inputValue_(0.),
updated_(false) {
  isUpdatableDuringSimulation_ = true;
}

void
UpdatableBoolean::init(const double /*t0*/) {
  // not needed
}

void
UpdatableBoolean::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
UpdatableBoolean::initializeStaticData() {
  // not needed
}

void
UpdatableBoolean::getSize() {
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of F(t,y,y') function
void
UpdatableBoolean::evalF(double /*t*/, propertyF_t type) {
}


// evaluation of root functions
void
UpdatableBoolean::evalG(const double /*t*/) {
  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

// evaluation of root functions
void
UpdatableBoolean::evalZ(const double /*t*/) {
  // not needed
}

void
UpdatableBoolean::setFequations() {
}

void
UpdatableBoolean::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableBoolean::evalJt(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& jt) {
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableBoolean::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& jt) {
}

void
UpdatableBoolean::collectSilentZ(BitMask* /*silentZTable*/) {
  // not needed
}

// evaluation of modes (alternatives) of F(t,y,y') functions
modeChangeType_t
UpdatableBoolean::evalMode(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

void
UpdatableBoolean::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // not needed
}

void
UpdatableBoolean::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // not needed
}

double
UpdatableBoolean::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return inputValue_;
}

void
UpdatableBoolean::evalCalculatedVars() {
  calculatedVars_[inputValueIdx_] = inputValue_;
}

void
UpdatableBoolean::getY0() {
}

void
UpdatableBoolean::evalStaticYType() {
}

void
UpdatableBoolean::evalStaticFType() {
}

void
UpdatableBoolean::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("input_value", BOOLEAN));
}

void
UpdatableBoolean::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("input_value", VAR_TYPE_BOOL, INTERNAL_PARAMETER));
}

void
UpdatableBoolean::setSubModelParameters() {
  // not needed
}

void
UpdatableBoolean::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement("input", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "input", Element::TERMINAL, name(), modelType(), elements, mapElement);
}

void
UpdatableBoolean::updateParameters(std::shared_ptr<ParametersSet>& parametersSet) {
  const std::shared_ptr<Parameter> param = parametersSet->getParameter("input_value");
  if (param->getType() == Parameter::ParameterType::BOOL) {
    inputValue_ = fromNativeBool(param->getBool());
    updated_ = true;
    Trace::debug() << "UpdatableBoolean: updated value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterBadType, param->getName());
  }
}

void
UpdatableBoolean::updateParameter(const std::string& name, double value)  {
  if (!name.compare("input_value")) {
    inputValue_ = value;
    updated_ = true;
    Trace::debug() << "UpdatableBoolean: updated value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterNotDefined, name);
  }
}

}  // namespace DYN
