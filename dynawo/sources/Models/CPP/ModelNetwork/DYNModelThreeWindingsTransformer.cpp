//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file  DYNModelThreeWindingsTransformer.cpp
 *
 * @brief
 *
 */

#include "DYNModelThreeWindingsTransformer.h"
#include "DYNModelNetwork.h"
#include "DYNModelBus.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNThreeWTransformerInterface.h"
#include "DYNBusInterface.h"


using std::vector;
using boost::shared_ptr;
using std::string;
using std::map;

namespace DYN {

ModelThreeWindingsTransformer::ModelThreeWindingsTransformer(const std::shared_ptr<ThreeWTransformerInterface>& tfo) :
NetworkComponent(tfo->getID()) {
}

void
ModelThreeWindingsTransformer::initSize() {
  if (network_->isInitModel()) {
    sizeF_ = 0;
    sizeY_ = 0;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = 0;
  } else {
    sizeF_ = 0;
    sizeY_ = 0;
    sizeZ_ = 0;
    sizeG_ = 0;
    sizeMode_ = 0;
    sizeCalculatedVar_ = nbCalculatedVariables_;
  }
}

void
ModelThreeWindingsTransformer::defineVariables(vector<shared_ptr<Variable> >& /*variables*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::instantiateVariables(vector<shared_ptr<Variable> >& /*variables*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::defineParameters(vector<ParameterModeler>& /*parameters*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::evalCalculatedVars() {
  // not needed
}

void
ModelThreeWindingsTransformer::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& /*numVars*/) const {
  throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
}

void
ModelThreeWindingsTransformer::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& /*res*/) const {
  throw DYNError(Error::MODELER, UndefJCalculatedVarI, numCalculatedVar);
}

double
ModelThreeWindingsTransformer::evalCalculatedVarI(unsigned numCalculatedVar) const {
  throw DYNError(Error::MODELER, UndefCalculatedVarI, numCalculatedVar);
}

NetworkComponent::StateChange_t
ModelThreeWindingsTransformer::evalState(const double /*time*/) {
    return NetworkComponent::NO_CHANGE;
}

void
ModelThreeWindingsTransformer::defineNonGenericParameters(vector<ParameterModeler>& /*parameters*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::evalYMat() {
  // not needed
}

void
ModelThreeWindingsTransformer::evalF(propertyF_t /*type*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::evalJt(const double /*cj*/, const int /*rowOffset*/, SparseMatrix& /*jt*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::evalJtPrim(const int /*rowOffset*/, SparseMatrix& /*jtPrim*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::defineElements(vector<Element>& /*elements*/, map<string, int>& /*mapElement*/) {
  // not needed
}
void
ModelThreeWindingsTransformer::collectSilentZ(BitMask* /*silentZTable*/) {
  // not needed
}

NetworkComponent::StateChange_t
ModelThreeWindingsTransformer::evalZ(const double /*t*/, bool /*deactivateRootFunctions*/) {
  return NetworkComponent::NO_CHANGE;
}

void
ModelThreeWindingsTransformer::evalG(const double /*t*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::init(int& /*yNum*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& /*params*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::setFequations(map<int, string>& /*fEquationIndex*/) {
  // not needed
}

void
ModelThreeWindingsTransformer::setGequations(map<int, string>& /*gEquationIndex*/) {
  // not needed
}

}  // namespace DYN
