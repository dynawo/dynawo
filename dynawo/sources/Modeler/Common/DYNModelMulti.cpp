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

#include "TLTimeline.h"
#include "CRVCurve.h"
#include "CRVCurvesCollection.h"
#include "CSTRConstraintsCollection.h"

#include "DYNMacrosMessage.h"
#include "DYNSparseMatrix.h"
#include "DYNModelMulti.h"
#include "DYNSubModel.h"
#include "DYNConnector.h"
#include "DYNTrace.h"
#include "DYNElement.h"
#include "DYNTimer.h"
#include "DYNConnectorCalculatedDiscreteVariable.h"
#include "DYNConnectorCalculatedVariable.h"
#include "DYNCommon.h"
#include "DYNVariableAlias.h"

using std::min;
using std::max;
using std::vector;
using std::set;
using std::string;
using std::stringstream;
using std::map;
using std::pair;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;
using timeline::Timeline;
using curves::Curve;
using constraints::ConstraintsCollection;
using std::fstream;

namespace DYN {

ModelMulti::ModelMulti() :
sizeF_(0),
sizeZ_(0),
sizeG_(0),
sizeMode_(0),
sizeY_(0),
silentZChange_(NO_Z_CHANGE),
modeChange_(false),
modeChangeType_(NO_MODE),
offsetFOptional_(0),
zConnectedLocal_(nullptr),
silentZInitialized_(false),
updatablesInitialized_(false) {
  connectorContainer_.reset(new ConnectorContainer());
}

ModelMulti::~ModelMulti() {
  if (zConnectedLocal_ != nullptr) {
    delete[] zConnectedLocal_;
    zConnectedLocal_ = nullptr;
  }
}

void
ModelMulti::setTimeline(const boost::shared_ptr<Timeline>& timeline) {
  for (const auto& subModel : subModels_)
    subModel->setTimeline(timeline);
}

void
ModelMulti::setConstraints(const std::shared_ptr<ConstraintsCollection>& constraints) {
  for (const auto& subModel : subModels_)
    subModel->setConstraints(constraints);
}

void
ModelMulti::setWorkingDirectory(const string& workingDirectory) {
  for (const auto& subModel : subModels_)
    subModel->setWorkingDirectory(workingDirectory);
}

void
ModelMulti::setActionBuffer(const std::shared_ptr<ActionBuffer> actionBuffer) {
  actionBuffer_ = actionBuffer;
}

void
ModelMulti::addSubModel(const shared_ptr<SubModel>& sub, const string& libName) {
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

  subModelByName_[sub->name()] = subModels_.size();
  if (!libName.empty()) {
    subModelByLib_[libName].push_back(sub);
  }
  subModels_.push_back(sub);
}

void
ModelMulti::initBuffers() {
  // (1) Get size of each sub models
  // -------------------------------
  for (const auto& subModel : subModels_)
    subModel->initSize(sizeY_, sizeZ_, sizeMode_, sizeF_, sizeG_);

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
  fLocal_ = std::vector<double>(sizeF_);
  gLocal_ = std::vector<state_g>(sizeG_, ROOT_DOWN);
  yLocal_ = std::vector<double>(sizeY_);
  ypLocal_ = std::vector<double>(sizeY_);
  zLocal_ = std::vector<double>(sizeZ_);
  zConnectedLocal_ = new bool[sizeZ_];
  std::fill_n(zConnectedLocal_, sizeZ_, false);
  silentZ_ = std::vector<BitMask>(sizeZ_);
  for (int i = 0; i < sizeZ_; ++i) {
    silentZ_[i].setFlags(NotSilent);
  }

  int offsetF = 0;
  int offsetG = 0;
  int offsetY = 0;
  int offsetZ = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const auto& subModel = subModels_[i];
    const int sizeY = subModel->sizeY();
    if (sizeY > 0)
      subModel->setBufferY(yLocal_.data(), ypLocal_.data(), offsetY);
    offsetY += sizeY;

    const int sizeF = subModel->sizeF();
    if (sizeF > 0) {
      subModel->setBufferF(fLocal_.data(), offsetF);
      for (int j = offsetF; j < offsetF + sizeF; ++j)
        mapAssociationF_[j] = i;

      offsetF += sizeF;
    }

    const int sizeG = subModel->sizeG();
    if (sizeG > 0) {
      subModel->setBufferG(gLocal_.data(), offsetG);
      for (int j = offsetG; j < offsetG + sizeG; ++j)
        mapAssociationG_[j] = i;

      offsetG += sizeG;
    }

    const int sizeZ = subModel->sizeZ();
    if (sizeZ > 0)
      subModels_[i]->setBufferZ(zLocal_.data(), zConnectedLocal_, offsetZ);
    offsetZ += sizeZ;
  }
  connectorContainer_->setBufferF(fLocal_.data(), offsetF);
  connectorContainer_->setBufferY(yLocal_.data(), ypLocal_.data());  // connectors access to the whole y Buffer
  connectorContainer_->setBufferZ(zLocal_.data(), zConnectedLocal_);  // connectors access to the whole z buffer
  connectorContainer_->propagateZConnectionInfoToModel();
  std::fill(fLocal_.begin() + offsetFOptional_, fLocal_.begin() + sizeF_, 0.);

  // (3) init buffers of each sub-model (useful for the network model)
  // (4) release elements that were used and declared only for connections
  for (const auto& subModel : subModels_) {
    subModel->initSubBuffers();
    subModel->releaseElements();
  }
}

