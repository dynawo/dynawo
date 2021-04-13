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
 * @file  DYNModelMulti.cpp
 *
 * @brief managing models with multiple sub-models
 *
 */
#include <cmath>
#include <vector>
#include <string>
#include <map>
#include <fstream>
#include <algorithm>
#include <iomanip>

#include <eigen3/Eigen/Sparse>

#include "TLTimeline.h"
#include "CRVCurve.h"
#include "CRVCurvesCollection.h"
#include "CSTRConstraintsCollection.h"

#include "FSModel.h"
#include "FSVariable.h"
#include "FSIterators.h"

#include "DYNMacrosMessage.h"
#include "DYNSparseMatrix.h"
#include "DYNModelMulti.h"
#include "DYNSubModel.h"
#include "DYNConnector.h"
#include "DYNTrace.h"
#include "DYNElement.h"
#include "DYNTimer.h"
#include "DYNConnectorCalculatedVariable.h"
#include "DYNCommon.h"
#include "DYNVariableAlias.h"

#include "DYNModalAnalysis.h"
#include "DYNCommonModalAnalysis.h"

using std::min;
using std::min;
using std::max;
using std::vector;
using std::set;
using std::string;
using std::stringstream;
using std::map;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;
using timeline::Timeline;
using curves::Curve;
using finalState::finalStateModel_iterator;
using finalState::finalStateVariable_iterator;
using constraints::ConstraintsCollection;
using std::fstream;


namespace DYN {

ModelMulti::ModelMulti() :
fType_(NULL),
yType_(NULL),
sizeF_(0),
sizeZ_(0),
sizeG_(0),
sizeMode_(0),
sizeY_(0),
silentZChange_(NO_Z_CHANGE),
modeChange_(false),
modeChangeType_(NO_MODE),
offsetFOptional_(0),
fLocal_(NULL),
gLocal_(NULL),
yLocal_(NULL),
ypLocal_(NULL),
zLocal_(NULL),
zConnectedLocal_(NULL),
silentZ_(NULL),
enableSilentZ_(true) {
  connectorContainer_.reset(new ConnectorContainer());
}

void
ModelMulti::cleanBuffers() {
  sizeF_ = 0;
  sizeY_ = 0;
  sizeZ_ = 0;
  sizeG_ = 0;
  sizeMode_ = 0;

  if (fLocal_ != NULL)
    delete[] fLocal_;

  if (yLocal_ != NULL)
    delete[] yLocal_;

  if (ypLocal_ != NULL)
    delete[] ypLocal_;

  if (gLocal_ != NULL)
    delete[] gLocal_;

  if (zLocal_ != NULL)
    delete[] zLocal_;

  if (zConnectedLocal_ != NULL)
    delete[] zConnectedLocal_;

  if (silentZ_ != NULL)
    delete[] silentZ_;

  if (fType_ != NULL)
    delete[] fType_;

  if (yType_ != NULL)
    delete[] yType_;
}

ModelMulti::~ModelMulti() {
  cleanBuffers();
}

void
ModelMulti::setTimeline(const shared_ptr<Timeline>& timeline) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setTimeline(timeline);
}

void
ModelMulti::setConstraints(const shared_ptr<ConstraintsCollection>& constraints) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setConstraints(constraints);
}

void
ModelMulti::setWorkingDirectory(const string& workingDirectory) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setWorkingDirectory(workingDirectory);
}

void
ModelMulti::addSubModel(shared_ptr<SubModel>& sub, const string& libName) {
  sub->defineVariablesInit();
  sub->defineParametersInit();  // only for modelica models
  sub->defineNamesInit();
  sub->setSharedParametersDefaultValuesInit();

  sub->defineParameters();
  sub->setSharedParametersDefaultValues();
  sub->setParametersFromPARFile();
  sub->setSubModelParameters();

  sub->initStaticData();

  sub->defineVariables();
  sub->defineNames();
  sub->defineElements();

  if (libName != "") {
    subModelByLib_[libName].push_back(sub);
  }
  subModels_.push_back(sub);
}

void
ModelMulti::initBuffers() {
  // (1) Get size of each sub models
  // -------------------------------
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->initSize(sizeY_, sizeZ_, sizeMode_, sizeF_, sizeG_);


  connectorContainer_->setOffsetModel(sizeF_);
  connectorContainer_->setSizeY(sizeY_);
  connectorContainer_->mergeConnectors();
  evalStaticYType();

  numVarsOptional_.clear();
  for (int i = 0; i < sizeY_; ++i) {
    if (yType_[i] == OPTIONAL_EXTERNAL) {
      const bool isConnected = connectorContainer_->isConnected(i);
      if (!isConnected) {
        numVarsOptional_.insert(i);
      }
    }
  }

  sizeF_ += connectorContainer_->nbContinuousConnectors();

  offsetFOptional_ = sizeF_;
  sizeF_ += numVarsOptional_.size();  /// fictitious equation will be added for unconnected optional external variables
  evalStaticFType();

  // (2) Initialize buffers that would be used during the simulation (avoid copy)
  // ----------------------------------------------------------------------------
  fLocal_ = new double[sizeF_]();
  gLocal_ = new state_g[sizeG_]();
  yLocal_ = new double[sizeY_]();
  ypLocal_ = new double[sizeY_]();
  zLocal_ = new double[sizeZ_]();
  zConnectedLocal_ = new bool[sizeZ_];
  silentZ_ = new BitMask[sizeZ_];
  std::fill_n(zConnectedLocal_, sizeZ_, false);
  for (int i = 0; i < sizeZ_; ++i) {
    silentZ_[i].setFlags(NotSilent);
  }

  int offsetF = 0;
  int offsetG = 0;
  int offsetY = 0;
  int offsetZ = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeY = subModels_[i]->sizeY();
    if (sizeY > 0)
      subModels_[i]->setBufferY(yLocal_, ypLocal_, offsetY);
    offsetY += sizeY;

    int sizeF = subModels_[i]->sizeF();
    if (sizeF > 0) {
      subModels_[i]->setBufferF(fLocal_, offsetF);
      for (int j = offsetF; j < offsetF + sizeF; ++j)
        mapAssociationF_[j] = i;

      offsetF += sizeF;
    }

    int sizeG = subModels_[i]->sizeG();
    if (sizeG > 0) {
      subModels_[i]->setBufferG(gLocal_, offsetG);
      for (int j = offsetG; j < offsetG + sizeG; ++j)
        mapAssociationG_[j] = i;

      offsetG += sizeG;
    }

    int sizeZ = subModels_[i]->sizeZ();
    if (sizeZ > 0)
      subModels_[i]->setBufferZ(zLocal_, zConnectedLocal_, offsetZ);
    offsetZ += sizeZ;
  }
  connectorContainer_->setBufferF(fLocal_, offsetF);
  connectorContainer_->setBufferY(yLocal_, ypLocal_);  // connectors access to the whole y Buffer
  connectorContainer_->setBufferZ(zLocal_, zConnectedLocal_);  // connectors access to the whole z buffer
  std::fill(fLocal_ + offsetFOptional_, fLocal_ + sizeF_, 0);

  // (3) init buffers of each sub-model (useful for the network model)
  // (4) release elements that were used and declared only for connections
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->initSubBuffers();
    subModels_[i]->releaseElements();
  }
}

