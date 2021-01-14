//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNSwitchInterface.h"
#include "DYNLoadInterface.h"
#include "DYNBusInterface.h"
#include "DYNDanglingLineInterface.h"
#include "DYNVscConverterInterface.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNStaticVarCompensatorInterface.h"
#include "DYNGeneratorInterface.h"
#include "DYNLccConverterInterface.h"
#include "DYNModelConstants.h"
#include "DYNTrace.h"

#include <powsybl/iidm/TopologyKind.hpp>
#include <powsybl/iidm/SwitchKind.hpp>
#include <powsybl/iidm/BusbarSection.hpp>
#include <powsybl/iidm/Bus.hpp>
#include <powsybl/iidm/Switch.hpp>

#include <vector>
#include <string>

using boost::shared_ptr;
using std::string;
using std::vector;
using std::pair;
using std::map;
using std::set;
using std::list;
using std::stringstream;

namespace DYN {

VoltageLevelInterfaceIIDM::VoltageLevelInterfaceIIDM(powsybl::iidm::VoltageLevel& voltageLevel) :
voltageLevelIIDM_(voltageLevel) {
  isNodeBreakerTopology_ = (voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);
  if (voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    for (const auto& nodeIndex : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
      graph_.addVertex(nodeIndex);
    }

    // Add edges
    for (const powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getSwitches()) {
      int node1 = voltageLevelIIDM_.getNodeBreakerView().getNode1(itSwitch.getId());
      int node2 = voltageLevelIIDM_.getNodeBreakerView().getNode2(itSwitch.getId());
      graph_.addEdge(node1, node2, itSwitch.getId());
      weights1_[itSwitch.getId()] = 1;
    }
  }
}

VoltageLevelInterfaceIIDM::~VoltageLevelInterfaceIIDM() {
}

string
VoltageLevelInterfaceIIDM::getID() const {
  return voltageLevelIIDM_.getId();
}

double
VoltageLevelInterfaceIIDM::getVNom() const {
  return voltageLevelIIDM_.getNominalVoltage();
}

VoltageLevelInterface::VoltageLevelTopologyKind_t
VoltageLevelInterfaceIIDM::getVoltageLevelTopologyKind() const {
  return isNodeBreakerTopology_?VoltageLevelInterface::NODE_BREAKER:VoltageLevelInterface::BUS_BREAKER;
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

void
VoltageLevelInterfaceIIDM::calculateBusTopology() {
  if (voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::BUS_BREAKER)
    return;
  // weight to use for edge to analyse graph and find nodes on the same topological node (switch not open = closed,not retained)
  boost::unordered_map<string, float> topologicalWeights;
  // weight to use for edge to analyse graph and find nodes on the same electrical node (switch not open = closed)
  boost::unordered_map<string, float> electricalWeights;

  for (const powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getSwitches()) {
    string id = itSwitch.getId();
    bool open = itSwitch.isOpen();
    bool retained = itSwitch.isRetained();
    topologicalWeights[id] = (!open && !retained) ? 1 : 0;
    electricalWeights[id] = (!open) ? 1 : 0;
  }

  pair<unsigned int, vector<unsigned int> >topoComponents = graph_.calculateComponents(topologicalWeights);
  pair<unsigned int, vector<unsigned int> >electricalComponents = graph_.calculateComponents(electricalWeights);

  // created calculated bus, one per connected_components
  for (unsigned int i = 0; i < topoComponents.first; ++i) {
    stringstream busName;
    busName << "calculatedBus_" << voltageLevelIIDM_.getId() << "_" << i;
    shared_ptr<CalculatedBusInterfaceIIDM> bus(new CalculatedBusInterfaceIIDM(voltageLevelIIDM_, busName.str(), i));
    calculatedBus_.push_back(bus);
  }

  vector<unsigned int> component = topoComponents.second;
  boost::unordered_map<unsigned int, unsigned int> componentIndexToNodeIndex;
  boost::unordered_map<unsigned int, unsigned int> nodeIndexToComponentIndex;
  unsigned int componentIndex = 0;
  for (const auto& nodeIndex : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    componentIndexToNodeIndex[componentIndex] = nodeIndex;
    nodeIndexToComponentIndex[nodeIndex] = componentIndex;
    componentIndex++;
  }
  for (unsigned int i = 0; i != component.size(); ++i) {
    calculatedBus_[component[i]]->addNode(componentIndexToNodeIndex[i]);
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(componentIndexToNodeIndex[i]);
    if (terminal) {
      const auto& bus = terminal.get().getBusBreakerView().getConnectableBus();
      if (bus) {
        calculatedBus_[component[i]]->setU0(bus.get().getV());
        calculatedBus_[component[i]]->setAngle0(bus.get().getAngle());
      }
    }
  }

  // associate busBarSection to CalculatedBus
  vector<unsigned int> component1 = electricalComponents.second;
  map<int, set<int> > electricalNodes;
  for (unsigned int i = 0; i != component1.size(); ++i)
    electricalNodes[component1[i]].insert(componentIndexToNodeIndex[i]);

  for (powsybl::iidm::BusbarSection& bbsIIDM : voltageLevelIIDM_.getNodeBreakerView().getBusbarSections()) {
    int node = bbsIIDM.getTerminal().getNodeBreakerView().getNode();
    calculatedBus_[component[nodeIndexToComponentIndex[node]]]->addBusBarSection(bbsIIDM.getId());
    stdcxx::Reference<powsybl::iidm::Bus> bus = bbsIIDM.getTerminal().getBusBreakerView().getConnectableBus();

    // retrieve the electricalNode
    unsigned int electricalComponent = component1[nodeIndexToComponentIndex[node]];

    // set voltage and angle of bus on the same electrical nodes
    set<int> nodes = electricalNodes[electricalComponent];  // to throw
    for (set<int>::iterator iter = nodes.begin(); iter != nodes.end(); ++iter) {
      if (bus) {
        calculatedBus_[component[nodeIndexToComponentIndex[*iter]]]->setU0(bus.get().getV());
        calculatedBus_[component[nodeIndexToComponentIndex[*iter]]]->setAngle0(bus.get().getAngle());
      }
    }
  }

  if (!calculatedBus_.empty()) {
    ::TraceDebug(Trace::network()) << "------------------------------" << Trace::endline;
    ::TraceDebug(Trace::network()) << "Calculated buses from " << getID() << Trace::endline;
    ::TraceDebug(Trace::network()) << "------------------------------" << Trace::endline;
  }
  for (unsigned int i = 0; i < calculatedBus_.size(); ++i)
    ::TraceDebug(Trace::network()) << (*calculatedBus_[i]) << Trace::endline;
}

void
VoltageLevelInterfaceIIDM::exportSwitchesState() {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  for (boost::unordered_map<shared_ptr<SwitchInterface>, double >::const_iterator iter = switchState_.begin(),
      iterEnd = switchState_.end(); iter != iterEnd; ++iter) {
    int state = iter->second;
    if (state == OPEN)
      iter->first->open();
    else
      iter->first->close();
  }
}

void
VoltageLevelInterfaceIIDM::connectNode(const unsigned int& nodeToConnect) {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  assert(voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);

  // close the shortest path to one bus bar section
  vector<string> shortestPath;
  for (const auto& nodeIndex : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(nodeIndex);
    if (terminal) {
      const auto& bus = terminal.get().getBusBreakerView().getBus();
      if (bus) {
        vector<string> ret;
        graph_.shortestPath(nodeToConnect, nodeIndex, weights1_, ret);
        if (!ret.empty() && ( ret.size() < shortestPath.size() || shortestPath.size() == 0) )
          shortestPath = ret;
      }
    }
  }

  for (vector<string>::iterator iter = shortestPath.begin(); iter != shortestPath.end(); ++iter) {
    powsybl::iidm::Switch& sw = voltageLevelIIDM_.getNodeBreakerView().getSwitch(*iter);
    if (sw.isOpen()) {
      map<string, shared_ptr<SwitchInterface> >::iterator itSw = switchesById_.find(*iter);
      if (itSw != switchesById_.end()) {
        switchState_[itSw->second] = CLOSED;
      }
      sw.setOpen(false);
    }
  }
}

void
VoltageLevelInterfaceIIDM::disconnectNode(const unsigned int& nodeToDisconnect) {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  assert(voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);
  // open all paths to bus bar section
  boost::unordered_map<string, float> weights;
  for (powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getNodeBreakerView().getSwitches()) {
    weights[itSwitch.getId()] = !itSwitch.isOpen() ? 1 : 0;
  }
  for (const auto& nodeIndex : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(nodeIndex);
    if (terminal) {
      const auto& bus = terminal.get().getBusView().getBus();
      if (bus) {
        list<vector<string> > paths;
        graph_.findAllPaths(nodeToDisconnect, nodeIndex, weights, paths);

        for (list<vector<string> >::const_iterator iter = paths.begin(); iter != paths.end(); ++iter) {
          const vector<string>& path = *iter;
          for (vector<string>::const_iterator itSwitch = path.begin(); itSwitch != path.end(); ++itSwitch) {
            string switchID = *itSwitch;
            powsybl::iidm::Switch&  sw = voltageLevelIIDM_.getNodeBreakerView().getSwitch(switchID);
            if (sw.getKind() == powsybl::iidm::SwitchKind::BREAKER) {
              if (!sw.isOpen()) {
                map<string, shared_ptr<SwitchInterface> >::iterator itSw = switchesById_.find(switchID);
                if (itSw != switchesById_.end()) {
                  switchState_[itSw->second] = OPEN;
                }
                sw.setOpen(true);
              }
              break;  // no more things to do, one breaker is open
            }
          }
        }
      }
    }
  }
}

bool
VoltageLevelInterfaceIIDM::isNodeConnected(const unsigned int& nodeToCheck) {
  assert(voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);

  // Change weight of edges
  boost::unordered_map<string, float> weights;
  for (powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getNodeBreakerView().getSwitches()) {
    weights[itSwitch.getId()] = itSwitch.isOpen() ? 0 : 1;
  }

  for (const auto& nodeIndex : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(nodeIndex);
    if (terminal) {
      const auto& bus = terminal.get().getBusView().getBus();
      if (bus) {
        if (graph_.pathExist(nodeToCheck, nodeIndex, weights)) {
          return true;
        }
      }
    }
  }
  return false;
}

}  // namespace DYN
