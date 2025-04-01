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
#include "DYNBatteryInterfaceIIDM.h"
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
#include "DYNFictBusInterfaceIIDM.h"
#include "DYNFictTwoWTransformerInterfaceIIDM.h"
#include "DYNFictVoltageLevelInterfaceIIDM.h"
#include "LEQLostEquipmentsCollectionFactory.h"

#include <powsybl/iidm/converter/ExportOptions.hpp>
#include <powsybl/iidm/converter/ImportOptions.hpp>
#include <powsybl/iidm/converter/FakeAnonymizer.hpp>
#include <powsybl/iidm/Substation.hpp>

#include <powsybl/iidm/ExtensionProviders.hpp>
#include <powsybl/iidm/converter/xml/ExtensionXmlSerializer.hpp>

#include <regex>
#include <unordered_set>

#include <boost/dll/shared_library.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/make_shared.hpp>

using std::map;
using std::string;
using std::vector;
using std::fstream;

using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using criteria::CriteriaCollection;

namespace DYN {

std::mutex DataInterfaceIIDM::loadExtensionMutex_;

DataInterfaceIIDM::DataInterfaceIIDM(const boost::shared_ptr<powsybl::iidm::Network>& networkIIDM) :
networkIIDM_(networkIIDM),
serviceManager_(boost::make_shared<ServiceManagerInterfaceIIDM>(this)) {
}

void
DataInterfaceIIDM::loadExtensions(const std::vector<std::string>& paths) {
  std::unique_lock<std::mutex> lock(loadExtensionMutex_);
  for (const auto& path : paths) {
    if (!boost::filesystem::is_directory(path)) {
      Trace::debug() << path << " is not a valid directory for IIDM extensions" << Trace::endline;
      continue;
    }
    std::regex fileRegex(stdcxx::format(".*iidm-ext-.*\\%1%", boost::dll::shared_library::suffix().string()));
    powsybl::iidm::ExtensionProviders<powsybl::iidm::converter::xml::ExtensionXmlSerializer>::getInstance().loadExtensions(path, fileRegex);
  }
}

boost::shared_ptr<DataInterface>
DataInterfaceIIDM::build(const std::string& iidmFilePath, unsigned int nbVariants) {
  boost::shared_ptr<DataInterfaceIIDM>  data;
  try {
    stdcxx::Properties properties;
    powsybl::iidm::converter::ImportOptions options(properties);

    std::string extensionsPaths = getMandatoryEnvVar("DYNAWO_LIBIIDM_EXTENSIONS");
    vector<string> paths;
    std::string splitCharacter;
#ifdef _WIN32
    splitCharacter = ";";
#else
    splitCharacter = ":";
#endif
    boost::split(paths, extensionsPaths, boost::is_any_of(splitCharacter));

    loadExtensions(paths);

    auto networkIIDM = boost::make_shared<powsybl::iidm::Network>(powsybl::iidm::Network::readXml(boost::filesystem::path(iidmFilePath), options));

    if (nbVariants > 1) {
      auto& manager = networkIIDM->getVariantManager();
      manager.allowVariantMultiThreadAccess(true);
      constexpr bool overwrite = true;
      for (unsigned int i = 0; i < nbVariants; ++i) {
        const std::string& variantName = std::to_string(i);
        manager.cloneVariant(powsybl::iidm::VariantManager::getInitialVariantId(), variantName, overwrite);
      }
    }

    data.reset(new DataInterfaceIIDM(networkIIDM));
    data->initFromIIDM();
  } catch (const powsybl::PowsyblException& exp) {
    throw DYNError(Error::GENERAL, XmlFileParsingError, iidmFilePath, exp.what());
  }
  return data;
}

bool DataInterfaceIIDM::canUseVariant() const {
  return getNetworkIIDM().getVariantManager().isVariantMultiThreadAccessAllowed();
}

void DataInterfaceIIDM::selectVariant(const std::string& variantName) {
  getNetworkIIDM().getVariantManager().setWorkingVariant(variantName);
}

void
DataInterfaceIIDM::dumpToFile(const std::string& iidmFilePath) const {
  try {
    stdcxx::Properties properties;
    powsybl::iidm::converter::ExportOptions options(properties);

    powsybl::iidm::Network::writeXml(boost::filesystem::path(iidmFilePath), *networkIIDM_, options);
  } catch (const powsybl::PowsyblException& exp) {
    throw DYNError(Error::GENERAL, XmlFileParsingError, iidmFilePath, exp.what());
  }
}

void
DataInterfaceIIDM::dumpToFile(std::stringstream& stream) const {
  try {
    stdcxx::Properties properties;
    powsybl::iidm::converter::ExportOptions options(properties);

    powsybl::iidm::Network::writeXml("", stream, *networkIIDM_, options);
  } catch (const powsybl::PowsyblException& exp) {
    throw DYNError(Error::GENERAL, XmlParsingError, exp.what());
  }
}

powsybl::iidm::Network&
DataInterfaceIIDM::getNetworkIIDM() {
  return *networkIIDM_;
}

const powsybl::iidm::Network&
DataInterfaceIIDM::getNetworkIIDM() const {
  return *networkIIDM_;
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
      case ComponentInterface::LINE: {
        shared_ptr<LineInterface> line = dynamic_pointer_cast<LineInterface>(component);
        if (labelNode == "@NODE1@") {
          busName = line->getBusInterface1()->getID();
        } else if (labelNode == "@NODE2@") {
          busName = line->getBusInterface2()->getID();
        }
        break;
      }
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
      case ComponentInterface::TWO_WTFO: {
        shared_ptr<TwoWTransformerInterface> twoTransformer = dynamic_pointer_cast<TwoWTransformerInterface>(component);
        if (labelNode == "@NODE1@") {
          busName = twoTransformer->getBusInterface1()->getID();
        } else if (labelNode == "@NODE2@") {
          busName = twoTransformer->getBusInterface2()->getID();
        }
        break;
      }
      case ComponentInterface::THREE_WTFO: {
        shared_ptr<ThreeWTransformerInterface> threeTransformer = dynamic_pointer_cast<ThreeWTransformerInterface>(component);
        if (labelNode == "@NODE1@") {
          busName = threeTransformer->getBusInterface1()->getID();
        } else if (labelNode == "@NODE2@") {
          busName = threeTransformer->getBusInterface2()->getID();
        } else if (labelNode == "@NODE3@") {
          busName = threeTransformer->getBusInterface3()->getID();
        }
        break;
      }
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
      case ComponentInterface::COMPONENT_TYPE_COUNT:
        break;
    }
  }
  return busName;
}

