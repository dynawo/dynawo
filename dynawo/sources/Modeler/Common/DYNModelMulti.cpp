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
#include "DYNVariable.h"
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
zChange_(false),
silentZChange_(false),
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
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->initSize(sizeY_, sizeZ_, sizeMode_, sizeF_, sizeG_);


  connectorContainer_->mergeConnectors();
  evalYType();

  numVarsOptional_.clear();
  for (int i = 0; i < sizeY_; ++i) {
    if (yType_[i] == OPTIONAL_EXTERNAL) {
      const bool isConnected = connectorContainer_->isConnected(i);
      if (!isConnected) {
        numVarsOptional_.insert(i);
      }
    }
  }

  connectorContainer_->setOffsetModel(sizeF_);
  connectorContainer_->setSizeY(sizeY_);
  sizeF_ += connectorContainer_->nbContinuousConnectors();

  offsetFOptional_ = sizeF_;
  sizeF_ += numVarsOptional_.size();  /// fictitious equation will be added for unconnected optional external variables
  evalFType();

  // (2) Initialize buffers that would be used during the simulation (avoid copy)
  // ----------------------------------------------------------------------------
  fLocal_ = new double[sizeF_]();
  gLocal_ = new state_g[sizeG_]();
  yLocal_ = new double[sizeY_]();
  ypLocal_ = new double[sizeY_]();
  zLocal_ = new double[sizeZ_]();
  zConnectedLocal_ = new bool[sizeZ_];
  silentZ_ = new bool[sizeZ_];
  std::fill_n(zConnectedLocal_, sizeZ_, false);
  std::fill_n(silentZ_, sizeZ_, false);
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
ModelMulti::init(const double& t0) {
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

bool
ModelMulti::zChange() const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelMulti::zChange");
#endif
  return zChange_;
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
ModelMulti::evalG(double t, vector<state_g> &g) {
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

  zChange_ = propagateZModif();
}

bool
ModelMulti::propagateZModif() {
  vector<int> indicesDiff;
  silentZChange_ = false;
  for (int i = 0, iEnd = nonSilentZIndexes_.size(); i < iEnd; ++i) {
    if (doubleNotEquals(zLocal_[nonSilentZIndexes_[i]], zSave_[nonSilentZIndexes_[i]])) {
      indicesDiff.push_back(nonSilentZIndexes_[i]);
    }
  }
  if (!indicesDiff.empty()) {
    connectorContainer_->propagateZDiff(indicesDiff, zLocal_);
    std::copy(zLocal_, zLocal_ + sizeZ(), zSave_.begin());
    return true;
  } else {
    for (int i = 0, iEnd = silentZIndexes_.size(); i < iEnd; ++i) {
      if (doubleNotEquals(zLocal_[silentZIndexes_[i]], zSave_[silentZIndexes_[i]])) {
        silentZChange_ = true;
        std::copy(zLocal_, zLocal_ + sizeZ(), zSave_.begin());
        return false;
      }
    }
  }
  return false;
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
  if (modeChangeType > modeChangeType_)
    modeChangeType_ = modeChangeType;
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
ModelMulti::evalCalculatedVariables(const double & t, const vector<double> &y, const vector<double> &yp, const vector<double> &z) {
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
ModelMulti::checkDataCoherence(const double & t) {
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
ModelMulti::getY0(const double& t0, vector<double>& y0, vector<double>& yp0) {
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
ModelMulti::evalYType() {
  yType_ = new propertyContinuousVar_t[sizeY_]();
  int offsetYType = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeYType = subModels_[i]->sizeY();
    if (sizeYType > 0) {
      subModels_[i]->setBufferYType(yType_, offsetYType);
      subModels_[i]->evalYType();
      offsetYType += sizeYType;
    }
  }
}

void
ModelMulti::updateYType() {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeYType = subModels_[i]->sizeY();
    if (sizeYType > 0)
      subModels_[i]->updateYType();
  }
}

void
ModelMulti::evalFType() {
  fType_ = new propertyF_t[sizeF_]();
  int offsetFType = 0;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeFType = subModels_[i]->sizeF();
    if (sizeFType > 0) {
      subModels_[i]->setBufferFType(fType_, offsetFType);
      subModels_[i]->evalFType();
      offsetFType += sizeFType;
    }
  }
  connectorContainer_->setBufferFType(fType_, offsetFType);
  connectorContainer_->evalFType();
  std::fill(fType_ + offsetFOptional_, fType_ + sizeF_, ALGEBRAIC_EQ);
}

void
ModelMulti::updateFType() {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    int sizeFType = subModels_[i]->sizeF();
    if (sizeFType > 0)
      subModels_[i]->updateFType();
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
ModelMulti::connectElements(shared_ptr<SubModel> &subModel1, const string &name1, shared_ptr<SubModel> &subModel2, const string &name2) {
  vector<std::pair<string, string> > variablesToConnect;
  findVariablesConnectedBy(subModel1, name1, subModel2, name2, variablesToConnect);
  for (size_t i = 0, iEnd = variablesToConnect.size(); i < iEnd; ++i) {
    createConnection(subModel1, variablesToConnect[i].first, subModel2, variablesToConnect[i].second);
  }
}


void
ModelMulti::findVariablesConnectedBy(const boost::shared_ptr<SubModel> &subModel1, const std::string &name1,
    const boost::shared_ptr<SubModel> &subModel2, const std::string &name2, vector<std::pair<string, string> >& variables) const {
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
ModelMulti::createConnection(shared_ptr<SubModel> &subModel1, const string & name1, shared_ptr<SubModel> &subModel2, const string &name2,
                             bool forceConnection) {
  const shared_ptr <Variable> variable1 = subModel1->getVariable(name1);
  const shared_ptr <Variable> variable2 = subModel2->getVariable(name2);

  int num1 = variable1->getIndex();
  int num2 = variable2->getIndex();
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
    throw DYNError(Error::MODELER, ConnectorCalculatedVariables, subModel1->name(), name1, subModel2->name(), name2);
  } else if ((!isState1) && (isState2)) {  // when one variable is a state variable and the other one isn't, use a specific connection
    if (typeVar2 != CONTINUOUS && typeVar2 != FLOW) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }
    createCalculatedVariableConnection(subModel1, num1, subModel2, num2);
  } else if ((isState1) && (!isState2)) {
    if (typeVar1 != CONTINUOUS && typeVar1 != FLOW) {
      throw DYNError(Error::MODELER, ConnectorFail, subModel1->modelType(), name1, typeVar2Str(typeVar1), subModel2->modelType(), name2, typeVar2Str(typeVar2));
    }
    createCalculatedVariableConnection(subModel2, num2, subModel1, num1);
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
ModelMulti::createCalculatedVariableConnection(shared_ptr<SubModel> &subModel1, const int & numVar, shared_ptr<SubModel> &subModel2, const int &yNum) {
  string calculatedVarName1 = subModel1->getCalculatedVarName(numVar);
  shared_ptr<ConnectorCalculatedVariable> connector;
  string name = subModel1->name()+"_"+calculatedVarName1;
  boost::shared_ptr<SubModel> subModelConnector = findSubModelByName(name);
  if (!subModelConnector) {
    // Multiple connection to the same connector can happen with flow connections
    connector = shared_ptr<ConnectorCalculatedVariable>(new ConnectorCalculatedVariable());
    connector->name(name);
    connector->setVariableName(calculatedVarName1);
    connector->setParams(subModel1, numVar);
    subModelConnector = dynamic_pointer_cast<SubModel> (connector);
    addSubModel(subModelConnector, "");  // no library for connectors
    subModelIdxToConnectorCalcVarsIdx_[subModelByName_[subModel1->name()]].push_back(subModels_.size() - 1);
  }

  const vector<string>& xNames = subModel2->xNames();
  createConnection(subModel2, xNames[yNum], subModelConnector, string("connector_" + name));
}

boost::shared_ptr<SubModel>
ModelMulti::findSubModelByName(const string& name) {
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
    map<int, int>::const_iterator iter = mapAssociationF_.find(globalFIndex);
    if (iter != mapAssociationF_.end()) {
      subModelName = subModels_[iter->second]->name();
      localFIndex = globalFIndex - subModels_[iter->second]->fDeb();
      fEquation = subModels_[iter->second]->getFequationByLocalIndex(localFIndex);
    }
  }
}

void
ModelMulti::getGInfos(const int globalGIndex, string& subModelName, int& localGIndex, string& gEquation) {
  map<int, int>::const_iterator iter = mapAssociationG_.find(globalGIndex);
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
ModelMulti::setInitialTime(const double& t0) {
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->setCurrentTime(t0);
}

ModelMulti::findSubModelFromVarName_t
ModelMulti::findSubModel(const string& modelName, const string& variable) {
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
      silentZ_[i] = false;
    }
    if (silentZ_[i]) {
      silentZIndexes_.push_back(i);
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
ModelMulti::updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection> curvesCollection) {
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
    const std::vector<std::pair<std::string, std::string> >& xAlias = subModels_[i]->xAliasesNames();
    for (unsigned int j = 0; j < xAlias.size(); ++j) {
      Trace::debug(Trace::variables()) << subModels_[i]->name() << "_" << xAlias[j].first << " is an alias of " <<
          subModels_[i]->name() << "_" << xAlias[j].second << Trace::endline;
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
    const std::vector<std::pair<std::string, std::string> >& zAlias = subModels_[i]->zAliasesNames();
    for (unsigned int j = 0; j < zAlias.size(); ++j) {
      Trace::debug(Trace::variables()) << subModels_[i]->name() << "_" << zAlias[j].first << " is an alias of "
          << subModels_[i]->name() << "_" << zAlias[j].second << Trace::endline;
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

void ModelMulti::getCurrentZ(vector<double> &z) {
  z.assign(zLocal_, zLocal_ + sizeZ());
}

void ModelMulti::setCurrentZ(const vector<double> &z) {
  assert(z.size() == (size_t)sizeZ());
  std::copy(z.begin(), z.end(), zLocal_);
}
  /* =======================================================================================================================================*/
  /* ====================================================FUNCTIONS FOR MODAL ANALYSIS=======================================================*/
  /* =======================================================================================================================================*/

  // @brief return the names of dynamic devices associated to differential/algebraic variables
  // if var = 1, it returns the names of dynamic devices associated to differential variables
  // if var = 2, it returns the names of dynamic devices associated to algebraic variables
  // * @param t time to use for the evaluation
  // * @param var integer used to switch between the outputs
vector<string>
ModelMulti::getNameDynamicDevices(int var) {
  std::vector<std::string> nameDynDiff;  // vector of names of dynamic devices associated to differential variables
  std::vector<std::string> nameDynAlg;  // vector of names of dynamic devices associated to algebraic variables
  for (int i = 0; i < sizeY(); ++i) {
      if (yType_[i] == DYN::DIFFERENTIAL) {
          nameDynDiff.push_back(getVariableNameDevices(i));
      } else {
            nameDynAlg.push_back(getVariableNameDevices(i));
      }
  }
  switch (var) {
         case 1 : {
         return nameDynDiff;
         break;
         }
         case 2 : {
         return nameDynAlg;
         break;
         }
         default : {
         return nameDynDiff;
         }
  }
     nameDynDiff.clear();
     nameDynAlg.clear();
}


  // @brief construct the state matrix A,
  // * @param t time to use for the evaluation
MatrixXd
ModelMulti::getMatrixA(const double t) {
  if (!exists("Linearisation")) {
    create_directory("Linearisation");
  }
      // declaration of required variables
  vector<int> indexVarDiff;  // vector of indices of differential variables
  vector<int> indexVarAlg;  // vector of indices of algebraic variables
  vector<int> indexEquDiff;  // vector of indices of differential equations
  vector<int> indexEquAlg;  // vector of indices of algebraic variables
  std::vector<std::string> varAlgName;  // vector of names of algebraic variables
  std::vector<std::string> varDiffName;  // vector of names of differential variables
  MatrixXd Aold(sizeY(), sizeY());  // full matrix J
  MatrixXd Aold1(sizeY(), sizeY());  // full matrix Jprime
  MatrixXd Aold2(sizeY(), sizeY());  // full matrix J + cj*Jprime
  SparseMatrix Jt;  // matrix J in sparse form
  SparseMatrix Jt1;  // matrix Jprime in sparse form
  Jt1.init(sizeY(), sizeY());
  Jt.init(sizeY(), sizeY());
  // returns the matrix J + cj*Jprime
  evalJt(t, 1, Jt);
  Aold2 = Jt.fullMatrix();
  // returns the matrix Jprime
  evalJtPrim(t, 1, Jt1);
  Aold1 = Jt1.fullMatrix();
  // computes the matrix J
  Aold = Aold2 - Aold1;
  writeToFile(Aold, "Linearisation/Aold.txt");
  writeToFile(Aold1, "Linearisation/Aold1.txt");


  indexVarDiff = getIndexVariable(1);
  indexEquDiff = getIndexEquation(1);
  indexEquAlg = getIndexEquation(2);
  indexVarAlg = getIndexVariable(2);
  varAlgName = getNameVariable(2);
  varDiffName = getNameVariable(1);

  writeToFileStd(indexEquDiff, "Linearisation/file_equ_Diff.log");
  writeToFileStd(indexVarAlg, "Linearisation/file_var_alg.log");
  writeToFileStd(indexVarDiff, "Linearisation/file_var_Diff.log");
  writeToFileStd(indexEquAlg, "Linearisation/file_equ_alg.log");
  writeToFileString(varAlgName, "Linearisation/file_varAlgName.log");
  writeToFileString(varDiffName, "Linearisation/file_varDiffName.log");

  MatrixXd A11 = contructSubMatrix(Aold, indexVarDiff.size(), indexVarDiff.size(), indexEquDiff, indexVarDiff);
  writeToFile(A11, "Linearisation/A11.txt");
  MatrixXd A11prime = contructSubMatrix(Aold1, indexVarDiff.size(), indexVarDiff.size(), indexEquDiff, indexVarDiff);
  writeToFile(A11prime, "Linearisation/A11prime.txt");
  MatrixXd A12 = contructSubMatrix(Aold, indexVarDiff.size(), indexVarAlg.size(), indexEquDiff, indexVarAlg);
  writeToFile(A12, "Linearisation/A12.txt");
  MatrixXd A21 = contructSubMatrix(Aold, indexVarAlg.size(), indexVarDiff.size(), indexEquAlg, indexVarDiff);
  writeToFile(A21, "Linearisation/A21.txt");
  MatrixXd A22  = contructSubMatrix(Aold, indexVarAlg.size(), indexVarAlg.size(), indexEquAlg, indexVarAlg);
  writeToFile(A22, "Linearisation/A22.txt");
  MatrixXd A = -(A11prime.inverse())*A11 + (A11prime.inverse())*(A12*(A22.inverse())*A21);
  writeToFile(A, "Linearisation/A.txt");
  indexEquDiff.clear();
  indexEquAlg.clear();
  indexVarAlg.clear();
  indexVarDiff.clear();
  varDiffName.clear();
  varAlgName.clear();
  return A;
}
  // @brief construct the input matrix B
  // * @param t time to use for the evaluation
  // this function is not the final version, the input variable will be interfaced,
  // also all the functions must be tested in other cases and will be generalized
MatrixXd
ModelMulti::getMatrixB(const double t) {
  if (!exists("Linearisation")) {
     create_directory("Linearisation");
  }

  vector<int> indexVarDiff;  // vector of indices of differential variables
  vector<int> indexVarAlg;  // vector of indices of algebraic variables
  vector<int> indexEquDiff;  // vector of indices of differential equations
  vector<int> indexEquAlg;  // vector of indices of algebraic variables
  std::vector<std::string> varAlgName;  // vector of names of algebraic variables
  MatrixXd B;  // input matrix
  MatrixXd R;  // matrix used to extract the columns associated to the input variables
  MatrixXd Aold(sizeY(), sizeY());  // full matrix J
  MatrixXd Aold1(sizeY(), sizeY());  // full matrix Jprime
  MatrixXd Aold2(sizeY(), sizeY());  // full matrix J + cj*Jprime
  SparseMatrix Jt;  // matrix J in sparse form
  SparseMatrix Jt1;  // matrix Jprime in sparse form
  Jt1.init(sizeY(), sizeY());
  Jt.init(sizeY(), sizeY());
  // returns the matrix J + cj*Jprime
  evalJt(t, 1, Jt);
  Aold2 = Jt.fullMatrix();
  // returns the matrix Jprime
  evalJtPrim(t, 1, Jt1);
  Aold1 = Jt1.fullMatrix();
  // computes the matrix J
  Aold = Aold2 - Aold1;

  varAlgName = getNameVariable(2);
  indexVarDiff = getIndexVariable(1);
  indexEquDiff = getIndexEquation(1);
  indexEquAlg = getIndexEquation(2);
  indexVarAlg = getIndexVariable(2);
  MatrixXd A12 = contructSubMatrix(Aold, indexVarDiff.size(), indexVarAlg.size(), indexEquDiff, indexVarAlg);
  MatrixXd A22  = contructSubMatrix(Aold, indexVarAlg.size(), indexVarAlg.size(), indexEquAlg, indexVarAlg);
  MatrixXd A11prime = contructSubMatrix(Aold1, indexVarDiff.size(), indexVarDiff.size(), indexEquDiff, indexVarDiff);

  //  ================get the index positions of the input variable: "UsRefPu"==================================//
  vector<int> indexVref = getIndexPositionString(varAlgName, "URef");  // "UsRefPu");
  vector<int> indexVref0 = getIndexPositionString(varAlgName, "UsRefPu");  // "UsRefPu");
  indexVref.insert(indexVref.end(), indexVref0.begin(), indexVref0.end());
  R = Eigen::MatrixXd::Zero(varAlgName.size(), indexVref.size());
  for (unsigned int k = 0; k < indexVref.size(); k++) {
  for (unsigned int j = 0; j < varAlgName.size(); j++) {
     if (A22(j, indexVref[k]) > 0) {
        R(j, k) = 1;
     }
  }
  }

  //  ========================Compute the input matrix B===================================================//
  B = -(A11prime.inverse())*(A12*(A22.inverse())*R);

  // dump the matrices R and B
  writeToFile(R, "Linearisation/R.txt");
  writeToFile(B, "Linearisation/B1.txt");

  indexEquDiff.clear();
  indexEquAlg.clear();
  indexVarAlg.clear();
  indexVarDiff.clear();
  varAlgName.clear();
  return B;
}
  // @brief construct the output matrix C
  // * @param t time to use for the evaluation
MatrixXd
ModelMulti::getMatrixC() {
  if (!exists("Linearisation")) {
      create_directory("Linearisation");
  }
  // required declarations
  std::vector<std::string> varDiffName;   // vector of names of differential variables
  vector<int> indexOmega;  // vector of index positions of output variables
  MatrixXd C;  // output matrix
  //  ======================get the names of differential variables======================================//
  varDiffName = getNameVariable(1);
  //  ================get the index positions of the output varaible: "omega"=================================//
  indexOmega = getIndexPositionString(varDiffName, "omega");
  //  =======================Compute the output matrix C=================================================//
  C = MatrixXd::Zero(indexOmega.size(), varDiffName.size());
  for (unsigned int i = 0; i < indexOmega.size(); i++) {
      C(i, indexOmega[i]) = 1;
  }
  writeToFile(C, "Linearisation/C.txt");
  return C;
}


  // @brief get the index positions of rotational states from the vector of differential states
vector<int>
ModelMulti::getIndexRot() {
  vector<string> stateDiff = getNameVariable(1);
  vector<int> indexrot = getIndexTypeState(stateDiff, "omega", 1);
  vector<int> indexrot1 = getIndexTypeState(stateDiff, "w", 1);
  vector<int> indexrot2 = getIndexTypeState(stateDiff, "delta", 1);
  vector<int> indexrot3 = getIndexTypeState(stateDiff, "theta", 1);
  vector<int> indexrot4 = getIndexTypeState(stateDiff, "OMEGA_REF_tetaRef", 1);
  indexrot.insert(indexrot.end(), indexrot1.begin(), indexrot1.end());
  indexrot.insert(indexrot.end(), indexrot2.begin(), indexrot2.end());
  indexrot.insert(indexrot.end(), indexrot3.begin(), indexrot3.end());
  indexrot.insert(indexrot.end(), indexrot4.begin(), indexrot4.end());
  return indexrot;
}
  // @brief get the index postions of D-axe states from the vector of differential states
vector<int>
ModelMulti::getIndexSMD() {
  vector<string> stateDiff = getNameVariable(1);
  vector<int> indexsmd = getIndexTypeState(stateDiff, "lambdad", 2);
  vector<int> indexsmd1 = getIndexTypeState(stateDiff, "lambdaD", 2);
  indexsmd.insert(indexsmd.end(), indexsmd1.begin(), indexsmd1.end());
  return indexsmd;
}
  // @brief get the index postions of Q-axe states from the vector of differential states
vector<int>
ModelMulti::getIndexSMQ() {
  vector<string> stateDiff = getNameVariable(1);
  vector<int> indexsmq = getIndexTypeState(stateDiff, "lambdaq", 3);
  vector<int> indexsmq1 = getIndexTypeState(stateDiff, "lambdaQ", 3);
  indexsmq.insert(indexsmq.end(), indexsmq1.begin(), indexsmq1.end());
  return indexsmq;
}
  // @brief get the index postions of Q-axe states from the vector of differential states
vector<int>
ModelMulti::getIndexAVR() {
  vector<string> stateDiff = getNameVariable(1);
  vector<int> indexavr = getIndexTypeState(stateDiff, "avr", 5);
  vector<int> indexavr1 = getIndexTypeState(stateDiff, "AVR", 5);
  vector<int> indexavr2 = getIndexTypeState(stateDiff, "VoltageRegulator", 5);
  vector<int> indexavr3 = getIndexTypeState(stateDiff, "VR", 5);
  vector<int> indexavr4 = getIndexTypeState(stateDiff, "lambdaf", 5);
  indexavr.insert(indexavr.end(), indexavr1.begin(), indexavr1.end());
  indexavr.insert(indexavr.end(), indexavr2.begin(), indexavr2.end());
  indexavr.insert(indexavr.end(), indexavr3.begin(), indexavr3.end());
  indexavr.insert(indexavr.end(), indexavr4.begin(), indexavr4.end());
  return indexavr;
}

  // @brief get the index postions of Q-axe states from the vector of differential states
vector<int>
ModelMulti::getIndexGOV() {
  vector<string> stateDiff = getNameVariable(1);
  vector<int> indexgov = getIndexTypeState(stateDiff, "gover", 6);
  vector<int> indexgov1 = getIndexTypeState(stateDiff, "GOVER", 6);
  vector<int> indexgov2 = getIndexTypeState(stateDiff, "gov", 6);
  vector<int> indexgov3 = getIndexTypeState(stateDiff, "GOV", 6);
  indexgov.insert(indexgov.end(), indexgov1.begin(), indexgov1.end());
  indexgov.insert(indexgov.end(), indexgov2.begin(), indexgov2.end());
  indexgov.insert(indexgov.end(), indexgov3.begin(), indexgov3.end());
  return indexgov;
}
  // @brief get the index postions of Injector states from the vector of differential states
vector<int>
ModelMulti::getIndexINJ() {
  vector<string> stateDiff = getNameVariable(1);
  vector<int> indexinj = getIndexTypeState(stateDiff, "inj", 4);
  vector<int> indexinj1 = getIndexTypeState(stateDiff, "HVDC", 4);
  indexinj.insert(indexinj.end(), indexinj.begin(), indexinj1.end());
  return indexinj;
}
  // @brief get the index postions of other states from the vector of differential states
vector<int>
ModelMulti::getIndexOTH() {
  vector<string> stateDiff = getNameVariable(1);
  vector<int> indexoth = getIndexTypeState(stateDiff, " ", 0);
  return indexoth;
}
  // Function to dump the sub participation factors associated  to a given mode
  // * @param nbrMode: number of selected mode
  // * @param matPart: matrice of participation factor
  // * @param eigenComp: vector of all eigenvalues
void
ModelMulti::printSubParticipation(int nbrMode, MatrixXd &matPart, VectorXcd &eigenComp) {
  vector<int> indexrot = getIndexRot();
  vector<int> indexsmd = getIndexSMD();
  vector<int> indexsmq = getIndexSMQ();
  vector<int> indexoth = getIndexOTH();
  vector<int> indexinj = getIndexINJ();
  vector<int> indexavr = getIndexAVR();
  vector<int> indexgov = getIndexGOV();
  ofstream of;
  of.open("subParticipation/subpart.txt");
  of << eigenComp(nbrMode) << endl;
  of << "ROT: " << getSubPart(nbrMode, indexrot, matPart) << endl;
  of << "SMD: " << getSubPart(nbrMode, indexsmd, matPart) << endl;
  of << "SMQ: " << getSubPart(nbrMode, indexsmq, matPart) << endl;
  of << "AVR: " << getSubPart(nbrMode, indexavr, matPart) << endl;
  of << "GOV: " << getSubPart(nbrMode, indexgov, matPart) << endl;
  of << "INJ: " << getSubPart(nbrMode, indexinj, matPart) << endl;
  of << "OTH: " << getSubPart(nbrMode, indexoth, matPart) << endl;
  of.close();
}
  // @brief return the names of differential/algebraic variables
  // * @param var integer used to switch between the outputs
  // * if var = 1, returns the names of differential variables
  // * if var = 2, returns the names of algebraic variables
vector<string>
ModelMulti::getNameVariable(int var) {
  std::vector<std::string> varDiffName;
  std::vector<std::string> varAlgName;
  for (int i = 0; i < sizeY(); ++i) {
  if (yType_[i] == DYN::DIFFERENTIAL) {
       varDiffName.push_back(getVariableName(i));
  } else {
       varAlgName.push_back(getVariableName(i));
    }
  }
  switch (var) {
         case 1 : {
         return varDiffName;
         break;
         }
         case 2 : {
         return varAlgName;
         break;
         }
         default : {
         return varDiffName;
         }
  }
}
  // @brief get the index positions of differential/algebraic variables
  // * @param var integer used to switch between the outputs
  // * if var = 1: it returns the index positons of differential variables
  // * if var = 2: it returns the index positons of algebraic variables
vector<int>
ModelMulti::getIndexVariable(int var) {
  std::vector<int> indexVarDiff;
  std::vector<int> indexVarAlg;
  for (int i = 0; i < sizeY(); ++i) {
    if (yType_[i] == DYN::DIFFERENTIAL) {
       indexVarDiff.push_back(i);
    } else {
       indexVarAlg.push_back(i);
    }
  }
  switch (var) {
         case 1 : {
         return indexVarDiff;
         break;
         }
         case 2 : {
         return indexVarAlg;
         break;
         }
         default : {
         return indexVarDiff;
         }
  }
}

  // @brief get the index positons of differential/algebraic equations
  // * @param var integer used to switch between the outputs
  // * if var = 1: it returns the index poitions of differential equations
  // * if var = 2: it returns the index positons of algebraic equations
vector<int>
ModelMulti::getIndexEquation(int var) {
  std::vector<int> indexEquDiff;
  std::vector<int> indexEquAlg;
  for (int i = 0; i < sizeF(); ++i) {
    if (fType_[i] == DYN::DIFFERENTIAL_EQ) {
      indexEquDiff.push_back(i);
    } else {
      indexEquAlg.push_back(i);
    }
  }
  switch (var) {
         case 1 : {
         return indexEquDiff;
         break;
         }
         case 2 : {
         return indexEquAlg;
         break;
         }
         default : {
         return indexEquDiff;
         }
  }
}
  // @brief return the name of machines associated to a vector of index states
  // * @param indexVect: vector of index states associated to most important participation factors of
  // the given modes used to select machine names
vector<std::string>
ModelMulti::nameMachine(std::vector<int> &indexVect) {
     std::vector<std::string> machName_;
     for (int i = 0; i < sizeY(); ++i) {
         if (yType_[i] == DYN::DIFFERENTIAL) {
            machName_.push_back(getVariableNameDevices(i));
         }
     }
     std::vector<string> selectMachName;
     for (unsigned int i = 0; i < indexVect.size(); i++) {
         selectMachName.push_back(machName_[indexVect[i]]);
     }
     return selectMachName;
}
  // Function that returns the name of machines of a given power system without redundancy
vector<std::string>
ModelMulti::nameMachineDiff() {
     std::vector<std::string> machName_;
     for (int i = 0; i < sizeY(); ++i) {
         if (yType_[i] == DYN::DIFFERENTIAL) {
            machName_.push_back(getVariableNameDevices(i));
         }
     }
    machName_.erase(std::unique(machName_.begin(), machName_.end()), machName_.end());
    return machName_;
}
  // @brief returns the name of machines of a given power system with redundancy
  // this vector of dynamic devices names will be used in SMA part
vector<std::string>
ModelMulti::nameDynamicDevicesDiff() {
     std::vector<std::string> nameDynamicDevices;
     for (int i = 0; i < sizeY(); ++i) {
         if (yType_[i] == DYN::DIFFERENTIAL) {
            nameDynamicDevices.push_back(getVariableNameDevices(i));
         }
     }
    return nameDynamicDevices;
}
  // @brief return the indices of coupled/not couplted dynamic devices
  // vector<int>
  // ModelMulti::getIndicesCoupledDynDevices(vector<std::string> machNames,
  // Function that returns only the name of dynamic devices according to a given index of variable
  // * @param index: is the index position of diff/alg variable
std::string
ModelMulti::getVariableNameDevices(int index) {
  if (_yNames.empty()) {
    std::string varName1;
     for (unsigned int i = 0; i < subModels_.size(); ++i) {
       const std::vector<std::string>& xNames = subModels_[i]->xNames();
       for (unsigned int j = 0; j < xNames.size(); ++j) {
        varName1 = subModels_[i]->name();
        _yNames.push_back(varName1);
      }
    }
  }
  assert(index < static_cast<int>(_yNames.size()));
  return _yNames[index];
}
  // @brief return the index positions of most participation states of each dynamic device involved in a given mode
  // * @param statesCoupledDevices: vector that contains the states of coupled dynamic devices
  //  selected according to a given participation factor threshould,
  // * @param indexSelecPart: index of selected participation factors associated to selected coupled dynamic devices,
  // * @param namesD: names of all dynamic devices of the differential part
vector<int>
ModelMulti::getIndexMostCoupledDevices(vector<string> &statesofCoupledDevices, vector<int> &indexSelecPart, vector<string> &namesD) {
    std::vector<int> indexStatesMode;
    std::vector<int> indexFinalMostStateMode;
    for (unsigned int i = 0; i < statesofCoupledDevices.size(); i++) {
      string line = statesofCoupledDevices[i];
        for (unsigned int lineno = 0; lineno < statesofCoupledDevices.size(); lineno++) {
          size_t found = line.find(namesD[indexSelecPart[lineno]]);
            if (found != string::npos) {
             indexStatesMode.push_back(indexSelecPart[lineno]);
            }
         }
    indexFinalMostStateMode.push_back(indexStatesMode[0]);
    indexStatesMode.clear();
    }
    uniqueVector(indexFinalMostStateMode);
    return indexFinalMostStateMode;
}

  // @brief dump a dynamic double matrix of Eigenlib type in txt file
  // * @param x dynamic double matrix,
  // * @param fileName file to be returned,
void
ModelMulti::writeToFile(MatrixXd x, string fileName) {
  ofstream of;
  if (exists(fileName.c_str())) {
    std::remove(fileName.c_str());
    of.open(fileName.c_str());
    of << x;
    of << "\n";
  } else {
    of.open(fileName.c_str());
    of << x;
    of << "\n";
  }
  of.close();
}

  // @brief dump an integer vector in txt file
  // * @param x integer vector,
  // * @param fileName file to be returned,
void
ModelMulti::writeToFileStd(vector<int> x, string fileName) {
  ofstream of;
  if (exists(fileName.c_str())) {
    std::remove(fileName.c_str());
    of.open(fileName.c_str());
  for (unsigned int i = 0; i < x.size(); ++i) {
  of << x[i];
  of << "\n";
  }
  } else {
    of.open(fileName.c_str());
    for (unsigned int i = 0; i < x.size(); ++i) {
      of << x[i];
      of << "\n";
    }
  }
  of.close();
}

  // @brief dump a complex vector in txt file
  // * @param x complex vector,
  // * @param fileName file to be returned,

void
ModelMulti::writeToFileComplexStd(vector<std::complex<double> > x, string fileName) {
  ofstream of;
  if (exists(fileName.c_str())) {
    std::remove(fileName.c_str());
    of.open(fileName.c_str());
  for (unsigned int i = 0; i < x.size(); ++i) {
  of << x[i];
  of << "\n";
  }
  } else {
    of.open(fileName.c_str());
    for (unsigned int i = 0; i < x.size(); ++i) {
      of << x[i];
      of << "\n";
    }
  }
  of.close();
}
  // @brief dump a string vector in txt file
  // * @param x integer vector,
  // * @param fileName file to be returned,
void
ModelMulti::writeToFileString(vector<string> x, string fileName) {
  ofstream of;
  if (exists(fileName.c_str())) {
    std::remove(fileName.c_str());
    of.open(fileName.c_str());
  for (unsigned int i = 0; i < x.size(); ++i) {
  of << x[i];
  of << "\n";
  }
  } else {
    of.open(fileName.c_str());
    for (unsigned int i = 0; i < x.size(); ++i) {
      of << x[i];
      of << "\n";
    }
  }
  of.close();
}
    // @brief dump a dynamic complex matrix of Eigenlib type in txt file
    // * @param x double dynamic complex matrix,
    // * @param fileName file to be returned,
void
ModelMulti::writeToFileComplex(MatrixXcd x, string fileName) {
  ofstream of;
  if (exists(fileName.c_str())) {
  std::remove(fileName.c_str());
  of.open(fileName.c_str());
  of << x;
  of << "\n";
  } else {
  of.open(fileName.c_str());
  of << x;
  of << "\n";
  }
  of.close();
}

  // @brief creat a double dynamic matrix of Eigenlib type from an existant file
  // * @param nrs number of rows
  // * @param fileName file to be used,
MatrixXd
ModelMulti::createEigenMatrixXd(int &nrs, string fileName) {
  Eigen::MatrixXd A(nrs, nrs);
  ifstream of;
  of.open(fileName.c_str());
  if (of.good()) {
     for (int row = 0; row < nrs; row++)
         for (int col = 0; col < nrs; col++) {
             float item = 0.0;
             of >> item;
             A(col, row) = item;
         }
  } else {
    Trace::error() << "THE " << fileName.c_str() << " DOES NOT CREAT" << Trace::endline;
  }
  of.close();
  return A;
}

  // @brief extract the names of most participating states (selected according a participation factor threshold)
  // associated to a given mode from a vector  of all differential variables.
  // * @param varDiff vector of all differential variables,
  // * @param indexStates vector contains the index positions of most participating states.
vector<std::string>
ModelMulti::getStateMode(std::vector<string> &varDiff, std::vector<int> &indexStates) {
  std::vector<string> vecStateMode;
  int n = static_cast<int>(varDiff.size());
  int m = static_cast<int>(indexStates.size());
  for (int i = 0; i < m; i++) {
      for (int lineno = 0; lineno < n; lineno++) {
          if (lineno == indexStates[i]) {
             vecStateMode.push_back(varDiff[lineno]);
          }
      }
  }
  return vecStateMode;
}

  // @brief compute the damping of a given mode
  // * @param realPart vector of real parts of the eigenvalues of A
  // * @param imagPart vector of imaginary parts of the eigenvalues of A
vector<float>
ModelMulti::computeDamping(std::vector<double> &realPart, std::vector<double> &imagPart) {
  std::vector<float> damp;
  for (unsigned int i = 0; i < realPart.size(); i++) {
      damp.push_back(abs(100*(realPart[i]/sqrt((realPart[i]*realPart[i]) + (imagPart[i]*imagPart[i])))));
  }
  return damp;
}

  // @brief compute the oscillation frequency of a given mode
  // * @param imagPart imaginary part of a given eigenvalue
vector<float>
ModelMulti::computeFrequency(std::vector<double> &imagPart) {
  std::vector<float> freq;
  for (unsigned int i = 0; i < imagPart.size(); i++) {
      freq.push_back(imagPart[i]/(2*M_PI));
  }
  return freq;
}

  // @brief extract the value of maximum participation factor, and the phase position associated
  // to a given mode according to a given index
  // * @param mat: matrix of relative participation factors or of phase positions
  // * @param indexModes : vector of indices of selected modes
  // * @param indexPartMax: vector of indices of maximum participation factors
  // * @param n : order of matrix mat
vector<float>
ModelMulti::getValueIndex(Eigen::MatrixXd &mat, std::vector<double> &indexModes, std::vector<double> &indexPartMax, unsigned int n) {
  Eigen::ArrayXd tempVect(n);
  std::vector<float> partValue;
  for (unsigned int i = 0; i < indexModes.size(); i++) {
      tempVect = mat.col(indexModes[i]);
      partValue.push_back(tempVect(indexPartMax[indexModes[i]]));
  }
  return partValue;
}

  // @brief return the nature of a given mode
  // * @param inLine a selected string line from a given vector of differential variables
  // * @param strVector a string vector that contains the possible states of interconnected power system
  // in this version of work, 22 possibilities are defined
string
ModelMulti::getModeType(std::string inLine, std::vector<std::string> &strVector) {
  string outLine;
  size_t found = inLine.find(strVector[0]);
  if (found != string::npos) {
  outLine = "ROT";
  } else {
  found = inLine.find(strVector[1]);
  if (found != string::npos) {
  outLine = "ROT";
  } else {
  found = inLine.find(strVector[2]);
  if (found != string::npos) {
  outLine = "ROT";
  } else {
  found = inLine.find(strVector[3]);
  if (found != string::npos) {
  outLine = "ROT";
  } else {
  found = inLine.find(strVector[4]);
  if (found != string::npos) {
  outLine = "ROT";
  } else {
  found = inLine.find(strVector[5]);
  if (found != string::npos) {
  outLine = "SMD";
  } else {
  found = inLine.find(strVector[6]);
  if (found != string::npos) {
  outLine = "SMD";
  } else {
  found = inLine.find(strVector[7]);
  if (found != string::npos) {
  outLine = "SMD";
  } else {
  found = inLine.find(strVector[8]);
  if (found != string::npos) {
  outLine = "SMQ";
  } else {
  found = inLine.find(strVector[9]);
  if (found != string::npos) {
  outLine = "SMQ";
  } else {
  found = inLine.find(strVector[10]);
  if (found != string::npos) {
  outLine = "SMQ";
  } else {
  found = inLine.find(strVector[11]);
  if (found != string::npos) {
  outLine = "SMQ";
  } else {
  found = inLine.find(strVector[12]);
  if (found != string::npos) {
  outLine = "EXC";
  } else {
  found = inLine.find(strVector[13]);
  if (found != string::npos) {
  outLine = "EXC";
  } else {
  found = inLine.find(strVector[14]);
  if (found != string::npos) {
  outLine = "EXC";
  } else {
  found = inLine.find(strVector[15]);
  if (found != string::npos) {
  outLine = "EXC";
  } else {
  found = inLine.find(strVector[16]);
  if (found != string::npos) {
  outLine = "GOV";
  } else {
  found = inLine.find(strVector[17]);
  if (found != string::npos) {
  outLine = "GOV";
  } else {
  found = inLine.find(strVector[18]);
  if (found != string::npos) {
  outLine = "GOV";
  } else {
  found = inLine.find(strVector[19]);
  if (found != string::npos) {
  outLine = "INJ";
  } else {
  found = inLine.find(strVector[20]);
  if (found != string::npos) {
  outLine = "INJ";
  } else {
  found = inLine.find(strVector[21]);
  if (found != string::npos) {
  outLine = "INJ";
  } else {
  outLine = "OTH";
  }}}}}}}
  }}}}}}}
  }}}}}}}}
  return outLine;
}
  //  @brief return the index positions of states from the vector of differential variables
  //  according to the type of state: ROT, SMD, SMQ, INJ, GOV, EXC, OTH.
  // * @param statesDiff vector contains all differential states
  // * @param var integer used to switch between the outputs
  // if var = 1 it returns indices associated to ROT type,
  // if var = 2 it returns indices associated to SMD type,
  // if var = 3 it returns indices associated to SMQ type,
  // if var = 4 it returns indices associated to INJ type,
  // if var = 5 it returns indices associated to AVR type,
  // if var = 6 it returns indices associated to GOV type,
  // default: it returns indices associated to any other type.
vector<int>
ModelMulti::getIndexTypeState(vector<std::string> &statesDiff, std::string type, const int var) {
  std::vector<int> index;
  switch (var) {
case 1 : {
  if (type == "w" || type == "delta" || type == "omega" || type == "theta" || type == "OMEGA_REF_tetaRef") {
     for (unsigned int i = 0; i < statesDiff.size(); i++) {
         size_t found = statesDiff[i].find(type);
         if (found != string::npos) {
            index.push_back(i);
         }
     }
  }
return index;
}
case 2 : {
  if (type == "lambdad" || type == "lambdaD") {
     for (unsigned int i = 0; i < statesDiff.size(); i++) {
         size_t found = statesDiff[i].find(type);
         if (found != string::npos) {
            index.push_back(i);
         }
     }
  }
return index;
}
case 3 : {
  if (type == "lambdaq" || type == "lambdaQ") {
     for (unsigned int i = 0; i < statesDiff.size(); i++) {
         size_t found = statesDiff[i].find(type);
         if (found != string::npos) {
            index.push_back(i);
         }
     }
  }
return index;
}
case 4 : {
  if (type == "inj" || type == "INJ" || type == "HVDC") {
     for (unsigned int i = 0; i < statesDiff.size(); i++) {
         size_t found = statesDiff[i].find(type);
         if (found != string::npos) {
            index.push_back(i);
         }
     }
  }
return index;
}
case 5 : {
  if (type == "VR" || type == "AVR" || type == "VoltageRegulator" || type == "lambdaf") {
     for (unsigned int i = 0; i < statesDiff.size(); i++) {
         size_t found = statesDiff[i].find(type);
         if (found != string::npos) {
            index.push_back(i);
         }
     }
  }
return index;
}
case 6 : {
  if (type == "gover" || type == "GOVER"|| type == "Gover") {
     for (unsigned int i = 0; i < statesDiff.size(); i++) {
         size_t found = statesDiff[i].find(type);
         if (found != string::npos) {
            index.push_back(i);
         }
     }
  }
return index;
}
default : {
  if (type == "lambdad" || type == "lambdaD" || type == "lambdaq" || type == "lambdaQ" || type == "w" || type == "delta" ||
type == "OMEGA" || type == "theta" || type == "lambdaf" || type == "OMEGA_REF_tetaRef" || type == "inj" ||
type == "INJ" || type == "HVDC" || type == "VR" || type == "AVR" || type == "VoltageRegulator" ||
type == "gover" || type == "GOVER"|| type == "Gover") {
     for (unsigned int i = 0; i < statesDiff.size(); i++) {
         size_t found = statesDiff[i].find(type);
         if (found == string::npos) {
            index.push_back(i);
         }
      }
  }
return index;
}
}
}

  // @brief dump the characteristic of stable modes
  // * @param fileName presents the name of the file to be returned
  // * @param states vector of selected states associated to a given mode
  // * @param strVec vector of string, contains the possible states that can be associated to a given mode
  // * @param vr vector of real part of complex stable modes
  // * @param vi vector of imag part of complex stable modes
  // * @param freq vector of oscillation frequencies of complex stable modes
  // * @param damp vector of damping of complex stable modes
  // * @param phas vector of phase positions of complex stable modes
  // * @param part vector of participation factors of complex stable modes
  // * @param ivi vector of index positions of imaginary part of complex modes
  // * @param unsvi vector of unstable modes (this param is used only for the display of the number of unstable modes)
  // * @param iR vector of index positions of real modes (this param is used only to display of the number of real modes)
  // * @param namesMachines vector of name of machines
void
ModelMulti::printToFileStableModes(std::string fileName, std::vector<std::string> &states, std::vector<std::string> &strVec,
std::vector<double> &vr, std::vector<double> &vi, std::vector<float> &freq, std::vector<float> &damp, std::vector<float> &phas,
std::vector<float> &part, std::vector<double> &ivi, std::vector<double> &unsvi, std::vector<double> &iR,
std::vector<std::string> &namesMachines) {
  string line;
  ofstream of;
  of.open(fileName.c_str());
  if (!of) {
  Trace::error() << "THE" << fileName.c_str() << "COULD NOT BE OPENED" << Trace::endline;
  exit(1);
} else {
  of << "-----------------------------------------------FULL MODAL";
  of << " ANALYSIS----------------------------------------";
  of << "\n";
  of << "Number of Stable Modes  :" << vi.size();
  of << "\n";
  of << "Number of Unstable Modes:" << unsvi.size();
  of << "\n";
  of << "Number of Real Modes    :" << iR.size();
  of << "\n";
  of << "---------------------------------------------------------";
  of << "------------------------------------------------";
  of << "\n";
  of << "-------------------------------------------COMPLEX STABLE";
  of << " MODES------------------------------------------";
  of << "\n";
  of << "---------------------------------------------------------";
  of << "------------------------------------------------";
  of << "\n";
  of << "Nb." << setw(12) << "--imag. Part--" << setw(12) << "real Part--" << setw(12) << "freq. Part--" << setw(12) << "damp. Part--";
  of << setw(12) << "parti. Part--" << setw(12) << "arg. Part--" << setw(12) << "mode Type--" << setw(12) << "mach. Name--" << endl;
  for (unsigned int i = 0; i < ivi.size(); i++) {
  line = getModeType(states[i], strVec);
  of << setw(1) << fixed << setprecision(0) << ivi[i] << setw(12) << fixed << setprecision(4) << vi[i];
  of << setw(12) << vr[i] << setw(12) << freq[i] << setw(12) << damp[i];
  of << setw(12) << 100*part[i] << setw(12) << phas[i] << setw(12) << line << setw(12) << namesMachines[i] << endl;
  of << "\n";
}
  of.close();
}
}

  // @brief dump the characteristics of unstable modes
  // * @param fileName presents the name of the file to be returned
  // * @param states vector of selected states associated to a given mode
  // * @param strVec vector of string, contains the possible states that can be associated to a given mode
  // * @param vr vector of real parts of complex stable modes
  // * @param vi vector of imag parts of complex stable modes
  // * @param freq vector of oscillation frequencies of complex stable modes
  // * @param damp vector of damping of complex stable modes
  // * @param phas vector of phase positions of complex stable modes
  // * @param part vector of participation factors of complex stable modes
  // * @param ivi vector of index positions of imaginary part of the complex modes
  // * @param unsvi vector of unstable modes (this param is used only for the display of the number of unstable modes)
  // * @param iR vector of index positions of real modes (this param is used only for the display of the number of real modes)
  // * @param namesMachines vector of name of machines
void
ModelMulti::printToFileUnstableModes(std::string fileName, std::vector<string> &states, vector<string> &strVec, std::vector<double> &vr,
std::vector<double> &vi, std::vector<float> &freq, std::vector<float> &damp, std::vector<float> &phas,
std::vector<float> &part, std::vector<double> &ivi, std::vector<std::string> &namesMachines) {
  string line;
  ofstream of;
  of.open(fileName.c_str(), std::ios::in | std::ios::out | std::ios::ate);
  if (!of) {
  Trace::error() << "THE" << fileName.c_str() << "COULD NOT BE OPENED" << Trace::endline;
  exit(1);
} else {
  of << "---------------------------------------------------------";
  of << "------------------------------------------------";
  of << "\n";
  of << "-----------------------------------------COMPLEX UNSTABLE";
  of << " MODES------------------------------------------";
  of << "\n";
  of << "---------------------------------------------------------";
  of << "------------------------------------------------";
  of << "\n";
  of << "Nb." << setw(12) << "--imag. Part--" << setw(12) << "real. Part--" << setw(12) << "freq. Part--" << setw(12) << "damp. Part--";
  of << setw(12) << "parti. Part--" << setw(12) << "arg. Part--" << setw(12) << "mode Type--" << setw(12) << "mach. Name--" << endl;
  for (unsigned int i = 0; i < ivi.size(); i++) {
  line = getModeType(states[i], strVec);
  of << setw(1) << fixed << setprecision(0) << ivi[i] << setw(12) << fixed << setprecision(4) << vi[i];
  of << setw(12) << vr[i] << setw(12) << freq[i] << setw(12) << damp[i] << setw(12);
  of << 100*part[i] << setw(12) << phas[i] << setw(12) << line <<  setw(12) << namesMachines[i] << endl;
  of << "\n";
}
  of.close();
}
}


  // @brief dump the characteristics of real modes
  // * @param fileName presents the name of file to be returned
  // * @param states vector of selected states associated to a given mode
  // * @param strVec vector of string contains the possible states that can be associated to a given mode
  // * @param vr vector of real part of complex stable modes
  // * @param part vector of participation factors of complex stable modes
  // * @param ir vector of index positions of real modes
  // * @param namesMachines vector of name of machines
void
ModelMulti::printToFileRealModes(string fileName, vector<string> &states, vector<string> &strVec, vector<double> &vr,
vector<float> &part, vector<double> &ir, vector<string> &namesMachines) {
  string line;
  ofstream of;
  of.open(fileName.c_str(), std::ios::in | std::ios::out | std::ios::ate);
  if (!of) {
  Trace::error() << "THE" << fileName.c_str() << "COULD NOT BE OPENED" << Trace::endline;
  exit(1);
} else {
  of << "---------------------------------------------------------";
  of << "------------------------------------------------";
  of << "\n";
  of << "-----------------------------------------------REAL MODES";
  of << "------------------------------------------------";
  of << "\n";
  of << "---------------------------------------------------------";
  of << "------------------------------------------------";
  of << "\n";
  of << "Nb." << setw(20) << "--real. Part--" << setw(20) << "parti. Part--" << setw(20) << "mode. Type--" << setw(18) << "mach. Name--" <<endl;
  for (unsigned int i = 0; i < ir.size(); i++) {
  line = getModeType(states[i], strVec);
  of << setw(1) << fixed << setprecision(0) << ir[i] << "        " << setw(12) << fixed << setprecision(4) << vr[i];
  of << "        " << setw(12) << 100*part[i] << setw(20) << line << "        " << namesMachines[i] << endl;
  of << "\n";
}
  of.close();
}
}

  // @brief extract the index position of great value of each column of a given matrix (for example the matrix of relative participation)
  // * @param mat dynamic double matrix
vector<double>
ModelMulti::getIndexPositionMax(MatrixXd &mat) {
  int n = mat.rows();
  Eigen::ArrayXd vect_temp(n);
  std::vector<float> vectPart(n, 0);
  std::vector<double> index;
  for (int row1 = 0; row1 < n; row1++) {
      vect_temp = mat.col(row1);
      for (int col1 = 0; col1 < n; col1++) {
           vectPart[col1] = vect_temp(col1);
       }
  index.push_back(distance(vectPart.begin(), max_element(vectPart.begin(), vectPart.end())));
  // reset the vector vectPart
  std::fill(vectPart.begin(), vectPart.end(), 0);
  }
  return index;
}

  // @brief find the index position of a given string from a vector of string and dump it in std vector
  // * @param varCombined vector that contains the new distribution of all states after rearrangement
  // * @param in_out a string that will be identified in the vector varCombined, and his position will be returned
vector<int>
ModelMulti::getIndexPositionString(vector<string> &varCombined, string in_out) {
  vector<int> vec;
  int n = static_cast<int>(varCombined.size());
  for (int lineno=0; lineno < n; lineno++) {
      size_t found = varCombined[lineno].find(in_out);
      if (found != string::npos) {
         vec.push_back(lineno);
      }
  }
  return vec;
}
  // @brief eliminate the redundancy in std vector
  // * @param vec vector of integer
void
ModelMulti::uniqueVector(vector <int> &vec) {
  TOP:for (unsigned int y = 0; y < vec.size(); ++y) {
  for (unsigned int z = 0; z < vec.size(); ++z) {
      if (y == z) {
      continue;
      }
      if (vec[y] == vec[z]) {
      vec.erase(vec.begin()+z);
      goto TOP;
      }
  }
}
}
  // @brief return a dynamic double matrix of phase positions from a dynamic complex double matrix of Eigenlib type
  // * @param mat matrix of right eigenvectors
Eigen::MatrixXd
ModelMulti::createEigenArgMatrix(MatrixXcd &mat) {
  int nrs = mat.rows();
  int ncs = mat.cols();
  Eigen::MatrixXd matPhase(nrs, ncs);
  for (int row = 0; row < nrs; row++) {
    for (int col = 0; col < ncs; col++) {
        matPhase(row, col) = (180/3.14)*arg(mat(row, col));
    }
  }
  return matPhase;
}

  // @brief convert a dynamic double Array of Eigenlib type to std vector
  // * @param dynamic double array
vector<double>
ModelMulti::convertEigenArrayToStdVector(Eigen::ArrayXd &vec1) {
  std::vector<double> vec2;
  for (unsigned int i = 0; i < vec1.size(); i++) {
      vec2.push_back(vec1[i]);
  }
  return vec2;
}

vector<std::complex<double> >
ModelMulti::convertEigenArrayCToStdVector(Eigen::ArrayXcd &vec1) {
  std::vector<std::complex<double> > vec3;
  for (unsigned int i = 0; i < vec1.size(); i++) {
      const std::complex<double> temp(vec1[i].real(), vec1[i].imag());
      vec3.push_back(temp);
  }
  return vec3;
}
    // @brief dump the coupled devices of stable and unstables complex modes//
    // * @param irealPartImag_: indices of stabe and unstable complex modes
    // * @param matRelativeRealParticipation: matrix of relative participation factor
    // * @param phaseMatrix: matrix of phase positons
    // * @param n: number of differential variables
    // * @param eigenValComplex: eigenvalues of matrix A
    // * @param strVec: vector of string, contains the possible states that can be associated to a given mode
    // * @param partFactor: threshould of participation factor, used to select the coupled dynamic devices
void
ModelMulti::printToFileCoupledDevices(string fileName, vector<double> &irealPartImag_, MatrixXd &matRelativeRealParticipation,
MatrixXd &phaseMatrix, VectorXcd &eigenValComplex, vector<string> &strVec, const double partFactor) {
  ofstream of;
  of.open(fileName.c_str(), std::ios::in | std::ios::out | std::ios::ate);
  if (!of) {
  Trace::error() << "THE" << fileName.c_str() << "COULD NOT BE OPENED" << Trace::endline;
  exit(1);
} else {
    std::vector<int> indexSelectedPart;
    int x = static_cast<int>(irealPartImag_.size());
    float participation;
    participation = partFactor;
    if (participation < 0) {
    Trace::error() << "THE MINIMUM VALUE OF PARTICIPATION SHOULD BE POSITIVE" << Trace::endline;
    exit(0);
    // goto TOP2;
    } else {
    of << "----------------------------------------------------------------------";
    of << "-----------------------------------";
    of << "\n";
    of << "---------------------------------COUPLED DEVICES ";
    of << "INVOLVED IN EACH COMPLEX MODE---------------------------";
    of << "\n";
    of << "------------------------------------WITH PARTICIPATION GREATEST";
    of << " THAN A LIMIT-----------------------------";
    of << "\n";
    of << "----------------------------------------------------------------------";
    of << "-----------------------------------";
    of << "\n";
    of << "Minimum Relative Participation (%): " << participation << endl;
    of << "\n";
    of << "----------------------------------------------------------------------";
    of << "-----------------------------------";
    of << "\n";
    of << "ind. State" << setw(15) << "|sub. Part|" << setw(15) << "mach. Name|" << setw(15) << "arg. Part|" << setw(18) << "state Type|" << endl;
    int nbofCoupledMode = 0;
    int nbofInterAreaMode = 0;
    std::vector<int> indexofInterAreaMode;
    int nbofElectricalCouplingMode = 0;
    std::vector<int> indexofLocalMode;
    int nbofLocalMode = 0;
    std::vector<int> indexofElectricalCouplingMode;
    std::vector<int> indexofOtherCouplingMode;
    int nbofOtherCouplingMode = 0;
    std::vector<double> selectedPhaseMode;
    int compteur = 0;
for (int nbMode = 0; nbMode < x; nbMode++) {
    int n = matRelativeRealParticipation.rows();
    ArrayXd colSelectedPart(n);
    // extract the column of relative participation factors associated to a given mode
    colSelectedPart = 100*matRelativeRealParticipation.col(irealPartImag_[nbMode]);
    // extract the column of phase associated to a given mode
    ArrayXd phaseCol(n);
    phaseCol = phaseMatrix.col(irealPartImag_[nbMode]);
    // extract the participation factors (greatest to a given threshould) associated to a given mode
    std::vector<double> selectedParticipationMode;
    for (int i = 0; i < n; i++) {
        if (colSelectedPart(i) > participation) {
           selectedParticipationMode.push_back(colSelectedPart(i));
        }
    }

    sort(selectedParticipationMode.begin(), selectedParticipationMode.end(), std::greater<double>());
       // convert a vector of Eigen lib type to std vector
    std::vector<double> stdColSelectedPart;

    for (int i = 0; i < n; i++) {
        stdColSelectedPart.push_back(colSelectedPart(i));
    }

    // index position associated to selected participation factors
    for (unsigned int i = 0; i < selectedParticipationMode.size(); i++) {
        std::vector<double>::iterator it1;
        it1 = find(stdColSelectedPart.begin(), stdColSelectedPart.end(), selectedParticipationMode[i]);
        indexSelectedPart.push_back(it1 - stdColSelectedPart.begin());
    }

    vector<string> varDIFFName = getNameVariable(1);

    vector<string> statesCoupledDevices = getStateMode(varDIFFName, indexSelectedPart);
    vector<string> nameDevices = getNameDynamicDevices(1);

    // Select and dump the index position of most participation factor associate at each dynamic devices involved in selected mode.
    std::vector<int> indexFinalMostStateMode;
    indexFinalMostStateMode = getIndexMostCoupledDevices(statesCoupledDevices, indexSelectedPart, nameDevices);

    if (indexFinalMostStateMode.size() > 1) {
       ++nbofCoupledMode;
    }

    /* classify modes according to the nature of Inter-Area, Electrical, Local and Other*/
    for (unsigned int i = 0; i < indexFinalMostStateMode.size(); i++) {
           selectedPhaseMode.push_back(abs(phaseCol(indexFinalMostStateMode[i])));
    }
    sort(selectedPhaseMode.begin(), selectedPhaseMode.end(), std::greater<double>());
    // Inter-area mode: check if there are at least two machines that are in phase opposition with
    // a highest participation factor associated to the ROT part
    double phaseDifference = abs(selectedPhaseMode.front() - selectedPhaseMode.back());
    string linetype1;
    linetype1 = getModeType(varDIFFName[indexFinalMostStateMode[0]], strVec);
    if (indexFinalMostStateMode.size() > 1 && phaseDifference > 90 && linetype1 == "ROT") {
    ++nbofInterAreaMode;
    indexofInterAreaMode.push_back(irealPartImag_[nbMode]);
    // Local Mode: check if there is a machine with highest participation factor associated to ROT part,
    // or more than 2 machines in phase position with highest participation associated to ROT part.
    } else if (indexFinalMostStateMode.size() >= 1 && phaseDifference < 90 && linetype1 == "ROT") {
    ++nbofLocalMode;
    indexofLocalMode.push_back(irealPartImag_[nbMode]);
    // Electrical coupling mode: check if there are at least two Dynamic Devices that are in phase position or phase opposition with
    // a highest participation factor associated to SMD, or SMQ or EXC part.
    } else if (indexFinalMostStateMode.size() > 1 && linetype1 == "EXC" && linetype1 == "SMD" && linetype1 == "SMQ") {
    ++nbofElectricalCouplingMode;
    indexofElectricalCouplingMode.push_back(irealPartImag_[nbMode]);
    } else {
    ++nbofOtherCouplingMode;
    indexofOtherCouplingMode.push_back(irealPartImag_[nbMode]);
    }

    string linetype;
    of << "=======================================================================================" << endl;
    of << setw(20) << "Nb :" <<  fixed << setprecision(0) << irealPartImag_[nbMode] << "    ||";
    of << "    Mode : <" << fixed << setprecision(4) << eigenValComplex(irealPartImag_[nbMode]) << " > " << endl;
    of << "=======================================================================================" << endl;

    for (unsigned int i = 0; i < indexFinalMostStateMode.size(); i++) {
        linetype = getModeType(varDIFFName[indexFinalMostStateMode[i]], strVec);
        of << indexFinalMostStateMode[i] << fixed << setprecision(4) << setw(18) << colSelectedPart(indexFinalMostStateMode[i]) << setw(20);
        of << nameDevices[indexFinalMostStateMode[i]] << fixed << setprecision(4) << setw(18) << phaseCol(indexFinalMostStateMode[i]);
        of << setw(15) << linetype << endl;
    }

    ++compteur;

    if (compteur == x) {
       of << "=======================================================================================" << endl;
       of << "Number of coupled modes is : ";
       of << nbofCoupledMode << endl;
       of << "Minimum Relative Participation (%):";
       of << participation << endl;
       of << "Number of Inter-Area Modes :";
       of << endl;
       of << nbofInterAreaMode << endl;
       of << "indices of Inter-Area Modes :";
       if (indexofInterAreaMode.size() == 0) {
       of << 0 << endl;
       } else {
       for (unsigned int i = 0; i < indexofInterAreaMode.size(); i++) {
       of << indexofInterAreaMode[i] << ", ";}}
       of << endl;
       of << "Number of Electrical Coupling Modes :";
       of << nbofElectricalCouplingMode << endl;
       of << "indices of Electrical Coupling Modes :";
       if (indexofElectricalCouplingMode.size() == 0) {
       of << 0 << endl;
       } else {
       for (unsigned int i = 0; i < indexofElectricalCouplingMode.size(); i++) {
       of << indexofElectricalCouplingMode[i] << ", ";}}
       of << endl;
       of << "Number of complex Local Modes :";
       of << nbofLocalMode << endl;
       of << "indices of complex Local Modes:";
       if (indexofLocalMode.size() == 0) {
       of << 0 << endl;
       } else {
       for (unsigned int i = 0; i < indexofLocalMode.size(); i++) {
       of << indexofLocalMode[i] << ", ";}}
       of << endl;
       of << "Number of Other Coupling Modes :";
       of << nbofOtherCouplingMode << endl;
       of << "indices of Other Coupling Modes :";
       if (indexofOtherCouplingMode.size() == 0) {
       of << 0 << endl;
       } else {
       for (unsigned int i = 0; i < indexofOtherCouplingMode.size(); i++) {
       of << indexofOtherCouplingMode[i] << ", ";
    }}
}
    selectedParticipationMode.clear();
    indexSelectedPart.clear();
    stdColSelectedPart.clear();
    selectedPhaseMode.clear();
    indexFinalMostStateMode.clear();
  }  // Mode
}  // else
}  // else
    of.close();
}
  //  @brief return the sub participation of a given mode
  // * @param nbMode: number of the mode
  // * @param indexState: indices of selected state (for example of Rot part) associated to nbMode
  // * @param part: matrice of participation factors
double
ModelMulti::getSubPart(int &nbMode, std::vector<int> &indexState, MatrixXd &part) {
    double var1 = 0.0;
    double var2 = 0.0;
    // extract the column of participation factor associated to nbMode
    ArrayXd partMode = part.col(nbMode);
    // compute the sub-participation associated to nbMode
    if (!indexState.empty()) {
       for (unsigned int i=0; i < indexState.size(); i++) {
       var1 = var1 + partMode(indexState[i]);
       }
    var2 = abs(var1);
    return var2;
    } else {
      var2 = 0.0;
      return var2;
    }
}
  // @brief get the index positions of imaginary parts that are different to zero
  // * @param imagPart: imaginary parts that are different to zero
  // * @param allImagPart: all imaginary parts of eigenvalues of A
vector<double>
ModelMulti::getIndexImagPart(vector<double> &imagPart, vector<double> &allImagPart) {
    std::vector<double> iImag;
    for (unsigned int i = 0; i < imagPart.size(); i++) {
        std::vector<double>::iterator it;
        it = find(allImagPart.begin(), allImagPart.end(), imagPart[i]);
        iImag.push_back(it - allImagPart.begin());
    }
    return iImag;
}
  //  @brief get the Imaginary parts that are different to zero, the purly real part and the index of pyrly real part
  //  if var = 1 : return Imaginary parts different to zero,
  //  if var = 2: return real Part associated to imaginary parts equal to zero,
  //  if var = 3: return the index of purly real part,
  // * @param imagEigen: imaginary parts of eigenvalues of A
  // * @param realEigen: real parts of eigenvalues of A
  // * @param var: integer use to switch between the outputs
vector<double>
ModelMulti::getImagRealIndexPart(ArrayXd &imagEigen, ArrayXd &realEigen, int var) {
    std::vector<double>imagPart;
    std::vector<double>realPart;
    std::vector<double>iReal;
    for (unsigned int i = 0; i < imagEigen.size(); i++) {
        if (abs(imagEigen[i]) != 0) {
           imagPart.push_back(abs(imagEigen[i]));
        } else {
          iReal.push_back(i);
          realPart.push_back(realEigen[i]);
        }
    }
    switch (var) {
    case 1 : {
     return imagPart;
     break;
    }
    case 2 : {
     return realPart;
     break;
    }
    case 3 : {
     return iReal;
     break;
    }
    default :
     return imagPart;
    }
}
  //  @brief return the stable real parts associated to the imaginary parts that are different to zero,
  //  the index position of stable real parts associated to the imaginary parts that are different ot zero,
  //  the unstable real parts associated to the imaginary parts that are different to zero and the index
  //  positions of unstable real parts.
  //  if var = 1: returns stable real parts "realPartImag" associated to the imaginary parts that are different to zero,
  //  if var = 2: returns the indices of stable real parts "irealPartImag" associated to the imaginary parts that are different to zero,
  //  if var = 3: returns unstable real parts associated to the imaginary parts that are different to zero,
  //  if var = 4: returns the indices of unstable parts associated to the imaginary parts that are different to zero,
  //  if var = 5: returns the indices of stable and unstable real parts "irealPartImag_"
  //  that are different to zero associated to imaginary parts that are different to zero,
  //  if var = 6: returns the imaginary parts "imagPartNew" associated to the stable real parts,
  //  if var = 7: returns the imaginary parts "unstableImagPartNew" associated to the unstable real parts
  // * @param iImagPartNotZero: index of imaginary parts that are different to zero of eigenvalues of A
  // * @param realEigen: real parts of eigenvalues of A
  // * @param imaginaryPartNotZero: imaginary parts of eigenvalues of A that are different to zero
  // * @param var: integer, used to switch between the outputs
std::vector<double>
ModelMulti::getStableUnstableIndexofModes(vector<double> &iImagPartNotZero, ArrayXd &realEigen, vector<double> &imaginaryPartNotZero,
int var) {
    std::vector<double> realPartImag, irealPartImag, unstableRealPartImag, iUnstableRealPartImag, irealPartImag_, unstableImagPartNew,
imagPartNew;
    for (unsigned int i = 0; i < iImagPartNotZero.size(); i++) {
     if (realEigen[iImagPartNotZero[i]] < 0) {
           realPartImag.push_back(realEigen[iImagPartNotZero[i]]);
           irealPartImag.push_back(iImagPartNotZero[i]);
           irealPartImag_.push_back(iImagPartNotZero[i]);
           imagPartNew.push_back(imaginaryPartNotZero[i]);
     } else if (realEigen[iImagPartNotZero[i]] > 0) {
          unstableRealPartImag.push_back(realEigen[iImagPartNotZero[i]]);
          iUnstableRealPartImag.push_back(iImagPartNotZero[i]);
          irealPartImag_.push_back(iImagPartNotZero[i]);
          unstableImagPartNew.push_back(imaginaryPartNotZero[i]);
     }
    }
    switch (var) {
     case 1 : {
      return realPartImag;
     }
     case 2 : {
      return irealPartImag;
     }
     case 3 : {
      return unstableRealPartImag;
     }
     case 4 : {
      return iUnstableRealPartImag;
     }
     case 5 : {
      return irealPartImag_;
     }
     case 6 : {
      return imagPartNew;
     }
     case 7 : {
      return unstableImagPartNew;
     }
     default :
     return realPartImag;
    }
}
  // @brief get the index position of a state associated to the important participation factors of a given mode (stable, real, unstable)
  // the output of this function will be used as input of getStateMode()
  // * @param indexMaxpart vector of indices of maximum participations
  // * @param indexUSPart vector of modes indices.
vector<int>
ModelMulti::getIndexState(vector<double> &indexMaxPart, vector<double> &indexUSPart) {
    std::vector<int> index;
    for (unsigned int i = 0; i < indexUSPart.size(); i++) {
        index.push_back(indexMaxPart[indexUSPart[i]]);
    }
    return index;
}
  // @brief construct a submatrix from another matrix
  // * @param x a dynamic double matrix
  // * @param nr number of rows of submatrix
  // * @param nc number of columns of submatrix
  // * @param index1/ index2: index positions of differential/algebraic varaibles/equations
MatrixXd
ModelMulti::contructSubMatrix(MatrixXd &x, int nr, int nc, vector<int> &index1, vector<int> &index2) {
    Eigen::MatrixXd Aij(nr, nc);
    for (int i = 0; i < nr; i++) {
        for (int j = 0; j < nc; j++) {
            Aij(i, j) = x(index1[i], index2[j]);
        }
     }
     return Aij;
}

 /** =================================Part 1: SIMPLIFIED MODAL ANALYSIS OF SMALL SYSTEM===========================================
   * @brief computes all modes of small system & returns, for each mode, the real part, the imaginary part,
   * the oscillation frequency, the damping, the phase position, the type, and the names of most participating dynamic devices.
   * Subfunctions: getMatrixA, getIndexVariable, getIndexEquation, getNameVariable, writeToFile, getIndexPositionString,
   * writeToFileComplex, createEigenArgMatrix, EigenSolver, getIndexPositionMax, convertEigenArrayToStdVector, getValueIndex,
   * computeFrequency, computeDamping, getStateMode, nameMachine, printToFileStableModes, printToFileUnstableModes,
   * printToFileRealModes, printToFileCoupledDevices, getSelectedParticipation, getNameDynamicDevices,
   * indexMostCoupledDevices, printCoupledDevices
   * @param t time to use for the evaluation
     =================================================================================================================================
   */
void
ModelMulti::allModes(const double t) {  //, std::vector<double> y
  std::vector<std::string> varNameCombined;
    // Trace::error() << "THE CHOSEN TIME tCurrent_ (DynSimulation.cpp) IS NOT VALIDATED, CHOOSE A tCurrent_ DIFFERENT TO ZERO" << Trace::endline;
    // exit(0);
    if (t != 0) {
    /** check if the folder "allModes" exists or not*/
       if (!exists("allModes")) {
          create_directory("allModes");
       }

    /*************************************************************************************************************************************/
    /*******************************COMPUTE THE MATRIX A and the INPUT/OUTPUT MATRICES B/C************************************************/
       MatrixXd A = getMatrixA(t);
    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    /*************************EXTRACT THE INDEX POSITIONS and NAMES OF DIFFERENTIAL AND ALGEBRAIC VARIABLES*******************************/
       // get the index positions of differential variables
       std::vector<int> indexVarDiff = getIndexVariable(1);
       // get the names of algebraic variables
       // ====== 1: returns only the names of differential variables, 2: returns only the names of algebraic variables =======//
       std::vector<std::string> varAlgName = getNameVariable(2);
       varNameCombined = getNameVariable(1);
       varNameCombined.insert(varNameCombined.end(), varAlgName.begin(), varAlgName.end());

    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    /***************************************COMPUTE and DUMP THE EIGENVALUES AND EIGENVECTORS*********************************************/
       // ==== compute the eigenvalues and the eigenvectors of matrix A using the EigenSolver of EigenLib
       Eigen::EigenSolver<Eigen::MatrixXd> s1(A);
       VectorXcd eigenValComplex = s1.eigenvalues();
       MatrixXcd eigenVectorComplex =  s1.eigenvectors();
       // === dump the eigenvalues===//
       writeToFileComplex(eigenValComplex, "allModes/eigenvaluesA.txt");
       // === dump the eigenvectors===//
       writeToFileComplex(eigenVectorComplex, "allModes/rightEigenvectorsA.txt");
    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    /*******************************ALL processing related to eigenvalues and eigenvectors************************************************/
       // === compute the phase position using the matrix of eigenvectors
       MatrixXd phaseMatrix = createEigenArgMatrix(eigenVectorComplex);
       // === dump the matrix of phase positions===//
       writeToFile(phaseMatrix, "allModes/PhaserightEigenvectors.txt");
       // === compute the matrix of participation factors using the right and left eigenvectors ===//
       MatrixXd matRealParticipation(indexVarDiff.size(), indexVarDiff.size());
       // === check if the matrices of real and imaginary parts of eigenvectors are singular or not ===//
       MatrixXd eigenVectorReal =  s1.eigenvectors().real();
       MatrixXd eigenVectorImag =  s1.eigenvectors().imag();
       // ===compute the determinant of real matrix of eigenvectors ===//
       float detVr = eigenVectorComplex.determinant().real();
       // ===compute the determinant of imaginary matrix of eigenvectors ===//
       float detVi = eigenVectorComplex.determinant().imag();
    if (detVr == 0 && detVi == 0) {
       Trace::error() << "THE MATRIX OF RIGTH EIGENVECTOR IS SINGULAR" << Trace::endline;
       exit(1);
    } else {
       // ===determine the left eigenvetors of a given matrix ===//
       MatrixXd eigenVecRealLeft(indexVarDiff.size(), indexVarDiff.size());
       eigenVecRealLeft = eigenVectorComplex.inverse().real().transpose();
       // ===dump the left eigenvectors of a given matrix===//
       writeToFile(eigenVecRealLeft, "allModes/eigenVecRealLeft.txt");
       // ===compute the matrix of participation factors ===//
       matRealParticipation = eigenVectorReal.cwiseProduct(eigenVecRealLeft);
       writeToFile(matRealParticipation, "allModes/realParticipationMatrix.txt");
    }
      // ===compute the matrix of the relative participation factors===//
       VectorXd vectorMaxParticipationCol = matRealParticipation.cwiseAbs().colwise().maxCoeff();
       MatrixXd matRelativeRealParticipation(indexVarDiff.size(), indexVarDiff.size());
    for (unsigned int row = 0; row < indexVarDiff.size(); row++) {
        matRelativeRealParticipation.col(row) =  (matRealParticipation.cwiseAbs()).col(row)/vectorMaxParticipationCol(row);
    }
      // ===dump the matrix of the relative participation factors===//
       writeToFile(matRelativeRealParticipation, "allModes/matRelativeRealParticipation.txt");
      // ===extract the index position of maximum participation factor of each column ==//
       vector<double> iMaxPart = getIndexPositionMax(matRelativeRealParticipation);
      // ===create a dynamic double vector that contains the imaginary parts of the eigenvalues of A===//
       ArrayXd imagEigenA = eigenValComplex.imag();
      // ===create a dynamic double vector that contains the real parts of the eigenvalues of A===//
       ArrayXd realEigenA = eigenValComplex.real();
      // ===get the imaginary parts of eigenvalues of A other than zero===//
       vector<double> imagPart = getImagRealIndexPart(imagEigenA, realEigenA, 1);
      // ===eliminate redundancies in the vector of imaginary parts===//
       imagPart.erase(std::unique(imagPart.begin(), imagPart.end()), imagPart.end());
      // ===get the index of imaginary parts that are different to zero from the vector of all imaginary parts of A===//
       vector<double> allImagPart = convertEigenArrayToStdVector(imagEigenA);
       vector<double> iImag = getIndexImagPart(imagPart, allImagPart);
      // =====get the real parts associated to the imaginary parts that are equal to zero=====//
       vector<double> realPart = getImagRealIndexPart(imagEigenA, realEigenA, 2);
      // =============get the index positions of purly real modes==============//
       vector<double> iReal = getImagRealIndexPart(imagEigenA, realEigenA, 3);
      // ===1: retrun the strictly negative real parts associated to imaginary parts that are different to zero ===//
       vector<double> realPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 1);
      // ===2: retrun the index positions the strictly negative real parts associated to the imaginary parts that are different to zero===//
       vector<double> irealPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 2);
      // ===3: retrun the the strictly positive real parts associated to the imaginary parts that are different to zero ===//
       vector<double> unstableRealPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 3);
      // ===4: retrun the index positions of the strictly positive real parts associated to imaginary parts that are different to zero===//
       vector<double> iUnstableRealPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 4);
      // ===5: retrun the index positions of non-zero real parts and associated to non-zero imaginary parts ===//
       vector<double> irealPartImag_ = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 5);
      // ===6: retrun the imaginary parts of stable modes===//
       vector<double> imagPartNew = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 6);
      // ===7: retrun the imaginary parts of unstable modes===//
       vector<double> unstableImagPartNew = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 7);
      // ===create a vector that contains the maximum participation factors associated to the stable modes===//
       vector<float> partStableMode = getValueIndex(matRelativeRealParticipation, irealPartImag, iMaxPart, indexVarDiff.size());
      // ===create a vector that contains the participation factors associated to the real modes===//
       vector<float> partRealMode = getValueIndex(matRelativeRealParticipation, iReal, iMaxPart, indexVarDiff.size());
      // ===create a vector that contains the participation factors associated to the unstable modes===//
       vector<float> partUnstableMode = getValueIndex(matRelativeRealParticipation, iUnstableRealPartImag, iMaxPart, indexVarDiff.size());
      // ===create a vector that contains the phase positions associated to the stable modes===//
       vector<float> phaseStableMode = getValueIndex(phaseMatrix, irealPartImag, iMaxPart, indexVarDiff.size());
      // ===create a vector that contains the phase positions associated to the unstable modes===//
       vector<float> phaseUnstableMode = getValueIndex(phaseMatrix, iUnstableRealPartImag, iMaxPart, indexVarDiff.size());
      // ===create a vector that contains the oscillation frequencies associated to the stable modes===//
       vector<float> frequStableMode = computeFrequency(imagPartNew);
      // ===create a vector that contains the oscillation frequencies associated to the unstable modes===//
       vector<float> frequUnstableMode = computeFrequency(unstableImagPartNew);
      // ===create a vector that contains the damping associated to the stable modes===//
       vector<float> dampStableMode = computeDamping(realPartImag, imagPartNew);
      // ===create a vector that contains the damping associated to the unstable modes===//
       vector<float> dampUnstableMode = computeDamping(unstableRealPartImag, unstableImagPartNew);
    // =====================================Stable Modes============================================//
    // -------------get the index position of the state associated to the most important------------//
    // --------------------------participation of each stable mode----------------------------------//
       vector<int> iStableState = getIndexState(iMaxPart, irealPartImag);
    // ------------get the names of the selected states associated to stable modes------------------//
       vector<string> varDIFFName = getNameVariable(1);
       vector<string> stateOfStableMode = getStateMode(varDIFFName, iStableState);
    // ----------------get the names of machines associated to stable modes-------------------------//
       vector<string> nameStableMach_ = nameMachine(iStableState);
    // ====================================Unstable Modes===========================================//
    // -------------get the index position of the state associated to the most important------------//
    // ------------------------participation of each unstable mode----------------------------------//
       vector<int> iUnstableState = getIndexState(iMaxPart, iUnstableRealPartImag);
    // -----------get the names of the selected states associated to unstable modes-----------------//
       vector<string> stateOfUnstableMode = getStateMode(varDIFFName, iUnstableState);
    // ---------------get the names of machines associated to unstable modes------------------------//
       vector<string> nameUnstableMach_ = nameMachine(iUnstableState);
    // =======================================Real Modes============================================//
    // -------------get the index position of the state associated to the most important------------//
    // -------------------------participation of each real mode-------------------------------------//
       vector<int> iRealState = getIndexState(iMaxPart, iReal);
    // ------------get the names of the selected states associated to real modes-------------------//
       vector<string> stateOfRealMode = getStateMode(varDIFFName, iRealState);
    // ----------------get the names of machines associated to real modes---------------------------//
       vector<string> nameRealMach_ = nameMachine(iRealState);
    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    // ==============================START THE DUMP of  SIMPLIFIED EIGEN ANALYSIS===================//
    // =======================================OF SMALL SYSTEM=======================================//
    // =============================================================================================//
    // ----------------------------Define the possible differential states,-------------------------//
    // -----------these states will be used in the definition of the nature of each mode------------//
    // -------------this is the initial set and could be modified in the final version--------------//
       vector<string> strVectorStatesDiff = {"delta", "ww", "theta", "omega", "OMEGA_REF_tetaRef", "lambdad", "lambdaD", "lambdaDPu",
"lambdaq", "lambdaQ", "lambdaQ1", "lambdaQ2", "VR", "AVR", "VoltageRegulator", "lambdaf", "gover", "Gover", "GOVER", "inj", "INJ", "HVDC"};
    // -------------------------------------Dump the stable modes-----------------------------------//
       printToFileStableModes("allModes/allModes.txt", stateOfStableMode, strVectorStatesDiff, realPartImag,
imagPartNew, frequStableMode, dampStableMode,
phaseStableMode, partStableMode, irealPartImag, unstableImagPartNew, iReal, nameStableMach_);
    // -------------------------------------Dump the Unstable modes---------------------------------//
       printToFileUnstableModes("allModes/allModes.txt", stateOfUnstableMode, strVectorStatesDiff, unstableRealPartImag,
unstableImagPartNew, frequUnstableMode,
dampUnstableMode, phaseUnstableMode, partUnstableMode, iUnstableRealPartImag, nameUnstableMach_);
    // -------------------------------------Dump the real modes------------------------------------//
       printToFileRealModes("allModes/allModes.txt", stateOfRealMode, strVectorStatesDiff, realPart, partRealMode, iReal, nameRealMach_);
    /*************************************************************************************************************************************/
}
}
 /** ===============================Part 2: DETAILED MODAL ANALYSIS OF SMALL SYSTEM==============================================
   * @brief return a complete engenanalysis of a small system
   * Subfunctions: getMatrixA, getIndexVariable, getIndexEquation, getNameVariable, writeToFile, getIndexPositionString,
   * writeToFileComplex, createEigenArgMatrix, EigenSolver, getIndexPositionMax, convertEigenArrayToStdVector, getValueIndex,
   * computeFrequency, computeDamping, getStateMode, nameMachine, printToFileStableModes, printToFileUnstableModes,
   * printToFileRealModes, printToFileCoupledDevices, getSelectedParticipation, getNameDynamicDevices,
   * indexMostCoupledDevices, printCoupledDevices
   * @param t time to use for the evaluation
   * @param partFactor minimum value of participation factor that will be used to selecte the coupled dynamic devices
     ============================================================================================================================
   */
