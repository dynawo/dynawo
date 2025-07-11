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
 * @file  DYNConnector.cpp
 *
 * @brief Connector implementation
 */

#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"
#include "DYNConnector.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNTimer.h"

using std::stringstream;
using std::vector;
using std::set;
using std::list;
using std::string;
using boost::shared_ptr;

namespace DYN {

void
Connector::addConnectedSubModel(const connectedSubModel& subModel) {
  connectedSubModels_.push_back(subModel);
}

void
Connector::addConnectedSubModel(const boost::shared_ptr<SubModel>& subModel, const boost::shared_ptr<Variable>& variable, bool negated) {
  connectedSubModels_.emplace_back(subModel, variable, negated);
}

int
Connector::nbConnectedSubModels() const {
  return static_cast<int>(connectedSubModels_.size());
}

ConnectorContainer::ConnectorContainer():
offsetModel_(0),
sizeY_(0),
fLocal_(nullptr),
yLocal_(nullptr),
ypLocal_(nullptr),
zLocal_(nullptr),
zConnectedLocal_(nullptr),
fType_(nullptr),
connectorsMerged_(false) {
}

unsigned int ConnectorContainer::nbYConnectors() const {
  unsigned int nbConnect = 0;
  for (const auto& yConnector : yConnectors_) {  // if there are n variables connected together
    // there are n-1 equations
    nbConnect += std::max(0, yConnector->nbConnectedSubModels() - 1);
  }

  return nbConnect;
}

void
ConnectorContainer::addFlowConnector(const shared_ptr<Connector>& connector) {
  flowConnectorsDeclared_.push_back(connector);  // do not forget mutual statement in the map
}

void
ConnectorContainer::addContinuousConnector(const shared_ptr<Connector>& connector) {
  yConnectorsDeclared_.push_back(connector);
}

void
ConnectorContainer::addDiscreteConnector(const shared_ptr<Connector>& connector) {
  zConnectorsDeclared_.push_back(connector);
}

void
ConnectorContainer::mergeConnectors() {
  if (connectorsMerged_)
    return;

  connectorsMerged_ = true;
  mergeYConnector();
  mergeFlowConnector();
  mergeZConnector();
}

void
ConnectorContainer::mergeYConnector() {
  // order Y connectors
  yConnectors_.clear();
  yConnectorByVarNum_.clear();
  list<shared_ptr<Connector> > yConnectorsList;
  for (const auto& yConnectorDeclared : yConnectorsDeclared_) {
    auto yc = boost::make_shared<Connector>(*yConnectorDeclared);
    bool merged = false;
    for (const auto& connectedSubModel : yc->connectedSubModels()) {
      const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      if (yConnectorByVarNum_.find(numVar) != yConnectorByVarNum_.end()) {
        mergeConnectors(yc, yConnectorByVarNum_[numVar], yConnectorsList, yConnectorByVarNum_);
        merged = true;
        break;
      }
    }

    if (!merged) {
      yConnectorsList.push_back(yc);
      for (const auto& connectedSubModel : yc->connectedSubModels()) {
        const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
        yConnectorByVarNum_[numVar] = yc;
      }
    }
  }

  // Copy kept yConnectors in the vector
  yConnectors_.assign(yConnectorsList.begin(), yConnectorsList.end());
}


int
ConnectorContainer::getConnectorVarNum(const shared_ptr<SubModel>& subModel, const boost::shared_ptr<Variable>& variable, const bool flowConnector) {
  int numVar;
  if (flowConnector && variable->isAlias()) {
    const string id = subModel->name() + "_" + variable->getName();
    const auto& aliasIt = flowAliasNameToFictitiousVarNum_.find(id);
    if (aliasIt != flowAliasNameToFictitiousVarNum_.end()) {
      numVar = aliasIt->second;
    } else {
      numVar = sizeY_ + static_cast<int>(flowAliasNameToFictitiousVarNum_.size());
      flowAliasNameToFictitiousVarNum_[id] = numVar;
    }
  } else {
    numVar = subModel->getVariableIndexGlobal(variable);
  }
  return numVar;
}
void
ConnectorContainer::mergeFlowConnector() {
  // order flow connectors
  flowConnectors_.clear();
  flowConnectorByVarNum_.clear();
  flowAliasNameToFictitiousVarNum_.clear();
  const bool flowConnector = true;
  list<shared_ptr<Connector> > flowConnectorsList;
  for (const auto& flowConnectorDeclared : flowConnectorsDeclared_) {
    auto flowc = boost::make_shared<Connector>(*flowConnectorDeclared);
    bool merged = false;
    for (const auto& connectedSubModel : flowc->connectedSubModels()) {
      const int numVar = getConnectorVarNum(connectedSubModel.subModel(), connectedSubModel.variable(), flowConnector);
      if (flowConnectorByVarNum_.find(numVar) != flowConnectorByVarNum_.end()) {
        mergeConnectors(flowc, flowConnectorByVarNum_[numVar], flowConnectorsList, flowConnectorByVarNum_, flowConnector);
        merged = true;
        break;
      }
    }

    if (!merged) {
      flowConnectorsList.push_back(flowc);
      for (const auto& connectedSubModels : flowc->connectedSubModels()) {
        int numVar = getConnectorVarNum(connectedSubModels.subModel(), connectedSubModels.variable(), flowConnector);
        flowConnectorByVarNum_[numVar] = flowc;
      }
    }
  }

  // Copy kept flowConnectors in the vector
  flowConnectors_.assign(flowConnectorsList.begin(), flowConnectorsList.end());
}

void
ConnectorContainer::mergeZConnector() {
  // order Z connectors
  zConnectors_.clear();
  zConnectorByVarNum_.clear();
  list<shared_ptr<Connector> > zConnectorsList;
  for (const auto& zConnectorDeclared : zConnectorsDeclared_) {
    auto zc = boost::make_shared<Connector>(*zConnectorDeclared);
    bool merged = false;
    for (const auto& connectedSubModel : zc->connectedSubModels()) {
      const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      if (zConnectorByVarNum_.find(numVar) != zConnectorByVarNum_.end()) {
        mergeConnectors(zc, zConnectorByVarNum_[numVar], zConnectorsList, zConnectorByVarNum_);
        merged = true;
        break;
      }
    }

    if (!merged) {
      zConnectorsList.push_back(zc);
      for (const auto& connectedSubModel : zc->connectedSubModels()) {
        const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
        zConnectorByVarNum_[numVar] = zc;
      }
    }
  }

  // Copy kept yConnectors in the vector
  zConnectors_.assign(zConnectorsList.begin(), zConnectorsList.end());
}

void
ConnectorContainer::propagateZConnectionInfoToModel() const {
  if (!connectorsMerged_)
    throw DYNError(Error::MODELER, AttemptToPropagateBeforeMerge);  // should not happen but who knows ...

  for (const auto& zConnector : zConnectors_) {
    if (zConnector->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }
    for (const auto& connectedSubModel : zConnector->connectedSubModels()) {
      const int numVar2 = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      zConnectedLocal_[numVar2] = true;
    }
  }
}

void
ConnectorContainer::mergeConnectors(shared_ptr<Connector> connector, shared_ptr<Connector>& reference,
  list<shared_ptr<Connector> >& connectorsList, std::unordered_map<int, shared_ptr<Connector> >& connectorsByVarNum, const bool flowConnector) {
  // Looking for common variable to test the negated attributes
  bool negatedMerge = false;
  for (const auto& connectedSubModel : connector->connectedSubModels()) {
    const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
    if (connectorsByVarNum.find(numVar) != connectorsByVarNum.end() && connectorsByVarNum[numVar] == reference) {
      // check whether the two connectors have at least one variable in common :
      // if so, the negated attribute of the merge is derived from the shared variable negated attribute comparison
      for (const auto& connectedSubModelRef : connector->connectedSubModels()) {
        if (connectedSubModelRef.subModel()->getVariableIndexGlobal(connectedSubModelRef.variable()) == numVar) {  // found the two connectedSubModels
          negatedMerge = connectedSubModelRef.negated() != connectedSubModel.negated();
          break;
        }
      }
    }
  }

  // Merging connectors
  for (const auto& connectedSubModel : connector->connectedSubModels()) {
    const auto& subModel = connectedSubModel.subModel();
    const auto& variable = connectedSubModel.variable();
    const int numVar = getConnectorVarNum(subModel, variable, flowConnector);
    if (connectorsByVarNum.find(numVar) != connectorsByVarNum.end()) {
      // variable used in a final connector
      if (connectorsByVarNum[numVar] == reference) {
        continue;
      } else if (connectorsByVarNum[numVar] != connector) {
        mergeConnectors(connectorsByVarNum[numVar], reference, connectorsList, connectorsByVarNum, flowConnector);
        continue;
      }
    }
    reference->addConnectedSubModel(subModel, variable, (negatedMerge ? !(connectedSubModel.negated()) : connectedSubModel.negated()));
    connectorsByVarNum[numVar] = reference;
  }

  // When merging two connectors of the list, only keep reference
  connectorsList.remove(connector);
}

void
ConnectorContainer::getConnectorInfos(const int globalFIndex, std::string& subModelName, int& localFIndex, std::string& fEquation) const {
  if (nbContinuousConnectors() == 0)
    return;

  if (globalFIndex < offsetModel_)
    return;

  localFIndex = globalFIndex - offsetModel_;
  assert(localFIndex >= 0);
  unsigned uLocalFIndex = static_cast<unsigned>(localFIndex);
  // find first in yConnectors, then in flowConnectors, at last in zConnectors.
  if (uLocalFIndex < nbYConnectors()) {
    subModelName = "Y Connector";
    fEquation = getYConnectorInfos(localFIndex);
  } else if ((uLocalFIndex >= nbYConnectors())
          && (uLocalFIndex < nbYConnectors() + nbFlowConnectors())) {
    const unsigned int index = localFIndex - nbYConnectors();
    subModelName = "Flow Connector";
    fEquation = getFlowConnectorInfos(index);
  } else if ((uLocalFIndex >= nbYConnectors() + nbFlowConnectors())
          && (uLocalFIndex < nbYConnectors() + nbFlowConnectors() + nbZConnectors())) {
    const unsigned int index = localFIndex - nbYConnectors() - nbFlowConnectors();
    subModelName = "Z Connector";
    fEquation = getZConnectorInfos(index);
  } else {
    subModelName = "SubModel Not Found";
    fEquation = "Fequation Not Found";
  }
}

string
ConnectorContainer::getYConnectorInfos(const int index) const {
  string equation = "";
  int offset = 0;

  for (const auto& yConnector : yConnectors_) {
    const int nbSubModels = static_cast<int>(yConnector->connectedSubModels().size()) - 1;  // -1 because first item (reference) not taken into account
    // check whether the index is inside the current connector
    if (offset + nbSubModels < index) {
      offset += nbSubModels;
    } else {
      const int localOffset = index - offset;  // first item (reference) not taken into account
      const auto& it = yConnector->connectedSubModels().begin();
      // First is reference
      const connectedSubModel& reference = *it;
      equation.append("Y Connector : ").append(reference.subModel()->name()).append(" - ");
      equation.append(yConnector->connectedSubModels().at(localOffset).subModel()->name());

      return equation;
    }
  }

  throw DYNError(Error::MODELER, ConnectorBadInfo, "YConnector", index);
}

string
ConnectorContainer::getConnectorInfos(const string& prefix, const shared_ptr<Connector>& connector) const {
  string equation = prefix;
  const auto& connectedSubModels = connector->connectedSubModels();
  for (const auto& connectedSubModel : connectedSubModels) {
    if (&connectedSubModel != &connectedSubModels.front()) {
      equation.append(" - ");
    }
    equation.append(connectedSubModel.subModel()->name());
  }
  return equation;
}

void
ConnectorContainer::printConnectors() const {
  if (nbContinuousConnectors() == 0)
    return;

  Trace::debug(Trace::modeler()) << DYNLog(ModelConnectorsNB, nbContinuousConnectors()) << Trace::endline;
  Trace::debug(Trace::modeler()) << "         F : [" << std::setw(6) << offsetModel_ << " ; "
                          << std::setw(6) << offsetModel_ + nbContinuousConnectors() << "[" << Trace::endline;
  Trace::debug(Trace::modeler()) << Trace::endline;

  Trace::debug(Trace::modeler()) << " ====== " << DYNLog(ModelConnectorsList) << " ===== " << Trace::endline;
  printYConnectors();
  printFlowConnectors();
  printZConnectors();
}

void
ConnectorContainer::printEquations() const {
  int offset = 0;
  for (const auto& yConnector : yConnectors_) {
    if (yConnector->connectedSubModels().empty()) {
      continue;  // should not happen but who knows ...
    }

    auto it = yConnector->connectedSubModels().begin();
    // First is reference
    const connectedSubModel& reference = *it;
    ++it;
    for (; it != yConnector->connectedSubModels().end(); ++it) {
      const int numEq = offsetModel_ + offset;
      Trace::debug(Trace::equations()) << numEq << " "  << reference.subModel()->name() + "_" + reference.variable()->getName() <<
          " = " << it->subModel()->name() + "_" + it->variable()->getName() << Trace::endline;
      ++offset;
    }
  }

  stringstream ss;
  for (const auto& flowConnector : flowConnectors_) {
    bool first = true;
    ss.str("");
    ss.clear();
    for (const auto& connectedSubModel : flowConnector->connectedSubModels()) {
      const string op = (first ? "" : "+");
      ss << (connectedSubModel.negated() ? "-" : op) << connectedSubModel.variable()->getName();
      first = false;
    }
    ss << " = 0";

    const int numEq = offsetModel_ + offset;
    Trace::debug(Trace::equations()) << numEq << " " << ss.str() << Trace::endline;
    ++offset;
  }
}

void
ConnectorContainer::printYConnectors() const {
  int offset = 0;
  for (const auto& yConnector : yConnectors_) {
    if (yConnector->connectedSubModels().empty()) {
      continue;  // should not happen but who knows ...
    }

    auto it = yConnector->connectedSubModels().begin();
    // First is reference
    const connectedSubModel& reference = *it;
    const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
    ++it;
    for (; it != yConnector->connectedSubModels().end(); ++it) {
      const int numVar2 = it->subModel()->getVariableIndexGlobal(it->variable());
      Trace::debug(Trace::modeler()) << "         Yconnector " << (it->negated() ? "-" : "") << "Y[" << std::setw(6) << numVar2 << "] = "
          << (reference.negated() ? "-" : "") << "Y[" << std::setw(6) << numVarReference << "]"
          << "      F = F[" << std::setw(6) << offsetModel_ + offset
          << "] / " << DYNLog(ConnectedModels, it->subModel()->name(), reference.subModel()->name()) << Trace::endline;
      ++offset;
    }
  }
}

void
ConnectorContainer::printFlowConnectors() const {
  std::size_t offset = yConnectors_.size();
  for (const auto& flowConnector : flowConnectors_) {
    stringstream ss;
    ss << "         flowConnector : ";
    bool first = true;
    for (const auto& connectedSubModel : flowConnector->connectedSubModels()) {
      const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      ss << (connectedSubModel.negated() ? "-" : (first ? "" : "+")) << "Y[" << std::setw(6) << numVar << "] ";
      first = false;
    }
    ss << " = 0";

    ss << "      F = F[" << std::setw(6) << offsetModel_ + offset << "]";
    Trace::debug(Trace::modeler()) << ss.str() << Trace::endline;
    ++offset;
  }
}

void
ConnectorContainer::printZConnectors() const {
  for (const auto& zConnector : zConnectors_) {
    if (zConnector->connectedSubModels().empty()) {
      continue;  // should not happen but who knows ...
    }

    auto it = zConnector->connectedSubModels().begin();
    // First is reference
    const connectedSubModel& reference = *it;
    const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
    ++it;
    for (; it != zConnector->connectedSubModels().end(); ++it) {
      const int numVar2 = it->subModel()->getVariableIndexGlobal(it->variable());
      Trace::debug(Trace::modeler()) << "         Zconnector " << (it->negated() ? "-" : "") << "Z[" << std::setw(6) << numVar2 << "] = "
          << (reference.negated() ? "-" : "") << "Z[" << std::setw(6) << numVarReference << "] / "
          << DYNLog(ConnectedModels, it->subModel()->name(), reference.subModel()->name()) << Trace::endline;
    }
  }
}

void
ConnectorContainer::setBufferFType(propertyF_t* fType, const int offsetFType) {
  fType_ = &fType[offsetFType];
}

void
ConnectorContainer::setBufferF(double* f, const int offsetF) {
  fLocal_ = &f[offsetF];
}

void
ConnectorContainer::setBufferY(double* y, double* yp) {
  yLocal_ = y;
  ypLocal_ = yp;
}

void
ConnectorContainer::setBufferZ(double* z, bool* zConnected) {
  zLocal_ = z;
  zConnectedLocal_ = zConnected;
}

void
ConnectorContainer::evalFConnector(const double /*t*/) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ConnectorContainer::evalF");
#endif

