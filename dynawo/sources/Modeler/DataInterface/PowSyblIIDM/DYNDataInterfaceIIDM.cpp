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

#include <DYNClone.hpp>

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
#include "make_unique.hpp"

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
  boost::shared_ptr<DataInterfaceIIDM> data;
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
  std::unordered_map<string, std::shared_ptr<ComponentInterface> >::const_iterator iter = components_.find(componentName);
  string busName = "";
  if (iter != components_.end()) {
    std::shared_ptr<ComponentInterface> component = iter->second;

    switch (component->getType()) {
      case ComponentInterface::BUS:
      case ComponentInterface::CALCULATED_BUS: {
        std::shared_ptr<BusInterface> bus = std::dynamic_pointer_cast<BusInterface>(component);
        busName = bus->getID();
        break;
      }
      case ComponentInterface::SWITCH:
        break;
      case ComponentInterface::LOAD: {
        std::shared_ptr<LoadInterface> load = std::dynamic_pointer_cast<LoadInterface>(component);
        busName = load->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::LINE: {
        std::shared_ptr<LineInterface> line = std::dynamic_pointer_cast<LineInterface>(component);
        if (labelNode == "@NODE1@") {
          busName = line->getBusInterface1()->getID();
        } else if (labelNode == "@NODE2@") {
          busName = line->getBusInterface2()->getID();
        }
        break;
      }
      case ComponentInterface::GENERATOR: {
        std::shared_ptr<GeneratorInterface> generator = std::dynamic_pointer_cast<GeneratorInterface>(component);
        busName = generator->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::SHUNT: {
        std::shared_ptr<ShuntCompensatorInterface> shunt = std::dynamic_pointer_cast<ShuntCompensatorInterface>(component);
        busName = shunt->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::DANGLING_LINE: {
        std::shared_ptr<DanglingLineInterface> line = std::dynamic_pointer_cast<DanglingLineInterface>(component);
        busName = line->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::TWO_WTFO: {
        std::shared_ptr<TwoWTransformerInterface> twoTransformer = std::dynamic_pointer_cast<TwoWTransformerInterface>(component);
        if (labelNode == "@NODE1@") {
          busName = twoTransformer->getBusInterface1()->getID();
        } else if (labelNode == "@NODE2@") {
          busName = twoTransformer->getBusInterface2()->getID();
        }
        break;
      }
      case ComponentInterface::THREE_WTFO: {
        std::shared_ptr<ThreeWTransformerInterface> threeTransformer = std::dynamic_pointer_cast<ThreeWTransformerInterface>(component);
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
        std::shared_ptr<StaticVarCompensatorInterface> svc = std::dynamic_pointer_cast<StaticVarCompensatorInterface>(component);
        busName = svc->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::VSC_CONVERTER: {
        std::shared_ptr<VscConverterInterface> vsc = std::dynamic_pointer_cast<VscConverterInterface>(component);
        busName = vsc->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::LCC_CONVERTER: {
        std::shared_ptr<LccConverterInterface> lcc = std::dynamic_pointer_cast<LccConverterInterface>(component);
        busName = lcc->getBusInterface()->getID();
        break;
      }
      case ComponentInterface::HVDC_LINE: {
        std::shared_ptr<HvdcLineInterface> hvdc = std::dynamic_pointer_cast<HvdcLineInterface>(component);
        if (labelNode == "@NODE1@") {
          std::shared_ptr<ConverterInterface> conv1 = hvdc->getConverter1();
          busName = conv1->getBusInterface()->getID();
        }
        if (labelNode == "@NODE2@") {
          std::shared_ptr<ConverterInterface> conv2 = hvdc->getConverter2();
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
      std::shared_ptr<VoltageLevelInterfaceIIDM> vl = importVoltageLevel(voltageLevel, substation.getCountry());
      network_->addVoltageLevel(vl);
      voltageLevels_[vl->getID()] = vl;
    }
  }

  //===========================
  //  ADD 2WTFO INTERFACE
  //===========================
  for (auto& twoWindingTransfoIIDM : networkIIDM_->getTwoWindingsTransformers()) {
    std::shared_ptr<TwoWTransformerInterfaceIIDM> tfo = importTwoWindingsTransformer(twoWindingTransfoIIDM);
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
    std::shared_ptr<LineInterfaceIIDM> line = importLine(lineIIDM);
    network_->addLine(line);
    components_[line->getID()] = line;
  }

  //===========================
  //  ADD HVDC LINE INTERFACE
  //===========================
  for (auto& hvdcLineIIDM : networkIIDM_->getHvdcLines()) {
    std::shared_ptr<HvdcLineInterfaceIIDM> hvdc = importHvdcLine(hvdcLineIIDM);
    network_->addHvdcLine(hvdc);
    components_[hvdc->getID()] = hvdc;
  }
  DYNErrorQueue::instance().flush();
}

std::shared_ptr<VoltageLevelInterfaceIIDM>
DataInterfaceIIDM::importVoltageLevel(powsybl::iidm::VoltageLevel& voltageLevelIIDM, const stdcxx::optional<powsybl::iidm::Country>& country) {
  std::shared_ptr<VoltageLevelInterfaceIIDM> voltageLevel = std::make_shared<VoltageLevelInterfaceIIDM>(voltageLevelIIDM);
  string countryStr;
  if (country)
    countryStr = powsybl::iidm::getCountryName(country.get());
  voltageLevel->setCountry(countryStr);

  if (voltageLevelIIDM.getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    voltageLevel->calculateBusTopology();

    //===========================
    //  ADD BUS INTERFACE
    //===========================
    for (auto& bus : voltageLevel->getCalculatedBus()) {
      const string& busId = bus->getID();
      components_[busId] = bus;
      busComponents_[busId] = bus;
      calculatedBusComponents_[voltageLevel->getID()].push_back(bus);
      bus->setCountry(countryStr);
      voltageLevel->addBus(bus);
    }

    //===========================
    //  ADD SWITCH INTERFACE
    //===========================
    for (auto& switchIIDM : voltageLevelIIDM.getSwitches()) {
      if (switchIIDM.isOpen() || switchIIDM.isRetained()) {
        std::shared_ptr<BusInterface> bus1 = findNodeBreakerBusInterface(voltageLevelIIDM,
                                                                    static_cast<int>(voltageLevelIIDM.getNodeBreakerView().getNode1(switchIIDM.getId())));
        std::shared_ptr<BusInterface> bus2 = findNodeBreakerBusInterface(voltageLevelIIDM,
                                                                    static_cast<int>(voltageLevelIIDM.getNodeBreakerView().getNode2(switchIIDM.getId())));
        std::shared_ptr<SwitchInterface> sw = importSwitch(switchIIDM, bus1, bus2);
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
      std::shared_ptr<BusInterfaceIIDM> bus = std::make_shared<BusInterfaceIIDM>(busIIDM);
      if (country)
        bus->setCountry(countryStr);
      voltageLevel->addBus(bus);
      const string& busId = bus->getID();
      components_[busId] = bus;
      busComponents_[busId] = bus;
    }

    //===========================
    //  ADD SWITCH INTERFACE
    //===========================
    for (auto& switchIIDM : voltageLevelIIDM.getSwitches()) {
      auto bus1 = findBusBreakerBusInterface(voltageLevelIIDM.getBusBreakerView().getBus1(switchIIDM.getId()).get());
      auto bus2 = findBusBreakerBusInterface(voltageLevelIIDM.getBusBreakerView().getBus2(switchIIDM.getId()).get());
      std::shared_ptr<SwitchInterfaceIIDM> sw = importSwitch(switchIIDM, bus1, bus2);
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
    std::shared_ptr<VscConverterInterfaceIIDM> vsc = importVscConverter(vscConverterIIDM);
    voltageLevel->addVscConverter(vsc);
    components_[vsc->getID()] = vsc;
    vsc->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD LCC CONVERTER INTERFACE
  //==========================================
  for (auto& lccConverterIIDM : voltageLevelIIDM.getLccConverterStations()) {
    std::shared_ptr<LccConverterInterfaceIIDM> lcc = importLccConverter(lccConverterIIDM);
    voltageLevel->addLccConverter(lcc);
    components_[lcc->getID()] = lcc;
    lcc->setVoltageLevelInterface(voltageLevel);
  }

  //===========================
  //  ADD GENERATOR INTERFACE
  //===========================
  for (auto& genIIDM : voltageLevelIIDM.getGenerators()) {
    std::shared_ptr<GeneratorInterfaceIIDM> generator = importGenerator(genIIDM, countryStr);
    voltageLevel->addGenerator(generator);
    const string& generatorId = generator->getID();
    components_[generatorId] = generator;
    generatorComponents_[generatorId] = generator;
    generator->setVoltageLevelInterface(voltageLevel);
  }

  //===========================
  //  ADD BATTERY INTERFACE
  //===========================
  for (auto& batIIDM : voltageLevelIIDM.getBatteries()) {
    std::shared_ptr<BatteryInterfaceIIDM> battery = importBattery(batIIDM, countryStr);
    voltageLevel->addGenerator(battery);
    const string& batteryId = battery->getID();
    components_[batteryId] = battery;
    generatorComponents_[batteryId] = battery;
    battery->setVoltageLevelInterface(voltageLevel);
  }

  //===========================
  //  ADD LOAD INTERFACE
  //===========================
  for (auto& loadIIDM : voltageLevelIIDM.getLoads()) {
    std::shared_ptr<LoadInterfaceIIDM> load = importLoad(loadIIDM, countryStr);
    voltageLevel->addLoad(load);
    const string& loadId = load->getID();
    components_[loadId] = load;
    loadComponents_[loadId] = load;
    load->setVoltageLevelInterface(voltageLevel);
  }
  // =======================================
  //    ADD SHUNTCOMPENSATORS INTERFACE
  // =======================================
  for (auto& shuntCompensators : voltageLevelIIDM.getShuntCompensators()) {
    std::shared_ptr<ShuntCompensatorInterfaceIIDM> shunt = importShuntCompensator(shuntCompensators);
    voltageLevel->addShuntCompensator(shunt);
    components_[shunt->getID()] = shunt;
    shunt->setVoltageLevelInterface(voltageLevel);
  }

  //==============================
  //  ADD DANGLINGLINE INTERFACE
  //==============================
  for (auto& danglingLine : voltageLevelIIDM.getDanglingLines()) {
    std::shared_ptr<DYN::DanglingLineInterfaceIIDM> line = importDanglingLine(danglingLine);
    voltageLevel->addDanglingLine(line);
    components_[line->getID()] = line;
    line->setVoltageLevelInterface(voltageLevel);
  }

  //==========================================
  //  ADD STATICVARCOMPENSATOR INTERFACE
  //==========================================
  for (auto& staticVarCompensator : voltageLevelIIDM.getStaticVarCompensators()) {
    std::shared_ptr<DYN::StaticVarCompensatorInterfaceIIDM> svc = importStaticVarCompensator(staticVarCompensator);
    voltageLevel->addStaticVarCompensator(svc);
    components_[svc->getID()] = svc;
    svc->setVoltageLevelInterface(voltageLevel);
  }

  return voltageLevel;
}

std::unique_ptr<SwitchInterfaceIIDM>
DataInterfaceIIDM::importSwitch(powsybl::iidm::Switch& switchIIDM, const std::shared_ptr<BusInterface>& bus1,
  const std::shared_ptr<BusInterface>& bus2) const {
  std::unique_ptr<SwitchInterfaceIIDM> sw = DYN::make_unique<SwitchInterfaceIIDM>(switchIIDM);
  sw->setBusInterface1(bus1);
  sw->setBusInterface2(bus2);
  return sw;
}

std::unique_ptr<GeneratorInterfaceIIDM>
DataInterfaceIIDM::importGenerator(powsybl::iidm::Generator & generatorIIDM, const std::string& country) const {
  std::unique_ptr<GeneratorInterfaceIIDM> generator = DYN::make_unique<GeneratorInterfaceIIDM>(generatorIIDM);
  generator->setCountry(country);
  generator->setBusInterface(findBusInterface(generatorIIDM.getTerminal()));
  return generator;
}

std::unique_ptr<BatteryInterfaceIIDM>
DataInterfaceIIDM::importBattery(powsybl::iidm::Battery& batteryIIDM, const std::string& country) const {
  std::unique_ptr<BatteryInterfaceIIDM> battery = DYN::make_unique<BatteryInterfaceIIDM>(batteryIIDM);
  battery->setCountry(country);
  battery->setBusInterface(findBusInterface(batteryIIDM.getTerminal()));
  return battery;
}

std::unique_ptr<LoadInterfaceIIDM>
DataInterfaceIIDM::importLoad(powsybl::iidm::Load& loadIIDM, const std::string& country) const {
  std::unique_ptr<LoadInterfaceIIDM> load = DYN::make_unique<LoadInterfaceIIDM>(loadIIDM);
  load->setCountry(country);
  load->setBusInterface(findBusInterface(loadIIDM.getTerminal()));
  return load;
}

std::unique_ptr<ShuntCompensatorInterfaceIIDM>
DataInterfaceIIDM::importShuntCompensator(powsybl::iidm::ShuntCompensator& shuntIIDM) const {
  std::unique_ptr<ShuntCompensatorInterfaceIIDM> shunt = DYN::make_unique<ShuntCompensatorInterfaceIIDM>(shuntIIDM);
  shunt->setBusInterface(findBusInterface(shuntIIDM.getTerminal()));
  return shunt;
}

std::unique_ptr<DanglingLineInterfaceIIDM>
DataInterfaceIIDM::importDanglingLine(powsybl::iidm::DanglingLine& danglingLineIIDM) const {
  std::unique_ptr<DanglingLineInterfaceIIDM> danglingLine = DYN::make_unique<DanglingLineInterfaceIIDM>(danglingLineIIDM);
  danglingLine->setBusInterface(findBusInterface(danglingLineIIDM.getTerminal()));

  if (danglingLineIIDM.getCurrentLimits()) {
    powsybl::iidm::CurrentLimits& currentLimits = danglingLineIIDM.getCurrentLimits();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits.getPermanentLimit(),
                                                                                                      std::numeric_limits<unsigned long>::max());
      danglingLine->addCurrentLimitInterface(std::move(cLimit));
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
                                                                                                        currentLimit.getAcceptableDuration());
        danglingLine->addCurrentLimitInterface(std::move(cLimit));
      }
    }
  }
  return danglingLine;
}

std::unique_ptr<StaticVarCompensatorInterfaceIIDM>
DataInterfaceIIDM::importStaticVarCompensator(powsybl::iidm::StaticVarCompensator& svcIIDM) const {
  std::unique_ptr<StaticVarCompensatorInterfaceIIDM> svc = DYN::make_unique<StaticVarCompensatorInterfaceIIDM>(svcIIDM);
  svc->setBusInterface(findBusInterface(svcIIDM.getTerminal()));
  return svc;
}

std::unique_ptr<TwoWTransformerInterfaceIIDM>
DataInterfaceIIDM::importTwoWindingsTransformer(powsybl::iidm::TwoWindingsTransformer& twoWTfoIIDM) const {
  std::unique_ptr<TwoWTransformerInterfaceIIDM> twoWTfo = DYN::make_unique<TwoWTransformerInterfaceIIDM>(twoWTfoIIDM);

  // add phase tapChanger and steps if exists
  if (twoWTfoIIDM.hasPhaseTapChanger()) {
    std::unique_ptr<PhaseTapChangerInterfaceIIDM> tapChanger = DYN::make_unique<PhaseTapChangerInterfaceIIDM>(twoWTfoIIDM.getPhaseTapChanger());
    twoWTfo->setPhaseTapChanger(std::move(tapChanger));
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
    std::unique_ptr<RatioTapChangerInterfaceIIDM> tapChanger = DYN::make_unique<RatioTapChangerInterfaceIIDM>(twoWTfoIIDM.getRatioTapChanger(), side);
    twoWTfo->setRatioTapChanger(std::move(tapChanger));
  }

  twoWTfo->setBusInterface1(findBusInterface(twoWTfoIIDM.getTerminal1()));
  twoWTfo->setVoltageLevelInterface1(findVoltageLevelInterface(twoWTfoIIDM.getTerminal1().getVoltageLevel().getId()));

  twoWTfo->setBusInterface2(findBusInterface(twoWTfoIIDM.getTerminal2()));
  twoWTfo->setVoltageLevelInterface2(findVoltageLevelInterface(twoWTfoIIDM.getTerminal2().getVoltageLevel().getId()));

  if (twoWTfoIIDM.getCurrentLimits1()) {
    powsybl::iidm::CurrentLimits& currentLimits = twoWTfoIIDM.getCurrentLimits1();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits.getPermanentLimit(),
                                                                                                      std::numeric_limits<unsigned long>::max());
      twoWTfo->addCurrentLimitInterface1(std::move(cLimit));
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
                                                                                                        currentLimit.getAcceptableDuration());
        twoWTfo->addCurrentLimitInterface1(std::move(cLimit));
      }
    }
  }

  if (twoWTfoIIDM.getCurrentLimits2()) {
    powsybl::iidm::CurrentLimits& currentLimits = twoWTfoIIDM.getCurrentLimits2();

    // permanent limit
    if (!std::isnan(currentLimits.getPermanentLimit())) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits.getPermanentLimit(),
                                                                                                      std::numeric_limits<unsigned long>::max());
      twoWTfo->addCurrentLimitInterface2(std::move(cLimit));
    }

    // temporary limit
    for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
                                                                                                        currentLimit.getAcceptableDuration());
        twoWTfo->addCurrentLimitInterface2(std::move(cLimit));
      }
    }
  }
  return twoWTfo;
}

