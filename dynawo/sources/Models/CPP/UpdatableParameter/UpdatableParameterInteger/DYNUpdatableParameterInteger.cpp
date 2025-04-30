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
 * @file  DYNUpdatableParameterInteger.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNUpdatableParameterInteger.h"
#include "DYNUpdatableParameterInteger.hpp"
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
  return (new DYN::UpdatableParameterIntegerFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::UpdatableParameterIntegerFactory::create() const {
  DYN::SubModel* model(new DYN::UpdatableParameterInteger());
  return model;
}

extern "C" void DYN::UpdatableParameterIntegerFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

UpdatableParameterInteger::UpdatableParameterInteger() :
ModelCPP("UpdatableParameterInteger"),
inputValue_(0.),
updated_(false) {
  isUpdatableDuringSimulation_ = true;
}

void
UpdatableParameterInteger::init(const double /*t0*/) {
  // not needed
}

void
UpdatableParameterInteger::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
UpdatableParameterInteger::initializeStaticData() {
  // not needed
}

void
UpdatableParameterInteger::getSize() {
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of F(t,y,y') function
void
UpdatableParameterInteger::evalF(double /*t*/, propertyF_t type) {
}


// evaluation of root functions
void
UpdatableParameterInteger::evalG(const double /*t*/) {
  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

// evaluation of root functions
void
UpdatableParameterInteger::evalZ(const double /*t*/) {
  // not needed
}

void
UpdatableParameterInteger::setFequations() {
}

void
UpdatableParameterInteger::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableParameterInteger::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int /*rowOffset*/) {
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableParameterInteger::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int /*rowOffset*/) {
}

void
UpdatableParameterInteger::collectSilentZ(BitMask* /*silentZTable*/) {
  // not needed
}

// evaluation of modes (alternatives) of F(t,y,y') functions
modeChangeType_t
UpdatableParameterInteger::evalMode(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

void
UpdatableParameterInteger::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // not needed
}

void
UpdatableParameterInteger::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // not needed
}

double
UpdatableParameterInteger::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return inputValue_;
}

void
UpdatableParameterInteger::evalCalculatedVars() {
  calculatedVars_[inputValueIdx_] = inputValue_;
}

void
UpdatableParameterInteger::getY0() {
}

void
UpdatableParameterInteger::evalStaticYType() {
}

void
UpdatableParameterInteger::evalStaticFType() {
}

void
UpdatableParameterInteger::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("input_value", INTEGER));
}

void
UpdatableParameterInteger::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("external_input", VAR_TYPE_INT, INTERNAL_PARAMETER));
}

void
UpdatableParameterInteger::setSubModelParameters() {
  // not needed
}

void
UpdatableParameterInteger::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement("input", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "input", Element::TERMINAL, name(), modelType(), elements, mapElement);
}

void
UpdatableParameterInteger::updateParameters(std::shared_ptr<ParametersSet>& parametersSet) {
  const std::shared_ptr<Parameter> param = parametersSet->getParameter("external_input");
  if (param->getType() == Parameter::ParameterType::INT) {
    inputValue_ = param->getInt();
    updated_ = true;
    Trace::debug() << "UpdatableParameterInteger: updated value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterBadType, param->getName());
  }
}

void
UpdatableParameterInteger::updateParameter(const std::string& name, double value)  {
  if (!name.compare("external_input")) {
    inputValue_ = value;
    updated_ = true;
    Trace::debug() << "UpdatableParameterInteger: updated value : " << inputValue_ << Trace::endline;
  } else {
    throw DYNError(Error::MODELER, ParameterNotDefined, name);
  }
}

}  // namespace DYN
