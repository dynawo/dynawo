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
 * @file  DYNModelAreaShedding.cpp
 *
 * @brief
 *
 */
#include "DYNModelAreaShedding.h"

#include <iostream>
#include <sstream>
#include <iomanip>
#include <vector>
#include <algorithm>
#include <cmath>
#include <cassert>

#include "PARParametersSet.h"

#include "DYNModelAreaShedding.hpp"
#include "DYNSparseMatrix.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNCommon.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#include "DYNModelConstants.h"

using std::min;
using std::vector;
using std::string;

using std::stringstream;
using std::map;

using boost::shared_ptr;

using parameters::ParametersSet;

/**
 * @brief ModelAreaSheddingFactory getter
 *
 * @return A pointer to a new instance of ModelAreaSheddingFactory
 */
extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelAreaSheddingFactory());
}

/**
 * @brief ModelAreaSheddingFactory destroy method
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

/**
 * @brief ModelAreaShedding getter
 *
 * @return A pointer to a new instance of ModelAreaShedding
 */
extern "C" DYN::SubModel* DYN::ModelAreaSheddingFactory::create() const {
  DYN::SubModel * model(new DYN::ModelAreaShedding());
  return model;
}

/**
 * @brief ModelAreaShedding destroy method
 */
extern "C" void DYN::ModelAreaSheddingFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelAreaShedding::ModelAreaShedding() :
ModelCPP("AreaShedding"),
PShed_(0.),
QShed_(0.),
deltaTime_(0.),
nbLoads_(0),
started_(-1.),
stateAreaShedding_(NOT_STARTED) {
}

void
ModelAreaShedding::init(const double /*t0*/) {
  // not needed
}

void
ModelAreaShedding::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
ModelAreaShedding::initializeStaticData() {
  // not needed
}

void
ModelAreaShedding::getSize() {
  sizeF_ = nbLoads_ * 2;  // equation for deltaPRef and deltaQRef by load
  sizeY_ = nbLoads_ * 2;   // deltaPRef and deltaQRef  by load
  sizeZ_ = 1;  // delta started
  sizeG_ = 1;  // activation of load shedding
  sizeMode_ = 1;  // activation of load shedding

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void ModelAreaShedding::evalStaticYTypeLinearize() {
  std::copy(yType_, yType_ + sizeY(), yTypeLinearize_);
}

void ModelAreaShedding::evalDynamicYTypeLinearize() {
}

void ModelAreaShedding::evalStaticFTypeLinearize() {
  std::copy(fType_, fType_ + sizeY(), fTypeLinearize_);
}

void ModelAreaShedding::evalDynamicFTypeLinearize() {
}

void ModelAreaShedding::getSizeLinearize() {
  sizeFLinearize_ = sizeF_;
  sizeYLinearize_ = sizeY_;
  sizeZLinearize_ = sizeZ_;
  sizeGLinearize_ = sizeG_;
  sizeModeLinearize_ = sizeMode_;

  calculatedVarsLinearize_.assign(nbCalculatedVars_, 0);
}

void ModelAreaShedding::defineVariablesLinearize(std::vector<boost::shared_ptr<Variable> >& variables) {
  defineVariables(variables);
}

void ModelAreaShedding::defineParametersLinearize(std::vector<ParameterModeler>& /*parameters*/) {
}

// evaluation of F(t,y,y') function

void
ModelAreaShedding::evalF(double /*t*/, const propertyF_t type) {
  if (type == DIFFERENTIAL_EQ)
    return;
  if (stateAreaShedding_ == NOT_STARTED) {  // shedding not started
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2];
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1];
    }
  } else {  // shedding started
    for (int i = 0; i < nbLoads_; ++i) {
      fLocal_[i * 2] = yLocal_[i * 2] - deltaP_[i];
      fLocal_[i * 2 + 1] = yLocal_[i * 2 + 1] - deltaQ_[i];
    }
  }
}


// evaluation of root functions

void
ModelAreaShedding::evalG(const double t) {
  gLocal_[0] = (doubleEquals(t, deltaTime_) || (t - deltaTime_) > 0) ? ROOT_UP : ROOT_DOWN;
}

void
ModelAreaShedding::setFequations() {
  stringstream ss;
  for (int i = 0; i < nbLoads_; ++i) {
    ss.str("");
    ss.clear();
    ss << i;
    fEquationIndex_[i * 2] = "deltaP_" + ss.str();
    fEquationIndex_[i * 2 + 1] = "deltaQ_" + ss.str();
  }
  assert(fEquationIndex_.size() == static_cast<size_t>(sizeF()) && "Model AreaShedding: fEquationIndex_.size() != fLocal_.size()");
}

void
ModelAreaShedding::setGequations() {
  gEquationIndex_[0] = "t >= deltaTime";

  assert(gEquationIndex_.size() == static_cast<size_t>(sizeG()) && "Model AreaShedding: gEquationIndex.size() != gLocal_.size()");
}

void
ModelAreaShedding::evalJt(const double /*t*/, const double /*cj*/, const int rowOffset, SparseMatrix& jt) {
  static double dPOne = 1;
  // whatever the state of the automaton, same Jacobian
  for (int i = 0; i < nbLoads_; ++i) {  // 2 equations by loads
    jt.changeCol();
    jt.addTerm(i * 2 + rowOffset, dPOne);
    jt.changeCol();
    jt.addTerm(i * 2 + 1 + rowOffset, dPOne);
  }
}