void
DataInterfaceIIDM::convertThreeWindingsTransformers(powsybl::iidm::ThreeWindingsTransformer& threeWindingTransformer) {
  const string fictVLId = threeWindingTransformer.getId() + "_FictVL";
  const string fictBusId = threeWindingTransformer.getId() + "_FictBUS";
  string countryStr;
  if (threeWindingTransformer.getSubstation().getCountry())
    countryStr = powsybl::iidm::getCountryName(threeWindingTransformer.getSubstation().getCountry().get());

  std::vector<stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg> > legs;
  legs.emplace_back(stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(threeWindingTransformer.getLeg1()));
  legs.emplace_back(stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(threeWindingTransformer.getLeg2()));
  legs.emplace_back(stdcxx::Reference<powsybl::iidm::ThreeWindingsTransformer::Leg>(threeWindingTransformer.getLeg3()));

  std::shared_ptr<VoltageLevelInterface> vl = std::make_shared<FictVoltageLevelInterfaceIIDM>(fictVLId, threeWindingTransformer.getRatedU0(), countryStr);
  network_->addVoltageLevel(vl);
  voltageLevels_[vl->getID()] = vl;
  std::shared_ptr<BusInterface> fictBus = std::make_shared<FictBusInterfaceIIDM>(fictBusId, threeWindingTransformer.getRatedU0(), countryStr);
  vl->addBus(fictBus);
  components_[fictBus->getID()] = fictBus;
  busComponents_[fictBus->getID()] = fictBus;

  int legCount = 1;
  const bool initialConnected1 = true;
  const double VNom1 = threeWindingTransformer.getRatedU0();
  const double ratedU1 = threeWindingTransformer.getRatedU0();

  auto libPath = IIDMExtensions::findLibraryPath();
  auto activeSeasonExtensionDef = IIDMExtensions::getExtension<ActiveSeasonIIDMExtension>(libPath.generic_string());
  auto activeSeasonExtension = std::get<IIDMExtensions::CREATE_FUNCTION>(activeSeasonExtensionDef)(threeWindingTransformer);
  auto destroyActiveSeasonExtension = std::get<IIDMExtensions::DESTROY_FUNCTION>(activeSeasonExtensionDef);
  const string activeSeason = activeSeasonExtension ? activeSeasonExtension->getValue() : std::string("UNDEFINED");
  destroyActiveSeasonExtension(activeSeasonExtension);

  for (auto& leg : legs) {
    string TwoWTransfId = threeWindingTransformer.getId() + "_" + std::to_string(legCount);
    // We consider the fictitious transformer always connected on the fictitious bus
    std::shared_ptr<TwoWTransformerInterface> fictTwoWTransf = std::make_shared<FictTwoWTransformerInterfaceIIDM>(TwoWTransfId,
                                                                                                                  leg,
                                                                                                                  initialConnected1,
                                                                                                                  VNom1,
                                                                                                                  ratedU1,
                                                                                                                  activeSeason);
    fictTwoWTransf->setBusInterface1(fictBus);
    fictTwoWTransf->setBusInterface2(findBusInterface(leg.get().getTerminal()));
    fictTwoWTransf->setVoltageLevelInterface1(vl);
    fictTwoWTransf->setVoltageLevelInterface2(findVoltageLevelInterface(leg.get().getTerminal().getVoltageLevel().getId()));
    // add phase tapChanger and steps if exists
    if (leg.get().hasPhaseTapChanger()) {
      std::unique_ptr<PhaseTapChangerInterfaceIIDM> tapChanger = DYN::make_unique<PhaseTapChangerInterfaceIIDM>(leg.get().getPhaseTapChanger());
      fictTwoWTransf->setPhaseTapChanger(std::move(tapChanger));
    }
    // add ratio tapChanger and steps if exists. It is always referring to side TWO as it is the side coming from
    // the orginal ThreeWindingTransformer
    if (leg.get().hasRatioTapChanger()) {
      string side;
      if (leg.get().getRatioTapChanger().getRegulationTerminal() &&
          stdcxx::areSame(leg.get().getTerminal(), leg.get().getRatioTapChanger().getRegulationTerminal().get())) {
        side = "TWO";
        std::unique_ptr<RatioTapChangerInterfaceIIDM> tapChanger = DYN::make_unique<RatioTapChangerInterfaceIIDM>(leg.get().getRatioTapChanger(), side);
        fictTwoWTransf->setRatioTapChanger(std::move(tapChanger));
      }
    }
    if (leg.get().getCurrentLimits()) {
      powsybl::iidm::CurrentLimits& currentLimits = leg.get().getCurrentLimits().get();
      // permanent limit
      if (!std::isnan(currentLimits.getPermanentLimit())) {
        std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits.getPermanentLimit(),
                                                                                                        std::numeric_limits<unsigned long>::max());
        fictTwoWTransf->addCurrentLimitInterface2(std::move(cLimit));
      }
      // temporary limit
      for (auto& currentLimit : currentLimits.getTemporaryLimits()) {
        if (!currentLimit.isFictitious()) {
          std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
                                                                                                          currentLimit.getAcceptableDuration());
          fictTwoWTransf->addCurrentLimitInterface2(std::move(cLimit));
        }
      }
    }
    network_->addTwoWTransformer(fictTwoWTransf);
    components_[fictTwoWTransf->getID()] = fictTwoWTransf;
    fict2wtIDto3wtID_.insert({fictTwoWTransf->getID(), threeWindingTransformer.getId()});
    legCount++;
  }
}

