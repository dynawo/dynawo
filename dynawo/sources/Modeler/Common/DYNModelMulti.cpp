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

ModelMulti::ModelMulti() {
  sizeF_ = 0;
  sizeY_ = 0;
  sizeZ_ = 0;
  sizeG_ = 0;
  sizeMode_ = 0;
  sizeCalculatedVar_ = 0;
  offsetFOptional_ = 0;
  zChange_ = false;
  modeChangeType_ = NO_MODE;
  modeChange_ = false;
  connectorContainer_.reset(new ConnectorContainer());
  fLocal_ = NULL;
  yLocal_ = NULL;
  ypLocal_ = NULL;
  gLocal_ = NULL;
  zLocal_ = NULL;
  fType_ = NULL;
  yType_ = NULL;
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
  Trace::debug("PARAMETERS") << "------------------------------" << Trace::endline;
  Trace::debug("PARAMETERS") << "SubModel " << sub->name() << Trace::endline;
  Trace::debug("PARAMETERS") << "------------------------------" << Trace::endline;

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

  subModelByName_[sub->name()] = sub;
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
      subModels_[i]->setBufferZ(zLocal_, offsetZ);
    offsetZ += sizeZ;
  }
  connectorContainer_->setBufferF(fLocal_, offsetF);
  connectorContainer_->setBufferY(yLocal_, ypLocal_);  // connectors access to the whole y Buffer
  connectorContainer_->setBufferZ(zLocal_);  // connectors access to the whole z buffer

  // (3) init buffers of each sub-model (useful for the network model)
  // (4) release elements that were used and declared only for connections
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->initSubBuffers();
    subModels_[i]->releaseElements();
  }
}

void
ModelMulti::init(const double& t0) {
  Timer timer1("ModelMulti::init");

  zSave_.assign(zLocal_, zLocal_ + sizeZ());

  // (1) initialising each sub-model
  //----------------------------------------
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->initSub(t0);

  // Detect if some discrete variable was modified during the initialization (e.g. subnetwork detection)
  std::vector<double> z(sizeZ());
  z.assign(zLocal_, zLocal_ + sizeZ());
  vector<int> indicesDiff;
  for (unsigned int i = 0; i < z.size(); ++i) {
    if (doubleNotEquals(z[i], zSave_[i])) {
      indicesDiff.push_back(i);
    }
  }

  // (2) initialising init values
  //-------------------------------
  vector<double> y0(sizeY(), 0.);
  vector<double> yp0(sizeY(), 0.);
  vector<double> z0(sizeZ(), 0.);
  getY0(t0, y0, yp0, z0);

  // Propagate the potential modifications of discrete variables. Needed here as otherwise
  // the next evalZ will not detect the modifications.
  if (!indicesDiff.empty()) {
    for (size_t i = 0; i < indicesDiff.size(); ++i) {
      zLocal_[indicesDiff[i]] = z[indicesDiff[i]];
    }
    z.assign(zLocal_, zLocal_ + sizeZ());

    connectorContainer_->propagateZDiff(indicesDiff, z);

    std::copy(z.begin(), z.end(), zLocal_);
    zSave_.assign(zLocal_, zLocal_ + sizeZ());

    for (unsigned int i = 0; i < subModels_.size(); ++i)
      subModels_[i]->evalZSub(t0);
    z.assign(zLocal_, zLocal_ + sizeZ());

    for (unsigned j = 0; j < 10 && !vectorAreEquals(zSave_, z); ++j) {
      copieResultZ(z);
      std::copy(z.begin(), z.end(), zLocal_);
      for (unsigned int i = 0; i < subModels_.size(); ++i)
        subModels_[i]->evalGSub(t0);
      for (unsigned int i = 0; i < subModels_.size(); ++i)
        subModels_[i]->evalZSub(t0);
      z.assign(zLocal_, zLocal_ + sizeZ());
    }
  }
}