void
ModelAreaShedding::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& jtPrim) {
  // no differential equations
  for (int i = 0; i < nbLoads_; ++i) {  // 2 equations by loads
    jtPrim.changeCol();
    jtPrim.changeCol();
  }
}

// evaluation of discrete variables

void
ModelAreaShedding::evalZ(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP && stateAreaShedding_ != STARTED) {  // load shedding starts
    if (doubleIsZero(PShed_) && doubleIsZero(QShed_)) {
      DYNAddTimelineEvent(this, name(), LoadSheddingStarted);
    } else {
      DYNAddTimelineEvent(this, name(), LoadSheddingStartedAndDisplay, PShed_, QShed_);
    }
    zLocal_[0] = STARTED;
    stateAreaShedding_ = STARTED;
  }
}


void
ModelAreaShedding::collectSilentZ(BitMask* silentZTable) {
  silentZTable[0].setFlags(NotUsedInDiscreteEquations);
}

// evaluation of modes (alternatives) of F(t,y,y') functions

modeChangeType_t
ModelAreaShedding::evalMode(const double t) {
  if ((started_ < 0 || doubleEquals(t, started_)) && t >= deltaTime_) {
    started_ = t;
    return ALGEBRAIC_MODE;
  }
  return NO_MODE;
}

void
ModelAreaShedding::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // output depends only on discrete variables
}

void
ModelAreaShedding::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // output depends only on discrete variables
}

double
ModelAreaShedding::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return 0;
}

void
ModelAreaShedding::evalCalculatedVars() {
  // not needed
}

void
ModelAreaShedding::getY0() {
  for (int i = 0; i < nbLoads_; ++i) {
    yLocal_[i * 2] = 0.;
    yLocal_[i * 2 + 1] = 0.;
  }
  std::fill(ypLocal_, ypLocal_ + nbLoads_ * 2, 0);
  zLocal_[0] = NOT_STARTED;
}

void
ModelAreaShedding::evalStaticYType() {
  std::fill(yType_, yType_ + sizeY(), ALGEBRAIC);  // all variables are algebraic variable
}

void
ModelAreaShedding::evalStaticFType() {
  std::fill(fType_, fType_ + 2 * nbLoads_, ALGEBRAIC_EQ);  // no differential variable
}

void
ModelAreaShedding::defineVariables(vector<shared_ptr<Variable> >& variables) {
  std::stringstream name;
  for (int i = 0; i < nbLoads_; ++i) {
    name.str("");
    name.clear();
    name << "deltaP_load_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));

    name.str("");
    name.clear();
    name << "deltaQ_load_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  variables.push_back(VariableNativeFactory::createState("state", DISCRETE));
}

void
ModelAreaShedding::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbLoads", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("deltaTime", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("deltaP", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbLoads"));
  parameters.push_back(ParameterModeler("deltaQ", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbLoads"));
  parameters.push_back(ParameterModeler("PShed", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("QShed", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelAreaShedding::setSubModelParameters() {
  nbLoads_ = findParameterDynamic("nbLoads").getValue<int>();
  deltaTime_ = findParameterDynamic("deltaTime").getValue<double>();

  constexpr bool isInitParam = false;
  constexpr bool isLinearizeParam = false;
  bool shedPowersSet = true;
  const ParameterModeler& PShedParameter = findParameter("PShed", isInitParam, isLinearizeParam);
  if (PShedParameter.hasValue()) {
    PShed_ = PShedParameter.getDoubleValue();
  } else {
    shedPowersSet = false;
  }
  const ParameterModeler& QShedparameter = findParameter("QShed", isInitParam, isLinearizeParam);
  if (QShedparameter.hasValue()) {
    QShed_ = QShedparameter.getDoubleValue();
  } else {
    shedPowersSet = false;
  }
  if (!shedPowersSet) {
    Trace::warn() << DYNLog(LoadSheddingValueIncomplete, name()) << Trace::endline;
  }

  deltaP_.clear();
  deltaQ_.clear();
  std::stringstream deltaName;
  for (int k = 0; k < nbLoads_; ++k) {
    deltaName.str("");
    deltaName.clear();
    deltaName << "deltaP_" << k;
    deltaP_.push_back(findParameterDynamic(deltaName.str()).getValue<double>());

    deltaName.str("");
    deltaName.clear();
    deltaName << "deltaQ_" << k;
    deltaQ_.push_back(findParameterDynamic(deltaName.str()).getValue<double>());
  }
}

void
ModelAreaShedding::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  std::stringstream namess;
  for (int i = 0; i < nbLoads_; ++i) {
    namess.str("");
    namess.clear();
    namess << "deltaP_load_" << i;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    namess.str("");
    namess.clear();
    namess << "deltaQ_load_" << i;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}

void
ModelAreaShedding::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << "deltaP_load_" << "<0-" << nbLoads_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "deltaQ_load_" << "<0-" << nbLoads_ << ">_value" << Trace::endline;
}
}  // namespace DYN
