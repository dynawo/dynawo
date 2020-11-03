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
#include "DYNDataInterfaceIIDM.h"

#include "DYNBusInterfaceIIDM.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNTwoWTransformerInterfaceIIDM.h"
#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
// #include "DYNStaticVarCompensatorInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNPhaseTapChangerInterfaceIIDM.h"
#include "DYNRatioTapChangerInterfaceIIDM.h"
#include "DYNCurrentLimitInterfaceIIDM.h"
#include "DYNVoltageLevelInterfaceIIDM.h"
#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNMacrosMessage.h"
#include "DYNSubModel.h"
#include "DYNTimer.h"
#include "DYNExecUtils.h"
#include "DYNTrace.h"
#include "DYNErrorQueue.h"
#include "DYNCriteria.h"
#include "CRTCriteria.h"
#include "CRTCriteriaParams.h"

#include <powsybl/iidm/converter/ImportOptions.hpp>
#include <powsybl/iidm/converter/FakeAnonymizer.hpp>
#include <powsybl/iidm/Substation.hpp>

using std::map;
using std::string;
using std::vector;
using std::stringstream;
using std::fstream;

using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using criteria::CriteriaCollection;

namespace DYN {
DataInterfaceIIDM::DataInterfaceIIDM(powsybl::iidm::Network& networkIIDM) :
networkIIDM_(networkIIDM) {
}

DataInterfaceIIDM::~DataInterfaceIIDM() {
}


boost::shared_ptr<DataInterface>
DataInterfaceIIDM::build(std::string iidmFilePath) {
  boost::shared_ptr<DataInterfaceIIDM>  data;
  try {
    std::ifstream inputStream(iidmFilePath);
    stdcxx::Properties properties;
    properties.set(powsybl::iidm::converter::ImportOptions::THROW_EXCEPTION_IF_EXTENSION_NOT_FOUND, "true");
    powsybl::iidm::converter::ImportOptions options(properties);

    powsybl::iidm::converter::FakeAnonymizer anonymizer;
    powsybl::iidm::Network networkIIDM = powsybl::iidm::Network::readXml(inputStream, options, anonymizer);
//    parser.register_extension<IIDM::extensions::standbyautomaton::xml::StandbyAutomatonHandler>();
//    parser.register_extension<IIDM::extensions::activeseason::xml::ActiveSeasonHandler>();
//    parser.register_extension<IIDM::extensions::currentlimitsperseason::xml::CurrentLimitsPerSeasonHandler>();
//    parser.register_extension<IIDM::extensions::generatoractivepowercontrol::xml::GeneratorActivePowerControlHandler>();
//    parser.register_extension<IIDM::extensions::busbarsection_position::xml::BusbarSectionPositionHandler>();  // useless for simulation
//    parser.register_extension<IIDM::extensions::connectable_position::xml::ConnectablePositionHandler>();
//    parser.register_extension<IIDM::extensions::hvdcangledroopactivepowercontrol::xml::HvdcAngleDroopActivePowerControlHandler>();
//    parser.register_extension<IIDM::extensions::hvdcoperatoractivepowerrange::xml::HvdcOperatorActivePowerRangeHandler>();
//    parser.register_extension<IIDM::extensions::generator_entsoe_category::xml::GeneratorEntsoeCategoryHandler>();
//    parser.register_extension<IIDM::extensions::generator_startup::xml::GeneratorStartupHandler>();
//    parser.register_extension<IIDM::extensions::load_detail::xml::LoadDetailHandler>();

//    bool xsdValidation = false;
//    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") == "true")
//      xsdValidation = true;

    data.reset(new DataInterfaceIIDM(networkIIDM));
    data->initFromIIDM();
  } catch (const powsybl::PowsyblException& exp) {
    throw DYNError(Error::GENERAL, XmlFileParsingError, iidmFilePath, exp.what());
  }
  return data;
}


void
DataInterfaceIIDM::dumpToFile(const std::string& iidmFilePath) const {
//  IIDM::xml::xml_formatter formatter;
//  formatter.register_extension(
//      &IIDM::extensions::busbarsection_position::xml::exportBusbarSectionPosition,
//      IIDM::extensions::busbarsection_position::xml::BusbarSectionPositionHandler::uri(),
//      "bbsp");
//
//  formatter.register_extension(
//      &IIDM::extensions::connectable_position::xml::exportConnectablePosition,
//      IIDM::extensions::connectable_position::xml::ConnectablePositionHandler::uri(),
//      "cp");
//
//  formatter.register_extension(
//      &IIDM::extensions::generatoractivepowercontrol::xml::exportGeneratorActivePowerControl,
//      IIDM::extensions::generatoractivepowercontrol::xml::GeneratorActivePowerControlHandler::uri(),
//      "gapc");
//
//  formatter.register_extension(
//      &IIDM::extensions::standbyautomaton::xml::exportStandbyAutomaton,
//      IIDM::extensions::standbyautomaton::xml::StandbyAutomatonHandler::uri(),
//      "sa");
//
//  formatter.register_extension(
//      &IIDM::extensions::hvdcoperatoractivepowerrange::xml::exportHvdcOperatorActivePowerRange,
//      IIDM::extensions::hvdcoperatoractivepowerrange::xml::HvdcOperatorActivePowerRangeHandler::uri(),
//      "hopr");
//
//  formatter.register_extension(
//      &IIDM::extensions::hvdcangledroopactivepowercontrol::xml::exportHvdcAngleDroopActivePowerControl,
//      IIDM::extensions::hvdcangledroopactivepowercontrol::xml::HvdcAngleDroopActivePowerControlHandler::uri(),
//      "hapc");
//
//  formatter.register_extension(
//      &IIDM::extensions::activeseason::xml::exportActiveSeason,
//      IIDM::extensions::activeseason::xml::ActiveSeasonHandler::uri(),
//      "as");
//
//  formatter.register_extension(
//      &IIDM::extensions::currentlimitsperseason::xml::exportCurrentLimitsPerSeason,
//      IIDM::extensions::currentlimitsperseason::xml::CurrentLimitsPerSeasonHandler::uri(),
//      "clps");
//
//  formatter.register_extension(
//      &IIDM::extensions::generator_entsoe_category::xml::exportGeneratorEntsoeCategory,
//      IIDM::extensions::generator_entsoe_category::xml::GeneratorEntsoeCategoryHandler::uri(),
//      "gec");
//
//  formatter.register_extension(
//      &IIDM::extensions::generator_startup::xml::exportGeneratorStartup,
//      IIDM::extensions::generator_startup::xml::GeneratorStartupHandler::uri(),
//      "gs");
//
//  formatter.register_extension(
//      &IIDM::extensions::load_detail::xml::exportLoadDetail,
//      IIDM::extensions::load_detail::xml::LoadDetailHandler::uri(),
//      "ld");
//
//  fstream file(iidmFilePath.c_str(), fstream::out);
//  formatter.to_xml(networkIIDM_, file);
}

powsybl::iidm::Network&
DataInterfaceIIDM::getNetworkIIDM() {
  return networkIIDM_;
}

std::string
DataInterfaceIIDM::getBusName(const std::string& componentName, const std::string& labelNode) {
  boost::unordered_map<string, shared_ptr<ComponentInterface> >::const_iterator iter = components_.find(componentName);
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
      case ComponentInterface::HVDC_LINE: {
        shared_ptr<HvdcLineInterface> hvdc = dynamic_pointer_cast<HvdcLineInterface>(component);
        if (labelNode == "@NODE1@") {
          shared_ptr<ConverterInterface> conv1 = hvdc->getConverter1();
          busName = conv1->getBusInterface()->getID();
        }
        if (labelNode == "@NODE2@") {
          shared_ptr<ConverterInterface> conv2 = hvdc->getConverter2();
          busName = conv2->getBusInterface()->getID();
        }
        break;
      }
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

  for (auto& substation : networkIIDM_.getSubstations()) {
    for (auto& voltageLevel : substation.getVoltageLevels()) {
      shared_ptr<VoltageLevelInterface> vl = importVoltageLevel(voltageLevel, substation.getCountry());
      network_->addVoltageLevel(vl);
      voltageLevels_[vl->getID()] = vl;
    }
  }

  //===========================
  //  ADD 2WTFO INTERFACE
  //===========================
  for (auto& twoWindingTransfoIIDM : networkIIDM_.getTwoWindingsTransformers()) {
    if (!twoWindingTransfoIIDM.getTerminal1().isConnected() && !twoWindingTransfoIIDM.getTerminal2().isConnected()) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, twoWindingTransfoIIDM.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<TwoWTransformerInterface> tfo = importTwoWindingsTransformer(twoWindingTransfoIIDM);
    network_->addTwoWTransformer(tfo);
    components_[tfo->getID()] = tfo;
  }

  //===========================
  //  ADD 3WTFO INTERFACE
  //===========================
  for (auto& threeWindingTransfoIIDM : networkIIDM_.getThreeWindingsTransformers()) {
    if (!threeWindingTransfoIIDM.getLeg1().getTerminal().get().isConnected() &&
        !threeWindingTransfoIIDM.getLeg2().getTerminal().get().isConnected() &&
        !threeWindingTransfoIIDM.getLeg3().getTerminal().get().isConnected()) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, threeWindingTransfoIIDM.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<ThreeWTransformerInterface> tfo = importThreeWindingsTransformer(threeWindingTransfoIIDM);
    network_->addThreeWTransformer(tfo);
    components_[tfo->getID()] = tfo;
  }


  //===========================
  //  ADD LINE INTERFACE
  //===========================
  for (auto& lineIIDM : networkIIDM_.getLines()) {
    if ( !lineIIDM.getTerminal1().isConnected() && !lineIIDM.getTerminal2().isConnected() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, lineIIDM.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<LineInterface> line = importLine(lineIIDM);
    network_->addLine(line);
    components_[line->getID()] = line;
  }

  //===========================
  //  ADD HVDC LINE INTERFACE
  //===========================
  for (auto& hvdcLineIIDM : networkIIDM_.getHvdcLines()) {
    shared_ptr<HvdcLineInterface> hvdc = importHvdcLine(hvdcLineIIDM);
    network_->addHvdcLine(hvdc);
    components_[hvdc->getID()] = hvdc;
  }
  DYNErrorQueue::get()->flush();
}

shared_ptr<VoltageLevelInterface>
DataInterfaceIIDM::importVoltageLevel(powsybl::iidm::VoltageLevel& voltageLevelIIDM, const stdcxx::optional<powsybl::iidm::Country>& country) {
  shared_ptr<VoltageLevelInterfaceIIDM> voltageLevel(new VoltageLevelInterfaceIIDM(voltageLevelIIDM));
  const auto& view = voltageLevelIIDM.getBusBreakerView();
  string countryStr;
  if (country)
    countryStr = powsybl::iidm::getCountryName(country.get());
  voltageLevel->setCountry(countryStr);
  //===========================
  //  ADD BUS INTERFACE
  //===========================
  for (auto& busIIDM : voltageLevelIIDM.getBusBreakerView().getBuses()) {
    shared_ptr<BusInterfaceIIDM> bus(new BusInterfaceIIDM(busIIDM));
    if (country)
      bus->setCountry(countryStr);
    voltageLevel->addBus(bus);
    components_[bus->getID()] = bus;
    busComponents_[bus->getID()] = bus;
  }

  //===========================
  //  ADD SWITCH INTERFACE
  //===========================
  if (voltageLevelIIDM.getTopologyKind() == powsybl::iidm::TopologyKind::BUS_BREAKER) {
    for (auto& switchIIDM : voltageLevelIIDM.getSwitches()) {
      shared_ptr<SwitchInterface> sw = importSwitch(switchIIDM,
          findBusInterface(view.getBus1(switchIIDM.getId()).get().getId()),
          findBusInterface(view.getBus2(switchIIDM.getId()).get().getId()));
      components_[sw->getID()] = sw;
      voltageLevel->addSwitch(sw);
    }
  }

  //===========================
  //  ADD LOAD INTERFACE
  //===========================
  for (auto& loadIIDM : voltageLevelIIDM.getLoads()) {
    if (!loadIIDM.getTerminal().isConnected()) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, loadIIDM.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<LoadInterface> load = importLoad(loadIIDM, countryStr);
    voltageLevel->addLoad(load);
    components_[load->getID()] = load;
    loadComponents_[load->getID()] = load;
    load->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD VSC CONVERTER INTERFACE
  //==========================================
  for (auto& vscConverterIIDM : voltageLevelIIDM.getVscConverterStations()) {
    if ( !vscConverterIIDM.getTerminal().isConnected() ) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, vscConverterIIDM.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<VscConverterInterface> vsc = importVscConverter(vscConverterIIDM);
    voltageLevel->addVscConverter(vsc);
    components_[vsc->getID()] = vsc;
    vsc->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD LCC CONVERTER INTERFACE
  //==========================================
  for (auto& lccConverterIIDM : voltageLevelIIDM.getLccConverterStations()) {
    if (!lccConverterIIDM.getTerminal().isConnected()) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, lccConverterIIDM.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<LccConverterInterface> lcc = importLccConverter(lccConverterIIDM);
    voltageLevel->addLccConverter(lcc);
    components_[lcc->getID()] = lcc;
    lcc->setVoltageLevelInterface(voltageLevel);
  }
  //===========================
  //  ADD GENERATOR INTERFACE
  //===========================
  for (auto& genIIDM : voltageLevelIIDM.getGenerators()) {
    if (!genIIDM.getTerminal().isConnected()) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, genIIDM.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<GeneratorInterface> generator = importGenerator(genIIDM, countryStr);
    voltageLevel->addGenerator(generator);
    components_[generator->getID()] = generator;
    generatorComponents_[generator->getID()] = generator;
    generator->setVoltageLevelInterface(voltageLevel);
  }
  // =======================================
  //    ADD SHUNTCOMPENSATORS INTERFACE
  // =======================================
  for (auto& shuntCompensators : voltageLevelIIDM.getShuntCompensators()) {
    if (!shuntCompensators.getTerminal().isConnected()) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, shuntCompensators.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<ShuntCompensatorInterface> shunt = importShuntCompensator(shuntCompensators);
    voltageLevel->addShuntCompensator(shunt);
    components_[shunt->getID()] = shunt;
    shunt->setVoltageLevelInterface(voltageLevel);
  }

  //==============================
  //  ADD DANGLINGLINE INTERFACE
  //==============================
  for (auto& danglingLine : voltageLevelIIDM.getDanglingLines()) {
    if (!danglingLine.getTerminal().isConnected()) {
      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, danglingLine.getId()) << Trace::endline;
      continue;
    }
    shared_ptr<DanglingLineInterface> line = importDanglingLine(danglingLine);
    voltageLevel->addDanglingLine(line);
    components_[line->getID()] = line;
    line->setVoltageLevelInterface(voltageLevel);
  }

//  //==========================================
//  //  ADD STATICVARCOMPENSATOR INTERFACE
//  //==========================================
//  IIDM::Contains<IIDM::StaticVarCompensator>::iterator itSVC = voltageLevelIIDM.staticVarCompensators().begin();
//  for (; itSVC != voltageLevelIIDM.staticVarCompensators().end(); ++itSVC) {
//    if ( !(*itSVC).has_connection() ) {
//      Trace::debug(Trace::modeler()) << DYNLog(NoNetworkConnection, (*itSVC).id()) << Trace::endline;
//      continue;
//    }
//    shared_ptr<StaticVarCompensatorInterface> svc = importStaticVarCompensator(*itSVC);
//    voltageLevel->addStaticVarCompensator(svc);
//    components_[svc->getID()] = svc;
//    svc->setVoltageLevelInterface(voltageLevel);
//  }

  return voltageLevel;
}

shared_ptr<SwitchInterface>
DataInterfaceIIDM::importSwitch(powsybl::iidm::Switch& switchIIDM, const shared_ptr<BusInterface>& bus1
    , const shared_ptr<BusInterface>& bus2) {
  shared_ptr<SwitchInterfaceIIDM> sw(new SwitchInterfaceIIDM(switchIIDM));
  sw->setBusInterface1(bus1);
  sw->setBusInterface2(bus2);
  return sw;
}

shared_ptr<GeneratorInterface>
DataInterfaceIIDM::importGenerator(powsybl::iidm::Generator & generatorIIDM, const std::string& country) {
  shared_ptr<GeneratorInterfaceIIDM> generator(new GeneratorInterfaceIIDM(generatorIIDM));
  generator->setCountry(country);
  generator->setBusInterface(findBusInterface(generatorIIDM.getTerminal().getBusBreakerView().getBus().get().getId()));
  return generator;
}

shared_ptr<LoadInterface>
DataInterfaceIIDM::importLoad(powsybl::iidm::Load& loadIIDM, const std::string& country) {
  shared_ptr<LoadInterfaceIIDM> load(new LoadInterfaceIIDM(loadIIDM));
  load->setCountry(country);
  load->setBusInterface(findBusInterface(loadIIDM.getTerminal().getBusBreakerView().getBus().get().getId()));
  return load;
}

shared_ptr<ShuntCompensatorInterface>
DataInterfaceIIDM::importShuntCompensator(powsybl::iidm::ShuntCompensator& shuntIIDM) {
  shared_ptr<ShuntCompensatorInterfaceIIDM> shunt(new ShuntCompensatorInterfaceIIDM(shuntIIDM));
  shunt->setBusInterface(findBusInterface(shuntIIDM.getTerminal().getBusBreakerView().getBus().get().getId()));
  return shunt;
}

shared_ptr<DanglingLineInterface>
DataInterfaceIIDM::importDanglingLine(powsybl::iidm::DanglingLine& danglingLineIIDM) {
  shared_ptr<DanglingLineInterfaceIIDM> danglingLine(new DanglingLineInterfaceIIDM(danglingLineIIDM));
  danglingLine->setBusInterface(findBusInterface(danglingLineIIDM.getTerminal().getBusBreakerView().getBus().get().getId()));

  if (danglingLineIIDM.getCurrentLimits()) {
    powsybl::iidm::CurrentLimits& currentLimits = danglingLineIIDM.getCurrentLimits();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), boost::none));
      danglingLine->addCurrentLimitInterface(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        danglingLine->addCurrentLimitInterface(cLimit);
      }
    }
  }
  return danglingLine;
}

