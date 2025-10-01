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

#include <DYNTimer.h>

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
  for (const auto& bus : busesByIndex_) {
    graph_->addVertex(bus.first);
  }

  // add edges to voltage level graph
  for (const auto& aSwitch : switches_) {
    if (!aSwitch->canBeClosed())
      continue;
    const int node1 = aSwitch->getModelBus1()->getBusIndex();
    const int node2 = aSwitch->getModelBus2()->getBusIndex();
    graph_->addEdge(node1, node2, aSwitch->id());
    weights1_[aSwitch->id()] = 1;
  }
}

void
ModelVoltageLevel::setInitialSwitchCurrents() {
  for (const auto& aSwitch : switches_) {
    aSwitch->setInitialCurrents();
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
  for (const auto& aSwitch : switches_) {
    // init
    aSwitch->inLoop(false);
    // If the switch is closed we get the island index of its nodes and we compare them
    if (aSwitch->getConnectionState() == CLOSED) {
      int ref1 = aSwitch->getModelBus1()->getRefIslands();
      int ref2 = aSwitch->getModelBus2()->getRefIslands();
      if (ref1 == ref2) {      // 1) node 1 and node 2 indexes are the same: two cases
        if (ref1 == 0) {             // a) ref1 = ref2 = 0 (default) : we set the island index to islandIndex
          aSwitch->getModelBus1()->setRefIslands(islandIndex);
          aSwitch->getModelBus2()->setRefIslands(islandIndex);
          busByRefIslands[islandIndex].push_back(aSwitch->getModelBus1());
          busByRefIslands[islandIndex].push_back(aSwitch->getModelBus2());
          ++islandIndex;
        } else {                     // b) ref1 = ref2 != 0 (a loop has been found) : we update the switch attribute
          aSwitch->inLoop(true);
        }
      } else if (ref1 == 0) {  // 2) node 1 index has not been set : we set node 1 index equals to node 2 index
        aSwitch->getModelBus1()->setRefIslands(ref2);
        busByRefIslands[ref2].push_back(aSwitch->getModelBus1());
      } else if (ref2 == 0) {  // 3) node 2 index has not been set : we set node 2 index equals to node 1 index
        aSwitch->getModelBus2()->setRefIslands(ref1);
        busByRefIslands[ref1].push_back(aSwitch->getModelBus2());
      } else {                 // 4) node 1 and node 2 indexes have been set but are different : we set node 2 index equals to node 1 index
                               //    and propagate the index value
        auto iter = busByRefIslands.find(ref2);
        if (iter != busByRefIslands.end()) {
          vector<std::shared_ptr<ModelBus> > vectBus = iter->second;
          for (unsigned int i = 0; i < vectBus.size(); ++i) {
            vectBus[i]->setRefIslands(ref1);
            busByRefIslands[ref1].push_back(vectBus[i]);
          }
          busByRefIslands.erase(iter);  // erase old reference
          aSwitch->getModelBus2()->setRefIslands(ref1);  // update node 2
          busByRefIslands[ref1].push_back(aSwitch->getModelBus2());
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

  const auto it = closestBBS_.find(node);
  if (it != closestBBS_.end()) {
    shortestPath = it->second.second;
    return it->second.first;
  }

  // define the voltage level graph if it hasn't been defined yet
  if (graph_ == boost::none) {
    defineGraph();
  }

  // find the shortest path between the node and the bus bar section
  unsigned int nodeClosestBBS = std::numeric_limits<unsigned>::max();
  for (const auto& busWithBBS : busesWithBBS_) {
    const unsigned int nodeBBS = busWithBBS->getBusIndex();
    vector<string> ret;
    if (node == nodeBBS) {
      shortestPath = ret;
      return node;
    }
    graph_->shortestPath(node, nodeBBS, weights1_, ret);
    if (!ret.empty() && (ret.size() < shortestPath.size() || shortestPath.empty())) {
      nodeClosestBBS = nodeBBS;
      shortestPath = ret;
    }
  }
  closestBBS_[node] = std::make_pair(nodeClosestBBS, shortestPath);
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
      const int nodeBBS = static_cast<int>(findClosestBBS(node, shortestPath));

      const auto itBus = busesByIndex_.find(nodeBBS);
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
    for (const auto& swicthName : shortestPath) {
      const std::shared_ptr<ModelSwitch>& sw = switchesById_.find(swicthName)->second;
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

    for (const auto& busWithBBS : busesWithBBS_) {
      const unsigned int nodeBBS = busWithBBS->getBusIndex();
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

    for (const auto& busWithBBS : busesWithBBS_) {
      // define a weight for each switch inside the voltage level depending on their connection state
      std::unordered_map<string, float> weights;
      for (const auto& aSwitch : switches_) {
        if (!aSwitch->canBeClosed())
          continue;
        weights[aSwitch->id()] = (aSwitch->getConnectionState() == OPEN) ? 0 : 1;
      }

      // find all path between the node to disconnect and the closest bus bar section
      const int nodeBBS = busWithBBS->getBusIndex();
      vector<string> path;
      graph_->shortestPath(nodeToDisconnect, nodeBBS, weights, path);

      while (!path.empty()) {
        const std::shared_ptr<ModelSwitch>& sw = switchesById_.find(*path.begin())->second;
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
  int index = 0;
  componentIndexByCalculatedVar_.clear();

  // the size of the voltage level is the sum of the unit components sizes
  for (const auto& component : components_) {
    component->initSize();
    sizeY_ += component->sizeY();
    sizeF_ += component->sizeF();
    sizeZ_ += component->sizeZ();
    sizeG_ += component->sizeG();
    sizeMode_ += component->sizeMode();
    component->setOffsetCalculatedVar(sizeCalculatedVar_);
    sizeCalculatedVar_ += component->sizeCalculatedVar();
    componentIndexByCalculatedVar_.resize(sizeCalculatedVar_, index);
    ++index;
  }
}

void
ModelVoltageLevel::init(int& yNum) {
  for (const auto& component : components_) {
    component->init(yNum);
  }
}

void
ModelVoltageLevel::getY0() {
  for (const auto& component : components_)
    component->getY0();
}

void
ModelVoltageLevel::evalF(const propertyF_t type) {
  for (const auto& component : components_)
    component->evalF(type);
}

void
ModelVoltageLevel::setFequations(map<int, string>& fEquationIndex) {
  int offset = 0;
  for (const auto& component : components_) {
    if (component->sizeF() != 0) {
      map<int, string> fTypeComponent;
      component->setFequations(fTypeComponent);

      for (const auto& fType : fTypeComponent) {
        int index = offset + fType.first;
        const string formula = fType.second;
        fEquationIndex[index] = formula;
      }
      offset += static_cast<int>(fTypeComponent.size());
    }
  }
}



void
ModelVoltageLevel::evalStaticFType() {
  unsigned int offsetComponent = 0;
  for (const auto& component : components_) {
    if (component->sizeF() != 0) {
      component->setBufferFType(fType_, offsetComponent);
      offsetComponent += component->sizeF();
      component->evalStaticFType();
    }
  }
}

void
ModelVoltageLevel::evalDynamicFType() {
  for (const auto& component : components_) {
    if (component->sizeF() != 0)
      component->evalDynamicFType();
  }
}


void
ModelVoltageLevel::collectSilentZ(BitMask* silentZTable) {
  unsigned int offsetComponent = 0;
  for (const auto& component : components_) {
    if (component->sizeZ() != 0) {
      component->collectSilentZ(&silentZTable[offsetComponent]);
      offsetComponent += component->sizeZ();
    }
  }
}

void
ModelVoltageLevel::evalYMat() {
  for (const auto& component : components_)
    component->evalYMat();
}

void
ModelVoltageLevel::evalStaticYType() {
  unsigned int offset = 0;
  for (const auto& component : components_) {
    if (component->sizeY() != 0) {
      component->setBufferYType(yType_, offset);
      offset += component->sizeY();
      component->evalStaticYType();
    }
  }
}

void
ModelVoltageLevel::evalDynamicYType() {
  for (const auto& component : components_) {
    if (component->sizeY() != 0)
      component->evalDynamicYType();
  }
}

void
ModelVoltageLevel::evalG(const double t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelNetwork::ModelVoltageLevel::evalG");
#endif
  for (const auto& component : components_)
    component->evalG(t);
}

void
ModelVoltageLevel::setGequations(map<int, string>& gEquationIndex) {
  int offset = 0;
  for (const auto& component : components_) {
    if (component->sizeG() != 0) {
      map<int, string> gPropComponent;
      component->setGequations(gPropComponent);

      for (const auto& gProp : gPropComponent) {
        int index = offset + gProp.first;
        const string formula = gProp.second;
        gEquationIndex[index] = formula;
      }
      offset += static_cast<int>(gPropComponent.size());
    }
  }
}

NetworkComponent::StateChange_t
ModelVoltageLevel::evalZ(const double t, bool deactivateZeroCrossingFunctions) {
  bool topoChange = false;
  bool stateChange = false;
  for (const auto& component : components_) {
    switch (component->evalZ(t, deactivateZeroCrossingFunctions)) {
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
ModelVoltageLevel::evalState(const double time) {
  bool topoChange = false;
  bool stateChange = false;

  for (const auto& component : components_) {
    switch (component->evalState(time)) {
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
  for (const auto& component : components_)
    component->evalDerivatives(cj);
}

void
ModelVoltageLevel::evalJt(const double cj, const int rowOffset, SparseMatrix& jt) {
  for (const auto& component : components_)
    component->evalJt(cj, rowOffset, jt);
}

void
ModelVoltageLevel::evalJtPrim(const int rowOffset, SparseMatrix& jtPrim) {
  for (const auto& component : components_)
    component->evalJtPrim(rowOffset, jtPrim);
}

void
ModelVoltageLevel::evalNodeInjection() {
  for (const auto& component : components_)
    component->evalNodeInjection();
}

void
ModelVoltageLevel::evalCalculatedVars() {
  for (const auto& component : components_)
    component->evalCalculatedVars();
}

void
ModelVoltageLevel::getIndexesOfVariablesUsedForCalculatedVarI(const unsigned numCalculatedVar, vector<int>& numVars) const {
  const int index = componentIndexByCalculatedVar_[numCalculatedVar];
  const int varIndex = static_cast<int>(numCalculatedVar) - components_[index]->getOffsetCalculatedVar();
  components_[index]->getIndexesOfVariablesUsedForCalculatedVarI(varIndex, numVars);
}

void
ModelVoltageLevel::evalJCalculatedVarI(const unsigned numCalculatedVar, vector<double>& res) const {
  const int index = componentIndexByCalculatedVar_[numCalculatedVar];
  const int varIndex = static_cast<int>(numCalculatedVar) - components_[index]->getOffsetCalculatedVar();
  components_[index]->evalJCalculatedVarI(varIndex, res);
}

double
ModelVoltageLevel::evalCalculatedVarI(const unsigned numCalculatedVar) const {
  const int index = componentIndexByCalculatedVar_[numCalculatedVar];
  const int varIndex = static_cast<int>(numCalculatedVar) - components_[index]->getOffsetCalculatedVar();
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
  for (const auto& component : components_) {
    component->instantiateVariables(variables);
  }
}

void
ModelVoltageLevel::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) {
  for (const auto& component : components_)
    component->setSubModelParameters(params);
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
  for (const auto& component : components_)
    component->defineNonGenericParameters(parameters);
}

void
ModelVoltageLevel::defineElements(vector<Element> &elements, map<string, int>& mapElement) {
  for (const auto& component : components_)
    component->defineElements(elements, mapElement);
}

void
ModelVoltageLevel::addBusNeighbors() {
  for (const auto& component : components_)
    component->addBusNeighbors();
}

void
ModelVoltageLevel::setReferenceY(double* y, double* yp, double* f, const int offsetY, const int offsetF) {
  int offsetYComponent = offsetY;
  int offsetFComponent = offsetF;
  for (const auto& component : components_) {
    if (component->sizeY() != 0) {
      component->setReferenceY(y, yp, f, offsetYComponent, offsetFComponent);
      offsetYComponent += component->sizeY();
      offsetFComponent += component->sizeF();
    }
  }
}

void
ModelVoltageLevel::setReferenceZ(double* z, bool* zConnected, const int offsetZ) {
  int offsetZComponent = offsetZ;
  for (const auto& component : components_) {
    if (component->sizeZ() != 0) {
      component->setReferenceZ(z, zConnected, offsetZComponent);
      offsetZComponent += component->sizeZ();
    }
  }
}

void
ModelVoltageLevel::setReferenceG(state_g* g, const int offsetG) {
  int offsetGComponent = offsetG;
  for (const auto& component : components_) {
    if (component->sizeG() != 0) {
      component->setReferenceG(g, offsetGComponent);
      offsetGComponent += component->sizeG();
    }
  }
}

void
ModelVoltageLevel::setReferenceCalculatedVar(double* calculatedVars, const int offsetCalculatedVars) {
  int offsetCalculatedVarComponent = offsetCalculatedVars;
  for (const auto& component : components_) {
    if (component->sizeCalculatedVar() != 0) {
      component->setReferenceCalculatedVar(calculatedVars, offsetCalculatedVarComponent);
      offsetCalculatedVarComponent += component->sizeCalculatedVar();
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
