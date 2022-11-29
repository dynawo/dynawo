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
 * @file  DYNModelOmegaRef.cpp
 *
 * @brief Reference frequency model implementation
 *
 * All generators of the network are connected to this model
 * but only the generators with a weight gen > 0 participate to the calculation of the frequency reference
 *
 */
#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNModelOmegaRef.h"
#include "DYNModelOmegaRef.hpp"
#include "DYNModelConstants.h"
#include "DYNSparseMatrix.h"
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
 * @brief ModelOmegaRefFactory getter
 *
 * @return A pointer to a new instance of ModelOmegaRefFactory
 */
extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelOmegaRefFactory());
}

/**
 * @brief ModelOmegaRefFactory destroy method
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

/**
 * @brief ModelOmegaRef getter
 *
 * @return A pointer to a new instance of ModelOmegaRef
 */
extern "C" DYN::SubModel* DYN::ModelOmegaRefFactory::create() const {
  DYN::SubModel* model(new DYN::ModelOmegaRef());
  return model;
}

/**
 * @brief ModelOmegaRef destroy method
 */
extern "C" void DYN::ModelOmegaRefFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {
static const int nbMaxCC = 10;  ///< max number of subNetwork where omegaRef is calculated

int ModelOmegaRef::col1stOmegaRef_;
int ModelOmegaRef::col1stOmega_;

/**
 * @brief Reference frequency model default constructor
 *
 *
 */
ModelOmegaRef::ModelOmegaRef() :
ModelCPP("omegaRef"),
firstState_(true),
nbGen_(0),
nbCC_(0),
nbOmega_(0),
omegaRefMin_(0.98),
omegaRefMax_(1.02) {
}

/**
 * @brief Reference frequency model initialization
 *
 */
void
ModelOmegaRef::init(const double /*t0*/) {
  numCCNode_.assign(nbGen_, 0);
  runningGrp_.assign(nbGen_, 0);
  nbCC_ = 0;

  ModelOmegaRef::col1stOmegaRef_ = 0;
  ModelOmegaRef::col1stOmega_ = ModelOmegaRef::col1stOmegaRef_ + nbMaxCC;
  col1stOmegaRefGrp_ = ModelOmegaRef::col1stOmega_ + nbOmega_;
}

void
ModelOmegaRef::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

/**
 * @brief Reference Frequency model's sizes getter
 *
 * Get the sizes of the vectors and matrices used by the solver to simulate
 * ModelOmegaRef instance. Used by @p ModelMulti to generate right size matrices
 * and vector for the solver.
 */
void
ModelOmegaRef::getSize() {
  sizeF_ = nbMaxCC + nbGen_;  // nbMaxCC eq (omegaref) + one equation by generator
  sizeY_ = nbMaxCC + nbGen_ + nbOmega_;  // (omegaref)*nbMaxCC + omegaRef by grp + omega_ for grp with weight > 0
  sizeZ_ = nbGen_ * 2;   // num cc for each connection node of generators + stateOff of each generators
  sizeG_ = 0;
  sizeMode_ = 1;  // change of CC organisation

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ModelOmegaRef::calculateInitialState() {
  sortGenByCC();
}

void
ModelOmegaRef::evalF(double /*t*/, propertyF_t type) {
  if (type == DIFFERENTIAL_EQ)
    return;
  if (firstState_) {
    calculateInitialState();
    firstState_ = false;
  }

  // I: for each connected component i, for generator k in this cc i:
  // 0 = sum_k (omega[k] * weight[k]) - omegaRef[i] * sum_k (weight[k])
  for (int i = 0; i < nbMaxCC; ++i) {
    map<int, std::vector<int> >::const_iterator iterGen = genByCC_.find(i);
    map<int, double>::const_iterator iterWeight = sumWeightByCC_.find(i);
    if (iterGen == genByCC_.end() || iterWeight == sumWeightByCC_.end()) {
      fLocal_[i] = 1 - yLocal_[i];
    } else {
      fLocal_[i] = -yLocal_[i];
      std::vector<int> numGen = iterGen->second;
      for (unsigned int j = 0; j < numGen.size(); ++j) {
        if (toNativeBool(runningGrp_[numGen[j]]) && weights_[numGen[j]] > 0) {
          fLocal_[i] += yLocal_[nbMaxCC + indexOmega_[numGen[j]]] * weights_[numGen[j]] / iterWeight->second;
        }
      }
    }
  }

  // II: equation nbMaxCC to nbGen_ + nbMaxCC :
  // for each generator k, and the connected component i which contains this generator k:
  // 0 = omegaRef[i] - omegaRefGrp[k]
  // the index i is given by numCCNode_[k]
  for (int k = 0; k < nbGen_; ++k) {
    if (toNativeBool(runningGrp_[k])) {
      fLocal_[nbMaxCC + k] = yLocal_[numCCNode_[k]] - yLocal_[nbMaxCC + nbOmega_ + k];
    } else {
      fLocal_[nbMaxCC + k] = 1 - yLocal_[nbMaxCC + nbOmega_ + k];
    }
  }
}

void
ModelOmegaRef::evalG(const double /*t*/) {
  // No root function for this model
}

void
ModelOmegaRef::evalJt(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int rowOffset) {
  // Equations:
  // I: for each connected component i, for generator k in this cc i:
  // 0 = sum_k (omega[k] * weight[k]) - omegaRef[i] * sum_k (weight[k])

  // II: equation nbMaxCC to nbGen_ + nbMaxCC :
  // for each generator k, and the connected component i which contains this generator k:
  // 0 = omegaRef[i] - omegaRefGrp[k]
  // the index i is given by numCCNode_[k]

  static double dMOne = -1.;
  static double dPOne = +1.;

  for (int i = 0; i < nbMaxCC; ++i) {
    jt.changeCol();
    map<int, std::vector<int> >::const_iterator iterGen = genByCC_.find(i);
    map<int, double>::const_iterator iterWeight = sumWeightByCC_.find(i);
    if (iterGen == genByCC_.end() || iterWeight == sumWeightByCC_.end()) {
      // f=1-omegaRef[i]
      jt.addTerm(col1stOmegaRef_ + i + rowOffset, dMOne);   // d(f)/d(omegaRef[i]) = -1;
    } else {
      // f = sum(omega[]*weight[]) - omegaRef[i]
      jt.addTerm(col1stOmegaRef_ + i + rowOffset, dMOne);   // d(f)/d(omegaRef[i]) = -1;
      std::vector<int> numGen = iterGen->second;
      for (unsigned int j = 0; j < numGen.size(); ++j) {
        if (toNativeBool(runningGrp_[numGen[j]]) && weights_[numGen[j]] > 0) {
          jt.addTerm(indexOmega_[numGen[j]] + col1stOmega_ + rowOffset, weights_[numGen[j]] / iterWeight->second);  // d(f0)/d(omega[i]) = weight[i]
        }
      }
    }
  }

  for (int i = 0; i < nbGen_; ++i) {
    jt.changeCol();
    if (runningGrp_[i] > 0.5) {
      jt.addTerm(col1stOmegaRef_ + numCCNode_[i] + rowOffset, dPOne);   // d(f)/d(omegaRef[0]) = 1:
      jt.addTerm(i + col1stOmegaRefGrp_ + rowOffset, dMOne);   // d(f)/d(omegaRefGrp[i]) = -1
    } else {
      jt.addTerm(i + col1stOmegaRefGrp_ + rowOffset, dMOne);   // d(f)/d(omegaRefGrp[i]) = -1
    }
  }
}

void
ModelOmegaRef::evalJtPrim(const double /*t*/, const double /*cj*/, SparseMatrix& jt, const int /*rowOffset*/) {
  // Equations:
  // I: for each connected component i, for generator k in this cc i:
  // 0 = sum_k (omega[k] * weight[k]) - omegaRef[i] * sum_k (weight[k])

  // II: equation nbMaxCC to nbGen_ + nbMaxCC :
  // for each generator k, and the connected component i which contains this generator k:
  // 0 = omegaRef[i] - omegaRefGrp[k]
  // the index i is given by numCCNode_[k]

  // equation 0 to nbMaxCC : no differential variable
  for (int i = 0; i < nbMaxCC; ++i)
    jt.changeCol();

  // equation nbMaxCC to nbGen + nbMaxCC : no differential variable
  for (int i = 0; i < nbGen_; ++i)
    jt.changeCol();
}

void
ModelOmegaRef::evalZ(const double /*t*/) {
  std::copy(zLocal_, zLocal_ + nbGen_, numCCNode_.begin());
  std::copy(zLocal_ + nbGen_, zLocal_ + sizeZ(), runningGrp_.begin());
}

void
ModelOmegaRef::collectSilentZ(BitMask* silentZTable) {
  for (unsigned k = 0; k < sizeZ_; ++k) {
    silentZTable[k].setFlags(NotUsedInDiscreteEquations);
  }
}

modeChangeType_t
ModelOmegaRef::evalMode(const double /*t*/) {
  // mode change = number of subNetwork change or grp status change
  if (numCCNodeOld_.size() == 0) {
    numCCNodeOld_.assign(numCCNode_.begin(), numCCNode_.end());
    sortGenByCC();
  } else if (runningGrpOld_.size() == 0) {
    runningGrpOld_.assign(runningGrp_.begin(), runningGrp_.end());
    sortGenByCC();
  } else if (!std::equal(numCCNode_.begin(), numCCNode_.end(), numCCNodeOld_.begin())) {
    numCCNodeOld_.assign(numCCNode_.begin(), numCCNode_.end());
    sortGenByCC();
    return ALGEBRAIC_J_UPDATE_MODE;
  } else if (!std::equal(runningGrp_.begin(), runningGrp_.end(), runningGrpOld_.begin())) {
    runningGrpOld_.assign(runningGrp_.begin(), runningGrp_.end());
    sortGenByCC();
    return ALGEBRAIC_J_UPDATE_MODE;
  }
  return NO_MODE;
}

/**
 * @brief Sort every generator by num of subNetwork
 *
 *
 */
void
ModelOmegaRef::sortGenByCC() {
  genByCC_.clear();
  sumWeightByCC_.clear();

  for (int i = 0; i < nbGen_; ++i) {
    if (toNativeBool(runningGrp_[i])) {
      genByCC_[numCCNode_[i]].push_back(i);
      if (weights_[i] > 0)
        sumWeightByCC_[numCCNode_[i]] += weights_[i];
    }
  }
  nbCC_ = static_cast<int>(genByCC_.size());
  if (nbCC_ > nbMaxCC)
    throw DYNError(Error::MODELER, TooMuchSubNetwork, nbCC_, nbMaxCC);
}

void
ModelOmegaRef::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // output depends only on discrete variables
}

void
ModelOmegaRef::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // output depends only on discrete variables
}