shared_ptr<StaticVarCompensatorInterface>
DataInterfaceIIDM::importStaticVarCompensator(powsybl::iidm::StaticVarCompensator& svcIIDM) {
//  shared_ptr<StaticVarCompensatorInterfaceIIDM> svc(new StaticVarCompensatorInterfaceIIDM(svcIIDM));
//
//  // reference to bus interface
//  if (svcIIDM.is_bus()) {
//    string id = svcIIDM.bus_id();
//    svc->setBusInterface(findBusInterface(id));
//  } else if (svcIIDM.is_node()) {
//    string voltageLevelId = svcIIDM.voltageLevel().id();
//    int node = svcIIDM.node();
//    svc->setBusInterface(findCalculatedBusInterface(voltageLevelId, node));
//  }
//  return svc;
  return nullptr;
}

shared_ptr<TwoWTransformerInterface>
DataInterfaceIIDM::importTwoWindingsTransformer(powsybl::iidm::TwoWindingsTransformer & twoWTfoIIDM) {
  shared_ptr<TwoWTransformerInterfaceIIDM> twoWTfo(new TwoWTransformerInterfaceIIDM(twoWTfoIIDM));

  // add phase tapChanger and steps if exists
  if (twoWTfoIIDM.hasPhaseTapChanger()) {
    auto& phaseTapChanger = twoWTfoIIDM.getPhaseTapChanger();
    shared_ptr<PhaseTapChangerInterfaceIIDM> tapChanger(new PhaseTapChangerInterfaceIIDM(twoWTfoIIDM.getPhaseTapChanger()));
    twoWTfo->setPhaseTapChanger(tapChanger);
  }
  // add ratio tapChanger and steps if exists
  if (twoWTfoIIDM.hasRatioTapChanger()) {
    string side;
    if (twoWTfoIIDM.getRatioTapChanger().isRegulating()) {
      if (stdcxx::areSame(twoWTfoIIDM.getTerminal1(), twoWTfoIIDM.getRatioTapChanger().getRegulationTerminal().get()))
        side = "ONE";
      else if (stdcxx::areSame(twoWTfoIIDM.getTerminal2(), twoWTfoIIDM.getRatioTapChanger().getRegulationTerminal().get()))
        side = "TWO";
    }
    shared_ptr<RatioTapChangerInterfaceIIDM> tapChanger(new RatioTapChangerInterfaceIIDM(twoWTfoIIDM.getRatioTapChanger(), side));
    twoWTfo->setRatioTapChanger(tapChanger);
  }

  if (twoWTfoIIDM.getTerminal1().isConnected()) {
    twoWTfo->setBusInterface1(findBusInterface(twoWTfoIIDM.getTerminal1().getBusBreakerView().getBus().get().getId()));
    twoWTfo->setVoltageLevelInterface1(findVoltageLevelInterface(twoWTfoIIDM.getTerminal1().getVoltageLevel().getId()));
  }

  if (twoWTfoIIDM.getTerminal2().isConnected()) {
    twoWTfo->setBusInterface2(findBusInterface(twoWTfoIIDM.getTerminal2().getBusBreakerView().getBus().get().getId()));
    twoWTfo->setVoltageLevelInterface2(findVoltageLevelInterface(twoWTfoIIDM.getTerminal2().getVoltageLevel().getId()));
  }

  if (twoWTfoIIDM.getCurrentLimits1()) {
    powsybl::iidm::CurrentLimits& currentLimits = twoWTfoIIDM.getCurrentLimits1();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), boost::none));
      twoWTfo->addCurrentLimitInterface1(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        twoWTfo->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (twoWTfoIIDM.getCurrentLimits2()) {
    powsybl::iidm::CurrentLimits& currentLimits = twoWTfoIIDM.getCurrentLimits2();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), boost::none));
      twoWTfo->addCurrentLimitInterface2(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        twoWTfo->addCurrentLimitInterface2(cLimit);
      }
    }
  }
  return twoWTfo;
}

