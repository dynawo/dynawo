//
// Copyright (c) 2022-2022, RTE (http://www.rte-france.com)
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
nbConnectedInputs_(0) {
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
  sizeF_ = 0;  // No equartions
  sizeY_ = nbConnectedInputs_;  // All voltage inputs and their boolean activity values
  sizeZ_ = nbConnectedInputs_;
  sizeG_ = 0;
  sizeMode_ = 0;

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ModelVoltageMeasurementsUtilities::evalF(double /*t*/, propertyF_t /*type*/) {
  // No evalF function needed
}

void
ModelVoltageMeasurementsUtilities::evalG(const double /*t*/) {
  // No root function for this model
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
ModelVoltageMeasurementsUtilities::evalZ(const double /*t*/) {
  // No evalZ function needed
}

void
ModelVoltageMeasurementsUtilities::collectSilentZ(BitMask* silentZTable) {
  for (unsigned int s = 0; s < sizeZ_; ++s) {
    silentZTable[s].setFlags(NotUsedInContinuousEquations);
  }
}

modeChangeType_t
ModelVoltageMeasurementsUtilities::evalMode(const double /*t*/) {
  return NO_MODE;
}

void
ModelVoltageMeasurementsUtilities::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // output depends only on discrete variables
}

void
ModelVoltageMeasurementsUtilities::getIndexesOfVariablesUsedForCalculatedVarI(unsigned int iCalculatedVar, std::vector<int>& indexes) const {
  switch (iCalculatedVar) {
    case minValIdx_:
    case maxValIdx_:
    case avgValIdx_:
      for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
        if (isConnected(i)) {
          indexes.push_back(i);
        }
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
    out = computeMin();
    break;
  case maxValIdx_:
    out = computeMax();
    break;
  case avgValIdx_:
    out = computeAverage();
    break;

  default:
    throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);  // Macro defined in DYNMacrosMessage
  }

  return out;
}

void
ModelVoltageMeasurementsUtilities::evalCalculatedVars() {
  calculatedVars_[minValIdx_] = computeMin();
  calculatedVars_[maxValIdx_] = computeMax();
  calculatedVars_[avgValIdx_] = computeAverage();
}

void
ModelVoltageMeasurementsUtilities::getY0() {
  // Not needed
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
  variables.push_back(VariableNativeFactory::createCalculated("min_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("max_value", CONTINUOUS));
  variables.push_back(VariableNativeFactory::createCalculated("average_value", CONTINUOUS));

  // Add the voltages
  stringstream name;
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    name.str("");
    name.clear();
    name << "UMonitored_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }

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
}

void
ModelVoltageMeasurementsUtilities::setSubModelParameters() {
  nbConnectedInputs_ = findParameterDynamic("nbInputs").getValue<int>();
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
ModelVoltageMeasurementsUtilities::computeMin() const {
  double minSoFar = std::numeric_limits<float>::max();
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    if (isConnected(i)) {
      minSoFar =  (yLocal_[i] < minSoFar) ? yLocal_[i] : minSoFar;
    }
  }
  return minSoFar;
}

double
ModelVoltageMeasurementsUtilities::computeMax() const {
  double maxSoFar = std::numeric_limits<float>::lowest();
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    if (isConnected(i)) {
      maxSoFar =  (yLocal_[i] > maxSoFar) ? yLocal_[i] : maxSoFar;
    }
  }
  return maxSoFar;
}

double
ModelVoltageMeasurementsUtilities::computeAverage() const {
  double totSoFar = 0;
  unsigned int nbActive = 0;
  for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
    if (isConnected(i)) {
      totSoFar +=  yLocal_[i];
      ++nbActive;
    }
  }
  return nbActive == 0 ? 0.0: totSoFar/nbActive;
}

bool
ModelVoltageMeasurementsUtilities::isConnected(unsigned int inputIdx) const {
  bool out = false;
  if (inputIdx < nbConnectedInputs_) {
    out = zLocal_[inputIdx] > 0;
  }

  return out;
}

}  // namespace DYN