std::unique_ptr<LineInterfaceIIDM>
DataInterfaceIIDM::importLine(powsybl::iidm::Line& lineIIDM) const {
  std::unique_ptr<LineInterfaceIIDM> line = DYN::make_unique<LineInterfaceIIDM>(lineIIDM);
  line->setBusInterface1(findBusInterface(lineIIDM.getTerminal1()));
  line->setVoltageLevelInterface1(findVoltageLevelInterface(lineIIDM.getTerminal1().getVoltageLevel().getId()));
  line->setBusInterface2(findBusInterface(lineIIDM.getTerminal2()));
  line->setVoltageLevelInterface2(findVoltageLevelInterface(lineIIDM.getTerminal2().getVoltageLevel().getId()));

  // permanent limit on side 1
  if (lineIIDM.getCurrentLimits1()) {
    powsybl::iidm::CurrentLimits& currentLimits1 = lineIIDM.getCurrentLimits1().get();
    if (!std::isnan(currentLimits1.getPermanentLimit())) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits1.getPermanentLimit(),
                                                                                                      std::numeric_limits<unsigned long>::max());
      line->addCurrentLimitInterface1(std::move(cLimit));
    }
    // temporary limit on side 1
    for (auto& currentLimit : currentLimits1.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
                                                                                                        currentLimit.getAcceptableDuration());
        line->addCurrentLimitInterface1(std::move(cLimit));
      }
    }
  }

  if (lineIIDM.getCurrentLimits2()) {
    // permanent limit on side 2
    powsybl::iidm::CurrentLimits& currentLimits2 = lineIIDM.getCurrentLimits2().get();
    if (!std::isnan(currentLimits2.getPermanentLimit())) {
      std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimits2.getPermanentLimit(),
                                                                                                      std::numeric_limits<unsigned long>::max());
      line->addCurrentLimitInterface2(std::move(cLimit));
    }
    // temporary limit on side 12
    for (auto& currentLimit : currentLimits2.getTemporaryLimits()) {
      if (!currentLimit.isFictitious()) {
        std::unique_ptr<CurrentLimitInterfaceIIDM> cLimit = DYN::make_unique<CurrentLimitInterfaceIIDM>(currentLimit.getValue(),
                                                                                                        currentLimit.getAcceptableDuration());
        line->addCurrentLimitInterface2(std::move(cLimit));
      }
    }
  }
  return line;
}