void
ModelMulti::init(const double t0) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer1("ModelMulti::init");
#endif

  zSave_.assign(zLocal_, zLocal_ + sizeZ());

  // (1) initialising each sub-model
  //----------------------------------------
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->initSub(t0);

  // Detect if some discrete variable were modified during the initialization (e.g. subnetwork detection)
  vector<int> indicesDiff;
  vector<int> valuesModified;
  for (int i = 0; i < sizeZ(); ++i) {
    if (doubleNotEquals(zLocal_[i], zSave_[i])) {
      indicesDiff.push_back(i);
      valuesModified.push_back(zLocal_[i]);
    }
  }

  // (2) initialising init values
  //-------------------------------
  vector<double> y0(sizeY(), 0.);
  vector<double> yp0(sizeY(), 0.);
  getY0(t0, y0, yp0);

  // Propagate the potential modifications of discrete variables. Needed here as otherwise
  // the next evalZ will not detect the modifications.
  if (!indicesDiff.empty()) {
    for (size_t i = 0; i < indicesDiff.size(); ++i) {
      zLocal_[indicesDiff[i]] = valuesModified[i];
    }

    connectorContainer_->propagateZDiff(indicesDiff, zLocal_);

    zSave_.assign(zLocal_, zLocal_ + sizeZ());
    rotateBuffers();

    for (unsigned int i = 0; i < subModels_.size(); ++i)
      subModels_[i]->evalZSub(t0);

    for (unsigned j = 0; j < 10 && propagateZModif(); ++j) {
      for (unsigned int i = 0; i < subModels_.size(); ++i)
        subModels_[i]->evalGSub(t0);
      for (unsigned int i = 0; i < subModels_.size(); ++i)
        subModels_[i]->evalZSub(t0);
    }
    rotateBuffers();
  }
}

void
ModelMulti::printModel() const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::printModel");
#endif
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->printModel();

  connectorContainer_->printConnectors();
}

void
ModelMulti::printParameterValues() const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::printParameterValues");
#endif
  Trace::debug(Trace::parameters()) << "This file is organized as follows: "<< Trace::endline <<
      "  -- For each model, initial and dynamic models parameters values before local initialization"<< Trace::endline <<
      "  -- For each model, dynamic models parameters values after local initialization"<< Trace::endline <<
      "caption: "<< Trace::endline <<
      "  -- \"modelica file\"  -> default value specified in modelica model"<< Trace::endline <<
      "  -- \"parameters\"     -> value read from parameter file"<< Trace::endline <<
      "  -- \"IIDM\"           -> value read from iidm file"<< Trace::endline <<
      "  -- \"loaded dump\"    -> value read from initial state file"<< Trace::endline <<
      "  -- \"initialization\" -> value computed by local initialization"<< Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->printParameterValues();
}

void
ModelMulti::rotateBuffers() {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->rotateBuffers();
}

void
ModelMulti::printMessages() {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->printMessages();
}

void
ModelMulti::printInitValues(const string& directory) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->printInitValues(directory);
}

void
ModelMulti::copyContinuousVariables(double* y, double* yp) {
  std::copy(y, y + sizeY() , yLocal_);
  std::copy(yp, yp + sizeY(), ypLocal_);
}

void
ModelMulti::copyDiscreteVariables(double* z) {
  std::copy(z, z + sizeZ(), zLocal_);
}

void
ModelMulti::evalF(const double t, double* y, double* yp, double* f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalF");
#endif
  copyContinuousVariables(y, yp);

#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer * timer2 = new Timer("ModelMulti::evalF_subModels");
#endif
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    if (subModels_[i]->sizeF() != 0)
      subModels_[i]->evalFSub(t);
  }
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  delete timer2;
#endif

  connectorContainer_->evalFConnector(t);

  std::copy(fLocal_, fLocal_ + sizeF_, f);
}

void
ModelMulti::evalFDiff(const double t, double* y, double* yp, double* f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalFDiff");
#endif
  copyContinuousVariables(y, yp);

  for (unsigned int i = 0; i < subModels_.size(); ++i) {
      subModels_[i]->evalFDiffSub(t);
  }
  std::copy(fLocal_, fLocal_ + sizeF_, f);
}

void
ModelMulti::evalFMode(const double t, double* y, double* yp, double* f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalFMode");
#endif
  copyContinuousVariables(y, yp);

  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    if (subModels_[i]->modeChange()) {
      subModels_[i]->evalFSub(t);
      boost::unordered_map<size_t, std::vector<size_t > >::const_iterator it = subModelIdxToConnectorCalcVarsIdx_.find(i);
      if (it != subModelIdxToConnectorCalcVarsIdx_.end()) {
        const std::vector<size_t >& connectorsIdx = it->second;
        for (size_t j = 0, jEnd = connectorsIdx.size(); j < jEnd; ++j) {
          subModels_[connectorsIdx[j]]->evalFSub(t);
        }
      }
    }
  }

  connectorContainer_->evalFConnector(t);

  std::copy(fLocal_, fLocal_ + sizeF_, f);
}

void
ModelMulti::evalG(double t, vector<state_g>& g) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalG");
#endif
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->evalGSub(t);

  std::copy(gLocal_, gLocal_ + sizeG_, g.begin());
}

void
ModelMulti::evalJt(const double t, const double cj, SparseMatrix& Jt) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalJt");
#endif
  int rowOffset = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->evalJtSub(t, cj, Jt, rowOffset);
    if (!Jt.withoutNan() || !Jt.withoutInf()) {
      throw DYNError(Error::MODELER, SparseMatrixWithNanInf, subModels_[i]->modelType(), subModels_[i]->name());
    }
  }

  connectorContainer_->evalJtConnector(Jt);

  // add Jacobian for optional variables X = 0
  for (set<int>::const_iterator it = numVarsOptional_.begin();
       it != numVarsOptional_.end(); ++it) {
    Jt.changeCol();
    Jt.addTerm(*it, +1);  // d(f)/d(Y) = +1;
  }
}

void
ModelMulti::evalJtPrim(const double t, const double cj, SparseMatrix& JtPrim) {
  int rowOffset = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->evalJtPrimSub(t, cj, JtPrim, rowOffset);
    if (!JtPrim.withoutNan() || !JtPrim.withoutInf()) {
      throw DYNError(Error::MODELER, SparseMatrixWithNanInf, subModels_[i]->modelType(), subModels_[i]->name());
    }
  }

  connectorContainer_->evalJtPrimConnector(JtPrim);

  for (unsigned int i =0; i < numVarsOptional_.size(); ++i)
    JtPrim.changeCol();
}

void
ModelMulti::evalZ(double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalZ");
#endif
  if (sizeZ() == 0) return;
  // calculate Z by model
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->evalZSub(t);

  // propagation of z changes to connected variables
  if (zSave_.size() != static_cast<size_t>(sizeZ()))
    zSave_.assign(sizeZ(), 0.);

  silentZChange_ = propagateZModif();
}

zChangeType_t
ModelMulti::propagateZModif() {
  vector<int> indicesDiff;
  zChangeType_t zChangeType = NO_Z_CHANGE;
  for (int i = 0, iEnd = nonSilentZIndexes_.size(); i < iEnd; ++i) {
    if (doubleNotEquals(zLocal_[nonSilentZIndexes_[i]], zSave_[nonSilentZIndexes_[i]])) {
      indicesDiff.push_back(nonSilentZIndexes_[i]);
      zChangeType = NOT_SILENT_Z_CHANGE;
    }
  }
  // test values of discrete variables that are not used to compute continuous equations
  // and raise the flag NotUsedInContinuousEquations if at least one has changed
  // If at least one non silent Z has changed then the flag is never raised
  for (int i = 0, iEnd = notUsedInContinuousEqSilentZIndexes_.size(); i < iEnd; ++i) {
    if (doubleNotEquals(zLocal_[notUsedInContinuousEqSilentZIndexes_[i]], zSave_[notUsedInContinuousEqSilentZIndexes_[i]])) {
      indicesDiff.push_back(notUsedInContinuousEqSilentZIndexes_[i]);
      if (zChangeType != NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE && zChangeType != NOT_SILENT_Z_CHANGE)
        zChangeType = NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE;
    }
  }
  if (!indicesDiff.empty()) {
    // if at least one discrete variable that is used in discrete equations has changed then we propagate the modification
    connectorContainer_->propagateZDiff(indicesDiff, zLocal_);
    std::copy(zLocal_, zLocal_ + sizeZ(), zSave_.begin());
    return zChangeType;
  } else {
    // if only discrete variables that are used only in continuous equations then we just raise the NotUsedInDiscreteEquations flag
    // no need to propagate
    for (int i = 0, iEnd = notUsedInDiscreteEqSilentZIndexes_.size(); i < iEnd; ++i) {
      if (doubleNotEquals(zLocal_[notUsedInDiscreteEqSilentZIndexes_[i]], zSave_[notUsedInDiscreteEqSilentZIndexes_[i]])) {
        std::copy(zLocal_, zLocal_ + sizeZ(), zSave_.begin());
        return NOT_USED_IN_DISCRETE_EQ_Z_CHANGE;
      }
    }
  }
  return NO_Z_CHANGE;
}

