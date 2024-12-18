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
 * @file  DYNModelVoltageLevel.cpp
 *
 * @brief ModelVoltageLevel implementation
 *
 * ModelVoltageLevel is the container of all subModels who constitute a voltage level
 * such as buses, switches, generators, loads, shunt etc..
 *
 */

#include "DYNModelVoltageLevel.h"
#include "DYNModelBus.h"
#include "DYNModelSwitch.h"
#include "DYNModelLoad.h"
#include "DYNModelGenerator.h"
#include "DYNModelShuntCompensator.h"
#include "DYNModelStaticVarCompensator.h"
#include "DYNModelDanglingLine.h"
#include "DYNModelNetwork.h"

#include "DYNVoltageLevelInterface.h"

#include "DYNSparseMatrix.h"
#include "DYNDerivative.h"

#include <boost/serialization/vector.hpp>

using std::vector;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;
using std::map;
using std::string;
using std::make_pair;

namespace DYN {

ModelVoltageLevel::ModelVoltageLevel(const std::shared_ptr<VoltageLevelInterface>& voltageLevel) :
NetworkComponent(voltageLevel->getID()),
graph_(boost::none),
topologyKind_(voltageLevel->getVoltageLevelTopologyKind()) { }

void
ModelVoltageLevel::dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const {
  // Dump internal variables of components
  for (const auto& component : getComponents()) {
      component->dumpInternalVariables(streamVariables);
  }
}

void
ModelVoltageLevel::loadInternalVariables(boost::archive::binary_iarchive& streamVariables) {
  // Load internal variables of components
  for (const auto& component : getComponents()) {
    component->loadInternalVariables(streamVariables);
  }
}

void
ModelVoltageLevel::addComponent(const std::shared_ptr<NetworkComponent>& component) {
  components_.push_back(component);
}

void
ModelVoltageLevel::addBus(const std::shared_ptr<ModelBus>& bus) {
  busesByIndex_.insert(make_pair(bus->getBusIndex(), bus));
  components_.push_back(bus);
  if (bus->hasBBS())
    busesWithBBS_.push_back(bus);
}

void
ModelVoltageLevel::addSwitch(const std::shared_ptr<ModelSwitch>& sw) {
  switches_.push_back(sw);
  components_.push_back(sw);
  switchesById_[sw->id()] = sw;
}

void
ModelVoltageLevel::defineGraph() {
  graph_ = Graph();
  weights1_.clear();

  // add vertex to voltage level graph
  for (map<int, std::shared_ptr<ModelBus> >::const_iterator  itBus = busesByIndex_.begin(); itBus != busesByIndex_.end(); ++itBus) {
    graph_->addVertex(itBus->first);
  }

  // add edges to voltage level graph
  for (vector<std::shared_ptr<ModelSwitch> >::const_iterator itSw = switches_.begin(); itSw != switches_.end(); ++itSw) {
    if (!(*itSw)->canBeClosed())
      continue;
    int node1 = (*itSw)->getModelBus1()->getBusIndex();
    int node2 = (*itSw)->getModelBus2()->getBusIndex();
    graph_->addEdge(node1, node2, (*itSw)->id());
    weights1_[(*itSw)->id()] = 1;
  }
}

void
ModelVoltageLevel::setInitialSwitchCurrents() {
  for (vector<std::shared_ptr<ModelSwitch> >::const_iterator itSw = switches_.begin(); itSw != switches_.end(); ++itSw) {
    (*itSw)->setInitialCurrents();
  }
}

void
ModelVoltageLevel::computeLoops() {
//  We are searching for switch loops within a substation
//  Example: we have a loop if all four switches are closed in the representation below
//
//  -------------sw-------------- busbar1
//     |                     |
//     |                     |
//    sw                    sw
//     |                     |
//     |                     |
//  -------------sw-------------- busbar2
//
//  To do so we introduce islands (groups) of switches nodes with different indexes
//  If switches are found to form a loop, all their nodes will have the same island index
//

  int islandIndex = 1;
  map<int, vector<std::shared_ptr<ModelBus> > > busByRefIslands;

  // iterate on all the voltage levels switches
  for (vector<std::shared_ptr<ModelSwitch> >::const_iterator itSwitch = switches_.begin(); itSwitch != switches_.end(); ++itSwitch) {
    // init
    (*itSwitch)->inLoop(false);
    // If the switch is closed we get the island index of its nodes and we compare them
    if ((*itSwitch)->getConnectionState() == CLOSED) {
      int ref1 = (*itSwitch)->getModelBus1()->getRefIslands();
      int ref2 = (*itSwitch)->getModelBus2()->getRefIslands();
      if (ref1 == ref2) {      // 1) node 1 and node 2 indexes are the same: two cases
        if (ref1 == 0) {             // a) ref1 = ref2 = 0 (default) : we set the island index to islandIndex
          (*itSwitch)->getModelBus1()->setRefIslands(islandIndex);
          (*itSwitch)->getModelBus2()->setRefIslands(islandIndex);
          busByRefIslands[islandIndex].push_back((*itSwitch)->getModelBus1());
          busByRefIslands[islandIndex].push_back((*itSwitch)->getModelBus2());
          ++islandIndex;
        } else {                     // b) ref1 = ref2 != 0 (a loop has been found) : we update the switch attribute
          (*itSwitch)->inLoop(true);
        }
      } else if (ref1 == 0) {  // 2) node 1 index has not been set : we set node 1 index equals to node 2 index
        (*itSwitch)->getModelBus1()->setRefIslands(ref2);
        busByRefIslands[ref2].push_back((*itSwitch)->getModelBus1());
      } else if (ref2 == 0) {  // 3) node 2 index has not been set : we set node 2 index equals to node 1 index
        (*itSwitch)->getModelBus2()->setRefIslands(ref1);
        busByRefIslands[ref1].push_back((*itSwitch)->getModelBus2());
      } else {                 // 4) node 1 and node 2 indexes have been set but are different : we set node 2 index equals to node 1 index
                               //    and propagate the index value
        map<int, vector<std::shared_ptr<ModelBus> > >::iterator iter = busByRefIslands.find(ref2);
        if (iter != busByRefIslands.end()) {
          vector<std::shared_ptr<ModelBus> > vectBus = iter->second;
          for (unsigned int i = 0; i < vectBus.size(); ++i) {
            vectBus[i]->setRefIslands(ref1);
            busByRefIslands[ref1].push_back(vectBus[i]);
          }
          busByRefIslands.erase(iter);  // erase old reference
          (*itSwitch)->getModelBus2()->setRefIslands(ref1);  // update node 2
          busByRefIslands[ref1].push_back((*itSwitch)->getModelBus2());
        }
      }
    }
  }
}

unsigned int
ModelVoltageLevel::findClosestBBS(const unsigned int node, vector<string>& shortestPath) {
  // This method should return the index of the closest bus bar section and the path to it
  // this function should not be called if not in node breaker topology
  if (topologyKind_ != VoltageLevelInterface::NODE_BREAKER)
    throw DYNError(Error::MODELER, VoltageLevelTopoError, id());

  std::unordered_map<unsigned, std::pair<unsigned, std::vector<std::string> > >::const_iterator it = ClosestBBS_.find(node);
  if (it != ClosestBBS_.end()) {
    shortestPath = it->second.second;
    return it->second.first;
  }

  // define the voltage level graph if it hasn't been defined yet
  if (graph_ == boost::none) {
    defineGraph();
  }

  // find the shortest path between the node and the bus bar section
  unsigned int nodeClosestBBS = std::numeric_limits<unsigned>::max();
  for (vector<std::shared_ptr<ModelBus> >::const_iterator itBBS = busesWithBBS_.begin(); itBBS != busesWithBBS_.end(); ++itBBS) {
    int nodeBBS = (*itBBS)->getBusIndex();
    vector<string> ret;
    graph_->shortestPath(node, nodeBBS, weights1_, ret);
    for (unsigned int i = 0; i < ret.size(); ++i) {
      if (!ret.empty() && (ret.size() < shortestPath.size() || shortestPath.size() == 0)) {
        nodeClosestBBS = nodeBBS;
        shortestPath = ret;
      }
    }
  }
  ClosestBBS_[node] = std::make_pair(nodeClosestBBS, shortestPath);
  return nodeClosestBBS;
}

bool
ModelVoltageLevel::isClosestBBSSwitchedOff(const std::shared_ptr<ModelBus>& bus) {
  // If in bus breaker topology, just look if the bus is switched off
  if (topologyKind_ == VoltageLevelInterface::BUS_BREAKER) {
    return bus->getSwitchOff();

  // If in node breaker topology, look if the closest bus bar section is switched off
  } else if (topologyKind_ == VoltageLevelInterface::NODE_BREAKER) {
    if (bus->hasBBS()) {  // if the bus has a bus bar section, directly check if it is switched off
      return bus->getSwitchOff();
    } else {              // if the bus has no bus bar section, find the closest one and check if it is switched off
      const unsigned int node = bus->getBusIndex();
      vector<string> shortestPath;
      const unsigned int nodeBBS = findClosestBBS(node, shortestPath);

      map<int, std::shared_ptr<ModelBus> >::const_iterator itBus = busesByIndex_.find(nodeBBS);
      if (itBus == busesByIndex_.end())
        return true;

      return itBus->second->getSwitchOff();
    }
  } else {
    throw DYNError(Error::MODELER, VoltageLevelTopoError, id());
  }
}

void
ModelVoltageLevel::connectNode(const unsigned int nodeToConnect) {
//  This method is used to close all switches between the node to connect and the closest bus bar section
//  This method should do nothing if not in node breaker topology
  if (topologyKind_ == VoltageLevelInterface::NODE_BREAKER) {
    // find the shortest path between the node to connect and the bus bar section
    vector<string> shortestPath;
    findClosestBBS(nodeToConnect, shortestPath);

    // iterate on the shortest path found and close identified switches
    for (vector<string>::const_iterator itSwitchName = shortestPath.begin(); itSwitchName != shortestPath.end(); ++itSwitchName) {
      std::shared_ptr<ModelSwitch> sw = switchesById_.find(*itSwitchName)->second;
      sw->close();
    }
  }
}


bool
ModelVoltageLevel::canBeDisconnected(const unsigned int node) {
  if (topologyKind_ == VoltageLevelInterface::NODE_BREAKER) {
    // define the voltage level graph if it hasn't been defined yet
    if (graph_ == boost::none)
      defineGraph();

    for (const auto& BBS : busesWithBBS_) {
      unsigned int nodeBBS = BBS->getBusIndex();
      // If the node is the same as a BBS node then it is connected with only not retained switches and cannot be disconnected
      if (nodeBBS == node)
        return false;
    }
    return true;
  }
  return true;
}

void
ModelVoltageLevel::disconnectNode(const unsigned int nodeToDisconnect) {
//  This method is used to open the first switch found between a node to disconnect and its closest bus bar section
//  This method should do nothing if not in node breaker topology
  if (topologyKind_ == VoltageLevelInterface::NODE_BREAKER) {
    // define the voltage level graph if it hasn't been defined yet
    if (graph_ == boost::none)
      defineGraph();

    vector<std::shared_ptr<ModelBus> >::const_iterator itBBS;
    for (itBBS = busesWithBBS_.begin(); itBBS != busesWithBBS_.end(); ++itBBS) {
      // define a weight for each switch inside the voltage level depending on their connection state
      std::unordered_map<string, float> weights;
      for (vector<std::shared_ptr<ModelSwitch> >::const_iterator itSwitch = switches_.begin(); itSwitch != switches_.end(); ++itSwitch) {
        if (!(*itSwitch)->canBeClosed())
          continue;
        weights[(*itSwitch)->id()] = ((*itSwitch)->getConnectionState() == OPEN) ? 0 : 1;
      }

      // find all path between the node to disconnect and the closest bus bar section
      int nodeBBS = (*itBBS)->getBusIndex();
      vector<string> path;
      graph_->shortestPath(nodeToDisconnect, nodeBBS, weights, path);

      while (!path.empty()) {
        std::shared_ptr<ModelSwitch> sw = switchesById_.find(*path.begin())->second;
        sw->open();
        weights[*path.begin()] = 0;
        path.clear();
        graph_->shortestPath(nodeToDisconnect, nodeBBS, weights, path);
      }
    }
  }
}

void
ModelVoltageLevel::initSize() {
  sizeY_ = 0;
  sizeF_ = 0;
  sizeZ_ = 0;
  sizeG_ = 0;
  sizeMode_ = 0;
  sizeCalculatedVar_ = 0;
  unsigned int index = 0;
  componentIndexByCalculatedVar_.clear();

  // the size of the voltage level is the sum of the unit components sizes
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    (*itComponent)->initSize();
    sizeY_ += (*itComponent)->sizeY();
    sizeF_ += (*itComponent)->sizeF();
    sizeZ_ += (*itComponent)->sizeZ();
    sizeG_ += (*itComponent)->sizeG();
    sizeMode_ += (*itComponent)->sizeMode();
    (*itComponent)->setOffsetCalculatedVar(sizeCalculatedVar_);
    sizeCalculatedVar_ += (*itComponent)->sizeCalculatedVar();
    componentIndexByCalculatedVar_.resize(sizeCalculatedVar_, index);
    ++index;
  }
}

