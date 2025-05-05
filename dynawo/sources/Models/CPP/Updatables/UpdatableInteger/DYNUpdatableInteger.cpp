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
 * @file  DYNUpdatableInteger.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNUpdatableInteger.h"
#include "DYNUpdatableInteger.hpp"
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
  return (new DYN::UpdatableIntegerFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::UpdatableIntegerFactory::create() const {
  DYN::SubModel* model(new DYN::UpdatableInteger());
  return model;
}

extern "C" void DYN::UpdatableIntegerFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

UpdatableInteger::UpdatableInteger() :
ModelCPP("UpdatableInteger"),
inputValue_(0.),
updated_(false) {
  isUpdatableDuringSimulation_ = true;
}

void
UpdatableInteger::init(const double /*t0*/) {
  // not needed
}

void
UpdatableInteger::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
UpdatableInteger::initializeStaticData() {
  // not needed
}

void
UpdatableInteger::getSize() {
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of F(t,y,y') function
void
UpdatableInteger::evalF(double /*t*/, propertyF_t type) {
}


// evaluation of root functions
void
UpdatableInteger::evalG(const double /*t*/) {
  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

// evaluation of root functions
void
UpdatableInteger::evalZ(const double /*t*/) {
  // not needed
}

void
UpdatableInteger::setFequations() {
}

void
UpdatableInteger::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableInteger::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int /*rowOffset*/) {
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableInteger::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int /*rowOffset*/) {
}

void
UpdatableInteger::collectSilentZ(BitMask* /*silentZTable*/) {
  // not needed
}

// evaluation of modes (alternatives) of F(t,y,y') functions
modeChangeType_t
UpdatableInteger::evalMode(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

void
UpdatableInteger::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // not needed
}

void
UpdatableInteger::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // not needed
}

double
UpdatableInteger::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return inputValue_;
}

void
UpdatableInteger::evalCalculatedVars() {
  calculatedVars_[inputValueIdx_] = inputValue_;
}

void
UpdatableInteger::getY0() {
}

void
UpdatableInteger::evalStaticYType() {
}

void
UpdatableInteger::evalStaticFType() {
}

void
UpdatableInteger::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("input_value", INTEGER));
}

void
UpdatableInteger::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("input_value", VAR_TYPE_INT, INTERNAL_PARAMETER));
}

void
UpdatableInteger::setSubModelParameters() {
  // not needed
}

void
UpdatableInteger::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement("input", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "input", Element::TERMINAL, name(), modelType(), elements, mapElement);
}

void
UpdatableInteger::updateParameters(std::shared_ptr<ParametersSet>& parametersSet) {
  const std::shared_ptr<Parameter> param = parametersSet->getParameter("input_value");
  if (param->getType() == Parameter::ParameterType::INT) {
    inputValue_ = param->getInt();
    updated_ = true;
    Trace::debug() << "UpdatableInteger: updated value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterBadType, param->getName());
  }
}

void
UpdatableInteger::updateParameter(const std::string& name, double value)  {
  if (!name.compare("input_value")) {
    inputValue_ = value;
    updated_ = true;
    Trace::debug() << "UpdatableInteger: updated value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterNotDefined, name);
  }
}

}  // namespace DYN
