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
 * @file  DYNDataInterfaceIIDM.cpp
 *
 * @brief Data interface : implementation file of IIDM implementation
 *
 */
#include <iostream>

#include <IIDM/Network.h>
#include <IIDM/components/Bus.h>
#include <IIDM/components/Switch.h>
#include <IIDM/components/Line.h>
#include <IIDM/components/Transformer2Windings.h>
#include <IIDM/components/Transformer3Windings.h>
#include <IIDM/components/TapChanger.h>
#include <IIDM/components/Load.h>
#include <IIDM/components/ShuntCompensator.h>
#include <IIDM/components/Generator.h>
#include <IIDM/components/DanglingLine.h>
#include <IIDM/components/CurrentLimit.h>
#include <IIDM/components/Substation.h>
#include <IIDM/components/TieLine.h>
#include <IIDM/components/StaticVarCompensator.h>
#include <IIDM/components/VoltageLevel.h>
#include <IIDM/components/HvdcLine.h>
#include <IIDM/components/VscConverterStation.h>
#include <IIDM/components/LccConverterStation.h>

#include "DYNDataInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNBusBarSectionInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNTwoWTransformerInterfaceIIDM.h"
#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNStepInterfaceIIDM.h"
#include "DYNCalculatedBusInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNMacrosMessage.h"
#include "DYNSubModel.h"
#include "DYNTimer.h"
#include "DYNTrace.h"
#include "DYNErrorQueue.h"
#include "DYNCriteria.h"
#include "CRTCriteria.h"
#include "CRTCriteriaParams.h"

using std::map;
using std::string;
using std::vector;
using std::stringstream;

using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using criteria::CriteriaCollection;

namespace DYN {

DataInterfaceIIDM::DataInterfaceIIDM(IIDM::Network networkIIDM) :
networkIIDM_(networkIIDM) {
}

DataInterfaceIIDM::~DataInterfaceIIDM() {
}

IIDM::Network&
DataInterfaceIIDM::getNetworkIIDM() {
  return networkIIDM_;
}

std::string
DataInterfaceIIDM::getBusName(const std::string& componentName) {
  map<string, shared_ptr<ComponentInterface> >::const_iterator iter = components_.find(componentName);
  string busName = "";
  if (iter != components_.end()) {
    shared_ptr<ComponentInterface> component = iter->second;

    switch (component->getType()) {
      case ComponentInterface::BUS:
      case ComponentInterface::CALCULATED_BUS: {
        shared_ptr<BusInterface> bus = dynamic_pointer_cast<BusInterface>(component);
        busName = bus->getID();
        break;
      }
      case ComponentInterface::SWITCH:
        break;
      case ComponentInterface::LOAD: {
        shared_ptr<LoadInterface> load = dynamic_pointer_cast<LoadInterface>(component);
        busName = load->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::LINE:  // @todo with @NODE1@, @NODE2@
        break;
      case ComponentInterface::GENERATOR: {
        shared_ptr<GeneratorInterface> generator = dynamic_pointer_cast<GeneratorInterface>(component);
        busName = generator->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::SHUNT: {
        shared_ptr<ShuntCompensatorInterface> shunt = dynamic_pointer_cast<ShuntCompensatorInterface>(component);
        busName = shunt->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::DANGLING_LINE: {
        shared_ptr<DanglingLineInterface> line = dynamic_pointer_cast<DanglingLineInterface>(component);
        busName = line->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::TWO_WTFO:  // @todo with @NODE1@ , @NODE2@
        break;
      case ComponentInterface::THREE_WTFO:  // @todo with @NODE1@, @NODE2@
        break;
      case ComponentInterface::SVC: {
        shared_ptr<StaticVarCompensatorInterface> svc = dynamic_pointer_cast<StaticVarCompensatorInterface>(component);
        busName = svc->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::VSC_CONVERTER: {
        shared_ptr<VscConverterInterface> vsc = dynamic_pointer_cast<VscConverterInterface>(component);
        busName = vsc->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::LCC_CONVERTER: {
        shared_ptr<LccConverterInterface> lcc = dynamic_pointer_cast<LccConverterInterface>(component);
        busName = lcc->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::HVDC_LINE:
        break;
      case ComponentInterface::UNKNOWN:
        break;
    }
  }
  return busName;
}

void
DataInterfaceIIDM::initFromIIDM() {
  // create network interface
  network_.reset(new NetworkInterfaceIIDM(networkIIDM_));

  IIDM::Contains<IIDM::Substation>::iterator itSubstation = networkIIDM_.substations().begin();
  for (; itSubstation != networkIIDM_.substations().end(); ++itSubstation) {
    IIDM::Contains<IIDM::VoltageLevel>::iterator itVoltageLevel = itSubstation->voltageLevels().begin();
    for (; itVoltageLevel != itSubstation->voltageLevels().end(); ++itVoltageLevel) {
      shared_ptr<VoltageLevelInterface> voltageLevel = importVoltageLevel(*itVoltageLevel);
      network_->addVoltageLevel(voltageLevel);
      voltageLevels_[voltageLevel->getID()] = voltageLevel;
    }

    //===========================
    //  ADD 2WTFO INTERFACE
    //===========================
    IIDM::Contains<IIDM::Transformer2Windings>::iterator it2WTfo = itSubstation->twoWindingsTransformers().begin();
    for (; it2WTfo != itSubstation->twoWindingsTransformers().end(); ++it2WTfo) {
      if ( !(*it2WTfo).has_connection(IIDM::side_1) && !(*it2WTfo).has_connection(IIDM::side_2) ) {
        Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*it2WTfo).id()) << Trace::endline;
        continue;
      }
      shared_ptr<TwoWTransformerInterface> tfo = importTwoWindingsTransformer(*it2WTfo);
      network_->addTwoWTransformer(tfo);
      components_[tfo->getID()] = tfo;
    }

    //===========================
    //  ADD 3WTFO INTERFACE
    //===========================
    IIDM::Contains<IIDM::Transformer3Windings>::iterator it3WTfo = itSubstation->threeWindingsTransformers().begin();
    for (; it3WTfo != itSubstation->threeWindingsTransformers().end(); ++it3WTfo) {
      if (!(*it3WTfo).has_connection(IIDM::side_1) && !(*it3WTfo).has_connection(IIDM::side_2) && !(*it3WTfo).has_connection(IIDM::side_3)) {
        Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*it3WTfo).id()) << Trace::endline;
        continue;
      }
      shared_ptr<ThreeWTransformerInterface> tfo = importThreeWindingsTransformer(*it3WTfo);
      network_->addThreeWTransformer(tfo);
      components_[tfo->getID()] = tfo;
    }
  }


  //===========================
  //  ADD LINE INTERFACE
  //===========================
  IIDM::Contains<IIDM::Line>::iterator itLine = networkIIDM_.lines().begin();
  for (; itLine != networkIIDM_.lines().end(); ++itLine) {
    if ( !(*itLine).has_connection(IIDM::side_1) && !(*itLine).has_connection(IIDM::side_2) ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itLine).id()) << Trace::endline;
      continue;
    }
    shared_ptr<LineInterface> line = importLine(*itLine);
    network_->addLine(line);
    components_[line->getID()] = line;
  }

  //===========================
  //  ADD TIELINE INTERFACE
  //===========================
  IIDM::Contains<IIDM::TieLine>::iterator itTieLine = networkIIDM_.tielines().begin();
  for (; itTieLine != networkIIDM_.tielines().end(); ++itTieLine) {
    if ( !(*itTieLine).has_connection(IIDM::side_1) && !(*itTieLine).has_connection(IIDM::side_2) ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itTieLine).id()) << Trace::endline;
      continue;
    }
    importTieLine(*itTieLine);
  }