void
ModelMulti::evalmodalAnalysis(const double t, const double partFactor) {  //, std::vector<double> y
    if (t != 0) {
    /** check if the folder "allModes" exists or not*/
       if (!exists("modalAnalysis")) {
       create_directory("modalAnalysis");
       }
      float participation;
      participation = partFactor;

    /*************************************************************************************************************************************/
    /*******************************COMPUTE THE MATRIX A and the INPUT/OUTPUT MATRICES B/C************************************************/
      MatrixXd A = getMatrixA(t);
    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    /*************************EXTRACT THE INDEX POSITIONS and NAMES OF DIFFERENTIAL AND ALGEBRAIC VARIABLES*******************************/
    // get the index positions of differential variables
      std::vector<int> indexVarDiff = getIndexVariable(1);
    // get the names of algbraic variables
      std::vector<std::string> varAlgName = getNameVariable(2);
    //  get the names of differential variables
      std::vector<std::string> varNameCombined = getNameVariable(1);
    //  get the new vector of all generated variables acording to the new distribution of the nonlinear system
      varNameCombined.insert(varNameCombined.end(), varAlgName.begin(), varAlgName.end());
    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    /***************************************COMPUTE and DUMP THE EIGENVALUES AND EIGENVECTORS*********************************************/
      Eigen::EigenSolver<Eigen::MatrixXd> s1(A);
    //  ===========================Compte the eigenvalues==========================================//
      VectorXcd eigenValComplex = s1.eigenvalues();
    //  =======================Compute the right eigenvectors======================================//
      MatrixXcd eigenVectorComplex =  s1.eigenvectors();
    //  =======================Generate the real parts of right eigenvectors=======================//
      MatrixXd eigenVectorReal =  s1.eigenvectors().real();
    // ========================Generate the imag parts of right eigenvectors=======================//
      MatrixXd eigenVectorImag;
      eigenVectorImag =  s1.eigenvectors().imag();
    // =============================Dump the eigenvalues of A==================================//
      writeToFileComplex(eigenValComplex, "modalAnalysis/eigenvaluesA.txt");

    // =============================Dump the Eigenvectors of A=================================//
      writeToFileComplex(eigenVectorComplex, "modalAnalysis/rightEigenvectorsA.txt");
    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    /*******************************ALL processing related to eigenvalues and eigenvectors************************************************/
    // ============Compute the matrix of phase postion associated at each state====================//
      MatrixXd phaseMatrix = createEigenArgMatrix(eigenVectorComplex);
    // ==========================Dump the matrix of phase position=================================//
      writeToFile(phaseMatrix, "modalAnalysis/file_Pahse_Vr.txt");
    // =============Compute and dump the real participation factors matrix=========================//
    // ==============associated to the eigenvalues using the eigenvectors==========================//
    // =========Firstly, check the singularty of right eigenvector matrix==========================//
    // ====if the matrix is singular, it is required to check the stabilty of system===============//
      MatrixXd matRealParticipation(indexVarDiff.size(), indexVarDiff.size());
      float detVr = eigenVectorComplex.determinant().real();
      float detVi = eigenVectorComplex.determinant().imag();
      if (detVr == 0 && detVi == 0) {
         Trace::error() << "THE MATRIX OF RIGTH EIGENVECTOR IS SINGULAR" << Trace::endline;
         exit(1);
      } else {
    //  ------Compute the left eigenvectors matrix based on the right eigenvectors matrix----------//
        MatrixXd eigenVecRealLeft = eigenVectorComplex.inverse().real().transpose();
    //  ----------------------Dump the matrix of left eigenvectors---------------------------------//
        writeToFile(eigenVecRealLeft, "modalAnalysis/eigenVecRealLeft.txt");
    //  ------------------------Compute the participation matrix-----------------------------------//
        matRealParticipation = eigenVectorReal.cwiseProduct(eigenVecRealLeft);
    //  ------------------------Dump the participation matrix--------------------------------------//
        writeToFile(matRealParticipation, "modalAnalysis/Participation_Real_Matrix.txt");
}
    //  =====Compute the maximum values of each column of participation factors matrix=============//
       VectorXd vectorMaxParticipationCol = matRealParticipation.cwiseAbs().colwise().maxCoeff();
    //  ==================Compute the real relative participation matrix===========================//
       MatrixXd matRelativeRealParticipation(indexVarDiff.size(), indexVarDiff.size());
      for (unsigned int row = 0; row < indexVarDiff.size(); row++) {
          matRelativeRealParticipation.col(row) =  (matRealParticipation.cwiseAbs()).col(row)/vectorMaxParticipationCol(row);
      }
    //  ======Determine the index position associated to maximum relative participation=============//
    //  ============of each col of real relative particpation factors matrix========================//
       vector<double> iMaxPart = getIndexPositionMax(matRelativeRealParticipation);
    //  ===================Specific treatments of eigenvalues and eigenvectors======================//
    //  -----------------------get all imaginary parts of eigenvalues-------------------------------//
       ArrayXd imagEigenA = eigenValComplex.imag();
    //  --------------------------get all real parts of eigenvalues---------------------------------//
       ArrayXd realEigenA = eigenValComplex.real();
    //  ---------------------get the non-zero imginary parts ---------------------------------------//
       vector<double>imagPart = getImagRealIndexPart(imagEigenA, realEigenA, 1);
    //  ------Eliminate the redundancy in the vector of imagPart (eliminate the conjugate)----------//
       imagPart.erase(std::unique(imagPart.begin(), imagPart.end()), imagPart.end());
    //  ---------------------------------get the real modes-----------------------------------------//
       vector<double>realPart = getImagRealIndexPart(imagEigenA, realEigenA, 2);
    //  -------------------get the index positions of purly real modes------------------------------//
       vector<double>iReal = getImagRealIndexPart(imagEigenA, realEigenA, 3);
    //  ---------------------Convert Eigen Array to std vector--------------------------------------//
    //  ---------------std vector contains all imag parts of eigenvalue-----------------------------//
       vector<double> allImagPart = convertEigenArrayToStdVector(imagEigenA);
    //  ------------get index position of non-zero imaginary parts "imagPart"-----------------------//
       vector<double> iImag = getIndexImagPart(imagPart, allImagPart);
    //  ------------get the stable real parts associated to the non-zero imaginary parts------------//
       vector<double> realPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 1);
    //  -----get the index positions of stable real parts associated to non-zero imaginary parts----//
       vector<double> irealPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 2);
    //  -----------get the unstable real parts associated to non-zero imaginary parts---------------//
       vector<double> unstableRealPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 3);
    //  ----get the index positions of unstable real parts associated to non-zero imaginary parts---//
       vector<double> iUnstableRealPartImag = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 4);
    // get the index positions of stable and unstable real part associated to non-zero imaginary parts//
       vector<double> irealPartImag_ = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 5);
    //  ------------get the imag parts associated to the stable non-zero real parts -----------------//
       vector<double> imagPartNew = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 6);
    //  ------get the unstable imag parts associated to the unstable non-zero real parts ----------//
       vector<double> unstableImagPartNew = getStableUnstableIndexofModes(iImag, realEigenA, imagPart, 7);
    // ----------------------------Define the main differential states,-----------------------------//
    // -----------these states will be used in the defintion of the nature of each mode-------------//
    // -------------this is the initial set and it could be modified in the final version---------------//
       vector<string> strVectorStatesDiff = {"delta", "ww", "theta", "omega", "OMEGA_REF_tetaRef", "lambdad", "lambdaD", "lambdaDPu",
"lambdaq", "lambdaQ", "lambdaQ1", "lambdaQ2", "VR", "AVR", "VoltageRegulator", "lambdaf", "gover", "Gover", "GOVER", "inj", "INJ", "HVDC"};
    // -----------get the maximum participation factors associated to the stable mode---------------//
       vector<float> partStableMode = getValueIndex(matRelativeRealParticipation, irealPartImag, iMaxPart, indexVarDiff.size());
    // --------get the maximum participation factors assocaited to purly real modes-----------------//
       vector<float> partRealMode = getValueIndex(matRelativeRealParticipation, iReal, iMaxPart, indexVarDiff.size());
    // -----------get the maximum participation factors assocaited to unstable modes----------------//
       vector<float> partUnstableMode = getValueIndex(matRelativeRealParticipation, iUnstableRealPartImag, iMaxPart, indexVarDiff.size());
    // --------------------get the phase associated to stable modes---------------------------------//
       vector<float> phaseStableMode = getValueIndex(phaseMatrix, irealPartImag, iMaxPart, indexVarDiff.size());
    // --------------------get the phase associated to unstable modes-------------------------------//
       vector<float> phaseUnstableMode = getValueIndex(phaseMatrix, iUnstableRealPartImag, iMaxPart, indexVarDiff.size());
    // ------------------get the frequencies assocaited to stable modes-----------------------------//
       vector<float> frequStableMode = computeFrequency(imagPartNew);
    // ------------------get the frequencies associated to unstable modes---------------------------//
       vector<float> frequUnstableMode = computeFrequency(unstableImagPartNew);
    // ---------------------get the damping associated to stable modes------------------------------//
       vector<float> dampStableMode = computeDamping(realPartImag, imagPartNew);
    // ---------------------get the damping associated to unstable modes----------------------------//
       vector<float> dampUnstableMode = computeDamping(unstableRealPartImag, unstableImagPartNew);
    // --------------------get the names of differential variables----------------------------------//
    // vector<string> varDIFFName = {"Model_delta", "Model_omega", "Model_eqp", "Model_Pgv", "Model_Pm", "Model_U1", "Model_U2"};
       vector<string> varDIFFName = getNameVariable(1);
    // =====================================Stable Modes============================================//
    // -------------get the index position of the state associated to the most important------------//
    // --------------------------participation of each stable mode----------------------------------//
       vector<int> iStableState = getIndexState(iMaxPart, irealPartImag);
    // ------------get the name of selected state associated to stable modes------------------------//
       vector<string> stateOfStableMode = getStateMode(varDIFFName, iStableState);
    // ----------------get the names of machines associated to stable modes--------------------------//
       vector<string> nameStableMach_ = nameMachine(iStableState);
    // ===================================Unstable Modes============================================//
    // -------------get the index position of the state associate to the most important-------------//
    // --------------------------participation of each unstable mode--------------------------------//
       vector<int> iUnstableState = getIndexState(iMaxPart, iUnstableRealPartImag);
    // ---------------get the names of machines associated to unstable modes-------------------------//
       vector<string> nameUnstableMach_ = nameMachine(iUnstableState);
    // ------------get the names of selected states associated to unstable modes----------------------//
       vector<string> stateOfUnstableMode = getStateMode(varDIFFName, iUnstableState);
    // ======================================Real Modes=============================================//
    // -------------get the index position of the state associate to the most important-------------//
    // --------------------------participation of each real mode------------------------------------//
       vector<int> iRealState = getIndexState(iMaxPart, iReal);
    // ------------------get the names of machines associated to real modes--------------------------//
       vector<string> nameRealMach_ = nameMachine(iRealState);
    // ------------get the names of selected states associated to real modes--------------------------//
       vector<string> stateOfRealMode = getStateMode(varDIFFName, iRealState);
    /*************************************************************************************************************************************/

    /*************************************************************************************************************************************/
    // ==============================START THE DUMP of  COMPLET EIGEN ANALYSIS======================//
    // =======================================OF SMALL SYSTEM=======================================//
    // =============================================================================================//
    // -------------------------------------Dump the stable modes-----------------------------------//
       printToFileStableModes("modalAnalysis/fullSmallModalAnalysis.txt", stateOfStableMode, strVectorStatesDiff, realPartImag,
imagPartNew, frequStableMode, dampStableMode,
phaseStableMode, partStableMode, irealPartImag, unstableImagPartNew, iReal, nameStableMach_);
    // -----------------------------------Dump the unstable modes-----------------------------------//
       printToFileUnstableModes("modalAnalysis/fullSmallModalAnalysis.txt", stateOfUnstableMode, strVectorStatesDiff, unstableRealPartImag,
unstableImagPartNew, frequUnstableMode,
dampUnstableMode, phaseUnstableMode, partUnstableMode, iUnstableRealPartImag, nameUnstableMach_);
    // --------------------------------------Dump the real modes------------------------------------//
       printToFileRealModes("modalAnalysis/fullSmallModalAnalysis.txt", stateOfRealMode, strVectorStatesDiff, realPart, partRealMode, iReal,
nameRealMach_);
    // ----------------Dump the coupled devices of stable and unstable complex modes----------------//
       printToFileCoupledDevices("modalAnalysis/fullSmallModalAnalysis.txt", irealPartImag_, matRelativeRealParticipation, phaseMatrix,
eigenValComplex, strVectorStatesDiff, participation);
    /*************************************************************************************************************************************/
}
}
  // =======================================Part 3: Subparticipation=================================================
  // @brief return the subparticipation associated to a given mode ==================================================
  // * @param t time to use for the evaluation
  // * @param nbrMode number of the mode that will be classified
  // ================================================================================================================
