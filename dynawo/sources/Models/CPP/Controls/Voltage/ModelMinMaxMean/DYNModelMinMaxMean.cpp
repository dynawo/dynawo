//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file  DYNModelMinMaxMean.cpp
 *
 * @brief Reference frequency model implementation
 *
 * All generators of the network are connected to this model
 * but only the generators with a weight gen > 0 participate to the calculation of the frequency reference
 *
 */
#include <sstream>
#include <vector>
#include "PARParametersSet.h"

#include "DYNModelMinMaxMean.h"
#include "DYNModelMinMaxMean.hpp"
#include "DYNModelConstants.h"
#include "DYNElement.h"
// #include "DYNSparseMatrix.h"
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
 * @brief ModelMinMaxMeanFactory getter
 *
 * @return A pointer to a new instance of ModelMinMaxMeanFactory
 */
extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelMinMaxMeanFactory());
}

/**
 * @brief ModelMinMaxMeanFactory destroy method
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

/**
 * @brief ModelMinMaxMean getter
 *
 * @return A pointer to a new instance of ModelMinMaxMean
 */
extern "C" DYN::SubModel* DYN::ModelMinMaxMeanFactory::create() const {
  DYN::SubModel* model(new DYN::ModelMinMaxMean());
  return model;
}

/**
 * @brief ModelMinMaxMean destroy method
 */
extern "C" void DYN::ModelMinMaxMeanFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

/**
 * @brief MinMaxMean model default constructor
 *
 */
ModelMinMaxMean::ModelMinMaxMean() :
ModelCPP("minMaxMean"),
nbConnectedInputs_(0) {
}

/**
 * @brief MinMaxMean model initialization
 *
 */
void
ModelMinMaxMean::init(const double /*t0*/) {
  // Nothing to initalize here.
}

void
ModelMinMaxMean::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

/**
 * @brief MinMaxMeans model's sizes getter
 *
 * Get the sizes of the vectors and matrices used by the solver to simulate
 * ModelMinMaxMean instance. Used by @p ModelMulti to generate right size matrices
 * and vector for the solver.
 */
void
ModelMinMaxMean::getSize() {
  sizeF_ = 0;  // No dynamics
  sizeY_ = nbConnectedInputs_;  // All voltage inputs and their boolean activity values
  sizeZ_ = nbConnectedInputs_;
  sizeG_ = 0;
  sizeMode_ = 1;

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ModelMinMaxMean::evalF(double /*t*/, propertyF_t /*type*/) {
  // No evalF function deeded
}

void
ModelMinMaxMean::evalG(const double /*t*/) {
  // No root function for this model
}

void
ModelMinMaxMean::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& /*jt*/, const int /*rowOffset*/) {
  // No evalJt function needed
}

void
ModelMinMaxMean::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& /*jt*/, const int /*rowOffset*/) {
  // No evalJtPrim function needed
}

void
ModelMinMaxMean::evalZ(const double /*t*/) {
  // No evalZ function needed
}

void
ModelMinMaxMean::collectSilentZ(BitMask* /*silentZTable*/) {
  /*
  for (unsigned k = 0; k < sizeZ_; ++k) {
    silentZTable[k].setFlags(NotUsedInDiscreteEquations);
  }
  */
}

modeChangeType_t
ModelMinMaxMean::evalMode(const double /*t*/) {
  return NO_MODE;
}

void
ModelMinMaxMean::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // output depends only on discrete variables
}

void
ModelMinMaxMean::getIndexesOfVariablesUsedForCalculatedVarI(unsigned int iCalculatedVar, std::vector<int>& indexes) const {
  // Need to return the variables for the input voltages and associated booleans
  switch (iCalculatedVar) {
    case minValIdx_:
    case maxValIdx_:
    case avgValIdx_:
      for (std::size_t i = 0; i < nbConnectedInputs_; i++) {
        indexes.push_back(i);  // Adds the voltage ...
        // indexes.push_back(i + nbConnectedInputs_);  // and the boolean
      }
      break;
    default:
        throw DYNError(Error::MODELER, UndefJCalculatedVarI, iCalculatedVar);
  }
}


double
ModelMinMaxMean::evalCalculatedVarI(unsigned iCalculatedVar) const {
  double out = 0.0f;
  switch (iCalculatedVar) {
  case minValIdx_:
    out = computeMin();
    break;
  case maxValIdx_:
    out = computeMax();
    break;
  case avgValIdx_:
    out = computeMean();
    break;

  default:
    throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);  // Macro defined in DYNMacrosMessage
    break;
  }

  return out;
}

void
ModelMinMaxMean::evalCalculatedVars() {
  calculatedVars_[minValIdx_] = computeMin();
  calculatedVars_[maxValIdx_] = computeMax();
  calculatedVars_[avgValIdx_] = computeMean();
}