std::unique_ptr<VscConverterInterfaceIIDM>
DataInterfaceIIDM::importVscConverter(powsybl::iidm::VscConverterStation& vscIIDM) const {
  std::unique_ptr<VscConverterInterfaceIIDM> vsc = DYN::make_unique<VscConverterInterfaceIIDM>(vscIIDM);
  vsc->setBusInterface(findBusInterface(vscIIDM.getTerminal()));
  return vsc;
}

std::unique_ptr<LccConverterInterfaceIIDM>
DataInterfaceIIDM::importLccConverter(powsybl::iidm::LccConverterStation& lccIIDM) const {
  std::unique_ptr<LccConverterInterfaceIIDM> lcc = DYN::make_unique<LccConverterInterfaceIIDM>(lccIIDM);
  lcc->setBusInterface(findBusInterface(lccIIDM.getTerminal()));
  return lcc;
}

std::unique_ptr<HvdcLineInterfaceIIDM>
DataInterfaceIIDM::importHvdcLine(powsybl::iidm::HvdcLine& hvdcLineIIDM) const {
  std::shared_ptr<ConverterInterface> conv1 = std::dynamic_pointer_cast<ConverterInterface>(findComponent(hvdcLineIIDM.getConverterStation1().get().getId()));
  std::shared_ptr<ConverterInterface> conv2 = std::dynamic_pointer_cast<ConverterInterface>(findComponent(hvdcLineIIDM.getConverterStation2().get().getId()));

  std::unique_ptr<HvdcLineInterfaceIIDM> hvdcLine = DYN::make_unique<HvdcLineInterfaceIIDM>(hvdcLineIIDM, conv1, conv2);
  return hvdcLine;
}