  if (index_.empty()) {
    index_.resize(nbYConnectors() + nbFlowConnectors());
    factor_.resize(nbYConnectors() + nbFlowConnectors());

    int offset = 0;
    for (const auto& yConnector : yConnectors_) {
      if (yConnector->connectedSubModels().empty()) {
        throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
      }

      auto it = yConnector->connectedSubModels().begin();
      // First is reference
      const connectedSubModel& reference = *it;
      const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
      ++it;
      for (; it != yConnector->connectedSubModels().end(); ++it) {
        vector<unsigned int> index(2, 0);
        vector<int> factor(2, 1);
        // First is reference
        index[0] = numVarReference;
        // second the other variable
        index[1] = it->subModel()->getVariableIndexGlobal(it->variable());
        factor[1] = (reference.negated() == it->negated()) ? -1 : 1;
        index_[offset] = index;
        factor_[offset] = factor;
        ++offset;
      }
    }

    // for each flow connector, add a function F = Y0 + Y1;
    for (const auto& flowConnector : flowConnectors_) {
      const auto& connectedSubModels = flowConnector->connectedSubModels();
      const auto connectedSubModelsSize = connectedSubModels.size();
      vector<unsigned int> index(connectedSubModelsSize, 0);
      vector<int> factor(connectedSubModelsSize, 1);

      for (unsigned int j = 0; j < connectedSubModelsSize; ++j) {
        const auto& connectedSubModel = connectedSubModels[j];
        index[j] = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
        factor[j] = connectedSubModel.negated() ? -1 : 1;
      }
      index_[offset] = index;
      factor_[offset] = factor;
      ++offset;
    }
  }