void
DataInterfaceIIDM::initFromIIDM() {
  // create network interface
  network_.reset(new NetworkInterfaceIIDM(*networkIIDM_));

  for (auto& substation : networkIIDM_->getSubstations()) {
    for (auto& voltageLevel : substation.getVoltageLevels()) {
      auto vl = importVoltageLevel(voltageLevel, substation.getCountry());
      network_->addVoltageLevel(vl);
      voltageLevels_[vl->getID()] = vl;
    }
  }

  //===========================
  //  ADD 2WTFO INTERFACE
  //===========================
  for (auto& twoWindingTransfoIIDM : networkIIDM_->getTwoWindingsTransformers()) {
    auto tfo = importTwoWindingsTransformer(twoWindingTransfoIIDM);
    network_->addTwoWTransformer(tfo);
    components_[tfo->getID()] = tfo;
  }

  //==========================================
  //  CONVERT THREE WINDINGS TRANSFORMERS
  //==========================================
  for (auto& threeWindingTransfoIIDM : networkIIDM_->getThreeWindingsTransformers()) {
    convertThreeWindingsTransformers(threeWindingTransfoIIDM);
  }

  //===========================
  //  ADD LINE INTERFACE
  //===========================
  for (auto& lineIIDM : networkIIDM_->getLines()) {
    auto line = importLine(lineIIDM);
    network_->addLine(line);
    components_[line->getID()] = line;
  }

  //===========================
  //  ADD HVDC LINE INTERFACE
  //===========================
  for (auto& hvdcLineIIDM : networkIIDM_->getHvdcLines()) {
    auto hvdc = importHvdcLine(hvdcLineIIDM);
    network_->addHvdcLine(hvdc);
    components_[hvdc->getID()] = hvdc;
  }
  DYNErrorQueue::instance().flush();
}