void
ModelVoltageLevel::init(int& yNum) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    (*itComponent)->init(yNum);
  }
}

void
ModelVoltageLevel::getY0() {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->getY0();
}

void
ModelVoltageLevel::evalF(propertyF_t type) {
  for (vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent = components_.begin();
      itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalF(type);
}

void
ModelVoltageLevel::setFequations(map<int, string>& fEquationIndex) {
  unsigned int offset = 0;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeF() != 0) {
      map<int, string> fTypeComponent;
      (*itComponent)->setFequations(fTypeComponent);

      map<int, string>::const_iterator itMapFType;
      for (itMapFType = fTypeComponent.begin(); itMapFType != fTypeComponent.end(); ++itMapFType) {
        int index = offset + itMapFType->first;
        string formula = itMapFType->second;
        fEquationIndex[index] = formula;
      }
      offset += fTypeComponent.size();
    }
  }
}



void
ModelVoltageLevel::evalStaticFType() {
  unsigned int offsetComponent = 0;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeF() != 0) {
      (*itComponent)->setBufferFType(fType_, offsetComponent);
      offsetComponent += (*itComponent)->sizeF();
      (*itComponent)->evalStaticFType();
    }
  }
}

void
ModelVoltageLevel::evalDynamicFType() {
  for (vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeF() != 0)
      (*itComponent)->evalDynamicFType();
  }
}


