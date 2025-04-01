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

#include "DYNBatteryInterfaceIIDM.h"
#include "DYNDataInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDM.h"

#include <boost/pointer_cast.hpp>

namespace DYN {

ServiceManagerInterfaceIIDM::ServiceManagerInterfaceIIDM(const DataInterfaceIIDM* const dataInterface) : dataInterface_(dataInterface) {}

void
ServiceManagerInterfaceIIDM::buildGraph(Graph& graph, const boost::shared_ptr<VoltageLevelInterface>& vl) {
  std::unordered_map<std::string, size_t> indexes;

  const auto& buses = vl->getBuses();

  for (auto it = buses.begin(); it != buses.end(); ++it) {
    size_t i = it - buses.begin();
    indexes[(*it)->getID()] = i;
    // we are using the position in the vector as the vertex, as these buses are fixed
    graph.addVertex(static_cast<unsigned int>(i));
  }

  for (const auto& sw : vl->getSwitches()) {
    auto busid1 = sw->getBusInterface1()->getID();
    auto busid2 = sw->getBusInterface2()->getID();
    // we are using the position of the bus in the bus array as index in the graph, because these indexes won't change during simulation
    graph.addEdge(static_cast<unsigned int>(indexes.at(busid1)), static_cast<unsigned int>(indexes.at(busid2)), sw->getID());
  }
}

std::vector<std::string>
ServiceManagerInterfaceIIDM::getBusesConnectedBySwitch(const std::string& busId, const std::string& VLId) const {
  const auto& levels = dataInterface_->getNetwork()->getVoltageLevels();
  auto vlIt = std::find_if(levels.begin(), levels.end(), [&VLId](const boost::shared_ptr<DYN::VoltageLevelInterface>& vl) { return vl->getID() == VLId; });
  if (vlIt == levels.end()) {
    throw DYNError(Error::MODELER, UnknownVoltageLevel, VLId);
  }

  const auto& buses = (*vlIt)->getBuses();
  auto it = std::find_if(buses.begin(), buses.end(), [&busId](const boost::shared_ptr<BusInterface>& bus) { return bus->getID() == busId; });

  if (it == buses.end()) {
    // check next voltage level if bus is not part of it
    throw DYNError(Error::MODELER, UnknownBus, busId);
  }

  Graph graph;
  buildGraph(graph, *vlIt);

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
    if (graph.pathExist(static_cast<unsigned int>(busIndexFound), static_cast<unsigned int>(busIndex), weights)) {
      ret.push_back(buses.at(busIndex)->getID());
    }
  }

  return ret;
}


bool
ServiceManagerInterfaceIIDM::isBusConnected(const std::string& busId, const std::string& VLId) const {
  const auto& levels = dataInterface_->getNetwork()->getVoltageLevels();
  auto vlIt = std::find_if(levels.begin(), levels.end(), [&VLId](const boost::shared_ptr<DYN::VoltageLevelInterface>& vl) { return vl->getID() == VLId; });
  if (vlIt == levels.end()) {
    throw DYNError(Error::MODELER, UnknownVoltageLevel, VLId);
  }
  const auto& buses = (*vlIt)->getBuses();
  auto it = std::find_if(buses.begin(), buses.end(), [&busId](const boost::shared_ptr<BusInterface>& bus) { return bus->getID() == busId;});

  if (it == buses.end()) {
    // check next voltage level if bus is not part of it
    throw DYNError(Error::MODELER, UnknownBus, busId);
  }
  if ((*vlIt)->getVoltageLevelTopologyKind() == VoltageLevelInterface::BUS_BREAKER)
    return true;

  Graph graph;
  buildGraph(graph, *vlIt);

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
    if (graph.pathExist(static_cast<unsigned int>(busIndexFound), static_cast<unsigned int>(busIndex), weights) &&
        !buses[busIndex]->getBusBarSectionIdentifiers().empty()) {
      return true;
    }
  }
  return false;
}

boost::shared_ptr<BusInterface>
ServiceManagerInterfaceIIDM::getRegulatedBus(const std::string& regulatingComponent) const {
  const auto& regulatingComp = dataInterface_->findComponent(regulatingComponent);
  switch (regulatingComp->getType()) {
    case ComponentInterface::GENERATOR: {
      // the following cast is needed because for the moment an iidm battery is moved to generator type
      auto isABattery = boost::dynamic_pointer_cast<BatteryInterfaceIIDM>(regulatingComp);
      if (isABattery) {
        return boost::shared_ptr<BusInterface> ();
      } else {
        const auto& generator = dataInterface_->getNetworkIIDM().getGenerator(regulatingComp.get()->getID());
        return getRegulatedBusOnSide(generator.getRegulatingTerminal());
      }
    }
    case ComponentInterface::SVC: {
      const auto& svc = dataInterface_->getNetworkIIDM().getStaticVarCompensator(regulatingComp.get()->getID());
      return getRegulatedBusOnSide(svc.getRegulatingTerminal());
    }
    case ComponentInterface::SHUNT: {
      const auto& shunt = dataInterface_->getNetworkIIDM().getShuntCompensator(regulatingComp.get()->getID());
      return getRegulatedBusOnSide(shunt.getRegulatingTerminal());
    }
    case ComponentInterface::UNKNOWN:
    case ComponentInterface::BUS:
    case ComponentInterface::TWO_WTFO:
    case ComponentInterface::CALCULATED_BUS:
    case ComponentInterface::SWITCH:
    case ComponentInterface::LOAD:
    case ComponentInterface::LINE:
    case ComponentInterface::DANGLING_LINE:
    case ComponentInterface::THREE_WTFO:
    case ComponentInterface::LCC_CONVERTER:
    case ComponentInterface::HVDC_LINE:
    case ComponentInterface::COMPONENT_TYPE_COUNT:
      break;
    case ComponentInterface::VSC_CONVERTER: {
      const auto& vsc = dataInterface_->getNetworkIIDM().getVscConverterStation(regulatingComp.get()->getID());
      return getRegulatedBusOnSide(vsc.getTerminal());  // regulating at connection terminal
    }
  }
  return boost::shared_ptr<BusInterface> ();
}

