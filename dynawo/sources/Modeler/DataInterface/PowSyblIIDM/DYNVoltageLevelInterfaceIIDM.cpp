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

static void
buildInternalConnectionId(const powsybl::iidm::node_breaker_view::InternalConnection& internalConnection, stringstream& ss) {
  ss.str(std::string());
  ss.clear();
  ss << "InternalConnection-" << internalConnection.getNode1() << "-" << internalConnection.getNode2();
}

VoltageLevelInterfaceIIDM::VoltageLevelInterfaceIIDM(powsybl::iidm::VoltageLevel& voltageLevel) :
voltageLevelIIDM_(voltageLevel) {
  isNodeBreakerTopology_ = (voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);
  if (voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    for (const auto& nodeId : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
      graph_.addVertex(static_cast<unsigned int>(nodeId));
    }

    // Add edges
    for (const powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getSwitches()) {
      if (itSwitch.isOpen() && !itSwitch.isRetained()) {
        // Disconnectors should never be closed
        continue;
      }
      int node1 = static_cast<int>(voltageLevelIIDM_.getNodeBreakerView().getNode1(itSwitch.getId()));
      int node2 = static_cast<int>(voltageLevelIIDM_.getNodeBreakerView().getNode2(itSwitch.getId()));
      graph_.addEdge(node1, node2, itSwitch.getId());
      weights1_[itSwitch.getId()] = 1;
    }
    // Additional edges for internal connections
    stringstream ssInternalConnectionId;
    for (powsybl::iidm::node_breaker_view::InternalConnection itInternalConnection : voltageLevelIIDM_.getNodeBreakerView().getInternalConnections()) {
      buildInternalConnectionId(itInternalConnection, ssInternalConnectionId);
      int node1 = static_cast<int>(itInternalConnection.getNode1());
      int node2 = static_cast<int>(itInternalConnection.getNode2());
      graph_.addEdge(node1, node2, ssInternalConnectionId.str());
      weights1_[ssInternalConnectionId.str()] = 1;
    }
  }

  slackTerminalExtension_ = voltageLevelIIDM_.findExtension<powsybl::iidm::extensions::SlackTerminal>();
}

VoltageLevelInterfaceIIDM::~VoltageLevelInterfaceIIDM() {
}

string
VoltageLevelInterfaceIIDM::getID() const {
  return voltageLevelIIDM_.getId();
}

