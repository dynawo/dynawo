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
using boost::shared_ptr;
using boost::dynamic_pointer_cast;
using timeline::Timeline;
using curves::Curve;
using curves::Point;
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
silentZInitialized_(false) {
  connectorContainer_.reset(new ConnectorContainer());
}

ModelMulti::~ModelMulti() {
  if (zConnectedLocal_ != nullptr) {
    delete[] zConnectedLocal_;
    zConnectedLocal_ = nullptr;
  }
}

void
ModelMulti::setTimeline(const shared_ptr<Timeline>& timeline) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->setTimeline(timeline);
}

void
ModelMulti::setConstraints(const std::shared_ptr<ConstraintsCollection>& constraints) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->setConstraints(constraints);
}

void
ModelMulti::setWorkingDirectory(const string& workingDirectory) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->setWorkingDirectory(workingDirectory);
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

  subModelByName_[sub->name()] = subModels_.size();
  if (libName != "") {
    subModelByLib_[libName].push_back(sub);
  }
  subModels_.push_back(sub);
}

void
ModelMulti::initBuffers() {
  // (1) Get size of each sub models
  // -------------------------------
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->initSize(sizeY_, sizeZ_, sizeMode_, sizeF_, sizeG_);

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
    int sizeY = subModels_[i]->sizeY();
    if (sizeY > 0)
      subModels_[i]->setBufferY(yLocal_.data(), ypLocal_.data(), offsetY);
    offsetY += sizeY;

    int sizeF = subModels_[i]->sizeF();
    if (sizeF > 0) {
      subModels_[i]->setBufferF(fLocal_.data(), offsetF);
      for (int j = offsetF; j < offsetF + sizeF; ++j)
        mapAssociationF_[j] = i;

      offsetF += sizeF;
    }

    int sizeG = subModels_[i]->sizeG();
    if (sizeG > 0) {
      subModels_[i]->setBufferG(gLocal_.data(), offsetG);
      for (int j = offsetG; j < offsetG + sizeG; ++j)
        mapAssociationG_[j] = i;

      offsetG += sizeG;
    }

    int sizeZ = subModels_[i]->sizeZ();
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    (*it)->initSubBuffers();
    (*it)->releaseElements();
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->initSub(t0, localInitParameters_);

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

    for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
      (*it)->evalZSub(t0);

    for (unsigned j = 0; j < 10 && propagateZModif() != NO_Z_CHANGE; ++j) {
      for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
        (*it)->evalGSub(t0);
      for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
        (*it)->evalZSub(t0);
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->printModel();

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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->printParameterValues();
}

void
ModelMulti::rotateBuffers() {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->rotateBuffers();
}

void
ModelMulti::printMessages() {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->printMessages();
}

void
ModelMulti::printModelValues(const string& directory, const string& dumpFileName) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->printModelValues(directory, dumpFileName);
}

void
ModelMulti::printInitModelValues(const string& directory, const string& dumpFileName) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->printInitModelValues(directory, dumpFileName);
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    if ((*it)->sizeF() != 0)
      (*it)->evalFSub(t);
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

  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
      (*it)->evalFDiffSub(t);
  }
  std::copy(fLocal_.begin(), fLocal_.end(), f);
}

void
ModelMulti::evalFMode(const double t, const double* y, const double* yp, double* f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalFMode");
#endif
  copyContinuousVariables(y, yp);

  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    if (subModels_[i]->modeChange()) {
      subModels_[i]->evalFSub(t);
      std::unordered_map<size_t, std::vector<size_t > >::const_iterator it = subModelIdxToConnectorCalcVarsIdx_.find(i);
      if (it != subModelIdxToConnectorCalcVarsIdx_.end()) {
        const std::vector<size_t >& connectorsIdx = it->second;
        for (size_t j = 0, jEnd = connectorsIdx.size(); j < jEnd; ++j) {
          subModels_[connectorsIdx[j]]->evalFSub(t);
        }
      }
    }
  }

  connectorContainer_->evalFConnector(t);

  std::copy(fLocal_.begin(), fLocal_.end(), f);
}