double
ModelOmegaRef::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return 0;
}

void
ModelOmegaRef::evalCalculatedVars() {
  // not needed
}

void
ModelOmegaRef::getY0() {
  sortGenByCC();  // need to sort generator by subnetwork

  // OmegaRef by cc (I)
  for (int i = 0; i < nbMaxCC; ++i) {
    yLocal_[i] = omegaRef0_[i];
    ypLocal_[i] = 0.;
  }

  // External variables (omega by generator)
  for (int i = 0; i < nbGen_; ++i) {
    if (weights_[i] > 0) {
      yLocal_[i + nbMaxCC] = 1.;
      ypLocal_[i + nbMaxCC] = 0.;
    }
  }

  // OmegaRef for each generator (II)
  for (int i = 0; i < nbGen_; ++i) {
    yLocal_[i + nbMaxCC + nbOmega_] = omegaRef0_[numCCNode_[i]];
    ypLocal_[i + nbMaxCC + nbOmega_] = 0.;
  }

  // External variables
  std::copy(zLocal_, zLocal_ + nbGen_, numCCNode_.begin());
  std::copy(zLocal_ + nbGen_, zLocal_ + sizeZ(), runningGrp_.begin());
}

void
ModelOmegaRef::evalStaticYType() {
  std::fill(yType_, yType_ + nbMaxCC, ALGEBRAIC);  // omegaRef[i] is an algebraic variable
  std::fill(yType_+ nbMaxCC, yType_ + nbMaxCC + nbOmega_, EXTERNAL);  // omega[i] is an external variable
  std::fill(yType_ + nbMaxCC + nbOmega_, yType_ + sizeY_, ALGEBRAIC);  // omegaRefGrp[i] is an algebraic variable
}