shared_ptr<ThreeWTransformerInterface>
DataInterfaceIIDM::importThreeWindingsTransformer(powsybl::iidm::ThreeWindingsTransformer & threeWTfoIIDM) {
  shared_ptr<ThreeWTransformerInterfaceIIDM> threeWTfo(new ThreeWTransformerInterfaceIIDM(threeWTfoIIDM));

  if (threeWTfoIIDM.getLeg1().getTerminal().get().isConnected()) {
    threeWTfo->setBusInterface1(findBusInterface(threeWTfoIIDM.getLeg1().getTerminal().get().getBusBreakerView().getBus().get().getId()));
    threeWTfo->setVoltageLevelInterface1(findVoltageLevelInterface(threeWTfoIIDM.getLeg1().getTerminal().get().getVoltageLevel().getId()));
  }

  if (threeWTfoIIDM.getLeg2().getTerminal().get().isConnected()) {
    threeWTfo->setBusInterface2(findBusInterface(threeWTfoIIDM.getLeg2().getTerminal().get().getBusBreakerView().getBus().get().getId()));
    threeWTfo->setVoltageLevelInterface2(findVoltageLevelInterface(threeWTfoIIDM.getLeg2().getTerminal().get().getVoltageLevel().getId()));
  }

  if (threeWTfoIIDM.getLeg3().getTerminal().get().isConnected()) {
    threeWTfo->setBusInterface3(findBusInterface(threeWTfoIIDM.getLeg3().getTerminal().get().getBusBreakerView().getBus().get().getId()));
    threeWTfo->setVoltageLevelInterface3(findVoltageLevelInterface(threeWTfoIIDM.getLeg3().getTerminal().get().getVoltageLevel().getId()));
  }

  if (threeWTfoIIDM.getLeg1().getCurrentLimits()) {
    powsybl::iidm::CurrentLimits& currentLimits = threeWTfoIIDM.getLeg1().getCurrentLimits();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), boost::none));
      threeWTfo->addCurrentLimitInterface1(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        threeWTfo->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (threeWTfoIIDM.getLeg2().getCurrentLimits()) {
    powsybl::iidm::CurrentLimits& currentLimits = threeWTfoIIDM.getLeg1().getCurrentLimits();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), boost::none));
      threeWTfo->addCurrentLimitInterface2(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        threeWTfo->addCurrentLimitInterface2(cLimit);
      }
    }
  }

  if (threeWTfoIIDM.getLeg3().getCurrentLimits()) {
    powsybl::iidm::CurrentLimits& currentLimits = threeWTfoIIDM.getLeg3().getCurrentLimits();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), boost::none));
      threeWTfo->addCurrentLimitInterface3(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        threeWTfo->addCurrentLimitInterface3(cLimit);
      }
    }
  }
  return threeWTfo;
}