void
ModelMulti::evalG(double t, vector<state_g>& g) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalG");
#endif
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->evalGSub(t);

  std::copy(gLocal_.begin(), gLocal_.end(), g.begin());
}

void
ModelMulti::evalJt(const double t, const double cj, SparseMatrix& Jt) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalJt");
#endif
  int rowOffset = 0;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    (*it)->evalJtSub(t, cj, Jt, rowOffset);
    if (!Jt.withoutNan() || !Jt.withoutInf()) {
      throw DYNError(Error::MODELER, SparseMatrixWithNanInf, (*it)->modelType(), (*it)->name());
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    (*it)->evalJtPrimSub(t, cj, JtPrim, rowOffset);
    if (!JtPrim.withoutNan() || !JtPrim.withoutInf()) {
      throw DYNError(Error::MODELER, SparseMatrixWithNanInf, (*it)->modelType(), (*it)->name());
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->evalZSub(t);

  // propagation of z changes to connected variables
  if (zSave_.size() != static_cast<size_t>(sizeZ()))
    zSave_.assign(sizeZ(), 0.);

  silentZChange_ = propagateZModif();
}

zChangeType_t
ModelMulti::propagateZModif() {
  vector<int> indicesDiff;
  zChangeType_t zChangeType = NO_Z_CHANGE;
  for (std::size_t i = 0, iEnd = nonSilentZIndexes_.size(); i < iEnd; ++i) {
    if (!std::isnan(zLocal_[nonSilentZIndexes_[i]]) && !std::isnan(zSave_[nonSilentZIndexes_[i]])) {
      if (doubleNotEquals(zLocal_[nonSilentZIndexes_[i]], zSave_[nonSilentZIndexes_[i]])) {
        indicesDiff.push_back(static_cast<int>(nonSilentZIndexes_[i]));
        zChangeType = NOT_SILENT_Z_CHANGE;
      }
    } else {
      throw DYNError(Error::MODELER, ZValueIsNaN, nonSilentZIndexes_[i]);
    }
  }
  // test values of discrete variables that are not used to compute continuous equations
  // and raise the flag NotUsedInContinuousEquations if at least one has changed
  // If at least one non silent Z has changed then the flag is never raised
  for (std::size_t i = 0, iEnd = notUsedInContinuousEqSilentZIndexes_.size(); i < iEnd; ++i) {
    if (!std::isnan(zLocal_[notUsedInContinuousEqSilentZIndexes_[i]]) && !std::isnan(zSave_[notUsedInContinuousEqSilentZIndexes_[i]])) {
      if (doubleNotEquals(zLocal_[notUsedInContinuousEqSilentZIndexes_[i]], zSave_[notUsedInContinuousEqSilentZIndexes_[i]])) {
        indicesDiff.push_back(static_cast<int>(notUsedInContinuousEqSilentZIndexes_[i]));
        if (zChangeType != NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE && zChangeType != NOT_SILENT_Z_CHANGE)
          zChangeType = NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE;
      }
    } else {
      throw DYNError(Error::MODELER, ZValueIsNaN, notUsedInContinuousEqSilentZIndexes_[i]);
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
    for (std::size_t i = 0, iEnd = notUsedInDiscreteEqSilentZIndexes_.size(); i < iEnd; ++i) {
      if (!std::isnan(zLocal_[notUsedInDiscreteEqSilentZIndexes_[i]]) && !std::isnan(zSave_[notUsedInDiscreteEqSilentZIndexes_[i]])) {
        if (doubleNotEquals(zLocal_[notUsedInDiscreteEqSilentZIndexes_[i]], zSave_[notUsedInDiscreteEqSilentZIndexes_[i]])) {
          std::copy(zLocal_.begin(), zLocal_.end(), zSave_.begin());
          return NOT_USED_IN_DISCRETE_EQ_Z_CHANGE;
        }
      } else {
        throw DYNError(Error::MODELER, ZValueIsNaN, notUsedInDiscreteEqSilentZIndexes_[i]);
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
  const std::vector<double> z(zLocal_);
#endif
  modeChange_ = false;
  modeChangeType_t modeChangeType = NO_MODE;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    modeChangeType_t modeChangeTypeSub = (*it)->evalModeSub(t);
    if (modeChangeTypeSub > modeChangeType)
      modeChangeType = modeChangeTypeSub;
    if ((*it)->modeChange()) {
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    (*it)->modeChange(false);
    (*it)->setModeChangeType(NO_MODE);
  }
}

void
ModelMulti::notifyTimeStep() {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    (*it)->notifyTimeStep();
  }
}

void
ModelMulti::evalCalculatedVariables(const double t, const vector<double>& y, const vector<double>& yp, const vector<double>& z) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::evalCalculatedVariables");
#endif
  yLocal_.assign(y.begin(), y.end());
  ypLocal_.assign(yp.begin(), yp.end());
  zLocal_.assign(z.begin(), z.end());

  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->evalCalculatedVariablesSub(t);
}

void
ModelMulti::checkParametersCoherence() const {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->checkParametersCoherence();
}

void
ModelMulti::checkDataCoherence(const double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::checkDataCoherence");
#endif

  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->checkDataCoherenceSub(t);
}

void
ModelMulti::setFequationsModel() {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->setFequationsSub();
}

void
ModelMulti::setGequationsModel() {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->setGequationsSub();
}

void
ModelMulti::initSilentZ(bool enableSilentZ) {
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    (*it)->getY0Sub();
    (*it)->evalCalculatedVariablesSub(t0);
  }
  connectorContainer_->getY0Connector();

  std::copy(yLocal_.begin(), yLocal_.end(), y0.begin());
  std::copy(ypLocal_.begin(), ypLocal_.end(), yp0.begin());
}

void
ModelMulti::evalStaticYType() {
  yType_.resize(sizeY_);
  int offsetYType = 0;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    int sizeYType = (*it)->sizeY();
    if (sizeYType > 0) {
      (*it)->setBufferYType(yType_.data(), offsetYType);
      (*it)->evalStaticYType();
      offsetYType += sizeYType;
    }
  }
}

void
ModelMulti::evalDynamicYType() {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    int sizeYType = (*it)->sizeY();
    if (sizeYType > 0)
      (*it)->evalDynamicYType();
  }
}

