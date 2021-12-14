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
// #include "DYNElement.h"
// #include "DYNCommonModeler.h"
// #include "DYNTrace.h"
// #include "DYNVariableForModel.h"
// #include "DYNParameter.h"

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
 * @brief Reference frequency model default constructor
 *
 *
 */
ModelMinMaxMean::ModelMinMaxMean() :
ModelCPP("minMaxMean"),
voltageInputs_(),
isActive_(),
minVal_(0),
maxVal_(0),
avgVal_(0),
idxMin_(-1),
idxMax_(-1),
nbCurActiveInputs_(0),
isInitialized_(false) {
}

/**
 * @brief MinMaxMean model initialization
 *
 */
void
ModelMinMaxMean::init(const double /*t0*/) {
  /*
  numCCNode_.assign(nbGen_, 0);
  runningGrp_.assign(nbGen_, 0);
  nbCC_ = 0;

  ModelMinMaxMean::col1stOmegaRef_ = 0;
  ModelMinMaxMean::col1stOmega_ = ModelMinMaxMean::col1stOmegaRef_ + nbMaxCC;
  col1stOmegaRefGrp_ = ModelMinMaxMean::col1stOmega_ + nbOmega_;
  */
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
  /*
  sizeF_ = nbMaxCC + nbGen_;  // nbMaxCC eq (omegaref) + one equation by generator
  sizeY_ = nbMaxCC + nbGen_ + nbOmega_;  // (omegaref)*nbMaxCC + omegaRef by grp + omega_ for grp with weight > 0
  sizeZ_ = nbGen_ * 2;   // num cc for each connection node of generators + stateOff of each generators
  sizeG_ = 0;
  sizeMode_ = 1;  // change of CC organisation

  calculatedVars_.assign(nbCalculatedVars_, 0);
  */
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
  /*
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
  */
  return NO_MODE;
}

void
ModelMinMaxMean::evalJCalculatedVarI(unsigned /*iCalculatedVar*/, vector<double>& /*res*/) const {
  // output depends only on discrete variables
}

void
ModelMinMaxMean::getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& /*indexes*/) const {
  // output depends only on discrete variables
}

double
ModelMinMaxMean::evalCalculatedVarI(unsigned iCalculatedVar) const {
  double out = 0.0f;
  switch (iCalculatedVar) {
  case minValIdx_:
    out = minVal_;
    break;
  case maxValIdx_:
    out = maxVal_;
    break;
  case avgValIdx_:
    out = avgVal_;
    break;

  default:
    throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);  // Macro defined in DYNMacrosMessage
    break;
  }

  return out;
}

void
ModelMinMaxMean::evalCalculatedVars() {
  calculatedVars_[minValIdx_] = minVal_;
  calculatedVars_[maxValIdx_] = maxVal_;
  calculatedVars_[avgValIdx_] = avgVal_;
}

void
ModelMinMaxMean::getY0() {
  /*
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
  */
}

void
ModelMinMaxMean::evalStaticYType() {
  /*
  std::fill(yType_, yType_ + nbMaxCC, ALGEBRAIC);  // omegaRef[i] is an algebraic variable
  std::fill(yType_+ nbMaxCC, yType_ + nbMaxCC + nbOmega_, EXTERNAL);  // omega[i] is an external variable
  std::fill(yType_ + nbMaxCC + nbOmega_, yType_ + sizeY_, ALGEBRAIC);  // omegaRefGrp[i] is an algebraic variable
  */
}

void
ModelMinMaxMean::evalStaticFType() {
  /*
  //  equation 0 to nbMaxCC
  // ----------------------
  std::fill(fType_, fType_ + nbMaxCC, ALGEBRAIC_EQ);  // no differential variable

  // equation nbMaxCC to nbGen_ + nbMaxCC =  omegaRef - omegaRefGrp[i]
  // -------------------------------------------------------------------
  std::fill(fType_ + nbMaxCC, fType_ + nbMaxCC + nbGen_, ALGEBRAIC_EQ);  // no differential variable

  return;
  */
}

/**
 * @brief initialize variables of the model
 *
 * A variable is a structure which contained all information needed to interact with the model
 */
void
ModelMinMaxMean::defineVariables(vector<shared_ptr<Variable> >& /*variables*/) {
  stringstream name;
  name.str("");
  // Define the min variable

  /*
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
  */
}

void
ModelMinMaxMean::defineParameters(vector<ParameterModeler>& /*parameters*/) {
  // No parameters for this module.
}

