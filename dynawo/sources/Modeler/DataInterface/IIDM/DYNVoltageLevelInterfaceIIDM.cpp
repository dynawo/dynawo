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
 * @file  DYNVoltageLevelInterfaceIIDM.cpp
 *
 * @brief VoltageLevel data interface  : implementation file for IIDM interface
 *
 */
#include <vector>
#include <list>
#include <sstream>
#include <iostream>
#include <map>
#include <limits>
#include <set>

#include <IIDM/components/VoltageLevel.h>
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNBusBarSectionInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNModelConstants.h"
#include "DYNCalculatedBusInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDM.h"

using std::string;
using std::vector;
using std::stringstream;
using std::map;
using std::list;
using std::set;
using std::pair;
using boost::shared_ptr;

namespace DYN {

VoltageLevelInterfaceIIDM::VoltageLevelInterfaceIIDM(IIDM::VoltageLevel& voltageLevel) :
voltageLevelIIDM_(voltageLevel) {
  isNodeBreakerTopology_ = (voltageLevelIIDM_.mode() == IIDM::VoltageLevel::node_breaker);
  if (voltageLevelIIDM_.mode() == IIDM::VoltageLevel::node_breaker) {
    for (int i = 0, iEnd = voltageLevelIIDM_.node_count(); i < iEnd; ++i) {
      graph_.addVertex(i);
    }

    // Add edges
    for (IIDM::Contains<IIDM::Switch>::const_iterator itSwitch = voltageLevelIIDM_.switches().begin();
        itSwitch != voltageLevelIIDM_.switches().end(); ++itSwitch) {
      int node1 = itSwitch->port1().port().node();
      int node2 = itSwitch->port2().port().node();
      graph_.addEdge(node1, node2, itSwitch->id());
      weights1_[itSwitch->id()] = 1;
    }
  }
}

VoltageLevelInterfaceIIDM::~VoltageLevelInterfaceIIDM() {
}

string
VoltageLevelInterfaceIIDM::getID() const {
  return voltageLevelIIDM_.id();
}

double
VoltageLevelInterfaceIIDM::getVNom() const {
  return voltageLevelIIDM_.nominalV();
}

VoltageLevelInterface::VoltageLevelTopologyKind_t
VoltageLevelInterfaceIIDM::getVoltageLevelTopologyKind() const {
  IIDM::VoltageLevel::e_mode topo = voltageLevelIIDM_.mode();
  switch (topo) {
    case IIDM::VoltageLevel::bus_breaker:
      return VoltageLevelInterface::BUS_BREAKER;
    case IIDM::VoltageLevel::node_breaker:
      return VoltageLevelInterface::NODE_BREAKER;
  }
  throw DYNError(Error::MODELER, VoltageLevelTopoError, getID());
}

void
VoltageLevelInterfaceIIDM::addSwitch(const shared_ptr<SwitchInterface>& sw) {
  switchesById_[sw->getID()] = sw;
  switches_.push_back(sw);
}

void
VoltageLevelInterfaceIIDM::addBus(const shared_ptr<BusInterface>& bus) {
  buses_.push_back(bus);
}

void
VoltageLevelInterfaceIIDM::addGenerator(const shared_ptr<GeneratorInterface>& generator) {
  generators_.push_back(generator);
}

void
VoltageLevelInterfaceIIDM::addLoad(const shared_ptr<LoadInterface>& load) {
  loads_.push_back(load);
}

void
VoltageLevelInterfaceIIDM::addShuntCompensator(const shared_ptr<ShuntCompensatorInterface>& shunt) {
  shunts_.push_back(shunt);
}

void
VoltageLevelInterfaceIIDM::addDanglingLine(const shared_ptr<DanglingLineInterface>& line) {
  danglingLines_.push_back(line);
}

void
VoltageLevelInterfaceIIDM::addStaticVarCompensator(const shared_ptr<StaticVarCompensatorInterface>& svc) {
  staticVarCompensators_.push_back(svc);
}

void
VoltageLevelInterfaceIIDM::addVscConverter(const shared_ptr<VscConverterInterface>& vsc) {
  vscConverters_.push_back(vsc);
}

void
VoltageLevelInterfaceIIDM::addLccConverter(const shared_ptr<LccConverterInterface>& lcc) {
  lccConverters_.push_back(lcc);
}

const vector< shared_ptr<BusInterface> >&
VoltageLevelInterfaceIIDM::getBuses() const {
  return buses_;
}

const vector< shared_ptr<SwitchInterface> >&
VoltageLevelInterfaceIIDM::getSwitches() const {
  return switches_;
}

const vector< shared_ptr<LoadInterface> >&
VoltageLevelInterfaceIIDM::getLoads() const {
  return loads_;
}

const vector< shared_ptr<ShuntCompensatorInterface> >&
VoltageLevelInterfaceIIDM::getShuntCompensators() const {
  return shunts_;
}

const vector< shared_ptr<StaticVarCompensatorInterface> >&
VoltageLevelInterfaceIIDM::getStaticVarCompensators() const {
  return staticVarCompensators_;
}

const vector< shared_ptr<GeneratorInterface> >&
VoltageLevelInterfaceIIDM::getGenerators() const {
  return generators_;
}

const vector< shared_ptr<DanglingLineInterface> >&
VoltageLevelInterfaceIIDM::getDanglingLines() const {
  return danglingLines_;
}

const vector< shared_ptr<VscConverterInterface> >&
VoltageLevelInterfaceIIDM::getVscConverters() const {
  return vscConverters_;
}

const vector< shared_ptr<LccConverterInterface> >&
VoltageLevelInterfaceIIDM::getLccConverters() const {
  return lccConverters_;
}


bool
VoltageLevelInterfaceIIDM::isNodeConnected(const unsigned int& nodeToCheck) {
  assert(voltageLevelIIDM_.mode() == IIDM::VoltageLevel::node_breaker);

  // Change weight of edges
  boost::unordered_map<string, float> weights;
  for (IIDM::Contains<IIDM::Switch>::const_iterator itSwitch = voltageLevelIIDM_.switches().begin();
      itSwitch != voltageLevelIIDM_.switches().end(); ++itSwitch) {
    weights[itSwitch->id()] = itSwitch->opened() ? 0 : 1;
  }

  for (IIDM::Contains<IIDM::BusBarSection>::iterator itBBS = voltageLevelIIDM_.busBarSections().begin();
      itBBS != voltageLevelIIDM_.busBarSections().end(); ++itBBS) {
    int nodeBBS = itBBS->node();
    if (graph_.pathExist(nodeToCheck, nodeBBS, weights)) {
      return true;
    }
  }
  return false;
}

unsigned
VoltageLevelInterfaceIIDM::countNumberOfSwitchesToClose(const std::vector<std::string>& path) const {
  unsigned res = 0;
  for (std::vector<std::string>::const_iterator it =  path.begin(), itEnd = path.end(); it != itEnd; ++it) {
    IIDM::Switch sw = *(voltageLevelIIDM_.find_switch(*it));
    if (sw.opened()) {
      ++res;
    }
  }
  return res;
}

void
VoltageLevelInterfaceIIDM::connectNode(const unsigned int& nodeToConnect) {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  assert(voltageLevelIIDM_.mode() == IIDM::VoltageLevel::node_breaker);

  // close the shortest path to one bus bar section
  vector<string> shortestPath;
  unsigned nbSwitchToClose = 0;
  for (IIDM::Contains<IIDM::BusBarSection>::iterator itBBS = voltageLevelIIDM_.busBarSections().begin();
      itBBS != voltageLevelIIDM_.busBarSections().end(); ++itBBS) {
    int nodeBBS = itBBS->node();
    vector<string> ret;
    graph_.shortestPath(nodeToConnect, nodeBBS, weights1_, ret);
    if (shortestPath.empty()) {
      shortestPath = ret;
      nbSwitchToClose = countNumberOfSwitchesToClose(ret);
    } else if (!ret.empty() && ret.size() < shortestPath.size()) {
      shortestPath = ret;
      nbSwitchToClose = countNumberOfSwitchesToClose(ret);
    } else if (!ret.empty() && shortestPath.size() == ret.size()) {  // Tie-breaker
      unsigned currentNbSwitchToClose = countNumberOfSwitchesToClose(ret);
      if (currentNbSwitchToClose < nbSwitchToClose) {
        shortestPath = ret;
        nbSwitchToClose = currentNbSwitchToClose;
      }
    }
  }

  for (vector<string>::iterator iter = shortestPath.begin(); iter != shortestPath.end(); ++iter) {
    IIDM::Switch sw = *(voltageLevelIIDM_.find_switch(*iter));
    if (sw.opened()) {
      map<string, shared_ptr<SwitchInterface> >::iterator itSw = switchesById_.find(*iter);
      if (itSw != switchesById_.end()) {
        switchState_[itSw->second] = CLOSED;
      }
      sw.close();
    }
  }
}

void
VoltageLevelInterfaceIIDM::disconnectNode(const unsigned int& nodeToDisconnect) {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  assert(voltageLevelIIDM_.mode() == IIDM::VoltageLevel::node_breaker);
  // open all paths to bus bar section
  IIDM::Contains<IIDM::BusBarSection>::iterator itBBS = voltageLevelIIDM_.busBarSections().begin();
  for (; itBBS != voltageLevelIIDM_.busBarSections().end(); ++itBBS) {
    boost::unordered_map<string, float> weights;
    for (IIDM::Contains<IIDM::Switch>::const_iterator itSwitch = voltageLevelIIDM_.switches().begin();
        itSwitch != voltageLevelIIDM_.switches().end(); ++itSwitch) {
      weights[itSwitch->id()] = !itSwitch->opened() ? 1 : 0;
    }

    int node = itBBS->node();
    vector<string> path;
    graph_.shortestPath(nodeToDisconnect, node, weights, path);
    bool somethingWasDisconnected = true;

    while (!path.empty() && somethingWasDisconnected) {
      somethingWasDisconnected = false;
      for (vector<string>::const_iterator itSwitch = path.begin(); itSwitch != path.end(); ++itSwitch) {
        string switchID = *itSwitch;
        IIDM::Switch sw = *(voltageLevelIIDM_.switches().find(switchID));
        if (sw.type() == IIDM::Switch::breaker) {
          if (!sw.opened()) {
            map<string, shared_ptr<SwitchInterface> >::iterator itSw = switchesById_.find(switchID);
            if (itSw != switchesById_.end()) {
              switchState_[itSw->second] = OPEN;
            }
            sw.open();
            weights[switchID] = 0;
            somethingWasDisconnected = true;
          }
          break;  // no more things to do, one breaker is open
        }
      }
      path.clear();
      graph_.shortestPath(nodeToDisconnect, static_cast<unsigned int>(node), weights, path);
    }
  }
}

void
VoltageLevelInterfaceIIDM::exportSwitchesState() {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  map<shared_ptr<SwitchInterface>, double >::const_iterator iter = switchState_.begin();
  for (; iter != switchState_.end(); ++iter) {
    int state = static_cast<int>(iter->second);
    if (state == OPEN)
      iter->first->open();
    else
      iter->first->close();
  }
}

void
VoltageLevelInterfaceIIDM::calculateBusTopology() {
  // weight to use for edge to analyse graph and find nodes on the same topological node (switch not open,not retained)
  boost::unordered_map<string, float> topologicalWeights;
  // weight to use for edge to analyse graph and find nodes on the same electrical node (switch not open)
  boost::unordered_map<string, float> electricalWeights;

  for (IIDM::Contains<IIDM::Switch>::const_iterator itSwitch = voltageLevelIIDM_.switches().begin();
      itSwitch != voltageLevelIIDM_.switches().end(); ++itSwitch) {
    string id = itSwitch->id();
    bool open = itSwitch->opened();
    bool retained = itSwitch->retained();
    topologicalWeights[id] = (!open && !retained) ? 1 : 0;
    electricalWeights[id] = (!open) ? 1 : 0;
  }

  pair<unsigned int, vector<unsigned int> >topoComponents = graph_.calculateComponents(topologicalWeights);
  pair<unsigned int, vector<unsigned int> >electricalComponents = graph_.calculateComponents(electricalWeights);

  stringstream busName;
  // created calculated bus, one per connected_components
  for (unsigned int i = 0; i < topoComponents.first; ++i) {
    busName.str("");
    busName.clear();
    busName << "calculatedBus_" << voltageLevelIIDM_.id() << "_" << i;
    shared_ptr<CalculatedBusInterfaceIIDM> bus(new CalculatedBusInterfaceIIDM(voltageLevelIIDM_, busName.str(), i));
    calculatedBus_.push_back(bus);
  }

  vector<unsigned int> component = topoComponents.second;
  for (unsigned int i = 0; i != component.size(); ++i) {
    calculatedBus_[component[i]]->addNode(i);
  }

  // associate busBarSection to CalculatedBus
  vector<unsigned int> component1 = electricalComponents.second;
  map<int, set<int> > electricalNodes;
  for (unsigned int i = 0; i != component1.size(); ++i)
    electricalNodes[component1[i]].insert(i);

  IIDM::Contains<IIDM::BusBarSection>::iterator itBBS = voltageLevelIIDM_.busBarSections().begin();
  for (; itBBS != voltageLevelIIDM_.busBarSections().end(); ++itBBS) {
    int node = itBBS->node();

    shared_ptr<BusBarSectionInterfaceIIDM> bbs(new BusBarSectionInterfaceIIDM(*itBBS));
    calculatedBus_[component[node]]->addBusBarSection(bbs);

    // retrieve the electricalNode
    unsigned int electricalComponent = component1[node];

    // set voltage and angle of bus on the same electrical nodes
    set<int> nodes = electricalNodes[electricalComponent];  // to throw
    for (set<int>::iterator iter = nodes.begin(); iter != nodes.end(); ++iter) {
      if (itBBS->has_v())
        calculatedBus_[component[*iter]]->setU0(itBBS->v());
      if (itBBS->has_angle())
        calculatedBus_[component[*iter]]->setAngle0(itBBS->angle());
    }
  }

  if (!calculatedBus_.empty()) {
    Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::network()) << "Calculated buses from " << getID() << Trace::endline;
    Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  }
  for (unsigned int i = 0; i < calculatedBus_.size(); ++i)
    Trace::debug(Trace::network()) << (*calculatedBus_[i]) << Trace::endline;
}