void
ModelMulti::evalStaticFType() {
  fType_.resize(sizeF_);
  int offsetFType = 0;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    int sizeFType = (*it)->sizeF();
    if (sizeFType > 0) {
      (*it)->setBufferFType(fType_.data(), offsetFType);
      (*it)->evalStaticFType();
      offsetFType += sizeFType;
    }
  }
  connectorContainer_->setBufferFType(fType_.data(), offsetFType);
  connectorContainer_->evalStaticFType();
  std::fill(fType_.begin() + offsetFOptional_, fType_.begin() + sizeF_, ALGEBRAIC_EQ);
}

void
ModelMulti::evalDynamicFType() {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    int sizeFType = (*it)->sizeF();
    if (sizeFType > 0)
      (*it)->evalDynamicFType();
  }
  // connectors equations (A = B) can't change during the simulation so we don't need to update them.
}

void
ModelMulti::dumpParameters(std::map< string, string >& mapParameters) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->dumpParameters(mapParameters);
}

void
ModelMulti::dumpVariables(std::map< string, string >& mapVariables) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->dumpVariables(mapVariables);
}

void
ModelMulti::getModelParameterValue(const string& curveModelName, const string& curveVariable, double& value, bool& found) {
  shared_ptr<SubModel> subModel = findSubModelByName(curveModelName);
  if (subModel) {
    std::string strValue;
    subModel->getSubModelParameterValue(curveVariable, strValue, found);
    if (found) {
      value = stod(strValue);
      return;
    }
  }
  Trace::warn() << DYNLog(ModelMultiParamNotFound, curveModelName, curveVariable) << Trace::endline;
  return;
}

