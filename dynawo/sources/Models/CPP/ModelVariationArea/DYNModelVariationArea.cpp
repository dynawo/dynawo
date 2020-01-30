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
 * @file  DYNModelVariationArea.cpp
 *
 * @brief
 *
 */
#include <iostream>
#include <sstream>
#include <iomanip>
#include <vector>
#include <algorithm>
#include <cmath>
#include <cassert>

#include "PARParametersSet.h"

#include "DYNModelVariationArea.h"
#include "DYNModelVariationArea.hpp"
#include "DYNSparseMatrix.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNCommon.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"

using std::min;
using std::vector;
using std::string;

using std::stringstream;
using std::map;

using boost::shared_ptr;

using parameters::ParametersSet;

/**
 * @brief ModelVariationAreaFactory getter
 *
 * @return A pointer to a new instance of ModelVariationaAreaFactory
 */
extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelVariationAreaFactory());
}

/**
 * @brief ModelVariationAreaFactory destroy method
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

/**
 * @brief ModelVariationArea getter
 *
 * @return A pointer to a new instance of ModelVariationArea
 */
extern "C" DYN::SubModel* DYN::ModelVariationAreaFactory::create() const {
  DYN::SubModel * model(new DYN::ModelVariationArea());
  return model;
}

/**
 * @brief ModelVariationArea destroy method
 */
extern "C" void DYN::ModelVariationAreaFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelVariationArea::ModelVariationArea() :
Impl("VariationArea"),
nbLoads_(0) {
}

void
ModelVariationArea::init(const double& /*t0*/) {
  stateVariationArea_ = 0;
}

void
ModelVariationArea::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
ModelVariationArea::initializeStaticData() {
  // not needed
}

void
ModelVariationArea::getSize() {
  sizeF_ = nbLoads_ * 2;  // equation for deltaP and deltaQ by load
  sizeY_ = nbLoads_ * 2;   // deltaP et deltaQ  by load
  sizeZ_ = 1;  // automaton running
  sizeG_ = 2;  // activation/deactivation of load increase
  sizeMode_ = 0;

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

// evaluation of F(t,y,y') function

void
ModelVariationArea::evalF(const double & t) {
  if (static_cast<int>(stateVariationArea_) == 0) {  // load increase not started
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2];
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1];
    }
  } else if (static_cast<int>(stateVariationArea_) == 1) {  // load increase in progress
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2] - deltaP_ / (stopTime_ - startTime_)*(t - startTime_);
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1] - deltaQ_ / (stopTime_ - startTime_)*(t - startTime_);
    }
  } else if (static_cast<int>(stateVariationArea_) == 2) {  // load increase completed
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2] - deltaP_;
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1] - deltaQ_;
    }
  }
}


// evaluation of root functions

void
ModelVariationArea::evalG(const double & t) {
  gLocal_[0] = (t - startTime_) >= 0 ? ROOT_UP : ROOT_DOWN;
  gLocal_[1] = (t - stopTime_) >= 0 ? ROOT_UP : ROOT_DOWN;
}

void
ModelVariationArea::setFequations() {
  // not needed
}

void
ModelVariationArea::setGequations() {
  gEquationIndex_[0] = "t >= startTime_";
  gEquationIndex_[1] = "t >= stopTime_";

  assert(gEquationIndex_.size() == (unsigned int) sizeG() && "Model VariationArea: gEquationIndex.size() != gLocal_.size()");
}

// evaluation of the transpose Jacobian Jt - sparse matrix

void
ModelVariationArea::evalJt(const double& /*t*/, const double& /*cj*/, SparseMatrix& jt, const int& rowOffset) {
  static double dPOne = 1;
  // whatever the state of the automaton, same Jacobian
  for (int i = 0; i < nbLoads_; ++i) {  // 2 equations by loads
    jt.changeCol();
    jt.addTerm(i * 2 + rowOffset, dPOne);
    jt.changeCol();
    jt.addTerm(i * 2 + 1 + rowOffset, dPOne);
  }
}

// evaluation of the transpose Jacobian Jt - sparse matrix

void
ModelVariationArea::evalJtPrim(const double& /*t*/, const double& /*cj*/, SparseMatrix& jt, const int& /*rowOffset*/) {
  // no differential equations
  for (int i = 0; i < nbLoads_; ++i) {  // 2 equations by loads
    jt.changeCol();
    jt.changeCol();
  }
}

// evaluation of discrete variables

void
ModelVariationArea::evalZ(const double& /*t*/) {
  if (gLocal_[0] == ROOT_UP)  // load increase in progress
    zLocal_[0] = 1;

  if (gLocal_[1] == ROOT_UP)  // load increase ended
    zLocal_[0] = 2;

  stateVariationArea_ = zLocal_[0];
}

// evaluation of modes (alternatives) of F(t,y,y') functions

modeChangeType_t
ModelVariationArea::evalMode(const double& /*t*/) {
  return NO_MODE;
}

void
ModelVariationArea::evalJCalculatedVarI(int /*iCalculatedVar*/, double* /*y*/, double* /*yp*/, vector<double>& /*res*/) {
  // output depends only on discrete variable
}

vector<int>
ModelVariationArea::getDefJCalculatedVarI(int /*iCalculatedVar*/) {
  vector<int> defJCalculatedVarI;
  return defJCalculatedVarI;
}

double
ModelVariationArea::evalCalculatedVarI(int /*iCalculatedVar*/, double* /*y*/, double* /*yp*/) {
  double output = 0;
  return (output);
}

void
ModelVariationArea::evalCalculatedVars() {
  // not needed
}

void
ModelVariationArea::getY0() {
  std::fill(yLocal_, yLocal_ + nbLoads_ * 2, 0);
  std::fill(ypLocal_, ypLocal_ + nbLoads_ * 2, 0);
  zLocal_[0] = 0;
}

void
ModelVariationArea::evalYType() {
  std::fill(yType_, yType_ + sizeY(), ALGEBRIC);  // all variables are algebraic variable
}

void
ModelVariationArea::evalFType() {
  std::fill(fType_, fType_ + 2 * nbLoads_, ALGEBRIC_EQ);  // no differential variable
}

void
ModelVariationArea::defineVariables(vector<shared_ptr<Variable> >& variables) {
  for (int i = 0; i < nbLoads_; ++i) {
    std::stringstream name;
    name << "DeltaPc_load_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));

    std::stringstream name1;
    name1 << "DeltaQc_load_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name1.str(), CONTINUOUS));
  }
}

void
ModelVariationArea::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbLoads", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("startTime", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("stopTime", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("deltaP", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("deltaQ", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelVariationArea::setSubModelParameters() {
  nbLoads_ = findParameterDynamic("nbLoads").getValue<int>();
  startTime_ = findParameterDynamic("startTime").getValue<double>();
  stopTime_ = findParameterDynamic("stopTime").getValue<double>();
  deltaP_ = findParameterDynamic("deltaP").getValue<double>();
  deltaQ_ = findParameterDynamic("deltaQ").getValue<double>();
}

void
ModelVariationArea::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  for (int i = 0; i < nbLoads_; ++i) {
    std::stringstream name;
    name << "DeltaPc_load_" << i;
    addElement(name.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name.str(), Element::TERMINAL, elements, mapElement);

    std::stringstream name1;
    name1 << "DeltaQc_load_" << i;
    addElement(name1.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name1.str(), Element::TERMINAL, elements, mapElement);
  }
}

}  // namespace DYN