  for (unsigned int i = 0; i < index_.size(); ++i) {
    fLocal_[i] = 0;
    fLocal_[i] = multiplyAndAdd(index_[i], factor_[i]);
  }
}

double
ConnectorContainer::multiplyAndAdd(const vector<unsigned int>& index, const vector<int>& factor) const {
  double sum = 0;
  for (unsigned int i = 0; i < index.size(); ++i)
    sum += factor[i] * yLocal_[index[i]];
  return sum;
}


void
ConnectorContainer::evalJtConnector(SparseMatrix& jt) const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ConnectorContainer::evalJ");
#endif

  // N equations of type 0 = Y0 - Y1
  constexpr double dMOne(-1.);
  constexpr double dPOne(+1.);

  for (const auto& yConnector : yConnectors_) {
    if (yConnector->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    auto it = yConnector->connectedSubModels().begin();
    // First is reference
    const connectedSubModel& reference = *it;
    const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
    ++it;
    for (; it != yConnector->connectedSubModels().end(); ++it) {
      const int numVar2 = it->subModel()->getVariableIndexGlobal(it->variable());
      jt.changeCol();
      if (reference.negated() == it->negated()) {
        jt.addTerm(numVarReference, dPOne);  // d(f)/d(Y0) = +1;
        jt.addTerm(numVar2, dMOne);  // d(f)/d(Y1) = -1;
      } else {
        jt.addTerm(numVarReference, dPOne);  // d(f)/d(Y0) = +1;
        jt.addTerm(numVar2, dPOne);  // d(f)/d(Y1) = +1;
      }
    }
  }

  // M equations of type 0 = sum(Y)
  for (const auto& flowConnector : flowConnectors_) {
    jt.changeCol();
    for (const auto& connectedSubModel : flowConnector->connectedSubModels()) {
      const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      if (connectedSubModel.negated()) {
        jt.addTerm(numVar, dMOne);  // d(f)/d(Yi) = -1;
      } else {
        jt.addTerm(numVar, dPOne);  // d(f)/d(Yi) = +1;
      }
    }
  }
}