  //===========================
  //  ADD HVDC LINE INTERFACE
  //===========================
  IIDM::Contains<IIDM::HvdcLine>::iterator itHvdcLine = networkIIDM_.hvdclines().begin();
  for (; itHvdcLine != networkIIDM_.hvdclines().end(); ++itHvdcLine) {
    shared_ptr<HvdcLineInterfaceIIDM> hvdc(new HvdcLineInterfaceIIDM(*itHvdcLine));
    network_->addHvdcLine(hvdc);
    components_[hvdc->getID()] = hvdc;
  }
  DYNErrorQueue::get()->flush();
}

shared_ptr<VoltageLevelInterface>
DataInterfaceIIDM::importVoltageLevel(IIDM::VoltageLevel& voltageLevelIIDM) {
  shared_ptr<VoltageLevelInterfaceIIDM> voltageLevel(new VoltageLevelInterfaceIIDM(voltageLevelIIDM));

  if (voltageLevelIIDM.mode() == IIDM::VoltageLevel::node_breaker) {
    voltageLevel->calculateBusTopology();

    vector<shared_ptr<CalculatedBusInterfaceIIDM> > buses = voltageLevel->getCalculatedBus();
    for (unsigned int i = 0; i < buses.size(); ++i) {
      components_[buses[i]->getID()] = buses[i];
      calculatedBusComponents_[voltageLevel->getID()].push_back(buses[i]);
      voltageLevel->addBus(buses[i]);
    }

    IIDM::Contains<IIDM::Switch>::iterator itSwitch = voltageLevelIIDM.switches().begin();
    for (; itSwitch != voltageLevelIIDM.switches().end(); ++itSwitch) {
      bool open = itSwitch->opened();
      bool retained = itSwitch->retained();
      if (open || retained) {  // if the switch is close or not retained, don't create a specific switch model
        shared_ptr<SwitchInterface> sw = importSwitch(*itSwitch);
        if (sw->getBusInterface1() != sw->getBusInterface2()) {  // if the switch is connecting one single bus, don't create a specific switch model
          components_[sw->getID()] = sw;
          voltageLevel->addSwitch(sw);
        }
      }
    }
  } else {
    //===========================
    //  ADD BUS/SWITCH INTERFACE
    //===========================
    IIDM::Contains<IIDM::Bus>::iterator itBus = voltageLevelIIDM.buses().begin();
    for (; itBus != voltageLevelIIDM.buses().end(); ++itBus) {
      shared_ptr<BusInterfaceIIDM> bus(new BusInterfaceIIDM(*itBus));
      components_[bus->getID()] = bus;
      busComponents_[bus->getID()] = bus;
      voltageLevel->addBus(bus);
    }

    //===========================
    //  ADD SWITCH INTERFACE
    //===========================
    IIDM::Contains<IIDM::Switch>::iterator itSwitch = voltageLevelIIDM.switches().begin();
    for (; itSwitch != voltageLevelIIDM.switches().end(); ++itSwitch) {
      shared_ptr<SwitchInterface> sw = importSwitch(*itSwitch);  // in bus breaker topology, keep all switches
      components_[sw->getID()] = sw;
      voltageLevel->addSwitch(sw);
    }
  }

  //===========================
  //  ADD GENERATOR INTERFACE
  //===========================
  IIDM::Contains<IIDM::Generator>::iterator itGen = voltageLevelIIDM.generators().begin();
  for (; itGen != voltageLevelIIDM.generators().end(); ++itGen) {
    if ( !(*itGen).has_connection() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itGen).id()) << Trace::endline;
      continue;
    }
    shared_ptr<GeneratorInterface> generator = importGenerator(*itGen);
    voltageLevel->addGenerator(generator);
    components_[generator->getID()] = generator;
    generatorComponents_[generator->getID()] = generator;
    generator->setVoltageLevelInterface(voltageLevel);
  }

  //===========================
  //  ADD LOAD INTERFACE
  //===========================
  IIDM::Contains<IIDM::Load>::iterator itLoad = voltageLevelIIDM.loads().begin();
  for (; itLoad != voltageLevelIIDM.loads().end(); ++itLoad) {
    if ( !(*itLoad).has_connection() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itLoad).id()) << Trace::endline;
      continue;
    }
    shared_ptr<LoadInterface> load = importLoad(*itLoad);
    voltageLevel->addLoad(load);
    components_[load->getID()] = load;
    loadComponents_[load->getID()] = load;
    load->setVoltageLevelInterface(voltageLevel);
  }

  // =======================================
  //    ADD SHUNTCOMPENSATORS INTERFACE
  // =======================================
  IIDM::Contains<IIDM::ShuntCompensator>::iterator itShunt = voltageLevelIIDM.shuntCompensators().begin();
  for (; itShunt != voltageLevelIIDM.shuntCompensators().end(); ++itShunt) {
    if ( !(*itShunt).has_connection() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itShunt).id()) << Trace::endline;
      continue;
    }
    shared_ptr<ShuntCompensatorInterface> shunt = importShuntCompensator(*itShunt);
    voltageLevel->addShuntCompensator(shunt);
    components_[shunt->getID()] = shunt;
    shunt->setVoltageLevelInterface(voltageLevel);
  }

  //==============================
  //  ADD DANGLINGLINE INTERFACE
  //==============================
  IIDM::Contains<IIDM::DanglingLine>::iterator itDanglingLine = voltageLevelIIDM.danglingLines().begin();
  for (; itDanglingLine != voltageLevelIIDM.danglingLines().end(); ++itDanglingLine) {
    if ( !(*itDanglingLine).has_connection() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itDanglingLine).id()) << Trace::endline;
      continue;
    }
    shared_ptr<DanglingLineInterface> line = importDanglingLine(*itDanglingLine);
    voltageLevel->addDanglingLine(line);
    components_[line->getID()] = line;
    line->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD STATICVARCOMPENSATOR INTERFACE
  //==========================================
  IIDM::Contains<IIDM::StaticVarCompensator>::iterator itSVC = voltageLevelIIDM.staticVarCompensators().begin();
  for (; itSVC != voltageLevelIIDM.staticVarCompensators().end(); ++itSVC) {
    if ( !(*itSVC).has_connection() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itSVC).id()) << Trace::endline;
      continue;
    }
    shared_ptr<StaticVarCompensatorInterface> svc = importStaticVarCompensator(*itSVC);
    voltageLevel->addStaticVarCompensator(svc);
    components_[svc->getID()] = svc;
    svc->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD VSC CONVERTER INTERFACE
  //==========================================
  IIDM::Contains<IIDM::VscConverterStation>::iterator itVSC = voltageLevelIIDM.vscConverterStations().begin();
  for (; itVSC != voltageLevelIIDM.vscConverterStations().end(); ++itVSC) {
    if ( !(*itVSC).has_connection() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itVSC).id()) << Trace::endline;
      continue;
    }
    shared_ptr<VscConverterInterface> vsc = importVscConverter(*itVSC);
    voltageLevel->addVscConverter(vsc);
    components_[vsc->getID()] = vsc;
    vsc->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD LCC CONVERTER INTERFACE
  //==========================================
  IIDM::Contains<IIDM::LccConverterStation>::iterator itLCC = voltageLevelIIDM.lccConverterStations().begin();
  for (; itLCC != voltageLevelIIDM.lccConverterStations().end(); ++itLCC) {
    if ( !(*itLCC).has_connection() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itLCC).id()) << Trace::endline;
      continue;
    }
    shared_ptr<LccConverterInterface> lcc = importLccConverter(*itLCC);
    voltageLevel->addLccConverter(lcc);
    components_[lcc->getID()] = lcc;
    lcc->setVoltageLevelInterface(voltageLevel);
  }