double
VoltageLevelInterfaceIIDM::getVNom() const {
  return voltageLevelIIDM_.getNominalV();
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
  std::unordered_map<string, float> topologicalWeights;
  // weight to use for edge to analyse graph and find nodes on the same electrical node (switch not open = closed)
  std::unordered_map<string, float> electricalWeights;

  for (const powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getSwitches()) {
    if (itSwitch.isOpen() && !itSwitch.isRetained()) {
      // Opened disconnectors are not in the graph
      continue;
    }
    string id = itSwitch.getId();
    bool open = itSwitch.isOpen();
    bool retained = itSwitch.isRetained();
    topologicalWeights[id] = (!open && !retained) ? 1 : 0;
    electricalWeights[id] = (!open) ? 1 : 0;
  }
  // Add all internal connections with weight 1
  stringstream ssInternalConnectionId;
  for (powsybl::iidm::node_breaker_view::InternalConnection itInternalConnection : voltageLevelIIDM_.getNodeBreakerView().getInternalConnections()) {
    buildInternalConnectionId(itInternalConnection, ssInternalConnectionId);
    topologicalWeights[ssInternalConnectionId.str()] = 1;
    electricalWeights[ssInternalConnectionId.str()] = 1;
  }

  pair<unsigned int, vector<unsigned int> >topoComponents = graph_.calculateComponents(topologicalWeights);
  pair<unsigned int, vector<unsigned int> >electricalComponents = graph_.calculateComponents(electricalWeights);

  // created calculated bus, one per connected_components
  stringstream busName;
  for (unsigned int i = 0; i < topoComponents.first; ++i) {
    busName.str("");
    busName.clear();
    busName << "calculatedBus_" << voltageLevelIIDM_.getId() << "_" << i;
    shared_ptr<CalculatedBusInterfaceIIDM> bus(new CalculatedBusInterfaceIIDM(voltageLevelIIDM_, busName.str(), i));
    calculatedBus_.push_back(bus);
  }

  vector<unsigned int> component = topoComponents.second;
  std::unordered_map<unsigned int, unsigned int> componentIndexToNodeId;
  std::unordered_map<unsigned int, unsigned int> nodeIdToComponentIndex;
  unsigned int componentIndex = 0;
  for (const auto& nodeId : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    componentIndexToNodeId[componentIndex] = static_cast<unsigned int>(nodeId);
    nodeIdToComponentIndex[static_cast<unsigned int>(nodeId)] = componentIndex;
    componentIndex++;
  }
  for (unsigned int i = 0; i != component.size(); ++i) {
    calculatedBus_[component[i]]->addNode(componentIndexToNodeId[i]);
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(componentIndexToNodeId[i]);
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
    electricalNodes[component1[i]].insert(componentIndexToNodeId[i]);

  for (powsybl::iidm::BusbarSection& bbsIIDM : voltageLevelIIDM_.getNodeBreakerView().getBusbarSections()) {
    int node = static_cast<int>(bbsIIDM.getTerminal().getNodeBreakerView().getNode());
    calculatedBus_[component[nodeIdToComponentIndex[node]]]->addBusBarSection(bbsIIDM.getId());
    stdcxx::Reference<powsybl::iidm::Bus> bus = bbsIIDM.getTerminal().getBusBreakerView().getConnectableBus();

    // retrieve the electricalNode
    unsigned int electricalComponent = component1[nodeIdToComponentIndex[node]];

    // set voltage and angle of bus on the same electrical nodes
    set<int> nodes = electricalNodes[electricalComponent];  // to throw
    for (set<int>::iterator iter = nodes.begin(); iter != nodes.end(); ++iter) {
      if (bus) {
        calculatedBus_[component[nodeIdToComponentIndex[*iter]]]->setU0(bus.get().getV());
        calculatedBus_[component[nodeIdToComponentIndex[*iter]]]->setAngle0(bus.get().getAngle());
      }
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
VoltageLevelInterfaceIIDM::exportSwitchesState() {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  for (std::unordered_map<shared_ptr<SwitchInterface>, double>::const_iterator iter = switchState_.begin(),
      iterEnd = switchState_.end(); iter != iterEnd; ++iter) {
    int state = static_cast<int>(iter->second);
    if (state == OPEN)
      iter->first->open();
    else
      iter->first->close();
  }
}

unsigned
VoltageLevelInterfaceIIDM::countNumberOfSwitchesToClose(const std::vector<std::string>& path) const {
  unsigned res = 0;
  for (const auto& switchId : path) {
    const auto& sw = voltageLevelIIDM_.getNodeBreakerView().getSwitch(switchId);
    if (sw && sw.get().isOpen()) {
      ++res;
    }
  }
  return res;
}

void
VoltageLevelInterfaceIIDM::connectNode(const unsigned int& nodeToConnect) {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  assert(voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);

  // close the shortest path to one bus bar section
  vector<string> shortestPath;
  unsigned nbSwitchToClose = 0;
  for (const auto& nodeId : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(nodeId);
    if (terminal) {
      const auto& bus = terminal.get().getBusBreakerView().getBus();
      if (bus) {
        vector<string> ret;
        graph_.shortestPath(nodeToConnect, static_cast<unsigned int>(nodeId), weights1_, ret);
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
    }
  }

  for (vector<string>::iterator iter = shortestPath.begin(); iter != shortestPath.end(); ++iter) {
    const auto& sw = voltageLevelIIDM_.getNodeBreakerView().getSwitch(*iter);
    if (sw && sw.get().isOpen()) {
      map<string, shared_ptr<SwitchInterface> >::iterator itSw = switchesById_.find(*iter);
      if (itSw != switchesById_.end()) {
        switchState_[itSw->second] = CLOSED;
      }
      sw.get().setOpen(false);
    }
  }
}

void
VoltageLevelInterfaceIIDM::disconnectNode(const unsigned int& nodeToDisconnect) {
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  assert(voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);
  // open all paths to bus bar section
  std::unordered_map<string, float> weights;
  for (powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getNodeBreakerView().getSwitches()) {
    if (itSwitch.isOpen() && !itSwitch.isRetained()) {
      // Opened disconnectors are not in the graph
      continue;
    }
    weights[itSwitch.getId()] = !itSwitch.isOpen() ? 1 : 0;
  }
  // Additional edges for internal connections, all closed
  stringstream ssInternalConnectionId;
  for (powsybl::iidm::node_breaker_view::InternalConnection itInternalConnection : voltageLevelIIDM_.getNodeBreakerView().getInternalConnections()) {
    buildInternalConnectionId(itInternalConnection, ssInternalConnectionId);
    weights[ssInternalConnectionId.str()] = 1;
  }
  for (const auto& nodeId : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(nodeId);
    if (terminal) {
      const auto& bus = terminal.get().getBusView().getBus();
      if (bus) {
        vector<string> path;
        graph_.shortestPath(nodeToDisconnect, static_cast<unsigned int>(nodeId), weights, path);
        bool somethingWasDisconnected = true;

        while (!path.empty() && somethingWasDisconnected) {
          somethingWasDisconnected = false;
          for (vector<string>::const_iterator itSwitch = path.begin(); itSwitch != path.end(); ++itSwitch) {
            string switchID = *itSwitch;
            const auto& sw = voltageLevelIIDM_.getNodeBreakerView().getSwitch(switchID);
            if (sw && sw.get().getKind() == powsybl::iidm::SwitchKind::BREAKER) {
              if (!sw.get().isOpen()) {
                map<string, shared_ptr<SwitchInterface> >::iterator itSw = switchesById_.find(switchID);
                if (itSw != switchesById_.end()) {
                  switchState_[itSw->second] = OPEN;
                }
                sw.get().setOpen(true);
                weights[switchID] = 0;
                somethingWasDisconnected = true;
              }
              break;  // no more things to do, one breaker is open
            }
          }
          path.clear();
          graph_.shortestPath(nodeToDisconnect, static_cast<unsigned int>(nodeId), weights, path);
        }
      }
    }
  }
}

bool
VoltageLevelInterfaceIIDM::isNodeConnected(const unsigned int& nodeToCheck) {
  assert(voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER);

  // Change weight of edges
  std::unordered_map<string, float> weights;
  for (powsybl::iidm::Switch& itSwitch : voltageLevelIIDM_.getNodeBreakerView().getSwitches()) {
    if (itSwitch.isOpen() && !itSwitch.isRetained()) {
      // Opened disconnectors are not in the graph
      continue;
    }
    weights[itSwitch.getId()] = itSwitch.isOpen() ? 0 : 1;
  }
  // Additional edges for internal connections, all closed
  stringstream ssInternalConnectionId;
  for (powsybl::iidm::node_breaker_view::InternalConnection itInternalConnection : voltageLevelIIDM_.getNodeBreakerView().getInternalConnections()) {
    buildInternalConnectionId(itInternalConnection, ssInternalConnectionId);
    weights[ssInternalConnectionId.str()] = 1;
  }

  for (const auto& nodeId : voltageLevelIIDM_.getNodeBreakerView().getNodes()) {
    const auto& terminal = voltageLevelIIDM_.getNodeBreakerView().getTerminal(nodeId);
    if (terminal) {
      const auto& bus = terminal.get().getBusView().getBus();
      if (bus && graph_.pathExist(nodeToCheck, static_cast<unsigned int>(nodeId), weights)) {
        return true;
      }
    }
  }
  return false;
}

boost::optional<std::string>
VoltageLevelInterfaceIIDM::getSlackBusId() const {
  if (slackTerminalExtension_) {
    const auto& terminal = slackTerminalExtension_.get().getTerminal().get();
    if (voltageLevelIIDM_.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
      const auto& bus = terminal.getBusView().getBus().get();
      return bus.getId();
    } else {
      const auto& bus = terminal.getBusBreakerView().getBus().get();
      return bus.getId();
    }
  } else {
    return boost::none;
  }
}

}  // namespace DYN