shared_ptr<VoltageLevelInterfaceIIDM>
DataInterfaceIIDM::importVoltageLevel(powsybl::iidm::VoltageLevel& voltageLevelIIDM, const stdcxx::optional<powsybl::iidm::Country>& country) {
  shared_ptr<VoltageLevelInterfaceIIDM> voltageLevel(new VoltageLevelInterfaceIIDM(voltageLevelIIDM));
  string countryStr;
  if (country)
    countryStr = powsybl::iidm::getCountryName(country.get());
  voltageLevel->setCountry(countryStr);

  if (voltageLevelIIDM.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    voltageLevel->calculateBusTopology();

    //===========================
    //  ADD BUS INTERFACE
    //===========================
    vector<shared_ptr<CalculatedBusInterfaceIIDM> > buses = voltageLevel->getCalculatedBus();
    for (unsigned int i = 0; i < buses.size(); ++i) {
      components_[buses[i]->getID()] = buses[i];
      busComponents_[buses[i]->getID()] = buses[i];
      calculatedBusComponents_[voltageLevel->getID()].push_back(buses[i]);
      buses[i]->setCountry(countryStr);
      voltageLevel->addBus(buses[i]);
    }


    //===========================
    //  ADD SWITCH INTERFACE
    //===========================
    for (auto& switchIIDM : voltageLevelIIDM.getSwitches()) {
      if (switchIIDM.isOpen() || switchIIDM.isRetained()) {
        shared_ptr<BusInterface> bus1 = findNodeBreakerBusInterface(voltageLevelIIDM,
                                                                    static_cast<int>(voltageLevelIIDM.getNodeBreakerView().getNode1(switchIIDM.getId())));
        shared_ptr<BusInterface> bus2 = findNodeBreakerBusInterface(voltageLevelIIDM,
                                                                    static_cast<int>(voltageLevelIIDM.getNodeBreakerView().getNode2(switchIIDM.getId())));
        shared_ptr<SwitchInterface> sw = importSwitch(switchIIDM, bus1, bus2);
        if (sw->getBusInterface1() != sw->getBusInterface2()) {  // if the switch is connecting one single bus, don't create a specific switch model
          components_[sw->getID()] = sw;
          voltageLevel->addSwitch(sw);
        }
      }
    }
  } else {
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
    for (auto& switchIIDM : voltageLevelIIDM.getSwitches()) {
      auto bus1 = findBusBreakerBusInterface(voltageLevelIIDM.getBusBreakerView().getBus1(switchIIDM.getId()).get());
      auto bus2 = findBusBreakerBusInterface(voltageLevelIIDM.getBusBreakerView().getBus2(switchIIDM.getId()).get());
      auto sw = importSwitch(switchIIDM, bus1, bus2);
      if (sw->getBusInterface1() != sw->getBusInterface2()) {  // if the switch is connecting one single bus, don't create a specific switch model
        components_[sw->getID()] = sw;
        voltageLevel->addSwitch(sw);
      }
    }
  }

  //==========================================
  //  ADD VSC CONVERTER INTERFACE
  //==========================================
  for (auto& vscConverterIIDM : voltageLevelIIDM.getVscConverterStations()) {
    auto vsc = importVscConverter(vscConverterIIDM);
    voltageLevel->addVscConverter(vsc);
    components_[vsc->getID()] = vsc;
    vsc->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD LCC CONVERTER INTERFACE
  //==========================================
  for (auto& lccConverterIIDM : voltageLevelIIDM.getLccConverterStations()) {
    auto lcc = importLccConverter(lccConverterIIDM);
    voltageLevel->addLccConverter(lcc);
    components_[lcc->getID()] = lcc;
    lcc->setVoltageLevelInterface(voltageLevel);
  }

  //===========================
  //  ADD GENERATOR INTERFACE
  //===========================
  for (auto& genIIDM : voltageLevelIIDM.getGenerators()) {
    auto generator = importGenerator(genIIDM, countryStr);
    voltageLevel->addGenerator(generator);
    components_[generator->getID()] = generator;
    generatorComponents_[generator->getID()] = generator;
    generator->setVoltageLevelInterface(voltageLevel);
  }

  //===========================
  //  ADD BATTERY INTERFACE
  //===========================
  for (auto& batIIDM : voltageLevelIIDM.getBatteries()) {
    auto battery = importBattery(batIIDM, countryStr);
    voltageLevel->addGenerator(battery);
    components_[battery->getID()] = battery;
    generatorComponents_[battery->getID()] = battery;
    battery->setVoltageLevelInterface(voltageLevel);
  }

  //===========================
  //  ADD LOAD INTERFACE
  //===========================
  for (auto& loadIIDM : voltageLevelIIDM.getLoads()) {
    auto load = importLoad(loadIIDM, countryStr);
    voltageLevel->addLoad(load);
    components_[load->getID()] = load;
    loadComponents_[load->getID()] = load;
    load->setVoltageLevelInterface(voltageLevel);
  }
  // =======================================
  //    ADD SHUNTCOMPENSATORS INTERFACE
  // =======================================
  for (auto& shuntCompensators : voltageLevelIIDM.getShuntCompensators()) {
    auto shunt = importShuntCompensator(shuntCompensators);
    voltageLevel->addShuntCompensator(shunt);
    components_[shunt->getID()] = shunt;
    shunt->setVoltageLevelInterface(voltageLevel);
  }

  //==============================
  //  ADD DANGLINGLINE INTERFACE
  //==============================
  for (auto& danglingLine : voltageLevelIIDM.getDanglingLines()) {
    auto line = importDanglingLine(danglingLine);
    voltageLevel->addDanglingLine(line);
    components_[line->getID()] = line;
    line->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD STATICVARCOMPENSATOR INTERFACE
  //==========================================
  for (auto& staticVarCompensator : voltageLevelIIDM.getStaticVarCompensators()) {
    auto svc = importStaticVarCompensator(staticVarCompensator);
    voltageLevel->addStaticVarCompensator(svc);
    components_[svc->getID()] = svc;
    svc->setVoltageLevelInterface(voltageLevel);
  }

  return voltageLevel;
}

shared_ptr<SwitchInterfaceIIDM>
DataInterfaceIIDM::importSwitch(powsybl::iidm::Switch& switchIIDM, const shared_ptr<BusInterface>& bus1
    , const shared_ptr<BusInterface>& bus2) {
  shared_ptr<SwitchInterfaceIIDM> sw(new SwitchInterfaceIIDM(switchIIDM));
  sw->setBusInterface1(bus1);
  sw->setBusInterface2(bus2);
  return sw;
}

shared_ptr<GeneratorInterfaceIIDM>
DataInterfaceIIDM::importGenerator(powsybl::iidm::Generator & generatorIIDM, const std::string& country) {
  shared_ptr<GeneratorInterfaceIIDM> generator(new GeneratorInterfaceIIDM(generatorIIDM));
  generator->setCountry(country);
  generator->setBusInterface(findBusInterface(generatorIIDM.getTerminal()));
  return generator;
}

shared_ptr<BatteryInterfaceIIDM>
DataInterfaceIIDM::importBattery(powsybl::iidm::Battery & batteryIIDM, const std::string& country) {
  shared_ptr<BatteryInterfaceIIDM> battery(new BatteryInterfaceIIDM(batteryIIDM));
  battery->setCountry(country);
  battery->setBusInterface(findBusInterface(batteryIIDM.getTerminal()));
  return battery;
}

shared_ptr<LoadInterfaceIIDM>
DataInterfaceIIDM::importLoad(powsybl::iidm::Load& loadIIDM, const std::string& country) {
  shared_ptr<LoadInterfaceIIDM> load(new LoadInterfaceIIDM(loadIIDM));
  load->setCountry(country);
  load->setBusInterface(findBusInterface(loadIIDM.getTerminal()));
  return load;
}

shared_ptr<ShuntCompensatorInterfaceIIDM>
DataInterfaceIIDM::importShuntCompensator(powsybl::iidm::ShuntCompensator& shuntIIDM) {
  shared_ptr<ShuntCompensatorInterfaceIIDM> shunt(new ShuntCompensatorInterfaceIIDM(shuntIIDM));
  shunt->setBusInterface(findBusInterface(shuntIIDM.getTerminal()));
  return shunt;
}

shared_ptr<DanglingLineInterfaceIIDM>
DataInterfaceIIDM::importDanglingLine(powsybl::iidm::DanglingLine& danglingLineIIDM) {
  shared_ptr<DanglingLineInterfaceIIDM> danglingLine(new DanglingLineInterfaceIIDM(danglingLineIIDM));
  danglingLine->setBusInterface(findBusInterface(danglingLineIIDM.getTerminal()));

  if (danglingLineIIDM.getCurrentLimits()) {
    powsybl::iidm::CurrentLimits& currentLimits = danglingLineIIDM.getCurrentLimits();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), std::numeric_limits<unsigned long>::max()));
      danglingLine->addCurrentLimitInterface(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(), currentLimit.getAcceptableDuration()));
        danglingLine->addCurrentLimitInterface(cLimit);
      }
    }
  }
  return danglingLine;
}