#ifdef LANG_CXX11
  return std::move(voltageLevel);
#else
  return voltageLevel;
#endif
}

shared_ptr<SwitchInterface>
DataInterfaceIIDM::importSwitch(IIDM::Switch& switchIIDM) {
  shared_ptr<SwitchInterfaceIIDM> sw(new SwitchInterfaceIIDM(switchIIDM));

  // reference to bus interface
  if (switchIIDM.port1().is_bus()) {
    string id1 = switchIIDM.port1().port().bus_id();
    sw->setBusInterface1(findBusInterface(id1));
  } else if (switchIIDM.port1().is_node()) {
    int node = switchIIDM.port1().node();
    string voltageLevelId = switchIIDM.voltageLevel().id();
    sw->setBusInterface1(findCalculatedBusInterface(voltageLevelId, node));
  }

  if (switchIIDM.port2().is_bus()) {
    string id2 = switchIIDM.port2().port().bus_id();
    sw->setBusInterface2(findBusInterface(id2));
  } else if (switchIIDM.port2().is_node()) {
    int node = switchIIDM.port2().node();
    string voltageLevelId = switchIIDM.voltageLevel().id();
    sw->setBusInterface2(findCalculatedBusInterface(voltageLevelId, node));
  }
#ifdef LANG_CXX11
  return std::move(sw);
#else
  return sw;
#endif
}

shared_ptr<GeneratorInterface>
DataInterfaceIIDM::importGenerator(IIDM::Generator & generatorIIDM) {
  shared_ptr<GeneratorInterfaceIIDM> generator(new GeneratorInterfaceIIDM(generatorIIDM));

  // reference to bus interface
  if (generatorIIDM.is_bus()) {
    string id = generatorIIDM.bus_id();
    generator->setBusInterface(findBusInterface(id));
  } else if (generatorIIDM.is_node()) {
    string voltageLevelId = generatorIIDM.voltageLevel().id();
    int node = generatorIIDM.node();
    generator->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
  }
#ifdef LANG_CXX11
  return std::move(generator);
#else
  return generator;
#endif
}