void
ModelMulti::evalMode(double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalMode");
#endif
  /* modeChange_ has to be set at each evalMode call
   *  -> it indicates if there has been a mode change for this call
   * modeChangeType_ is the worst mode change for a complete time step (possibly several evalMode calls)
   *   -> it is reinitialized by the solvers at the end of the time step
  */
#ifdef _DEBUG_
  std::vector<double> z(sizeZ());
  std::copy(zLocal_, zLocal_ + sizeZ(), z.begin());
#endif
  modeChange_ = false;
  modeChangeType_t modeChangeType = NO_MODE;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    modeChangeType_t modeChangeTypeSub = subModels_[i]->evalModeSub(t);
    if (modeChangeTypeSub > modeChangeType)
      modeChangeType = modeChangeTypeSub;
    if (subModels_[i]->modeChange()) {
      modeChange_ = true;
    }
  }
  if (modeChange_) {
    modeChangeType_ = modeChangeType;
    Trace::info() << DYNLog(ModeChangeGeneric, modeChangeType2Str(modeChangeType), t) << Trace::endline;
  }
#ifdef _DEBUG_
  // Make sure evalMode does not modify discrete variables as side effect
  for (unsigned i = 0, iEnd = sizeZ(); i < iEnd; ++i) {
    assert(doubleEquals(z[i], zLocal_[i]));
  }
#endif
}

void
ModelMulti::reinitMode() {
  modeChangeType_ = NO_MODE;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->modeChange(false);
    subModels_[i]->setModeChangeType(NO_MODE);
  }
}

void
ModelMulti::notifyTimeStep() {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->notifyTimeStep();
  }
}

void
ModelMulti::evalCalculatedVariables(const double t, const vector<double>& y, const vector<double>& yp, const vector<double>& z) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalCalculatedVariables");
#endif
  std::copy(y.begin(), y.end(), yLocal_);
  std::copy(yp.begin(), yp.end(), ypLocal_);
  std::copy(z.begin(), z.end(), zLocal_);

  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->evalCalculatedVariablesSub(t);
}

void
ModelMulti::checkParametersCoherence() const {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->checkParametersCoherence();
}

void
ModelMulti::checkDataCoherence(const double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::checkDataCoherence");
#endif

  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->checkDataCoherenceSub(t);
}

void
ModelMulti::setFequationsModel() {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setFequationsSub();
}

void
ModelMulti::setGequationsModel() {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setGequationsSub();
}

void
ModelMulti::getY0(const double t0, vector<double>& y0, vector<double>& yp0) {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->getY0Sub();
    subModels_[i]->evalCalculatedVariablesSub(t0);
  }
  connectorContainer_->getY0Connector();
  if (!subModels_.empty() && subModels_[0]->getIsInitProcess() && enableSilentZ_) {
    collectSilentZ();
  }

  std::copy(yLocal_, yLocal_ + sizeY_, y0.begin());
  std::copy(ypLocal_, ypLocal_ + sizeY_, yp0.begin());
}

void
ModelMulti::evalStaticYType() {
  yType_ = new propertyContinuousVar_t[sizeY_]();
  int offsetYType = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeYType = subModels_[i]->sizeY();
    if (sizeYType > 0) {
      subModels_[i]->setBufferYType(yType_, offsetYType);
      subModels_[i]->evalStaticYType();
      offsetYType += sizeYType;
    }
  }
}

void
ModelMulti::evalDynamicYType() {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeYType = subModels_[i]->sizeY();
    if (sizeYType > 0)
      subModels_[i]->evalDynamicYType();
  }
}

void
ModelMulti::evalStaticFType() {
  fType_ = new propertyF_t[sizeF_]();
  int offsetFType = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeFType = subModels_[i]->sizeF();
    if (sizeFType > 0) {
      subModels_[i]->setBufferFType(fType_, offsetFType);
      subModels_[i]->evalStaticFType();
      offsetFType += sizeFType;
    }
  }
  connectorContainer_->setBufferFType(fType_, offsetFType);
  connectorContainer_->evalStaticFType();
  std::fill(fType_ + offsetFOptional_, fType_ + sizeF_, ALGEBRAIC_EQ);
}

void
ModelMulti::evalDynamicFType() {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeFType = subModels_[i]->sizeF();
    if (sizeFType > 0)
      subModels_[i]->evalDynamicFType();
  }
  // connectors equations (A = B) can't change during the simulation so we don't need to update them.
}

void
ModelMulti::dumpParameters(std::map< string, string >& mapParameters) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->dumpParameters(mapParameters);
}

void
ModelMulti::dumpVariables(std::map< string, string >& mapVariables) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->dumpVariables(mapVariables);
}

void
ModelMulti::getModelParameterValue(const string& curveModelName, const string& curveVariable, double& value, bool& found) {
  shared_ptr<SubModel> subModel = findSubModelByName(curveModelName);
  if (subModel) {
    subModel->getSubModelParameterValue(curveVariable, value, found);
    if (found) {
      return;
    }
  }
  Trace::warn() << DYNLog(ModelMultiParamNotFound, curveModelName, curveVariable) << Trace::endline;
  return;
}

void
ModelMulti::loadParameters(const std::map< string, string >& mapParameters) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->loadParameters(mapParameters);
}

void
ModelMulti::loadVariables(const std::map< string, string >& mapVariables) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->loadVariables(mapVariables);
}

void
ModelMulti::connectElements(const shared_ptr<SubModel>& subModel1, const string& name1, const shared_ptr<SubModel>& subModel2, const string& name2) {
  vector<std::pair<string, string> > variablesToConnect;
  findVariablesConnectedBy(subModel1, name1, subModel2, name2, variablesToConnect);
  for (size_t i = 0, iEnd = variablesToConnect.size(); i < iEnd; ++i) {
    const bool forceConnection = false;
    const bool throwIfCalculatedVarConn = false;
    createConnection(subModel1, variablesToConnect[i].first, subModel2, variablesToConnect[i].second, forceConnection, throwIfCalculatedVarConn);
  }
}


void
ModelMulti::findVariablesConnectedBy(const boost::shared_ptr<SubModel>& subModel1, const std::string& name1,
    const boost::shared_ptr<SubModel>& subModel2, const std::string& name2, vector<std::pair<string, string> >& variables) const {
  vector<Element> elements1 = subModel1->getElements(name1);
  vector<Element> elements2 = subModel2->getElements(name2);

  stringstream msg;
  if (elements1.size() != elements2.size()) {
    msg << DYNLog(IncorrectConnectionDiffSize, subModel1->name(), name1, subModel2->name(), name2, elements1.size(), elements2.size());
    throw DYNError(Error::MODELER, MultiIncorrectConnection, msg.str());
  }

  for (unsigned int i = 0; i < elements1.size(); ++i) {
    Element element = elements1[i];
    string id1 = element.id();
    string nameElt1 = id1.erase(0, name1.size());  // only keep name of sub-structure

    // search for the element in element2 with the same name (id can be different)
    unsigned int j = 0;
    bool connectionOk = false;
    for (; j < elements2.size(); ++j) {
      string id2 = elements2[j].id();
      string nameElt2 = id2.erase(0, name2.size());  // only keep name of sub-structure
      if (nameElt2 == nameElt1) {
        connectionOk = true;
        break;
      }
    }
    if (!connectionOk) {
      msg << DYNLog(ImpossibleConnection, element.id(), name1, subModel2->name(), subModel2->modelType(), name2);
      throw DYNError(Error::MODELER, MultiIncorrectConnection, msg.str());
    }
    variables.push_back(std::make_pair(element.id(), elements2[j].id()));
  }
}

