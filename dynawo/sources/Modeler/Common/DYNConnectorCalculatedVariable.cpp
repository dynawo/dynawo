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
using std::stringstream;
using std::vector;
using std::map;
using boost::shared_ptr;

using parameters::ParametersSet;

namespace DYN {
const int ConnectorCalculatedVariable::colCalculatedVariable_ = 0;
const int ConnectorCalculatedVariable::col1stYModelExt_ = 1;

ConnectorCalculatedVariable::ConnectorCalculatedVariable() :
indexCalculatedVariable_(0),
nbVarExt_(0) {
}

void ConnectorCalculatedVariable::getSize() {
  sizeF_ = 1;
  sizeY_ = nbVarExt_ + 1;  // the value and the y variable of the model used to calculate the value
  sizeZ_ = 0;
  sizeG_ = 0;
  sizeMode_ = 0;
  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ConnectorCalculatedVariable::init(const double& /*t0*/) {
  // no initialization needed
}

void
ConnectorCalculatedVariable::checkDataCoherence(const double& /*t*/) {
  // no check
}

void
ConnectorCalculatedVariable::evalF(const double& /*t*/) {
  // computing the model calculated variables
  double output = model_->evalCalculatedVarI(indexCalculatedVariable_, &yLocal_[1], &ypLocal_[1]);  //  first variable in y is the value of the output

  // only one equation 0 = output - yLocal
  fLocal_[0] = output - yLocal_[0];
}

void
ConnectorCalculatedVariable::evalG(const double& /*t*/) {
  // no root function for now
}

void
ConnectorCalculatedVariable::evalJt(const double& /*t*/, const double& /*cj*/, SparseMatrix& Jt, const int& rowOffset) {
  // only one equation : 0 = calculatedVariable -y

  const double dMOne(-1.);

  Jt.changeCol();
  Jt.addTerm(colCalculatedVariable_ + rowOffset, dMOne);  // d(f)/d(yLocal) = -1;


  vector<double> JModel(nbVarExt_);
  model_->evalJCalculatedVarI(indexCalculatedVariable_, &yLocal_[1], &ypLocal_[1], JModel);

  for (int i = 0; i < nbVarExt_; ++i)  // d(f)/dyModel = d(calculatedVariable)/d(yModel)
    Jt.addTerm(i + col1stYModelExt_ + rowOffset, JModel[i]);
}

void
ConnectorCalculatedVariable::evalJtPrim(const double& /*t*/, const double& /*cj*/, SparseMatrix& Jt, const int& /*rowOffset*/) {
  // only one equation : 0 = calculatedVariable  -y
  Jt.changeCol();
  // @todo : to be improve if one calculated variable depends on a derivative
}

void
ConnectorCalculatedVariable::evalZ(const double& /*t*/) {
  // no discrete variable
}

modeChangeType_t
ConnectorCalculatedVariable::evalMode(const double& /*t*/) {
  // no modes, F has always the same formula
  return NO_MODE;
}

void
ConnectorCalculatedVariable::evalCalculatedVars() {
  calculatedVars_[0] = yLocal_[0];
}

void
ConnectorCalculatedVariable::setParams(const shared_ptr<SubModel>& model, const int& indexCalculatedVariable) {
  model_ = model;
  indexCalculatedVariable_ = indexCalculatedVariable;
  if (indexCalculatedVariable_ == -1)
    throw DYNError(Error::MODELER, UndefCalculatedVar);
  nbVarExt_ = model_->getDefJCalculatedVarI(indexCalculatedVariable_).size();
}

void
ConnectorCalculatedVariable::evalJCalculatedVarI(int /*iCalculatedVar*/, double* /*y*/, double* /*yp*/, vector<double>& /*JI*/) {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

vector<int>
ConnectorCalculatedVariable::getDefJCalculatedVarI(int /*iCalculatedVar*/) {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

double
ConnectorCalculatedVariable::evalCalculatedVarI(int /*iCalculatedVar*/, double* /*y*/, double* /*yp*/) {
  throw DYNError(Error::MODELER, FuncNotYetCoded);
}

void
ConnectorCalculatedVariable::getY0() {
  vector<double> y;
  vector<double> yp;
  vector<double> z;
  y.resize(model_->sizeY());
  z.resize(model_->sizeZ());
  yp.resize(model_->sizeY());
  model_->getY0Values(y, yp, z);

  yLocal_[0] = model_->getCalculatedVar(indexCalculatedVariable_);  // valeur calculée à l'instant zero

  vector<int> numVars = model_->getDefJCalculatedVarI(indexCalculatedVariable_);

  for (unsigned int i = 0; i < numVars.size(); ++i)
    yLocal_[1+i] = y[numVars[i]];

  ypLocal_[0] = 0.;
  for (unsigned int i = 0; i < numVars.size(); ++i)
    ypLocal_[1+i] = yp[numVars[i]];
}

void
ConnectorCalculatedVariable::evalYType() {
  yType_[0] = ALGEBRIC;  // the calculated variable is an algebraic variable

  for (int i = 0; i < nbVarExt_; ++i)
    yType_[1 + i] = EXTERNAL;
}

void
ConnectorCalculatedVariable::evalFType() {
  fType_[0] = ALGEBRIC_EQ;  // no differential variable in connector calculated variable
}

void
ConnectorCalculatedVariable::defineVariables(vector<boost::shared_ptr<Variable> >& variables) {
  variables.push_back(VariableNativeFactory::createState("connector_" + name(), CONTINUOUS));

  for (int i = 0; i < nbVarExt_; ++i) {
    std::stringstream var;
    var << "connector_varExt_" << name() << "_" << i;
    variables.push_back(VariableNativeFactory::createState(var.str(), CONTINUOUS));
  }
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
ConnectorCalculatedVariable::getSubModelParameterValue(const string& /*nameParameter*/, double& /*value*/, bool& /*found*/) {
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

void
ConnectorCalculatedVariable::printInitValues(const string& /*directory*/) {
  // no initialization needed
}


}  // namespace DYN
