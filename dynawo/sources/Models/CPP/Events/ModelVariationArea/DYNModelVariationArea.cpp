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
ModelCPP("VariationArea"),
deltaP_(0.),
deltaQ_(0.),
startTime_(0.),
stopTime_(0.),
nbLoads_(0),
timeModeOnGoingRaised_(-1),
timeModeFinishedRaised_(-1),
stateVariationArea_(NOT_STARTED) {
}

void
ModelVariationArea::init(const double /*t0*/) {
  // not needed
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
  sizeY_ = nbLoads_ * 2;   // deltaP and deltaQ  by load
  sizeZ_ = 1;  // automaton running
  sizeG_ = 2;  // activation/deactivation of load increase
  sizeMode_ = 2;  // activation/deactivation of load increase

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void ModelVariationArea::evalStaticYTypeLinearize() {
  std::copy(yType_, yType_ + sizeY(), yTypeLinearize_);
}

void ModelVariationArea::evalDynamicYTypeLinearize() {
}

void ModelVariationArea::evalStaticFTypeLinearize() {
  std::copy(fType_, fType_ + sizeY(), fTypeLinearize_);
}

void ModelVariationArea::evalDynamicFTypeLinearize() {
}

void ModelVariationArea::getSizeLinearize() {
  sizeFLinearize_ = sizeF_;
  sizeYLinearize_ = sizeY_;
  sizeZLinearize_ = sizeZ_;
  sizeGLinearize_ = sizeG_;
  sizeModeLinearize_ = sizeMode_;

  calculatedVarsLinearize_.assign(nbCalculatedVars_, 0);
}

void ModelVariationArea::defineVariablesLinearize(std::vector<boost::shared_ptr<Variable> >& variables) {
  defineVariables(variables);
}

  void ModelVariationArea::defineParametersLinearize(std::vector<ParameterModeler>& /*parameters*/) {
}

// evaluation of F(t,y,y') function

void
ModelVariationArea::evalF(const double t, const propertyF_t type) {
  if (type == DIFFERENTIAL_EQ)
    return;
  if (stateVariationArea_ == NOT_STARTED) {  // load increase not started
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2];
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1];
    }
  } else if (stateVariationArea_ == ON_GOING) {  // load increase in progress
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2] - deltaP_[i] / (stopTime_ - startTime_) * (t - startTime_);
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1] - deltaQ_[i] / (stopTime_ - startTime_) * (t - startTime_);
    }
  } else if (stateVariationArea_ == FINISHED) {  // load increase completed
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2] - deltaP_[i];
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1] - deltaQ_[i];
    }
  }
}


// evaluation of root functions

void
ModelVariationArea::evalG(const double t) {
  gLocal_[0] = ((t - startTime_) >= 0 && (t - stopTime_) < 0) ? ROOT_UP : ROOT_DOWN;
  gLocal_[1] = (t - stopTime_) >= 0 ? ROOT_UP : ROOT_DOWN;
}

void
ModelVariationArea::setFequations() {
  stringstream ss;
  for (int i = 0; i < nbLoads_; ++i) {
    ss.str("");
    ss.clear();
    ss << i;
    fEquationIndex_[i * 2] = "deltaP_" + ss.str();
    fEquationIndex_[i * 2 + 1] = "deltaQ_" + ss.str();
  }
  assert(fEquationIndex_.size() == static_cast<size_t>(sizeF()) && "Model VariationArea: fEquationIndex_.size() != fLocal_.size()");
}

void
ModelVariationArea::setGequations() {
  gEquationIndex_[0] = "stopTime > t >= startTime";
  gEquationIndex_[1] = "t >= stopTime";

  assert(gEquationIndex_.size() == static_cast<size_t>(sizeG()) && "Model VariationArea: gEquationIndex.size() != gLocal_.size()");
}

// evaluation of the transpose Jacobian Jt - sparse matrix

void
ModelVariationArea::evalJt(const double /*t*/, const double /*cj*/, const int rowOffset,  SparseMatrix& jt) {
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
ModelVariationArea::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/,  SparseMatrix& jtPrim) {
  // no differential equations
  for (int i = 0; i < nbLoads_; ++i) {  // 2 equations by loads
    jtPrim.changeCol();
    jtPrim.changeCol();
  }
}

// evaluation of discrete variables