shared_ptr<StaticVarCompensatorInterfaceIIDM>
DataInterfaceIIDM::importStaticVarCompensator(powsybl::iidm::StaticVarCompensator& svcIIDM) {
  shared_ptr<StaticVarCompensatorInterfaceIIDM> svc(new StaticVarCompensatorInterfaceIIDM(svcIIDM));
  svc->setBusInterface(findBusInterface(svcIIDM.getTerminal()));
  return svc;
}

shared_ptr<TwoWTransformerInterfaceIIDM>
DataInterfaceIIDM::importTwoWindingsTransformer(powsybl::iidm::TwoWindingsTransformer& twoWTfoIIDM) {
  shared_ptr<TwoWTransformerInterfaceIIDM> twoWTfo(new TwoWTransformerInterfaceIIDM(twoWTfoIIDM));

  // add phase tapChanger and steps if exists
  if (twoWTfoIIDM.hasPhaseTapChanger()) {
    shared_ptr<PhaseTapChangerInterfaceIIDM> tapChanger(new PhaseTapChangerInterfaceIIDM(twoWTfoIIDM.getPhaseTapChanger()));
    twoWTfo->setPhaseTapChanger(tapChanger);
  }
  // add ratio tapChanger and steps if exists
  if (twoWTfoIIDM.hasRatioTapChanger()) {
    string side;
    if (twoWTfoIIDM.getRatioTapChanger().getRegulationTerminal() &&
        stdcxx::areSame(twoWTfoIIDM.getTerminal1(), twoWTfoIIDM.getRatioTapChanger().getRegulationTerminal().get()))
      side = "ONE";
    else if (twoWTfoIIDM.getRatioTapChanger().getRegulationTerminal() &&
        stdcxx::areSame(twoWTfoIIDM.getTerminal2(), twoWTfoIIDM.getRatioTapChanger().getRegulationTerminal().get()))
      side = "TWO";
    shared_ptr<RatioTapChangerInterfaceIIDM> tapChanger(new RatioTapChangerInterfaceIIDM(twoWTfoIIDM.getRatioTapChanger(), side));
    twoWTfo->setRatioTapChanger(tapChanger);
  }

  twoWTfo->setBusInterface1(findBusInterface(twoWTfoIIDM.getTerminal1()));
  twoWTfo->setVoltageLevelInterface1(findVoltageLevelInterface(twoWTfoIIDM.getTerminal1().getVoltageLevel().getId()));

  twoWTfo->setBusInterface2(findBusInterface(twoWTfoIIDM.getTerminal2()));
  twoWTfo->setVoltageLevelInterface2(findVoltageLevelInterface(twoWTfoIIDM.getTerminal2().getVoltageLevel().getId()));

  if (twoWTfoIIDM.getCurrentLimits1()) {
    powsybl::iidm::CurrentLimits& currentLimits = twoWTfoIIDM.getCurrentLimits1();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), std::numeric_limits<unsigned long>::max()));
      twoWTfo->addCurrentLimitInterface1(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(), currentLimit.getAcceptableDuration()));
        twoWTfo->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (twoWTfoIIDM.getCurrentLimits2()) {
    powsybl::iidm::CurrentLimits& currentLimits = twoWTfoIIDM.getCurrentLimits2();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(), std::numeric_limits<unsigned long>::max()));
      twoWTfo->addCurrentLimitInterface2(cLimit);
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(), currentLimit.getAcceptableDuration()));
        twoWTfo->addCurrentLimitInterface2(cLimit);
      }
    }
  }
  return twoWTfo;
}