void
ModelMulti::init(const double t0) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer1("ModelMulti::init");
#endif

  zSave_.assign(zLocal_.begin(), zLocal_.end());

  // (1) initialising each sub-model
  //----------------------------------------
  for (const auto& subModel : subModels_)
    subModel->initSub(t0, localInitParameters_);

  // Detect if some discrete variable were modified during the initialization (e.g. subnetwork detection)
  vector<int> indicesDiff;
  vector<int> valuesModified;
  for (int i = 0; i < sizeZ(); ++i) {
    if (doubleNotEquals(zLocal_[i], zSave_[i])) {
      indicesDiff.push_back(i);
      valuesModified.push_back(static_cast<int>(zLocal_[i]));
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

    connectorContainer_->propagateZDiff(indicesDiff, zLocal_.data());

    zSave_.assign(zLocal_.begin(), zLocal_.end());
    rotateBuffers();

    for (const auto& subModel : subModels_)
      subModel->evalZSub(t0);

    for (unsigned j = 0; j < 10 && propagateZModif(); ++j) {
      for (const auto& subModel : subModels_)
        subModel->evalGSub(t0);
      for (const auto& subModel : subModels_)
        subModel->evalZSub(t0);
    }
    rotateBuffers();
  }
  zSave_.assign(zLocal_.begin(), zLocal_.end());
}

void
ModelMulti::printModel() const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::printModel");
#endif
  for (const auto& subModel : subModels_)
    subModel->printModel();

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
  for (const auto& subModel : subModels_)
    subModel->printParameterValues();
}

void
ModelMulti::rotateBuffers() {
  for (const auto& subModel : subModels_)
    subModel->rotateBuffers();
}

void
ModelMulti::printMessages() {
  for (const auto& subModel : subModels_)
    subModel->printMessages();
}

void
ModelMulti::printModelValues(const string& directory, const string& dumpFileName) {
  for (const auto& subModel : subModels_)
    subModel->printModelValues(directory, dumpFileName);
}

void
ModelMulti::printInitModelValues(const string& directory, const string& dumpFileName) {
  for (const auto& subModel : subModels_)
    subModel->printInitModelValues(directory, dumpFileName);
}

void
ModelMulti::copyContinuousVariables(const double* y, const double* yp) {
  yLocal_.assign(y, y + sizeY());
  ypLocal_.assign(yp, yp + sizeY());
}

void
ModelMulti::copyDiscreteVariables(const double* z) {
  yLocal_.assign(z, z + sizeZ());
}

void
ModelMulti::evalF(const double t, const double* y, const double* yp, double* f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalF");
#endif
  copyContinuousVariables(y, yp);

#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer* timer2 = new Timer("ModelMulti::evalF_subModels");
#endif
  for (const auto& subModel : subModels_) {
    if (subModel->sizeF() != 0)
      subModel->evalFSub(t);
  }
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  delete timer2;
#endif

  connectorContainer_->evalFConnector(t);

  std::copy(fLocal_.begin(), fLocal_.end(), f);
}

void
ModelMulti::evalFDiff(const double t, const double* y, const double* yp, double* f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalFDiff");
#endif
  copyContinuousVariables(y, yp);

  for (const auto& subModel : subModels_)
    subModel->evalFDiffSub(t);

  std::copy(fLocal_.begin(), fLocal_.end(), f);
}

void
ModelMulti::evalFMode(const double t, const double* y, const double* yp, double* f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalFMode");
#endif
  copyContinuousVariables(y, yp);

  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const auto& subModel = subModels_[i];
    if (subModel->modeChange()) {
      subModel->evalFSub(t);
      const auto it = subModelIdxToConnectorCalcVarsIdx_.find(i);
      if (it != subModelIdxToConnectorCalcVarsIdx_.end()) {
        const std::vector<size_t >& connectorsIdx = it->second;
        for (const auto connectorIdx : connectorsIdx) {
          subModels_[connectorIdx]->evalFSub(t);
        }
      }
    }
  }

  connectorContainer_->evalFConnector(t);

  std::copy(fLocal_.begin(), fLocal_.end(), f);
}

void
ModelMulti::evalG(const double t, vector<state_g>& g) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalG");
#endif
  for (const auto& subModel : subModels_)
    subModel->evalGSub(t);

  std::copy(gLocal_.begin(), gLocal_.end(), g.begin());
}

void
ModelMulti::evalJt(const double t, const double cj, SparseMatrix& jt) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalJt");
#endif
  int rowOffset = 0;
#ifdef _DEBUG_
  int numCols = 0;
#endif
  for (const auto& subModel : subModels_) {
    subModel->evalJtSub(t, cj, rowOffset, jt);

#ifdef _DEBUG_
    numCols += subModel->sizeF();
    if (jt.getIAp() != numCols) {
      throw DYNError(Error::MODELER, JacobianWrongBuild, subModel->modelType(), subModel->name(), jt.getIAp(), numCols);
    }
#endif

    if (!jt.withoutNan() || !jt.withoutInf()) {
      setFequationsModel();
      const auto& rows = jt.getWithNanOrInfRowIndices();
      const auto& cols = jt.getWithNanOrInfColIndices();
      string variableName;
      int localFIndex;
      string fEquation;
      std::string subModelName("");
      for (unsigned int i = 0; i < jt.getWithNanOrInfColIndices().size(); ++i) {
        int row = rows[i];
        int col = cols[i];
        variableName = getVariableName(row);
        getFInfos(col, subModelName, localFIndex, fEquation);
        Trace::debug() << DYNLog(JacobianNanInfVariable, variableName)<< variableName << " (localIndex " << row - (rowOffset - subModel->sizeY()) << ")"
          << Trace::endline;
        Trace::debug() << DYNLog(JacobianNanInfEquation, fEquation) << " (localIndex " << localFIndex << ")" << Trace::endline;
      }
      throw DYNError(Error::MODELER, SparseMatrixWithNanInf, subModel->modelType(), subModel->name());
    }
  }

  connectorContainer_->evalJtConnector(jt);

  // add Jacobian for optional variables X = 0
  for (const auto numVarOptional : numVarsOptional_) {
    jt.changeCol();
    jt.addTerm(numVarOptional, +1);  // d(f)/d(Y) = +1;
  }
}