shared_ptr<LineInterface>
DataInterfaceIIDM::importLine(powsybl::iidm::Line& lineIIDM) {
  shared_ptr<LineInterfaceIIDM> line(new LineInterfaceIIDM(lineIIDM));
  line->setBusInterface1(findBusInterface(lineIIDM.getTerminal1().getBusBreakerView().getBus().get().getId()));
  line->setBusInterface2(findBusInterface(lineIIDM.getTerminal2().getBusBreakerView().getBus().get().getId()));

  // permanent limit on side 1
  if (lineIIDM.getCurrentLimits1()) {
    powsybl::iidm::CurrentLimits& currentLimits1 = lineIIDM.getCurrentLimits1().get();
    if (!std::isnan(currentLimits1.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits1.getPermanentLimit(), boost::none));
      line->addCurrentLimitInterface1(cLimit);
    }
    // temporary limit on side 1
    for (auto& currentLimit : currentLimits1.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        line->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (lineIIDM.getCurrentLimits2()) {
    // permanent limit on side 2
    powsybl::iidm::CurrentLimits& currentLimits2 = lineIIDM.getCurrentLimits2().get();
    if (!std::isnan(currentLimits2.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits2.getPermanentLimit(), boost::none));
      line->addCurrentLimitInterface1(cLimit);
    }
    // temporary limit on side 12
    for (auto& currentLimit : currentLimits2.getTemporaryLimits()) {
      if (!currentLimit.get().isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.get().getValue(), currentLimit.get().getAcceptableDuration()));
        line->addCurrentLimitInterface1(cLimit);
      }
    }
  }
  return line;
}