void
ModelOmegaRef::evalStaticFType() {
  //  equation 0 to nbMaxCC
  // ----------------------
  std::fill(fType_, fType_ + nbMaxCC, ALGEBRAIC_EQ);  // no differential variable

  // equation nbMaxCC to nbGen_ + nbMaxCC =  omegaRef - omegaRefGrp[i]
  // -------------------------------------------------------------------
  std::fill(fType_ + nbMaxCC, fType_ + nbMaxCC + nbGen_, ALGEBRAIC_EQ);  // no differential variable

  return;
}

/**
 * @brief initialize variables of the model
 *
 * A variable is a structure which contains all information needed to interact with the model
 */
void
ModelOmegaRef::defineVariables(vector<shared_ptr<Variable> >& variables) {
  stringstream name;
  for (int i = 0; i < nbMaxCC; ++i) {
    name.str("");
    name.clear();
    name << "omegaRef_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  for (int k = 0; k < nbGen_; ++k) {
    if (weights_[k] > 0) {
      name.str("");
      name.clear();
      name << "omega_grp_" << k << "_value";
      variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
    }
  }
  for (int k = 0; k < nbGen_; ++k) {
    name.str("");
    name.clear();
    name << "omegaRef_grp_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  for (int k = 0; k < nbGen_; ++k) {
    name.str("");
    name.clear();
    name << "numcc_node_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));
  }

  for (int k = 0; k < nbGen_; ++k) {
    name.str("");
    name.clear();
    name << "running_grp_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), BOOLEAN));
  }
}