void
ModelMulti::evalJtPrim(const double t, const double cj, SparseMatrix& jtPrim) {
  int rowOffset = 0;
  for (const auto& subModel : subModels_) {
    subModel->evalJtPrimSub(t, cj, rowOffset, jtPrim);
    if (!jtPrim.withoutNan() || !jtPrim.withoutInf()) {
      throw DYNError(Error::MODELER, SparseMatrixWithNanInf, subModel->modelType(), subModel->name());
    }
  }

  connectorContainer_->evalJtPrimConnector(jtPrim);

  for (unsigned int i = 0; i < numVarsOptional_.size(); ++i)
    jtPrim.changeCol();
}

void
ModelMulti::evalZ(const double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalZ");
#endif
  if (sizeZ() == 0) return;
  // calculate Z by model
  for (const auto& subModel : subModels_)
    subModel->evalZSub(t);

  // propagation of z changes to connected variables
  if (zSave_.size() != static_cast<size_t>(sizeZ()))
    zSave_.assign(sizeZ(), 0.);

  silentZChange_ = propagateZModif();
}

zChangeType_t
ModelMulti::propagateZModif() {
  vector<int> indicesDiff;
  zChangeType_t zChangeType = NO_Z_CHANGE;
  for (const auto nonSilentZIndex : nonSilentZIndexes_) {
    if (!std::isnan(zLocal_[nonSilentZIndex]) && !std::isnan(zSave_[nonSilentZIndex])) {
      if (doubleNotEquals(zLocal_[nonSilentZIndex], zSave_[nonSilentZIndex])) {
        indicesDiff.push_back(static_cast<int>(nonSilentZIndex));
        zChangeType = NOT_SILENT_Z_CHANGE;
      }
    } else {
      throw DYNError(Error::MODELER, ZValueIsNaN, nonSilentZIndex);
    }
  }
  // test values of discrete variables that are not used to compute continuous equations
  // and raise the flag NotUsedInContinuousEquations if at least one has changed
  // If at least one non silent Z has changed then the flag is never raised
  for (const auto notUsedInContinuousEqSilentZIndex : notUsedInContinuousEqSilentZIndexes_) {
    if (!std::isnan(zLocal_[notUsedInContinuousEqSilentZIndex]) && !std::isnan(zSave_[notUsedInContinuousEqSilentZIndex])) {
      if (doubleNotEquals(zLocal_[notUsedInContinuousEqSilentZIndex], zSave_[notUsedInContinuousEqSilentZIndex])) {
        indicesDiff.push_back(static_cast<int>(notUsedInContinuousEqSilentZIndex));
        if (zChangeType != NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE && zChangeType != NOT_SILENT_Z_CHANGE)
          zChangeType = NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE;
      }
    } else {
      throw DYNError(Error::MODELER, ZValueIsNaN, notUsedInContinuousEqSilentZIndex);
    }
  }
  if (!indicesDiff.empty()) {
    // if at least one discrete variable that is used in discrete equations has changed then we propagate the modification
    connectorContainer_->propagateZDiff(indicesDiff, zLocal_.data());
    std::copy(zLocal_.begin(), zLocal_.end(), zSave_.begin());
    return zChangeType;
  } else {
    // if only discrete variables that are used only in continuous equations then we just raise the NotUsedInDiscreteEquations flag
    // no need to propagate
    for (const auto notUsedInDiscreteEqSilentZIndex : notUsedInDiscreteEqSilentZIndexes_) {
      if (!std::isnan(zLocal_[notUsedInDiscreteEqSilentZIndex]) && !std::isnan(zSave_[notUsedInDiscreteEqSilentZIndex])) {
        if (doubleNotEquals(zLocal_[notUsedInDiscreteEqSilentZIndex], zSave_[notUsedInDiscreteEqSilentZIndex])) {
          std::copy(zLocal_.begin(), zLocal_.end(), zSave_.begin());
          return NOT_USED_IN_DISCRETE_EQ_Z_CHANGE;
        }
      } else {
        throw DYNError(Error::MODELER, ZValueIsNaN, notUsedInDiscreteEqSilentZIndex);
      }
    }
  }
  return NO_Z_CHANGE;
}