void
ModelMulti::subParticipation(const double t, int nbrMode) {
    if (t != 0) {
       if (!exists("subParticipation")) {
       create_directory("subParticipation");
       }
      // ====construct the matrix A using the function "getMatrixA()"====//
      MatrixXd A = getMatrixA(t);
      // ====compute the eigenvalues, right eigenvectors, and real parts of eigenvalues ===//
      EigenSolver<MatrixXd> s1(A);
      VectorXcd eigenValComplex = s1.eigenvalues();
      MatrixXcd eigenVectorComplex =  s1.eigenvectors();
      MatrixXd eigenVectorReal =  s1.eigenvectors().real();
      // ====compute the matrix of the left eigenvectors====//
      MatrixXd eigenVecRealLeft = eigenVectorComplex.inverse().real().transpose();
      // ====construct vector of index positions of differential variables using the function "getIndexVariable()"====//
      std::vector<int> indexVarDiff = getIndexVariable(1);
      // ===compute the matrix of participation factors ===//
      MatrixXd matRealParticipation(indexVarDiff.size(), indexVarDiff.size());
      float detVr = eigenVectorComplex.determinant().real();
      float detVi = eigenVectorComplex.determinant().imag();
      if (detVr == 0 && detVi == 0) {
         Trace::error() << "THE MATRIX OF RIGTH EIGENVECTOR IS SINGULAR" << Trace::endline;
         exit(1);
      } else {
        matRealParticipation = eigenVectorReal.cwiseProduct(eigenVecRealLeft);
      // =======dump the sub-participation factors of a given mode "nbrMode" =======//
        printSubParticipation(nbrMode, matRealParticipation, eigenValComplex);
}
}
}
  // =====================================Part 4: linearisation function===========================================
  // @brief return the state matrix, input marix, output matrix,  the index positions of===========================
  // =====================Algebraic/Differential Variables/Equations and the names of all variables================
  // ==============================================================================================================
  // * @param t time to use for the evaluation
  // ==============================================================================================================