shared_ptr<NetworkInterface>
DataInterfaceIIDM::getNetwork() const {
  return network_;
}

std::shared_ptr<BusInterface>
DataInterfaceIIDM::findBusInterface(const powsybl::iidm::Terminal& terminal) const {
  if (terminal.getVoltageLevel().getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    return findNodeBreakerBusInterface(terminal.getVoltageLevel(), static_cast<int>(terminal.getNodeBreakerView().getNode()));
  } else {
    return findBusBreakerBusInterface(terminal.getBusBreakerView().getConnectableBus().get());
  }
}

std::shared_ptr<BusInterface>
DataInterfaceIIDM::findBusBreakerBusInterface(const powsybl::iidm::Bus& bus) const {
  string id = bus.getId();
  if (bus.getVoltageLevel().getTopologyKind() == powsybl::iidm::TopologyKind::NODE_BREAKER) {
    throw DYNError(Error::MODELER, UnknownBus, id);
  }
  const auto iter = busComponents_.find(id);
  if (iter != busComponents_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownBus, id);
}


std::shared_ptr<CalculatedBusInterfaceIIDM>
DataInterfaceIIDM::findNodeBreakerBusInterface(const powsybl::iidm::VoltageLevel& vl, const int node) const {
  if (vl.getTopologyKind() == powsybl::iidm::TopologyKind::BUS_BREAKER) {
    throw DYNError(Error::MODELER, UnknownCalculatedBus, vl.getId(), node);
  }
  const auto iter = calculatedBusComponents_.find(vl.getId());
  if (iter == calculatedBusComponents_.end())
    throw DYNError(Error::MODELER, UnknownCalculatedBus, vl.getId());

  vector<std::shared_ptr<CalculatedBusInterfaceIIDM> > buses = iter->second;
  for (const auto& bus : buses) {
    if (bus->hasNode(node))
      return bus;
  }
  throw DYNError(Error::MODELER, UnknownCalculatedBus, vl.getId(), node);
}