void
DataInterfaceIIDM::convertThreeWindingsTransformers(powsybl::iidm::ThreeWindingsTransformer & ThreeWindingTransformer) {
  const string fictVLId = ThreeWindingTransformer.getId() + "_FictVL";
  const string fictBusId = ThreeWindingTransformer.getId() + "_FictBUS";
  string countryStr;
  if (ThreeWindingTransformer.getSubstation().getCountry())
    countryStr = powsybl::iidm::getCountryName(ThreeWindingTransformer.getSubstation().getCountry().get());

  std::vector<stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg> > legs;
  legs.push_back(stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(ThreeWindingTransformer.getLeg1()));
  legs.push_back(stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(ThreeWindingTransformer.getLeg2()));
  legs.push_back(stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(ThreeWindingTransformer.getLeg3()));

  shared_ptr<VoltageLevelInterface> vl(new FictVoltageLevelInterfaceIIDM(fictVLId, ThreeWindingTransformer.getRatedU0(), countryStr));
  network_->addVoltageLevel(vl);
  voltageLevels_[vl->getID()] = vl;
  shared_ptr<BusInterface> fictBus(new FictBusInterfaceIIDM(fictBusId, ThreeWindingTransformer.getRatedU0(), countryStr));
  vl->addBus(fictBus);
  components_[fictBus->getID()] = fictBus;
  busComponents_[fictBus->getID()] = fictBus;

  int legCount = 1;
  const bool initialConnected1 = true;
  const double VNom1 = ThreeWindingTransformer.getRatedU0();
  const double ratedU1 = ThreeWindingTransformer.getRatedU0();

  auto libPath = IIDMExtensions::findLibraryPath();
  auto activeSeasonExtensionDef = IIDMExtensions::getExtension<ActiveSeasonIIDMExtension>(libPath.generic_string());
  auto activeSeasonExtension = std::get<IIDMExtensions::CREATE_FUNCTION>(activeSeasonExtensionDef)(ThreeWindingTransformer);
  auto destroyActiveSeasonExtension = std::get<IIDMExtensions::DESTROY_FUNCTION>(activeSeasonExtensionDef);
  const string activeSeason = activeSeasonExtension ? activeSeasonExtension->getValue() : std::string("UNDEFINED");
  destroyActiveSeasonExtension(activeSeasonExtension);

  for (auto& leg : legs) {
    string TwoWTransfId = ThreeWindingTransformer.getId() + "_" + std::to_string(legCount);
    // We consider the fictitious transformer always connected on the fictitious bus
    shared_ptr<TwoWTransformerInterface> fictTwoWTransf(new FictTwoWTransformerInterfaceIIDM(TwoWTransfId, leg, initialConnected1, VNom1,
                                                        ratedU1, activeSeason));
    fictTwoWTransf.get()->setBusInterface1(fictBus);
    fictTwoWTransf.get()->setBusInterface2(findBusInterface(leg.get().getTerminal()));
    fictTwoWTransf.get()->setVoltageLevelInterface1(vl);
    fictTwoWTransf.get()->setVoltageLevelInterface2(findVoltageLevelInterface(leg.get().getTerminal().getVoltageLevel().getId()));
    // add phase tapChanger and steps if exists
    if (leg.get().hasPhaseTapChanger()) {
      shared_ptr<PhaseTapChangerInterfaceIIDM> tapChanger(new PhaseTapChangerInterfaceIIDM(leg.get().getPhaseTapChanger()));
      fictTwoWTransf->setPhaseTapChanger(tapChanger);
    }
    // add ratio tapChanger and steps if exists. It is always referring to side TWO as it is the side coming from
    // the orginal ThreeWindingTransformer
    if (leg.get().hasRatioTapChanger()) {
      string side;
      if (leg.get().getRatioTapChanger().getRegulationTerminal() &&
          stdcxx::areSame(leg.get().getTerminal(), leg.get().getRatioTapChanger().getRegulationTerminal().get())) {
        side = "TWO";
        shared_ptr<RatioTapChangerInterfaceIIDM> tapChanger(new RatioTapChangerInterfaceIIDM(leg.get().getRatioTapChanger(), side));
        fictTwoWTransf->setRatioTapChanger(tapChanger);
      }
    }
    if (leg.get().getCurrentLimits()) {
      powsybl::iidm::CurrentLimits& currentLimits = leg.get().getCurrentLimits().get();
      // permanent limit
      if (!std::isnan(currentLimits.getPermanentLimit())) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits.getPermanentLimit(),
                                                    std::numeric_limits<unsigned long>::max()));
        fictTwoWTransf->addCurrentLimitInterface2(cLimit);
      }
      // temporary limit
      for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
        if (!currentLimit.isFictitious()) {
          shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(),
                                                    currentLimit.getAcceptableDuration()));
          fictTwoWTransf->addCurrentLimitInterface2(cLimit);
        }
      }
    }
    network_->addTwoWTransformer(fictTwoWTransf);
    components_[fictTwoWTransf->getID()] = fictTwoWTransf;
    fict2wtIDto3wtID_.insert({fictTwoWTransf->getID(), ThreeWindingTransformer.getId()});
    legCount++;
  }
  return;
}