shared_ptr<VscConverterInterface>
DataInterfaceIIDM::importVscConverter(powsybl::iidm::VscConverterStation& vscIIDM) {
  shared_ptr<VscConverterInterfaceIIDM> vsc(new VscConverterInterfaceIIDM(vscIIDM));
  vsc->setBusInterface(findBusInterface(vscIIDM.getTerminal().getBusBreakerView().getBus().get().getId()));
  return vsc;
}

shared_ptr<LccConverterInterface>
DataInterfaceIIDM::importLccConverter(powsybl::iidm::LccConverterStation& lccIIDM) {
  shared_ptr<LccConverterInterfaceIIDM> lcc(new LccConverterInterfaceIIDM(lccIIDM));
  lcc->setBusInterface(findBusInterface(lccIIDM.getTerminal().getBusBreakerView().getBus().get().getId()));
  return lcc;
}

shared_ptr<HvdcLineInterface>
DataInterfaceIIDM::importHvdcLine(powsybl::iidm::HvdcLine& hvdcLineIIDM) {
  shared_ptr<ConverterInterface> conv1 = dynamic_pointer_cast<ConverterInterface>(findComponent(hvdcLineIIDM.getConverterStation1().get().getId()));
  shared_ptr<ConverterInterface> conv2 = dynamic_pointer_cast<ConverterInterface>(findComponent(hvdcLineIIDM.getConverterStation2().get().getId()));

  shared_ptr<HvdcLineInterfaceIIDM> hvdcLine(new HvdcLineInterfaceIIDM(hvdcLineIIDM, conv1, conv2));
  return hvdcLine;
}