std::shared_ptr<VoltageLevelInterface>
DataInterfaceIIDM::findVoltageLevelInterface(const string& id) const {
  const auto iter = voltageLevels_.find(id);
  if (iter != voltageLevels_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownVoltageLevel, id);
}

std::shared_ptr<BusInterface>
DataInterfaceIIDM::findCalculatedBusInterface(const string& voltageLevelId, const string& bbsId) const {
  const auto iter = calculatedBusComponents_.find(voltageLevelId);
  if (iter != calculatedBusComponents_.end()) {
    vector<std::shared_ptr<CalculatedBusInterfaceIIDM> > buses = iter->second;
    for (const auto& bus : buses) {
      if (bus->hasBusBarSection(bbsId))
        return bus;
    }
  }
  return std::shared_ptr<BusInterface>();
}

const std::shared_ptr<ComponentInterface>&
DataInterfaceIIDM::findComponent(const std::string& id) const {
  const auto iter = components_.find(id);
  if (iter != components_.end())
    return iter->second;
  else
    throw DYNError(Error::MODELER, UnknownStaticComponent, id);
}

std::shared_ptr<ComponentInterface>&
DataInterfaceIIDM::findComponent(const std::string& id) {
  const auto iter = components_.find(id);
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
  if (staticId.empty())
    throw DYNError(Error::MODELER, WrongReferenceId, staticId);

  findComponent(staticId)->setReference(componentVar, modelId, modelVar);
}

void
DataInterfaceIIDM::setDynamicModel(const string& componentId, const shared_ptr<SubModel>& model) {
  findComponent(componentId)->setModelDyn(model);
}

void
DataInterfaceIIDM::setModelNetwork(const shared_ptr<SubModel>& model) {
  for (const auto& componentPair : components_)
    componentPair.second->setModelDyn(model);
}

void
DataInterfaceIIDM::mapConnections() {
  for (const auto& line : network_->getLines()) {
    if (line->hasDynamicModel()) {
      line->getBusInterface1()->hasConnection(true);
      line->getBusInterface2()->hasConnection(true);
    }
  }

  for (const auto& twoWtfo : network_->getTwoWTransformers()) {
    if (twoWtfo->hasDynamicModel()) {
      twoWtfo->getBusInterface1()->hasConnection(true);
      twoWtfo->getBusInterface2()->hasConnection(true);
    }
  }

  for (const auto& hvdcLine : network_->getHvdcLines()) {
    if (hvdcLine->hasDynamicModel()) {
      hvdcLine->getConverter1()->getBusInterface()->hasConnection(true);
      hvdcLine->getConverter2()->getBusInterface()->hasConnection(true);
    }
  }

  for (const auto& voltageLevel : network_->getVoltageLevels())
    voltageLevel->mapConnections();
}

