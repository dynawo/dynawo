//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DYNModelSignalN.cpp
 *
 * @brief SignalN model implementation
 *
 * All generators of the network are connected to this model through their participation in the frequency
 * regulation Alpha, which is a coefficient that can be equal to the nominal active power of the generator,
 * its maximum active power, or its active power set point, through the total participation SignalN, which
 * is calculated in this model and is equal to the sum of the Alpha, and through the signal N, which is common
 * to all the generators in the same "synchronous area" and that changes the active power reference of the
 * generators to balance the generation and the consumption.
 * Moreover, the voltage angle of a chosen bus is fixed here to 0 to balance the number of equations and the number
 * of variables.
 * When using this model, the frequency is not explicitly modeled. As a result, this model cannot be used in the
 * same simulation as the model DYNModelOmegaRef. One has to choose between both depending on the type of the study
 * and the way the frequency is modeled (explicitly for DYNModelOmegaRef, implicitly for DYNModelSignalN).
 *
 */
#include <sstream>
#include <vector>

#include "PARParametersSet.h"

#include "DYNModelSignalN.h"
#include "DYNModelSignalN.hpp"
#include "DYNSparseMatrix.h"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNCommonModeler.h"
#include "DYNVariableForModel.h"

using std::vector;
using std::string;
using std::map;
using std::stringstream;

using boost::shared_ptr;

using parameters::ParametersSet;

extern "C" DLL_PUBLIC DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelSignalNFactory());
}

extern "C" DLL_PUBLIC void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

extern "C" DYN::SubModel* DYN::ModelSignalNFactory::create() const {
  DYN::SubModel* model(new DYN::ModelSignalN());
  return model;
}

