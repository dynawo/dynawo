//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNModelVoltageMeasurementsUtilities.cpp
 *
 * @brief Measurements utility model
 *
 * Model to compute some aggregations of the voltages connected to the (sub)network.
 * Only running models are taken into account for the computations.
 *
 * Aggregations implemented:
 * -> Minimum
 * -> Maximum
 * -> Average
 *
 */

#include <sstream>
#include <vector>
#include "PARParametersSet.h"

#include "DYNModelVoltageMeasurementsUtilities.h"
#include "DYNModelVoltageMeasurementsUtilities.hpp"
#include "DYNModelConstants.h"
#include "DYNElement.h"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNTrace.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"

using std::vector;
using std::string;
using std::map;
using std::stringstream;

using boost::shared_ptr;

using parameters::ParametersSet;

/**
 * @brief ModelVoltageMeasurementsUtilitiesFactory getter
 *
 * @return A pointer to a new instance of ModelVoltageMeasurementsUtilitiesFactory
 */
extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelVoltageMeasurementsUtilitiesFactory());
}

/**
 * @brief ModelVoltageMeasurementsUtilitiesFactory destroy method
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

/**
 * @brief ModelVoltageMeasurementsUtilities getter
 *
 * @return A pointer to a new instance of ModelVoltageMeasurementsUtilities
 */
extern "C" DYN::SubModel* DYN::ModelVoltageMeasurementsUtilitiesFactory::create() const {
  DYN::SubModel* model(new DYN::ModelVoltageMeasurementsUtilities());
  return model;
}

/**
 * @brief ModelVoltageMeasurementsUtilitiesFactory destroy method
 */
extern "C" void DYN::ModelVoltageMeasurementsUtilitiesFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

/**
 * @brief ModelVoltageMeasurementsUtilities model default constructor
 *
 */
ModelVoltageMeasurementsUtilities::ModelVoltageMeasurementsUtilities() :
ModelCPP("voltageMeasurementsUtilities"),
nbConnectedInputs_(0), step_(12.), isInitialized_(false) {
}

/**
 * @brief ModelVoltageMeasurementsUtilities model initialization
 *
 */
void
ModelVoltageMeasurementsUtilities::init(const double /*t0*/) {
  // Nothing to initalize here.
}

void
ModelVoltageMeasurementsUtilities::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
ModelVoltageMeasurementsUtilities::getSize() {
  sizeF_ = 0;  // No equations
  sizeY_ = nbConnectedInputs_;  // All voltage inputs and their boolean activity values
  sizeZ_ = nbConnectedInputs_ + nbDiscreteVars_;
  sizeG_ = nbRoots_;
  sizeMode_ = 0;

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ModelVoltageMeasurementsUtilities::evalF(double /*t*/, propertyF_t /*type*/) {
  // No evalF function needed
}

void
ModelVoltageMeasurementsUtilities::evalG(const double t) {
  if (!isInitialized_) {
    initializeVMU(t);
  }
  gLocal_[timeToUpdate_] = ((t-(zLocal_[tLastUpdate_] + step_)) >= 0) ? ROOT_UP : ROOT_DOWN;
}

void
ModelVoltageMeasurementsUtilities::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& /*jt*/, const int /*rowOffset*/) {
  // No evalJt function needed
}

void
ModelVoltageMeasurementsUtilities::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& /*jt*/, const int /*rowOffset*/) {
  // No evalJtPrim function needed
}

void
ModelVoltageMeasurementsUtilities::evalZ(const double t) {
  // Make sure it is initialized
  if (!isInitialized_) {
    initializeVMU(t);
  }

  // Is it time for a new update?
  if (gLocal_[timeToUpdate_] == ROOT_UP) {
    // update EV-E-RY-THIIIING !!
    for (size_t i = 0; i < nbConnectedInputs_; ++i) {
      isActive_[i] = toNativeBool(zLocal_[i + nbDiscreteVars_]);
    }
    lastMin_ = computeMin(achievedMin_);
    lastMax_ = computeMax(achievedMax_);
    lastAverage_ = computeAverage(nbActive_);
    zLocal_[tLastUpdate_] = t;
  }
}