void
ModelMulti::printModel() {
  Timer timer("ModelMulti::printModel");
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->printModel();

  connectorContainer_->printConnectors();
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
  Timer timer("ModelMulti::zChange");
  return zChange_;
}

void
ModelMulti::zChange(bool /*zChange*/) {
  // not yet coded .. is this function necessary?
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
#ifdef _DEBUG_
  Timer timer("ModelMulti::evalF");
#endif
  copyContinuousVariables(y, yp);

  Timer * timer2 = new Timer("ModelMulti::evalF_subModels");
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    if (subModels_[i]->sizeF() != 0)
      subModels_[i]->evalFSub(t);
  }
  delete timer2;

  connectorContainer_->evalFConnector(t);

  std::fill(fLocal_ + offsetFOptional_, fLocal_ + sizeF_, 0);

  std::copy(fLocal_, fLocal_ + sizeF_, f);
}

void
ModelMulti::evalG(double t, vector<state_g> &g) {
#ifdef _DEBUG_
  Timer timer("ModelMulti::evalG");
#endif
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->evalGSub(t);

  std::copy(gLocal_, gLocal_ + sizeG_, g.begin());
}

void
ModelMulti::evalJt(const double t, const double cj, SparseMatrix& Jt) {
#ifdef _DEBUG_
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
ModelMulti::evalZ(double t, vector<double> &z) {
#ifdef _DEBUG_
  Timer timer("ModelMulti::evalZ");
#endif
  if (sizeZ() == 0) return;

  std::copy(z.begin(), z.end(), zLocal_);

  // calculate Z by model
  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->evalZSub(t);

  std::copy(zLocal_, zLocal_ + z.size(), z.begin());

  // propagation of z changes to connected variables
  if (zSave_.size() != z.size())
    zSave_.assign(z.size(), 0.);

  if ( !vectorAreEquals(zSave_, z) ) {
    zChange_ = true;
    copieResultZ(z);
  } else {
    zChange_ = false;
  }
}

void
ModelMulti::copieResultZ(vector<double> & z) {
  vector<int> indicesDiff;
  for (unsigned int i = 0; i < z.size(); ++i) {
    if (doubleNotEquals(z[i], zSave_[i]))
      indicesDiff.push_back(i);
  }

  connectorContainer_->propagateZDiff(indicesDiff, z);
  zSave_ = z;
}

void
ModelMulti::evalMode(double t) {
  Timer timer("ModelMulti::evalMode");
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
    if (subModels_[i]->modeChange())
      modeChange_ = true;
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
ModelMulti::evalCalculatedVariables(const double & t, const vector<double> &y, const vector<double> &yp, const vector<double> &z) {
  Timer timer("ModelMulti::evalCalculatedVariables");
  std::copy(y.begin(), y.end(), yLocal_);
  std::copy(yp.begin(), yp.end(), ypLocal_);
  std::copy(z.begin(), z.end(), zLocal_);

  for (unsigned int i = 0; i < subModels_.size(); ++i)
    subModels_[i]->evalCalculatedVariablesSub(t);
}

void
ModelMulti::checkDataCoherence(const double & t) {
  Timer timer("ModelMulti::checkDataCoherence");

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
ModelMulti::getY0(const double& t0, vector<double>& y0, vector<double>& yp0, vector<double>& z0) {
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    subModels_[i]->getY0Sub();
    subModels_[i]->evalCalculatedVariablesSub(t0);
  }
  connectorContainer_->getY0Connector();

  std::copy(yLocal_, yLocal_ + sizeY_, y0.begin());
  std::copy(ypLocal_, ypLocal_ + sizeY_, yp0.begin());
  std::copy(zLocal_, zLocal_ + sizeZ_, z0.begin());
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
  std::fill(fType_ + offsetFOptional_, fType_ + sizeF_, ALGEBRIC_EQ);
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
      Trace::debug() << DYNLog(ModelMultiGetParam, curveVariable, value, curveModelName) << Trace::endline;
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
    createCalculatedVariableConnection(subModel1, num1, subModel2, num2);
  } else if ((isState1) && (!isState2)) {
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
  shared_ptr<ConnectorCalculatedVariable> connector(new ConnectorCalculatedVariable());
  connector->name(calculatedVarName1);
  connector->setParams(subModel1, numVar);
  shared_ptr<SubModel> subModelConnector = dynamic_pointer_cast<SubModel> (connector);
  addSubModel(subModelConnector, "");  // no library for connectors
  vector<int> numVars = subModel1->getDefJCalculatedVarI(numVar);
  int col1stYModelExt = connector->col1stYModelExt();

  const vector<string>& xNamesConnector = subModelConnector->xNames();
  const vector<string>& xNamesModel = subModel1->xNames();

  for (unsigned int i = 0; i < numVars.size(); ++i) {
    createConnection(subModelConnector, xNamesConnector[col1stYModelExt + i], subModel1, xNamesModel[numVars[i]], true);
  }

  const vector<string>& xNames = subModel2->xNames();
  createConnection(subModel2, xNames[yNum], subModelConnector, string("connector_" + calculatedVarName1));
}

boost::shared_ptr<SubModel>
ModelMulti::findSubModelByName(const string& name) {
  std::map<string, shared_ptr<SubModel> >::const_iterator iter = subModelByName_.find(name);
  if (iter == subModelByName_.end())
    return (shared_ptr<SubModel>());
  else
    return iter->second;
}

vector<boost::shared_ptr<SubModel> >
ModelMulti::findSubModelByLib(const string& libName) {
  std::map<string, vector<shared_ptr<SubModel> > >::const_iterator iter = subModelByLib_.find(libName);
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
          Trace::debug() << DYNLog(SubModelExtVar, sub->name(), name[j]) << Trace::endline;
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
  Timer timer("ModelMulti::setIsInitProcess");

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
        Trace::info() << DYNLog(AddingCurveParam, modelName, variable) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variable);
        curve->setAsParameterCurve(true);   // This is a parameter curve
        subModel->addParameterCurve(curve);
        return;
      } else if (props.variableNameInSubModel_ == variable) {   // found exact curve name
        Trace::info() << DYNLog(AddingCurve, modelName, variable) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variable);
        curve->setAsParameterCurve(false);   // This is a variable curve
        subModel->addCurve(curve);
        return;
      } else if (props.variableNameInSubModel_ == variableNameBis) {
        Trace::info() << DYNLog(AddingCurveOutput, modelName, variable, variableNameBis) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(variableNameBis);
        subModel->addCurve(curve);
        return;
      }
    } else {
      // BEGIN SEARCH IN NETWORK
      shared_ptr<SubModel> modelNetwork = subModel;
      string name = modelName + "_" + variable;
      if (props.variableNameInSubModel_ == name) {
        Trace::info() << DYNLog(AddingCurveOutput, modelName, variable, name) << Trace::endline;
        curve->setAvailable(true);
        curve->setFoundVariableName(name);
        modelNetwork->addCurve(curve);
        return;
      } else {
        string name2 = name + "_value";
        if (props.variableNameInSubModel_ == name2) {   // find name2 = name_value
          Trace::info() << DYNLog(AddingCurveOutput, modelName, variable, name2) << Trace::endline;
          curve->setAvailable(true);
          curve->setFoundVariableName(name2);
          modelNetwork->addCurve(curve);
          return;
        }
      }
    }
  }

  Trace::warn() << DYNLog(CurveNotAdded, modelName, variable) << Trace::endline;
  return;
}