extern "C" void DYN::ModelSignalNFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {
const int nbMaxCC = 1;  ///< max number of subnetwork where alphasum is calculated

int ModelSignalN::col1stN_;
int ModelSignalN::col1stNGrp_;
int ModelSignalN::col1stTetaRef_;
int ModelSignalN::col1stAlphaSum_;
int ModelSignalN::col1stAlpha_;
int ModelSignalN::col1stAlphaSumGrp_;

ModelSignalN::ModelSignalN() :
Impl("alphaSum"),
firstState_(true),
nbGen_(0),
nbCC_(0) {
}

void
ModelSignalN::init(const double& /*t0*/) {
  numCCNode_.assign(nbGen_, 0);

  ModelSignalN::col1stN_ = 0;
  ModelSignalN::col1stNGrp_ = ModelSignalN::col1stN_ + nbMaxCC;
  ModelSignalN::col1stTetaRef_ = ModelSignalN::col1stNGrp_ + nbGen_;
  ModelSignalN::col1stAlphaSum_ = 0;
  ModelSignalN::col1stAlpha_ = ModelSignalN::col1stAlphaSum_ + nbMaxCC;
  ModelSignalN::col1stAlphaSumGrp_ = ModelSignalN::col1stAlpha_ + nbGen_;
}

void
ModelSignalN::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

void
ModelSignalN::getSize() {
  sizeF_ = nbMaxCC + nbGen_;
  sizeY_ = nbGen_ + 2 * nbMaxCC;
  sizeZ_ = nbMaxCC + 3 * nbGen_;
  sizeG_ = 0;
  sizeMode_ = 1;  // change of CC organisation

  calculatedVars_.assign(nbCalculatedVars_, 0);
}

void
ModelSignalN::calculateInitialState() {
  sortGenByCC();
}

void
ModelSignalN::evalF(double /*t*/, propertyF_t type) {
  if (type == DIFFERENTIAL_EQ)
    return;
  if (firstState_) {
    calculateInitialState();
    firstState_ = false;
  }

  // for each generator k, and the "synchronous area" i which contains this generator k:
  // 0 = n[i] - nGrp[k]
  // the index i is given by numCCNode_[k]
  for (int k = 0; k < nbGen_; ++k) {
    fLocal_[k] = yLocal_[numCCNode_[k]] - yLocal_[col1stNGrp_ + k];
  }

  // for each "synchronous area" i, tetaRef[i]=0
  for (int i = 0; i < nbMaxCC; ++i) {
    fLocal_[nbGen_ + i] = yLocal_[col1stTetaRef_ + i];
  }
}

void
ModelSignalN::evalG(const double& /*t*/) {
  // No root function for this model
}

void
ModelSignalN::evalJt(const double& /*t*/, const double& /*cj*/, SparseMatrix& jt, const int& rowOffset) {
  static double dMOne = -1.;
  static double dPOne = +1.;

  // for each generator k, and the "synchronous area" i which contains this generator k:
  // 0 = n[i] - nGrp[k]
  // the index i is given by numCCNode_[k]
  for (int i = 0; i < nbGen_; ++i) {
    jt.changeCol();
    jt.addTerm(col1stN_ + numCCNode_[i] + rowOffset, dPOne);
    jt.addTerm(i + col1stNGrp_ + rowOffset, dMOne);
  }

  // for each "synchronous area" i, tetaRef[i]=0
  for (int i = 0; i < nbMaxCC; ++i) {
    jt.changeCol();
    jt.addTerm(i + col1stTetaRef_ + rowOffset, dPOne);
  }
}

void
ModelSignalN::evalJtPrim(const double& /*t*/, const double& /*cj*/, SparseMatrix& jt, const int& /*rowOffset*/) {
  // for each generator k, and the "synchronous area" i which contains this generator k:
  // 0 = n[i] - nGrp[k]
  // the index i is given by numCCNode_[k]
  for (int i = 0; i < nbGen_; ++i) {
    jt.changeCol();
  }

  // for each "synchronous area" i, tetaRef[i]=0
  for (int i = 0; i < nbMaxCC; ++i) {
    jt.changeCol();
  }
}

void
ModelSignalN::evalZ(const double& /*t*/) {
  if (firstState_) {
    calculateInitialState();
    firstState_ = false;
  }
  std::copy(zLocal_ + nbMaxCC + 2 * nbGen_, zLocal_ + nbMaxCC + 3 * nbGen_, numCCNode_.begin());
  sortGenByCC();

  // I: for each "synchronous area" i, for generator k in this cc i:
  // 0 = sum_k (alpha[k]) - alphaSum[i]
  for (int i = 0; i < nbMaxCC; ++i) {
    boost::unordered_map<int, std::vector<int> >::const_iterator iterGen = genByCC_.find(i);
    zLocal_[i] = 0;
    if (iterGen != genByCC_.end()) {
      std::vector<int> numGen = iterGen->second;
      for (unsigned int j = 0; j < numGen.size(); ++j) {
        zLocal_[i] += zLocal_[col1stAlpha_ + numGen[j]];
      }
    }
  }

  // II: equation nbMaxCC to nbGen_+ nbMaxCC :
  // for each generator k, and the "synchronous area" i which contains this generator k:
  // 0 = alphaSum[i] - alphaSumGrp[k]
  // the index i is given by numCCNode_[k]
  for (int k = 0; k < nbGen_; ++k) {
    zLocal_[col1stAlphaSumGrp_ + k] = zLocal_[numCCNode_[k]];
  }
}

void
ModelSignalN::collectSilentZ(BitMask* silentZTable) {
  for (unsigned k = 0; k < sizeZ_; ++k) {
    silentZTable[k].setFlags(NotUsedInDiscreteEquations);
  }
}

modeChangeType_t
ModelSignalN::evalMode(const double& /*t*/) {
  // mode change = number of subNetwork change
  if (numCCNodeOld_.empty()) {
    numCCNodeOld_.assign(numCCNode_.begin(), numCCNode_.end());
    sortGenByCC();
  } else if (!std::equal(numCCNode_.begin(), numCCNode_.end(), numCCNodeOld_.begin())) {
    numCCNodeOld_.assign(numCCNode_.begin(), numCCNode_.end());
    sortGenByCC();
    return ALGEBRAIC_J_UPDATE_MODE;
  } return NO_MODE;
}

void
ModelSignalN::sortGenByCC() {
  genByCC_.clear();

  for (int i = 0; i < nbGen_; ++i) {
    genByCC_[numCCNode_[i]].push_back(i);
  }
  nbCC_ = genByCC_.size();
  if (nbCC_ > nbMaxCC)
    throw DYNError(Error::MODELER, TooMuchSubNetwork, nbCC_, nbMaxCC);
}

void
ModelSignalN::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // output depends only on discrete variables
}

void
ModelSignalN::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // output depends only on discrete variables
}

double
ModelSignalN::evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
  return 0;
}

void
ModelSignalN::evalCalculatedVars() {
  // not needed
}