void
ModelMulti::createConnection(const shared_ptr<SubModel>& subModel1, const string& name1, const shared_ptr<SubModel>& subModel2, const string& name2,
                             bool forceConnection, bool throwIfCalculatedVarConn) {
  const shared_ptr<Variable>& variable1 = subModel1->getVariable(name1);
  const shared_ptr<Variable>& variable2 = subModel2->getVariable(name2);

  typeVar_t typeVar1 = variable1->getType();
  // Use local type as the connection was made with the aliased variable that might have a different type from the reference variable
  if (variable1->isAlias())
    typeVar1 = dynamic_pointer_cast<VariableAlias> (variable1)->getLocalType();
  typeVar_t typeVar2 = variable2->getType();
  // Use local type as the connection was made with the aliased variable that might have a different type from the reference variable
  if (variable2->isAlias())
    typeVar2 = dynamic_pointer_cast<VariableAlias> (variable2)->getLocalType();
  bool negated1 = variable1->getNegated();
  bool negated2 = variable2->getNegated();
  bool isState1 = variable1->isState();
  bool isState2 = variable2->isState();

  if (forceConnection) {  // force the connection to YConnector, specific to the computed variable connector model
    typeVar1 = CONTINUOUS;
    typeVar2 = CONTINUOUS;
  }

  // connection to a calculated variable
  // at least one of the connected variables should be a state variable
  // (a calculated variable is a non-state variable)
  if ((!isState1) && (!isState2)) {
    if (throwIfCalculatedVarConn)
      throw DYNError(Error::MODELER, ConnectorCalculatedVariables, subModel1->name(), name1, subModel2->name(), name2);
    else
      Trace::warn() << DYNLog(CalcVarConnectionIgnored, name1, name2) << Trace::endline;
  } else if ((!isState1) && (isState2)) {  // when one variable is a state variable and the other one isn't, use a specific connection
    if (typeVar2 != CONTINUOUS && typeVar2 != FLOW) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }
    createCalculatedVariableConnection(subModel1, variable1, subModel2, variable2);
  } else if ((isState1) && (!isState2)) {
    if (typeVar1 != CONTINUOUS && typeVar1 != FLOW) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }
    createCalculatedVariableConnection(subModel2, variable2, subModel1, variable1);
  } else {  // both variables are state variables
    if (typeVar2 != typeVar1) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }

    boost::shared_ptr<Connector> connector(new Connector());
    connector->addConnectedSubModel(subModel1, variable1, negated1);
    connector->addConnectedSubModel(subModel2, variable2, negated2);
    switch (typeVar1) {
      case FLOW: {
        connectorContainer_->addFlowConnector(connector);
        break;
      }
      case CONTINUOUS: {
        connectorContainer_->addContinuousConnector(connector);
        break;
      }
      case DISCRETE:
      case INTEGER:
      case BOOLEAN: {
        connectorContainer_->addDiscreteConnector(connector);
        break;
      }
      case UNDEFINED_TYPE:
      {
        throw DYNError(Error::MODELER, ModelFuncError, "Unsupported variable type");
      }
    }
  }
}

void
ModelMulti::createCalculatedVariableConnection(const shared_ptr<SubModel>& subModel1, const shared_ptr<Variable>& variable1,
    const shared_ptr<SubModel>& subModel2, const shared_ptr<Variable>& variable2) {
  string calculatedVarName1 = variable1->getName();
  shared_ptr<ConnectorCalculatedVariable> connector;
  string name = subModel1->name()+"_"+calculatedVarName1;
  if (variable1->isAlias())
    name = subModel1->name()+"_"+subModel1->getCalculatedVarName(variable1->getIndex());
  boost::shared_ptr<SubModel> subModelConnector = findSubModelByName(name);
  if (!subModelConnector) {
    // Multiple connection to the same connector can happen with flow connections
    connector = shared_ptr<ConnectorCalculatedVariable>(new ConnectorCalculatedVariable());
    connector->name(name);
    connector->setVariableName(calculatedVarName1);
    connector->setParams(subModel1, variable1->getIndex());
    subModelConnector = dynamic_pointer_cast<SubModel> (connector);
    addSubModel(subModelConnector, "");  // no library for connectors
    subModelIdxToConnectorCalcVarsIdx_[subModelByName_[subModel1->name()]].push_back(subModels_.size() - 1);
  }

  createConnection(subModel2, variable2->getName(), subModelConnector, string("connector_" + name));
}

boost::shared_ptr<SubModel>
ModelMulti::findSubModelByName(const string& name) const {
  boost::unordered_map<string, size_t >::const_iterator iter = subModelByName_.find(name);
  if (iter == subModelByName_.end())
    return (shared_ptr<SubModel>());
  else
    return subModels_[iter->second];
}

vector<boost::shared_ptr<SubModel> >
ModelMulti::findSubModelByLib(const string& libName) {
  boost::unordered_map<string, vector<shared_ptr<SubModel> > >::const_iterator iter = subModelByLib_.find(libName);
  if (iter == subModelByLib_.end())
    return (vector<shared_ptr<SubModel> >());
  else
    return iter->second;
}

bool
ModelMulti::checkConnects() {
  bool connectOk = true;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    shared_ptr<SubModel> sub = subModels_[i];
    vector<string> name = sub->xNames();
    const int yDeb = sub->yDeb();
    for (unsigned int j = 0; j < sub->sizeY(); ++j) {
      if (yType_[yDeb + j] == EXTERNAL) {
        const bool isConnected = connectorContainer_->isConnected(yDeb + j);
        if (!isConnected) {
          Trace::info() << DYNLog(SubModelExtVar, sub->name(), name[j]) << Trace::endline;
          connectOk = false;
          break;
        }
      }
    }
  }
  return (connectOk);
}

void
ModelMulti::getFInfos(const int globalFIndex, string& subModelName, int& localFIndex, string& fEquation) {
  if (globalFIndex >= connectorContainer_->getOffsetModel()) {
    connectorContainer_->getConnectorInfos(globalFIndex, subModelName, localFIndex, fEquation);
  } else {
    boost::unordered_map<int, int>::const_iterator iter = mapAssociationF_.find(globalFIndex);
    if (iter != mapAssociationF_.end()) {
      subModelName = subModels_[iter->second]->name();
      localFIndex = globalFIndex - subModels_[iter->second]->fDeb();
      fEquation = subModels_[iter->second]->getFequationByLocalIndex(localFIndex);
    }
  }
}

void
ModelMulti::getGInfos(const int globalGIndex, string& subModelName, int& localGIndex, string& gEquation) {
  boost::unordered_map<int, int>::const_iterator iter = mapAssociationG_.find(globalGIndex);
  if (iter != mapAssociationG_.end()) {
    subModelName = subModels_[iter->second]->name();
    localGIndex = globalGIndex - subModels_[iter->second]->gDeb();
    gEquation = subModels_[iter->second]->getGequationByLocalIndex(localGIndex);
  }
}

void
ModelMulti::setIsInitProcess(bool isInitProcess) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::setIsInitProcess");
#endif

  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setIsInitProcess(isInitProcess);
}

void
ModelMulti::setInitialTime(const double t0) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setCurrentTime(t0);
}

ModelMulti::findSubModelFromVarName_t
ModelMulti::findSubModel(const string& modelName, const string& variable) const {
  const string variableNameBis = variable + "_value";

  // Search in for the device in Composed Model...
  shared_ptr<SubModel> subModel = findSubModelByName(modelName);
  if (subModel) {   // found model's ID in the composed models.
    const bool isNetwork = false;
    // case 1: curve's variable is a variable in submodel
    if (subModel->hasVariable(variable)) {   // found exact curve name
      return findSubModelFromVarName_t(subModel, isNetwork, false, variable);
    } else if (subModel->hasParameterDynamic(variable)) {   // case 2: curve's variable curve is a parameter in submodel
      return findSubModelFromVarName_t(subModel, isNetwork, true, variable);
    } else {   // BEGIN search :Some names of "variables" type are ended by "_value". This might change in the future, then this block could be neglected.
      if (subModel->hasVariable(variableNameBis)) {   // find variableNameBis = name_value
        return findSubModelFromVarName_t(subModel, isNetwork, false, variableNameBis);
      }
    }  // End search
  } else {   // to be deleted in the future, when Network model becomes a proper modelica model.
    // BEGIN SEARCH IN NETWORK
    // (for the moment, there is no Network model; so we have this temporary search block...
    // in the future when Network becomes a proper modelica model in dyd file like the others, this block could be neglected.)
    shared_ptr<SubModel> modelNetwork = findSubModelByName("NETWORK");
    if (modelNetwork) {
      const bool isNetwork = true;
      string name = modelName + "_" + variable;
      if (modelNetwork->hasVariable(name)) {
        return findSubModelFromVarName_t(modelNetwork, isNetwork, false, name);
      } else {
        string name2 = name + "_value";
        if (modelNetwork->hasVariable(name2)) {   // find name2 = name_value
          return findSubModelFromVarName_t(modelNetwork, isNetwork, false, name2);
        }
      }
    }
  }

  return findSubModelFromVarName_t();
}

