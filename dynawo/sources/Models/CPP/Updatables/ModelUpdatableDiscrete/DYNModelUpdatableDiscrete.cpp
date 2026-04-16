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
 * @file  DYNModelUpdatableDiscrete.cpp
 *
 * @brief Continuous updatable parameter
 *
 */



#include <vector>

#include "PARParametersSet.h"

#include "DYNModelUpdatableDiscrete.h"
#include "DYNModelUpdatableDiscrete.hpp"
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
  return (new DYN::ModelUpdatableDiscreteFactory());
}

extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelUpdatableDiscreteFactory::create() const {
  DYN::SubModel* model(new DYN::ModelUpdatableDiscrete());
  return model;
}

extern "C" void DYN::ModelUpdatableDiscreteFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelUpdatableDiscrete::ModelUpdatableDiscrete(): ModelUpdatable("ModelUpdatableDiscrete") {}

void
ModelUpdatableDiscrete::getSize() {
  sizeZ_ = 1;  // input value
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}


void
ModelUpdatableDiscrete::evalZ(double /* t */) {
  if (gLocal_[0] == ROOT_UP) {
    zLocal_[0] = inputValue_;
  }
}

void
ModelUpdatableDiscrete::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(UPDATABLE_INPUT_VAR_NAME, DISCRETE));
}

void
ModelUpdatableDiscrete::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(UPDATABLE_INPUT_NAME, VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(UPDATABLE_MULTIPLIER_NAME, VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
}

void
ModelUpdatableDiscrete::setSubModelParameters() {
  if (findParameterDynamic(UPDATABLE_INPUT_NAME).hasValue()) {
    double inputValueParameter = findParameterDynamic(UPDATABLE_INPUT_NAME).getValue<double>();
    if (!doubleEquals(inputValueParameter, inputValue_)) {
      inputValue_ = inputValueParameter;
      updated_ = true;
    }
  }
  if (findParameterDynamic(UPDATABLE_MULTIPLIER_NAME).hasValue()) {
    double inputMultiplierParameter = findParameterDynamic(UPDATABLE_MULTIPLIER_NAME).getValue<double>();
    if (!doubleEquals(inputMultiplierParameter, 1.)) {
      if (updated_) {
        Trace::warn() << DYNLog(UpdatableIgnoredMultiplier, name()) << Trace::endline;
      } else {
        inputValue_ *= inputMultiplierParameter;
        updated_ = true;
      }
      setParameterValue(UPDATABLE_MULTIPLIER_NAME, FINAL, 1., false);
      setParameterValue(UPDATABLE_INPUT_NAME, FINAL, inputValue_, false);
    }
  }
}

void
ModelUpdatableDiscrete::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement(UPDATABLE_INPUT_VAR_NAME, Element::TERMINAL, elements, mapElement);
}


void
ModelUpdatableDiscrete::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  -> " << UPDATABLE_INPUT_NAME << Trace::endline;
}
}  // namespace DYN