void
ModelVoltageLevel::collectSilentZ(BitMask* silentZTable) {
  unsigned int offsetComponent = 0;
  for (vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent = components_.begin(), itEnd = components_.end();
      itComponent != itEnd; ++itComponent) {
    if ((*itComponent)->sizeZ() != 0) {
      (*itComponent)->collectSilentZ(&silentZTable[offsetComponent]);
      offsetComponent += (*itComponent)->sizeZ();
    }
  }
}

void
ModelVoltageLevel::evalYMat() {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalYMat();
}

void
ModelVoltageLevel::evalStaticYType() {
  unsigned int offset = 0;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeY() != 0) {
      (*itComponent)->setBufferYType(yType_, offset);
      offset += (*itComponent)->sizeY();
      (*itComponent)->evalStaticYType();
    }
  }
}

void
ModelVoltageLevel::evalDynamicYType() {
  for (vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeY() != 0)
      (*itComponent)->evalDynamicYType();
  }
}

void
ModelVoltageLevel::evalG(const double& t) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalG(t);
}

void
ModelVoltageLevel::setGequations(map<int, string>& gEquationIndex) {
  unsigned int offset = 0;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeG() != 0) {
      map<int, string> GpropComponent;
      (*itComponent)->setGequations(GpropComponent);

      map<int, string>::const_iterator itMapGprop;
      for (itMapGprop = GpropComponent.begin(); itMapGprop != GpropComponent.end(); ++itMapGprop) {
        int index = offset + itMapGprop->first;
        string formula = itMapGprop->second;
        gEquationIndex[index] = formula;
      }
      offset += GpropComponent.size();
    }
  }
}