shared_ptr<NetworkInterface>
DataInterfaceIIDM::getNetwork() const {
  return network_;
}

shared_ptr<BusInterface>
DataInterfaceIIDM::findBusInterface(const string& id) const {
  boost::unordered_map<std::string, boost::shared_ptr<BusInterface> >::const_iterator iter = busComponents_.find(id);
  if (iter != busComponents_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownBus, id);
}

shared_ptr<VoltageLevelInterface>
DataInterfaceIIDM::findVoltageLevelInterface(const string& id) const {
  boost::unordered_map<string, shared_ptr<VoltageLevelInterface> >::const_iterator iter = voltageLevels_.find(id);
  if (iter != voltageLevels_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownVoltageLevel, id);
}

shared_ptr<ComponentInterface>&
DataInterfaceIIDM::findComponent(const std::string& id) {
  boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.find(id);
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
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(), iterEnd = components_.end();
      iter != iterEnd; ++iter) {
    (iter->second)->setModelDyn(model);
  }
}

void
DataInterfaceIIDM::mapConnections() {
  const vector<shared_ptr<LineInterface> >& lines = network_->getLines();
  for (vector<shared_ptr<LineInterface> >::const_iterator iLine = lines.begin(); iLine != lines.end(); ++iLine) {
    if ((*iLine)->hasDynamicModel()) {
      (*iLine)->getBusInterface1()->hasConnection(true);
      (*iLine)->getBusInterface2()->hasConnection(true);
    }
  }

  const vector<shared_ptr<TwoWTransformerInterface> >& twoWtfos = network_->getTwoWTransformers();
  for (vector<shared_ptr<TwoWTransformerInterface> >::const_iterator i2WTfo = twoWtfos.begin(); i2WTfo != twoWtfos.end(); ++i2WTfo) {
    if ((*i2WTfo)->hasDynamicModel()) {
      (*i2WTfo)->getBusInterface1()->hasConnection(true);
      (*i2WTfo)->getBusInterface2()->hasConnection(true);
    }
  }

  const vector<shared_ptr<ThreeWTransformerInterface> >& threeWtfos = network_->getThreeWTransformers();
  for (vector<shared_ptr<ThreeWTransformerInterface> >::const_iterator i3WTfo = threeWtfos.begin(); i3WTfo != threeWtfos.end(); ++i3WTfo) {
    if ((*i3WTfo)->hasDynamicModel()) {
      (*i3WTfo)->getBusInterface1()->hasConnection(true);
      (*i3WTfo)->getBusInterface2()->hasConnection(true);
      (*i3WTfo)->getBusInterface3()->hasConnection(true);
    }
  }

  const vector<shared_ptr<HvdcLineInterface> >& hvdcs = network_->getHvdcLines();
  for (vector<shared_ptr<HvdcLineInterface> >::const_iterator iHvdc = hvdcs.begin(); iHvdc != hvdcs.end(); ++iHvdc) {
    if ((*iHvdc)->hasDynamicModel()) {
      (*iHvdc)->getConverter1()->getBusInterface()->hasConnection(true);
      (*iHvdc)->getConverter2()->getBusInterface()->hasConnection(true);
    }
  }

  const vector< shared_ptr<VoltageLevelInterface> > voltageLevels = network_->getVoltageLevels();
  for (vector<shared_ptr<VoltageLevelInterface> >::const_iterator iVL = voltageLevels.begin(); iVL != voltageLevels.end(); ++iVL) {
    (*iVL)->mapConnections();
  }
}

