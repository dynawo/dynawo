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
 * @file  DYNUpdatableContinuous.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNUpdatableContinuous.h"
#include "DYNUpdatableContinuous.hpp"
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
  return (new DYN::UpdatableContinuousFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::UpdatableContinuousFactory::create() const {
  DYN::SubModel* model(new DYN::UpdatableContinuous());
  return model;
}

extern "C" void DYN::UpdatableContinuousFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

UpdatableContinuous::UpdatableContinuous() :
ModelCPP("UpdatableContinuous"),
inputValue_(0.),
updated_(false) {
  needsInitFromConnectedModel_ = true;
}

void
UpdatableContinuous::init(const double /*t0*/) {
  // not needed
}

void
UpdatableContinuous::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
UpdatableContinuous::initializeStaticData() {
  // not needed
}

void
UpdatableContinuous::getSize() {
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of F(t,y,y') function
void
UpdatableContinuous::evalF(double /*t*/, propertyF_t type) {
}


// evaluation of root functions
void
UpdatableContinuous::evalG(const double /*t*/) {
  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

// evaluation of root functions
void
UpdatableContinuous::evalZ(const double /*t*/) {
  // not needed
}

void
UpdatableContinuous::setFequations() {
}

void
UpdatableContinuous::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableContinuous::evalJt(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& jt) {
}

// evaluation of the transpose Jacobian Jt - sparse matrix
void
UpdatableContinuous::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& jt) {
}

void
UpdatableContinuous::collectSilentZ(BitMask* /*silentZTable*/) {
  // not needed
}

// evaluation of modes (alternatives) of F(t,y,y') functions
modeChangeType_t
UpdatableContinuous::evalMode(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

void
UpdatableContinuous::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // not needed
}

void
UpdatableContinuous::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // not needed
}

double
UpdatableContinuous::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return inputValue_;
}

void
UpdatableContinuous::evalCalculatedVars() {
  calculatedVars_[inputValueIdx_] = inputValue_;
}

void
UpdatableContinuous::getY0() {
}

void
UpdatableContinuous::evalStaticYType() {
}

void
UpdatableContinuous::evalStaticFType() {
}

void
UpdatableContinuous::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated("input_value", CONTINUOUS));
}

void
UpdatableContinuous::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("input_value", VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
}

void
UpdatableContinuous::setSubModelParameters() {
  if (findParameterDynamic("input_value").hasValue()) {
    double parameterValue = findParameterDynamic("input_value").getValue<double>();
    if (!DYN::doubleEquals(parameterValue, inputValue_))
      updated_ = true;
    inputValue_ = parameterValue;
  }
}


void
UpdatableContinuous::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement("input", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "input", Element::TERMINAL, name(), modelType(), elements, mapElement);
}

}  // namespace DYN