void
VoltageLevelInterfaceIIDM::mapConnections() {
  vector<shared_ptr<LoadInterface> >::const_iterator iLoad;
  for (iLoad = loads_.begin(); iLoad != loads_.end(); ++iLoad) {
    if ((*iLoad)->hasDynamicModel()) {
      (*iLoad)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<SwitchInterface> >::const_iterator iSwitch;
  for (iSwitch = switches_.begin(); iSwitch != switches_.end(); ++iSwitch) {
    if ((*iSwitch)->hasDynamicModel()) {
      (*iSwitch)->getBusInterface1()->hasConnection(true);
      (*iSwitch)->getBusInterface2()->hasConnection(true);
    }
  }

  vector<shared_ptr<ShuntCompensatorInterface> >::const_iterator iShunt;
  for (iShunt = shunts_.begin(); iShunt != shunts_.end(); ++iShunt) {
    if ((*iShunt)->hasDynamicModel()) {
      (*iShunt)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<StaticVarCompensatorInterface> >::const_iterator iSvc;
  for (iSvc = staticVarCompensators_.begin(); iSvc != staticVarCompensators_.end(); ++iSvc) {
    if ((*iSvc)->hasDynamicModel()) {
      (*iSvc)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<GeneratorInterface> >::const_iterator iGen;
  for (iGen = generators_.begin(); iGen != generators_.end(); ++iGen) {
    if ((*iGen)->hasDynamicModel()) {
      (*iGen)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<DanglingLineInterface> >::const_iterator iDangling;
  for (iDangling = danglingLines_.begin(); iDangling != danglingLines_.end(); ++iDangling) {
    if ((*iDangling)->hasDynamicModel()) {
      (*iDangling)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<VscConverterInterface> >::const_iterator iVsc;
  for (iVsc = vscConverters_.begin(); iVsc != vscConverters_.end(); ++iVsc) {
    if ((*iVsc)->hasDynamicModel()) {
      (*iVsc)->getBusInterface()->hasConnection(true);
    }
  }

  vector<shared_ptr<LccConverterInterface> >::const_iterator iLcc;
  for (iLcc = lccConverters_.begin(); iLcc != lccConverters_.end(); ++iLcc) {
    if ((*iLcc)->hasDynamicModel()) {
      (*iLcc)->getBusInterface()->hasConnection(true);
    }
  }
}

}  // namespace DYN