void
ModelVariationArea::evalZ(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {  // load increase in progress
    if (stateVariationArea_ != ON_GOING) {
      DYNAddTimelineEvent(this, name(), LoadModificationStarted);
    }
    zLocal_[0] = ON_GOING;
    stateVariationArea_ = ON_GOING;
  }

  if (gLocal_[1] == ROOT_UP) {  // load increase ended
    if (stateVariationArea_ == ON_GOING) {
      DYNAddTimelineEvent(this, name(), LoadModificationEnded);
    }
    zLocal_[0] = FINISHED;
    stateVariationArea_ = FINISHED;
  }
}


void
ModelVariationArea::collectSilentZ(BitMask* silentZTable) {
  silentZTable[0].setFlags(NotUsedInDiscreteEquations);
}

// evaluation of modes (alternatives) of F(t,y,y') functions

modeChangeType_t
ModelVariationArea::evalMode(const double t) {
  if ((timeModeOnGoingRaised_ < 0 || doubleEquals(t, timeModeOnGoingRaised_)) && t >= startTime_) {
    timeModeOnGoingRaised_ = t;
    return DIFFERENTIAL_MODE;
  }
  if ((timeModeFinishedRaised_ < 0 || doubleEquals(t, timeModeFinishedRaised_)) && t >= stopTime_) {
    timeModeFinishedRaised_ = t;
    return DIFFERENTIAL_MODE;
  }
  return NO_MODE;
}

void
ModelVariationArea::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // output depends only on discrete variables
}

void
ModelVariationArea::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // output depends only on discrete variables
}

double
ModelVariationArea::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return 0;
}

void
ModelVariationArea::evalCalculatedVars() {
  // not needed
}

void
ModelVariationArea::getY0() {
  std::fill(yLocal_, yLocal_ + nbLoads_ * 2, 0);
  std::fill(ypLocal_, ypLocal_ + nbLoads_ * 2, 0);
  zLocal_[0] = NOT_STARTED;
}

void
ModelVariationArea::evalStaticYType() {
  std::fill(yType_, yType_ + sizeY(), ALGEBRAIC);  // all variables are algebraic variable
}

void
ModelVariationArea::evalStaticFType() {
  std::fill(fType_, fType_ + 2 * nbLoads_, ALGEBRAIC_EQ);  // no differential variable
}

void
ModelVariationArea::defineVariables(vector<shared_ptr<Variable> >& variables) {
  std::stringstream name;
  for (int i = 0; i < nbLoads_; ++i) {
    name.str("");
    name.clear();
    name << "DeltaPc_load_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));

    name.str("");
    name.clear();
    name << "DeltaQc_load_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  variables.push_back(VariableNativeFactory::createState("state", DISCRETE));
}

void
ModelVariationArea::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbLoads", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("startTime", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("stopTime", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("deltaP_load", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbLoads"));
  parameters.push_back(ParameterModeler("deltaQ_load", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbLoads"));
}

void
ModelVariationArea::setSubModelParameters() {
  nbLoads_ = findParameterDynamic("nbLoads").getValue<int>();
  startTime_ = findParameterDynamic("startTime").getValue<double>();
  stopTime_ = findParameterDynamic("stopTime").getValue<double>();

  deltaP_.clear();
  deltaQ_.clear();
  std::stringstream deltaName;
  for (int k = 0; k < nbLoads_; ++k) {
    deltaName.str("");
    deltaName.clear();
    deltaName << "deltaP_load_" << k;
    deltaP_.push_back(findParameterDynamic(deltaName.str()).getValue<double>());

    deltaName.str("");
    deltaName.clear();
    deltaName << "deltaQ_load_" << k;
    deltaQ_.push_back(findParameterDynamic(deltaName.str()).getValue<double>());
  }
}

void
ModelVariationArea::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  std::stringstream namess;
  for (int i = 0; i < nbLoads_; ++i) {
    namess.str("");
    namess.clear();
    namess << "DeltaPc_load_" << i;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    namess.str("");
    namess.clear();
    namess << "DeltaQc_load_" << i;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}

void
ModelVariationArea::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << "DeltaPc_load_" << "<0-" << nbLoads_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "DeltaQc_load_" << "<0-" << nbLoads_ << ">_value" << Trace::endline;
}
}  // namespace DYN