shared_ptr<LoadInterface>
DataInterfaceIIDM::importLoad(IIDM::Load& loadIIDM) {
  shared_ptr<LoadInterfaceIIDM> load(new LoadInterfaceIIDM(loadIIDM));

  // reference to bus interface
  if (loadIIDM.is_bus()) {
    string id = loadIIDM.bus_id();
    load->setBusInterface(findBusInterface(id));
  } else if (loadIIDM.is_node()) {
    string voltageLevelId = loadIIDM.voltageLevel().id();
    int node = loadIIDM.node();
    load->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
  }
#ifdef LANG_CXX11
  return std::move(load);
#else
  return load;
#endif
}

shared_ptr<ShuntCompensatorInterface>
DataInterfaceIIDM::importShuntCompensator(IIDM::ShuntCompensator& shuntIIDM) {
  shared_ptr<ShuntCompensatorInterfaceIIDM> shunt(new ShuntCompensatorInterfaceIIDM(shuntIIDM));

  // reference to bus interface
  if (shuntIIDM.is_bus()) {
    string id = shuntIIDM.bus_id();
    shunt->setBusInterface(findBusInterface(id));
  } else if (shuntIIDM.is_node()) {
    string voltageLevelId = shuntIIDM.voltageLevel().id();
    int node = shuntIIDM.node();
    shunt->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
  }
#ifdef LANG_CXX11
  return std::move(shunt);
#else
  return shunt;
#endif
}

shared_ptr<DanglingLineInterface>
DataInterfaceIIDM::importDanglingLine(IIDM::DanglingLine& danglingLineIIDM) {
  shared_ptr<DanglingLineInterfaceIIDM> danglingLine(new DanglingLineInterfaceIIDM(danglingLineIIDM));

  // reference to bus interface
  if (danglingLineIIDM.is_bus()) {
    string id = danglingLineIIDM.bus_id();
    danglingLine->setBusInterface(findBusInterface(id));
  } else if (danglingLineIIDM.is_node()) {
    string voltageLevelId = danglingLineIIDM.voltageLevel().id();
    int node = danglingLineIIDM.node();
    danglingLine->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
  }

  if (danglingLineIIDM.has_currentLimits()) {
    IIDM::CurrentLimits currentLimits = danglingLineIIDM.currentLimits();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      danglingLine->addCurrentLimitInterface(cLimit);
    }

    // temporary limit
    IIDM::CurrentLimits::const_iterator it = currentLimits.begin();
    for (; it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        danglingLine->addCurrentLimitInterface(cLimit);
      }
    }
  }
#ifdef LANG_CXX11
  return std::move(danglingLine);
#else
  return danglingLine;
#endif
}

shared_ptr<StaticVarCompensatorInterface>
DataInterfaceIIDM::importStaticVarCompensator(IIDM::StaticVarCompensator& svcIIDM) {
  shared_ptr<StaticVarCompensatorInterfaceIIDM> svc(new StaticVarCompensatorInterfaceIIDM(svcIIDM));

  // reference to bus interface
  if (svcIIDM.is_bus()) {
    string id = svcIIDM.bus_id();
    svc->setBusInterface(findBusInterface(id));
  } else if (svcIIDM.is_node()) {
    string voltageLevelId = svcIIDM.voltageLevel().id();
    int node = svcIIDM.node();
    svc->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
  }
#ifdef LANG_CXX11
  return std::move(svc);
#else
  return svc;
#endif
}

shared_ptr<TwoWTransformerInterface>
DataInterfaceIIDM::importTwoWindingsTransformer(IIDM::Transformer2Windings & twoWTfoIIDM) {
  shared_ptr<TwoWTransformerInterfaceIIDM> twoWTfo(new TwoWTransformerInterfaceIIDM(twoWTfoIIDM));

  // add phase tapChanger and steps if exists
  if (twoWTfoIIDM.has_phaseTapChanger()) {
    shared_ptr<PhaseTapChangerInterfaceIIDM> tapChanger(new PhaseTapChangerInterfaceIIDM(twoWTfoIIDM.phaseTapChanger()));

    IIDM::PhaseTapChanger::const_iterator itStep = twoWTfoIIDM.phaseTapChanger().begin();
    for (; itStep != twoWTfoIIDM.phaseTapChanger().end(); ++itStep) {
      shared_ptr<StepInterfaceIIDM> step(new StepInterfaceIIDM(*itStep));
      tapChanger->addStep(step);
    }
    twoWTfo->setPhaseTapChanger(tapChanger);
  }
  // add ratio tapChanger and steps if exists
  if (twoWTfoIIDM.has_ratioTapChanger()) {
    shared_ptr<RatioTapChangerInterfaceIIDM> tapChanger(new RatioTapChangerInterfaceIIDM(twoWTfoIIDM.ratioTapChanger(), twoWTfoIIDM.id()));
    IIDM::RatioTapChanger::const_iterator itStep = twoWTfoIIDM.ratioTapChanger().begin();
    for (; itStep != twoWTfoIIDM.ratioTapChanger().end(); ++itStep) {
      shared_ptr<StepInterfaceIIDM> step(new StepInterfaceIIDM(*itStep));
      tapChanger->addStep(step);
    }
    twoWTfo->setRatioTapChanger(tapChanger);
  }


  // reference to bus interface
  if (twoWTfoIIDM.connection(IIDM::side_1)) {
    string voltageLevel = twoWTfoIIDM.connection(IIDM::side_1)->connectionPoint().voltageLevel();
    if (twoWTfoIIDM.connection(IIDM::side_1)->connectionPoint().is_bus()) {
      string id1 = twoWTfoIIDM.connection(IIDM::side_1)->connectionPoint().bus_id();
      twoWTfo->setBusInterface1(findBusInterface(id1));
    } else if (twoWTfoIIDM.connection(IIDM::side_1)->connectionPoint().is_node()) {
      int node = twoWTfoIIDM.connection(IIDM::side_1)->connectionPoint().node();
      twoWTfo->setBusInterface1(findCalculatedBusInterface(voltageLevel, node));
    }
    twoWTfo->setVoltageLevelInterface1(findVoltageLevelInterface(voltageLevel));
  }

  if (twoWTfoIIDM.connection(IIDM::side_2)) {
    string voltageLevel = twoWTfoIIDM.connection(IIDM::side_2)->connectionPoint().voltageLevel();
    if (twoWTfoIIDM.connection(IIDM::side_2)->connectionPoint().is_bus()) {
      string id2 = twoWTfoIIDM.connection(IIDM::side_2)->connectionPoint().bus_id();
      twoWTfo->setBusInterface2(findBusInterface(id2));
    } else if (twoWTfoIIDM.connection(IIDM::side_2)->connectionPoint().is_node()) {
      int node = twoWTfoIIDM.connection(IIDM::side_2)->connectionPoint().node();
      twoWTfo->setBusInterface2(findCalculatedBusInterface(voltageLevel, node));
    }
    twoWTfo->setVoltageLevelInterface2(findVoltageLevelInterface(voltageLevel));
  }

  if (twoWTfoIIDM.has_currentLimits1()) {
    IIDM::CurrentLimits currentLimits = twoWTfoIIDM.currentLimits1();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      twoWTfo->addCurrentLimitInterface1(cLimit);
    }

    // temporary limit
    for (IIDM::CurrentLimits::const_iterator it = currentLimits.begin(); it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        twoWTfo->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (twoWTfoIIDM.has_currentLimits2()) {
    IIDM::CurrentLimits currentLimits = twoWTfoIIDM.currentLimits2();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      twoWTfo->addCurrentLimitInterface2(cLimit);
    }

    // temporary limit
    for (IIDM::CurrentLimits::const_iterator it = currentLimits.begin(); it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        twoWTfo->addCurrentLimitInterface2(cLimit);
      }
    }
  }