void
ModelMulti::loadParameters(const std::map< string, string >& mapParameters) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->loadParameters(mapParameters);
}

void
ModelMulti::loadVariables(const std::map< string, string >& mapVariables) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->loadVariables(mapVariables);
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
  } else if (!isState1 && isState2) {  // when one variable is a state variable and the other one isn't, use a specific connection
    if (typeVar2 != CONTINUOUS && typeVar2 != FLOW && typeVar2 != DISCRETE && typeVar2 != INTEGER) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }
    createCalculatedVariableConnection(subModel1, variable1, subModel2, variable2);
  } else if (isState1 && (!isState2)) {
    if (typeVar1 != CONTINUOUS && typeVar1 != FLOW && typeVar1 != DISCRETE && typeVar1 != INTEGER) {
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
  string name = subModel1->name()+"_"+calculatedVarName1;
  if (variable1->isAlias())
    name = subModel1->name()+"_"+subModel1->getCalculatedVarName(variable1->getIndex());
  boost::shared_ptr<SubModel> subModelConnector = findSubModelByName(name);
  if (!subModelConnector) {
    // Multiple connection to the same connector can happen with flow connections
    subModelConnector = (variable1->getType() == DISCRETE ||  variable1->getType() == INTEGER)?
                    setConnector(shared_ptr<ConnectorCalculatedDiscreteVariable>(new ConnectorCalculatedDiscreteVariable()), name, subModel1, variable1) :
                    setConnector(shared_ptr<ConnectorCalculatedVariable>(new ConnectorCalculatedVariable()), name, subModel1, variable1);
    addSubModel(subModelConnector, "");  // no library for connectors
    subModelIdxToConnectorCalcVarsIdx_[subModelByName_[subModel1->name()]].push_back(subModels_.size() - 1);
  }

  createConnection(subModel2, variable2->getName(), subModelConnector, string("connector_" + name));
}

boost::shared_ptr<SubModel>
ModelMulti::findSubModelByName(const string& name) const {
  std::unordered_map<string, size_t >::const_iterator iter = subModelByName_.find(name);
  if (iter == subModelByName_.end())
    return (shared_ptr<SubModel>());
  else
    return subModels_[iter->second];
}

vector<boost::shared_ptr<SubModel> >
ModelMulti::findSubModelByLib(const string& libName) {
  std::unordered_map<string, vector<shared_ptr<SubModel> > >::const_iterator iter = subModelByLib_.find(libName);
  if (iter == subModelByLib_.end())
    return (vector<shared_ptr<SubModel> >());
  else
    return iter->second;
}

bool
ModelMulti::checkConnects() {
  bool connectOk = true;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const vector<string>& names = (*it)->xNames();
    const int yDeb = (*it)->yDeb();
    for (unsigned int j = 0; j < (*it)->sizeY(); ++j) {
      if (yType_[yDeb + j] == EXTERNAL) {
        const bool isConnected = connectorContainer_->isConnected(yDeb + j);
        if (!isConnected) {
          Trace::info() << DYNLog(SubModelExtVar, (*it)->name(), names[j]) << Trace::endline;
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
    std::unordered_map<int, int>::const_iterator iter = mapAssociationF_.find(globalFIndex);
    if (iter != mapAssociationF_.end()) {
      subModelName = subModels_[iter->second]->name();
      localFIndex = globalFIndex - subModels_[iter->second]->fDeb();
      fEquation = subModels_[iter->second]->getFequationByLocalIndex(localFIndex);
    }
  }
}

void
ModelMulti::getGInfos(const int globalGIndex, string& subModelName, int& localGIndex, string& gEquation) const {
  std::unordered_map<int, int>::const_iterator iter = mapAssociationG_.find(globalGIndex);
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

  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->setIsInitProcess(isInitProcess);
}

void
ModelMulti::setInitialTime(const double t0) {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it)
    (*it)->setCurrentTime(t0);
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
  nonSilentZIndexes_.clear();
  notUsedInDiscreteEqSilentZIndexes_.clear();
  nonSilentZIndexes_.clear();
  unsigned offsetZ = 0;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    int sizeZ = (*it)->sizeZ();
    if (sizeZ > 0)
      (*it)->collectSilentZ(&silentZ_[offsetZ]);
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
ModelMulti::initCurves(std::shared_ptr<curves::Curve>& curve) {
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
ModelMulti::updateCalculatedVarForCurves(std::shared_ptr<curves::CurvesCollection>& curvesCollection) const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::updateCurves");
#endif
  for (curves::CurvesCollection::iterator itCurve = curvesCollection->begin(), itCurveEnd = curvesCollection->end();
      itCurve != itCurveEnd; ++itCurve) {
    std::shared_ptr<Curve> curve = *itCurve;
    shared_ptr<SubModel> subModel = findSubModel(curve->getModelName(), curve->getVariable()).subModel_;
    if (subModel) {
      subModel->updateCalculatedVarForCurve(curve);
    }
  }
}

vector<shared_ptr<Point> >
ModelMulti::getLastCurvesValues(shared_ptr<curves::CurvesCollection>& curvesCollection) const {
  vector<shared_ptr<Point>> v;
  for (curves::CurvesCollection::iterator itCurve = curvesCollection->begin(), itCurveEnd = curvesCollection->end();
      itCurve != itCurveEnd; ++itCurve) {
    if ((*itCurve)->getAvailable()) {
      v.push_back((*itCurve)->getLastPoint());
    }
  }
  return v;
}

vector<string>
ModelMulti::getCurvesNames(shared_ptr<curves::CurvesCollection>& curvesCollection) const {
  vector<string> v;
  for (curves::CurvesCollection::iterator itCurve = curvesCollection->begin(), itCurveEnd = curvesCollection->end();
      itCurve != itCurveEnd; ++itCurve) {
    if ((*itCurve)->getAvailable()) {
      string curveName =  (*itCurve)->getModelName() + "_" + (*itCurve)->getVariable();
      v.push_back(curveName);
    }
  }
  return v;
}

void ModelMulti::printVariableNames(bool withVariableType) {
  Trace::clearLogFile(Trace::variables(), DEBUG);
  Trace::printDynawoLogHeader(Trace::variables());
  int nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::string>& xNames = (*it)->xNamesInit();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << (*it)->name() << " | " << xNames[j] << Trace::endline;
       ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X calculated variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::string>& xNames = (*it)->getCalculatedVarNamesInit();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << (*it)->name() << " | " << xNames[j] << Trace::endline;
       ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "Z variables init" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::string>& zNames = (*it)->zNamesInit();
    for (unsigned int j = 0; j < zNames.size(); ++j) {
      Trace::debug(Trace::variables()) << nVar << " " << (*it)->name() << " | " << zNames[j] << Trace::endline;
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::string>& xNames = (*it)->xNames();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
      std::string varName = (*it)->name() + " | " + xNames[j];
      if (withVariableType) {
        Trace::debug(Trace::variables()) << nVar << " " << varName << " | " << propertyVar2Str(modelYType[nVar]) << Trace::endline;
      } else {
        Trace::debug(Trace::variables()) << nVar << " " << varName << Trace::endline;
      }
      ++nVar;
    }
  }
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::pair<std::string, std::pair<std::string, bool > > >& xAlias = (*it)->xAliasesNames();
    for (unsigned int j = 0; j < xAlias.size(); ++j) {
      Trace::debug(Trace::variables()) << (*it)->name() << " | " << xAlias[j].first << " is an alias of " <<
          (*it)->name() << " | " << xAlias[j].second.first << " (negated: " << xAlias[j].second.second << ")" << Trace::endline;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "X calculated variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::string>& xNames = (*it)->getCalculatedVarNames();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
      std::string varName = (*it)->name() + " | " + xNames[j];
      Trace::debug(Trace::variables()) << nVar << " " << varName << Trace::endline;
      ++nVar;
    }
  }
  nVar = 0;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::variables()) << "Z variables" << Trace::endline;
  Trace::debug(Trace::variables()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::string>& zNames = (*it)->zNames();
    for (unsigned int j = 0; j < zNames.size(); ++j) {
       Trace::debug(Trace::variables()) << nVar << " " << (*it)->name() << " | " << zNames[j] << Trace::endline;
       ++nVar;
    }
  }
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    const std::vector<std::pair<std::string, std::pair<std::string, bool > > >& zAlias = (*it)->zAliasesNames();
    for (unsigned int j = 0; j < zAlias.size(); ++j) {
      Trace::debug(Trace::variables()) << (*it)->name() << " | " << zAlias[j].first << " is an alias of "
          << (*it)->name() << "_" << zAlias[j].second.first << " (negated: " << zAlias[j].second.second << ")" << Trace::endline;
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
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    for (unsigned int j = 0 ; j < (*it)->sizeFInit() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << (*it)->getFequationByLocalIndex(j) <<
          " model: " << (*it)->name() <<  Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(false);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Equations" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    for (unsigned int j = 0 ; j < (*it)->sizeF() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << (*it)->getFequationByLocalIndex(j) <<
          " model: " << (*it)->name() << Trace::endline;
      ++nVar;
    }
  }
  connectorContainer_->printEquations();

  setIsInitProcess(true);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Roots init" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    for (unsigned int j = 0 ; j < (*it)->sizeGInit() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << (*it)->getGequationByLocalIndex(j) <<
          " model: " << (*it)->name() <<  Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(false);
  nVar = 0;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::equations()) << "Roots" << Trace::endline;
  Trace::debug(Trace::equations()) << "------------------------------" << Trace::endline;
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    for (unsigned int j = 0 ; j < (*it)->sizeG() ; ++j) {
      Trace::debug(Trace::equations()) << nVar << " " << (*it)->getGequationByLocalIndex(j) <<
          " model: " << (*it)->name() << Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(isInitProcessBefore);
}