void
ModelMulti::evalLinearise(const double t) {
     MatrixXd A = getMatrixA(t);
     MatrixXd B = getMatrixB(t);
     MatrixXd C = getMatrixC();
     MatrixXd RSM = getMatrixRSM(t);
     // MatrixXd RSM1 = contructReducedMatrix(t);
     largeScaleModalAnalysis(t);
     vector<std::string> namemach = nameMachineDiff();
     writeToFileString(namemach, "Linearisation/namemach.log");
}

  // ========================Part 5: Modal analysis of Large scale-power systems===================================
  // ==============================================================================================================

  // @brief compute the Relative Sensitivity Matrix RSM of any given power system
  // * @param t time to use for the evaluation
MatrixXd
ModelMulti::getMatrixRSM(const double t) {
     MatrixXd A = getMatrixA(t);
     MatrixXd B = getMatrixB(t);
     MatrixXd C = getMatrixC();
     MatrixXd RSM(B.cols(), B.cols());  // final matrix of Relative sentitivity Matrix
     MatrixXd RSM1 = MatrixXd::Zero(B.cols(), B.cols());
     MatrixXd RSM2(B.cols(), B.cols());
     MatrixXd S(B.cols(), B.cols());
     MatrixXd Sinv(B.cols(), B.cols());
     MatrixXd S3(B.cols(), B.cols());
     MatrixXd S1 = MatrixXd::Zero(B.cols(), B.cols());
     MatrixXd Rij(B.cols(), B.cols());
     MatrixXd pow_A_rij(B.rows(), B.rows());
     MatrixXd A0 = MatrixXd::Identity(B.rows(), B.rows());
     // compute the matrices of sensitivity S and of relative degree Rij
     for (unsigned int i = 0; i < B.cols(); i++) {
     int rij = 1;
     for (unsigned int j = 0; j < B.cols(); j++) {
     S(j, i) = C.row(j)*A0*B.col(i);
     pow_A_rij = A0;
     while (abs(S(j, i)) <= 0) {
     ++rij;
         for (int k = 0; k < rij; k++) {
              if (k+1 < rij) pow_A_rij = pow_A_rij * A;
         }
              S(j, i) = C.row(j)*pow_A_rij*B.col(i);
     }
              Rij(j, i) = rij;
              rij = 1;
     }
     }
     // compute the RSM matrix
     float detS = S.determinant();
     if (detS != 0 && abs(detS) < 0.001) {
     // compute the square of S
     for (unsigned int i = 0; i < B.cols(); i++) {
         for (unsigned int j = 0; j < B.cols(); j++) {
             S1(i, j) = S(i, j)*S(i, j);
         }
     }
     // determine the matrix of coupled dynamic devices RSM using the first RST method
     ArrayXd S2 = S1.rowwise().sum();
     for (unsigned int i = 0; i < B.cols(); i++) {
         for (unsigned int j = 0; j < B.cols(); j++) {
             S3(i, j) = S1(i, j)/S2(i);
               if (S3(i, j) > 0.009) {
                  RSM1(i, j) = 1;
               }
          }
     }
     RSM = RSM1;
     // determine the matrix of coupled dynamic devices RSM using the second RST method
     } else {
     Sinv = S.inverse().transpose();
     for (unsigned int i = 0; i < B.cols(); i++) {
     for (unsigned int j = 0; j < B.cols(); j++) {
     RSM2(i, j) = S(i, j)*Sinv(j, i);
     }
     }
     RSM = RSM2;
     }
     // several dumps are used for the test in this version
     writeToFile(RSM, "Linearisation/RSM.txt");
     writeToFile(Rij, "Linearisation/Rij.txt");
     return RSM;
}
  // @brief return the indices of states of relevant coupled dynamic devices