#ifdef LANG_CXX11
  return std::move(twoWTfo);
#else
  return twoWTfo;
#endif
}

shared_ptr<ThreeWTransformerInterface>
DataInterfaceIIDM::importThreeWindingsTransformer(IIDM::Transformer3Windings & threeWTfoIIDM) {
  shared_ptr<ThreeWTransformerInterfaceIIDM> threeWTfo(new ThreeWTransformerInterfaceIIDM(threeWTfoIIDM));

  // reference to bus interface
  if (threeWTfoIIDM.connection(IIDM::side_1)) {
    string voltageLevel = threeWTfoIIDM.connection(IIDM::side_1)->connectionPoint().voltageLevel();
    if (threeWTfoIIDM.connection(IIDM::side_1)->connectionPoint().is_bus()) {
      string id1 = threeWTfoIIDM.connection(IIDM::side_1)->connectionPoint().bus_id();
      threeWTfo->setBusInterface1(findBusInterface(id1));
    } else if (threeWTfoIIDM.connection(IIDM::side_1)->connectionPoint().is_node()) {
      int node = threeWTfoIIDM.connection(IIDM::side_1)->connectionPoint().node();
      threeWTfo->setBusInterface1(findCalculatedBusInterface(voltageLevel, node));
    }
    threeWTfo->setVoltageLevelInterface1(findVoltageLevelInterface(voltageLevel));
  }

  if (threeWTfoIIDM.connection(IIDM::side_2)) {
    string voltageLevel = threeWTfoIIDM.connection(IIDM::side_2)->connectionPoint().voltageLevel();
    if (threeWTfoIIDM.connection(IIDM::side_2)->connectionPoint().is_bus()) {
      string id2 = threeWTfoIIDM.connection(IIDM::side_2)->connectionPoint().bus_id();
      threeWTfo->setBusInterface2(findBusInterface(id2));
    } else if (threeWTfoIIDM.connection(IIDM::side_2)->connectionPoint().is_node()) {
      int node = threeWTfoIIDM.connection(IIDM::side_2)->connectionPoint().node();
      threeWTfo->setBusInterface2(findCalculatedBusInterface(voltageLevel, node));
    }
    threeWTfo->setVoltageLevelInterface2(findVoltageLevelInterface(voltageLevel));
  }

  if (threeWTfoIIDM.connection(IIDM::side_3)) {
    string voltageLevel = threeWTfoIIDM.connection(IIDM::side_3)->connectionPoint().voltageLevel();
    if (threeWTfoIIDM.connection(IIDM::side_3)->connectionPoint().is_bus()) {
      string id3 = threeWTfoIIDM.connection(IIDM::side_3)->connectionPoint().bus_id();
      threeWTfo->setBusInterface3(findBusInterface(id3));
    } else if (threeWTfoIIDM.connection(IIDM::side_3)->connectionPoint().is_node()) {
      int node = threeWTfoIIDM.connection(IIDM::side_3)->connectionPoint().node();
      threeWTfo->setBusInterface3(findCalculatedBusInterface(voltageLevel, node));
    }
    threeWTfo->setVoltageLevelInterface3(findVoltageLevelInterface(voltageLevel));
  }

  if (threeWTfoIIDM.has_currentLimits1()) {
    IIDM::CurrentLimits currentLimits = threeWTfoIIDM.currentLimits1();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      threeWTfo->addCurrentLimitInterface1(cLimit);
    }

    // temporary limit
    IIDM::CurrentLimits::const_iterator it = currentLimits.begin();
    for (; it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        threeWTfo->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (threeWTfoIIDM.has_currentLimits2()) {
    IIDM::CurrentLimits currentLimits = threeWTfoIIDM.currentLimits2();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      threeWTfo->addCurrentLimitInterface2(cLimit);
    }

    // temporary limit
    IIDM::CurrentLimits::const_iterator it = currentLimits.begin();
    for (; it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        threeWTfo->addCurrentLimitInterface2(cLimit);
      }
    }
  }

  if (threeWTfoIIDM.has_currentLimits3()) {
    IIDM::CurrentLimits currentLimits = threeWTfoIIDM.currentLimits3();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      threeWTfo->addCurrentLimitInterface3(cLimit);
    }

    // temporary limit
    IIDM::CurrentLimits::const_iterator it = currentLimits.begin();
    for (; it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        threeWTfo->addCurrentLimitInterface3(cLimit);
      }
    }
  }