NetworkComponent::StateChange_t
ModelVoltageLevel::evalZ(const double& t) {
  bool topoChange = false;
  bool stateChange = false;
  for (vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent = components_.begin(), itEnd = components_.end();
      itComponent != itEnd; ++itComponent) {
    switch ((*itComponent)->evalZ(t)) {
    case NetworkComponent::TOPO_CHANGE:
      topoChange = true;
      break;
    case NetworkComponent::STATE_CHANGE:
      stateChange = true;
      break;
    case NetworkComponent::NO_CHANGE:
      break;
    }
  }
  if (topoChange)
    return NetworkComponent::TOPO_CHANGE;
  else if (stateChange)
    return NetworkComponent::STATE_CHANGE;
  return NetworkComponent::NO_CHANGE;
}

NetworkComponent::StateChange_t
ModelVoltageLevel::evalState(const double& time) {
  bool topoChange = false;
  bool stateChange = false;

  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    switch ((*itComponent)->evalState(time)) {
    case NetworkComponent::TOPO_CHANGE:
      topoChange = true;
      break;
    case NetworkComponent::STATE_CHANGE:
      stateChange = true;
      break;
    case NetworkComponent::NO_CHANGE:
      break;
    }
  }

  // TOPO_CHANGE if voltage level components have generated a TOPO_CHANGE (bus or switch)
  //          or if voltage level components have generated a STATE_CHANGE and the voltage level is in node breaker topology
  //          (because in that case component state change will generate neighbouring switch opening or closing)
  // STATE_CHANGE if voltage level components have generated a STATE_CHANGE and the voltage level is in bus breaker topology
  if (topoChange || (stateChange && topologyKind_ == VoltageLevelInterface::NODE_BREAKER)) {
    return NetworkComponent::TOPO_CHANGE;
  } else if (stateChange && topologyKind_ == VoltageLevelInterface::BUS_BREAKER) {
    return NetworkComponent::STATE_CHANGE;
  } else {
    return NetworkComponent::NO_CHANGE;
  }
}