vector<int>
ModelMulti::getRelevantIndex(vector<int> coupledClass) {
     vector<string> dynamicDeviceNames = nameMachineDiff();
     vector<string> allDynamicDeviceNames = nameDynamicDevicesDiff();
     writeToFileString(allDynamicDeviceNames, "Linearisation/allDynamicDeviceNames.log");
     vector<int> allNewIndexVars;
     for (unsigned int i = 0; i < coupledClass.size(); i++) {
         if (coupledClass[i] != 0) {
         vector<int> newIndexVars = getIndexPositionString(allDynamicDeviceNames, dynamicDeviceNames[i]);
         allNewIndexVars.insert(allNewIndexVars.end(), newIndexVars.begin(), newIndexVars.end());
         }
     }
     return allNewIndexVars;
}
  // @brief return the indices of states of less relevant coupled dynamic devices
vector<int>
ModelMulti::getLessRelevantIndex(vector<int> coupledClass) {
     vector<string> dynamicDeviceNames = nameMachineDiff();
     vector<string> allDynamicDeviceNames = nameDynamicDevicesDiff();
     vector<int> allbarIndexVars;
     for (unsigned int i = 0; i < coupledClass.size(); i++) {
         if (coupledClass[i] != 1) {
         cout << "coupledClass[i]:" << coupledClass[i] << endl;
         vector<int> barIndexVars = getIndexPositionString(allDynamicDeviceNames, dynamicDeviceNames[i]);
         allbarIndexVars.insert(allbarIndexVars.end(), barIndexVars.begin(), barIndexVars.end());
         }
     }
     return allbarIndexVars;
}
  // @brief get the sub matrix of A