shared_ptr<LineInterfaceIIDM>
DataInterfaceIIDM::importLine(powsybl::iidm::Line& lineIIDM) {
  shared_ptr<LineInterfaceIIDM> line(new LineInterfaceIIDM(lineIIDM));
  line->setBusInterface1(findBusInterface(lineIIDM.getTerminal1()));
  line->setVoltageLevelInterface1(findVoltageLevelInterface(lineIIDM.getTerminal1().getVoltageLevel().getId()));
  line->setBusInterface2(findBusInterface(lineIIDM.getTerminal2()));
  line->setVoltageLevelInterface2(findVoltageLevelInterface(lineIIDM.getTerminal2().getVoltageLevel().getId()));

  // permanent limit on side 1
  if (lineIIDM.getCurrentLimits1()) {
    powsybl::iidm::CurrentLimits& currentLimits1 = lineIIDM.getCurrentLimits1().get();
    if (!std::isnan(currentLimits1.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits1.getPermanentLimit(),
          std::numeric_limits<unsigned long>::max()));
      line->addCurrentLimitInterface1(cLimit);
    }
    // temporary limit on side 1
    for (auto& currentLimit : currentLimits1.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(), currentLimit.getAcceptableDuration()));
        line->addCurrentLimitInterface1(cLimit);
      }
    }
  }

  if (lineIIDM.getCurrentLimits2()) {
    // permanent limit on side 2
    powsybl::iidm::CurrentLimits& currentLimits2 = lineIIDM.getCurrentLimits2().get();
    if (!std::isnan(currentLimits2.getPermanentLimit())) {
      shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimits2.getPermanentLimit(),
          std::numeric_limits<unsigned long>::max()));
      line->addCurrentLimitInterface2(cLimit);
    }
    // temporary limit on side 12
    for (auto& currentLimit : currentLimits2.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        shared_ptr<CurrentLimitInterfaceIIDM> cLimit(new CurrentLimitInterfaceIIDM(currentLimit.getValue(), currentLimit.getAcceptableDuration()));
        line->addCurrentLimitInterface2(cLimit);
      }
    }
  }
  return line;
}

shared_ptr<VscConverterInterfaceIIDM>
DataInterfaceIIDM::importVscConverter(powsybl::iidm::VscConverterStation& vscIIDM) {
  shared_ptr<VscConverterInterfaceIIDM> vsc(new VscConverterInterfaceIIDM(vscIIDM));
  vsc->setBusInterface(findBusInterface(vscIIDM.getTerminal()));
  return vsc;
}

shared_ptr<LccConverterInterfaceIIDM>
DataInterfaceIIDM::importLccConverter(powsybl::iidm::LccConverterStation& lccIIDM) {
  shared_ptr<LccConverterInterfaceIIDM> lcc(new LccConverterInterfaceIIDM(lccIIDM));
  lcc->setBusInterface(findBusInterface(lccIIDM.getTerminal()));
  return lcc;
}

shared_ptr<HvdcLineInterfaceIIDM>
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
DataInterfaceIIDM::findBusInterface(const powsybl::iidm::Terminal& terminal) const {
  if (terminal.getVoltageLevel().getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    return findNodeBreakerBusInterface(terminal.getVoltageLevel(), static_cast<int>(terminal.getNodeBreakerView().getNode()));
  } else {
    return findBusBreakerBusInterface(terminal.getBusBreakerView().getConnectableBus().get());
  }
}

shared_ptr<BusInterface>
DataInterfaceIIDM::findBusBreakerBusInterface(const powsybl::iidm::Bus& bus) const {
  string id = bus.getId();
  if (bus.getVoltageLevel().getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    throw DYNError(Error::MODELER, UnknownBus, id);
  }
  boost::unordered_map<std::string, boost::shared_ptr<BusInterface> >::const_iterator iter = busComponents_.find(id);
  if (iter != busComponents_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownBus, id);
}