void
ConnectorContainer::evalJtPrimConnector(SparseMatrix& jt) const {
  // we only build the matrix structure without putting any value (all the derivatives of f with respect to y' are 0)

  // N equations of type 0 = Y0 - Y1
  for (const auto& yConnector : yConnectors_) {
    if (yConnector->connectedSubModels().empty())
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    for (std::size_t j = 0, jEnd = yConnector->connectedSubModels().size() - 1; j < jEnd; ++j)
      jt.changeCol();
  }

  // M equations of type 0 = sum(Y)
  for (unsigned int i = 0; i < nbFlowConnectors(); ++i)
    jt.changeCol();
}

void
ConnectorContainer::getY0Connector() const {
  getY0ConnectorForYConnector();
  getY0ConnectorForZConnector();
}

void
ConnectorContainer::getY0ConnectorForYConnector() const {
  // for each YConnector, copy y0 from one pin to y0 of the other pins (reference identified by yType = -2)
  for (const auto& yConnector : yConnectors_) {
    if (yConnector->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    // Searching the initialization reference
    const connectedSubModel* reference = nullptr;
    bool referenceFound = false;
    bool zNegated = false;
    for (const auto& connectedSubModel : yConnector->connectedSubModels()) {
      const propertyContinuousVar_t* yType = connectedSubModel.subModel()->getYType();

      const unsigned int variableIndex = connectedSubModel.variable()->getIndex();
      if (yType[variableIndex] != EXTERNAL && yType[variableIndex] != OPTIONAL_EXTERNAL) {  // non external variable
        reference = &connectedSubModel;
        referenceFound = true;
        zNegated = connectedSubModel.negated();
        break;
      }
    }

    if (!referenceFound)
      continue;

    assert(reference != nullptr);
    // Propagating reference init value
    const int numVarReference = reference->subModel()->getVariableIndexGlobal(reference->variable());
    for (const auto& connectedSubModel : yConnector->connectedSubModels()) {
      if (&connectedSubModel != reference) {
        const int numVar2 = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
        if (connectedSubModel.negated() == zNegated) {
          yLocal_[numVar2] = yLocal_[numVarReference];
          ypLocal_[numVar2] = ypLocal_[numVarReference];
        } else {
          yLocal_[numVar2] = -yLocal_[numVarReference];
          ypLocal_[numVar2] = -ypLocal_[numVarReference];
        }
      }
    }
  }
}

void
ConnectorContainer::getY0ConnectorForZConnector() const {
  // for each ZConnector, copy z0 from one pin to z0 of the other pin
  // if one pin is equal to zero and the other not, the non-zero should be the reference
  for (const auto& zConnector : zConnectors_) {
    if (zConnector->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    // Searching the initialization reference
    const connectedSubModel* reference = nullptr;
    bool nonZeroVariableFound = false;
    bool zNegated = false;
    for (const auto& connectedSubModel : zConnector->connectedSubModels()) {
      const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      if (doubleNotEquals(zLocal_[numVar], 0)) {  // non-zero variable
        reference = &connectedSubModel;
        zNegated = connectedSubModel.negated();
        nonZeroVariableFound = true;
        break;
      }
    }

    if (!nonZeroVariableFound)
      reference = &zConnector->connectedSubModels().front();

    assert(reference != nullptr);
    // Propagating reference init value
    const int numVarReference = reference->subModel()->getVariableIndexGlobal(reference->variable());
    for (const auto& connectedSubModel : zConnector->connectedSubModels()) {
      if (&connectedSubModel != reference) {
        const int numVar2 = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
        if (connectedSubModel.negated() == zNegated) {
          zLocal_[numVar2] = zLocal_[numVarReference];
        } else {
          zLocal_[numVar2] = -zLocal_[numVarReference];
        }
      }
    }
  }
}

void
ConnectorContainer::evalStaticFType() const {
  int offset = 0;

  for (const auto & yConnector : yConnectors_) {
    if (yConnector->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }
    for (std::size_t j = 0, jEnd = yConnector->connectedSubModels().size() - 1; j < jEnd; ++j) {
      fType_[offset] = ALGEBRAIC_EQ;  // no differential equation in connector
      ++offset;
    }
  }

  for (unsigned int i = 0; i < nbFlowConnectors(); ++i) {
    fType_[offset ] = ALGEBRAIC_EQ;  // no differential equation in connector
    ++offset;
  }
}

void
ConnectorContainer::propagateZDiff(const vector<int>& indicesDiff, double* z) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ConnectorContainer::propagateZDiff");
#endif
  // z modified, it is necessary to propagate the differences if we have a connector for each indicesDiff
  for (const auto index : indicesDiff) {
    const auto iter = zConnectorByVarNum_.find(index);  // all discrete variables are not necessarily connected
    if (iter == zConnectorByVarNum_.end())
      continue;

    const shared_ptr<Connector>& connect = iter->second;
    // Get negated attribute of the z variable in the connector
    bool zNegated = false;
    bool found = false;
    for (const auto& connectedSubModel : connect->connectedSubModels()) {
      const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      if (numVar == index) {
        found = true;
        zNegated = connectedSubModel.negated();
      }
    }

    if (!found)
      continue;

    for (const auto& connectedSubModel : connect->connectedSubModels()) {
      const int numVar = connectedSubModel.subModel()->getVariableIndexGlobal(connectedSubModel.variable());
      if (connectedSubModel.negated() == zNegated) {
        z[numVar] = z[index];
      } else {
        z[numVar] = -z[index];
      }
    }
  }
}

bool
ConnectorContainer::isConnected(const int numVariable) {
  if (!connectorsMerged_) mergeConnectors();
  if (yConnectorByVarNum_.find(numVariable) != yConnectorByVarNum_.end()) return true;
  if (flowConnectorByVarNum_.find(numVariable) != flowConnectorByVarNum_.end()) return true;
  return false;
}

}  // namespace DYN