Eigen::MatrixXd
ModelMulti::getSubMatrix(MatrixXd A, vector<int> indexi, vector<int> indexj) {
    MatrixXd subA = MatrixXd::Zero(indexi.size(), indexj.size());
    for (unsigned int i = 0; i < indexi.size(); i++) {
    for (unsigned int j = 0; j < indexj.size(); j++) {
    subA(i, j) = A(indexi[i], indexj[j]);
    }
    }
return subA;
}
  // @brief construct reduced matrix A (used for Selective Modla analysis) based on the coupled devices
Eigen::MatrixXd
ModelMulti::contructReducedMatrix(const double t, vector<int> coupledClass) {
    MatrixXd A = getMatrixA(t);
    vector<int> allindex = getRelevantIndex(coupledClass);
    vector<int> barindex = getLessRelevantIndex(coupledClass);
    writeToFileStd(allindex, "Linearisation/allindex.log");
    writeToFileStd(barindex, "Linearisation/barindex.log");
    MatrixXd A11 = getSubMatrix(A, allindex, allindex);
    MatrixXd A12 = getSubMatrix(A, allindex, barindex);
    MatrixXd A21 = getSubMatrix(A, barindex, allindex);
    MatrixXd A22 = getSubMatrix(A, barindex, barindex);

     writeToFile(A11, "Linearisation/A110.txt");
     writeToFile(A12, "Linearisation/A120.txt");
     writeToFile(A21, "Linearisation/A210.txt");
     writeToFile(A22, "Linearisation/A220.txt");
    return A11;
}
    // @brief get the transfer matrix H of selective modal analysis