void
ModelVoltageMeasurementsUtilities::collectSilentZ(BitMask* silentZTable) {
  for (unsigned int s = 0; s < sizeZ_; ++s) {
    silentZTable[s].setFlags(NotUsedInContinuousEquations);
  }
}

modeChangeType_t
ModelVoltageMeasurementsUtilities::evalMode(const double /*t*/) {
  if (gLocal_[timeToUpdate_] == ROOT_UP) return ALGEBRAIC_J_UPDATE_MODE;
  return NO_MODE;
}

void
ModelVoltageMeasurementsUtilities::evalJCalculatedVarI(unsigned iCalculatedVar, vector<double>& res) const {
  if (iCalculatedVar < nbCalculatedVars_) {
    for (size_t i = 0; i < sizeZ_; ++i) {
      res[i] = 0.;
    }
  }
  switch (iCalculatedVar) {
    case minValIdx_: {
      if (achievedMin_ < nbConnectedInputs_) {
        res[achievedMin_ + nbDiscreteVars_] = 1.;
      }
      break;
    }
    case maxValIdx_: {
      if (achievedMax_ < nbConnectedInputs_) {
        res[achievedMax_ + nbDiscreteVars_] = 1.;
      }
      break;
    }
    case avgValIdx_: {
      if (nbActive_ > 0) {
        for (std::size_t i = 0; i < nbConnectedInputs_; ++i) {
          if (isRunning(i)) {
            res[i+nbDiscreteVars_] = 1./nbActive_;
          }
        }
      }
      break;
    }
    default: {
      throw DYNError(Error::MODELER, UndefJCalculatedVarI, iCalculatedVar);
    }
  }
}

void
ModelVoltageMeasurementsUtilities::getIndexesOfVariablesUsedForCalculatedVarI(unsigned int iCalculatedVar, std::vector<int>& indexes) const {
  switch (iCalculatedVar) {
    case minValIdx_:
    case maxValIdx_:
    case avgValIdx_:
      for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
        indexes.push_back(i);
      }
      break;
    default:
        throw DYNError(Error::MODELER, UndefJCalculatedVarI, iCalculatedVar);
  }
}

double
ModelVoltageMeasurementsUtilities::evalCalculatedVarI(unsigned iCalculatedVar) const {
  double out = 0.0f;
  switch (iCalculatedVar) {
  case minValIdx_:
    out = lastMin_;
    break;
  case maxValIdx_:
    out = lastMax_;
    break;
  case avgValIdx_:
    out = lastAverage_;
    break;

  default:
    throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);  // Macro defined in DYNMacrosMessage
  }

  return out;
}

void
ModelVoltageMeasurementsUtilities::evalCalculatedVars() {
  calculatedVars_[minValIdx_] = lastMin_;
  calculatedVars_[maxValIdx_] = lastMax_;
  calculatedVars_[avgValIdx_] = lastAverage_;
}

void
ModelVoltageMeasurementsUtilities::getY0() {
  initializeVMU(0.);
}

void
ModelVoltageMeasurementsUtilities::evalStaticYType() {
  std::fill(yType_, yType_ + nbConnectedInputs_, EXTERNAL);  // Variables are obtained from outside.
}

void
ModelVoltageMeasurementsUtilities::evalStaticFType() {
  // function not needed for VoltageMeasurementsUtilities
}

void
ModelVoltageMeasurementsUtilities::defineVariables(vector<shared_ptr<Variable> >& variables) {
  // Create "output" variables
  variables.push_back(VariableNativeFactory::createCalculated("min_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated("max_value", DISCRETE));
  variables.push_back(VariableNativeFactory::createCalculated("average_value", DISCRETE));

  // Add the voltages
  stringstream name;
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    name.str("");
    name.clear();
    name << "UMonitored_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }

  // Add the time of last update
  name.str("");
  name.clear();
  name << "tLastUpdate_value";
  variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));

  // Add whether a bus is connected or not
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    name.str("");
    name.clear();
    name << "running_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), BOOLEAN));
  }
}