#ifdef LANG_CXX11
  return std::move(threeWTfo);
#else
  return threeWTfo;
#endif
}

shared_ptr<LineInterface>
DataInterfaceIIDM::importLine(IIDM::Line& lineIIDM) {
  shared_ptr<LineInterfaceIIDM> line(new LineInterfaceIIDM(lineIIDM));

  // reference to bus interface
  if (lineIIDM.connection(IIDM::side_1)) {
    string voltageLevel = lineIIDM.connection(IIDM::side_1)->connectionPoint().voltageLevel();
    if (lineIIDM.connection(IIDM::side_1)->connectionPoint().is_bus()) {
      string id1 = lineIIDM.connection(IIDM::side_1)->connectionPoint().bus_id();
      line->setBusInterface1(findBusInterface(id1));
    } else if (lineIIDM.connection(IIDM::side_1)->connectionPoint().is_node()) {
      int node = lineIIDM.connection(IIDM::side_1)->connectionPoint().node();
      line->setBusInterface1(findCalculatedBusInterface(voltageLevel, node));
    }
    line->setVoltageLevelInterface1(findVoltageLevelInterface(voltageLevel));
  }

  if (lineIIDM.connection(IIDM::side_2)) {
    string voltageLevel = lineIIDM.connection(IIDM::side_2)->connectionPoint().voltageLevel();
    if (lineIIDM.connection(IIDM::side_2)->connectionPoint().is_bus()) {
      string id2 = lineIIDM.connection(IIDM::side_2)->connectionPoint().bus_id();
      line->setBusInterface2(findBusInterface(id2));
    } else if (lineIIDM.connection(IIDM::side_2)->connectionPoint().is_node()) {
      int node = lineIIDM.connection(IIDM::side_2)->connectionPoint().node();
      line->setBusInterface2(findCalculatedBusInterface(voltageLevel, node));
    }
    line->setVoltageLevelInterface2(findVoltageLevelInterface(voltageLevel));
  }

  if (lineIIDM.has_currentLimits1()) {
    IIDM::CurrentLimits currentLimits = lineIIDM.currentLimits1();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      line->addCurrentLimitInterface1(cLimit);
    }

    // temporary limit
    IIDM::CurrentLimits::const_iterator it = currentLimits.begin();
    for (; it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        line->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (lineIIDM.has_currentLimits2()) {
    IIDM::CurrentLimits currentLimits = lineIIDM.currentLimits2();

     // permanent limit
    if (currentLimits.has_permanent_limit()) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.permanent_limit(), boost::none));
      line->addCurrentLimitInterface2(cLimit);
    }

    // temporary limit
    IIDM::CurrentLimits::const_iterator it = currentLimits.begin();
    for (; it != currentLimits.end(); ++it) {
      bool fictitious = (it->fictitious) ? *(it->fictitious) : false;
      if (!fictitious) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(it->value, it->acceptableDuration));
        line->addCurrentLimitInterface2(cLimit);
      }
    }
  }
#ifdef LANG_CXX11
  return std::move(line);
#else
  return line;
#endif
}

void
DataInterfaceIIDM::importTieLine(IIDM::TieLine& /*lineIIDM*/) {
  // nothing to do
}

shared_ptr<VscConverterInterface>
DataInterfaceIIDM::importVscConverter(IIDM::VscConverterStation& vscIIDM) {
  shared_ptr<VscConverterInterfaceIIDM> vsc(new VscConverterInterfaceIIDM(vscIIDM));

  // reference to bus interface
  if (vscIIDM.is_bus()) {
    string id = vscIIDM.bus_id();
    vsc->setBusInterface(findBusInterface(id));
  } else if (vscIIDM.is_node()) {
    string voltageLevelId = vscIIDM.voltageLevel().id();
    int node = vscIIDM.node();
    vsc->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
  }
#ifdef LANG_CXX11
  return std::move(vsc);
#else
  return vsc;
#endif
}

shared_ptr<LccConverterInterface>
DataInterfaceIIDM::importLccConverter(IIDM::LccConverterStation& lccIIDM) {
  shared_ptr<LccConverterInterfaceIIDM> lcc(new LccConverterInterfaceIIDM(lccIIDM));

  // reference to bus interface
  if (lccIIDM.is_bus()) {
    string id = lccIIDM.bus_id();
    lcc->setBusInterface(findBusInterface(id));
  } else if (lccIIDM.is_node()) {
    string voltageLevelId = lccIIDM.voltageLevel().id();
    int node = lccIIDM.node();
    lcc->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
  }
#ifdef LANG_CXX11
  return std::move(lcc);
#else
  return lcc;
#endif
}

shared_ptr<NetworkInterface>
DataInterfaceIIDM::getNetwork() const {
  return network_;
}

shared_ptr<BusInterface>
DataInterfaceIIDM::findBusInterface(const string& id) {
  map<string, shared_ptr<BusInterface> >::iterator iter = busComponents_.find(id);
  if (iter != busComponents_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownBus, id);
}

shared_ptr<VoltageLevelInterface>
DataInterfaceIIDM::findVoltageLevelInterface(const string& id) {
  map<string, shared_ptr<VoltageLevelInterface> >::iterator iter = voltageLevels_.find(id);
  if (iter != voltageLevels_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownVoltageLevel, id);
}

shared_ptr<BusInterface>
DataInterfaceIIDM::findCalculatedBusInterface(const string& voltageLevelId, const int& node) {
  map<string, vector<shared_ptr<CalculatedBusInterfaceIIDM> > >::iterator iter = calculatedBusComponents_.find(voltageLevelId);
  if (iter == calculatedBusComponents_.end())
    throw DYNError(Error::MODELER, UnknownCalculatedBus, voltageLevelId);

  vector<shared_ptr<CalculatedBusInterfaceIIDM> > buses = iter->second;
  for (unsigned int i = 0; i < buses.size(); ++i) {
    if (buses[i]->hasNode(node))
      return buses[i];
  }
  throw DYNError(Error::MODELER, UnknownCalculatedBus, voltageLevelId, node);
}