void
ModelMulti::collectSilentZ() {
  unsigned offsetZ = 0;
  for (unsigned int i = 0, iEnd = subModels_.size(); i < iEnd; ++i) {
    int sizeZ = subModels_[i]->sizeZ();
    if (sizeZ > 0)
      subModels_[i]->collectSilentZ(&silentZ_[offsetZ]);
    offsetZ += sizeZ;
  }
  // a discrete variable is not silent if it is connected somewhere
  for (int i = 0; i < sizeZ_; ++i) {
    if (zConnectedLocal_[i]) {
      silentZ_[i].reset();
      silentZ_[i].setFlags(NotSilent);
      nonSilentZIndexes_.push_back(i);
      continue;
    }
    if (silentZ_[i].getFlags(NotUsedInDiscreteEquations)) {
      notUsedInDiscreteEqSilentZIndexes_.push_back(i);
    } else if (silentZ_[i].getFlags(NotUsedInContinuousEquations)) {
      notUsedInContinuousEqSilentZIndexes_.push_back(i);
    } else {
      nonSilentZIndexes_.push_back(i);
    }
  }
}

bool
ModelMulti::initCurves(shared_ptr<curves::Curve>& curve) {
  const string modelName = curve->getModelName();
  const string variable = curve->getVariable();
  const string variableNameBis = variable + "_value";

  const findSubModelFromVarName_t& props = findSubModel(modelName, variable);
  shared_ptr<SubModel> subModel = props.subModel_;

  curve->setAvailable(false);

  if (subModel) {
    if (!props.isNetwork_) {   // found model's ID in the composed models.
      if (props.isDynParam_) {   // case 2: curve's variable curve is a parameter in submodel
        Trace::debug() << DYNLog(AddingCurveParam, modelName, variable) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variable);
        curve->setAsParameterCurve(true);   // This is a parameter curve
        subModel->addParameterCurve(curve);
        return true;
      } else if (props.variableNameInSubModel_ == variable) {   // found exact curve name
        Trace::debug() << DYNLog(AddingCurve, modelName, variable) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variable);
        curve->setAsParameterCurve(false);   // This is a variable curve
        subModel->addCurve(curve);
        return true;
      } else if (props.variableNameInSubModel_ == variableNameBis) {
        Trace::debug() << DYNLog(AddingCurveOutput, modelName, variable, variableNameBis) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variableNameBis);
        subModel->addCurve(curve);
        return true;
      }
    } else {
      // BEGIN SEARCH IN NETWORK
      shared_ptr<SubModel> modelNetwork = subModel;
      string name = modelName + "_" + variable;
      if (props.variableNameInSubModel_ == name) {
        Trace::debug() << DYNLog(AddingCurveOutput, modelName, variable, name) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(name);
        modelNetwork->addCurve(curve);
        return true;
      } else {
        string name2 = name + "_value";
        if (props.variableNameInSubModel_ == name2) {   // find name2 = name_value
          Trace::debug() << DYNLog(AddingCurveOutput, modelName, variable, name2) << Trace::endline;
          curve->setAvailable(true);
          curve->setFoundVariableName(name2);
          modelNetwork->addCurve(curve);
          return true;
        }
      }
    }
  }

  Trace::warn() << DYNLog(CurveNotAdded, modelName, variable) << Trace::endline;
  return false;
}

void
ModelMulti::updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection>& curvesCollection) const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::updateCurves");
#endif
  for (curves::CurvesCollection::iterator itCurve = curvesCollection->begin(), itCurveEnd = curvesCollection->end();
      itCurve != itCurveEnd; ++itCurve) {
    boost::shared_ptr<Curve> curve = *itCurve;
    shared_ptr<SubModel> subModel = findSubModel(curve->getModelName(), curve->getVariable()).subModel_;
    if (subModel) {
      subModel->updateCalculatedVarForCurve(curve);
    }
  }
}

void
ModelMulti::fillVariables(boost::shared_ptr<finalState::FinalStateModel>& model) {
  // warning: modelmulti is only composed of submodels
  // excepted network model, submodels have no submodels
  // variables are researched in submodels
  // for variable in model1 which are in model, the researched name is model1Name_variableName

  const string id = model->getId();
  const shared_ptr<SubModel>& subModel = findSubModelByName(id);
  if (subModel) {  // found model id in the composed models
    for (finalStateVariable_iterator itVariable = model->beginVariable();
            itVariable != model->endVariable();
            ++itVariable) {
      const string name = (*itVariable)->getId();
      if (subModel->hasVariable(name)) {
        (*itVariable)->setValue(subModel->getVariableValue(name));
      }
    }

    for (finalStateModel_iterator itModel1 = model->beginFinalStateModel();
            itModel1 != model->endFinalStateModel();
            ++itModel1) {
      string id1 = (*itModel1)->getId();
      for (finalStateVariable_iterator itVariable = (*itModel1)->beginVariable();
              itVariable != (*itModel1)->endVariable();
              ++itVariable) {
        string name = id1 + "_" + (*itVariable)->getId();
        if (subModel->hasVariable(name)) {
          (*itVariable)->setValue(subModel->getVariableValue(name));
        }
      }
    }
  }
}

void
ModelMulti::fillVariable(boost::shared_ptr<finalState::Variable>& /*variable*/) {
  // no variable are alone without been associated to a subModel until now
  // it's due to the way the modelMulti is constructed.
}

void ModelMulti::printVariableNames() {
  int nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& xNames = subModels_[i]->xNamesInit();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << subModels_[i]->name() << "_" << xNames[j] << Trace::endline;
       ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X calculated variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& xNames = subModels_[i]->getCalculatedVarNamesInit();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << subModels_[i]->name() << "_" << xNames[j] << Trace::endline;
       ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "Z variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& zNames = subModels_[i]->zNamesInit();
    for (unsigned int j = 0; j < zNames.size(); ++j) {
      Trace::debug(Trace::variables()) << nVar << " " << subModels_[i]->name() << "_" << zNames[j] << Trace::endline;
      ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& xNames = subModels_[i]->xNames();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
      std::string varName = subModels_[i]->name() + "_" + xNames[j];
      Trace::debug(Trace::variables()) << nVar << " " << varName << Trace::endline;
      ++nVar;
    }
  }
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::pair<std::string, std::pair<std::string, bool > > >& xAlias = subModels_[i]->xAliasesNames();
    for (unsigned int j = 0; j < xAlias.size(); ++j) {
      Trace::debug(Trace::variables()) << subModels_[i]->name() << "_" << xAlias[j].first << " is an alias of " <<
          subModels_[i]->name() << "_" << xAlias[j].second.first << " (negated: " << xAlias[j].second.second << ")" << Trace::endline;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X calculated variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& xNames = subModels_[i]->getCalculatedVarNames();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
      std::string varName = subModels_[i]->name() + "_" + xNames[j];
      Trace::debug(Trace::variables()) << nVar << " " << varName << Trace::endline;
      ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "Z variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& zNames = subModels_[i]->zNames();
    for (unsigned int j = 0; j < zNames.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << subModels_[i]->name() << "_" << zNames[j] << Trace::endline;
       ++nVar;
    }
  }
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::pair<std::string, std::pair<std::string, bool > > >& zAlias = subModels_[i]->zAliasesNames();
    for (unsigned int j = 0; j < zAlias.size(); ++j) {
      Trace::debug(Trace::variables()) << subModels_[i]->name() << "_" << zAlias[j].first << " is an alias of "
          << subModels_[i]->name() << "_" << zAlias[j].second.first << " (negated: " << zAlias[j].second.second << ")" << Trace::endline;
    }
  }
}