void
ModelMulti::updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection> curvesCollection,
    std::vector<double>& y, std::vector<double>& yp) {
  Timer timer("ModelMulti::updateCurves");
  for (curves::CurvesCollection::iterator itCurve = curvesCollection->begin(), itCurveEnd = curvesCollection->end();
      itCurve != itCurveEnd; ++itCurve) {
    boost::shared_ptr<Curve> curve = *itCurve;
    shared_ptr<SubModel> subModel = findSubModel(curve->getModelName(), curve->getVariable()).subModel_;
    if (subModel) {
      subModel->updateCalculatedVarForCurve(curve, &y[0], &yp[0]);
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
  Trace::debug("VARIABLES") << "------------------------------" << Trace::endline;
  Trace::debug("VARIABLES") << "X variables init" << Trace::endline;
  Trace::debug("VARIABLES") << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& xNames = subModels_[i]->xNamesInit();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
       Trace::debug("VARIABLES") << nVar << " " << subModels_[i]->name() << "_" << xNames[j] << Trace::endline;
       ++nVar;
    }
  }
  nVar = 0;
  Trace::debug("VARIABLES") << "------------------------------" << Trace::endline;
  Trace::debug("VARIABLES") << "Z variables init" << Trace::endline;
  Trace::debug("VARIABLES") << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& zNames = subModels_[i]->zNamesInit();
    for (unsigned int j = 0; j < zNames.size(); ++j) {
      Trace::debug("VARIABLES") << nVar << " " << subModels_[i]->name() << "_" << zNames[j] << Trace::endline;
      ++nVar;
    }
  }
  nVar = 0;
  Trace::info("VARIABLES") << "------------------------------" << Trace::endline;
  Trace::info("VARIABLES") << "X variables" << Trace::endline;
  Trace::info("VARIABLES") << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& xNames = subModels_[i]->xNames();
    for (unsigned int j = 0; j < xNames.size(); ++j) {
      std::string varName = subModels_[i]->name() + "_" + xNames[j];
      Trace::info("VARIABLES") << nVar << " " << varName << Trace::endline;
      ++nVar;
    }
  }
  nVar = 0;
  Trace::info("VARIABLES") << "------------------------------" << Trace::endline;
  Trace::info("VARIABLES") << "Z variables" << Trace::endline;
  Trace::info("VARIABLES") << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    const std::vector<std::string>& zNames = subModels_[i]->zNames();
    for (unsigned int j = 0; j < zNames.size(); ++j) {
       Trace::info("VARIABLES") << nVar << " " << subModels_[i]->name() << "_" << zNames[j] << Trace::endline;
       ++nVar;
    }
  }
}