shared_ptr<ComponentInterface>&
DataInterfaceIIDM::findComponent(const std::string& id) {
  map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.find(id);
  if (iter != components_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownStaticComponent, id);
}

void
DataInterfaceIIDM::hasDynamicModel(const string& id) {
  findComponent(id)->hasDynamicModel(true);
}

void
DataInterfaceIIDM::setReference(const string& componentVar, const string& staticId, const string& modelId, const string& modelVar) {
  if (staticId == "")
    throw DYNError(Error::MODELER, WrongReferenceId, staticId);

  findComponent(staticId)->setReference(componentVar, modelId, modelVar);
}

void
DataInterfaceIIDM::setDynamicModel(const string& componentId, const shared_ptr<SubModel>& model) {
  findComponent(componentId)->setModelDyn(model);
}

void
DataInterfaceIIDM::setModelNetwork(const shared_ptr<SubModel>& model) {
  map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin();
  for (; iter != components_.end(); ++iter) {
    (iter->second)->setModelDyn(model);
  }
}

void
DataInterfaceIIDM::mapConnections() {
  const vector<shared_ptr<LineInterface> >& lines = network_->getLines();
  vector<shared_ptr<LineInterface> >::const_iterator iLine;
  for (iLine = lines.begin(); iLine != lines.end(); ++iLine) {
    if ((*iLine)->hasDynamicModel()) {
      (*iLine)->getBusInterface1()->hasConnection(true);
      (*iLine)->getBusInterface2()->hasConnection(true);
    }
  }

  const vector<shared_ptr<TwoWTransformerInterface> >& twoWtfos = network_->getTwoWTransformers();
  vector<shared_ptr<TwoWTransformerInterface> >::const_iterator i2WTfo;
  for (i2WTfo = twoWtfos.begin(); i2WTfo != twoWtfos.end(); ++i2WTfo) {
    if ((*i2WTfo)->hasDynamicModel()) {
      (*i2WTfo)->getBusInterface1()->hasConnection(true);
      (*i2WTfo)->getBusInterface2()->hasConnection(true);
    }
  }


  const vector<shared_ptr<ThreeWTransformerInterface> >& threeWtfos = network_->getThreeWTransformers();
  vector<shared_ptr<ThreeWTransformerInterface> >::const_iterator i3WTfo;
  for (i3WTfo = threeWtfos.begin(); i3WTfo != threeWtfos.end(); ++i3WTfo) {
    if ((*i3WTfo)->hasDynamicModel()) {
      (*i3WTfo)->getBusInterface1()->hasConnection(true);
      (*i3WTfo)->getBusInterface2()->hasConnection(true);
      (*i3WTfo)->getBusInterface3()->hasConnection(true);
    }
  }

  const vector< shared_ptr<VoltageLevelInterface> > voltageLevels = network_->getVoltageLevels();
  vector<shared_ptr<VoltageLevelInterface> >::const_iterator iVL;
  for (iVL = voltageLevels.begin(); iVL != voltageLevels.end(); ++iVL) {
    (*iVL)->mapConnections();
  }
}

void
DataInterfaceIIDM::importStaticParameters() {
  map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin();
  for (; iter != components_.end(); ++iter) {
    (iter->second)->importStaticParameters();
  }
}

void
DataInterfaceIIDM::getStateVariableReference() {
  map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin();
  for (; iter != components_.end(); ++iter) {
    (iter->second)->getStateVariableReference();
  }
}

void
DataInterfaceIIDM::updateFromModel(bool filterForCriteriaCheck) {
  map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin();
  for (; iter != components_.end(); ++iter) {
    (iter->second)->updateFromModel(filterForCriteriaCheck);
  }
}

void
DataInterfaceIIDM::exportStateVariables() {
  const bool filterForCriteriaCheck = false;
  map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin();
  for (; iter != components_.end(); ++iter) {
    (iter->second)->updateFromModel(filterForCriteriaCheck);
    (iter->second)->exportStateVariables();
  }

  // loop to update switch state due to topology analysis
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  map<string, shared_ptr<VoltageLevelInterface> >::iterator iterVL = voltageLevels_.begin();
  for (; iterVL != voltageLevels_.end(); ++iterVL)
    (iterVL->second)->exportSwitchesState();
}

void
DataInterfaceIIDM::configureCriteria(const shared_ptr<CriteriaCollection>& criteria) {
  configureBusCriteria(criteria);
  configureLoadCriteria(criteria);
  configureGeneratorCriteria(criteria);
}


void
DataInterfaceIIDM::configureBusCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria) {
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteria->begin(CriteriaCollection::BUS),
      itEnd = criteria->end(CriteriaCollection::BUS);
      it != itEnd; ++it) {
    shared_ptr<criteria::Criteria> crit = *it;
    if (!BusCriteria::criteriaEligibleForBus(crit->getParams())) continue;
    shared_ptr<BusCriteria> dynCriteria = shared_ptr<BusCriteria>(new BusCriteria(crit->getParams()));
    if (crit->begin() != crit->end()) {
      for (criteria::Criteria::component_id_const_iterator cmpIt = crit->begin(),
          cmpItEnd = crit->end();
          cmpIt != cmpItEnd; ++cmpIt) {
        std::map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator busItfIter = components_.find(*cmpIt);
        if (busItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = busItfIter->second;
          if (cmp->getType() != ComponentInterface::BUS)
            Trace::warn() << DYNLog(WrongComponentType, *cmpIt, "bus") << Trace::endline;
          boost::shared_ptr<BusInterface> bus = dynamic_pointer_cast<BusInterface>(cmp);
          assert(bus);
          dynCriteria->addBus(bus);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, *cmpIt) << Trace::endline;
        }
      }
    } else {
      for (std::map<std::string, boost::shared_ptr<BusInterface> >::const_iterator cmpIt = busComponents_.begin(),
          cmpItEnd = busComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        dynCriteria->addBus(cmpIt->second);
      }
      for (std::map<std::string, std::vector<boost::shared_ptr<CalculatedBusInterfaceIIDM> > >::const_iterator cmpIt = calculatedBusComponents_.begin(),
          cmpItEnd = calculatedBusComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        const std::vector<boost::shared_ptr<CalculatedBusInterfaceIIDM> >& calBuses = cmpIt->second;
        for (size_t i = 0, iEnd = calBuses.size(); i < iEnd; ++i) {
          dynCriteria->addBus(calBuses[i]);
        }
      }
    }
    if (!dynCriteria->empty()) {
      criteria_.push_back(dynCriteria);
    }
  }
}

