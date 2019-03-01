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
using std::map;
using std::list;
using std::string;
using boost::shared_ptr;

namespace DYN {

void
Connector::addConnectedSubModel(const connectedSubModel& subModel) {
  connectedSubModels_.push_back(subModel);
}

void
Connector::addConnectedSubModel(const boost::shared_ptr<SubModel> & subModel, const boost::shared_ptr<Variable> & variable, bool negated) {
  connectedSubModels_.push_back(connectedSubModel(subModel, variable, negated));
}

int
Connector::nbConnectedSubModels() const {
  return connectedSubModels_.size();
}

ConnectorContainer::ConnectorContainer():
connectorsMerged_(false) {
}

ConnectorContainer::~ConnectorContainer() {
}

unsigned int ConnectorContainer::nbYConnectors() const {
  unsigned int nbConnect = 0;
  for (unsigned int i = 0; i < yConnectors_.size(); ++i) {  // if there are n variables connected together
    // there are n-1 equations
    shared_ptr<Connector> yc = yConnectors_[i];
    nbConnect += std::max(0, yc->nbConnectedSubModels() - 1);
  }

  return nbConnect;
}

void
ConnectorContainer::addFlowConnector(shared_ptr<Connector> & connector) {
  flowConnectorsDeclared_.push_back(connector);  // do not forget mutual statement in the map
}

void
ConnectorContainer::addContinuousConnector(shared_ptr<Connector> & connector) {
  yConnectorsDeclared_.push_back(connector);
}

void
ConnectorContainer::addDiscreteConnector(shared_ptr<Connector> & connector) {
  zConnectorsDeclared_.push_back(connector);
}

void
ConnectorContainer::mergeConnectors() {
  if (connectorsMerged_)
    return;

  connectorsMerged_ = true;
  // order Y connectors
  yConnectors_.clear();
  yConnectorByVarNum_.clear();
  list<shared_ptr<Connector> > yConnectorsList;
  for (unsigned int i = 0; i < yConnectorsDeclared_.size(); ++i) {
    shared_ptr<Connector> yc(new Connector(*yConnectorsDeclared_[i]));
    bool merged = false;
    for (vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
            it != yc->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      if (yConnectorByVarNum_.find(numVar) != yConnectorByVarNum_.end()) {
        mergeConnectors(yc, yConnectorByVarNum_[numVar], yConnectorsList, yConnectorByVarNum_);
        merged = true;
        break;
      }
    }

    if (!merged) {
      yConnectorsList.push_back(yc);
      for (vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
              it != yc->connectedSubModels().end();
              ++it) {
        const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
        yConnectorByVarNum_[numVar] = yc;
      }
    }
  }

  // Copy kept yConnectors in the vector
  yConnectors_.assign(yConnectorsList.begin(), yConnectorsList.end());

  // order flow connectors
  flowConnectors_.clear();
  flowConnectorByVarNum_.clear();
  list<shared_ptr<Connector> > flowConnectorsList;
  for (unsigned int i = 0; i < flowConnectorsDeclared_.size(); ++i) {
    shared_ptr<Connector> flowc(new Connector(*flowConnectorsDeclared_[i]));
    bool merged = false;
    for (vector<connectedSubModel>::iterator it = flowc->connectedSubModels().begin();
            it != flowc->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      if (flowConnectorByVarNum_.find(numVar) != flowConnectorByVarNum_.end()) {
        mergeConnectors(flowc, flowConnectorByVarNum_[numVar], flowConnectorsList, flowConnectorByVarNum_);
        merged = true;
        break;
      }
    }

    if (!merged) {
      flowConnectorsList.push_back(flowc);
      for (vector<connectedSubModel>::iterator it = flowc->connectedSubModels().begin();
              it != flowc->connectedSubModels().end();
              ++it) {
        const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
        flowConnectorByVarNum_[numVar] = flowc;
      }
    }
  }

  // Copy kept flowConnectors in the vector
  flowConnectors_.assign(flowConnectorsList.begin(), flowConnectorsList.end());

  // order Z connectors
  zConnectors_.clear();
  zConnectorByVarNum_.clear();
  list<shared_ptr<Connector> > zConnectorsList;
  for (unsigned int i = 0; i < zConnectorsDeclared_.size(); ++i) {
    shared_ptr<Connector> zc(new Connector(*zConnectorsDeclared_[i]));
    bool merged = false;
    for (vector<connectedSubModel>::iterator it = zc->connectedSubModels().begin();
            it != zc->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      if (zConnectorByVarNum_.find(numVar) != zConnectorByVarNum_.end()) {
        mergeConnectors(zc, zConnectorByVarNum_[numVar], zConnectorsList, zConnectorByVarNum_);
        merged = true;
        break;
      }
    }

    if (!merged) {
      zConnectorsList.push_back(zc);
      for (vector<connectedSubModel>::iterator it = zc->connectedSubModels().begin();
              it != zc->connectedSubModels().end();
              ++it) {
        const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
        zConnectorByVarNum_[numVar] = zc;
      }
    }
  }

  // Copy kept yConnectors in the vector
  zConnectors_.assign(zConnectorsList.begin(), zConnectorsList.end());
}

void
ConnectorContainer::mergeConnectors(shared_ptr<Connector> connector, shared_ptr<Connector> reference, list<shared_ptr<Connector> > &connectorsList,
                                    map<int, shared_ptr<Connector> >& connectorsByVarNum) {
  // Looking for common variable to test the negated attributes
  bool negatedMerge = false;
  for (vector<connectedSubModel>::const_iterator itCon = connector->connectedSubModels().begin();
          itCon != connector->connectedSubModels().end();
          ++itCon) {
    const int numVar = itCon->subModel()->getVariableIndexGlobal(itCon->variable());
    if (connectorsByVarNum.find(numVar) != connectorsByVarNum.end()) {
      // check whether the two connectors have at least one variable in common :
      // if so, the negated attribute of the merge is derived from the shared variable negated attribute comparison
      if (connectorsByVarNum[numVar] == reference) {
        for (vector<connectedSubModel>::const_iterator itRef = connector->connectedSubModels().begin();
                itRef != connector->connectedSubModels().end();
                ++itRef) {
          if (itRef->subModel()->getVariableIndexGlobal(itRef->variable()) == numVar) {  // found the two connectedSubModels
            negatedMerge = itRef->negated() != itCon->negated();
            break;
          }
        }
      }
    }
  }

  // Merging connectors
  for (vector<connectedSubModel>::const_iterator it = connector->connectedSubModels().begin();
          it != connector->connectedSubModels().end();
          ++it) {
    const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
    if (connectorsByVarNum.find(numVar) != connectorsByVarNum.end()) {
      // variable used in a final connector
      if (connectorsByVarNum[numVar] == reference) {
        continue;
      } else if (connectorsByVarNum[numVar] != connector) {
        mergeConnectors(connectorsByVarNum[numVar], reference, connectorsList, connectorsByVarNum);
        continue;
      }
    }
    reference->addConnectedSubModel(it->subModel(), it->variable(), (negatedMerge ? !(it->negated()) : it->negated()));
    connectorsByVarNum[numVar] = reference;
  }

  // When merging two connectors of the list, only keep reference
  connectorsList.remove(connector);
}

void
ConnectorContainer::getConnectorInfos(const int & globalFIndex, std::string & subModelName, int & localFIndex, std::string & fEquation) const {
  if (nbContinuousConnectors() == 0)
    return;

  if (globalFIndex < offsetModel_)
    return;

  localFIndex = globalFIndex - offsetModel_;
  // find first in yConnectors, then in flowConnectors, at last in zConnectors.
  if ((unsigned int) localFIndex < nbYConnectors()) {
    subModelName = "Y Connector";
    fEquation = getYConnectorInfos(localFIndex);
  } else if (((unsigned int) localFIndex >= nbYConnectors())
          && ((unsigned int) localFIndex < nbYConnectors() + nbFlowConnectors())) {
    unsigned int index = localFIndex - nbYConnectors();
    subModelName = "Flow Connector";
    fEquation = getFlowConnectorInfos(index);
  } else if (((unsigned int) localFIndex >= nbYConnectors() + nbFlowConnectors())
          && ((unsigned int) localFIndex < nbYConnectors() + nbFlowConnectors() + nbZConnectors())) {
    unsigned int index = localFIndex - nbYConnectors() - nbFlowConnectors();
    subModelName = "Z Connector";
    fEquation = getZConnectorInfos(index);
  } else {
    subModelName = "SubModel Not Found";
    fEquation = "Fequation Not Found";
    return;
  }
}

string
ConnectorContainer::getYConnectorInfos(const int & index) const {
  string equation = "";
  int offset = 0;

  for (unsigned int i = 0; i < yConnectors_.size(); ++i) {
    shared_ptr<Connector> yc = yConnectors_[i];
    const int nbSubModels = yc->connectedSubModels().size() - 1;  // -1 because first item (reference) not taken into account
    // check whether the index is inside the current connector
    if (offset + nbSubModels < index) {
      offset += nbSubModels;
    } else {
      const int localOffset = index - offset;  // first item (reference) not taken into account
      vector<connectedSubModel>::const_iterator it = yc->connectedSubModels().begin();
      // First is reference
      const connectedSubModel& reference = *it;
      equation.append("Y Connector : ").append(reference.subModel()->name()).append(" - ");
      equation.append(yc->connectedSubModels().at(localOffset).subModel()->name());

      return equation;
    }
  }

  throw DYNError(Error::MODELER, ConnectorBadInfo, "YConnector", index);
}

string
ConnectorContainer::getConnectorInfos(const string& prefix, const shared_ptr<Connector> connector) const {
  string equation = prefix;
  for (vector<connectedSubModel>::const_iterator it = connector->connectedSubModels().begin();
          it != connector->connectedSubModels().end();
          ++it) {
    if (it != connector->connectedSubModels().begin()) {
      equation.append(" - ");
    }
    equation.append(it->subModel()->name());
  }
  return equation;
}

void
ConnectorContainer::printConnectors() const {
  if (nbContinuousConnectors() == 0)
    return;

  Trace::debug("MODELER") << DYNLog(ModelConnectorsNB, nbContinuousConnectors()) << Trace::endline;
  Trace::debug("MODELER") << "         F : [" << std::setw(6) << offsetModel_ << " ; "
                          << std::setw(6) << offsetModel_ + nbContinuousConnectors() << "[" << Trace::endline;
  Trace::debug("MODELER") << Trace::endline;

  Trace::debug("MODELER") << " ====== " << DYNLog(ModelConnectorsList) << " ===== " << Trace::endline;
  int offset = 0;
  for (unsigned int i = 0; i < yConnectors_.size(); ++i) {
    shared_ptr<Connector> yc = yConnectors_[i];
    if (yc->connectedSubModels().empty()) {
      continue;  // should not happen but who knows ...
    }

    vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
    // First is reference
    connectedSubModel reference = *it;
    const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
    ++it;
    for (;
            it != yc->connectedSubModels().end();
            ++it) {
      const int numVar2 = it->subModel()->getVariableIndexGlobal(it->variable());
      Trace::debug("MODELER") << "         Yconnector " << (it->negated() ? "-" : "") << "Y[" << std::setw(6) << numVar2 << "] = "
                              << (reference.negated() ? "-" : "") << "Y[" << std::setw(6) << numVarReference << "]"
                              << "      F = F[" << std::setw(6) << offsetModel_ + offset
                              << "] / " << DYNLog(ConnectedModels, it->subModel()->name(), reference.subModel()->name()) << Trace::endline;
      ++offset;
    }
  }
  for (unsigned int i = 0; i < nbFlowConnectors(); ++i) {
    shared_ptr<Connector> fc = flowConnectors_[i];
    stringstream ss;
    ss << "         flowConnector : ";
    bool first = true;
    for (vector<connectedSubModel>::iterator it = fc->connectedSubModels().begin();
            it != fc->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      ss << (it->negated() ? "-" : (first ? "" : "+")) << "Y[" << std::setw(6) << numVar << "] ";
      first = false;
    }
    ss << " = 0";

    ss << "      F = F[" << std::setw(6) << offsetModel_ + offset << "]";
    Trace::debug("MODELER") << ss.str() << Trace::endline;
    ++offset;
  }

  for (unsigned int i = 0; i < nbZConnectors(); ++i) {
    shared_ptr<Connector> zc = zConnectors_[i];
    if (zc->connectedSubModels().empty()) {
      continue;  // should not happen but who knows ...
    }

    vector<connectedSubModel>::iterator it = zc->connectedSubModels().begin();
    // First is reference
    connectedSubModel reference = *it;
    const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
    ++it;
    for (;
            it != zc->connectedSubModels().end();
            ++it) {
      const int numVar2 = it->subModel()->getVariableIndexGlobal(it->variable());
      Trace::debug("MODELER") << "         Zconnector " << (it->negated() ? "-" : "") << "Z[" << std::setw(6) << numVar2 << "] = "
                              << (reference.negated() ? "-" : "") << "Z[" << std::setw(6) << numVarReference << "] / "
                              << DYNLog(ConnectedModels, it->subModel()->name(), reference.subModel()->name()) << Trace::endline;
    }
  }
}

void
ConnectorContainer::setBufferFType(propertyF_t* fType, const int& offsetFType) {
  fType_ = &(fType[offsetFType]);
}

void
ConnectorContainer::setBufferF(double* f, const int& offsetF) {
  fLocal_ = &(f[offsetF]);
}

void
ConnectorContainer::setBufferY(double* y, double* yp) {
  yLocal_ = y;
  ypLocal_ = yp;
}

void
ConnectorContainer::setBufferZ(double* z) {
  zLocal_ = z;
}

void
ConnectorContainer::evalFConnector(const double& /*t*/) {
  Timer timer("ConnectorContainer::evalF");

  if (index_.size() == 0) {
    index_.resize(nbYConnectors() + nbFlowConnectors());
    factor_.resize(nbYConnectors() + nbFlowConnectors());

    int offset = 0;
    for (unsigned int i = 0; i < yConnectors_.size(); ++i) {
      shared_ptr<Connector> yc = yConnectors_[i];
      if (yc->connectedSubModels().empty()) {
        throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
      }

      vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
      // First is reference
      connectedSubModel reference = *it;
      const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
      ++it;
      for (; it != yc->connectedSubModels().end(); ++it) {
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
    for (unsigned int i = 0; i < nbFlowConnectors(); ++i) {
      shared_ptr<Connector> fc = flowConnectors_[i];
      vector<unsigned int> index(fc->connectedSubModels().size(), 0);
      vector<int> factor(fc->connectedSubModels().size(), 1);

      for (unsigned int j=0; j < fc->connectedSubModels().size(); ++j) {
        index[j] = fc->connectedSubModels()[j].subModel()->getVariableIndexGlobal(fc->connectedSubModels()[j].variable());
        factor[j] = (fc->connectedSubModels()[j].negated()) ? -1 : 1;
      }
      index_[offset] = index;
      factor_[offset] = factor;
      ++offset;
    }
  }

  for (unsigned int i=0; i < index_.size(); ++i) {
    fLocal_[i] = 0;
    fLocal_[i] = multiplyAndAdd(index_[i], factor_[i]);
  }
}

double
ConnectorContainer::multiplyAndAdd(const vector<unsigned int>& index, const vector<int>& factor) {
  double sum = 0;
  for (unsigned int i=0; i < index.size(); ++i)
    sum += factor[i]*yLocal_[index[i]];
  return sum;
}


void
ConnectorContainer::evalJtConnector(SparseMatrix& jt) {
  Timer timer("ConnectorContainer::evalJ");

  // N equations of type 0 = Y0 - Y1
  const double dMOne(-1.);
  const double dPOne(+1.);

  for (unsigned int i = 0; i < yConnectors_.size(); ++i) {
    shared_ptr<Connector> yc = yConnectors_[i];
    if (yc->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
    // First is reference
    connectedSubModel reference = *it;
    const int numVarReference = reference.subModel()->getVariableIndexGlobal(reference.variable());
    ++it;
    for (;
            it != yc->connectedSubModels().end();
            ++it) {
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
  for (unsigned int i = 0; i < nbFlowConnectors(); ++i) {
    shared_ptr<Connector> fc = flowConnectors_[i];
    jt.changeCol();
    for (vector<connectedSubModel>::iterator it = fc->connectedSubModels().begin();
            it != fc->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      if (it->negated()) {
        jt.addTerm(numVar, dMOne);  // d(f)/d(Yi) = -1;
      } else {
        jt.addTerm(numVar, dPOne);  // d(f)/d(Yi) = +1;
      }
    }
  }
}

void
ConnectorContainer::evalJtPrimConnector(SparseMatrix& jt) {
  // we only build the matrix structure without putting any value (all the derivatives of f with respect to y' are 0)

  // N equations of type 0 = Y0 - Y1
  for (unsigned int i = 0; i < yConnectors_.size(); ++i) {
    shared_ptr<Connector> yc = yConnectors_[i];
    if (yc->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
    // First is reference
    connectedSubModel reference = *it;
    ++it;
    for (;
            it != yc->connectedSubModels().end();
            ++it) {
      jt.changeCol();
    }
  }

  // M equations of type 0 = sum(Y)
  for (unsigned int i = 0; i < nbFlowConnectors(); ++i)
    jt.changeCol();
}

void
ConnectorContainer::getY0Connector() {
  // for each YConnector, copy y0 from one pin to y0 of the other pins (reference identified by yType = -2)
  for (unsigned int i = 0; i < yConnectors_.size(); ++i) {
    shared_ptr<Connector> yc = yConnectors_[i];
    if (yc->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    // Searching the initialization reference
    vector<connectedSubModel>::iterator itReference;
    bool referenceFound = false;
    for (vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
            it != yc->connectedSubModels().end();
            ++it) {
      propertyContinuousVar_t * yType = it->subModel()->getYType();

      if (yType[it->variable()->getIndex()] != EXTERNAL && yType[it->variable()->getIndex()] != OPTIONAL_EXTERNAL) {  // non external variable
        itReference = it;
        referenceFound = true;
        break;
      }
    }

    if (!referenceFound)
      continue;

    // Propagating reference init value
    const int numVarReference = itReference->subModel()->getVariableIndexGlobal(itReference->variable());
    for (vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
            it != yc->connectedSubModels().end();
            ++it) {
      if (it != itReference) {
        const int numVar2 = it->subModel()->getVariableIndexGlobal(it->variable());
        yLocal_[ numVar2 ] = yLocal_[ numVarReference ];
        ypLocal_[ numVar2 ] = ypLocal_[ numVarReference ];
      }
    }
  }

  // for each ZConnector, copy z0 from one pin to z0 of the other pin
  // if one pin is equal to zero and the other not, the non zero should be the reference
  for (unsigned int i = 0; i < nbZConnectors(); ++i) {
    boost::shared_ptr<Connector> zc = zConnectors_[i];
    if (zc->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    // Searching the initialization reference
    vector<connectedSubModel>::iterator itReference;
    bool nonZeroVariableFound = false;
    for (vector<connectedSubModel>::iterator it = zc->connectedSubModels().begin();
            it != zc->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      if (doubleNotEquals(zLocal_[numVar], 0)) {  // non zero variable
        itReference = it;
        nonZeroVariableFound = true;
        break;
      }
    }

    if (!nonZeroVariableFound)
      itReference = zc->connectedSubModels().begin();

    // Propagating reference init value
    const int numVarReference = itReference->subModel()->getVariableIndexGlobal(itReference->variable());
    for (vector<connectedSubModel>::iterator it = zc->connectedSubModels().begin();
            it != zc->connectedSubModels().end();
            ++it) {
      if (it != itReference) {
        const int numVar2 = it->subModel()->getVariableIndexGlobal(it->variable());
        zLocal_[numVar2] = zLocal_[numVarReference];
      }
    }
  }
}

void
ConnectorContainer::evalFType() const {
  int offset = 0;

  for (unsigned int i = 0; i < yConnectors_.size(); ++i) {
    shared_ptr<Connector> yc = yConnectors_[i];
    if (yc->connectedSubModels().empty()) {
      throw DYNError(Error::MODELER, EmptyConnector);  // should not happen but who knows ...
    }

    vector<connectedSubModel>::iterator it = yc->connectedSubModels().begin();
    // First is reference
    connectedSubModel reference = *it;
    ++it;
    for (;
            it != yc->connectedSubModels().end();
            ++it) {
      fType_[offset] = ALGEBRIC_EQ;  // no differential equation in connector
      ++offset;
    }
  }

  for (unsigned int i = 0; i < nbFlowConnectors(); ++i) {
    fType_[offset ] = ALGEBRIC_EQ;  // no differential equation in connector
    ++offset;
  }
}

void
ConnectorContainer::propagateZDiff(vector<int> & indicesDiff, vector<double> & z) {
  Timer timer("ConnectorContainer::propagateZDiff");
  // z modified, it is necessary to propagate the differences if we have a connector for each indicesDiff
  for (unsigned int i = 0; i < indicesDiff.size(); ++i) {
    int index = indicesDiff[i];
    map<int, shared_ptr<Connector> >::iterator iter;
    iter = zConnectorByVarNum_.find(index);  // all discrete variables are not necessarily connected
    if (iter == zConnectorByVarNum_.end())
      continue;

    shared_ptr<Connector> connect = iter->second;
    // Get negated attribute of the z variable in the connector
    bool zNegated;
    bool found = false;
    for (vector<connectedSubModel>::iterator it = connect->connectedSubModels().begin();
            it != connect->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      if (numVar == index) {
        found = true;
        zNegated = it->negated();
      }
    }
    if (!found)
      continue;
    for (vector<connectedSubModel>::iterator it = connect->connectedSubModels().begin();
            it != connect->connectedSubModels().end();
            ++it) {
      const int numVar = it->subModel()->getVariableIndexGlobal(it->variable());
      if (it->negated() == zNegated) {
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