void
ModelMulti::evalMode(const double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalMode");
#endif
  /* modeChange_ has to be set at each evalMode call
   *  -> it indicates if there has been a mode change for this call
   * modeChangeType_ is the worst mode change for a complete time step (possibly several evalMode calls)
   *   -> it is reinitialized by the solvers at the end of the time step
  */
#ifdef _DEBUG_
  const std::vector<double> z(zLocal_);
#endif
  modeChange_ = false;
  modeChangeType_t modeChangeType = NO_MODE;
  for (const auto& subModel : subModels_) {
    modeChangeType_t modeChangeTypeSub = subModel->evalModeSub(t);
    if (modeChangeTypeSub > modeChangeType)
      modeChangeType = modeChangeTypeSub;
    if (subModel->modeChange()) {
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
  for (const auto& subModel : subModels_) {
    subModel->modeChange(false);
    subModel->setModeChangeType(NO_MODE);
  }
}

void
ModelMulti::notifyTimeStep() {
  for (const auto& subModel : subModels_)
    subModel->notifyTimeStep();
}

void
ModelMulti::evalCalculatedVariables(const double t, const vector<double>& y, const vector<double>& yp, const vector<double>& z) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalCalculatedVariables");
#endif
  yLocal_.assign(y.begin(), y.end());
  ypLocal_.assign(yp.begin(), yp.end());
  zLocal_.assign(z.begin(), z.end());

  for (const auto& subModel : subModels_)
    subModel->evalCalculatedVariablesSub(t);
}

void
ModelMulti::checkParametersCoherence() const {
  for (const auto& subModel : subModels_)
    subModel->checkParametersCoherence();
}

void
ModelMulti::checkDataCoherence(const double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::checkDataCoherence");
#endif

  for (const auto& subModel : subModels_)
    subModel->checkDataCoherenceSub(t);
}

void
ModelMulti::setFequationsModel() {
  for (const auto& subModel : subModels_)
    subModel->setFequationsSub();
}

void
ModelMulti::setGequationsModel() {
  for (const auto& subModel : subModels_)
    subModel->setGequationsSub();
}

void
ModelMulti::initSilentZ(const bool enableSilentZ) {
  if (!silentZInitialized_ && !subModels_.empty()) {
    silentZInitialized_ = true;
    if (enableSilentZ) {
      collectSilentZ();
    } else {
      nonSilentZIndexes_.clear();
      for (int i = 0; i < sizeZ_; ++i) {
        silentZ_[i].reset();
        silentZ_[i].setFlags(NotSilent);
        nonSilentZIndexes_.push_back(i);
      }
    }
  }
}

void
ModelMulti::getY0(const double t0, vector<double>& y0, vector<double>& yp0) {
  for (const auto& subModel : subModels_) {
    subModel->getY0Sub();
    subModel->evalCalculatedVariablesSub(t0);
  }
  if (!updatablesInitialized_) {
    connectorContainer_->initUpdatableValues();
    updatablesInitialized_ = true;
  }
  connectorContainer_->getY0Connector();

  std::copy(yLocal_.begin(), yLocal_.end(), y0.begin());
  std::copy(ypLocal_.begin(), ypLocal_.end(), yp0.begin());
}

void
ModelMulti::evalStaticYType() {
  yType_.resize(sizeY_);
  int offsetYType = 0;
  for (const auto& subModel : subModels_) {
    const int sizeYType = subModel->sizeY();
    if (sizeYType > 0) {
      subModel->setBufferYType(yType_.data(), offsetYType);
      subModel->evalStaticYType();
      offsetYType += sizeYType;
    }
  }
}

void
ModelMulti::evalDynamicYType() {
  for (const auto& subModel : subModels_) {
    const int sizeYType = subModel->sizeY();
    if (sizeYType > 0)
      subModel->evalDynamicYType();
  }
}

void
ModelMulti::evalStaticFType() {
  fType_.resize(sizeF_);
  int offsetFType = 0;
  for (const auto& subModel : subModels_) {
    const int sizeFType = subModel->sizeF();
    if (sizeFType > 0) {
      subModel->setBufferFType(fType_.data(), offsetFType);
      subModel->evalStaticFType();
      offsetFType += sizeFType;
    }
  }
  connectorContainer_->setBufferFType(fType_.data(), offsetFType);
  connectorContainer_->evalStaticFType();
  std::fill(fType_.begin() + offsetFOptional_, fType_.begin() + sizeF_, ALGEBRAIC_EQ);
}

void
ModelMulti::evalDynamicFType() {
  for (const auto& subModel : subModels_) {
    const int sizeFType = subModel->sizeF();
    if (sizeFType > 0)
      subModel->evalDynamicFType();
  }
  // connectors equations (A = B) can't change during the simulation so we don't need to update them.
}

void
ModelMulti::dumpParameters(std::map< string, string >& mapParameters) {
  for (const auto& subModel : subModels_)
    subModel->dumpParameters(mapParameters);
}

void
ModelMulti::dumpVariables(std::map< string, string >& mapVariables) {
  for (const auto& subModel : subModels_)
    subModel->dumpVariables(mapVariables);
}

void
ModelMulti::getModelParameterValue(const string& curveModelName, const string& curveVariable, double& value, bool& found) {
  const shared_ptr<SubModel>& subModel = findSubModelByName(curveModelName);
  if (subModel) {
    std::string strValue;
    subModel->getSubModelParameterValue(curveVariable, strValue, found);
    if (found) {
      value = stod(strValue);
      return;
    }
  }
  Trace::warn() << DYNLog(ModelMultiParamNotFound, curveModelName, curveVariable) << Trace::endline;
}

void
ModelMulti::loadParameters(const std::map< string, string >& mapParameters) {
  for (const auto& subModel : subModels_)
    subModel->loadParameters(mapParameters);
}

void
ModelMulti::loadVariables(const std::map< string, string >& mapVariables) {
  for (const auto& subModel : subModels_)
    subModel->loadVariables(mapVariables);
}

void
ModelMulti::connectElements(const shared_ptr<SubModel>& subModel1, const string& name1, const shared_ptr<SubModel>& subModel2, const string& name2) {
  vector<std::pair<string, string> > variablesToConnect;
  findVariablesConnectedBy(subModel1, name1, subModel2, name2, variablesToConnect);
  for (const auto& variableToConnectpPair : variablesToConnect) {
    constexpr bool forceConnection = false;
    constexpr bool throwIfCalculatedVarConn = false;
    createConnection(subModel1, variableToConnectpPair.first, subModel2, variableToConnectpPair.second, forceConnection, throwIfCalculatedVarConn);
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

  for (const auto& element1 : elements1) {
    Element element = element1;
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
    variables.emplace_back(element.id(), elements2[j].id());
  }
}

void
ModelMulti::createConnection(const shared_ptr<SubModel>& subModel1, const string& name1, const shared_ptr<SubModel>& subModel2, const string& name2,
                             const bool forceConnection, const bool throwIfCalculatedVarConn) {
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
  const bool negated1 = variable1->getNegated();
  const bool negated2 = variable2->getNegated();
  const bool isState1 = variable1->isState();
  const bool isState2 = variable2->isState();

  if (forceConnection) {  // force the connection to YConnector, specific to the computed variable connector model
    typeVar1 = CONTINUOUS;
    typeVar2 = CONTINUOUS;
  }

  // connection to a calculated variable
  // at least one of the connected variables should be a state variable
  // (a calculated variable is a non-state variable)
  if (!isState1 && !isState2) {
    if (throwIfCalculatedVarConn)
      throw DYNError(Error::MODELER, ConnectorCalculatedVariables, subModel1->name(), name1, subModel2->name(), name2);
    else
      Trace::warn() << DYNLog(CalcVarConnectionIgnored, name1, name2) << Trace::endline;
  } else if (!isState1 && isState2) {  // when one variable is a state variable and the other one isn't, use a specific connection
    if (typeVar2 != CONTINUOUS && typeVar2 != FLOW && typeVar2 != DISCRETE && typeVar2 != INTEGER && typeVar2 != BOOLEAN) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }
    createCalculatedVariableConnection(subModel1, variable1, subModel2, variable2);
  } else if (isState1 && (!isState2)) {
    if (typeVar1 != CONTINUOUS && typeVar1 != FLOW && typeVar1 != DISCRETE && typeVar1 != INTEGER && typeVar2 != BOOLEAN) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }
    createCalculatedVariableConnection(subModel2, variable2, subModel1, variable1);
  } else {  // both variables are state variables
    if (typeVar2 != typeVar1) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }

    const auto connector = boost::make_shared<Connector>();
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
  string name = subModel1->name() + "_" + calculatedVarName1;
  bool isUpdatable = subModel1->getIsUpdatable();

  if (variable1->isAlias())
    name = subModel1->name() + "_" + subModel1->getCalculatedVarName(variable1->getIndex());
  boost::shared_ptr<SubModel> subModelConnector = findSubModelByName(name);
  if (!subModelConnector) {
    // Multiple connection to the same connector can happen with flow connections
    subModelConnector = (variable1->getType() == DISCRETE || variable1->getType() == INTEGER || variable1->getType() == BOOLEAN)?
                    setConnector(shared_ptr<ConnectorCalculatedDiscreteVariable>(new ConnectorCalculatedDiscreteVariable()),
                    name, subModel1, variable1, isUpdatable) :
                    setConnector(shared_ptr<ConnectorCalculatedVariable>(new ConnectorCalculatedVariable()),
                    name, subModel1, variable1, isUpdatable);
    addSubModel(subModelConnector, "");  // no library for connectors
    subModelIdxToConnectorCalcVarsIdx_[subModelByName_[subModel1->name()]].push_back(subModels_.size() - 1);
  }

  createConnection(subModel2, variable2->getName(), subModelConnector, string("connector_" + name));
}