void
ModelVoltageLevel::evalDerivatives(const double cj) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalDerivatives(cj);
}

void
ModelVoltageLevel::evalJt(SparseMatrix& jt, const double& cj, const int& rowOffset) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalJt(jt, cj, rowOffset);
}

void
ModelVoltageLevel::evalJtPrim(SparseMatrix& jt, const int& rowOffset) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalJtPrim(jt, rowOffset);
}

void
ModelVoltageLevel::evalNodeInjection() {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalNodeInjection();
}

void
ModelVoltageLevel::evalCalculatedVars() {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->evalCalculatedVars();
}

void
ModelVoltageLevel::getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, vector<int>& numVars) const {
  int index = componentIndexByCalculatedVar_[numCalculatedVar];
  int varIndex = numCalculatedVar - components_[index]->getOffsetCalculatedVar();
  components_[index]->getIndexesOfVariablesUsedForCalculatedVarI(varIndex, numVars);
}

void
ModelVoltageLevel::evalJCalculatedVarI(unsigned numCalculatedVar, vector<double>& res) const {
  int index = componentIndexByCalculatedVar_[numCalculatedVar];
  int varIndex = numCalculatedVar - components_[index]->getOffsetCalculatedVar();
  components_[index]->evalJCalculatedVarI(varIndex, res);
}

double
ModelVoltageLevel::evalCalculatedVarI(unsigned numCalculatedVar) const {
  int index = componentIndexByCalculatedVar_[numCalculatedVar];
  int varIndex = numCalculatedVar - components_[index]->getOffsetCalculatedVar();
  return components_[index]->evalCalculatedVarI(varIndex);
}

void
ModelVoltageLevel::defineVariables(vector<shared_ptr<Variable> >& variables) {
  ModelBus::defineVariables(variables);
  ModelDanglingLine::defineVariables(variables);
  ModelGenerator::defineVariables(variables);
  ModelLoad::defineVariables(variables);
  ModelShuntCompensator::defineVariables(variables);
  ModelStaticVarCompensator::defineVariables(variables);
  ModelSwitch::defineVariables(variables);
}

void
ModelVoltageLevel::instantiateVariables(vector<shared_ptr<Variable> >& variables) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    (*itComponent)->instantiateVariables(variables);
  }
}

void
ModelVoltageLevel::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->setSubModelParameters(params);
}

void
ModelVoltageLevel::defineParameters(vector<ParameterModeler>& parameters) {
  ModelBus::defineParameters(parameters);
  ModelDanglingLine::defineParameters(parameters);
  ModelGenerator::defineParameters(parameters);
  ModelLoad::defineParameters(parameters);
  ModelShuntCompensator::defineParameters(parameters);
  ModelStaticVarCompensator::defineParameters(parameters);
  ModelSwitch::defineParameters(parameters);
}