boost::shared_ptr<CalculatedBusInterfaceIIDM>
DataInterfaceIIDM::findNodeBreakerBusInterface(const powsybl::iidm::VoltageLevel& vl, const int node) const {
  if (vl.getTopologyKind() == powsybl::iidm::TopologyKind::BUS_BREAKER) {
    throw DYNError(Error::MODELER, UnknownCalculatedBus, vl.getId(), node);
  }
  boost::unordered_map<string, vector<shared_ptr<CalculatedBusInterfaceIIDM> > >::const_iterator iter = calculatedBusComponents_.find(vl.getId());
  if (iter == calculatedBusComponents_.end())
    throw DYNError(Error::MODELER, UnknownCalculatedBus, vl.getId());

  vector<shared_ptr<CalculatedBusInterfaceIIDM> > buses = iter->second;
  for (unsigned int i = 0; i < buses.size(); ++i) {
    if (buses[i]->hasNode(node))
      return buses[i];
  }
  throw DYNError(Error::MODELER, UnknownCalculatedBus, vl.getId(), node);
}

shared_ptr<VoltageLevelInterface>
DataInterfaceIIDM::findVoltageLevelInterface(const string& id) const {
  boost::unordered_map<string, shared_ptr<VoltageLevelInterface> >::const_iterator iter = voltageLevels_.find(id);
  if (iter != voltageLevels_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownVoltageLevel, id);
}

shared_ptr<BusInterface>
DataInterfaceIIDM::findCalculatedBusInterface(const string& voltageLevelId, const string& bbsId) const {
  boost::unordered_map<string, vector<shared_ptr<CalculatedBusInterfaceIIDM> > >::const_iterator iter = calculatedBusComponents_.find(voltageLevelId);
  if (iter != calculatedBusComponents_.end()) {
    vector<shared_ptr<CalculatedBusInterfaceIIDM> > buses = iter->second;
    for (unsigned int i = 0; i < buses.size(); ++i) {
      if (buses[i]->hasBusBarSection(bbsId))
        return buses[i];
    }
  }
  return shared_ptr<BusInterface>();
}

