//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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
 * @file  DYNServiceManagerInterfaceIIDM.cpp
 *
 * @brief Service manager : implementation file for IIDM implementation
 *
 */

#include "DYNServiceManagerInterfaceIIDM.h"

#include "DYNDataInterfaceIIDM.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"

namespace DYN {

ServiceManagerInterfaceIIDM::ServiceManagerInterfaceIIDM(const DataInterfaceIIDM* const dataInterface) : dataInterface_(dataInterface), graphs_{} {}

void
ServiceManagerInterfaceIIDM::buildGraph(const boost::shared_ptr<VoltageLevelInterface>& vl) {
  auto compare = [](const boost::shared_ptr<BusInterface>& bus, const std::string& id) { return bus->getID() == id; };

  auto& graph = graphs_[vl->getID()];
  const auto& buses = vl->getBuses();

  for (size_t i = 0; i < buses.size(); i++) {
    // we are using the position in the vector as the vertex, as these buses are fixed
    graph.addVertex(i);
  }

  for (const auto& sw : vl->getSwitches()) {
    auto busid1 = sw->getBusInterface1()->getID();
    auto bus1It1 = std::find_if(buses.begin(), buses.end(), std::bind(compare, std::placeholders::_1, busid1));
#if _DEBUG_
    // shouldn't happen by construction of the IIDM element
    assert(bus1It1 != buses.end());
#endif
    auto busid2 = sw->getBusInterface2()->getID();
    auto bus1It2 = std::find_if(buses.begin(), buses.end(), std::bind(compare, std::placeholders::_1, busid2));
#if _DEBUG_
    // shouldn't happen by construction of the IIDM element
    assert(bus1It2 != buses.end());
#endif
    // we are using the position of the bus in the bus array as index in the graph, because these indexes won't change during simulation
    graph.addEdge(bus1It1 - buses.begin(), bus1It2 - buses.begin(), sw->getID());
  }
}

std::vector<std::string>
ServiceManagerInterfaceIIDM::getBusesConnectedBySwitch(const std::string& busId, const std::string& VLId) {
  const auto& levels = dataInterface_->getNetwork()->getVoltageLevels();
  auto vlIt = std::find_if(levels.begin(), levels.end(), [&VLId](const boost::shared_ptr<DYN::VoltageLevelInterface>& vl) { return vl->getID() == VLId; });
  if (vlIt == levels.end()) {
    throw DYNError(Error::MODELER, UnknownVoltageLevel, VLId);
  }

  if ((*vlIt)->getVoltageLevelTopologyKind() == VoltageLevelInterface::NODE_BREAKER) {
    throw DYNError(Error::MODELER, VoltageLevelTopoError, VLId);
  }

  const auto& buses = (*vlIt)->getBuses();
  auto it = std::find_if(buses.begin(), buses.end(), [&busId](const boost::shared_ptr<BusInterface>& bus) { return bus->getID() == busId; });

  if (it == buses.end()) {
    // check next voltage level if bus is not part of it
    throw DYNError(Error::MODELER, UnknownBus, busId);
  }

  if (graphs_.count((*vlIt)->getID()) == 0) {
    buildGraph(*vlIt);
  }

  // Change weight of edges
  boost::unordered_map<std::string, float> weights;
  for (const auto& sw : (*vlIt)->getSwitches()) {
    weights[sw->getID()] = sw->isOpen() ? 0 : 1;
  }

  std::vector<std::string> ret;

  size_t busIndexFound = it - buses.begin();
  for (size_t busIndex = 0; busIndex < buses.size(); busIndex++) {
    if (busIndex == busIndexFound) {
      continue;
    }
    if (graphs_.at((*vlIt)->getID()).pathExist(busIndexFound, busIndex, weights)) {
      ret.push_back(buses.at(busIndex)->getID());
    }
  }

  // Bus ids are unique so we can stop the loop here
  return ret;
}

}  // namespace DYN