void
ModelMinMaxMean::setSubModelParameters() {
  /*
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
  bool success;
  getSubModelParameterValue("omegaRefMin", omegaRefMin_, success);
  getSubModelParameterValue("omegaRefMax", omegaRefMax_, success);
  */
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
ModelMinMaxMean::defineElements(std::vector<Element> &/*elements*/, std::map<std::string, int>& /*mapElement*/) {
  /*
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
  */
}

void
ModelMinMaxMean::dumpUserReadableElementList(const std::string& /*nameElement*/) const {
  /*
  Trace::info() << DYNLog(ElementNames, name(), modelType()) << Trace::endline;
  Trace::info() << "  ->" << "omegaRef_" << "<0-" << nbMaxCC << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "omega_grp_" << "<0-" << nbGen_ << ">_value (and weight_gen_<num> > 0)" << Trace::endline;
  Trace::info() << "  ->" << "numcc_node_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "running_grp_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  Trace::info() << "  ->" << "omegaRef_grp_" << "<0-" << nbGen_ << ">_value" << Trace::endline;
  */
}

void
ModelMinMaxMean::setFequations() {
  // setFequations not needed
}

void
ModelMinMaxMean::checkDataCoherence(const double /*t*/) {
  /*for (int i = 0; i < nbMaxCC; ++i) {
    if (doubleEquals(yLocal_[i], omegaRef0_[i]))
      continue;
    if (yLocal_[i] < omegaRefMin_ && doubleNotEquals(yLocal_[i], omegaRefMin_))
      throw DYNError(Error::MODELER, FrequencyCollapse, yLocal_[i] * FNOM, omegaRefMin_ * FNOM);
    else if (yLocal_[i] > omegaRefMax_ && doubleNotEquals(yLocal_[i], omegaRefMax_))
      throw DYNError(Error::MODELER, FrequencyIncrease, yLocal_[i] * FNOM, omegaRefMax_ * FNOM);
  }
  */
}

void
ModelMinMaxMean::updateAsset(const double &newVal, const int &assetId) {
  if (isActive_[assetId]) {
    // Do the update
    avgVal_ += (newVal - voltageInputs_[assetId])/nbCurActiveInputs_;
    voltageInputs_[assetId] = newVal;
    if (newVal < minVal_) {
      idxMax_ = assetId;
      minVal_ = newVal;
    } else if (newVal > maxVal_) {
      maxVal_ = newVal;
      idxMax_ = assetId;
    }
  } else {
    // Something is odd
  }
}

void
ModelMinMaxMean::enableAsset(const double &newVal, const int &assetId) {
  if (isActive_[assetId]) {
    // Only update the value
    updateAsset(newVal, assetId);
  } else {
    // Need a bit more work
    double tot = avgVal_*nbCurActiveInputs_;
    nbCurActiveInputs_++;
    isActive_[assetId] = true;
    voltageInputs_[assetId] = newVal;
    tot += newVal;
    avgVal_ = tot/nbCurActiveInputs_;
    if (newVal < minVal_) {
      idxMax_ = assetId;
      minVal_ = newVal;
    } else if (newVal > maxVal_) {
      maxVal_ = newVal;
      idxMax_ = assetId;
    }
  }
}

void
ModelMinMaxMean::disableAsset(const int &id) {
    if (isActive_[id]) {
        // The asset was indeed active. Some care should be taken
        avgVal_ = avgVal_*nbCurActiveInputs_ - voltageInputs_[id];
        nbCurActiveInputs_--;
        if (nbCurActiveInputs_ > 0) {
          avgVal_ /= nbCurActiveInputs_;
          isActive_[id] = false;

          // Update min and max values
          if (id == idxMax_) {
            // Need to search for a new max
            maxVal_ = minVal_;
            for (int i=0; i < isActive_.size(); i++) {
              if (isActive_[i]) {
                if (voltageInputs_[i] > maxVal_) {
                  idxMax_ = i;
                  maxVal_ = voltageInputs_[i];
                }
              }
            }
          }
          if (id == idxMin_) {
            // Need to search for a new min
            minVal_ = maxVal_;
            for (int i=0; i < isActive_.size(); i++) {
              if (isActive_[i]) {
                if (voltageInputs_[i] < minVal_) {
                  idxMin_ = i;
                  minVal_ = voltageInputs_[i];
                }
              }
            }
          }
        } else {
          // Nothing to see here!
          minVal_ = 0;
          maxVal_ = 0;
          avgVal_ = 0;
          idxMin_ = -1;
          idxMin_ = -1;
        }

    } else {
        // do nothing
    }
}

}  // namespace DYN
