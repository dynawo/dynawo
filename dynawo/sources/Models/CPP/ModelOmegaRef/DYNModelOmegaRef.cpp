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
 * All generators of the newtork are connected to this model
 * but only the generators with a weight gen > 0 participate to the calcul of the frequency reference
 *
 */
#include <sstream>
#include <vector>
#include <algorithm>

#include "PARParametersSet.h"

#include "DYNModelOmegaRef.h"
#include "DYNModelOmegaRef.hpp"
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
Impl("omegaRef"),
firstState_(true),
nbGen_(0),
nbCC_(0),
nbOmega_(0) {
}

/**
 * @brief Reference frequency model initialization
 *
 */
void
ModelOmegaRef::init(const double& /*t0*/) {
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

/**
 * @brief Reference frequency G(t,y,y') function evaluation
 *
 * Get the root's value
 *
 * @param t Simulation instant
 */
void
ModelOmegaRef::evalG(const double& /*t*/) {
  // No root fucntion for this model
}

/**
 * @brief Reference frequency transposed jacobian evaluation
 *
 * Get the sparse transposed jacobian \f$ Jt=@F/@y + cj*@F/@y' \f$
 *
 * @param t Simulation instant
 * @param cj Jacobian prime coefficient
 * @param jt
 * @param rowOffset
 */
void
ModelOmegaRef::evalJt(const double& /*t*/, const double& /*cj*/, SparseMatrix& jt, const int& rowOffset) {
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

/**
 * @brief  Reference frequency transposed jacobian evaluation
 *
 * Get the sparse transposed jacobian \f$ Jt=@F/@y' \f$
 *
 * @param t Simulation instant
 * @param cj Jacobian prime coefficient
 * @param jt
 * @param rowOffset
 */
void
ModelOmegaRef::evalJtPrim(const double& /*t*/, const double& /*cj*/, SparseMatrix& jt, const int& /*rowOffset*/) {
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

/**
 * @brief Reference frequency discrete variables evaluation
 *
 * Get the discrete variables' value depending on current simulation instant and
 * current state variables values.
 *
 * @param t Simulation instant
 */
void
ModelOmegaRef::evalZ(const double& /*t*/) {
  std::copy(zLocal_, zLocal_ + nbGen_, numCCNode_.begin());
  std::copy(zLocal_ + nbGen_, zLocal_ + sizeZ(), runningGrp_.begin());
}

void
ModelOmegaRef::collectSilentZ(bool* silentZTable) {
  std::fill_n(silentZTable, sizeZ_, true);
}

/**
 * @brief Reference frequency modes' evaluation
 *
 * Set the modes' value depending on current simulation instant and
 * current state variables values. For this model, the mode changes when the number
 * of subNetwork changes
 *
 * @param t Simulation instant
 */
modeChangeType_t
ModelOmegaRef::evalMode(const double& /*t*/) {
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
  nbCC_ = genByCC_.size();
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
ModelOmegaRef::evalYType() {
  std::fill(yType_, yType_ + nbMaxCC, ALGEBRAIC);  // omegaRef[i] is an algebraic variable
  std::fill(yType_+ nbMaxCC, yType_ + nbMaxCC + nbOmega_, EXTERNAL);  // omega[i] is an external variable
  std::fill(yType_ + nbMaxCC + nbOmega_, yType_ + sizeY_, ALGEBRAIC);  // omegaRefGrp[i] is an algebraic variable
}

void
ModelOmegaRef::evalFType() {
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
 * A variable is a structure which contained all information needed to interact with the model
 */
void
ModelOmegaRef::defineVariables(vector<shared_ptr<Variable> >& variables) {
  for (int i = 0; i < nbMaxCC; ++i) {
    std::stringstream name;
    name << "omegaRef_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  for (int k = 0; k < nbGen_; ++k) {
    if (weights_[k] > 0) {
      std::stringstream name;
      name << "omega_grp_" << k << "_value";
      variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
    }
  }
  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream name;
    name << "omegaRef_grp_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream name;
    name << "numcc_node_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));
  }

  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream name;
    name << "running_grp_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), BOOLEAN));
  }
}

void
ModelOmegaRef::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbGen", VAR_TYPE_INT, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("weight_gen", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER, "*", "nbGen"));
}

void
ModelOmegaRef::setSubModelParameters() {
  nbGen_ = findParameterDynamic("nbGen").getValue<int>();
  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream weightName;
    weightName << "weight_gen_" << k;
    weights_.push_back(findParameterDynamic(weightName.str()).getValue<double>());
  }

  nbOmega_ = 0;
  indexOmega_.clear();
  for (int k = 0; k < nbGen_; ++k) {
    if (weights_[k] > 0) {
      ++nbOmega_;
      indexOmega_.push_back(k);
    } else {
      indexOmega_.push_back(-1);
    }
  }

  omegaRef0_.assign(nbMaxCC, 1.);
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
  for (int i = 0; i < nbMaxCC; ++i) {
    std::stringstream name;
    name << "omegaRef_" << i;
    addElement(name.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name.str(), Element::TERMINAL, elements, mapElement);
  }

  for (int k = 0; k < nbGen_; ++k) {
    if (weights_[k] > 0) {
      std::stringstream name;
      name << "omega_grp_" << k;
      addElement(name.str(), Element::STRUCTURE, elements, mapElement);
      addSubElement("value", name.str(), Element::TERMINAL, elements, mapElement);
    }

    std::stringstream name1;
    name1 << "numcc_node_" << k;
    addElement(name1.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name1.str(), Element::TERMINAL, elements, mapElement);

    std::stringstream name2;
    name2 << "running_grp_" << k;
    addElement(name2.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name2.str(), Element::TERMINAL, elements, mapElement);

    std::stringstream name3;
    name3 << "omegaRef_grp_" << k;
    addElement(name3.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name3.str(), Element::TERMINAL, elements, mapElement);
  }
}

void
ModelOmegaRef::setFequations() {
  for (int i = 0; i < nbMaxCC; ++i) {
    std::stringstream f;
    f << "Synchronous area " << i << " : 0 = sum_k (omega[k] * weight[k]) - omegaRef[i] * sum_k (weight[k])";
    fEquationIndex_[i] =  f.str();
  }

  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream f;
    f << "Generator " << k << " : 0 = omegaRef[CC] - omegaRefGrp[k]";
    fEquationIndex_[k + nbMaxCC] = f.str();
  }

  assert(fEquationIndex_.size() == (unsigned int) sizeF() && "ModelOmegaRef:fEquationIndex_.size() != f_.size()");
}

}  // namespace DYN