void
DataInterfaceIIDM::importStaticParameters() {
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(), iterEnd = components_.end();
      iter != iterEnd; ++iter) {
    (iter->second)->importStaticParameters();
  }
}

void
DataInterfaceIIDM::getStateVariableReference() {
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(), iterEnd = components_.end();
      iter != iterEnd; ++iter) {
    (iter->second)->getStateVariableReference();
  }
}

void
DataInterfaceIIDM::updateFromModel(bool filterForCriteriaCheck) {
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(), iterEnd = components_.end();
      iter != iterEnd; ++iter) {
    (iter->second)->updateFromModel(filterForCriteriaCheck);
  }
}

void
DataInterfaceIIDM::exportStateVariables() {
  const bool filterForCriteriaCheck = false;
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(), iterEnd = components_.end();
      iter != iterEnd; ++iter) {
    (iter->second)->updateFromModel(filterForCriteriaCheck);
    (iter->second)->exportStateVariables();
  }

  // loop to update switch state due to topology analysis
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  for (boost::unordered_map<string, shared_ptr<VoltageLevelInterface> >::iterator iterVL = voltageLevels_.begin(),
      iterVLEnd = voltageLevels_.end(); iterVL != iterVLEnd; ++iterVL)
    (iterVL->second)->exportSwitchesState();
}

