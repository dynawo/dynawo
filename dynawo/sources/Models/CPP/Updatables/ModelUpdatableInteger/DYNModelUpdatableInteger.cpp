//
// Copyright (c) 2025, RTE
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNModelUpdatableInteger.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNNumericalUtils.h"
#include "DYNModelUpdatableInteger.h"
#include "DYNModelUpdatableInteger.hpp"
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
  return (new DYN::ModelUpdatableIntegerFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelUpdatableIntegerFactory::create() const {
  DYN::SubModel* model(new DYN::ModelUpdatableInteger());
  return model;
}

extern "C" void DYN::ModelUpdatableIntegerFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelUpdatableInteger::ModelUpdatableInteger(): ModelUpdatable("ModelUpdatableInteger") {}

void
ModelUpdatableInteger::getSize() {
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of root functions
void
ModelUpdatableInteger::evalG(const double /*t*/) {
  gLocal_[0] = (updated_) ? ROOT_UP : ROOT_DOWN;
  updated_ = false;
}

void
ModelUpdatableInteger::setGequations() {
  gEquationIndex_[0] = std::string("parameter update");
}

// evaluation of modes (alternatives) of F(t,y,y') functions
modeChangeType_t
ModelUpdatableInteger::evalMode(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

double
ModelUpdatableInteger::evalCalculatedVarI(unsigned iCalculatedVar) const {
  switch (iCalculatedVar) {
    case inputValueIdx_:
      return inputValue_;
    default:
      throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
  }
}

void
ModelUpdatableInteger::evalCalculatedVars() {
  calculatedVars_[inputValueIdx_] = inputValue_;
}

void
ModelUpdatableInteger::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createCalculated(UPDATABLE_INPUT_NAME, INTEGER));
}

void
ModelUpdatableInteger::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(UPDATABLE_INPUT_NAME, VAR_TYPE_INT, INTERNAL_PARAMETER));
}

void
ModelUpdatableInteger::setSubModelParameters() {
  if (findParameterDynamic(UPDATABLE_INPUT_NAME).hasValue()) {
    double parameterValue = findParameterDynamic(UPDATABLE_INPUT_NAME).getValue<int>();
    if (!DYN::doubleEquals(parameterValue, inputValue_))
      updated_ = true;
    inputValue_ = parameterValue;
  } else {
    inputValue_ = 0;
  }
}

void
ModelUpdatableInteger::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement(UPDATABLE_INPUT_NAME, Element::TERMINAL, elements, mapElement);
}

void
ModelUpdatableInteger::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  ModelCPP::dumpInStream(streamVariables, inputValue_);
}

void
ModelUpdatableInteger::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  char c;
  streamVariables >> c;
  streamVariables >> inputValue_;
}

void
ModelUpdatableInteger::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << UPDATABLE_INPUT_NAME << Trace::endline;
}
}  // namespace DYN
