//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file  DYNConnectorCalculatedDiscreteVariable.cpp
 *
 * @brief This class builds a connector submodel related to a discrete calculated variable
 *
 */

#include "DYNConnectorCalculatedDiscreteVariable.h"

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


namespace DYN {

ConnectorCalculatedDiscreteVariable::ConnectorCalculatedDiscreteVariable() :
indexCalculatedVariable_(0),
prevZValue_(0) {
}

void ConnectorCalculatedDiscreteVariable::getSize() {
  sizeF_ = 0;
  sizeY_ = 0;
  sizeZ_ = 1;
  sizeG_ = 1;
  sizeMode_ = 0;
}

void
ConnectorCalculatedDiscreteVariable::init(const double /*t0*/) {
  // no initialization needed
}

void
ConnectorCalculatedDiscreteVariable::evalF(double /*t*/, propertyF_t /*type*/) {
  /* not needed*/
}

void
ConnectorCalculatedDiscreteVariable::setGequations() {
  gEquationIndex_[0] = std::string("pre(DiscreteCalcVar) !=  model_->evalCalculatedVarI(indexCalculatedVariable_)");
}
void
ConnectorCalculatedDiscreteVariable::evalG(const double /*t*/) {
  gLocal_[0] = doubleNotEquals(prevZValue_, model_->evalCalculatedVarI(indexCalculatedVariable_)) ? ROOT_UP : ROOT_DOWN;
}

void
ConnectorCalculatedDiscreteVariable::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& /*Jt*/, const int /*rowOffset*/) {
  /* not needed*/
}

void
ConnectorCalculatedDiscreteVariable::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& /*Jt*/, const int /*rowOffset*/) {
  /* not needed*/
}

void
ConnectorCalculatedDiscreteVariable::evalZ(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    zLocal_[0] = model_->evalCalculatedVarI(indexCalculatedVariable_);
    prevZValue_ = zLocal_[0];
  }
}


void
ConnectorCalculatedDiscreteVariable::collectSilentZ(BitMask* /*silentZTable*/) {
  /* not needed*/
}

modeChangeType_t
ConnectorCalculatedDiscreteVariable::evalMode(const double /*t*/) {
  return NO_MODE;
}

void
ConnectorCalculatedDiscreteVariable::setParams(const shared_ptr<SubModel>& model, const int indexCalculatedVariable) {
  model_ = model;
  indexCalculatedVariable_ = indexCalculatedVariable;
  if (indexCalculatedVariable_ == -1)
    throw DYNError(Error::MODELER, UndefCalculatedVar);
}

void
ConnectorCalculatedDiscreteVariable::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*JI*/) const {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

void
ConnectorCalculatedDiscreteVariable::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

double
ConnectorCalculatedDiscreteVariable::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

void
ConnectorCalculatedDiscreteVariable::getY0() {
  model_->getY0Sub();
  zLocal_[0] = model_->getCalculatedVar(indexCalculatedVariable_);
  prevZValue_ = zLocal_[0];
}

void
ConnectorCalculatedDiscreteVariable::defineVariables(vector<boost::shared_ptr<Variable> >& variables) {
  typeVar_t type = model_->getVariable(variableName_)->getType();
  assert(type == DISCRETE || type == INTEGER);
  variables.push_back(VariableNativeFactory::createState("connector_" + name(), type));
}

void
ConnectorCalculatedDiscreteVariable::initializeFromData(const shared_ptr<DataInterface>& /*data*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::defineElements(vector<Element>& /*elements*/, map<string, int>& /*mapElement*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::defineParameters(vector<ParameterModeler>& /*parameters*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::defineParametersInit(vector<ParameterModeler>& /*parameters*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::defineVariablesInit(vector<boost::shared_ptr<Variable> >& /*variables*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::dumpParameters(map<string, string >& /*mapParameters*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::getSubModelParameterValue(const string& /*nameParameter*/, std::string& /*value*/, bool& /*found*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::dumpVariables(map<string, string >& /*mapVariables*/) {
  /* not needed */
}

void
ConnectorCalculatedDiscreteVariable::loadParameters(const string& /*parameters*/) {
  // no parameter
}

void
ConnectorCalculatedDiscreteVariable::loadVariables(const string& /*variables*/) {
  /* not needed */
}

}  // namespace DYN