void
DataInterfaceIIDM::configureLoadCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria) {
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteria->begin(CriteriaCollection::LOAD),
      itEnd = criteria->end(CriteriaCollection::LOAD);
      it != itEnd; ++it) {
    shared_ptr<criteria::Criteria> crit = *it;
    if (!LoadCriteria::criteriaEligibleForLoad(crit->getParams())) continue;
    shared_ptr<LoadCriteria> dynCriteria = shared_ptr<LoadCriteria>(new LoadCriteria(crit->getParams()));
    if (crit->begin() != crit->end()) {
      for (criteria::Criteria::component_id_const_iterator cmpIt = crit->begin(),
          cmpItEnd = crit->end();
          cmpIt != cmpItEnd; ++cmpIt) {
        std::map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator loadItfIter = components_.find(*cmpIt);
        if (loadItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = loadItfIter->second;
          if (cmp->getType() != ComponentInterface::LOAD)
            Trace::warn() << DYNLog(WrongComponentType, *cmpIt, "load") << Trace::endline;
          boost::shared_ptr<LoadInterface> load = dynamic_pointer_cast<LoadInterface>(cmp);
          assert(load);
          dynCriteria->addLoad(load);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, *cmpIt) << Trace::endline;
        }
      }
    } else {
      for (std::map<std::string, boost::shared_ptr<LoadInterface> >::const_iterator cmpIt = loadComponents_.begin(),
          cmpItEnd = loadComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        dynCriteria->addLoad(cmpIt->second);
      }
    }
    if (!dynCriteria->empty()) {
      criteria_.push_back(dynCriteria);
    }
  }
}

void
DataInterfaceIIDM::configureGeneratorCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria) {
  for (CriteriaCollection::CriteriaCollectionConstIterator it = criteria->begin(CriteriaCollection::GENERATOR),
      itEnd = criteria->end(CriteriaCollection::GENERATOR);
      it != itEnd; ++it) {
    shared_ptr<criteria::Criteria> crit = *it;
    if (!GeneratorCriteria::criteriaEligibleForGenerator(crit->getParams())) continue;
    shared_ptr<GeneratorCriteria> dynCriteria = shared_ptr<GeneratorCriteria>(new GeneratorCriteria(crit->getParams()));
    if (crit->begin() != crit->end()) {
      for (criteria::Criteria::component_id_const_iterator cmpIt = crit->begin(),
          cmpItEnd = crit->end();
          cmpIt != cmpItEnd; ++cmpIt) {
        std::map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator generatorItfIter = components_.find(*cmpIt);
        if (generatorItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = generatorItfIter->second;
          if (cmp->getType() != ComponentInterface::GENERATOR)
            Trace::warn() << DYNLog(WrongComponentType, *cmpIt, "generator") << Trace::endline;
          boost::shared_ptr<GeneratorInterface> gen = dynamic_pointer_cast<GeneratorInterface>(cmp);
          assert(gen);
          dynCriteria->addGenerator(gen);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, *cmpIt) << Trace::endline;
        }
      }
    } else {
      for (std::map<std::string, boost::shared_ptr<GeneratorInterface> >::const_iterator cmpIt = generatorComponents_.begin(),
          cmpItEnd = generatorComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        dynCriteria->addGenerator(cmpIt->second);
      }
    }
    if (!dynCriteria->empty()) {
      criteria_.push_back(dynCriteria);
    }
  }
}

bool
DataInterfaceIIDM::checkCriteria(double t, bool finalStep) {
  Timer timer("DataInterfaceIIDM::checkCriteria");
#ifdef _DEBUG_
  for (map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(); iter != components_.end(); ++iter) {
    iter->second->enableCheckStateVariable();
  }
#endif
  bool criteriaOk = true;
  for (std::vector<boost::shared_ptr<Criteria> >::const_iterator it = criteria_.begin(), itEnd = criteria_.end();
      it != itEnd; ++it) {
    criteriaOk &= (*it)->checkCriteria(t, finalStep);
  }
#ifdef _DEBUG_
  for (map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(); iter != components_.end(); ++iter) {
    iter->second->disableCheckStateVariable();
  }
#endif
  return criteriaOk;
}

void
DataInterfaceIIDM::getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const {
  for (std::vector<boost::shared_ptr<Criteria> >::const_iterator it = criteria_.begin(), itEnd = criteria_.end();
      it != itEnd; ++it) {
    const std::vector<std::pair<double, std::string> >& ids = (*it)->getFailingCriteria();
    failingCriteria.insert(failingCriteria.end(), ids.begin(), ids.end());
  }
}

double
DataInterfaceIIDM::getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName) {
  return findComponent(staticID)->getStaticParameterValue<double>(refOrigName);
}

int
DataInterfaceIIDM::getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName) {
  return findComponent(staticID)->getStaticParameterValue<int>(refOrigName);
}

bool
DataInterfaceIIDM::getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName) {
  return findComponent(staticID)->getStaticParameterValue<bool>(refOrigName);
}



}  // namespace DYN
