//
// Copyright (c) 2025, RTE
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
 * @file  DYNModelUpdatableContinuous.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNModelUpdatableContinuous.h"
#include "DYNModelUpdatableContinuous.hpp"
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
  return (new DYN::ModelUpdatableContinuousFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelUpdatableContinuousFactory::create() const {
  DYN::SubModel* model(new DYN::ModelUpdatableContinuous());
  return model;
}

extern "C" void DYN::ModelUpdatableContinuousFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelUpdatableContinuous::ModelUpdatableContinuous(): ModelUpdatable("ModelUpdatableContinuous") {}

void
ModelUpdatableContinuous::getSize() {
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of root functions
void
ModelUpdatableContinuous::evalG(const double /*t*/) {
  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

void
ModelUpdatableContinuous::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

// evaluation of modes (alternatives) of F(t,y,y') functions
modeChangeType_t
ModelUpdatableContinuous::evalMode(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

double
ModelUpdatableContinuous::evalCalculatedVarI(unsigned iCalculatedVar) const {
  switch (iCalculatedVar) {
    case inputValueIdx_:
      return inputValue_;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
  }
}

void
ModelUpdatableContinuous::evalCalculatedVars() {
  calculatedVars_[inputValueIdx_] = inputValue_;
}

void
ModelUpdatableContinuous::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated(UPDATABLE_INPUT_NAME, CONTINUOUS));
}

void
ModelUpdatableContinuous::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(UPDATABLE_INPUT_NAME, VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
}

void
ModelUpdatableContinuous::setSubModelParameters() {
  if (findParameterDynamic(UPDATABLE_INPUT_NAME).hasValue()) {
    double parameterValue = findParameterDynamic(UPDATABLE_INPUT_NAME).getValue<double>();
    if (!DYN::doubleEquals(parameterValue, inputValue_))
      updated_ = true;
    inputValue_ = parameterValue;
  }
}

void
ModelUpdatableContinuous::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement(UPDATABLE_INPUT_NAME, Element::TERMINAL, elements, mapElement);
}

void
ModelUpdatableContinuous::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  ModelCPP::dumpInStream(streamVariables, inputValue_);
}

void
ModelUpdatableContinuous::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> inputValue_;
}

void
ModelUpdatableContinuous::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << UPDATABLE_INPUT_NAME << Trace::endline;
}
}  // namespace DYN