Eigen::MatrixXcd
ModelMulti::contructMMatrix(const double t, vector<int> coupledClass) {
    MatrixXd A = getMatrixA(t);
    vector<int> allindex = getRelevantIndex(coupledClass);
    vector<int> barindex = getLessRelevantIndex(coupledClass);
    MatrixXd A11 = getSubMatrix(A, allindex, allindex);
    MatrixXd A12 = getSubMatrix(A, allindex, barindex);
    MatrixXd A21 = getSubMatrix(A, barindex, allindex);
    MatrixXd A22 = getSubMatrix(A, barindex, barindex);
    EigenSolver<MatrixXd> s1(A11);
    MatrixXcd X1;
    MatrixXcd X2;
    Eigen::ArrayXcd X3;
    VectorXcd eigenValComplex = s1.eigenvalues();
    MatrixXcd eigenVectorComplex =  s1.eigenvectors();
    MatrixXcd H = MatrixXcd::Zero(A11.rows(), A11.rows());;
    MatrixXcd M;
    MatrixXd E = MatrixXd::Identity(A22.rows(), A22.rows());
    cout << "end0:" << endl;
    for (unsigned int i = 0; i < A11.rows(); i++) {
    X1 = (eigenValComplex(i)*E - A22);
    X2 = A12*X1.inverse()*A21;
    // cout << "end4:" << endl;
    X3 = X2*eigenVectorComplex.col(i);
    // cout << "end3:" << endl;
    // cout << "X3.size():" << X3.size() << endl;
    for (unsigned int j = 0; j < X3.size(); j++) {
    H(i, j) = X3(j);
    }
    // (A12*((eigenValComplex(i)1E-A22).inverse())*A21)*eigenVectorComplex.col(i);
    }
    writeToFileComplex(H, "Linearisation/H.txt");
    M = H*eigenVectorComplex.inverse();
    writeToFileComplex(M, "Linearisation/M.txt");
    // cout << "end:" << endl;
    return H;
}

    // @brief get the condition number of matrix