void
ModelVoltageLevel::defineNonGenericParameters(vector<ParameterModeler>& parameters) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->defineNonGenericParameters(parameters);
}

void
ModelVoltageLevel::defineElements(vector<Element> &elements, map<string, int>& mapElement) {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->defineElements(elements, mapElement);
}

void
ModelVoltageLevel::addBusNeighbors() {
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent)
    (*itComponent)->addBusNeighbors();
}

void
ModelVoltageLevel::setReferenceY(double* y, double* yp, double* f, const int & offsetY, const int & offsetF) {
  int offsetYComponent = offsetY;
  int offsetFComponent = offsetF;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeY() != 0) {
      (*itComponent)->setReferenceY(y, yp, f, offsetYComponent, offsetFComponent);
      offsetYComponent += (*itComponent)->sizeY();
      offsetFComponent += (*itComponent)->sizeF();
    }
  }
}

void
ModelVoltageLevel::setReferenceZ(double* z, bool* zConnected, const int& offsetZ) {
  int offsetZComponent = offsetZ;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeZ() != 0) {
      (*itComponent)->setReferenceZ(z, zConnected, offsetZComponent);
      offsetZComponent += (*itComponent)->sizeZ();
    }
  }
}

void
ModelVoltageLevel::setReferenceG(state_g* g, const int& offsetG) {
  int offsetGComponent = offsetG;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeG() != 0) {
      (*itComponent)->setReferenceG(g, offsetGComponent);
      offsetGComponent += (*itComponent)->sizeG();
    }
  }
}

void
ModelVoltageLevel::setReferenceCalculatedVar(double* calculatedVars, const int& offsetCalculatedVar) {
  int offsetCalculatedVarComponent = offsetCalculatedVar;
  vector<std::shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    if ((*itComponent)->sizeCalculatedVar() != 0) {
      (*itComponent)->setReferenceCalculatedVar(calculatedVars, offsetCalculatedVarComponent);
      offsetCalculatedVarComponent += (*itComponent)->sizeCalculatedVar();
    }
  }
}


void
ModelVoltageLevel::dumpVariables(boost::archive::binary_oarchive& os) const {
  os << getComponents().size();
  // Dump variables of components
  for (const auto& component : getComponents()) {
    os << component->getId();
    component->dumpVariables(os);
  }
}

bool
ModelVoltageLevel::loadVariables(boost::archive::binary_iarchive& is, const std::string& variablesFileName) {
  bool couldBeLoaded = true;
  size_t nbComponent;
  is >> nbComponent;
  const std::vector<std::shared_ptr<NetworkComponent> >& components = getComponents();

  std::unordered_map<std::string, size_t> ids2Indexes;
  for (size_t i = 0, itEnd = components.size(); i < itEnd; ++i) {
    ids2Indexes[components[i]->getId()] = i;
  }

  // load variables of components
  for (size_t i = 0; i < nbComponent; ++i) {
    std::string idRead;
    is >> idRead;
    auto it = ids2Indexes.find(idRead);
    if (it != ids2Indexes.end()) {
      couldBeLoaded &= components[it->second]->loadVariables(is, variablesFileName);
    } else {
      // Not found, skip the component
      Trace::debug() << DYNLog(NetworkComponentNotFoundInDump, idRead, variablesFileName) << Trace::endline;
      vector<double> yValues;
      vector<double> ypValues;
      vector<double> zValues;
      vector<double> gValues;
      is >> yValues;
      is >> ypValues;
      is >> zValues;
      is >> gValues;
      double dummyValueD;
      bool dummyValueB;
      int dummyValueI;
      char type;
      unsigned nbInternalVar;
      is >> nbInternalVar;
      for (unsigned j = 0; j < nbInternalVar; ++j) {
        is >> type;
        if (type == 'B')
          is >> dummyValueB;
        else if (type == 'D')
          is >> dummyValueD;
        else if (type == 'I')
          is >> dummyValueI;
      }
      couldBeLoaded = false;
    }
  }
  return couldBeLoaded;
}

}  // namespace DYN