void
ModelOmegaRef::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbGen", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("weight_gen", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGen"));
  parameters.push_back(ParameterModeler("omegaRefMin", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("omegaRefMax", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

void
ModelOmegaRef::setSubModelParameters() {
  nbGen_ = findParameterDynamic("nbGen").getValue<int>();
  stringstream weightName;
  for (int k = 0; k < nbGen_; ++k) {
    weightName.str("");
    weightName.clear();
    weightName << "weight_gen_" << k;
    weights_.push_back(findParameterDynamic(weightName.str()).getValue<double>());
  }

  nbOmega_ = 0;
  indexOmega_.clear();
  for (int k = 0; k < nbGen_; ++k) {
    if (weights_[k] > 0) {
      indexOmega_.push_back(nbOmega_);
      ++nbOmega_;
    } else {
      indexOmega_.push_back(-1);
    }
  }

  omegaRef0_.assign(nbMaxCC, 1.);

  // Get omegaRefMin and omegaRefMax parameters from the par file if they exist
  const bool isInitParam = false;
  const ParameterModeler& parameter = findParameter("omegaRefMin", isInitParam);
  if (parameter.hasValue()) {
    omegaRefMin_ = parameter.getDoubleValue();
  }
  const ParameterModeler& parameter2 = findParameter("omegaRefMax", isInitParam);
  if (parameter2.hasValue()) {
    omegaRefMax_ = parameter2.getDoubleValue();
  }
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
ModelOmegaRef::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  stringstream namess;
  for (int i = 0; i < nbMaxCC; ++i) {
    namess.str("");
    namess.clear();
    namess << "omegaRef_" << i;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }

  for (int k = 0; k < nbGen_; ++k) {
    if (weights_[k] > 0) {
      namess.str("");
      namess.clear();
      namess << "omega_grp_" << k;
      addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
    }

    namess.str("");
    namess.clear();
    namess << "numcc_node_" << k;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    namess.str("");
    namess.clear();
    namess << "running_grp_" << k;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    namess.str("");
    namess.clear();
    namess << "omegaRef_grp_" << k;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}

void
ModelOmegaRef::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << "omegaRef_" << "<0-" << nbMaxCC << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "omega_grp_" << "<0-" << nbGen_ << ">_value (and weight_gen_<num> > 0)" << Trace::endline;
  Trace::info() << "  ->" << "numcc_node_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "running_grp_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "omegaRef_grp_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
}

void
ModelOmegaRef::setFequations() {
  stringstream f;
  for (int i = 0; i < nbMaxCC; ++i) {
    f.str("");
    f.clear();
    f << "Synchronous area " << i << " : 0 = sum_k (omega[k] * weight[k]) - omegaRef[i] * sum_k (weight[k])";
    fEquationIndex_[i] =  f.str();
  }

  for (int k = 0; k < nbGen_; ++k) {
    f.str("");
    f.clear();
    f << "Generator " << k << " : 0 = omegaRef[CC] - omegaRefGrp[k]";
    fEquationIndex_[k + nbMaxCC] = f.str();
  }

  assert(fEquationIndex_.size() == static_cast<size_t>(sizeF()) && "ModelOmegaRef:fEquationIndex_.size() != f_.size()");
}

void
ModelOmegaRef::checkDataCoherence(const double /*t*/) {
  for (int i = 0; i < nbMaxCC; ++i) {
    if (doubleEquals(yLocal_[i], omegaRef0_[i]))
      continue;
    if (yLocal_[i] < omegaRefMin_ && doubleNotEquals(yLocal_[i], omegaRefMin_))
      throw DYNError(Error::MODELER, FrequencyCollapse, yLocal_[i] * FNOM, omegaRefMin_ * FNOM);
    else if (yLocal_[i] > omegaRefMax_ && doubleNotEquals(yLocal_[i], omegaRefMax_))
      throw DYNError(Error::MODELER, FrequencyIncrease, yLocal_[i] * FNOM, omegaRefMax_ * FNOM);
  }
}

}  // namespace DYN