void
ModelVoltageMeasurementsUtilities::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbInputs", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("updateStep", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelVoltageMeasurementsUtilities::setSubModelParameters() {
  nbConnectedInputs_ = findParameterDynamic("nbInputs").getValue<int>();
  step_ = findParameterDynamic("updateStep").getValue<double>();
}

void
ModelVoltageMeasurementsUtilities::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement("min", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "min", Element::TERMINAL, name(), modelType(), elements, mapElement);
  addElement("max", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "max", Element::TERMINAL, name(), modelType(), elements, mapElement);
  addElement("average", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "average", Element::TERMINAL, name(), modelType(), elements, mapElement);

  stringstream names;
  for (size_t i = 0; i < nbConnectedInputs_; ++i) {
    names.str("");
    names.clear();
    names << "UMonitored_" << i;
    addElement(names.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", names.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }

  addElement("tLastUpdate_", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "tLastUpdate_", Element::TERMINAL, name(), modelType(), elements, mapElement);

  for (size_t i = 0; i < nbConnectedInputs_; ++i) {
    names.str("");
    names.clear();
    names << "running_" << i;
    addElement(names.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", names.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}

void
ModelVoltageMeasurementsUtilities::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << "UMonitored_" << "<0-" << nbConnectedInputs_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "running_" << "<0-" << nbConnectedInputs_ << ">_value" << Trace::endline;
}

void
ModelVoltageMeasurementsUtilities::setFequations() {
  // setFequations not needed
}

void
ModelVoltageMeasurementsUtilities::checkDataCoherence(const double /*t*/) {
  // Nothing to do in this case.
}

double
ModelVoltageMeasurementsUtilities::computeMin(unsigned int &minIdx) const {
  double minSoFar = std::numeric_limits<double>::max();
  minIdx = nbConnectedInputs_;
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    if (isRunning(i) && (minSoFar > yLocal_[i])) {
      minSoFar = yLocal_[i];
      minIdx = i;
    }
  }
  return minSoFar;
}

double
ModelVoltageMeasurementsUtilities::computeMax(unsigned int &maxIdx) const {
  double maxSoFar = std::numeric_limits<double>::lowest();
  maxIdx = nbConnectedInputs_;
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    if (isRunning(i) && (yLocal_[i] > maxSoFar)) {
      maxSoFar = yLocal_[i];
      maxIdx = i;
    }
  }
  return maxSoFar;
}

double
ModelVoltageMeasurementsUtilities::computeAverage(unsigned int &nbActive) const {
  double totSoFar = 0;
  nbActive = 0;
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    if (isRunning(i)) {
      totSoFar +=  yLocal_[i];
      ++nbActive;
    }
  }
  return nbActive == 0 ? 0.0: totSoFar/nbActive;
}

bool
ModelVoltageMeasurementsUtilities::isRunning(unsigned int inputIdx) const {
  bool out = false;
  if (inputIdx < nbConnectedInputs_) {
    out = isActive_[inputIdx];
  }

  return out;
}

void
ModelVoltageMeasurementsUtilities::initializeVMU(const double t) {
  if (!isInitialized_) {
    isActive_ = new bool[nbConnectedInputs_];
    nbActive_ = 0;
    achievedMin_ = nbConnectedInputs_;
    achievedMax_ = nbConnectedInputs_;
    lastMax_ = std::numeric_limits<double>::lowest();
    lastMin_ = std::numeric_limits<double>::max();
    lastAverage_ = 0.;
    for (std::size_t i = 0; i < nbConnectedInputs_; ++i) {
      isActive_[i] = zLocal_[nbDiscreteVars_ + i];
      if (isActive_[i]) {
        ++nbActive_;
        if (yLocal_[i] > lastMax_) {
          lastMax_ = yLocal_[i];
          achievedMax_ = i;
        }
        if (yLocal_[i] < lastMin_) {
          lastMin_ = yLocal_[i];
          achievedMin_ = i;
        }
        lastAverage_ += yLocal_[i];
      }
    }
    lastAverage_ = nbActive_ == 0 ? 0 : lastAverage_/nbActive_;
    isInitialized_ = true;
    zLocal_[tLastUpdate_] = t;
  }
}

}  // namespace DYN