boost::shared_ptr<SubModel>
ModelMulti::findSubModelByName(const string& name) const {
  const auto iter = subModelByName_.find(name);
  if (iter == subModelByName_.end())
    return (shared_ptr<SubModel>());
  else
    return subModels_[iter->second];
}

vector<boost::shared_ptr<SubModel> >
ModelMulti::findSubModelByLib(const string& libName) {
  const auto iter = subModelByLib_.find(libName);
  if (iter == subModelByLib_.end())
    return (vector<shared_ptr<SubModel> >());
  else
    return iter->second;
}

bool
ModelMulti::checkConnects() {
  bool connectOk = true;
  for (const auto& subModel : subModels_) {
    const vector<string>& names = subModel->xNames();
    const int yDeb = subModel->yDeb();
    for (unsigned int j = 0; j < subModel->sizeY(); ++j) {
      if (yType_[yDeb + j] == EXTERNAL) {
        const bool isConnected = connectorContainer_->isConnected(yDeb + j);
        if (!isConnected) {
          Trace::info() << DYNLog(SubModelExtVar, subModel->name(), names[j]) << Trace::endline;
          connectOk = false;
          break;
        }
      }
    }
  }
  return connectOk;
}

void
ModelMulti::getFInfos(const int globalFIndex, string& subModelName, int& localFIndex, string& fEquation) const {
  if (globalFIndex >= connectorContainer_->getOffsetModel()) {
    connectorContainer_->getConnectorInfos(globalFIndex, subModelName, localFIndex, fEquation);
  } else {
    const auto iter = mapAssociationF_.find(globalFIndex);
    if (iter != mapAssociationF_.end()) {
      const auto index = iter->second;
      subModelName = subModels_[index]->name();
      localFIndex = globalFIndex - subModels_[index]->fDeb();
      fEquation = subModels_[index]->getFequationByLocalIndex(localFIndex);
    }
  }
}

void
ModelMulti::getFInfos(const int globalFIndex, string& subModelName, int& localFIndex, string& fEquation, const std::unordered_set<int>& ignoreF) const {
  if (globalFIndex >= connectorContainer_->getOffsetModel()) {
    connectorContainer_->getConnectorInfos(globalFIndex, subModelName, localFIndex, fEquation);
  } else {
    int numVarFull = 0;
    int numVarSubset = 0;

    for (const auto& subModel : subModels_) {
      for (unsigned int j = 0 ; j < subModel->sizeF() ; ++j) {
        if (ignoreF.find(numVarFull) == ignoreF.end()) {
          if (globalFIndex == numVarSubset) {
            fEquation = subModel->getFequationByLocalIndex(j);
            subModelName = subModel->name();
            localFIndex = j;
            break;
          }
          ++numVarSubset;
        }
        ++numVarFull;
      }
      if (globalFIndex == numVarSubset) {
        break;
      }
    }
  }
}