void ModelMulti::printLocalInitParametersValues() const {
  for (std::vector<boost::shared_ptr<DYN::SubModel> >::const_iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
    (*it)->printLocalInitParametersValues();
  }
}

std::string ModelMulti::getVariableName(int index) {
  // At the first call we construct the association
  if (yNames_.empty()) {
    std::string varName;
    for (std::vector<boost::shared_ptr<DYN::SubModel> >::iterator it = subModels_.begin(); it != subModels_.end(); ++it) {
      const std::vector<std::string>& xNames = (*it)->xNames();
      for (unsigned int j = 0; j < xNames.size(); ++j) {
        varName = (*it)->name() + "_" + xNames[j];
        yNames_.push_back(varName);
      }
    }
  }
  assert(index < static_cast<int>(yNames_.size()));
  return yNames_[index];
}

void ModelMulti::getCurrentZ(vector<double>& z) const {
  z.assign(zLocal_.begin(), zLocal_.end());
}

void ModelMulti::setCurrentZ(const vector<double>& z) {
  assert(z.size() == static_cast<size_t>(sizeZ()));
  std::copy(z.begin(), z.end(), zLocal_.begin());
}

void ModelMulti::setLocalInitParameters(std::shared_ptr<parameters::ParametersSet> localInitParameters) {
  localInitParameters_ = localInitParameters;
}

}  // namespace DYN