double
ModelMulti::getCond(Eigen::MatrixXcd Acond) {
     Eigen::JacobiSVD<MatrixXcd> svd(Acond);
     double condA =  svd.singularValues().maxCoeff()/svd.singularValues().minCoeff();
     return condA;
}

    // @brief convert of eigen matrix to armadillo matrix (
mat
ModelMulti::example_cast_arma(Eigen::MatrixXd eigen_A) {
    arma::mat arma_B = arma::mat(eigen_A.data(), eigen_A.rows(), eigen_A.cols(),
                               false, false);
    return arma_B;
    }

    // @brief Compue the eigenvalues based on the classes of coupled dynamic devices
void
ModelMulti::largeScaleModalAnalysis(const double t) {
    if (t != 0) {
       if (!exists("largeScaleModalAnalysis")) {
       create_directory("largeScaleModalAnalysis");
       }
    MatrixXd Ainit = getMatrixA(t);
    // arma::mat arma_Adiff1 = arma::mat(Ainit.data(), Ainit.rows(), Ainit.cols(),
    //                           false, false);
    // arma::cx_vec eigval;
    // arma::cx_mat eigvec;
    // arma::eig_gen(eigval, eigvec, arma_Adiff1);
    MatrixXd I = MatrixXd::Identity(Ainit.rows(), Ainit.rows());
    vector<int> coupledClass;
    vector<std::complex<double> > alleigen;
    vector<std::complex<double> > alleigen1;
    MatrixXcd A;
    MatrixXcd ACond;
    MatrixXd RSM = getMatrixRSM(t);
    for (unsigned int i = 0; i < RSM.rows(); i++) {
    for (unsigned int j = 0; j < RSM.rows(); j++) {
    coupledClass.push_back(RSM(i, j));
    }
    MatrixXd Ared = contructReducedMatrix(t, coupledClass);
    // cout << "end1:" << endl;
    MatrixXcd M = contructMMatrix(t, coupledClass);
    A = M + Ared;
    // A.imag() = M.imag();
    Eigen::ComplexEigenSolver<MatrixXcd> s(A);
    Eigen::ArrayXcd eigenValComplex = s.eigenvalues();
    for (unsigned int m = 0; m < eigenValComplex.size(); m++) {
    ACond = eigenValComplex(m)*I - Ainit;
    double condA = getCond(ACond);
    if (condA > 10) {
    cout << "eigenValComplex.size():" << eigenValComplex.size() <<"--condA:" << condA << "--ArrayXcd:" << eigenValComplex(m) << endl;
    }
    }
    /* for (unsigned int k = 0; k < eigenValComplex.size(); k++) {
    cout << "ArrayXcd:" << eigenValComplex(k) << endl;
    }*/
    alleigen1 = convertEigenArrayCToStdVector(eigenValComplex);
    alleigen.insert(alleigen.end(), alleigen1.begin(), alleigen1.end());
    coupledClass.clear();
    }
    writeToFileComplexStd(alleigen, "Linearisation/alleigen.txt");
    writeToFileComplex(A.real(), "Linearisation/Areal.txt");
    writeToFileComplex(A.imag(), "Linearisation/Aimag.txt");
}
}

}  // namespace DYN