std::vector<std::string>
ModelMulti::getFInfos(const string& subModelName, const string& variable) const {
  std::vector<std::string> equations;

  const auto& subModel = findSubModelByName(subModelName);

  if (subModel) {
    for (unsigned int j = 0 ; j < subModel->sizeF() ; ++j) {
      std::string fEquation = subModel->getFequationByLocalIndex(j);
      if (fEquation.find(variable) != std::string::npos) {
        equations.push_back(subModelName + ": " + fEquation + " localIndex " + std::to_string(j));
      }
    }
  }

  return equations;
}

void
ModelMulti::getGInfos(const int globalGIndex, string& subModelName, int& localGIndex, string& gEquation) const {
  const auto iter = mapAssociationG_.find(globalGIndex);
  if (iter != mapAssociationG_.end()) {
    const auto index = iter->second;
    subModelName = subModels_[index]->name();
    localGIndex = globalGIndex - subModels_[index]->gDeb();
    gEquation = subModels_[index]->getGequationByLocalIndex(localGIndex);
  }
}

void
ModelMulti::setIsInitProcess(bool isInitProcess) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::setIsInitProcess");
#endif

  for (const auto& subModel : subModels_)
    subModel->setIsInitProcess(isInitProcess);
}

void
ModelMulti::setInitialTime(const double t0) {
  for (const auto& subModel : subModels_)
    subModel->setCurrentTime(t0);
}

