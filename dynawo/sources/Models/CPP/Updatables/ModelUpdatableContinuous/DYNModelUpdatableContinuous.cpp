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

#include "PARParametersSet.h"

#include "DYNModelUpdatableContinuous.h"
#include "DYNModelUpdatableContinuous.hpp"
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
  sizeY_ = 1;  // input value
  sizeF_ = 1;  // input value assignation
  sizeG_ = 1;  // parameter updated
  sizeMode_ = 1;
}


void
ModelUpdatableContinuous::evalStaticYType() {
  yType_[0] = ALGEBRAIC;
}

void
ModelUpdatableContinuous::evalStaticFType() {
  fType_[0] = ALGEBRAIC_EQ;  // no differential variable in connector calculated variable
}

void
ModelUpdatableContinuous::evalF(const double /*t*/, const propertyF_t type) {
  if (type == DIFFERENTIAL_EQ)
    return;

  // only one equation: 0 = inputValue - yLocal
  fLocal_[0] = inputValue_ - yLocal_[0];
}

void
ModelUpdatableContinuous::setFequations() {
  fEquationIndex_[0] = "input variable = inputValue";
}

void
ModelUpdatableContinuous::evalJt(const double /*t*/, const double /*cj*/, const int rowOffset, SparseMatrix& jt) {
  // only one equation: 0 = inputValue - y
  constexpr double dMOne(-1.);
  jt.changeCol();
  jt.addTerm(rowOffset, dMOne);  // d(f)/d(yLocal) = -1
}

void
ModelUpdatableContinuous::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& jtPrim) {
  // only one equation: 0 = inputValue - y
  jtPrim.changeCol();
}

void
ModelUpdatableContinuous::defineVariables(vector<shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState(UPDATABLE_INPUT_VAR_NAME, CONTINUOUS));
}

void
ModelUpdatableContinuous::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler(UPDATABLE_INPUT_NAME, VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler(UPDATABLE_MULTIPLIER_NAME, VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
}

void
ModelUpdatableContinuous::setSubModelParameters() {
  if (findParameterDynamic(UPDATABLE_INPUT_NAME).hasValue()) {
    double parameterValue = findParameterDynamic(UPDATABLE_INPUT_NAME).getValue<double>();
    if (!doubleEquals(parameterValue, inputValue_)) {
      inputValue_ = parameterValue;
      updated_ = true;
    }
  }
  if (findParameterDynamic(UPDATABLE_MULTIPLIER_NAME).hasValue()) {
    double parameterValue = findParameterDynamic(UPDATABLE_MULTIPLIER_NAME).getValue<double>();
    if (!doubleEquals(parameterValue, 1.)) {
      if (updated_) {
        Trace::warn() << DYNLog(UpdatableIgnoredMultiplier, name()) << Trace::endline;
      } else {
        inputValue_ *= parameterValue;
        updated_ = true;
      }
      setParameterValue(UPDATABLE_INPUT_NAME, FINAL, inputValue_, false);
      setParameterValue(UPDATABLE_MULTIPLIER_NAME, FINAL, 1., false);
    }
  }
}

void
ModelUpdatableContinuous::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement(UPDATABLE_INPUT_VAR_NAME, Element::TERMINAL, elements, mapElement);
}


void
ModelUpdatableContinuous::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  -> " << UPDATABLE_INPUT_NAME << Trace::endline;
}
}  // namespace DYN