void
ModelSignalN::getY0() {
  sortGenByCC();  // need to sort generator by subnetwork

  for (int i = 0; i < 2 * nbMaxCC + nbGen_; ++i) {
    yLocal_[i] = 0.;
    ypLocal_[i] = 0.;
  }

  for (int i = 0; i < nbMaxCC; ++i) {
    zLocal_[i] = alphaSum0_[i];
  }

  // External variables
  for (int i = 0; i < nbGen_; ++i) {
    zLocal_[i + nbMaxCC] = 1.;
  }

  //
  for (int i = 0; i < nbGen_; ++i) {
    zLocal_[i + nbMaxCC + nbGen_] = alphaSum0_[numCCNode_[i]];
  }

  // External variables
  std::copy(zLocal_ + nbMaxCC + 2 * nbGen_, zLocal_ + nbMaxCC + 3 * nbGen_, numCCNode_.begin());
}

void
ModelSignalN::evalYType() {
  std::fill(yType_, yType_ + nbMaxCC, ALGEBRAIC);  // n[i] is an algebraic variable
  std::fill(yType_ + nbMaxCC, yType_ + nbMaxCC + nbGen_, ALGEBRAIC);   // nGrp[i] is an algebraic variable
  std::fill(yType_+ nbMaxCC + nbGen_, yType_+ 2 * nbMaxCC + nbGen_, ALGEBRAIC);  // tetaRef[i] is an algebraic variable
}

void
ModelSignalN::evalFType() {
  std::fill(fType_, fType_ + nbMaxCC + nbGen_, ALGEBRAIC_EQ);  // no differential variable
}

void
ModelSignalN::defineVariables(vector<shared_ptr<Variable> >& variables) {
  for (int i = 0; i < nbMaxCC; ++i) {
    std::stringstream name;
    name << "n_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream name;
    name << "n_grp_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  for (int i = 0; i < nbMaxCC; ++i) {
    std::stringstream name;
    name << "tetaRef_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), CONTINUOUS));
  }
  for (int i = 0; i < nbMaxCC; ++i) {
    std::stringstream name;
    name << "alphaSum_" << i << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));
  }
  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream name;
    name << "alpha_grp_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));
  }
  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream name;
    name << "alphaSum_grp_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));
  }
  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream name;
    name << "numcc_node_" << k << "_value";
    variables.push_back(VariableNativeFactory::createState(name.str(), DISCRETE));
  }
}

void
ModelSignalN::defineParameters(vector<ParameterModeler>& parameters) {
  parameters.push_back(ParameterModeler("nbGen", VAR_TYPE_INT, EXTERNAL_PARAMETER));
}

void
ModelSignalN::setSubModelParameters() {
  nbGen_ = findParameterDynamic("nbGen").getValue<int>();
  alphaSum0_.assign(nbMaxCC, 0.);
}

void
ModelSignalN::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) {
  for (int i = 0; i < nbMaxCC; ++i) {
    std::stringstream namess;
    namess << "alphaSum_" << i;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    std::stringstream name1;
    name1 << "n_" << i;
    addElement(name1.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name1.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    std::stringstream name2;
    name2 << "tetaRef_" << i;
    addElement(name2.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name2.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }

  for (int k = 0; k < nbGen_; ++k) {
    std::stringstream namess;
    namess << "alpha_grp_" << k;
    addElement(namess.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", namess.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    std::stringstream name1;
    name1 << "numcc_node_" << k;
    addElement(name1.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name1.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    std::stringstream name2;
    name2 << "alphaSum_grp_" << k;
    addElement(name2.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name2.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);

    std::stringstream name3;
    name3 << "n_grp_" << k;
    addElement(name3.str(), Element::STRUCTURE, elements, mapElement);
    addSubElement("value", name3.str(), Element::TERMINAL, name(), modelType(), elements, mapElement);
  }
}

void
ModelSignalN::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  TRACE(info) << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  TRACE(info) << "  ->" << "alphaSum_" << "<0-" << nbMaxCC << ">_value" << Trace::endline;
  TRACE(info) << "  ->" << "n_" << "<0-" << nbMaxCC << ">_value" << Trace::endline;
  TRACE(info) << "  ->" << "tetaRef_" << "<0-" << nbMaxCC << ">_value" << Trace::endline;
  TRACE(info) << "  ->" << "alpha_grp_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  TRACE(info) << "  ->" << "numcc_node_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  TRACE(info) << "  ->" << "alphaSum_grp_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  TRACE(info) << "  ->" << "n_grp_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
}

void ModelSignalN::setFequations() {
  for (int i = 0; i < nbMaxCC; ++i) {
    fEquationIndex_[i] = "0=tetaRef[i]";
  }
  for (int k = 0; k < nbGen_; ++k) {
    fEquationIndex_[nbMaxCC + k] = "nGrp[k]=n[k]";
  }
}

}  // namespace DYN