void
ModelMinMaxMean::getY0() {
  // Not needed
}

void
ModelMinMaxMean::evalStaticYType() {
  std::fill(yType_, yType_ + nbConnectedInputs_, EXTERNAL);  // Variables are obtained from outside.
}

void
ModelMinMaxMean::evalStaticFType() {
  // function not needed for MinMaxMean
}

/**
 * @brief initialize variables of the model
 *
 * A variable is a structure which contains all information needed to interact with the model
 */
void
ModelMinMaxMean::defineVariables(vector<shared_ptr<Variable> >& variables) {
  // Add the voltages
  stringstream name;
  for (std::size_t i=0; i < nbConnectedInputs_; i++) {
    name.str("");
    name.clear();
    name << "UMonitored_" << i << "Pu_value";  // As in "Voltage INput"
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }

  // Add whether a bus is connected or not
  for (std::size_t i=0; i < nbConnectedInputs_; i++) {
    name.str("");
    name.clear();
    name << "running_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), BOOLEAN));
  }
}

void
ModelMinMaxMean::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbInputs", VAR_TYPE_INT, EXTERNAL_PARAMETER));
}

void
ModelMinMaxMean::setSubModelParameters() {
  nbConnectedInputs_ = findParameterDynamic("nbInputs").getValue<int>();
}

/**
 * @brief Reference frequency elements initializer
 *
 * Define elements for this model( elements to be seen by other models)
 *
 * @param elements  Reference to elements' vector
 * @param mapElement Map associating each element index in the elements vector to its name
 */
void
ModelMinMaxMean::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  addElement("min", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "min", Element::TERMINAL, name(), modelType(), elements, mapElement);
  addElement("max", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "max", Element::TERMINAL, name(), modelType(), elements, mapElement);
  addElement("avg", Element::STRUCTURE, elements, mapElement);
  addSubElement("value", "avg", Element::TERMINAL, name(), modelType(), elements, mapElement);
  // Now deal with the continuous variables
  stringstream names;
  for (size_t i = 0; i < nbConnectedInputs_; ++i) {
    names.str("");
    names.clear();
    names << "UMonitored_" << i;
    addElement(names.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", names.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
  // Now let's handle the boolean parts
  for (size_t i = 0; i < nbConnectedInputs_; ++i) {
    names.str("");
    names.clear();
    names << "running_" << i;
    addElement(names.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", names.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}

void
ModelMinMaxMean::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << "VinPu_" << "<0-" << nbConnectedInputs_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "isActive_" << "<0-" << nbConnectedInputs_ << ">_value" << Trace::endline;
}

void
ModelMinMaxMean::setFequations() {
  // setFequations not needed
}

void
ModelMinMaxMean::checkDataCoherence(const double /*t*/) {
  for (std::size_t i = 0; i < nbConnectedInputs_; ++i) {
    if (isConnected(i)) {  // Current input is active.
      if (yLocal_[i] < calculatedVars_[minValIdx_]) {
        throw DYNError(Error::MODELER, FrequencyCollapse, yLocal_[i], calculatedVars_[minValIdx_]);
      }
      if (yLocal_[i] > calculatedVars_[maxValIdx_]) {
        throw DYNError(Error::MODELER, FrequencyIncrease, yLocal_[i], calculatedVars_[maxValIdx_]);
      }
    }
  }
}

double
ModelMinMaxMean::computeMin() const {
  double minSoFar = MAXFLOAT;
  for (std::size_t i=0; i < nbConnectedInputs_; i++) {
    if (isConnected(i)) {
      minSoFar =  (yLocal_[i] < minSoFar) ? yLocal_[i] : minSoFar;
    }
  }
  return minSoFar;
}

double
ModelMinMaxMean::computeMax() const {
  double maxSoFar = -MAXFLOAT;
  for (std::size_t i=0; i < nbConnectedInputs_; i++) {
    if (isConnected(i)) {
      maxSoFar =  (yLocal_[i] > maxSoFar) ? yLocal_[i] : maxSoFar;
    }
  }
  return maxSoFar;
}

double
ModelMinMaxMean::computeMean() const {
  double totSoFar = 0;
  unsigned int nbActive = 0;
  for (std::size_t i=0; i < nbConnectedInputs_; i++) {
    if (isConnected(i)) {
      totSoFar +=  yLocal_[i];
      nbActive++;
    }
  }
  return nbActive == 0? 0.0: totSoFar/nbActive;
}

bool
ModelMinMaxMean::isConnected(unsigned int iInputIdx) const {
  bool out = false;
  if (iInputIdx < nbConnectedInputs_) {
    out = zLocal_[iInputIdx] > 0;
  }

  return out;
}

}  // namespace DYN
