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
 * @file  DYNConnectorCalculatedVariable.cpp
 *
 * @brief Connector to use when connecting to a calculated variable
 *
 */

#include "DYNConnectorCalculatedVariable.h"

#include <iostream>
#include <iomanip>

#include "PARParametersSet.h"

#include "DYNSparseMatrix.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNElement.h"
#include "DYNVariableNative.h"
#include "DYNVariableNativeFactory.h"

using std::string;
using std::vector;
using std::map;
using boost::shared_ptr;

using parameters::ParametersSet;

namespace DYN {

ConnectorCalculatedVariable::ConnectorCalculatedVariable() :
indexCalculatedVariable_(0) {
}

void ConnectorCalculatedVariable::getSize() {
  sizeF_ = 1;
  sizeY_ = 1;
  sizeZ_ = 0;
  sizeG_ = 0;
  sizeMode_ = 0;
  model_->getIndexesOfVariablesUsedForCalculatedVarI(indexCalculatedVariable_, varExtIndexes_);
}

void
ConnectorCalculatedVariable::init(const double /*t0*/) {
  // no initialization needed
}

void
ConnectorCalculatedVariable::checkParametersCoherence() const {
  // no check
}

void
ConnectorCalculatedVariable::evalF(const double /*t*/, const propertyF_t type) {
  if (type == DIFFERENTIAL_EQ)
    return;
  // only one equation 0 = calculated var - yLocal
  fLocal_[0] = model_->evalCalculatedVarI(indexCalculatedVariable_) - yLocal_[0];
}

void
ConnectorCalculatedVariable::setFequations() {
  fEquationIndex_[0] = "Calculated variable connector for variable " + name();
}
void
ConnectorCalculatedVariable::evalG(const double /*t*/) {
  // no root function for now
}

void
ConnectorCalculatedVariable::evalJt(const double /*t*/, const double /*cj*/, const int rowOffset, SparseMatrix& jt) {
  // only one equation : 0 = calculatedVariable -y

  constexpr double dMOne(-1.);

  jt.changeCol();
  jt.addTerm(rowOffset, dMOne);  // d(f)/d(yLocal) = -1

  vector<double> jModel(varExtIndexes_.size());
  model_->evalJCalculatedVarI(indexCalculatedVariable_, jModel);

  for (std::size_t i = 0, iEnd = varExtIndexes_.size(); i < iEnd; ++i) {  // d(f)/dyModel = d(calculatedVariable)/d(yModel)
    jt.addTerm(model_->getOffsetY() + varExtIndexes_[i], jModel[i]);
  }
}

void
ConnectorCalculatedVariable::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& jtPrim) {
  // only one equation : 0 = calculatedVariable  -y
  jtPrim.changeCol();
  // We assume that calculated variables do not depend on derivatives.
}

void
ConnectorCalculatedVariable::evalZ(const double /*t*/) {
  // no discrete variable
}


void
ConnectorCalculatedVariable::collectSilentZ(BitMask* /*silentZTable*/) {
  // no discrete variable
}

modeChangeType_t
ConnectorCalculatedVariable::evalMode(const double /*t*/) {
  // no modes, F has always the same formula
  return NO_MODE;
}

void
ConnectorCalculatedVariable::evalCalculatedVars() {
  // no calculated variables
}

void
ConnectorCalculatedVariable::setParams(const boost::shared_ptr<SubModel>& model, const int indexCalculatedVariable) {
  model_ = model;
  indexCalculatedVariable_ = indexCalculatedVariable;
  if (indexCalculatedVariable_ == -1)
    throw DYNError(Error::MODELER, UndefCalculatedVar);
}

void
ConnectorCalculatedVariable::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*JI*/) const {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

void
ConnectorCalculatedVariable::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

double
ConnectorCalculatedVariable::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

void
ConnectorCalculatedVariable::getY0() {
  model_->getY0Sub();

  yLocal_[0] = model_->getCalculatedVar(indexCalculatedVariable_);  // value computed at t=0
  ypLocal_[0] = 0.;
}

void
ConnectorCalculatedVariable::evalStaticYType() {
  yType_[0] = ALGEBRAIC;  // the calculated variable is an algebraic variable
}

void
ConnectorCalculatedVariable::evalStaticFType() {
  fType_[0] = ALGEBRAIC_EQ;  // no differential variable in connector calculated variable
}

void
ConnectorCalculatedVariable::defineVariables(vector<boost::shared_ptr<Variable> >& variables) {
  const typeVar_t type = model_->getVariable(variableName_)->getType();
  assert(type == CONTINUOUS || type == FLOW);
  variables.emplace_back(VariableNativeFactory::createState("connector_" + name(), type));
}

void
ConnectorCalculatedVariable::initializeFromData(const shared_ptr<DataInterface>& /*data*/) {
  // no initialization needed
}

void
ConnectorCalculatedVariable::defineElements(vector<Element>& /*elements*/, map<string, int>& /*mapElement*/) {
  // no element to define
}

void
ConnectorCalculatedVariable::defineParameters(vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ConnectorCalculatedVariable::defineParametersInit(vector<ParameterModeler>& /*parameters*/) {
  // no parameter
}

void
ConnectorCalculatedVariable::defineVariablesInit(vector<boost::shared_ptr<Variable> >& /*variables*/) {
  // no variable
}

void
ConnectorCalculatedVariable::dumpParameters(map<string, string >& /*mapParameters*/) {
  // no parameter
}

void
ConnectorCalculatedVariable::getSubModelParameterValue(const string& /*nameParameter*/, std::string& /*value*/, bool& /*found*/) {
  // no parameter
}

void
ConnectorCalculatedVariable::dumpVariables(map<string, string >& /*mapVariables*/) {
  // no variable
}

void
ConnectorCalculatedVariable::loadParameters(const string& /*parameters*/) {
  // no parameter
}

void
ConnectorCalculatedVariable::loadVariables(const string& /*variables*/) {
  // no variable
}

}  // namespace DYN
