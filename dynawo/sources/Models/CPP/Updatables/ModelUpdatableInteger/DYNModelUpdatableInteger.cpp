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
 * @file  DYNModelUpdatableInteger.cpp
 *
 * @brief Continuous updatable parameter
 *
 */

#include <vector>

#include "PARParametersSet.h"

#include "DYNModelUpdatableInteger.h"
#include "DYNModelUpdatableInteger.hpp"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNModelConstants.h"

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
  sizeZ_ = 1;  // input value
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ModelUpdatableInteger::evalZ(double /* t */) {
  if (gLocal_[0] == ROOT_UP) {
    zLocal_[0] = inputValue_;
  }
}

void
ModelUpdatableInteger::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(UPDATABLE_INPUT_VAR_NAME, INTEGER));
}

void
ModelUpdatableInteger::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(UPDATABLE_INPUT_NAME, VAR_TYPE_INT, INTERNAL_PARAMETER));
}

void
ModelUpdatableInteger::setSubModelParameters() {
  if (findParameterDynamic(UPDATABLE_INPUT_NAME).hasValue()) {
    const double parameterValue = findParameterDynamic(UPDATABLE_INPUT_NAME).getValue<int>();
    if (!doubleEquals(parameterValue, inputValue_)) {
      inputValue_ = parameterValue;
      updated_ = true;
    }
  }
}

void
ModelUpdatableInteger::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement(UPDATABLE_INPUT_VAR_NAME, Element::TERMINAL, elements, mapElement);
}

void
ModelUpdatableInteger::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << UPDATABLE_INPUT_NAME << Trace::endline;
}
}  // namespace DYN