void
DataInterfaceIIDM::importStaticParameters() {
  for (const auto& componentPair : components_)
    componentPair.second->importStaticParameters();
}

void
DataInterfaceIIDM::getStateVariableReference() {
  for (const auto& componentPair : components_)
    componentPair.second->getStateVariableReference();
}

void
DataInterfaceIIDM::updateFromModel(bool filterForCriteriaCheck) {
  for (const auto& componentPair : components_)
    componentPair.second->updateFromModel(filterForCriteriaCheck);
}

void
DataInterfaceIIDM::exportStateVariables() {
  const bool filterForCriteriaCheck = false;
  for (const auto& componentPair : components_) {
    const auto& component = componentPair.second;
    component->updateFromModel(filterForCriteriaCheck);
    component->exportStateVariables();
  }

  // loop to update switch state due to topology analysis
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  for (const auto& voltageLevelPair : voltageLevels_)
    voltageLevelPair.second->exportSwitchesState();
}

#ifdef _DEBUG_
void
DataInterfaceIIDM::exportStateVariablesNoReadFromModel() const {
  for (const auto& componentPair : components_)
    componentPair.second->exportStateVariables();

  // loop to update switch state due to topology analysis
  // should be removed once a solution has been found to propagate switches (de)connection
  // following component (de)connection (only Modelica models)
  for (const auto& voltageLevelPair : voltageLevels_)
    voltageLevelPair.second->exportSwitchesState();
}
#endif

std::shared_ptr<vector<std::shared_ptr<ComponentInterface> > >
DataInterfaceIIDM::findConnectedComponents() {
  std::shared_ptr<vector<std::shared_ptr<ComponentInterface> > > connectedComponents(new vector<std::shared_ptr<ComponentInterface> >());
  for (auto& component : components_) {
    if (component.second->isPartiallyConnected()) {
      connectedComponents->push_back(component.second);
    }
  }
  return connectedComponents;
}

std::unique_ptr<lostEquipments::LostEquipmentsCollection>
DataInterfaceIIDM::findLostEquipments(const std::shared_ptr<vector<std::shared_ptr<ComponentInterface> > >& connectedComponents) {
  std::unique_ptr<lostEquipments::LostEquipmentsCollection> lostEquipments = lostEquipments::LostEquipmentsCollectionFactory::newInstance();
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
DataInterfaceIIDM::configureCriteria(const std::shared_ptr<CriteriaCollection>& criteria) {
  configureBusCriteria(criteria);
  configureLoadCriteria(criteria);
  configureGeneratorCriteria(criteria);
}

void
DataInterfaceIIDM::configureBusCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria) {
  for (const auto& busCriteria : criteria->getBusCriteria()) {
    if (!BusCriteria::criteriaEligibleForBus(busCriteria->getParams())) continue;
    std::unique_ptr<BusCriteria> dynCriteria = DYN::make_unique<BusCriteria>(busCriteria->getParams());
    const auto& componentIds = busCriteria->getComponentIds();
    if (!componentIds.empty()) {
      for (const auto& componentId : componentIds) {
        std::shared_ptr<BusInterface> bus;
        if (!componentId->getVoltageLevelId().empty()) {
          bus = findCalculatedBusInterface(componentId->getVoltageLevelId(), componentId->getId());
          if (!bus) {
            Trace::warn() << DYNLog(CalculatedBusNotFound, componentId->getVoltageLevelId(), componentId->getId()) << Trace::endline;
            continue;
          }
        } else {
          std::unordered_map<std::string, std::shared_ptr<ComponentInterface> >::const_iterator busItfIter = components_.find(componentId->getId());
          if (busItfIter != components_.end()) {
            const std::shared_ptr<ComponentInterface>& cmp = busItfIter->second;
            if (cmp->getType() != ComponentInterface::BUS) {
              Trace::warn() << DYNLog(WrongComponentType, componentId->getId(), "bus") << Trace::endline;
              continue;
            }
            bus = dynamic_pointer_cast<BusInterface>(cmp);
            assert(bus);
          } else {
            Trace::warn() << DYNLog(ComponentNotFound, componentId->getId()) << Trace::endline;
            continue;
          }
        }
        if (busCriteria->hasCountryFilter()) {
          const std::shared_ptr<BusInterfaceIIDM> busIIDM = dynamic_pointer_cast<BusInterfaceIIDM>(bus);
          if (busIIDM && !busIIDM->getCountry().empty() && !busCriteria->containsCountry(busIIDM->getCountry()))
            continue;
        }
        dynCriteria->addBus(bus);
      }
    } else {
      for (const auto& busComponent : busComponents_) {
        if (busCriteria->hasCountryFilter()) {
          const std::shared_ptr<BusInterfaceIIDM> bus = dynamic_pointer_cast<BusInterfaceIIDM>(busComponent.second);
          if (!bus->getCountry().empty() && !busCriteria->containsCountry(bus->getCountry()))
            continue;
        }
        dynCriteria->addBus(busComponent.second);
      }
    }
    if (!dynCriteria->empty()) {
      criteria_.push_back(std::move(dynCriteria));
    }
  }
}