void ModelMulti::printEquations() {
  bool isInitProcessBefore = subModels_[0]->getIsInitProcess();
  setIsInitProcess(true);
  int nVar = 0;
  Trace::debug("EQUATIONS") << "------------------------------" << Trace::endline;
  Trace::debug("EQUATIONS") << "Equations init" << Trace::endline;
  Trace::debug("EQUATIONS") << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    for (unsigned int j = 0 ; j < subModels_[i]->sizeFInit() ; ++j) {
      Trace::debug("EQUATIONS") << nVar << " " << subModels_[i]->getFequationByLocalIndex(j) << Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(false);
  nVar = 0;
  Trace::debug("EQUATIONS") << "------------------------------" << Trace::endline;
  Trace::debug("EQUATIONS") << "Equations" << Trace::endline;
  Trace::debug("EQUATIONS") << "------------------------------" << Trace::endline;
  for (unsigned int i = 0; i < subModels_.size(); ++i) {
    for (unsigned int j = 0 ; j < subModels_[i]->sizeF() ; ++j) {
      Trace::debug("EQUATIONS") << nVar << " " << subModels_[i]->getFequationByLocalIndex(j) << Trace::endline;
      ++nVar;
    }
  }
  setIsInitProcess(isInitProcessBefore);
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

void ModelMulti::copyZ(const vector<double> &z) {
  std::copy(z.begin(), z.end(), zLocal_);
}
}  // namespace DYN