void ModelMulti::printEquations() {
  bool isInitProcessBefore = subModels_[0]->getIsInitProcess();
  setIsInitProcess(true);
  int nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Equations init" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    for (unsigned int j = 0 ; j < subModels_[i]->sizeFInit() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModels_[i]->getFequationByLocalIndex(j) <<
          " model: " << subModels_[i]->name() <<  Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(false);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Equations" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    for (unsigned int j = 0 ; j < subModels_[i]->sizeF() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModels_[i]->getFequationByLocalIndex(j) <<
          " model: " << subModels_[i]->name() << Trace::endline;
      ++nVar;
    }
  }
  connectorContainer_->printEquations();

  setIsInitProcess(true);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Roots init" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    for (unsigned int j = 0 ; j < subModels_[i]->sizeGInit() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModels_[i]->getGequationByLocalIndex(j) <<
          " model: " << subModels_[i]->name() <<  Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(false);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Roots" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    for (unsigned int j = 0 ; j < subModels_[i]->sizeG() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModels_[i]->getGequationByLocalIndex(j) <<
          " model: " << subModels_[i]->name() << Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(isInitProcessBefore);
}

void ModelMulti::printLocalInitParametersValues() const {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->printLocalInitParametersValues();
  }
}

std::string ModelMulti::getVariableName(int index) {
  // At the first call we construct the association
  if (yNames_.empty()) {
    std::string varName;
    for (unsigned int i = 0; i < subModels_.size(); ++i) {
      const std::vector<std::string>& xNames = subModels_[i]->xNames();
      for (unsigned int j = 0; j < xNames.size(); ++j) {
        varName = subModels_[i]->name() + "_" + xNames[j];
        yNames_.push_back(varName);
      }
    }
  }
  assert(index < static_cast<int>(yNames_.size()));
  return yNames_[index];
}

void ModelMulti::getCurrentZ(vector<double>& z) const {
  z.assign(zLocal_, zLocal_ + sizeZ());
}

void ModelMulti::setCurrentZ(const vector<double>& z) {
  assert(z.size() == (size_t)sizeZ());
  std::copy(z.begin(), z.end(), zLocal_);
}

string
ModelMulti::getDynamicDeviceNameVariable(int index) {
  if (yNamesDynamicDevices_.empty()) {
    string varName;
    for (unsigned int i = 0; i < subModels_.size(); ++i) {
      const vector<string> & xNames = subModels_[i] -> xNames();
      for (unsigned int j = 0; j < xNames.size(); ++j) {
        varName = subModels_[i] -> name();
        yNamesDynamicDevices_.push_back(varName);
      }
    }
  }
  assert(index < static_cast < int > (yNamesDynamicDevices_.size()));
  return yNamesDynamicDevices_[index];
}

void
ModelMulti::getAllNamesDiffDynamicDevices() {
  if (namesDiffDynamicDevices_.empty()) {
    for (int i = 0; i < sizeY(); ++i) {
      if (yType_[i] == DYN::DIFFERENTIAL) {
        namesDiffDynamicDevices_.push_back(getDynamicDeviceNameVariable(i));  // names of dynamic devices that are associated to
                                                                              // differential variables with redundancy
      }
    }
  }
}

vector<string>
ModelMulti::findNamesDiffDynamicDevices(std::vector<int> &indices) {
  getAllNamesDiffDynamicDevices();
  std::vector<string> selectNamesDiffDynamicDevices;
  for (unsigned int i = 0; i < indices.size(); i++) {
    selectNamesDiffDynamicDevices.push_back(namesDiffDynamicDevices_[indices[i]]);
  }
  return selectNamesDiffDynamicDevices;
}

void
ModelMulti::getIndicesDiffAlgVariables() {
  if (indicesDiffVars_.empty()) {
    if (indicesAlgVars_.empty()) {
      for (int i = 0; i < sizeY(); ++i) {
        if (yType_[i] == DYN::DIFFERENTIAL) {
          indicesDiffVars_.push_back(i);
        } else {
          indicesAlgVars_.push_back(i);
        }
      }
    }
  }
}

void
ModelMulti::getIndicesDiffAlgEquations() {
  if (indicesDiffEqus_.empty()) {
    if (indicesAlgEqus_.empty()) {
      for (int i = 0; i < sizeF(); ++i) {
        if (fType_[i] == DYN::DIFFERENTIAL_EQ) {
          indicesDiffEqus_.push_back(i);
        } else {
          indicesAlgEqus_.push_back(i);
        }
      }
    }
  }
}

void
ModelMulti::getNamesDiffAlgVariables() {
  if (varDiffNames_.empty()) {
    if (varAlgNames_.empty()) {
      for (int i = 0; i < sizeY(); ++i) {
        if (yType_[i] == DYN::DIFFERENTIAL) {
          varDiffNames_.push_back(getVariableName(i));
        } else {
          varAlgNames_.push_back(getVariableName(i));
        }
      }
    }
  }
}

void
ModelMulti::createMatrixA(const double t) {
  if (A_.size() == 0) {
    SparseMatrix Jt;  // J in sparse form
    Jt.init(sizeY(), sizeY());
    evalJt(t, 1, Jt);

    SparseMatrix JtPrim;  // JPrime in sparse form
    JtPrim.init(sizeY(), sizeY());
    evalJtPrim(t, 1, JtPrim);

    Eigen::MatrixXd Aold = Jt.EigenMatrix() - JtPrim.EigenMatrix();

    getIndicesDiffAlgVariables();  // indices of differential/algebraic variables
    getIndicesDiffAlgEquations();  // indices of differential/algebraic equations
    Eigen::MatrixXd A11Prim = contructSubMatrix(JtPrim.EigenMatrix(), indicesDiffEqus_, indicesDiffVars_);

    if (A11Prim.determinant() == 0) {
      throw DYNError(Error::MODELER, ModelFuncError, "The matrix A11Prim is singular");
    } else {
      Eigen::MatrixXd A11 = contructSubMatrix(Aold, indicesDiffEqus_, indicesDiffVars_);
      Eigen::MatrixXd A12 = contructSubMatrix(Aold, indicesDiffEqus_, indicesAlgVars_);
      Eigen::MatrixXd A21 = contructSubMatrix(Aold, indicesAlgEqus_, indicesDiffVars_);
      Eigen::MatrixXd A22 = contructSubMatrix(Aold, indicesAlgEqus_, indicesAlgVars_);

      if (A22.determinant() != 0) {
        A_ = -(A11Prim.inverse()) * A11 + (A11Prim.inverse()) * (A12 * (A22.inverse()) * A21);
      } else {
        throw DYNError(Error::MODELER, ModelFuncError, "The matrix A22 is singular");
      }
    }
  }
}

void
ModelMulti::createMatrixB(const double t) {
  if (B_.size() == 0) {
    SparseMatrix Jt;
    SparseMatrix JtPrim;
    Jt.init(sizeY(), sizeY());
    JtPrim.init(sizeY(), sizeY());
    evalJtPrim(t, 1, JtPrim);
    evalJt(t, 1, Jt);
    Eigen::MatrixXd Aold = Jt.EigenMatrix() - JtPrim.EigenMatrix();
    getNamesDiffAlgVariables();  // names of differential/algebraic variables
    getIndicesDiffAlgVariables();
    getIndicesDiffAlgEquations();

    Eigen::MatrixXd A12 = contructSubMatrix(Aold, indicesDiffEqus_, indicesAlgVars_);
    Eigen::MatrixXd A22 = contructSubMatrix(Aold, indicesAlgEqus_, indicesAlgVars_);

    if (A22.determinant() == 0) {
      throw DYNError(Error::MODELER, ModelFuncError, "The matrix A11Prim is singular");
    } else {
      Eigen::MatrixXd A11Prim = contructSubMatrix(JtPrim.EigenMatrix(), indicesDiffEqus_, indicesDiffVars_);

      if (A11Prim.determinant() != 0) {
        std::vector<int> indicesVref1 = getIndicesString(varAlgNames_, "URef");
        std::vector<int> indicesVref2 = getIndicesString(varAlgNames_, "UsRefPu");
        indicesVref1.insert(indicesVref1.end(), indicesVref2.begin(), indicesVref2.end());

        if (indicesVref1.empty()) {
          throw DYNError(Error::MODELER, ModelFuncError, "Input variable was not found, choose another input variable");
        } else {
          Eigen::MatrixXd R = Eigen::MatrixXd::Zero(varAlgNames_.size(), indicesVref1.size());
          for (unsigned int k = 0; k < indicesVref1.size(); k++) {
            for (unsigned int j = 0; j < varAlgNames_.size(); j++) {
              if (A22(j, indicesVref1[k]) > 0) {
                R(j, k) = 1;
              }
            }
          }
          B_ = -(A11Prim.inverse()) * (A12 * (A22.inverse()) * R);  // input matrix
         }
        } else {
          throw DYNError(Error::MODELER, ModelFuncError, "The matrix A22 is singular");
        }
      }
  }
}