void
DataInterfaceIIDM::configureLoadCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria) {
  for (const auto& loadCriteria : criteria->getLoadCriteria()) {
    if (!LoadCriteria::criteriaEligibleForLoad(loadCriteria->getParams())) continue;
    std::unique_ptr<LoadCriteria> dynCriteria = DYN::make_unique<LoadCriteria>(loadCriteria->getParams());
    const auto& componentIds = loadCriteria->getComponentIds();
    if (!componentIds.empty()) {
      for (const auto& componentId : componentIds) {
        const auto loadItfIter = components_.find(componentId->getId());
        if (loadItfIter != components_.end()) {
          const std::shared_ptr<ComponentInterface>& cmp = loadItfIter->second;
          if (cmp->getType() != ComponentInterface::LOAD) {
            Trace::warn() << DYNLog(WrongComponentType, componentId->getId(), "load") << Trace::endline;
            continue;
          }
          if (loadCriteria->hasCountryFilter()) {
            const std::shared_ptr<LoadInterfaceIIDM> load = dynamic_pointer_cast<LoadInterfaceIIDM>(cmp);
            if (!load->getCountry().empty() && !loadCriteria->containsCountry(load->getCountry()))
              continue;
          }
          std::shared_ptr<LoadInterface> load = std::dynamic_pointer_cast<LoadInterface>(cmp);
          assert(load);
          dynCriteria->addLoad(load);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, componentId->getId()) << Trace::endline;
        }
      }
    } else {
      for (const auto& loadComponentPair : loadComponents_) {
        const auto& loadComponent = loadComponentPair.second;
        if (loadCriteria->hasCountryFilter() && !loadComponent->getCountry().empty() && !loadCriteria->containsCountry(loadComponent->getCountry()))
            continue;
        dynCriteria->addLoad(loadComponent);
      }
    }
    if (!dynCriteria->empty()) {
      criteria_.push_back(std::move(dynCriteria));
    }
  }
}

void
DataInterfaceIIDM::configureGeneratorCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria) {
  for (const auto& generatorCriteria : criteria->getGeneratorCriteria()) {
    if (!GeneratorCriteria::criteriaEligibleForGenerator(generatorCriteria->getParams())) continue;
    std::unique_ptr<GeneratorCriteria> dynCriteria = DYN::make_unique<GeneratorCriteria>(generatorCriteria->getParams());
    const auto& componentIds = generatorCriteria->getComponentIds();
    if (!componentIds.empty()) {
      for (const auto& componentId : componentIds) {
        const auto generatorItfIter = components_.find(componentId->getId());
        if (generatorItfIter != components_.end()) {
          const std::shared_ptr<ComponentInterface>& cmp = generatorItfIter->second;
          if (cmp->getType() != ComponentInterface::GENERATOR) {
            Trace::warn() << DYNLog(WrongComponentType, componentId->getId(), "generator") << Trace::endline;
            continue;
          }
          if (generatorCriteria->hasCountryFilter()) {
            const std::shared_ptr<GeneratorInterfaceIIDM> gen = dynamic_pointer_cast<GeneratorInterfaceIIDM>(cmp);
            if (!gen->getCountry().empty() && !generatorCriteria->containsCountry(gen->getCountry()))
              continue;
          }
          const std::shared_ptr<GeneratorInterface> gen = dynamic_pointer_cast<GeneratorInterface>(cmp);
          assert(gen);
          dynCriteria->addGenerator(gen);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, componentId->getId()) << Trace::endline;
        }
      }
    } else {
      for (const auto& generatorComponentPair : generatorComponents_) {
        const auto& generatorComponent = generatorComponentPair.second;
        const std::shared_ptr<GeneratorInterfaceIIDM> gen = dynamic_pointer_cast<GeneratorInterfaceIIDM>(generatorComponent);
        const std::shared_ptr<BatteryInterfaceIIDM> bat = dynamic_pointer_cast<BatteryInterfaceIIDM>(generatorComponent);
        if (gen && generatorCriteria->hasCountryFilter() && !gen->getCountry().empty() && !generatorCriteria->containsCountry(gen->getCountry()))
            continue;
        if (bat && generatorCriteria->hasCountryFilter() && !bat->getCountry().empty() && !generatorCriteria->containsCountry(bat->getCountry()))
            continue;
        dynCriteria->addGenerator(generatorComponent);
      }
    }
    if (!dynCriteria->empty()) {
      criteria_.push_back(std::move(dynCriteria));
    }
  }
}

bool
DataInterfaceIIDM::checkCriteria(const double t, const bool finalStep) {
#if defined(_DEBUG_)
  Timer timer("DataInterfaceIIDM::checkCriteria");
#endif
#ifdef _DEBUG_
  for (const auto& component : components_)
    component.second->enableCheckStateVariable();

#endif
  bool criteriaOk = true;
  for (const auto& criteria : criteria_)
    criteriaOk &= criteria->checkCriteria(t, finalStep, timeline_);

#ifdef _DEBUG_
  for (const auto& component : components_)
    component.second->disableCheckStateVariable();

#endif
  return criteriaOk;
}

void
DataInterfaceIIDM::getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const {
  for (const auto& criteria : criteria_) {
    const std::vector<std::pair<double, std::string> >& ids = criteria->getFailingCriteria();
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
