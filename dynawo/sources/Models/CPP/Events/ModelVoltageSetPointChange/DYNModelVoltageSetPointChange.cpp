//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNModelVoltageSetPointChange.cpp
 *
 * @brief Model to handle a voltage set point change on loads
 *
 */
#include <iostream>
#include <sstream>
#include <vector>
#include <algorithm>
#include <cassert>

#include "DYNModelVoltageSetPointChange.h"
#include "DYNModelVoltageSetPointChange.hpp"
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
 * @brief ModelVoltageSetPointChangeFactory getter
 *
 * @return A pointer to a new instance of ModelVariationaAreaFactory
 */
extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelVoltageSetPointChangeFactory());
}

/**
 * @brief ModelVoltageSetPointChangeFactory destroy method
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

/**
 * @brief ModelVoltageSetPointChange getter
 *
 * @return A pointer to a new instance of ModelVoltageSetPointChange
 */
extern "C" DYN::SubModel* DYN::ModelVoltageSetPointChangeFactory::create() const {
  DYN::SubModel * model(new DYN::ModelVoltageSetPointChange());
  return model;
}

/**
 * @brief ModelVoltageSetPointChange destroy method
 */
extern "C" void DYN::ModelVoltageSetPointChangeFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelVoltageSetPointChange::ModelVoltageSetPointChange() :
ModelCPP("VoltageSetPointChange"),
startTime_(0.),
stopTime_(0.),
voltageSetPointChange_(0.),
numLoads_(0),
startTimelineAdded_(false),
endTimelineAdded_(false) {
}

void
ModelVoltageSetPointChange::init(const double /*t0*/) {
  // not needed
}

void
ModelVoltageSetPointChange::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
ModelVoltageSetPointChange::initializeStaticData() {
  // not needed
}

void
ModelVoltageSetPointChange::getSize() {
  sizeF_ = 0;
  sizeY_ = 0;
  sizeZ_ = numLoads_;  // number of loads controlled
  sizeG_ = 2;
  sizeMode_ = 0;

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ModelVoltageSetPointChange::evalF(double /*t*/, propertyF_t /*type*/) {
  // not needed
}

void
ModelVoltageSetPointChange::evalG(const double t) {
  gLocal_[0] = ((t > startTime_ || doubleEquals(t, startTime_)) && t < stopTime_) ? ROOT_UP : ROOT_DOWN;
  gLocal_[1] = (t > stopTime_ || doubleEquals(t, stopTime_)) ? ROOT_UP : ROOT_DOWN;
}

void
ModelVoltageSetPointChange::setFequations() {
  // not needed
}

void
ModelVoltageSetPointChange::setGequations() {
  gEquationIndex_[0] = "stopTime > t >= startTime";
  gEquationIndex_[1] = "t >= stopTime";

  assert(gEquationIndex_.size() == static_cast<size_t>(sizeG()) && "Model VoltageSetPointChange: gEquationIndex.size() != gLocal_.size()");
}

void
ModelVoltageSetPointChange::evalJt(const double /*t*/, const double /*cj*/, const int /*rowOffset*/, SparseMatrix& /*jt*/) {
  // not needed
}

void
ModelVoltageSetPointChange::evalJtPrim(const double /*t*/, const double /*cj*/, const int /*rowOffset*/,  SparseMatrix& /*jtPrim*/) {
  // not needed
}

void
ModelVoltageSetPointChange::evalZ(const double /*t*/) {
  if (gLocal_[0] == ROOT_UP) {
    for (int i = 0; i < numLoads_; ++i) {
      zLocal_[i] = voltageSetPointChange_;
    }
    if (!startTimelineAdded_) {
      DYNAddTimelineEvent(this, name(), VoltageSetPointChangeStarted);
      startTimelineAdded_ = true;
    }
  }

  if (gLocal_[1] == ROOT_UP) {
    for (int i = 0; i < numLoads_; ++i) {
      zLocal_[i] = 0.;
    }
    if (!endTimelineAdded_) {
      DYNAddTimelineEvent(this, name(), VoltageSetPointChangeEnded);
      endTimelineAdded_ = true;
    }
  }
}


void
ModelVoltageSetPointChange::collectSilentZ(BitMask* silentZTable) {
  for (int i = 0; i < numLoads_; ++i) {
    silentZTable[i].setFlags(NotUsedInContinuousEquations);
  }
}

modeChangeType_t
ModelVoltageSetPointChange::evalMode(const double /*t*/) {
  return NO_MODE;
}

void
ModelVoltageSetPointChange::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // not needed
}

void
ModelVoltageSetPointChange::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // not needed
}

double
ModelVoltageSetPointChange::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return 0;
}

void
ModelVoltageSetPointChange::evalCalculatedVars() {
  // not needed
}

void
ModelVoltageSetPointChange::getY0() {
  for (int i = 0; i < numLoads_; ++i) {
    zLocal_[i] = 0.;
  }
}

void
ModelVoltageSetPointChange::evalStaticYType() {
  // not needed
}

void
ModelVoltageSetPointChange::evalStaticFType() {
  // not needed
}

void
ModelVoltageSetPointChange::defineVariables(vector<shared_ptr<Variable> >& variables) {
  std::stringstream name;
  for (int i = 0; i < numLoads_; ++i) {
    name.str("");
    name.clear();
    name << "setPointChange_" << i;
    variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));
  }
}

void
ModelVoltageSetPointChange::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("numLoads", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("startTime", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("stopTime", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("voltageSetPointChange", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelVoltageSetPointChange::setSubModelParameters() {
  numLoads_ = findParameterDynamic("numLoads").getValue<int>();
  startTime_ = findParameterDynamic("startTime").getValue<double>();
  voltageSetPointChange_ = findParameterDynamic("voltageSetPointChange").getValue<double>();
  const ParameterModeler& stopTime = findParameterDynamic("stopTime");
  if (stopTime.hasValue())
    stopTime_ = stopTime.getValue<double>();
  else
    stopTime_ = std::numeric_limits<double>::max();
}

void
ModelVoltageSetPointChange::defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) {
  std::stringstream name;
  for (int i = 0; i < numLoads_; ++i) {
    name.str("");
    name.clear();
    name << "setPointChange_" << i;
    addElement(name.str(), Element::TERMINAL, elements, mapElement);
  }
}

void
ModelVoltageSetPointChange::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << "setPointChange_" << "<0-" << numLoads_ << ">" << Trace::endline;
}
}  // namespace DYN