void
ModelMulti::createMatrixC() {
  if (C_.size() == 0) {
    getNamesDiffAlgVariables();
    std::vector<int> indicesOmega = getIndicesString(varDiffNames_, "omega");  // indices of output variable

    if (indicesOmega.empty()) {
      throw DYNError(Error::MODELER, ModelFuncError, "Output variable was not found, choose another output variable");
    } else {
      C_ = Eigen::MatrixXd::Zero(indicesOmega.size(), varDiffNames_.size());
      for (unsigned int i = 0; i < indicesOmega.size(); i++) {
        C_(i, indicesOmega[i]) = 1;
      }
    }
  }
}

void
ModelMulti::generalizedEigenSolver(const double t) {
  boost::shared_ptr<ModalAnalysis> modalAnalysis(new ModalAnalysis());

  if (allEigenvalues_.size() == 0 && rightEigenvectors_.size() == 0) {
    createMatrixA(t);
    Eigen::EigenSolver<Eigen::MatrixXd> s(A_);
    allEigenvalues_ = s.eigenvalues();
    rightEigenvectorsInitial_ = s.eigenvectors();
    // normalized eigenvectors
    Eigen::MatrixXd rightEigenvectorsAbs(rightEigenvectorsInitial_.cols(), rightEigenvectorsInitial_.cols());
    Eigen::MatrixXcd rightEigenvectorsNormalized(rightEigenvectorsInitial_.cols(), rightEigenvectorsInitial_.cols());

    rightEigenvectorsAbs = rightEigenvectorsInitial_.cwiseAbs();
    std::vector < int > maxIndices = getIndicesMax(rightEigenvectorsAbs);

    for (unsigned int i = 0; i < rightEigenvectorsInitial_.cols(); i++) {
      rightEigenvectorsNormalized.col(i) = (rightEigenvectorsInitial_.col(i)) / (rightEigenvectorsInitial_(maxIndices[i], i));
    }
    rightEigenvectors_ = rightEigenvectorsNormalized;

    if (rightEigenvectors_.determinant().real() == 0 && rightEigenvectors_.determinant().imag() == 0) {
      throw DYNError(Error::MODELER, ModelFuncError, "The matrix of right eigenvectors is singular");
    } else {
      matParticipation_ = modalAnalysis -> createParticipationMatrix(rightEigenvectors_);
      matPhase_ = modalAnalysis -> createPhaseMatrix(rightEigenvectors_);
    }
  }
}

void
ModelMulti::printSmallModalAnalysis(const double t, const double partFactor) {
  boost::shared_ptr<ModalAnalysis> modalAnalysis(new ModalAnalysis());

  generalizedEigenSolver(t);
  getNamesDiffAlgVariables();
  imagEigenvalues_ = allEigenvalues_.imag();
  realEigenvalues_ = allEigenvalues_.real();

  std::vector<int> indicesNonzeroImagParts = modalAnalysis -> getIndicesNonzeroImagParts(imagEigenvalues_);
  std::vector<int> indicesRealModes = modalAnalysis -> getIndicesRealModes(imagEigenvalues_);
  std::vector<int> indicesMaxParticitpations = getIndicesMax(matParticipation_);

  if (!indicesNonzeroImagParts.empty()) {
    std::vector<int> indicesStableModes = modalAnalysis -> getIndicesStableModes(indicesNonzeroImagParts, realEigenvalues_);
    std::vector<int> indicesUnstableModes = modalAnalysis -> getIndicesUnstableModes(imagEigenvalues_, realEigenvalues_);

    if (!indicesStableModes.empty()) {
      std::vector<int> indicesMaxParticipationStableModes = getIndicesMaxParticipationModes(indicesMaxParticitpations, indicesStableModes);
      std::vector<double> maxPartStableModes = getValuesIndices(matParticipation_, indicesStableModes, indicesMaxParticitpations);
      std::vector<std::string> namesMostVarDiff = modalAnalysis -> getNamesMostVarDiff(varDiffNames_, indicesMaxParticipationStableModes);
      std::vector<std::string> selectNamesDiffDynamicDevices = findNamesDiffDynamicDevices(indicesMaxParticipationStableModes);

      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "Modal Analysis" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "Number of Stable Modes  :" << indicesStableModes.size() << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "Number of Unstable Modes:" << indicesUnstableModes.size() << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "Number of Real Modes    :" << indicesRealModes.size() << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;

      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "Stable Modes" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << boost::format("%-8s%-13s%-13s%-10s%-10s%-13s%-15s%-13s%-15s") % "Nb." % "Imag. part" %
      "Real part" % "Freq.(Hz)" % "Damp.(%)" % "Parti.(%)" % "Phase(deg)" % "Type" % "Gen. With Greatest Part." << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;

      vector<double> phaseStableModes = getValuesIndices(matPhase_, indicesStableModes, indicesMaxParticitpations);
      for (unsigned int i = 0; i < indicesStableModes.size(); i++) {
        string modeType = getTypeMode(namesMostVarDiff[i]);
        double frequStableMode = modalAnalysis -> computeFrequency(imagEigenvalues_[indicesStableModes[i]]);
        double dampStableMode = modalAnalysis -> computeDamping(realEigenvalues_[indicesStableModes[i]],
        imagEigenvalues_[indicesStableModes[i]]);
        double maxPartStableModesFinal = 100*maxPartStableModes[i];
        Trace::debug(Trace::fullmodalanalysis()) << boost::format("%-8i%-13.4f%-13.4f%-10.4f%-10.4f%-13.4f%-15.4f%-13s%-15s") %
        indicesStableModes[i] % imagEigenvalues_[indicesStableModes[i]] % realEigenvalues_[indicesStableModes[i]] %
        frequStableMode % dampStableMode % maxPartStableModesFinal % phaseStableModes[i] % modeType %
        selectNamesDiffDynamicDevices[i] << Trace::endline;
      }
    }

    if (!indicesUnstableModes.empty()) {
      std::vector<int> indicesMaxParticipationUnstableModes = getIndicesMaxParticipationModes(indicesMaxParticitpations, indicesUnstableModes);
      std::vector<double> maxParticipationUnstableModes = getValuesIndices(matParticipation_, indicesUnstableModes, indicesMaxParticitpations);
      std::vector<std::string> namesMostVarDiff = modalAnalysis -> getNamesMostVarDiff(varDiffNames_, indicesMaxParticipationUnstableModes);
      std::vector<std::string> selectNamesDiffDynamicDevices = findNamesDiffDynamicDevices(indicesMaxParticipationUnstableModes);

      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "Unstable Modes" << Trace::endline;
      Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;

      std::vector<double> phaseUnstableModes = getValuesIndices(matPhase_, indicesUnstableModes, indicesMaxParticitpations);
      for (unsigned int i = 0; i < indicesUnstableModes.size(); i++) {
        double maxParticipationUnstableModesFinal = 100*maxParticipationUnstableModes[i];
        string modeType = getTypeMode(namesMostVarDiff[i]);
        double frequUnstableMode = modalAnalysis -> computeFrequency(imagEigenvalues_[indicesUnstableModes[i]]);
        double dampUnstableMode = modalAnalysis -> computeDamping(realEigenvalues_[indicesUnstableModes[i]],
        imagEigenvalues_[indicesUnstableModes[i]]);
        Trace::debug(Trace::fullmodalanalysis()) << boost::format("%-8i%-12.4f%-12.4f%-10.4f%-10.4f%-12.4f%-12.4f%-8s%-17s") %
        indicesUnstableModes[i] % imagEigenvalues_[indicesUnstableModes[i]] % realEigenvalues_[indicesUnstableModes[i]] %
        frequUnstableMode % dampUnstableMode % maxParticipationUnstableModesFinal % phaseUnstableModes[i] % modeType %
        selectNamesDiffDynamicDevices[i] << Trace::endline;
      }
    }
  }

  if (!indicesRealModes.empty()) {
    std::vector<double> maxParticipationRealModes = getValuesIndices(matParticipation_, indicesRealModes, indicesMaxParticitpations);
    std::vector<int> indicesMaxParticipationRealModes = getIndicesMaxParticipationModes(indicesMaxParticitpations, indicesRealModes);
    std::vector<std::string> namesMostVarDiff = modalAnalysis -> getNamesMostVarDiff(varDiffNames_, indicesMaxParticipationRealModes);
    std::vector<std::string> selectNamesDiffDynamicDevices = findNamesDiffDynamicDevices(indicesMaxParticipationRealModes);

    Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "Real Modes" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << boost::format("%-8s%-13s%-15s%-13s%-15s") % "Nb." % "Real part" % "Parti.(%)" %
    "Type" % "Gen. With Greatest Part." << Trace::endline;
    Trace::debug(Trace::fullmodalanalysis()) << "------------------------------" << Trace::endline;

    for (unsigned int i = 0; i < indicesRealModes.size(); i++) {
      string modeType = getTypeMode(namesMostVarDiff[i]);
      double maxParticipationRealModesFinal = 100*maxParticipationRealModes[i];
      Trace::debug(Trace::fullmodalanalysis()) << boost::format("%-8d%-13.4f%-15.4f%-13s%-15s") % indicesRealModes[i] %
      realEigenvalues_[indicesRealModes[i]] % maxParticipationRealModesFinal % modeType % selectNamesDiffDynamicDevices[i] << Trace::endline;
    }
  }

  if (partFactor >= 0) {
  getAllNamesDiffDynamicDevices();
  modalAnalysis->printCoupledDevices(indicesNonzeroImagParts, matParticipation_, matPhase_,
   allEigenvalues_, partFactor, varDiffNames_, namesDiffDynamicDevices_);
  } else {
    throw DYNError(Error::MODELER, ModelFuncError, "The minimum value of participation factor should be positive");
  }
}