ModelMulti::findSubModelFromVarName_t
ModelMulti::findSubModel(const string& modelName, const string& varName) const {
  const string variableNameBis = varName + "_value";

  // Search in for the device in Composed Model...
  const shared_ptr<SubModel> subModel = findSubModelByName(modelName);
  if (subModel) {   // found model's ID in the composed models.
    constexpr bool isNetwork = false;
    // case 1: curve's variable is a variable in submodel
    if (subModel->hasVariable(varName)) {   // found exact curve name
      return findSubModelFromVarName_t(subModel, isNetwork, false, varName);
    } else if (subModel->hasParameterDynamic(varName)) {   // case 2: curve's variable curve is a parameter in submodel
      return findSubModelFromVarName_t(subModel, isNetwork, true, varName);
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
      constexpr bool isNetwork = true;
      const string name = modelName + "_" + varName;
      if (modelNetwork->hasVariable(name)) {
        return findSubModelFromVarName_t(modelNetwork, isNetwork, false, name);
      } else {
        const string name2 = name + "_value";
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
  nonSilentZIndexes_.clear();
  notUsedInDiscreteEqSilentZIndexes_.clear();
  nonSilentZIndexes_.clear();
  unsigned offsetZ = 0;
  for (const auto& subModel : subModels_) {
    const int sizeZ = subModel->sizeZ();
    if (sizeZ > 0)
      subModel->collectSilentZ(&silentZ_[offsetZ]);
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
ModelMulti::initCurves(const std::shared_ptr<curves::Curve>& curve) {
  const string& modelName = curve->getModelName();
  const string& variable = curve->getVariable();
  const string variableNameBis = variable + "_value";

  const findSubModelFromVarName_t props = findSubModel(modelName, variable);
  const shared_ptr<SubModel>& subModel = props.subModel_;

  curve->setAvailable(false);

  if (subModel) {
    if (!props.isNetwork_) {   // found model's ID in the composed models.
      if (props.isDynParam_) {   // case 2: curve's variable curve is a parameter in submodel
        Trace::debug() << DYNLog(AddingCurveParam, modelName, variable) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variable);
        curve->setAsParameterCurve(true);   // This is a parameter curve
        SubModel::addParameterCurve(curve);
      } else if (props.variableNameInSubModel_ == variable) {   // found exact curve name
        Trace::debug() << DYNLog(AddingCurve, modelName, variable) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variable);
        subModel->addCurve(curve);
      } else if (props.variableNameInSubModel_ == variableNameBis) {
        Trace::debug() << DYNLog(AddingCurveOutput, modelName, variable, variableNameBis) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variableNameBis);
        subModel->addCurve(curve);
      }
    } else {
      // BEGIN SEARCH IN NETWORK
      const shared_ptr<SubModel> modelNetwork = subModel;
      string name = modelName + "_" + variable;
      if (props.variableNameInSubModel_ == name) {
        Trace::debug() << DYNLog(AddingCurveOutput, modelName, variable, name) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(name);
        modelNetwork->addCurve(curve);
      } else {
        string name2 = name + "_value";
        if (props.variableNameInSubModel_ == name2) {   // find name2 = name_value
          Trace::debug() << DYNLog(AddingCurveOutput, modelName, variable, name2) << Trace::endline;
          curve->setAvailable(true);
          curve->setFoundVariableName(name2);
          modelNetwork->addCurve(curve);
        }
      }
    }
    // Register curve calculated var index in subModel, to optimize variable update during simulation
    if (curve->getAvailable() && curve->getCurveType() == Curve::CALCULATED_VARIABLE)
      curvesCalculatedVarIndexes_.push_back(std::make_pair(subModel, curve->getIndexCalculatedVarInSubModel()));
  }
  if (!curve->getAvailable())
    Trace::warn() << DYNLog(CurveNotAdded, modelName, variable) << Trace::endline;
  return curve->getAvailable();
}

void
ModelMulti::updateCalculatedVarForCurves() const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::updateCurves");
#endif
  for (const auto& itSubModelIndex : curvesCalculatedVarIndexes_) {
    boost::shared_ptr<SubModel> subModel = itSubModelIndex.first;
    unsigned varNum = itSubModelIndex.second;
    if (!subModel ) continue;
    subModel->updateCalculatedVar(varNum);
  }
}

void ModelMulti::printVariableNames(const bool withVariableType) {
  Trace::clearLogFile(Trace::variables(), DEBUG);
  Trace::printDynawoLogHeader(Trace::variables());
  int nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    const auto& xNameInit = subModel->xNamesInit();
    for (unsigned int j = 0; j < xNameInit.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << subModel->name() << " ¦ " << xNameInit[j] << " (local " << j << ")" << Trace::endline;
       ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X calculated variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    const auto& xCalculatedVarNameInit = subModel->getCalculatedVarNamesInit();
    for (unsigned int j = 0; j < xCalculatedVarNameInit.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << subModel->name() << " ¦ " << xCalculatedVarNameInit[j] << " (local " << j << ")" << Trace::endline;
       ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "Z variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    const auto& zNameInit = subModel->zNamesInit();
    for (unsigned int j = 0; j < zNameInit.size(); ++j) {
      Trace::debug(Trace::variables()) << nVar << " " << subModel->name() << " ¦ " << zNameInit[j] << " (local " << j << ")" << Trace::endline;
      ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  if (withVariableType)
    Trace::debug(Trace::variables()) << "X variables (with initial type)" << Trace::endline;
  else
    Trace::debug(Trace::variables()) << "X variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  const std::vector<propertyContinuousVar_t>& modelYType = getYType();
  for (const auto& subModel : subModels_) {
    const auto& xNames = subModel->xNames();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
      const std::string varName = subModel->name() + " ¦ " + xNames[j];
      if (withVariableType) {
        Trace::debug(Trace::variables()) << nVar << " " << varName << " (local " << j << ")" << " ¦ " << propertyVar2Str(modelYType[nVar]) << Trace::endline;
      } else {
        Trace::debug(Trace::variables()) << nVar << " " << varName << " (local " << j << ")" << Trace::endline;
      }
      ++nVar;
    }
  }
  for (const auto& subModel : subModels_) {
    for (const auto& xAliasNamePair : subModel->xAliasesNames()) {
      Trace::debug(Trace::variables()) << subModel->name() << " ¦ " << xAliasNamePair.first << " is an alias of " <<
          subModel->name() << " ¦ " << xAliasNamePair.second.first << " (negated: " << xAliasNamePair.second.second << ")" << Trace::endline;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X calculated variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    const auto& calculatedVarNames = subModel->getCalculatedVarNames();
    for (unsigned int j = 0; j < calculatedVarNames.size(); ++j) {
      const std::string varName = subModel->name() + " ¦ " + calculatedVarNames[j];
      Trace::debug(Trace::variables()) << nVar << " " << varName << " (local " << j << ")" << Trace::endline;
      ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "Z variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    const auto& zNames = subModel->zNames();
    for (unsigned int j = 0; j < zNames.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << subModel->name() << " ¦ " << zNames[j] << " (local " << j << ")" << Trace::endline;
       ++nVar;
    }
  }
  for (const auto& subModel : subModels_) {
    for (const auto& zAliasNamePair : subModel->zAliasesNames()) {
      Trace::debug(Trace::variables()) << subModel->name() << " ¦ " << zAliasNamePair.first << " is an alias of "
          << subModel->name() << "_" << zAliasNamePair.second.first << " (negated: " << zAliasNamePair.second.second << ")" << Trace::endline;
    }
  }
}

void ModelMulti::printEquations() {
  const bool isInitProcessBefore = subModels_[0]->getIsInitProcess();
  setIsInitProcess(true);
  int nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Equations init" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    for (unsigned int j = 0 ; j < subModel->sizeFInit() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModel->getFequationByLocalIndex(j) <<
          " model: " << subModel->name() << " (local " << j << ")" <<  Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(false);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Equations" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    for (unsigned int j = 0 ; j < subModel->sizeF() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModel->getFequationByLocalIndex(j) <<
          " model: " << subModel->name() << " (local " << j << ")" << Trace::endline;
      ++nVar;
    }
  }
  connectorContainer_->printEquations();
  nVar += connectorContainer_->nbContinuousConnectors();
  std::unordered_set<int> ignoreY;
  std::string subModelName;
  for (const auto numVarOptionnal : numVarsOptional_) {
    Trace::debug(Trace::equations()) << nVar << " optional connection " << getVariableName(numVarOptionnal, ignoreY, subModelName) << " model: " << subModelName << Trace::endline;
    ++nVar;
  }

  setIsInitProcess(true);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Roots init" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    for (unsigned int j = 0 ; j < subModel->sizeGInit() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModel->getGequationByLocalIndex(j) <<
          " model: " << subModel->name() << " (local " << j << ")" <<  Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(false);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Roots" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    for (unsigned int j = 0 ; j < subModel->sizeG() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << subModel->getGequationByLocalIndex(j) <<
          " model: " << subModel->name() << " (local " << j << ")" << Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(isInitProcessBefore);
}

void ModelMulti::printEquations(const std::unordered_set<int>& ignoreF, bool clearLogFile) {
  static int nbPrint = 0;
  if (clearLogFile) {
    Trace::clearLogFile(Trace::equations(), DEBUG);
  }
  int numEqFull = 0;
  int numEqSubset = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Equations (subset) " << nbPrint << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    for (unsigned int j = 0 ; j < subModel->sizeF() ; ++j) {
      if (ignoreF.find(numEqFull) == ignoreF.end()) {
        Trace::debug(Trace::equations()) << numEqSubset << " " << subModel->getFequationByLocalIndex(j) <<
    " model: " << subModel->name() << " (local " << j << ")" << Trace::endline;
        ++numEqSubset;
      }
      ++numEqFull;
    }
  }
  ++nbPrint;
  const int offSetModel = connectorContainer_->getOffsetModel();
  connectorContainer_->setOffsetModel(numEqSubset);
  connectorContainer_->printEquations();
  connectorContainer_->setOffsetModel(offSetModel);
  numEqSubset += connectorContainer_->nbContinuousConnectors();
  std::unordered_set<int> ignoreY;
  std::string subModelName;
  for (const auto numVarOptionnal : numVarsOptional_) {
    Trace::debug(Trace::equations()) << numEqSubset << " optional connection " << getVariableName(numVarOptionnal, ignoreY, subModelName) << " model: "
      << subModelName << Trace::endline;
    ++numEqSubset;
  }
}

void ModelMulti::printVariableNames(const std::unordered_set<int>& ignoreY, bool clearLogFile) {
  static int nbPrint = 0;
  if (clearLogFile) {
    Trace::clearLogFile(Trace::variables(), DEBUG);
  }
  int numVarFull = 0;
  int numVarSubset = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "Variables (subset) " << nbPrint << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (const auto& subModel : subModels_) {
    const std::vector<std::string>& xNames = subModel->xNames();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
      if (ignoreY.find(numVarFull) == ignoreY.end()) {
        std::string varName = subModel->name() + " | " + xNames[j];
        Trace::debug(Trace::variables()) << numVarSubset << " " << varName << " (local " << j << ")" << Trace::endline;
        ++numVarSubset;
      }
      ++numVarFull;
    }
  }
  ++nbPrint;
}