boost::shared_ptr<BusInterface>
ServiceManagerInterfaceIIDM::getRegulatedBusOnSide(const powsybl::iidm::Terminal& terminal) const {
  auto regulatedId = dataInterface_->findBusInterface(terminal)->getID();
  const auto& regulatedComponent = dataInterface_->findComponent(regulatedId);
  switch (regulatedComponent->getType()) {
    case ComponentInterface::LINE: {
      boost::shared_ptr<LineInterface> line = boost::dynamic_pointer_cast<LineInterface>(regulatedComponent);
      const auto& lineIIDM = dataInterface_->getNetworkIIDM().getLine(regulatedComponent.get()->getID());
      if (stdcxx::areSame(terminal, lineIIDM.getTerminal1()))
        return line.get()->getBusInterface1();
      return line.get()->getBusInterface2();
    }
    case ComponentInterface::BUS:
    case ComponentInterface::CALCULATED_BUS: {
      return boost::dynamic_pointer_cast<BusInterface>(regulatedComponent);
    }
    case ComponentInterface::SWITCH: {
      boost::shared_ptr<SwitchInterface> switch_ = boost::dynamic_pointer_cast<SwitchInterface>(regulatedComponent);
      const auto& SwitchTerminals = terminal.getConnectable().get().getTerminals();
      assert(static_cast<int>(SwitchTerminals.size()) == 2);
      if (stdcxx::areSame(terminal, SwitchTerminals.at(0).get()))
        return switch_.get()->getBusInterface1();
      return switch_.get()->getBusInterface2();
    }
    case ComponentInterface::LOAD: {
      return boost::dynamic_pointer_cast<LoadInterface>(regulatedComponent).get()->getBusInterface();
    }
    case ComponentInterface::SHUNT: {
      return boost::dynamic_pointer_cast<ShuntCompensatorInterface>(regulatedComponent).get()->getBusInterface();
    }
    case ComponentInterface::DANGLING_LINE: {
      return boost::dynamic_pointer_cast<DanglingLineInterface>(regulatedComponent).get()->getBusInterface();
    }
    case ComponentInterface::TWO_WTFO: {
      boost::shared_ptr<TwoWTransformerInterface> TwoWTransf = boost::dynamic_pointer_cast<TwoWTransformerInterface>(regulatedComponent);
      const auto& TwoWTransfIIDM = dataInterface_->getNetworkIIDM().getTwoWindingsTransformer(regulatedComponent.get()->getID());
      if (stdcxx::areSame(terminal, TwoWTransfIIDM.getTerminal1()))
        return TwoWTransf.get()->getBusInterface1();
      return TwoWTransf.get()->getBusInterface2();
    }
    case ComponentInterface::SVC: {
      return boost::dynamic_pointer_cast<StaticVarCompensatorInterface>(regulatedComponent).get()->getBusInterface();
    }
    case ComponentInterface::VSC_CONVERTER: {
      return boost::dynamic_pointer_cast<VscConverterInterface>(regulatedComponent).get()->getBusInterface();
    }
    case ComponentInterface::LCC_CONVERTER: {
      return boost::dynamic_pointer_cast<LccConverterInterface>(regulatedComponent).get()->getBusInterface();
    }
    case ComponentInterface::GENERATOR: {
      return boost::dynamic_pointer_cast<GeneratorInterface>(regulatedComponent).get()->getBusInterface();
    }
    case ComponentInterface::THREE_WTFO: {
      boost::shared_ptr<ThreeWTransformerInterface> ThreeWTransf = boost::dynamic_pointer_cast<ThreeWTransformerInterface>(regulatedComponent);
      const auto& ThreeWTransfIIDM = dataInterface_->getNetworkIIDM().getThreeWindingsTransformer(regulatedComponent.get()->getID());
      if (stdcxx::areSame(terminal, ThreeWTransfIIDM.getLeg1().getTerminal()))
        return ThreeWTransf.get()->getBusInterface1();
      if (stdcxx::areSame(terminal, ThreeWTransfIIDM.getLeg2().getTerminal()))
        return ThreeWTransf.get()->getBusInterface2();
      return ThreeWTransf.get()->getBusInterface3();
    }
    case ComponentInterface::UNKNOWN:
    case ComponentInterface::HVDC_LINE:
    case ComponentInterface::COMPONENT_TYPE_COUNT:
      break;
  }
  return boost::shared_ptr<BusInterface> ();
}

}  // namespace DYN