#ifdef _DEBUG_
void
DataInterfaceIIDM::exportStateVariablesNoReadFromModel() {
  const bool filterForCriteriaCheck = false;
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(), iterEnd = components_.end();
      iter != iterEnd; ++iter) {
    (iter->second)->exportStateVariables();
  }

  // loop to update switch state due to topology analysis
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  for (boost::unordered_map<string, shared_ptr<VoltageLevelInterface> >::iterator iterVL = voltageLevels_.begin(),
      iterVLEnd = voltageLevels_.end(); iterVL != iterVLEnd; ++iterVL)
    (iterVL->second)->exportSwitchesState();
}
#endif

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
        boost::unordered_map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator busItfIter = components_.find(*cmpIt);
        if (busItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = busItfIter->second;
          if (cmp->getType() != ComponentInterface::BUS)
            Trace::warn() << DYNLog(WrongComponentType, *cmpIt, "bus") << Trace::endline;
          if (crit->hasCountryFilter()) {
            boost::shared_ptr<BusInterfaceIIDM> bus = dynamic_pointer_cast<BusInterfaceIIDM>(cmp);
            if (bus && !bus->getCountry().empty() && !crit->containsCountry(bus->getCountry()))
              continue;
          }
          boost::shared_ptr<BusInterface> bus = dynamic_pointer_cast<BusInterface>(cmp);
          assert(bus);
          dynCriteria->addBus(bus);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, *cmpIt) << Trace::endline;
        }
      }
    } else {
      for (boost::unordered_map<std::string, boost::shared_ptr<BusInterface> >::const_iterator cmpIt = busComponents_.begin(),
          cmpItEnd = busComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        if (crit->hasCountryFilter()) {
          boost::shared_ptr<BusInterfaceIIDM> bus = dynamic_pointer_cast<BusInterfaceIIDM>(cmpIt->second);
          if (!bus->getCountry().empty() && !crit->containsCountry(bus->getCountry()))
            continue;
        }
        dynCriteria->addBus(cmpIt->second);
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
        boost::unordered_map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator loadItfIter = components_.find(*cmpIt);
        if (loadItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = loadItfIter->second;
          if (cmp->getType() != ComponentInterface::LOAD)
            Trace::warn() << DYNLog(WrongComponentType, *cmpIt, "load") << Trace::endline;
          if (crit->hasCountryFilter()) {
            boost::shared_ptr<LoadInterfaceIIDM> load = dynamic_pointer_cast<LoadInterfaceIIDM>(cmp);
            if (!load->getCountry().empty() && !crit->containsCountry(load->getCountry()))
              continue;
          }
          boost::shared_ptr<LoadInterface> load = dynamic_pointer_cast<LoadInterface>(cmp);
          assert(load);
          dynCriteria->addLoad(load);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, *cmpIt) << Trace::endline;
        }
      }
    } else {
      for (boost::unordered_map<std::string, boost::shared_ptr<LoadInterface> >::const_iterator cmpIt = loadComponents_.begin(),
          cmpItEnd = loadComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        if (crit->hasCountryFilter()) {
          boost::shared_ptr<LoadInterfaceIIDM> load = dynamic_pointer_cast<LoadInterfaceIIDM>(cmpIt->second);
          if (!load->getCountry().empty() && !crit->containsCountry(load->getCountry()))
            continue;
        }
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
        boost::unordered_map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator generatorItfIter = components_.find(*cmpIt);
        if (generatorItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = generatorItfIter->second;
          if (cmp->getType() != ComponentInterface::GENERATOR)
            Trace::warn() << DYNLog(WrongComponentType, *cmpIt, "generator") << Trace::endline;
          if (crit->hasCountryFilter()) {
            boost::shared_ptr<GeneratorInterfaceIIDM> gen = dynamic_pointer_cast<GeneratorInterfaceIIDM>(cmp);
            if (!gen->getCountry().empty() && !crit->containsCountry(gen->getCountry()))
              continue;
          }
          boost::shared_ptr<GeneratorInterface> gen = dynamic_pointer_cast<GeneratorInterface>(cmp);
          assert(gen);
          dynCriteria->addGenerator(gen);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, *cmpIt) << Trace::endline;
        }
      }
    } else {
      for (boost::unordered_map<std::string, boost::shared_ptr<GeneratorInterface> >::const_iterator cmpIt = generatorComponents_.begin(),
          cmpItEnd = generatorComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        if (crit->hasCountryFilter()) {
          boost::shared_ptr<GeneratorInterfaceIIDM> gen = dynamic_pointer_cast<GeneratorInterfaceIIDM>(cmpIt->second);
          if (!gen->getCountry().empty() && !crit->containsCountry(gen->getCountry()))
            continue;
        }
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
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("DataInterfaceIIDM::checkCriteria");
#endif
#ifdef _DEBUG_
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(); iter != components_.end(); ++iter) {
    iter->second->enableCheckStateVariable();
  }
#endif
  bool criteriaOk = true;
  for (std::vector<boost::shared_ptr<Criteria> >::const_iterator it = criteria_.begin(), itEnd = criteria_.end();
      it != itEnd; ++it) {
    criteriaOk &= (*it)->checkCriteria(t, finalStep);
  }
#ifdef _DEBUG_
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(); iter != components_.end(); ++iter) {
    iter->second->disableCheckStateVariable();
  }
#endif
  return criteriaOk;
  return false;
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