void ModelMulti::printLocalInitParametersValues() const {
  for (const auto& subModel : subModels_)
    subModel->printLocalInitParametersValues();
}

std::string ModelMulti::getVariableName(const int index) {
  // At the first call we construct the association
  if (yNames_.empty()) {
    for (const auto& subModel : subModels_) {
      for (const auto& xName : subModel->xNames()) {
        std::string varName = subModel->name() + "_" + xName;
        yNames_.push_back(varName);
      }
    }
  }
  assert(index < static_cast<int>(yNames_.size()));
  return yNames_[index];
}

std::string ModelMulti::getVariableName(const int index, const std::unordered_set<int>& ignoreY, std::string& subModelName) const {
  int numVarFull = 0;
  int numVarSubset = 0;
  std::string varName;
  for (const auto& subModel : subModels_) {
    const std::vector<std::string>& xNames = subModel->xNames();
    for (const auto& xName : xNames) {
      if (ignoreY.find(numVarFull) == ignoreY.end()) {
        if (index == numVarSubset) {
          if (varName.empty()) {
            varName = subModel->name() + "_" + xName;
            subModelName = subModel->name();
          }
          break;
        }
        ++numVarSubset;
      }
      ++numVarFull;
    }
    if (index == numVarSubset) {
      break;
    }
  }
  return varName;
}

void ModelMulti::getCurrentZ(vector<double>& z) const {
  z.assign(zLocal_.begin(), zLocal_.end());
}

void ModelMulti::setCurrentZ(const vector<double>& z) {
  assert(z.size() == static_cast<size_t>(sizeZ()));
  std::copy(z.begin(), z.end(), zLocal_.begin());
}

void ModelMulti::setLocalInitParameters(const std::shared_ptr<parameters::ParametersSet>& localInitParameters) {
  localInitParameters_ = localInitParameters;
}

void ModelMulti::registerAction(const string& actionString) {
  if (!actionBuffer_)
    return;

  // --- Parse the action string
  std::istringstream stream(actionString);
  string token;
  string subModelName;

  // Read the model name (first part before the first comma)
  std::getline(stream, subModelName, ',');

  const boost::shared_ptr<SubModel> subModel = findSubModelByName(subModelName);
  if (!subModel) {
    Trace::warn() << DYNLog(ActionUnknownSubModel, subModelName) << Trace::endline;
    return;
  }

  Action::ActionParameters parameterValueSet;
  // Read the rest of the parameter-value pairs
  while (std::getline(stream, token, ',')) {
    string paramName = token;
    string value;

    if (std::getline(stream, token, ',')) {
        value = token;
    } else {
      string shortAction = (actionString.size() > 40) ? actionString.substr(0, 40) + "..." : actionString;
      Trace::warn() << DYNLog(ActionUnparsable, shortAction) << Trace::endline;
      return;
    }

    if (subModel->hasParameterDynamic(paramName)) {
      const ParameterModeler& parameter = subModel->findParameterDynamic(paramName);
      boost::any castedValue;
      switch (parameter.getValueType()) {
        case VAR_TYPE_DOUBLE: {
          castedValue = std::stod(value);
          break;
        }
        case VAR_TYPE_INT: {
          castedValue = std::stoi(value);
          break;
        }
        case VAR_TYPE_BOOL: {
          bool bval = std::stoi(value);
          castedValue = bval;
          break;
        }
        case VAR_TYPE_STRING: {
          castedValue = value;
          break;
        }
        default:
        {
          throw DYNError(Error::MODELER, ParameterBadType, parameter.getName());
        }
      }

      parameterValueSet.push_back(std::make_tuple(paramName, castedValue, parameter.getValueType()));
    } else {
      Trace::warn() << DYNLog(ActionParameterNotFound, paramName) << Trace::endline;
      return;
    }
  }
  // --- Add to buffer
  actionBuffer_->addAction(subModel, parameterValueSet);
}

}  // namespace DYN