void
ModelMulti::evalLinearise(const double t) {
  if (t == 0) {
    throw DYNError(Error::MODELER, ModelFuncError, "The evaluation time should be different to zero");
  } else {
    Trace::debug(Trace::statespace()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::statespace()) << " A " << Trace::endline;
    Trace::debug(Trace::statespace()) << "------------------------------" << Trace::endline;
    createMatrixA(t);
    Trace::debug(Trace::statespace()) << "\n" << A_<< Trace::endline;

    Trace::debug(Trace::statespace()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::statespace()) << " B " << Trace::endline;
    Trace::debug(Trace::statespace()) << "------------------------------" << Trace::endline;
    createMatrixB(t);
    Trace::debug(Trace::statespace()) << "\n" << B_ << Trace::endline;

    Trace::debug(Trace::statespace()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::statespace()) << " C " << Trace::endline;
    Trace::debug(Trace::statespace()) << "------------------------------" << Trace::endline;
    createMatrixC();
    Trace::debug(Trace::statespace()) << "\n" << C_ << Trace::endline;
  }
}

void
ModelMulti::smallModalAnalysis(const double t, const double partFactor) {
  if (t == 0) {
    throw DYNError(Error::MODELER, ModelFuncError, "The evaluation time should be different to zero");
  } else {
  printSmallModalAnalysis(t, partFactor);
  }
}

void
ModelMulti::subParticipation(const double t, const int nbrMode) {
  boost::shared_ptr<ModalAnalysis> modalAnalysis(new ModalAnalysis());
  if (t == 0) {
    throw DYNError(Error::MODELER, ModelFuncError, "The evaluation time should be different to zero");
  } else {
    generalizedEigenSolver(t);
    getNamesDiffAlgVariables();

    if (nbrMode >= 0) {
      Trace::debug(Trace::subparticipation()) << "----------------------------------------" << Trace::endline;
      Trace::debug(Trace::subparticipation()) << " Subsystem Participation of the" << Trace::endline;
      Trace::debug(Trace::subparticipation()) << " dynamic device components in the mode" << Trace::endline;
      Trace::debug(Trace::subparticipation()) << "---------------------------------------" << Trace::endline;

      Trace::debug(Trace::subparticipation()) << "---------------------------------------" << Trace::endline;
      Trace::debug(Trace::subparticipation()) << "Mode: " << "<" << allEigenvalues_(nbrMode) << ">" << Trace::endline;
      Trace::debug(Trace::subparticipation()) << "---------------------------------------" << Trace::endline;
      vector<int> indicesROT = modalAnalysis -> getIndicesROT(varDiffNames_);
      Trace::debug(Trace::subparticipation()) << "ROT: " << modalAnalysis -> getSubParticipation(nbrMode, indicesROT, matParticipation_) << Trace::endline;
      vector<int> indicesSMD = modalAnalysis -> getIndicesSMD(varDiffNames_);
      Trace::debug(Trace::subparticipation()) << "SMD: " << modalAnalysis -> getSubParticipation(nbrMode, indicesSMD, matParticipation_) << Trace::endline;
      vector<int> indicesSMQ = modalAnalysis -> getIndicesSMQ(varDiffNames_);
      Trace::debug(Trace::subparticipation()) << "SMQ: " << modalAnalysis -> getSubParticipation(nbrMode, indicesSMQ, matParticipation_) << Trace::endline;
      vector<int> indicesAVR = modalAnalysis -> getIndicesAVR(varDiffNames_);
      Trace::debug(Trace::subparticipation()) << "AVR: " << modalAnalysis -> getSubParticipation(nbrMode, indicesAVR, matParticipation_) << Trace::endline;
      vector<int> indicesGOV = modalAnalysis -> getIndicesGOV(varDiffNames_);
      Trace::debug(Trace::subparticipation()) << "GOV: " << modalAnalysis -> getSubParticipation(nbrMode, indicesGOV, matParticipation_) << Trace::endline;
      vector<int> indicesINJ = modalAnalysis -> getIndicesINJ(varDiffNames_);
      Trace::debug(Trace::subparticipation()) << "INJ: " << modalAnalysis -> getSubParticipation(nbrMode, indicesINJ, matParticipation_) << Trace::endline;
      fixedIndices_.insert(fixedIndices_.end(), indicesROT.begin(), indicesROT.end());
      fixedIndices_.insert(fixedIndices_.end(), indicesSMD.begin(), indicesSMD.end());
      fixedIndices_.insert(fixedIndices_.end(), indicesSMQ.begin(), indicesSMQ.end());
      fixedIndices_.insert(fixedIndices_.end(), indicesAVR.begin(), indicesAVR.end());
      fixedIndices_.insert(fixedIndices_.end(), indicesGOV.begin(), indicesGOV.end());
      fixedIndices_.insert(fixedIndices_.end(), indicesINJ.begin(), indicesINJ.end());
      vector<int> indicesOTH = modalAnalysis -> getIndicesOTH(varDiffNames_, fixedIndices_);
      Trace::debug(Trace::subparticipation()) << "OTH: " << modalAnalysis -> getSubParticipation(nbrMode, indicesOTH, matParticipation_) << Trace::endline;
      Trace::debug(Trace::subparticipation()) << "---------------------------------------" << Trace::endline;
    } else {
      throw DYNError(Error::MODELER, ModelFuncError, "The number of mode should be positive");
    }
  }
}

}  // namespace DYN