const shared_ptr<ComponentInterface>&
DataInterfaceIIDM::findComponent(const std::string& id) const {
  boost::unordered_map<string, shared_ptr<ComponentInterface> >::const_iterator iter = components_.find(id);
  if (iter != components_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownStaticComponent, id);
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

const shared_ptr<vector<shared_ptr<ComponentInterface> > >
DataInterfaceIIDM::findConnectedComponents() {
  auto connectedComponents = boost::make_shared<vector<shared_ptr<ComponentInterface> > >();
  for (auto& component : components_) {
    if ((component.second)->isPartiallyConnected()) {
      connectedComponents->push_back(component.second);
    }
  }
  return connectedComponents;
}

const shared_ptr<lostEquipments::LostEquipmentsCollection>
DataInterfaceIIDM::findLostEquipments(const shared_ptr<vector<shared_ptr<ComponentInterface> > >& connectedComponents) {
  auto lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
  if (connectedComponents) {
    std::unordered_set<std::string> alreadyLost3wt;
    for (const auto& component : *connectedComponents) {
      auto lost = !component->isPartiallyConnected();  // from connected to not connected (not even partially)
      if (lost) {
        std::string componentID = component->getID();
        if (component->getType() == ComponentInterface::ComponentType_t::TWO_WTFO &&
            fict2wtIDto3wtID_.find(componentID) != fict2wtIDto3wtID_.end()) {
          if (alreadyLost3wt.find(fict2wtIDto3wtID_[componentID]) == alreadyLost3wt.end()) {
            lostEquipments->addLostEquipment(fict2wtIDto3wtID_[componentID], "THREE_WINDINGS_TRANSFORMER");
            alreadyLost3wt.insert(fict2wtIDto3wtID_[componentID]);
          }
        } else {
          lostEquipments->addLostEquipment(componentID, component->getTypeAsString());
        }
      }
    }
  }
  return lostEquipments;
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
        shared_ptr<BusInterface> bus;
        if (!cmpIt->getVoltageLevelId().empty()) {
          bus = findCalculatedBusInterface(cmpIt->getVoltageLevelId(), cmpIt->getId());
          if (!bus) {
            Trace::warn() << DYNLog(CalculatedBusNotFound, cmpIt->getVoltageLevelId(), cmpIt->getId()) << Trace::endline;
            continue;
          }
        } else {
          boost::unordered_map<std::string, shared_ptr<ComponentInterface> >::const_iterator busItfIter = components_.find(cmpIt->getId());
          if (busItfIter != components_.end()) {
            const shared_ptr<ComponentInterface> &cmp = busItfIter->second;
            if (cmp->getType() != ComponentInterface::BUS) {
              Trace::warn() << DYNLog(WrongComponentType, cmpIt->getId(), "bus") << Trace::endline;
              continue;
            }
            bus = dynamic_pointer_cast<BusInterface>(cmp);
            assert(bus);
          } else {
            Trace::warn() << DYNLog(ComponentNotFound, cmpIt->getId()) << Trace::endline;
            continue;
          }
        }
        if (crit->hasCountryFilter()) {
          shared_ptr<BusInterfaceIIDM> busIIDM = dynamic_pointer_cast<BusInterfaceIIDM>(bus);
          if (busIIDM && !busIIDM->getCountry().empty() && !crit->containsCountry(busIIDM->getCountry()))
            continue;
        }
        dynCriteria->addBus(bus);
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
        boost::unordered_map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator loadItfIter = components_.find(cmpIt->getId());
        if (loadItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = loadItfIter->second;
          if (cmp->getType() != ComponentInterface::LOAD) {
            Trace::warn() << DYNLog(WrongComponentType, cmpIt->getId(), "load") << Trace::endline;
            continue;
          }
          if (crit->hasCountryFilter()) {
            boost::shared_ptr<LoadInterfaceIIDM> load = dynamic_pointer_cast<LoadInterfaceIIDM>(cmp);
            if (!load->getCountry().empty() && !crit->containsCountry(load->getCountry()))
              continue;
          }
          boost::shared_ptr<LoadInterface> load = dynamic_pointer_cast<LoadInterface>(cmp);
          assert(load);
          dynCriteria->addLoad(load);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, cmpIt->getId()) << Trace::endline;
        }
      }
    } else {
      for (boost::unordered_map<std::string, boost::shared_ptr<LoadInterfaceIIDM> >::const_iterator cmpIt = loadComponents_.begin(),
          cmpItEnd = loadComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        if (crit->hasCountryFilter() && !cmpIt->second->getCountry().empty() && !crit->containsCountry(cmpIt->second->getCountry()))
            continue;
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
        boost::unordered_map<std::string, boost::shared_ptr<ComponentInterface> >::const_iterator generatorItfIter = components_.find(cmpIt->getId());
        if (generatorItfIter != components_.end()) {
          const boost::shared_ptr<ComponentInterface>& cmp = generatorItfIter->second;
          if (cmp->getType() != ComponentInterface::GENERATOR) {
            Trace::warn() << DYNLog(WrongComponentType, cmpIt->getId(), "generator") << Trace::endline;
            continue;
          }
          if (crit->hasCountryFilter()) {
            boost::shared_ptr<GeneratorInterfaceIIDM> gen = dynamic_pointer_cast<GeneratorInterfaceIIDM>(cmp);
            if (!gen->getCountry().empty() && !crit->containsCountry(gen->getCountry()))
              continue;
          }
          boost::shared_ptr<GeneratorInterface> gen = dynamic_pointer_cast<GeneratorInterface>(cmp);
          assert(gen);
          dynCriteria->addGenerator(gen);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, cmpIt->getId()) << Trace::endline;
        }
      }
    } else {
      for (boost::unordered_map<std::string, boost::shared_ptr<GeneratorInterface> >::const_iterator cmpIt = generatorComponents_.begin(),
          cmpItEnd = generatorComponents_.end();
          cmpIt != cmpItEnd; ++cmpIt) {
        boost::shared_ptr<GeneratorInterfaceIIDM> gen = dynamic_pointer_cast<GeneratorInterfaceIIDM>(cmpIt->second);
        boost::shared_ptr<BatteryInterfaceIIDM> bat = dynamic_pointer_cast<BatteryInterfaceIIDM>(cmpIt->second);
        if (gen && crit->hasCountryFilter() && !gen->getCountry().empty() && !crit->containsCountry(gen->getCountry()))
            continue;
        if (bat && crit->hasCountryFilter() && !bat->getCountry().empty() && !crit->containsCountry(bat->getCountry()))
            continue;
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
    criteriaOk &= (*it)->checkCriteria(t, finalStep, timeline_);
  }
#ifdef _DEBUG_
  for (boost::unordered_map<string, shared_ptr<ComponentInterface> >::iterator iter = components_.begin(); iter != components_.end(); ++iter) {
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

void
DataInterfaceIIDM::setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline) {
  timeline_ = timeline;
}

void
DataInterfaceIIDM::copy(const DataInterfaceIIDM& other) {
  networkIIDM_  = other.networkIIDM_;  // No clone here because iidm network is not copyable
  // Criterias are not copied and must be initialized again
  serviceManager_ = boost::make_shared<ServiceManagerInterfaceIIDM>(this);

  initFromIIDM();
}

DataInterfaceIIDM::DataInterfaceIIDM(const DataInterfaceIIDM& other) {
  copy(other);
}

DataInterfaceIIDM& DataInterfaceIIDM::operator=(const DataInterfaceIIDM& other) {
  copy(other);
  return *this;
}

boost::shared_ptr<DataInterface>
DataInterfaceIIDM::clone() const {
  return boost::shared_ptr<DataInterfaceIIDM>(new DataInterfaceIIDM(*this));
}

}  // namespace DYN
